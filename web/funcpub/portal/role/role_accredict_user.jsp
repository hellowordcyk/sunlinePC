<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations"%>
<%
	String roleid =  request.getParameter("roleid");
%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return dialogSearch(this);" action="/httpprocesserservlet?=&=&=&=" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='queryRoleUser' type='crypto'/>" />
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/role/role_accredict_user.jsp' />" />
		<sc:hidden name="selected" value="${jrafrpu.rspPkg.rspDataMap.selected}"/>
		<div class="searchBar">
			<sc:hidden name="roleid" index="1"/>
			<sc:hidden name="pageNum" index="1"/>
			
			<table class="searchContent">
			    <tr>
				    <td align="right">用户名称</td>
				  	<td colspan="4"><sc:text name="usercode" /></td>
				    <td align="right"><button class="button"  jraf_initsubmit  type="submit">查询</button></td>
			    </tr>
		    </table>
	    </div>
	</form>
</div>
<div class="pageContent" >
		<table class="table" width="98%" >
			<thead>
				<tr>
					<th width="30px"><input type="checkbox" class="checkboxCtrl" group="userids" /></th>
					<th>用户编号</th>
					<th>用户名称</th>
					<th>所在机构</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="user" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
					<tr>
						<c:if test="${user.isSelected == 1}">
							<td><input type="checkbox" checked="checked"  name="userids" value="${user.userid}" onchange="changeChose(this)"/></td>
						</c:if>
						<c:if test="${user.isSelected == 0}">
							<td><input type="checkbox"  name="userids" value="${user.userid}" onchange="changeChose(this)"/></td>
						</c:if>
						<td>${user.usercode}</td>
						<td>${user.username}</td>
						<td>${user.deptname}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	
	<div class="panelBar">
		<div rel=""  class="pagination" targetType="dialog" 
			totalCount="${jrafrpu.rspPkg.rspRecordCount}" 
			numPerPage="${jrafrpu.rspPkg.rspPageSize }" 
			currentPage="${jrafrpu.rspPkg.rspPageNo}">
		</div>
	</div>	
</div>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
	<input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>" />
	<input type="hidden" name="actions" value="<sc:fmt value='mergeRoleUser' type='crypto'/>" />
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />" />
	<sc:hidden name="roleid" index="1"/>
	<sc:hidden name="selected" value="${jrafrpu.rspPkg.rspDataMap.selected}"/>
	<div class="formBar">
		<ul>
			<li><button type="submit" class="button">提交</button></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>	
</form>
<script>
function changeChose(event){
	
	var isSelected = $(event)[0].checked;
	var userID = $(event).val();
	var selected = new Array();
	var selectedStr = $("input[name='selected']",$.pdialog.getCurrent()).val();
	if(null != selectedStr && selectedStr != ""){
		selected = selectedStr.split(",");
	}
	if(isSelected){
		selected.push(userID);
	}else{
		selected.splice(jQuery.inArray(userID,selected),1); 
	}
	$("input[name='selected']",$.pdialog.getCurrent()).val(selected.toString());
}
</script>
