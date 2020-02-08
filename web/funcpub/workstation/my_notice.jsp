<%@page import="com.sunline.jraf.util.Crypto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>

<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>用户公告列表</title>
<script type="text/javascript">
	
	$(function(){
		loadData();
	});
	
	function callbackMg(data){
		if(data.statusCode == "200"){
			loadData();
		} else {
			alertMsg.error("标记公告失败");
		}
	}
	
	
	function loadData(){
		$(".pageContent#my_notice_div").load("/funcpub/workstation/my_noticelist.jsp");
	}
	
</script>
</head>
<body scroll="no">
	<div class="pageContent" id="my_notice_div">
		
	</div>
	</body>
</html>

