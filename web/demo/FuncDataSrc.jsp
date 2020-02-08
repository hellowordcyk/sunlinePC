<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>管理系统</title>
</head>
<sc:doPost sysName="funcpub" oprId="dataconf-jui-user" action="getFuncMenu" scope="request" var="rspPkg" all="true"></sc:doPost>
<body>
<div class="pageContent">
	<table class="table" width="100%" border="1">
		<thead>
			<tr>
				<th>功能id</th>
				<th>功能编码</th>
				<th>功能名称</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="metadata123" items="${rspPkg.rspRcdDataMapsResults1 }" end="4">
			<tr target="funcid" rel="${metadata123.funcid}">
				<td>${metadata123.funcid}</td>
				<td>${metadata123.funccode}</td>
				<td>${metadata123.funcname}</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
</div>
</body>
</html>