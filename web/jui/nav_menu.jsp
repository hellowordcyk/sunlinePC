<%@page import="com.sunline.jraf.util.Crypto"%>
<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html>
<sc:doPost sysName="funcpub" oprId="initMenu" action="initTopNavMenu" scope="request" var="rspPkg" ></sc:doPost>

	<c:forEach var="topnavmenu" items="${rspPkg.rspRcdDataMaps}"  varStatus="menuStatus">
		<li onclick="changeTopNavMenu(this)"><input type="hidden" value="${topnavmenu.menuid}">
			<c:choose>
				<c:when test="${not empty topnavmenu.linkurl}">
					<c:choose>
						<c:when test="${not empty topnavmenu.displaytype and topnavmenu.displaytype eq '03'}">
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>" target="_blank" rel="${topnavmenu.rel}">
						</c:when>
						<c:when test="${not empty menu.displaytype and menu.displaytype eq '02'}">
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>" target="navTab"  external="true" rel="${topnavmenu.rel}">
						</c:when>
						<c:otherwise>
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>" target="navTab" rel="${topnavmenu.rel}">
						</c:otherwise>
					</c:choose>
				</c:when>
				<c:otherwise>
					<a  href="#">
				</c:otherwise>
			</c:choose>
			${topnavmenu.menuname}</a>
		</li>
	</c:forEach>
