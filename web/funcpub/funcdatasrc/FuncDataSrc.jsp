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
<%
	
		    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
			Element pageInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Results1").getChild("PageInfo");
		    String recordCount = pageInfo.getChildTextTrim("RecordCount");
		    String pageCount = pageInfo.getChildTextTrim("PageCount");
		    String pageSize = pageInfo.getChildTextTrim("PageSize");
		    String pageNo = pageInfo.getChildTextTrim("PageNo");
%>
<body>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>&actions=<sc:fmt value='getFuncMenu' type='crypto'/>&forward=<sc:fmt value='/funcpub/funcdatasrc/FuncDataSrc.jsp' type='crypto'/>" method="post">
    <input type="hidden" name="pageNum" value="1" />
    
	<%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
	
	<div class="searchBar">
		<table class="searchContent" width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td align="right">功能编码</td>
				<td><sc:text name="look.funcname" /></td>
				<td align="right">功能名称</td>
				<td><sc:text name="funcname11" /> </td>
				<td align="right">功能名称</td>
				<td><sc:text name="funcname12" /></td>
			</tr>
			<tr>
				<td align="right">功能名称</td>
				<td colspan="4"><sc:text name="funcname12" /> </td>
				<td align="right"> 
					<input type="submit"  jraf_initsubmit class="button" value="查询"/>
				</td>
			</tr>
			
		</table>
	</div>
	</form>
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="/funcpub/funcdatasrc/FuncDataAdd.jsp" height="400" width="800" target="dialog" rel="addFuncMenu"><span>新增</span></a></li>
            <li><a class="delete" rel="funcids" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>&actions=<sc:fmt value='delFuncMenu' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>
			<li><a href="doc/dwz-team.xls"  class="export" target="dwzExport" targetType="navTab" title="实要导出这些记录吗?"><span>导出Excel</span></a></li>

			
		</ul>
	</div>	
	<table class="table" width="100%" >
		<thead>
			<tr>
				<th width="2%"><input type="checkbox" class="checkboxCtrl" group="funcids" /></th>
				<th>功能编码</th>
				<th>功能名称</th>
				<th>功能脚本JAVA路径</th>
				<th>数据源编码</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="metadata" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1 }">
			<tr target="funcid" rel="${metadata.funcid}">
				<td><input type="checkbox"  name="funcids" value="${metadata.funcid}" /></td>
				<td>${metadata.funccode}</td>
				<td>${metadata.funcname}</td>
				<td>${metadata.funcaddres}</td>
				<td>${metadata.func_datasrc}</td>
				<td>
					<a title="删除" target="ajaxTodo" href="/httpprocesserservlet?
					sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>
					&actions=<sc:fmt value='delFuncMenu' type='crypto'/>&funcids=${metadata.funcid}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="btnDel">删除</a>
					
					<a title="修改功能" rel="getfunmapbyid" href="/httpprocesserservlet?
					sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>
					&actions=<sc:fmt value='getfunmapbyid' type='crypto'/>&func_id=${metadata.funcid}&forward=<sc:fmt value='/funcpub/funcdatasrc/FuncDataUpd.jsp' type='crypto'/>" 
					class="btnEdit" target="dialog"  height="400" width="800" >修改</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="panelBar" style="height: 35px;">
		
		<div class="pagination" targetType="navTab" totalCount="<%=recordCount %>" numPerPage="<%=pageSize %>" pageNumShown="<%=pageCount %>" currentPage="<%=pageNo %>"></div>
	</div>
</div>
</body>
</html>