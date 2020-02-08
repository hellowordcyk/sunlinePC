<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<sc:doPost sysName="funcpub" oprId="MysqlBackupsTable" action="TableQuery" scope="request" var="rspPkg" all="true"></sc:doPost>
<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='MysqlBackupsTable' type='crypto'/>&actions=<sc:fmt value='TableQuery' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
<div class="searchBar">
	<!-- <ul class="searchContent">
		<li>
			<label>机构名称:</label>
			<input class="textInput" name="orgName" value="" type="text">
		</li>	  
		<li>
			<label>机构编号:</label>
			<input class="textInput" name="orgNum" value="" type="text">
		</li>
		<li>
			<label>机构经理:</label>
			<input class="textInput" name="leader" value="" type="text">
		</li>
			<li>
			<label>上级机构:</label>
			<input class="textInput" name="parentOrg.orgName" value="" type="text">
		</li> 
	</ul> -->
	<div class="subBar">
		<ul>
			<!-- <li><div class="buttonContent"><button type="submit">查询</button></div></li> -->
			<li><button class="button" type="button" multLookup="orgId" warn="请选择机构">选择带回</button></li>
		</ul>
	</div>
</div>
</form>
<table class="table" width="100%">
	<thead>
		<tr>
			<th width="4%"><input type="checkbox" class="checkboxCtrl" group="orgId" /></th>
			<th orderfield="tablename">表名</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="lookup" items="${rspPkg.rspRcdDataMaps}" varStatus="Index">
			<tr>
				<td><input type="checkbox"  name="orgId" value="{tablename: '${lookup.tablename}'}"/></td>
				<td>${lookup.tablename}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
