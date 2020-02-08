<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.security.*" %>
<%@ include file="/common.jsp"%>
<%
	if (request.getParameter("logoff") != null) {
		response.sendRedirect("/logout.jsp");
		return;
	}

	// 取出线程内的认证信息(登录交易中成功登录后生成)
	UserAuthenticator loginJrafAuth2 = (UserAuthenticator) UserAuthenticator
			.getAuthenticator();
	if (loginJrafAuth2 == null) {
		response.sendRedirect("/logout.jsp");
		return;
	} else {
		// 认证信息回存到session
		UserAuthenticator.setSessionAttribute(session, loginJrafAuth2.getUser());
	}
%>
<c:set var="userInfo" value="${jrafrpu.rspPkg.rspDataMap}"/>
<c:set var="deptcode" value="${userInfo.deptcode}" scope="session"/>
<c:set var="deptname" value="${userInfo.deptname}" scope="session"/>
<!-- 取用户的子系统  -->
<sc:doPost sysName="pcmc" oprId="sm_query" action="getUserPcmcSubsys" var="subsysPkg" all="true" encoding="UTF-8"/>
<%--
<c:set var="subsyss" value="${subsysPkg.rspRcdDataMaps}"/>
 --%>
<c:set var="subsys" value="${subsysPkg.rspRcdDataMaps[0]}"/>
<html>
<body></body>
<%--<c:forEach var="subsys" varStatus="status" items="${subsyss}">
  <c:if test="${subsys.shortname == param.subsysName}">--%>
  <c:if test="${not empty subsys}">
    <c:set var="url" value="${subsys.linkurl}?shortname=${subsys.shortname}&subsysid=${subsys.subsysid}&roleid=${subsys.roleid}&pubinfourl=${subsys.pubinfourl}"/>
	<script language="javascript">
		window.location.href='<sc:fmt value="${url}"/>';
	</script>
  </c:if>
<%--  </c:if>
</c:forEach>--%>
<script language="javascript">
	Jraf.showMessageBox({
	    text: '<span class="warn">用户权限不足，请联系管理员！<br/><br/></span>',
	    onClose:function(){window.close();}
	});
</script>
</html>
