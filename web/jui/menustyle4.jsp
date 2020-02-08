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
<sc:doPost sysName="funcpub" oprId="initMenu" action="initTopNavMenu" scope="request" var="menuPkg"></sc:doPost>
<style>
	.jraf-menu a{
		position: relative;
		padding: 10px 10px;
		display:block;
	}
	.jraf-menu a i{
		margin-right: 10px;
	}
	.title-first i{
		color: #5D82C1;
	}
	.title-first .title{
		color: #555;
		font-size: 14px;
	}
	.jraf-menu a span.more{
		position: absolute;
	    right: 8px;
	    top: 18px;
	    display: inline-block;
        width: 0;
    	height: 0;
    	border-right: 6px dashed;
    	border-top: 6px solid transparent;
    	color: #e2e2e2;
	}
	.jraf-menu li{
		position: relative;
	}
	.jraf-menu ul{
		width: 186px;
		position: absolute;
		left: 184px;
		/* top: 0px; */
		color: #333 !important;
		list-style: none;
	    background-color: #fff;
	    -webkit-background-clip: padding-box;
	    background-clip: padding-box;
	    border: 1px solid #ccc;
	    border: 1px solid rgba(0,0,0,.15);
	    border-radius: 4px;
	    -webkit-box-shadow: 0 6px 12px rgba(0,0,0,.175);
	    box-shadow: 0 6px 12px rgba(0,0,0,.175);
    }
    #sidebar a{
    	color: #555;
    	font-size: 14px;
    }
    .dropdown-menu {  
    	left: 26px;
	}
	#navTab {
    	padding-left: 10px;
    }
    #footer {
    	background: #f0f0f0;
    	padding: 0 10px;
    }
    #leftside,#container{
    	top: 0px;
    }
    .title-first:hover{
    	background: #5D82C1;
    	color: #fff !important;
    }
    .title-first:hover i,
    .title-first:hover .title{
    	color: #fff !important;
    
    }
    .title-second{
    	position: relative;
    	
    }
    .title-second i{
    	position: absolute;
    	right: 0px;
    	top: 13px;
    }
    .jraf-menu-item ul li a:hover{
    	background: #f3f3f3;
    }
    .dropdown-toggle.currentUser{
    	padding: 10px 0px;
    }
    .themeList li{
    	float: left;
    	padding: 0 3px;
    }
</style>
<!-- 左侧导航栏 -->
<div id="leftside">
	<div id="sidebar" style="overflow:inherit;background:#fff;">
		<!-- <div class="accordion" fillSpace="sidebar" style="overflow:inherit;"> -->
		<div id="scrollmenu">
			<!-- logo -->
			<div class="menulogo" style="height:50px;width:100%;background:url('/jui/themes/css/images/leftlogo.png') no-repeat center center;
				background-size: 80%;
			">
			</div>
			<!-- 常用配置信息 -->
			<ul class="nav" style="height:40px;position:relative;">
				<div style="position:absolute;width:24px;height:24px;background:#EBF0F8;border-radius:50%;left: 4px;top:6px;z-index:1;
					text-align:center;line-height:24px;"
					onclick="changeMenuScale(this)"
				>
					<i class="fa fa-angle-left fa-lg"></i>
				</div>
				<li>
					<a class="dropdown-toggle currentUser" data-toggle="dropdown" style="width: 150px;margin-left: 30px;background: #5D82C1;border-radius:3px;text-align:center;color:#fff;">   
					</a>
					<ul class="dropdown-menu">
						<li><a href="/jui/index.jsp?csrftoken=${csrftoken}"> <i
								class="jf-btn-home"></i>&nbsp;&nbsp;首页
						</a></li>
						<li class="user"><a onclick="personInfo();">
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
								class="jf-btn-out"></i>&nbsp;&nbsp;退出
						</a></li>
					</ul>
				</li>
			</ul>
			
			<!--动态数据获取-->		
			<ul class="jraf-menu">
			<c:forEach var="topnavmenu" items="${menuPkg.rspRcdDataMaps}" varStatus="menuStatus">
					<li class="jraf-menu-item" menuid="${topnavmenu.menuid}">
						<!-- 一级菜单（不会发生跳转） -->
						<a class="title-first">
							<!-- 图标icon -->
							<i class="fa ${topnavmenu.imgurl}"></i>
							<span class="title">${topnavmenu.menuname}</span>
							<span class="more"></span>
						</a>
						 <ul style="display: none;" id="${topnavmenu.menuid}" class=""></ul> 
					</li>
			</c:forEach>									
			</ul>
		</div>
	</div> 
</div>


<script>

$(function(){
	$('body').removeClass('initialise');
	doubledown($("#navMenu"));
	initLayout();
	/**
	* 左侧菜单
	*/
	$(".themeList li").click(function(){
	    updateTheme($(this).attr("theme"));
	});
	if (!hasInitHomePageInfo) {
		initHomePageInfo();//初始化首页信息 
		hasInitHomePageInfo = true; // 首页信息只加载一次
	}
	inituserInfo();
	$(".jraf-menu-item").hover(function(){
		var leftDistance = $("#sidebar").width()+'px';
		$(this).find('>ul').css({'left':leftDistance,'top':0}).show();
		var offset = $(this).offset();
		var offsetTop = offset.top
		var htmlHeight = document.documentElement.clientHeight || document.body.clientHeight;
		initMenu($(this))
		if(htmlHeight-offsetTop-40<$(this).find('>ul').height()){			
			var h = htmlHeight-offsetTop-40
			var height = h- $(this).find('>ul').height()+'px'
			$(this).find('>ul').css({'top':height}) 
			var sech = $(this).find('>ul').find('li').find('ul').height()+'px'
			$(this).find('>ul').find('li').find('ul').css({'bottom':0}) 
		}else{
			$(this).find('>ul').css({'top':0})
			$(this).find('>ul').find('li').find('ul').css({'top':0}) 
		}
	},function(){		
		$(this).find('>ul').hide();
	})
	$(".jraf-menu-item ul ").click(function(){
		$(this).hide();
	})
	loadAllMenu();
});
function personInfo(){
	$.pdialog.open('/funcpub/public/userinfo/userInfoManager.jsp','userInfoManager','个人信息',{width:'750',height:'450'})
}
function inituserInfo(){
	if (switchRole) {
		$("#changeRole").show();
		$(".currentRole").show();
	} else {
		$("#changeRole").hide();
		$(".currentRole").hide();
	}
}
function bindHover(topMenu){
	$(topMenu).find("li").hover(function(){		
		$(this).find('>ul').show();
	},function(){	
		$(this).find('>ul').hide();
	}) 
}
function changeMenuScale(e){
	if($(e).find('i').hasClass('fa-angle-right')){
		$(".menulogo").css({'background-image':'url(/jui/themes/css/images/leftlogo.png)'})
		$(".dropdown-toggle").show();
		$(".title-first").find("span").show();
		$("#sidebar").width(186);
		$("#container").css({'padding-left':'187px'})
		$(e).find('i').removeClass('fa-angle-right').addClass('fa-angle-left')
		return;
	}
	$(".menulogo").css({'background-image':'url(/jui/themes/css/images/leftlogomark.png)'})
	$(".dropdown-toggle").hide();
	$(".title-first").find("span").hide();
	$("#sidebar").animate({'width':'40px'},200);
	$("#container").animate({'paddingLeft':'40px'},200)
	$(e).find('i').removeClass('fa-angle-left').addClass('fa-angle-right')
}
function loadMenu(topmenu){
	$(".jraf-menu-item").children("ul").each(function(i,item){
		initChildMenuCache($(this).attr("id"));
	});
}
/**
 * 加载左侧菜单
 */
function initMenu(topmenu){
	$(topmenu).children("ul").each(function(i,item){
		var length = $(this).find("li").length;
		if( length== undefined ||  length ==0 ){
			initFolderMenu($(this));
		}
	});
}
function initFolderMenu(topMenu){
	var currentRole = $("#currentRoleid_id").val();
	 var pmenuid = topMenu.attr("id");
	if (typeof (Jraf.menuCacheMap[pmenuid]) === "undefined"
		|| Jraf.menuCacheMap[pmenuid].length == 0) {
	   initJrafCacheFromData(pmenuid,currentRole);
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
			    var html = "<li><a class='title-second'>"+menuname+"<i class='fa fa-angle-right'></i></a>";
			    html+="<ul style='display: none;' id='"+menuid+"' ></ul>";
				$(topMenu).append(html);
				initFolderMenu($(topMenu).find("#"+menuid));
				bindHover($(topMenu));
				continue;
		} else {
			if (linkurl != null && "" != linkurl) {
				rel = linkurl.substring(linkurl.lastIndexOf("/") + 1, linkurl.lastIndexOf("."));
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
				var html = "<li>"+
					       "<a href=\""+linkurl+"\" target=\""+target+"\" onclick=\""+onclick+"\" rel=\""+rel+"\">"+menuname+"</a>"+
							"</li>";
				
			$(topMenu).append(html);
	 }
	}
	initUI($(".jraf-menu"));
}
//初始化树型子菜单
function loadAllMenu(currentRole) {
	var url = "/jsonprocesserservlet"
		+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
		+ "&oprID=<sc:fmt value='initMenu' type='crypto'/>"
		+ "&actions=<sc:fmt value='loadAllMenu' type='crypto'/>"
		+ "&currentRole=" + currentRole;
	$.ajax({
		type : 'POST',
		url : url,
		global: true,
		dataType : 'json',
		error : DWZ.ajaxError,
		async : false,
		success : function(data) {
			if (data != null && data.length != 0) {
				menuData = data;
			}
		}
	});
}
function initJrafCacheFromData(pmenuid){

	var currentMenu = new Array();
	for (var i = 0; menuData && i < menuData.length; i++) {
		var childCacheMap_one = menuData[i];
		var child_pmenuid = childCacheMap_one["pmenuid"];
		if(child_pmenuid == pmenuid ){
			currentMenu.push(childCacheMap_one);
		}
	}
	Jraf.menuCacheMap[pmenuid] = currentMenu;
}
</script>
