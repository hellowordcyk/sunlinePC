<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
<!DOCTYPE>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
	<title>系统资源管理</title>
</head>
<script type="text/javascript">	
	$("#jbsxBox1",navTab.getCurrentPanel()).loadUrl("/funcpub/portal/resource/query_sysresourse.jsp",{},function(){});	//进来自动加载第一个tab
</script>
<body>
<div class="pageContent">
	<div class="tabs" currentIndex="0" eventType="click"  >
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li><a href="/funcpub/portal/resource/query_sysresourse.jsp" target="ajax" rel="jbsxBox1"><span>系统资源维护</span></a></li>
					<!-- <li><a href="/funcpub/portal/resource/mananger_rescgroup.jsp" target="ajax" rel="jbsxBox2"><span>系统资源组维护</span></a></li> -->
					<li><a href="/funcpub/portal/resource/manager_user_grant_resc.jsp" target="ajax" rel="jbsxBox3"><span>用户资源授权</span></a></li>
					<li><a href="/funcpub/portal/resource/manager_role_grant_resc.jsp" target="ajax" rel="jbsxBox4"><span>角色资源授权</span></a></li>
				</ul>
			</div>
		</div>
		<div class="tabsContent">
			<div id="jbsxBox1"></div>
			<!-- <div id="jbsxBox2"></div> -->
			<div id="jbsxBox3"></div>
			<div id="jbsxBox4"></div>
		</div>
		<div class="tabsFooter">
			<div class="tabsFooterContent"></div>
		</div>
	</div>
</div>
</body>
</html>