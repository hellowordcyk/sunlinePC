<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ include file="/jui_tag.jsp" %>
<%
  if (request.getParameter("logoff") != null) {
	response.sendRedirect("/logout.jsp");
	return;
  }
/* 	Cookie cookie = new Cookie("usercode",request.getParameter("usercode"));
	Cookie cookie2 = new Cookie("userpwd",request.getParameter("userpwd"));
	cookie.setMaxAge(24*60*60);
	cookie2.setMaxAge(24*60*60);
	response.addCookie(cookie);
	response.addCookie(cookie2); */
	// 取出线程内的认证信息(登录交易中成功登录后生成)
	com.sunline.jraf.security.UserAuthenticator loginJrafAuth = com.sunline.jraf.security.UserAuthenticator.currentAuthenticator();
	if(loginJrafAuth==null){
	    response.sendRedirect("/logout.jsp");
	    return;
	}else{
		// 认证信息回存到session
		com.sunline.jraf.security.UserAuthenticator.setSessionAttribute(session,loginJrafAuth.getUser());
	}
%>
<!--  取用户的子系统  -->
<sc:doPost sysName="pcmc" oprId="sm_query" action="getUserPcmcSubsys" var="subsysPkg" all="true" params="subsysid=1"  encoding="UTF-8"/>
<c:set var="subsyss" value="${subsysPkg.rspRcdDataMaps}"/>

<c:if test="${empty subsyss }">
    <div style="margin: 0 auto; font-weight: bold; font-size: 18px; width: 100%; height: 200px; padding: 15px;">
    用户${username }未配置任何系统角色！
    </div>
</c:if>

<c:forEach var="subsys" varStatus="status" items="${subsyss}">
	<c:choose>
		<c:when test="${subsys.shortname == 'bdss' and param.usercode != 'admin' }">
		<c:set var="url" value="${subsys.linkurl}?shortname=${subsys.shortname}&subsysid=${subsys.subsysid}&cnname=${subsys.cnname}&roleid=${subsys.roleid}&rolename=${subsys.rolename}&pubinfourl=${subsys.pubinfourl}&csrftoken=${csrftoken}"/>
		<c:redirect url="${subsys.linkurl}" >
			<c:param name="shortname" value="${subsys.shortname}" />
			<c:param name="subsysid" value="${subsys.subsysid}" />
			<c:param name="cnname" value="${subsys.cnname}" />	
			<c:param name="pubinfourl" value="${subsys.pubinfourl}" />
			<c:param name="csrftoken" value="${csrftoken}" />
		</c:redirect>
		</c:when>
		<c:otherwise>
			<c:redirect url="/jui/index.jsp" >
				<c:param name="csrftoken" value="${csrftoken}" />
			</c:redirect>
		</c:otherwise>
	</c:choose>
</c:forEach>