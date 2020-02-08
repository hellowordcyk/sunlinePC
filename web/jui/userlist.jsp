<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%
		    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
			Element pageInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("PageInfo");
		    String recordCount = pageInfo.getChildTextTrim("RecordCount");
		    String pageCount = pageInfo.getChildTextTrim("PageCount");
		    String pageSize = pageInfo.getChildTextTrim("PageSize");
		    String pageNo = pageInfo.getChildTextTrim("PageNo");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>学校信息管理网站</title>
</head>
<body>
<form id="pagerForm" method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-jui-user' type='crypto'/>&actions=<sc:fmt value='getMenu' type='crypto'/>&forward=<sc:fmt value='/jui/userlist.jsp' type='crypto'/>">
	<input type="hidden" name="menuName" value="${param.menuName}" />
	<input type="hidden" name="pageNum" value="1" />
</form>
<div class="pageHeader">
	<form onsubmit="return navTabSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-jui-user' type='crypto'/>&actions=<sc:fmt value='getMenu' type='crypto'/>&forward=<sc:fmt value='/jui/userlist.jsp' type='crypto'/>" method="post">
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					关键字：<input type="text" name="menuName" /> [menuname]
				</td>
			</tr>
		</table>
		<div class="subBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">检索</button></div></div></li>
				<li><a class="button" href="demo_page6.html" target="dialog" mask="true" title="查询框"><span>高级检索</span></a></li>
			</ul>
		</div>
	</div>
	</form>
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="useradd.jsp" height="300" width="800" target="dialog" rel="addUser"><span>新增</span></a></li>
			<li><a class="delete" rel="menuid" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-jui-user' type='crypto'/>&actions=<sc:fmt value='delMenu' type='crypto'/>&forward=<sc:fmt value='/jui/json.jsp' type='crypto'/>" ><span>删除</span></a></li>
			<li class="line">line</li>
			<li><a class="icon" href="demo/common/dwz-team.xls" target="dwzExport" targetType="navTab" title="实要导出这些记录吗?"><span>导出Excel</span></a></li>
		</ul>
	</div>	
	<table class="table" width="100%" layoutH="138">
		<thead>
			<tr>
				<th width="2%"><input type="checkbox" class="checkboxCtrl" group="menuid" /></th>
				<th>menuid</th>
				<th>subsysid</th>
				<th>pmenuid</th>
				<th>levelp</th>
				<th>menuname</th>
				<th>imgurl</th>
				<th>linkurl</th>
				<th>isinternet</th>
				<th>remark</th>
				<th>sortno</th>
			</tr>
		</thead>
		<tbody>
		<%
		    List dataList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildren("Record");
		    if (dataList != null){
		        for (int i=0;i<dataList.size();i++){
		            Element recordElement = (Element)dataList.get(i);
		            String menuid=recordElement.getChildTextTrim("MENUID");
		            String subsysid=recordElement.getChildTextTrim("SUBSYSID");
		            String pmenuid=recordElement.getChildTextTrim("PMENUID");
		            String levelp=recordElement.getChildTextTrim("LEVELP");
		            String menuname=recordElement.getChildTextTrim("MENUNAME");
		            String imgurl=recordElement.getChildTextTrim("IMGURL");
		            String linkurl=recordElement.getChildTextTrim("LINKURL");
		            String isinternet=recordElement.getChildTextTrim("ISINTERNET");
		            String remark=recordElement.getChildTextTrim("REMARK");
		            String sortno=recordElement.getChildTextTrim("SORTNO");
		            String strInfo=menuid+"-"+subsysid+"-"+pmenuid+"-"+levelp+"-"+menuname+"-"+imgurl+"-"+linkurl+"-"+isinternet+"-"+remark+"-"+sortno;
	    %>
			<tr target="menuid" rel="<%=strInfo%>">
				<td><input type="checkbox"  name="menuid" value="<%=recordElement.getChildTextTrim("MENUID")%>" /></td>
				<td><%=menuid%></td>
				<td><%=subsysid%></td>
				<td><%=pmenuid%></td>
				<td><%=levelp%></td>
				<td><%=menuname%></td>
				<td><%=imgurl%></td>
				<td><%=linkurl%></td>
				<td><%=isinternet%></td>
				<td><%=remark%></td>
				<td><%=sortno%></td>
			</tr>
			<% 
		        }}
			%>
		</tbody>
	</table>
	
</div>
<div class="panelBar">
		<div class="pagination" targetType="navTab" totalCount="<%=recordCount %>" numPerPage="<%=pageSize %>" pageNumShown="<%=pageCount %>" currentPage="<%=pageNo %>"></div>
	</div>
</body>
</html>