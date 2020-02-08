<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/governor/common/common.jsp"%>
<%

/* Cookie cookie = new Cookie("usercode",request.getParameter("usercode"));
//Cookie cookie2 = new Cookie("userpwd",request.getParameter("userpwd"));
cookie.setMaxAge(24*60*60);
cookie2.setMaxAge(24*60*60);
response.addCookie(cookie);
response.addCookie(cookie2); */
// 取出线程内的认证信息(登录交易中成功登录后生成)
com.sunline.jraf.security.UserAuthenticator loginJrafAuth2 = (com.sunline.jraf.security.UserAuthenticator) com.sunline.jraf.security.UserAuthenticator.getAuthenticator();
if(loginJrafAuth2==null){
    response.sendRedirect("/governor/common/logout.jsp");
    return;		
}else{
	// 认证信息回存到session
	com.sunline.jraf.security.UserAuthenticator.setSessionAttribute(session,loginJrafAuth2.getUser());
}
%>
<html>
<head>
<Meta http-equiv="Pragma" Content="No-cach">
<Meta http-equiv="Expires" Content="0">
<title>平台配置管理系统</title>
</head>
<frameset rows="52,*,28" frameborder="NO" border="0" framespacing="0">
  <frame src="/governor/common/outlookMenu.jsp?pubinfourl=/governor/common/pubtopinfo.jsp?initname=<c:out value='${initname }' />"; 
         name="topFrame" scrolling="auto" noresize/>
  <frame src="/governor/common/homePage.jsp" name="bodyFrame_all" scrolling="no" noresize>
  <frame src="/governor/common/copyright.jsp" scrolling="no" noresize>
</frameset>
</html>