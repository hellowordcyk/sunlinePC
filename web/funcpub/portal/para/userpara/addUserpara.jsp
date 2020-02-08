<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-userpara' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='addUserpara' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent">
		<div id="content" class="pageFormContent" style="margin-left:10px;">
			<table width="100%" >
				<tr>
					<td>参数名称：</td>
					<td><sc:text name="paraname" validate="required"/><span class="redmust">*</span></td>
					<td>区域编码：</td>
					<td>
						<select id="addUserparaAreaSelect" name="areano" validate="required" onchange="initDateArea()">
						</select>
						<span class="redmust">*</span>
					</td>
					<td><input type="button" class="button" onclick="checkAndSubmit(this)" value="提交"/></td>
				</tr>
				<tr>
					<td>备注：</td>
					<td><sc:textarea name="remark" rows="1" cols="20" style="resize:none;"/></td>
					<td>状态</td>
					<td><sc:select name="status" type="dict" key="pams,inptst"  includeTitle="false" default="1"/></td>
					<td><input type="button" class="button" onclick="addDateArea()" value="增加区间"/></td>
				</tr>
			</table>
			
		</div>
	</div>
</form>

<script>
var dataAreaid = 1;
var dataAreahtml1 = "";
var dataAreahtml2 = "";
$(function(){
	initSelect();
});
function initSelect(){
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
	    + "&oprID=<sc:fmt value='funcpub-userpara' type='crypto'/>"
	    + "&actions=<sc:fmt value='getAreaSelect' type='crypto'/>";
	$.ajax({
		type:'POST',
		url: url,
		dataType:'xml',
		success:function(data){
			$(data).find('DataPacket Response Data Record').each(function(i){
				var areaname=$(this).children("areaname").text();
				var areano=$(this).children("areano").text();
				$("#addUserparaAreaSelect",$.pdialog.getCurrent()).append("<option value=\""+areano+"\">"+areaname+"</option>");
			});
			initUI($("#addUserparaAreaSelect",$.pdialog.getCurrent()));
			initDateArea();
		}
	}); 
}
function deleteDateArea(id){
	$("#"+id,$.pdialog.getCurrent()).remove();
}
function initDateArea(){
	$("div[id^=dataArea]",$.pdialog.getCurrent()).remove();
	dataAreaid = 1;
	var areano = $("#addUserparaAreaSelect",$.pdialog.getCurrent()).val();
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
		    + "&oprID=<sc:fmt value='funcpub-userpara' type='crypto'/>"
		    + "&actions=<sc:fmt value='getRuleDept' type='crypto'/>"
			+ "&areano="+areano;
	$.ajax({
		type:'POST',
		url: url,
		dataType:'xml',
		success:function(data){
			var id = "dataArea"+dataAreaid;
			var deptcount = $(data).find('DataPacket Response Data Record').length;
			dataAreahtml1 = '<div id="'+id+'" style="width:48%;float:left;margin:5px;margin-top:20px;">'
				 +'<div style="border:solid #C0C0C0 1px;">'
				 +'<table class="list" width="100%" >'
				 +'<tr><td width="20%">起止日期</td><td width="30%"><input type="text" class="date" name="'+id+'_enabledate" style="width:85%;" validate="required"/><span class="redmust">*</span></td>'
				 +'<td width="30%"><input type="text" class="date" name="'+id+'_disenabledate" style="width:85%;" validate="required"/><span class="redmust">*</span></td>';
			var countTd = '<td><sc:hidden name="areacount" value="'+dataAreaid+'"/></td>'; 
			dataAreahtml2 = '</tr></table></div><div style="border:solid #C0C0C0 1px;margin-top:5px;">'
				 +'<table class="list"  width="100%" ><thead><tr ><td>机构</td><td>参数值</td></tr></thead><tbody>'
				 +'<sc:hidden name="deptcount" value="'+deptcount+'"/>';	
			$(data).find('DataPacket Response Data Record').each(function(index,e){
				var deptid=$(this).children("deptid").text();
				var deptname=$(this).children("deptname").text();
				dataAreahtml2 += '<tr><td width="40%">'+deptname+'</td>';
				dataAreahtml2 += '<td><sc:hidden name="'+id+'_deptid'+(index+1)+'" value="'+deptid+'"/>';
				if(index == 0){
					dataAreahtml2 += '<sc:text name="'+id+'_paravalue'+(index+1)+'" validate="required"/><span class="redmust">*</span></td></tr>';
				}else{
					dataAreahtml2 += '<sc:text name="'+id+'_paravalue'+(index+1)+'" /></td></tr>';
				}
			});
			dataAreahtml2 += '</tbody></table></div></div>';
			$("#content",$.pdialog.getCurrent()).append(dataAreahtml1+countTd+dataAreahtml2);
			initUI($("#"+id,$.pdialog.getCurrent())); 
		}
	}); 
}

function addDateArea(){
	dataAreaid++;
	var id = "dataArea"+dataAreaid;
	var html = dataAreahtml1
			+ '<td width="25%"><a class="btnDel" href="javascript:void(0)" onclick=\'deleteDateArea("'+id+'")\'>删除区间</a></td>'
			+ '<td><sc:hidden name="areacount" value="'+dataAreaid+'"/></td>'
			+ dataAreahtml2;
	html = html.replace(/dataArea1/g,id);
	$("#content",$.pdialog.getCurrent()).append(html);
	initUI($("#content",$.pdialog.getCurrent())); 

}
function checkAndSubmit(event){
	var dateAreaArray = $(event).closest("form").find("div[id^='dataArea']");
	var startDateArray = new Array();
	var endDateArray = new Array();
	try{
		$(dateAreaArray).each(function(index){
			var startdate = $(this).find("input[name$='enabledate']").val();
			var enddate = $(this).find("input[name$='disenabledate']").val();	
			var sdate = new Date(startdate.replace(/-/g,"/"));
		    var edate = new Date(enddate.replace(/-/g,"/"));
			if("" == startdate || null == startdate){
				throw "第"+(index+1)+"个时间区间,生效日期不能为空";
			}
			if("" == enddate || null == enddate){
				throw"第"+(index+1)+"个时间区间,失效日期不能为空";
			}
			if(sdate-edate>0){
				throw "第"+(index+1)+"个时间区间,失效日期不能小于生效日期";
		    }
			
			var reg =  /(([1-9]+[0-9]*|0)(\\.[\\d]{1,2})?)/;
			var valueArray = $(this).find("input[name*='paravalue']");
			$(valueArray).each(function(i){
				var value = $(this).val();
				if( value!=null && value!="" && !reg.test(value)){
			    	throw "第"+(index+1)+"个时间区间,第"+(i+1)+"行,"+value+"不是一个合理的数字,请输入一个最多精确到小数点后2位的数字!";
			    }
			});
			startDateArray.push(sdate);
			endDateArray.push(edate);
		});
	}catch (e){
		alertMsg.error(e);
		return;
	}
	
	//有多行时,验证生效日期、失效日期是否交叉、是否连续
	if(startDateArray.length>1){
		//将生效日期、失效日期排序
		for(var i=0;i<startDateArray.length-1;i++){
			for(var j=i+1;j<startDateArray.length;j++){
			    var sdate = startDateArray[i];
			    var edate = startDateArray[j];
			    if(sdate-edate>0) {
			    	var sdateMid = startDateArray[i];
			    	startDateArray[i] = startDateArray[j];
			    	startDateArray[j] = sdateMid;
			    	
					var edateMid = endDateArray[i];
					endDateArray[i] = endDateArray[j];
					endDateArray[j] = edateMid;
			    }	
			}	
		}
		//验证
		for(var i=0;i<startDateArray.length-1;i++){    
		    var edate = endDateArray[i]; //上一日期段的失效日期
		    var sdate = startDateArray[i+1];  //下一日期段的生效日期
			var sub = sdate-edate;			   //单位为毫秒
			if(sub != "86400000"){
				alertMsg.error("各个日期段之间必须连续,下一日期段的生效日期必须是上一日期段的失效日期的后一天");
				return;
			}	
		}	
	}
	$(event).closest("form").submit();
}
</script>