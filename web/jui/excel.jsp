<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>公共平台</title>
</head>
<body scroll="no">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="icon" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-excel' type='crypto'/>&actions=<sc:fmt value='exportExcel' type='crypto'/>&userid=1001&multi=1&forward=<sc:fmt value='/jui/excel.jsp' type='crypto'/>" target="navTab" rel="exportExcel"><span>导出Excel</span></a></li>
		</ul>
		<button class="button" onclick="test()">ajax</button>
	<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return navTabSearch(this)">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='add' type='crypto'/>"/>
		<input type="hidden" name="forward" value=""/>
		
		<input type="submit" class="button" value="form">
	</form>
	</div>
	
</body>
</html>
<script>
function test(){
	$.ajax({
		global:false,
		timeout:10000,
		type:"post",
		url:"/httpprocesserservlet?sysName=<%=Crypto.encode(request,"")%>&oprID=<sc:fmt value='funcpub-excel' type='crypto'/>&actions=<sc:fmt value='exportExcel' type='crypto'/>&userid=1001&multi=1",
		dataType:"xml",
		success:function(){
			alert("success");	
		},
		error:function(obj){
			jQuery.event.trigger( "ajaxStop" );
			var msg = obj.responseText.substring(obj.responseText.indexOf("<br/>")+5,obj.responseText.lastIndexOf("</p>")+4);
			alertMsg.error(msg);
		}
	});
}
</script>