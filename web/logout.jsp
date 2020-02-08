<%@page import="com.sunline.jraf.cache.ssologin.UserTokenCacheService"%>
<%@page import="com.sunline.jraf.conf.BimisConf"%>
<%@page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sunline.jraf.services.*"%>
<%@page import="com.sunline.jraf.conf.bimis.*"%>
<%@page import="com.sunline.jraf.security.UserAuthenticator"%>
<%
boolean ssologin = BimisConf.isSSOLogin();
if(ssologin){
	UserAuthenticator jraf_auth = (UserAuthenticator) session.getAttribute("jraf_auth");
	if(jraf_auth != null){
		String token = UserTokenCacheService.getToken(jraf_auth.getUserID());
		String stoken = (String)session.getAttribute("csrftoken");
		if(token != null && stoken != null && token.equals(stoken)){
			UserTokenCacheService.cleanTokenCache(jraf_auth.getUserID());
		}
	}
}
session.invalidate();
PortalConf pc = PortalConf.getInstance();
String url = "";
String basePath = "";
try {
    String path = request.getContextPath();
    basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

    url = pc.getLoginUrl();
    url = url.substring(url.lastIndexOf("/")+1);
    if (url == null || "".equals(url)) {
        url = "login.jsp";
    } 
    url = basePath + url;
} catch (Exception e) {
    e.printStackTrace();
}
//response.sendRedirect(manager.getConf().getBaseUrl());
response.sendRedirect(url);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%--@include file="/common.jsp"--%>
<link rel="stylesheet" type="text/css" href="/common/skins/theme/style-custom.css">
<title>退出系统</title>
</head>
<body>
<%=basePath %>
<div class="warning-content">
     <div class="warning-form">
         <div class="warning-form-top">
             <div class="warning-info"></div>
             <div class="warning-text">
                 <span class="warning">会话已过期</span>
                 <p>系统因长时间未访问或用户点击&lt;退出系统&gt;按钮，已登出系统。</p>
             </div>
             <div class="warning-button">
                 <input id="loginId" class="button" type="button" value="重新登录(10)" onclick="loginAgain();"/>
                 <input class="button" type="button" value="关闭" onclick="window.close();"/>
             </div>
         </div>
     </div>
</div>
</body>
<script type="text/javascript" defer="defer">
var g_count = 10;
var oInterval = window.setInterval(function() {
    if (g_count == 0) {
        window.clearInterval(oInterval);
        document.getElementById("loginId").click();
    }
    g_count --;
    document.getElementById("loginId").value = "重新登录("+g_count+")";
}, 1000);

function loginAgain() {
    if(window.top != window.self){
        window.top.location.href='<%=url%>';
    }else{
        window.location.href='<%=url%>';
    }
}
</script>
</html>