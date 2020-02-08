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
<link href="/jui/themes/default/style.css" rel="stylesheet" type="text/css" media="screen"/>
<link href="/jui/themes/css/core.css" rel="stylesheet" type="text/css" media="screen"/>
<link href="/jui/themes/css/print.css" rel="stylesheet" type="text/css" media="print"/>
<link href="/jui/uploadify/css/uploadify.css" rel="stylesheet" type="text/css" media="screen"/>

<script src="/jui/js/jquery-1.7.2.js" type="text/javascript"></script>
<script src="/jui/js/jquery.cookie.js" type="text/javascript"></script>
<script src="/jui/js/jquery.validate.js" type="text/javascript"></script>
<script src="/jui/js/jquery.bgiframe.js" type="text/javascript"></script>
<script src="/jui/xheditor/xheditor-1.2.1.min.js" type="text/javascript"></script>
<script src="/jui/xheditor/xheditor_lang/zh-cn.js" type="text/javascript"></script>
<script src="/jui/uploadify/scripts/jquery.uploadify.js" type="text/javascript"></script>
<script src="/jui/bin/dwz.min.js" type="text/javascript"></script>
<script src="/jui/js/dwz.regional.zh.js" type="text/javascript"></script>
<script src="/common/func-scripts/jquery.jraf.commons.js" type="text/javascript"></script>
</head>
<body>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>&actions=<sc:fmt value='getFuncMenu' type='crypto'/>&forward=<sc:fmt value='/funcpub/funcdatasrc/FuncDataSrc.jsp' type='crypto'/>" method="post">
    <input type="hidden" name="pageNum" value="1" />
    
	<%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
	
	<div class="searchBar">
		<table class="searchContent">
			<tr>
				<td>
					关键字：<sc:text name="look.funcname" /> [功能名称]
					关键字：<sc:text name="funcname11" /> [功能名称]
				</td>
				<td align="right">
				<a href="/funcpub/funcdatasrc/FuncDataSrc.jsp" target="navTab" external="true" rel="r1">iframe方式打开</a>
				<a href="/funcpub/funcdatasrc/FuncDataSrc.jsp" target="navTab" external="false" rel="r2">非iframe方式打开</a>

				
					<input type="submit"   	jraf_initsubmit class="button" value="查询"/>
					<a class="button" href="demo_page6.html" target="dialog" mask="true" title="查询框">高级检索<a/> 
				</td>
			</tr>
		</table>
	</div>
	</form>
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="/funcpub/funcdatasrc/FuncDataAdd.jsp" height="300" width="800" target="dialog" rel="addFuncMenu"><span>新增</span></a></li>
            <li><a class="edit" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>&actions=<sc:fmt value='getfunmapbyid' type='crypto'/>&func_id={funcid}&forward=<sc:fmt value='/funcpub/funcdatasrc/FuncDataUpd.jsp' type='crypto'/>" height="300" width="800" target="dialog" rel="getfunmapbyid"><span>修改</span></a></li>
            <li><a class="delete" rel="funcids" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>&actions=<sc:fmt value='delFuncMenu' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>

			<li class="line">line</li>
		</ul>
	</div>	
	<table class="table" width="100%" >
		<thead>
			<tr>
				<th width="2%"><input type="checkbox" class="checkboxCtrl" group="funcids" /></th>
				<th>功能id</th>
				<th>功能编码</th>
				<th>功能名称</th>
				<th>功能脚本JAVA路径</th>
				<th>数据源编码</th>
				<th>备注</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="metadata123" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1 }">
			<tr target="funcid" rel="${metadata123.funcid}">
				<td><input type="checkbox"  name="funcids" value="${metadata123.funcid}" /></td>
				<td>${metadata123.funcid}</td>
				<td>${metadata123.funccode}</td>
				<td>${metadata123.funcname}</td>
				<td>${metadata123.funcaddres}</td>
				<td>${metadata123.func_datasrc}</td>
				<td>${metadata123.remark}</td>
				<td>
					
					<a title="删除" target="ajaxTodo" href="/httpprocesserservlet?
					sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>
					&actions=<sc:fmt value='delFuncMenu' type='crypto'/>&funcids=${metadata123.funcid}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="btnDel">删除</a>
					
					<a title="修改" rel="getfunmapbyid" href="/httpprocesserservlet?
					sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>
					&actions=<sc:fmt value='getfunmapbyid' type='crypto'/>&func_id=${metadata123.funcid}&forward=<sc:fmt value='/funcpub/funcdatasrc/FuncDataUpd.jsp' type='crypto'/>" 
					class="btnEdit" target="dialog">修改</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="panelBar">
	  <div class="pagination" targetType="navTab" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
	  </div>
  </div>
</div>
</body>
</html>