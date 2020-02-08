<%@page import="java.net.URLEncoder"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<style type="text/css">
	#selectedManagerTree li span.button.switch.level0 {visibility:hidden; width:1px;}
	#selectedManagerTree li ul.level0 {padding:0; background:none;}
	.myPagin li .first span {
		color: #0073cc;
		background: url(/jui/themes/blue/images/button/first.gif) no-repeat 0 4px;
	}
	
	.myPagin li .previous span {
		color: #0073cc;
		background: url(/jui/themes/blue/images/button/prev.gif) no-repeat 0 4px;
	}
	
	.myPagin li .next span {
		color: #0073cc;
		background: url(/jui/themes/blue/images/button/next.gif) no-repeat 0 4px;
	}
	
	.myPagin li .last span {
		color: #0073cc;
		background: url(/jui/themes/blue/images/button/last.gif) no-repeat 0 4px;
	}
	
	.myPagin li .first span:hover {
		color: #054a7e;
		background: url(/jui/themes/blue/images/button/first-hover.gif) no-repeat 0
			4px;
	}
	
	.myPagin li .previous span:hover {
		color: #054a7e;
		background: url(/jui/themes/blue/images/button/prev-hover.gif) no-repeat 0 4px;
	}
	
	.myPagin li .next span:hover {
		color: #054a7e;
		background: url(/jui/themes/blue/images/button/next-hover.gif) no-repeat 0 4px;
	}
	
	.myPagin li .last span:hover {
		color: #054a7e;
		background: url(/jui/themes/blue/images/button/last-hover.gif) no-repeat 0 4px;
	}
	
	.myPagin li.disabled .first span,.myPagin li.disabled .first span:hover
		{
		background: url(/jui/themes/blue/images/button/first-dis.gif) no-repeat 0 4px;
		color: #888;
		font-weight: normal;
	}
	
	.myPagin li.disabled .previous span,.myPagin li.disabled .previous span:hover
		{
		background: url(/jui/themes/blue/images/button/prev-dis.gif) no-repeat 0 4px;
		color: #888;
		font-weight: normal;
	}
	
	.myPagin li.disabled .next span,.myPagin li.disabled .next span:hover
		{
		background: url(/jui/themes/blue/images/button/next-dis.gif) no-repeat 0 4px;
		color: #888;
		font-weight: normal;
	}
	
	.myPagin li.disabled .last span,.myPagin li.disabled .last span:hover
		{
		background: url(/jui/themes/blue/images/button/last-dis.gif) no-repeat 0 4px;
		color: #888;
		font-weight: normal;
	}
	
	.myPagin li.jumpto .textInput {
		border: 1px solid #c4cfda;
	}
	
	.myPagin li.jumpto .textInput:focus {
		background-color: #c4e9e3;
	}
	
	.myPagin li.jumpto .goto {
		background-color: #549cff;
		border-radius: 1px;
	}
	
	.myPagin li.jumpto .goto:hover {
		background-color: #64b4ff;
	}
	
	.myPagin {
		float: right;
		padding-left: 7px;
		padding-top: 4px;
		/* 	position:absolute;
		bottom:0;
		right:0; */
	}
	
	.myPagin li,.myPagin li.hover {
		padding: 0 5px 0 5px;
		/* color: #fff000; */
	}
	
	.myPagin a,.myPagin li.hover a,.myPagin li span {
		float: left;
		display: block;
		padding: 0;
		text-decoration: none;
		line-height: 23px;
		color: black;
	}
	
	.myPagin li.selected a {
		color: red;
		font-weight: bold;
	}
	
	.myPagin span,.myPagin li.hover span {
		float: left;
		display: block;
		height: 23px;
		line-height: 23px;
		cursor: pointer;
	}
	
	.myPagin span.pageinfo {
		display: block;
		height: 23px;
		line-height: 23px;
		color: black;
	}
	
	.myPagin li .first span,.myPagin li .previous span,.myPagin li .next span,.panelBar li .last span
		{
		padding: 0px 2px 0px 18px;
	}
	
	.myPagin li .last {
		margin-right: 2px;
	}
	
	.myPagin li.disabled {
		
	}
	
	.myPagin li.disabled span,.grid .myPagin li.disabled a {
		cursor: default;
	}
	
	.myPagin li.disabled span span {
		color: #666;
	}
	
	.myPagin li.disabled .last {
		margin-right: 2px;
	}
	
	.myPagin li.jumpto {
		padding: 0 2px 0 0;
	}
	
	.myPagin li.jumpto .textInput {
		float: left;
		width: 30px;
		height: 16px;
		border-radius: 2px;
	}
	
	.myPagin li.jumpto .goto {
		float: left;
		display: block;
		overflow: hidden;
		height: 22px;
		width: 45px;
		line-height: 22px;
		border: 0;
		cursor: pointer;
		margin: 0 5px;
		text-align: center;
		color: #fff;
	}
	.evenrow {
	    background-color: #fafafa;
	}
</style>
<body>
 <div class="pageHeader" style="height: 10%" >
 <sc:doPost sysName="funcpub" oprId="grantResourceToUserActor" action="getPrivTypeList" scope="request" var="rspPkg" all="true"></sc:doPost>
	
	<form id="pagerForm" onsubmit="return false;" action="javascript:void(0);" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='grantResourceToUserActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='getPrivTypeList' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/userpriv/grantResource.jsp' />?roleid=${param.roleid}" />
		 	
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				   <td class="form-label">资源类型</td>
				    <td class="form-value">
				    	<select name="pType" id="pType" onchange="changepType()" class="required" style="width:150px;text-align:center;">
				    		<c:if test="${not empty rspPkg.rspRcdDataMaps}">
					    		<c:forEach var="privT" items="${rspPkg.rspRcdDataMaps}"  varStatus="index">
					    			<option value="${privT.privType}" subsysCode="${privT.subsysCode}">${privT.privDesc }</option>
					    		</c:forEach>
				    		</c:if>
				    		<c:if test="${empty rspPkg.rspRcdDataMaps}">
				    			<option value="">--无用户授权资源服务--</option>
				    		</c:if>
				    	</select>
				    </td>
				    <td class="form-label">资源名称 </td>
				    <td class="form-value"><input type="text" class="inputtext textInput" name="qName" id="qName" value="" onkeydown="enterForQuery(event)"/></td>
				    <td class="form-btn">
                        <ul>
                            <li>
                                <button class="querybtn" onclick="query()" type="button">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
			    </tr>
		    </table>
	    </div>
	</form>
  </div>
	
	<div class="pageContent" style="padding-bottom:0px;">
		<div style="width:42%;float:left;margin-top:5px;margin-left:5px; height:380px;">
			<div id="ungrantResource" style="width:99%;float:left;height:330px;overflow: auto;">
				<table class="list options" width="95%" style="margin:0px auto;">
					<caption style="text-align:center;height:32px;line-height:32px;background-color:#e4e7ec;color:#666;border:solid 1px #D0D0D0;">未授权列表</caption>
					<thead>
						<tr>				
							<th align="center" width="50px" style="text-align:center;"><input type="checkbox" id="checkAll1" /></th>
							<th align="center" style="text-align:center;">资源名称</th>
						</tr>
					</thead>
					
					<tbody>
						
					</tbody>
				</table>
			    
			</div>
			<div class="panelBar" id="pagin1">
				
			</div>
		</div>
		
		<div class="window-center-button" style="width:110px;margin-left:12px;">
			<button class="add" onclick="confirmGrant('grant','selected');" type="button" style="width:90px;">授权-&gt;</button><br><br>
			<button class="add" onclick="confirmGrant('grant','all');" type="button" style="width:90px;">授权本页-&gt;</button><br><br>
			<button class="delete" onclick="confirmGrant('revoke','selected')" type="button" style="width:90px;">&lt;-取消授权</button><br><br>
			<button class="delete" onclick="confirmGrant('revoke','all')" type="button" style="width:90px;">&lt;-取消本页</button><br><br>
		</div>
		<div style="width:42%;float:left;margin-top:5px;margin-left:5px; margin-left:2px;height:380px;">
			<div id="grantedResource" style="width:99%;float:left;height:330px;overflow: auto;">
				<table class="list options" width="95%" style="margin:0px auto;">
					<caption style="text-align:center;height:32px;line-height:32px;background-color:#e4e7ec;color:#666;border:solid 1px #D0D0D0;">已授权列表</caption>
					<thead>
						<tr>				
							<th align="center" width="50px" style="text-align:center;"><input type="checkbox" id="checkAll2" /></th>
							<th align="center" style="text-align:center;">资源名称</th>
						</tr>
					</thead>
					<tbody>
						
					</tbody>
				</table>
			</div>
			<div class="panelBar" id="pagin2">
					
			</div>
	</div>
	<div class="pageContent" id="grantResource_divid" >
	 

</div>
</body>
</html>
<script>

var pageNo1 = 1;
var pageNo2 = 1;
var pageSize1 = 10;
var pageSize2 = 10;
var queryName = "";
var pubResource = "no";
var pageScope = navTab.getCurrentPanel().find("#resc_priv_ctt");
function myKeyUp(event) {
	query();
	return false;
}

function enterForQuery(event){
	if(event.keyCode == DWZ.keyCode.ENTER){
		query();
		return false;
	}
}

/**
 * 加载未授权的资源权限
 */
function loadUngrantResource() {
	var _pType = $("#pType",navTab.getCurrentPanel());
	var privType = _pType.val();
	$("#ungrantResource table tbody",navTab.getCurrentPanel()).empty();
	if(!privType || privType.isBlank() || !_pType.valid()){
		return;
	}
	var subsysCode = $("#pType",navTab.getCurrentPanel()).find("option[value='"+privType+"']").attr("subsysCode");
	var sysName='<sc:fmt value='funcpub' type='crypto'/>';
	var oprID='<sc:fmt value='grantResourceToUserActor' type='crypto'/>';
	var actions='<sc:fmt value='getUserUnGrantedPrivilegeListPage' type='crypto'/>';
	var userid = '${param.userid}';
	var url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions+"&userid1="+userid+"&privType1="+privType+"&pageNum="+pageNo1+"&pageSize="+pageSize1+"&qName1="+queryName+"&pubResource=" + pubResource+"&subsysCode1="+subsysCode;
	$.ajax({    
        type:'post',        
        url:url,
        async:true,   
        dataType:'xml', 
        success:function(result){        	
        	var result = Jraf.parseXmlResponseDataToJson(result);
        	var html = "";
        	var data = result["Record"];
        	var dataList = result["PageInfo"];  
        	if(typeof(data)!='undefined' && data){
        		
        			if(data instanceof Array){
        				for(var i=0;i < data.length;i++){
        					html+='<tr'+ (i%2==0?'':' class="evenrow"') +'>';
        		        	html+='   <td align="center" style="text-align:center;">';
        		        	html+='    	<input type="checkbox" name="resourceCode1"/>';
        		        	html+='    	<input type="hidden" name="privCode" id="privCode" value="'+data[i].privCode+'"/>';
        		        	html+='    	<input type="hidden" name="subsysCode" id="subsysCode" value="'+data[i].subsysCode+'"/>';
        		        	html+='    	<input type="hidden" name="privType" id="privType" value="'+data[i].privType+'"/>';
        		        	html+='   </td>';
        		        	html+='    <td align="center">'+data[i].privName+'[' +data[i].privCode+']</td>';
        		        	html+='</tr>';
        		        }
        		}
        			else{
        		        
        		        	html+='<tr'+ (0%2==0?'':' class="evenrow"') +'>';
        		        	html+='   <td align="center" style="text-align:center;">';
        		        	html+='    	<input type="checkbox" name="resourceCode1"/>';
        		        	html+='    	<input type="hidden" name="privCode" id="privCode" value="'+data.privCode+'"/>';
        		        	html+='    	<input type="hidden" name="subsysCode" id="subsysCode" value="'+data.subsysCode+'"/>';
        		        	html+='    	<input type="hidden" name="privType" id="privType" value="'+data.privType+'"/>';
        		        	html+='   </td>';
        		        	html+='    <td align="center">'+data.privName+'[' +data.privCode+']</td>';
        		        	html+='</tr>';
        		        
        		    }
        	}
        	$("#ungrantResource tbody",navTab.getCurrentPanel()).html(html);
        	genaratorPagin(result.PageInfo, "pagin1", 1);
        }
    });   
}

/**
 * 加载已授权的资源权限
 */
function loadgrantedResource() {
	var _pType = $("#pType",navTab.getCurrentPanel());
	var privType = _pType.val();
	$("#grantedResource tbody",pageScope).empty();
	if(!privType || privType.isBlank() || !_pType.valid()){
		return;
	}
	var privType = $("#pType",navTab.getCurrentPanel()).val();
	var subsysCode = $("#pType",navTab.getCurrentPanel()).find("option[value='"+privType+"']").attr("subsysCode");
	
	var sysName='<sc:fmt value='funcpub' type='crypto'/>';
	var oprID='<sc:fmt value='grantResourceToUserActor' type='crypto'/>';
	var actions='<sc:fmt value='getUserGrantedPrivilegeListPage' type='crypto'/>';
	var userid = '${param.userid}';
	var url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions+"&userId="+userid+"&privType="+privType+"&pageNum="+pageNo2+"&pageSize="+pageSize2+"&qName="+queryName+"&pubResource=" + pubResource+"&subsysCode="+subsysCode;
	$.ajax({    
        type:'post',        
        url:url,
        async:true,   
        dataType:'xml', 
        success:function(result){
        	
        	var result = Jraf.parseXmlResponseDataToJson(result);
        	
        	
        	var html = "";
        	var data = result["Record"];
        	if(typeof(data)!='undefined' && data){
        		if(data instanceof Array){
    				
        	for(var i=0;i < data.length;i++){
	        	html+='<tr'+ (i%2==0?'':' class="evenrow"') +'>';
	        	html+='	<td align="center" style="text-align:center;">';
	        	html+='    	<input type="checkbox" name="resourceCode2"/>';
	        	html+='    	<input type="hidden" name="privCode" id="privCode" value="'+data[i].privCode+'"/>';
	        	html+='    	<input type="hidden" name="subsysCode" id="subsysCode" value="'+data[i].subsysCode+'"/>';
	        	html+='    	<input type="hidden" name="privType" id="privType" value="'+data[i].privType+'"/>';
	        	html+='   </td>';
	        	html+='    <td align="center">'+data[i].privName+'[' +data[i].privCode+']</td>';
	        	html+='</tr>';
        	}
        		}else{
        			html+='<tr'+ (0%2==0?'':' class="evenrow"') +'>';
    	        	html+='	<td align="center" style="text-align:center;">';
    	        	html+='    	<input type="checkbox" name="resourceCode2"/>';
    	        	html+='    	<input type="hidden" name="privCode" id="privCode" value="'+data.privCode+'"/>';
    	        	html+='    	<input type="hidden" name="subsysCode" id="subsysCode" value="'+data.subsysCode+'"/>';
    	        	html+='    	<input type="hidden" name="privType" id="privType" value="'+data.privType+'"/>';
    	        	html+='   </td>';
    	        	html+='    <td align="center">'+data.privName+'[' +data.privCode+']</td>';
    	        	html+='</tr>';
		    }
        	}
        	$("#grantedResource tbody",navTab.getCurrentPanel()).html(html);
        	
        	genaratorPagin(result.PageInfo, "pagin2", 2);
        }
    });    
}

/**
 * 加载未授权 或者 已授权 的数据
 */
function changepType(){
	queryName = "";
	$("#qName",navTab.getCurrentPanel()).val("");
	pageNo1 = 1;
	pageSize1 = 10;
	loadUngrantResource();
	pageNo2 = 1;
	pageSize2 = 10;
	loadgrantedResource();
}

/**
 * 页面初始化
 */
$(document).ready(function() {
	loadUngrantResource();
	loadgrantedResource();
	$("#checkAll1",navTab.getCurrentPanel()).live("change",function(e) {
		$("#ungrantResource tbody").find(":checkbox").each(function(i,e1) {
	       $(this).attr("checked",e.target.checked);
	     });
	});
	$("#checkAll2",navTab.getCurrentPanel()).live("change",function(e) {
		$("#grantedResource tbody",navTab.getCurrentPanel()).find(":checkbox").each(function(i,e1) {
	       $(this).attr("checked",e.target.checked);
	     });
	});
});

/**
 * 授权或取消授权 操作确认
 */
function confirmGrant(type,sel) {
	var tip = "确定操作吗？";
	if(type==="grant") {
		if(sel=="all") {
			tip = "确定授权本页资源吗？";
		}else{
			tip = "确定授权已选中资源吗？";
		}
	}else if(type=="revoke") {
		if(sel=="all") {
			tip = "确定取消本页资源权限吗？";
		}else{
			tip = "确定取消已选中资源权限吗？";
		}
	}
	alertMsg.confirm(tip, {
        okCall: function(){
        	grantResource(type,sel);
        	
        	loadgrantedResource();
        	loadUngrantResource();

        	$("#checkAll1",navTab.getCurrentPanel()).removeAttr("checked");
        	$("#checkAll2",navTab.getCurrentPanel()).removeAttr("checked");
        	
        }
	});
}


/**
 * 对选中的资源授权或取消授权
 */
function grantResource(type,sel) {
	var res = "[";
	if(type=="grant") {
		if(sel=="all") {
			var all1 = $("#ungrantResource tbody",navTab.getCurrentPanel()).find(":checkbox");
			if(all1.length < 1) {
				alertMsg.warn("请在左边选择资源！");
				return;
			}
			all1.each(function(i,e){
				res += "{";
				res += "\"privCode\":\"" + $(e).nextAll("#privCode").val() + "\",";
				res += "\"privType\":\"" + $(e).nextAll("#privType").val() + "\",";
				res += "\"subsysCode\":\"" + $(e).nextAll("#subsysCode").val() + "\"";
				res += "},";
			});
		}else if(sel="selected"){
			var sels = new Array();
			$("#ungrantResource tbody",navTab.getCurrentPanel()).find(":checkbox").each(function(){
				if(this.checked){
					sels.push($(this));
				}
			});
			if(sels.length < 1) {
				alertMsg.warn("请在左边选择资源！");
				return;
			}
			$(sels).each(function(i,e){
				res += "{";
				res += "\"privCode\":\"" + $(e).nextAll("#privCode").val() + "\",";
				res += "\"privType\":\"" + $(e).nextAll("#privType").val() + "\",";
				res += "\"subsysCode\":\"" + $(e).nextAll("#subsysCode").val() + "\"";
				res += "},";
			});
		}
	}else if(type=="revoke") {
		if(sel=="all") {
			var all2 = $("#grantedResource tbody",navTab.getCurrentPanel()).find(":checkbox");
			if(all2.length < 1) {
				alertMsg.warn("请在右边选择资源！");
				return;
			}
			all2.each(function(i,e){
				res += "{";
				res += "\"privCode\":\"" + $(e).nextAll("#privCode").val() + "\",";
				res += "\"privType\":\"" + $(e).nextAll("#privType").val() + "\",";
				res += "\"subsysCode\":\"" + $(e).nextAll("#subsysCode").val() + "\"";
				res += "},";
			});
		}else if(sel="selected"){
			var sels = new Array();
			$("#grantedResource tbody",navTab.getCurrentPanel()).find(":checkbox").each(function(){
				if(this.checked){
					sels.push($(this));
				}
			});
			if(sels.length < 1) {
				alertMsg.warn("请在右边选择资源！");
				return;
			}
			$(sels).each(function(i,e){
				res += "{";
				res += "\"privCode\":\"" + $(e).nextAll("#privCode").val() + "\",";
				res += "\"privType\":\"" + $(e).nextAll("#privType").val() + "\",";
				res += "\"subsysCode\":\"" + $(e).nextAll("#subsysCode").val() + "\"";
				res += "},";
			});
		}
	}
	
	
	res = res.substring(0, res.length-1) + "]";
	var privType = $("#pType",navTab.getCurrentPanel()).val();
	var subsysCode = $("#pType",navTab.getCurrentPanel()).find("option[value='"+privType+"']").attr("subsysCode");
	var sysName='<sc:fmt value='funcpub' type='crypto'/>';
	var oprID='<sc:fmt value='grantResourceToUserActor' type='crypto'/>';
	var actions='<sc:fmt value='GrantResourceToUser' type='crypto'/>';
	if(type=="grant") {
		actions='<sc:fmt value='GrantResourceToUser' type='crypto'/>';
	}else if(type=="revoke") {
		actions='<sc:fmt value='revokeResourceToUser' type='crypto'/>';
	}
	var userid = '${param.userid}';
	var params = {"userId":userid,"privType":privType,"resources":res,"pubResource":pubResource,"subsysCode":subsysCode};
	var url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions;
	$.ajax({    
        type:'post',        
        url:url,
        async:false,
        data:params,
        dataType:'XML', 
        success:function(data){   
        	var retMessage = $(data).find('Msg').text();
        	alertMsg.info(retMessage);
        	query();
        }
    });   
}


/**
 * 查询函数
 */
function query() {
	
	queryName = $("#qName",navTab.getCurrentPanel()).val();	
	queryName = encodeURIComponent(encodeURIComponent(queryName));
	pageNo1 = 1;
	pageSize1 = 10;
	loadUngrantResource();
	pageNo2 = 1;
	pageSize2 = 10;
	loadgrantedResource();
}
function clearPrivList() {
	$("#grantedResource tbody",pageScope).empty();
	$("#ungrantResource tbody",pageScope).empty();
	var pageObj = new Object();
	pageObj.recordCount = 0;
	pageObj.pageNo = 1;
	pageObj.pageSize = 10;
	genaratorPagin(pageObj, "pagin1", 1);
	genaratorPagin(pageObj, "pagin2", 2);
}


/**
 * 翻页函数
 */
function jumpPage(pageN,pageS,totalPage,tableNum) {
	
	if(pageN==-1) {
		var jumpPageNo = $("#jump"+tableNum,navTab.getCurrentPanel()).val();
		if(jumpPageNo<1 || jumpPageNo >totalPage) {
			alertMsg.warn("页码超出范围！！");  
		}else{
			jumpPage(jumpPageNo,pageS,totalPage,tableNum);
		}
	}else {
		if(tableNum==1) {
			pageNo1 = pageN;
			pageSize1 = pageS;
			loadUngrantResource();
		}else if(tableNum==2){
			pageNo2 = pageN;
			pageSize2 = pageS;
			loadgrantedResource();
		}
	}
}

/**
 * 构造分页Html
 */
 function genaratorPagin(pageObj,pageId,tableNum) {
	
		var totalCount = pageObj.RecordCount,currentPageNum = pageObj.PageNo,numPerPage = pageObj.PageSize;
		if(tableNum==1) {
			pageNo1 = currentPageNum;
			pageSize1 = numPerPage;
		}else if(tableNum==2){
			pageNo2 = currentPageNum;
			pageSize2 = numPerPage;
		}
		var totalPage = 1;
		if(totalCount<=0) {
			totalPage = 1;
		}else{
			if(totalCount % numPerPage==0) {
				totalPage = parseInt(totalCount/numPerPage);
			}else{
				totalPage = parseInt(totalCount/numPerPage)+1;
			}
		}
		var paginHtml = '';
		paginHtml +='<div class="myPagin">';
		paginHtml +='	<ul>';
		paginHtml +='		<li class="">';
		paginHtml +='			<span class="j-pageinfo"><span>共'+totalCount+'条</span></span>';
		paginHtml +='		</li>';
		paginHtml +='		<li class="">';
		paginHtml +='			<span class="j-pageinfo"><span>每页'+numPerPage+'条</span></span>';
		paginHtml +='		</li>';
		paginHtml +='		<li class="">';
		paginHtml +='			<span class="j-pageinfo"><span>'+currentPageNum+'/'+totalPage+'</span></span>';
		paginHtml +='		</li>';
		if(currentPageNum<2) {
			paginHtml +='		<li class="j-first disabled">';
			paginHtml +='			<a style="display: none;" class="first" href="javascript:;"><span></span></a>';
			paginHtml +='			<span class="first"><span></span></span>';
			paginHtml +='		</li>';
			paginHtml +='		<li class="j-prev disabled">';
			paginHtml +='			<a style="display: none;" class="previous" href="javascript:;"><span></span></a>';
			paginHtml +='			<span class="previous"><span></span></span>';
			paginHtml +='		</li>';
		}else{
			paginHtml +='		<li class="j-first">';
			paginHtml +='			<a style="" class="first" href="javascript:jumpPage(1,'+numPerPage+','+totalPage+','+tableNum+');"><span></span></a>';
			paginHtml +='		</li>';
			paginHtml +='		<li class="j-prev ">';
			paginHtml +='			<a style="" class="previous" href="javascript:jumpPage('+(parseInt(currentPageNum)-1)+','+numPerPage+','+totalPage+','+tableNum+');"><span></span></a>';
			paginHtml +='		</li>';
		}
		if(currentPageNum >= totalPage) {
			paginHtml +='		<li class="j-next disabled">';
			paginHtml +='			<a style="display: none;" class="next" href="javascript:;"><span></span></a>';
			paginHtml +='			<span class="next"><span></span></span>';
			paginHtml +='		</li>';
			paginHtml +='		<li class="j-last disabled">';
			paginHtml +='			<a style="display: none;" class="last" href="javascript:;"><span></span></a>';
			paginHtml +='			<span class="last"><span></span></span>';
			paginHtml +='		</li>';
		}else{
			paginHtml +='		<li class="j-next">';
			paginHtml +='			<a style="" class="next" href="javascript:jumpPage('+(parseInt(currentPageNum)+1)+','+numPerPage+','+totalPage+','+tableNum+');"><span></span></a>';
			paginHtml +='		</li>';
			paginHtml +='		<li class="j-last">';
			paginHtml +='			<a style="" class="last" href="javascript:jumpPage('+totalPage+','+numPerPage+','+totalPage+','+tableNum+');"><span></span></a>';
			paginHtml +='		</li>';
		}
		paginHtml +='		<li class="jumpto"><input id="jump'+tableNum+'" class="textInput" size="4" value="'+currentPageNum+'" type="text"><input class="goto" value="GO" onclick="jumpPage(-1,'+numPerPage+','+totalPage+','+tableNum+')"  type="button"></li>';
		paginHtml +='	</ul>';
		paginHtml +='</div>';
		$("#"+pageId,navTab.getCurrentPanel()).html(paginHtml);
	}
	</script>
