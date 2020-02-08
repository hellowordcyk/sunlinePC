<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>机构管理</title>
</head>
<body>
<div class="pageContent" >
   <div class="tabs" currentIndex="0" eventType="click"  >
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li initTab="true"><a href="/funcpub/portal/userpriv/childUser.jsp?deptid=<c:out value='${param.id }' />&isRoot=${param.isRoot}"   target="ajax" rel="deptManagerBox3"><span>机构人员</span></a></li>
				</ul>
			</div>
		</div>
		
		<div class="tabsContent">
			<div id="deptManagerBox3"></div>
		</div>
			
	</div>
</div>
</body>
</html>