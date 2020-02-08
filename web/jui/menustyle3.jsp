<%@page import="com.sunline.jraf.util.Crypto"%>
<%@page import="java.util.HashMap"%>
<%@ page import="com.sunline.jraf.security.UserAuthenticator"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="com.sunline.funcpub.util.SysConstants"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html>
<%
	String sitename = BimisConf.getSiteName();
	String bankpic = BimisConf.getBankpic();
	String footer = BimisConf.getMainFooter();

    request.setAttribute("sitename", sitename);
    request.setAttribute("bankpic", bankpic);
    request.setAttribute("footer", footer);
    
	if (request.getParameter("logoff") != null) {
		response.sendRedirect("/logout.jsp");
		return;
	}
    
	response.setHeader("Cache-Control", "no-cache");  
	response.setHeader("Pragma", "no-cache");  
	response.setDateHeader("Expires", 0);  
%>
<sc:doPost sysName="funcpub" oprId="initMenu" action="initTopNavMenu"
	scope="request" var="rspPkg"></sc:doPost>

<div class="container-fluid">

	<nav class="navbar navbar-default navbar-fixed-top">
		<div class="navbar-header" id="headerheight">
			<a id="indexlogo" class="navbar-brand">${sitename}</a>
		</div>
		<div id="navbar" class="navbar-collapse collapse">
			<div class="sun-toggle" id="sun_toggle">
				<i class="fa fa-chevron-right"></i>
			</div>
				<!-- user dropdown starts -->
				<ul class="nav navbar-nav hidden" id="navMenu" ></ul>
		   		<ul class="nav navbar-nav hidden" id="navDropdown"></ul>
		   		
			<!-- 顶层一级菜单 -->
			<ul class="nav navbar-nav hidden" id="navMenu">
				<c:forEach var="topnavmenu" items="${rspPkg.rspRcdDataMaps}"
					varStatus="menuStatus">
					<li onclick="changeTopNavMenu(this)"><input type="hidden"
						value="${topnavmenu.menuid}"> <c:choose>
							<c:when test="${not empty topnavmenu.linkurl}">
								<c:choose>
									<c:when
										test="${not empty topnavmenu.displaytype and topnavmenu.displaytype eq '03'}">
										<a
											href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>"
											target="_blank" rel="${topnavmenu.rel}">
									</c:when>
									<c:when
										test="${not empty menu.displaytype and menu.displaytype eq '02'}">
										<a
											href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>"
											target="navTab" external="true" rel="${topnavmenu.rel}">
									</c:when>
									<c:otherwise>
										<a
											href="<%=Crypto.encodeUrl(request,( (HashMap<String,String>)pageContext.getAttribute("topnavmenu") ).get("linkurl") )%>"
											target="navTab" rel="${topnavmenu.rel}">
									</c:otherwise>
								</c:choose>
							</c:when>
							<c:otherwise>
								<a href="#">
							</c:otherwise>
						</c:choose> ${topnavmenu.menuname}</a></li>
				</c:forEach>
			</ul>
			<!--  -->

			<ul class="nav navbar-nav navbar-right">
				<li class=" hidden-xs "><a class="double-down hidden"><i
						class="fa fa-angle-double-down"></i>&nbsp;<span
						class="badge navMenusize">0</span></a></li>
				<li class="hidden-xs"><a id="toggle"><i
						class="fa fa-expand"></i>&nbsp;</a></li>
				<li><a class="dropdown-toggle" data-toggle="dropdown"> <i
						class="glyphicon glyphicon-user"></i>&nbsp; <span
						class="currentUser"></span> <span class="caret"></span>
				</a>
					<ul class="dropdown-menu">
						<li><a href="/jui/index.jsp?csrftoken=${csrftoken}"> <i
								class="jf-btn-home"></i>&nbsp;&nbsp;首页
						</a></li>
						<li class="user"><a
							href="/funcpub/public/userinfo/userInfoManager.jsp" title="个人信息"
							target="dialog" maxable=false mask=true width="750" height="450">
								<i class="jf-btn-mine"></i>&nbsp;&nbsp;个人信息
						</a></li>
						<li class="user" id="changeRole" style="display: none;"><a
							onclick="changeRole();"> <i class="jf-btn-switch"></i>&nbsp;&nbsp;切换角色
								<input type="hidden" id="currentRoleid_id">
						</a></li>
						<li class="user">
							<!-- 从后台常量类取值 --> <input type="hidden" id="userFavorMenu_id"
							value="<%=SysConstants.USER_FAVOR_ID%>" /> <a
							onclick="deployMenu();"> <i class="jf-btn-common"></i>&nbsp;&nbsp;常用功能配置
						</a>
						</li>
						<li class="user"><a href="/jui/lockScreen.jsp" title="锁屏"
							target="dialog" close="false" maxable="false" width="450"
							height="250"> <i class="jf-btn-screen"></i>&nbsp;&nbsp;锁屏
						</a></li>

						<sc:doPost sysName="funcpub" oprId="themeActor"
							action="queryTheme" scope="request" all="false" var="rspPkg" />
						<c:if test="${fn:length(rspPkg.rspRcdDataMaps) gt 1}">
							<li id="header"><a href="#"><i class="jf-btn-skin"
									aria-hidden="true"></i>&nbsp;&nbsp;换肤：</a>
								<ul class='themeList' id='themeList'>
									<c:forEach var="item" items="${rspPkg.rspRcdDataMaps }">
										<li theme='${item.theme}'><i class='jf-btn-${item.theme}'></i></li>
									</c:forEach>
								</ul></li>
						</c:if>

						<li class="divider"></li>
						<li class="exit"><a href="/logout.jsp"> <i
								class="jf-btn-sign-out"></i>&nbsp;&nbsp;退出
						</a></li>
					</ul></li>
			</ul>
		</div>
	</nav>
</div>

<!-- 左侧导航栏 -->
<div id="leftside">
	<div id="sidebar_s">
		<div class="collapse">
			<div class="toggleCollapse"></div>
		</div>
	</div>
	<div id="sidebar">
		<div class="toggleCollapse">
			<h2>主菜单</h2>
		</div>

		<div class="accordion" fillSpace="sidebar">
			<ul id="folderNavMenu"></ul>
		</div>
	</div>
</div>
<!--  -->

<script>
	$(function() {
		$("#navDropdown").ajaxUrl({
			type : "POST",
			url : "/jui/nav_top_menu.jsp",
			data : null,
			callback : function(resData) {
				//判断角色一级菜单
				var li = $(resData).find("li");
				if (!li) {
					alertMsg.warn("未分配任意角色菜单权限！请联系管理员分配！\n 点击确认按钮将退出系统！", {
						okCall : function() {
							location.href = "/login.jsp";
						}
					});
				}
				initTopMenu();
				doubledown($("#navDropdown"));
				bindEvent();
				inituserInfo();
			}
		});
	});
	function inituserInfo(){
		if (switchRole) {
			$("#changeRole").show();
			$(".currentRole").show();
		} else {
			$("#changeRole").hide();
			$(".currentRole").hide();
		}
		//控制满屏效果是否显示
		if(document.fullscreenEnabled == true || document.webkitFullscreenEnabled == true || document.mozFullScreenEnabled == true || document.msFullscreenEnabled == true){
			$("#toggle").show(0).click(function () {
				screenfull.toggle($('#body')[0]);
				$(this).find('i').toggleClass('fa-compress');
			});
		}
	}
	function bindEvent(){
		/* 横向菜单鼠标经过事件*/
		 $("#navDropdown").on("mouseover"," .dropdown-menu li",function() {
			 	$("ul",$(this)).first().show(0);
			 	$("ul",$(this)).first().css("left", $(this).parent().width());
			}).on("mouseout",".dropdown-menu li",function() {
				$("ul",$(this)).first().hide(0);
			});
		//绑定切换皮肤方法
		$(".themeList li").click(function(){
		   updateTheme($(this).attr("theme"));
		});
	}
	
	/* 初始化top菜单*/
	function initTopMenu(menuid) {
		$('#navDropdown .dropdown-menu >li').remove();
		initMenu(menuid);
	}

 	function initMenu(menuid) {
		var currentRole = $("#currentRoleid_id").val();

		if (menuid == null || menuid == "") {
			getMenuStyle();
			menuid = $("#navDropdown li:first input").val();
			$(".sun-toggle").hide();
			$(".accordion").hide();
			$("#sidebar").hide();
		}
		if (typeof (Jraf.menuCacheMap[menuid]) === "undefined"
				|| Jraf.menuCacheMap[menuid].length == 0) {
			initMenuCache(menuid, currentRole);
		}
		var childCacheArr_one = Jraf.menuCacheMap[menuid];
		for (var i = 0; childCacheArr_one && i < childCacheArr_one.length; i++) {
			var childCacheMap_one = childCacheArr_one[i];
			var menuid = childCacheMap_one["menuid"];
			var menuname = childCacheMap_one["menuname"];
			var isleaf = childCacheMap_one["isleaf"];
			var linkurl = childCacheMap_one["linkurl"];
			var displaytype = childCacheMap_one["displaytype"];
			var rel = "";
			var onclick = "";
			var target = "navTab";
			var external = null;
			if (displaytype && displaytype == "03") {
				target = "_blank";
			}
			if (displaytype && displaytype == "02") {
				external = "true";
			}
			if ("1" != isleaf) {
				if (linkurl != null && "" != linkurl) {
					rel = linkurl.substring(linkurl.lastIndexOf("/") + 1,
							linkurl.lastIndexOf("."));
					if (linkurl.indexOf("sysName") > 0) {
						$.ajax({
							url : "/jui/CryptoUrl.jsp",
							data : {
								url : linkurl
							},
							async : false,
							success : function(data) {
								linkurl = data;
							}
						});
					}
				}
				var html = "<li><a title=\"" + menuname + "\" ";
				if (linkurl) {
					html += "href=\"" + linkurl + "\" target=\"" + target
							+ "\" rel='" + rel + "'";
					if (external) {
						html += "external=\"true\" ";
					}
				}
				html += ">";
				html += menuname
						+ "<span class='right-i down'></span></a><ul id='"+menuid+"'></ul></li>";
				$('#navDropdown .addContent .dropdown-menu').append(html);
				initChildFolderMenu(menuid);
				continue;
			} else {
				if (linkurl != null && "" != linkurl) {
					rel = linkurl.substring(linkurl.lastIndexOf("/") + 1,
							linkurl.lastIndexOf("."));
				} else {
					linkurl = "/jui/developed.jsp";
					rel = "developed";
				}
				if (linkurl.indexOf("sysName") > 0) {
					$.ajax({
						url : "/jui/CryptoUrl.jsp",
						data : {
							url : linkurl
						},
						async : false,
						success : function(data) {
							linkurl = data;
						}
					});
				}
				if (ismenuVisitLog && "1" == isleaf) {
					onclick = "menuVisitLog('" + encodeURI(linkurl) + "','"
							+ menuid + "','" + menuname + "');";
				}
				var html = "<li id='"+menuid+"'><a href=\"" + linkurl
						+ "\" target=\"" + target + "\" onclick=\"" + onclick
						+ "\" ";
				if (external) {
					html += " external=\"true\" ";
				}
				html += "rel=\"" + rel + "\" title=\"" + menuname + "\">";
				html += menuname + "</a></li>";
				$('#navDropdown .addContent .dropdown-menu').append(html);
			}
		}
		initUI($("#navDropdown"));
		if (!hasInitHomePageInfo) {
			initHomePageInfo();//初始化首页信息 
			hasInitHomePageInfo = true; // 首页信息只加载一次
		}
	} 
 	//初始化树型子菜单
 	function initChildFolderMenu(pmenuid) {
 		var currentRole = $("#currentRoleid_id").val();

 		//判断该父菜单下的子菜单是否已经缓存，如未缓存则初始化缓存
 		if (typeof (Jraf.menuCacheMap[pmenuid]) === "undefined"
 				|| Jraf.menuCacheMap[pmenuid].length == 0) {
 			initMenuCache(pmenuid, currentRole);
 		}
 		var childCacheArr_one = Jraf.menuCacheMap[pmenuid];
 		for (var i = 0; childCacheArr_one && i < childCacheArr_one.length; i++) {
 			var childCacheMap_one = childCacheArr_one[i];
 			var menuid = childCacheMap_one["menuid"];
 			var menuname = childCacheMap_one["menuname"];
 			var isleaf = childCacheMap_one["isleaf"];
 			var linkurl = childCacheMap_one["linkurl"];
 			var displaytype = childCacheMap_one["displaytype"];
 			var rel = "";
 			var onclick = "";
 			var target = "navTab";
 			var external = null;
 			if(displaytype && displaytype == "03"){
 				target = "_blank";
 			}
 			if(displaytype && displaytype == "02"){
 				external = "true";
 			}
 			if ("1" != isleaf) {
 				if (linkurl != null && "" != linkurl) {
 					rel = linkurl.substring(linkurl.lastIndexOf("/") + 1, linkurl.lastIndexOf("."));
 					if (linkurl.indexOf("sysName") > 0) {
 						$.ajax({
 							url : "/jui/CryptoUrl.jsp",
 							data : {url : linkurl},
 							async : false,
 							success : function(data) {
 								linkurl = data;
 							}
 						});
 					}
 				} 
 				
 				var html ="<li><a class=\"side-two\" ";
 				if(linkurl){
 					html += "href=\""+linkurl+"\" target=\""+target+"\" rel=\""+rel+"\""; 
 					if(external){
 						html += " external=\"true\" ";
 					}
 				}
 				html += ">";
 				html += menuname + "<span class=\"right-i down\"></span></a><ul style=\"display:none\" id=\""+menuid+"\"></ul></li>"; 
 			  	$("#" + pmenuid).append(html);
 			  	initChildFolderMenu(menuid);
 			} else {
 				if (linkurl != null && "" != linkurl) {
 					rel = linkurl.substring(linkurl.lastIndexOf("/") + 1,
 							linkurl.lastIndexOf("."));
 				} else {
 					linkurl = "/jui/developed.jsp";
 					rel = "developed";
 				}
 				if (linkurl.indexOf("sysName") > 0) {
 					$.ajax({
 						url : "/jui/CryptoUrl.jsp",
 						data : {
 							url : linkurl
 						},
 						async : false,
 						success : function(data) {

 							linkurl = data.trim();
 						}
 					});
 				}
 				if (ismenuVisitLog && "1" == isleaf) {
 					onclick = "menuVisitLog('" + encodeURI(linkurl) + "','"+ menuid + "','" + menuname + "');";
 				}
 				var html = "<li><a href=\""+linkurl+"\" target=\""+target+"\" onclick=\""+onclick+"\" rel=\""+rel+"\"";
 				if(external){
 					html += " external=\"true\" ";
 				}	
 				html += " title=\""+menuname+"\">";
 				html += menuname + "</a></li>";
 				$("#" + pmenuid).append(html);
 			}
 		}
 	}
 	function changeTopMenu(obj) {
		var menuid = $(obj).find("input").val();
		$(obj).addClass("addContent");
		$(obj).siblings().removeClass("addContent"); 
		initTopMenu(menuid);
		
		var liLength =  $(obj).find('ul').children().length
		if(!liLength){
			$(obj).find('ul').hide();
		}
	}
 	/* 初始化top菜单*/

	function initTopMenu(menuid) {
		$('#navDropdown .dropdown-menu >li').remove(); 
		initMenu(menuid);
	}
</script>





