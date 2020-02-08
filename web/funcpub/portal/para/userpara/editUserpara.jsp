<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-userpara' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updateUserpara' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent">
		<div id="content" class="pageFormContent" style="margin-left:10px;">
			<table cellpadding="0" cellspacing="0" width="100%" >
				<tr>
					<td>参数名称：</td>
					<td>
						<sc:hidden name="paracode" index="1"/>
						<sc:text name="paraname" index="1" readonly="true" validate="required"/><span class="redmust">*</span>
					</td>
					<td>区域编码：</td>
					<td>
						<sc:hidden name="areano" index="1"/>
						<sc:select name="areano" index="1" type="area" attributesText='disabled="disabled"' />
						<span class="redmust">*</span>
					</td>
					<td><input type="button" class="button" onclick="checkAndSubmit(this)" value="提交"/></td>
				</tr>
				<tr>
					<td>备注：</td>
					<td><sc:textarea name="remark" rows="1" index="1" cols="20" style="resize:none;"/></td>
					<td>状态</td>
					<td><sc:select name="status" type="dict" key="pams,inptst"  includeTitle="false" default="1"/></td>
					<td>
						<div class="panelBar">
							<ul class="toolBar">
								<li><a class="add" onclick="addDateArea()"><span>增加区间</span></a></li>
							</ul>
						</div>
					</td>
				</tr>
			</table>
			<c:forEach var="dateArea" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1}"  varStatus="dateAreaStatus">
				<c:if test="${dateAreaStatus.last}">
					<sc:hidden id="dataAreaid" name="dataAreaid" value = "${dateAreaStatus.count}" />
				</c:if>
				<div id="dataArea${dateAreaStatus.count}" style="width:48%;float:left;margin:5px;margin-top:20px;">
					<div style="border:solid #C0C0C0 1px;">
						<table class="list" width="100%" >
							<tr>
								<td width="20%">起止日期</td>
								<td width="30%"><sc:date name="dataArea${dateAreaStatus.count}_enabledate"  value="${dateArea.enabledate}" style="width:85%;" validate="required"/><span class="redmust">*</span></td>
								<td width="30%"><sc:date name="dataArea${dateAreaStatus.count}_disenabledate" value="${dateArea.disenabledate}" style="width:85%;" validate="required"/><span class="redmust">*</span></td>
								<td><sc:hidden name="areacount" value="${dateAreaStatus.count}"/></td>
								<c:if test="${dateAreaStatus.count != 1}">
									<td width="25%"><a class="btnDel" href="javascript:void(0)" onclick='deleteDateArea("dataArea${dateAreaStatus.count}")'>删除区间</a></td>
								</c:if>
							</tr>
						</table>
					</div>
					<div style="border:solid #C0C0C0 1px;margin-top:5px;">
						<table class="list"  width="100%" >
							<thead>
								<tr >
									<td>机构</td>
									<td>参数值</td>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="dept" items="${jrafrpu.rspPkg.rspRcdDataMapsResults2}"  varStatus="deptStatus">
									<c:if test="${deptStatus.last}">
										<sc:hidden name = "deptcount" value = "${deptStatus.count}" />
									</c:if>
									<tr>
										<td width="40%">${dept.deptname}<sc:hidden name="dataArea${dateAreaStatus.count}_deptid${deptStatus.count}" value="${dept.deptid}"/></td>
										<%boolean flag = true; %>
										<c:forEach var="detail" items="${jrafrpu.rspPkg.rspRcdDataMapsResults3}"  varStatus="detailStatus">
											<c:if test="${dateArea.enabledate == detail.enabledate && dateArea.disenabledate == detail.disenabledate && detail.orgno == dept.deptid}">
												<%flag = false; %>
												<c:if test="${deptStatus.count == 1}">
													<td><sc:text name="dataArea${dateAreaStatus.count}_paravalue${deptStatus.count}" value="${detail.paravalue}" validate="required"/><span class="redmust">*</span></td>
												</c:if>
												<c:if test="${deptStatus.count != 1}">
													<td><sc:text name="dataArea${dateAreaStatus.count}_paravalue${deptStatus.count}" value="${detail.paravalue}"/></td>
												</c:if>
											</c:if>
										</c:forEach>
										<%if(flag){%>
											<td><sc:text name="dataArea${dateAreaStatus.count}_paravalue${deptStatus.count}"/></td>
										<%}%>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</form>
<script>
var dataAreaid = $("#dataAreaid").val();
function deleteDateArea(id){
	$("#"+id,$.pdialog.getCurrent()).remove();
}
function addDateArea(){
	dataAreaid++;
	var html = "";
		html = "<div id='dataArea"+dataAreaid+"' style='width:48%;float:left;margin:5px;margin-top:20px;'>"
		+"<div style='border:solid #C0C0C0 1px;'>"
		+"<table class='list' width='100%' ><tr><td width='20%'>起止日期</td>"
		+"<td width='30%'><input type='text' class='date required' name='dataArea"+dataAreaid+"_enabledate' style='width:85%;'/><span class='redmust'>*</span></td>"
		+"<td width='30%'><input type='text' class='date required' name='dataArea"+dataAreaid+"_disenabledate' style='width:85%;'/><span class='redmust'>*</span></td>"
		+"<td><input type='hidden' name='areacount' value='"+dataAreaid+"'/></td>"
		+"<td width='25%'><a class='btnDel' href='javascript:void(0)' onclick='deleteDateArea(\"dataArea"+dataAreaid+"\")'>删除区间</a></td></tr></table></div>"
		+"<div style='border:solid #C0C0C0 1px;margin-top:5px;'><table class='list'  width='100%' ><thead><tr ><td>机构</td><td>参数值</td></tr></thead><tbody>"
		+"<c:forEach var='dept' items='${jrafrpu.rspPkg.rspRcdDataMapsResults2}'  varStatus='deptStatus'>"
		+"<c:if test='${deptStatus.last}'><input type='hidden' name = 'deptcount' value = '${deptStatus.count}' /></c:if>"
		+"<tr><td width='40%'>${dept.deptname}<input type='hidden' name='dataArea"+dataAreaid+"_deptid${deptStatus.count}' value='${dept.deptid}'/></td>"
		+"<c:if test='${deptStatus.count == 1}'><td><input type='text' name='dataArea"+dataAreaid+"_paravalue${deptStatus.count}' validate='required'/><span class='redmust'>*</span></td></c:if>"
		+"<c:if test='${deptStatus.count != 1}'><td><input type='text' name='dataArea"+dataAreaid+"_paravalue${deptStatus.count}'/></td></c:if>"
		+"</tr></c:forEach></tbody></table></div></div>";
	$("#content",$.pdialog.getCurrent()).append(html);
	initUI($("#dataArea"+dataAreaid,$.pdialog.getCurrent())); 
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