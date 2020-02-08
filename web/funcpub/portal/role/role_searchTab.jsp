<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>角色管理</title>
</head>
<body scroll="no">
<div class="pageHeader">            
	<form id="pagerForm"  onsubmit="return dialogSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='queryRole' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/role/role_searchTab.jsp' type='crypto'/>" method="post">
		<input type="hidden" name="pageNum" value="1" />
		<!-- 丢失参数，需要input  hidden 增加 edit by longjian 20160615 night-->
		<input type="hidden" name="lookupCodeField" value="${param.lookupCodeField }"/>
		<input type="hidden" name="lookupNameField" value="${param.lookupNameField }"/>
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
    
		<div class="searchBar">
			<table class="searchContent" width="100%">
			    <tr>
				    <td align="right">子系统</td>
				    <td><sc:select name="subsys"  type="subsys"  nullOption ="--所有子系统--" validate="required"/></td>
				    <td align="right">角色名称 </td>
				    <td colspan="2"><sc:text name="rolename"/></td> 
				    <td align="right"><input type="submit"   jraf_initsubmit  class="button" value="查询"/></td>
			    </tr>
		    </table>
	    </div>
	</form>
</div>
<div class="pageContent">
	<table class="table list" width="100%" >
		<thead>
			<tr>
				<th>角色编号</th>
				<th>角色名称</th>
				<th>所属系统</th>
				<th>所属类型</th>
				<th width="25%">操作</th>

			</tr>
		</thead>
		<tbody>
			<c:forEach var="role" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
				<tr >
					<td align="center">${role.roleid}</td>
					<td align="center">${role.rolename}</td>
					<td align="center">${role.cnname}</td>
					<td align="center"><sc:optd name="roletype" type="dict" key="pcmc,roletp" value="${role.roletp }" /></td>
					<td>
						<a title="查找带回" class="btnSelect" style="cursor: pointer;"
						    onclick='$.bringBack({"${param.lookupCodeField }":"${role.roleid}", "${param.lookupNameField }":"${role.rolename}"})'
							>选择</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="dialog" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div>   
</body>

</html>