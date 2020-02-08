<%@page import="java.util.HashMap"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<%@page import="com.sunline.jraf.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>三级菜单</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" href="/common/func-css/menu-list/menu-list.css" />
</head>
<sc:doPost sysName="funcpub" oprId="initMenu" action="getMenu" scope="request" var="rspPkg" all="true"></sc:doPost>
<c:set var="iconStyle" value="${rspPkg.rspDataMap.iconStyle}"/>
<body>
<div class="pageContent">
<c:choose>
	<c:when test='${"1" ne iconStyle }'>
	<div class="menuNavTab">
		<c:if test="${empty rspPkg.rspRcdDataMaps}">
			<jsp:include page="/jui/developed.jsp"></jsp:include>
		</c:if>
		<c:forEach var="menu" items="${rspPkg.rspRcdDataMaps}"  varStatus="menuStatus">
			<div class="${'2' eq iconStyle ? 'menuList' : 'menuFullList'}">
				<c:if test='${menu.isleaf == "0"}'>
					<a href="/jui/menu-list.jsp?menuid=${menu.menuid}" rel="menu-list_${menu.menuid}" title="${menu.menuname}" target="navTab" >
				</c:if>
				<c:if test='${menu.isleaf == "1" && (empty menu.linkurl || menu.linkurl == "")}'>
					<a href="/jui/developed.jsp"  rel="developed"  target="navTab" title="${menu.menuname}" fresh="true">
				</c:if>
				<c:if test='${menu.isleaf == "1" && not empty menu.linkurl && menu.linkurl != ""}'>
					<c:choose>
						<c:when test="${not empty menu.displaytype and menu.displaytype eq '03'}">
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("menu") ).get("linkurl") )%>" onclick="menuVisitLog('${menu.linkurl}','${menu.menuid}','${menu.menuname }');"   title="${menu.menuname}" target="_blank" rel="${menu.rel}">
						</c:when>
						<c:when test="${not empty menu.displaytype and menu.displaytype eq '02'}">
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("menu") ).get("linkurl") )%>" onclick="menuVisitLog('${menu.linkurl}','${menu.menuid}','${menu.menuname }');"  title="${menu.menuname}" target="navTab"  external="true" rel="${menu.rel}">
						</c:when>
						<c:otherwise>
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("menu") ).get("linkurl") )%>" onclick="menuVisitLog('${menu.linkurl}','${menu.menuid}','${menu.menuname }');"  title="${menu.menuname}" target="navTab" rel="${menu.rel}">
						</c:otherwise>
					</c:choose>
				</c:if>
					<div class="menuIcon">
						<c:if test='${empty menu.imgurl || menu.imgurl == "" }'>
							<c:if test="${'2' eq iconStyle }">
							<span>${fn:substring(menu.menuname,0,1)}</span>
							</c:if>
							<c:if test="${'3' eq iconStyle }">
							<span>${menu.menuname}</span>
							</c:if>
						</c:if>	
						<c:if test='${not empty menu.imgurl && menu.imgurl != "" }'>
							<img src="${menu.imgurl}"/>
						</c:if>	
					</div>
					<c:if test="${'2' eq iconStyle }">
						<div class="menuText"><span>${menu.menuname}</span></div>
					</c:if>
				</a>
			</div>
		</c:forEach>
	</div>
	</c:when>
	<c:otherwise>
	<div class="menu-index">
		<c:if test="${empty rspPkg.rspRcdDataMaps}">
			<jsp:include page="/jui/developed.jsp"></jsp:include>
		</c:if>
	
		<c:forEach var="menu" items="${rspPkg.rspRcdDataMaps}"  varStatus="menuStatus">
			<div class="menu3-list">
				<c:if test='${menu.isleaf == "0"}'>
					<a href="/jui/menu-list.jsp?menuid=${menu.menuid}" rel="menu-list_${menu.menuid}" target="navTab" >
				</c:if>
				<c:if test='${menu.isleaf == "1" && (empty menu.linkurl || menu.linkurl == "")}'>
					<a href="/jui/developed.jsp"  rel="developed"  target="navTab" title="${menu.menuname}" fresh="true">
				</c:if>
				<c:if test='${menu.isleaf == "1" && not empty menu.linkurl && menu.linkurl != ""}'>
					<c:choose>
						<c:when test="${not empty menu.displaytype and menu.displaytype eq '03'}">
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("menu") ).get("linkurl") )%>" onclick="menuVisitLog('${menu.linkurl}','${menu.menuid}','${menu.menuname }');"  target="_blank" rel="${menu.rel}">
						</c:when>
						<c:when test="${not empty menu.displaytype and menu.displaytype eq '02'}">
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("menu") ).get("linkurl") )%>" onclick="menuVisitLog('${menu.linkurl}','${menu.menuid}','${menu.menuname }');"  target="navTab" external="true" rel="${menu.rel}">
						</c:when>
						<c:otherwise>
							<a href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("menu") ).get("linkurl") )%>" onclick="menuVisitLog('${menu.linkurl}','${menu.menuid}','${menu.menuname }');"  target="navTab" rel="${menu.rel}">
						</c:otherwise>
					</c:choose>
				</c:if>
					<div class="listicon">
						<c:if test='${empty menu.imgurl || menu.imgurl == "" }'>
							<img src="/common/func-images/menu-icon/icon2.png"/>
						</c:if>	
						<c:if test='${not empty menu.imgurl && menu.imgurl != "" }'>
							<img src="${menu.imgurl}"/>
						</c:if>	
					</div>
					<div class="listicon-text"><span>${menu.menuname}</span></div>
				</a>
			</div>
		</c:forEach>
		
	</div>
	
	</c:otherwise>
</c:choose>
</div>
</body>
</html>
<script type="text/javascript">
<c:if test='${"1" ne iconStyle }'>
/**
 * 随机颜色
 */
$(function(){
	if(ismenuVisitLog) {
		$("")
	}
	var menuIcon = $(".menuIcon",navTab.getCurrentPanel()).find("span").closest(".menuIcon");
	var iconBgColor = ['#1B7B91','#35BDF7','#98D88E','#FDCE66'];
	if(null != menuIcon && menuIcon.length>0){
		for(var i=0;i<menuIcon.length;i++){
			$(menuIcon[i]).css("background-color",iconBgColor[i%4]);
		}
	}
});
</c:if>
</script>