<%@page import="java.util.HashMap"%>
<%@page import="com.sunline.jraf.util.Crypto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html>
<sc:doPost sysName="funcpub" oprId="initMenu" action="initTopNavMenu" scope="request" var="rspPkg" ></sc:doPost>

<c:forEach var="topnavmenu" items="${rspPkg.rspRcdDataMaps}"  varStatus="menuStatus">
	<li class=" dropdown"  onclick="changeTopMenu(this)">
		<input type="hidden" value="${topnavmenu.menuid}">
		<c:choose>
			<c:when test="${not empty topnavmenu.linkurl}">
				<c:choose>
					<c:when test="${not empty topnavmenu.displaytype and topnavmenu.displaytype eq '03'}">
						<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>" target="_blank" rel="${topnavmenu.rel}"
							class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
					</c:when>
					<c:when test="${not empty menu.displaytype and menu.displaytype eq '02'}">
						<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>" target="navTab"  external="true" rel="${topnavmenu.rel}"
							class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
					</c:when>
					<c:otherwise>
						<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>" target="navTab" rel="${topnavmenu.rel}"
							class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>
				<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">
			</c:otherwise>
		</c:choose>
			${topnavmenu.menuname} 
			<c:if test="${topnavmenu.isleaf eq 0}">
			 <span class="caret"></span>
			</c:if>
		</a>
		<ul class='dropdown-menu' ></ul>
	</li>
</c:forEach>
