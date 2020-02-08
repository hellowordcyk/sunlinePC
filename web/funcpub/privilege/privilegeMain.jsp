<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
	<title>资源权限管理</title>
</head>
<sc:doPost sysName="funcpub" oprId="privilegeManager" action="getSubsysList"  var="subsysList"/>
<body>
<div class="pageContent">
	<div class="tabs" currentIndex="0" eventType="click">
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<c:forEach items="${subsysList.rspRcdDataMaps }" var="subsys" varStatus="index">
						<c:choose>
							<c:when test="${index.index eq 0 }">
								<li initTab="true"><a href="/funcpub/privilege/privilegeSearch.jsp?subsysCode=${subsys.shortname }" target="ajax" rel="privDiv${subsys.shortname }"><span>${subsys.cnname}</span></a></li>
							</c:when>
							<c:otherwise>
								<li><a href="/funcpub/privilege/privilegeSearch.jsp?subsysCode=${subsys.shortname }" target="ajax" rel="privDiv${subsys.shortname }"><span>${subsys.cnname}</span></a></li>
							</c:otherwise>
						</c:choose>
					</c:forEach>
				</ul>
			</div>
		</div>
		<div class="tabsContent" layoutH="60">
			<c:forEach items="${subsysList.rspRcdDataMaps }" var="subsys" varStatus="index">
			<div id="privDiv${subsys.shortname }"></div>
			</c:forEach>
		</div>
		<div class="tabsFooter">
			<div class="tabsFooterContent"></div>
		</div>
	</div>
</div>
</body>
</html>