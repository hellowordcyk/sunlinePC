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
<title>根节点机构人员管理</title>
</head>

<body>
<div class="pageContent" >
   <div class="tabs" currentIndex="1" eventType="click"  >
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li onclick="toDept()">
                        <a href="#" rel="deptManagerBox1">
                           <span>所有机构</span>
                        </a>
                    </li>
					 <li onclick="toUser();">
                        <a href="#" rel="deptManagerBox2">
                            <span>所有人员</span>
                        </a>
                    </li>
				</ul>
			</div>
		</div>
		
		<div class="tabsContent">
			<div id="deptManagerBox1"></div>
			<div id="deptManagerBox2"></div>
		</div>
		
		
			
	</div>
</div>
</body>
<script type="text/javascript">
$(function(){
	//toUser();
	toDept();
	
});

function toDept(){
	$(".tabs").attr("currentIndex", "0");
	var url = "/funcpub/portal/organization/deptManagerRootDept.jsp";
	$("#deptManagerBox1").loadUrl(url,null, null);
}

function toUser(){
	$(".tabs").attr("currentIndex", "1");
	var url = "/funcpub/portal/organization/deptManagerRootUser.jsp";
	$("#deptManagerBox2").loadUrl(url,null, null);
}
</script>
</html>