<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.security.UserAuthenticator"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
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
	/* Cookie cookie = new Cookie("usercode",request.getParameter("usercode"));
	Cookie cookie2 = new Cookie("userpwd",request.getParameter("userpwd"));
	cookie.setMaxAge(24*60*60);
	cookie2.setMaxAge(24*60*60);
	response.addCookie(cookie);
	response.addCookie(cookie2); */
    
	response.setHeader("Cache-Control", "no-cache");  
	response.setHeader("Pragma", "no-cache");  
	response.setDateHeader("Expires", 0);  
    
	// 取出线程内的认证信息(登录交易中成功登录后生成)
	UserAuthenticator loginJrafAuth = (UserAuthenticator) UserAuthenticator.currentAuthenticator();
	if(loginJrafAuth==null){
	    response.sendRedirect("/governor/common/logout.jsp");
	    return;		
	}else{
    	/**
         * 登录首页,未经过过滤器，必须将认证信息回存至session
         */
		UserAuthenticator.setSessionAttribute(session,loginJrafAuth.getUser());// 认证信息回存到session
	}
	String skinName = "blue";
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport"
		content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>${sitename}</title>
	<%@include file="/jui/jui_common_header.jsp"%>
	<%@include file="/jui/jui_common_foot.jsp"%>
</head>
<body scroll="no" class="initialise flip-scroll">
	<div class="container-fluid">
    <form id="flushTopNavMenu" method="post" action="/httpprocesserservlet" class="pageForm">
        <input type="hidden" name="sysName" value='<sc:fmt value='funcpub' type='crypto'/>' />
        <input type="hidden" name="oprID" value='<sc:fmt value='initMenu' type='crypto'/>' />
        <input type="hidden" name="actions" value='<sc:fmt value='initTopNavMenu' type='crypto'/>' />
        <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/index_governor.jsp' />" />
    </form>
    
	<nav class="navbar navbar-default navbar-fixed-top">
	
		<div class="navbar-header" id="headerheight">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
				<span class="sr-only">Toggle navigation</span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
				<span class="icon-bar"></span>
			</button>
			
			<a id="indexlogo" class="logo" style="background:url('${bankpic}') no-repeat left 0;"></a>
			<a id="indexlogo" class="navbar-brand" style="width: 182px; background: url('/jui/themes/blue/images/login_logo.png') no-repeat left 0;"></a>
			
		</div>
		<div id="navbar" class="navbar-collapse collapse">
			<!-- user dropdown starts -->
			<ul class="nav navbar-nav" id="navMenu" ></ul>
			<ul class="nav navbar-nav hidden" id="navDropdown"></ul>
			<ul class="nav navbar-nav navbar-right">
			
			    <li class=" hidden-xs ">
			    	<a class="double-down hidden">
				    	<i class="fa fa-angle-double-down"></i>&nbsp;
						<span class="badge navMenusize">0</span>
					</a>
				</li>
				<li class="hidden-xs"><a id="toggle"><i class="fa fa-arrows-alt"></i>&nbsp;</a></li>
			   
				<li>
					<a class="dropdown-toggle" data-toggle="dropdown">
						<i class="glyphicon glyphicon-user"></i>&nbsp;
						<span class="currentUser">sysadmin</span> 
						<span class="caret"></span>
					</a>
					<ul class="dropdown-menu">
						<li>
							<a href="/jui/index_governor.jsp"><i class="fa fa-home fa-fw"></i>&nbsp;首页</a>
						</li>
						<li class="divider"></li>
						<li class="exit">
							<a href="#" onclick="parent.window.location='/governor'"><i class="fa fa-power-off fa-fw"></i>退出</a>
						</li>
					</ul>
				</li>
			</ul>
		</div>
	</nav>

   
        <!-- 左侧导航栏的开始 -->
        <div>
      		<div id="leftside">
				<div id="sidebar_s">
					<div class="collapse">
						<div class="toggleCollapse">
							<div class="toggleMark">
								<i class="fa fa-bars"></i>
							</div>
						</div>
					</div>
				</div>
				<div id="sidebar">
					<div class="toggleCollapse">
						<h2>主菜单</h2>
						<div class="toggleMark">
							<i class="fa fa-long-arrow-left"></i>
						</div>
					</div>
		
					<div class="accordion" fillSpace="sidebar" >
		                  <ul id="folderNavMenu"></ul>
					</div>
				</div>
			</div>

        <!-- 导航栏的结束 -->
	        <div id="container">
	            <div id="navTab" class="tabsPage">
					<div class="tabsPageHeader">
						<div class="tabsPageHeaderContent">
							<!-- 显示左右控制时添加 class="tabsPageHeaderMargin" -->
							<ul class="navTab-tab">
								<li tabid="main" class="main">
									<a href="javascript:;">
										<span>
											<span><i class="fa fa-home fa-lg"></i> &nbsp;首页</span>
										</span>
									</a>
								</li>
							</ul>
						</div>
						
						<div class="tabsLeft">left</div>
						<!-- 禁用只需要添加一个样式 class="tabsLeft tabsLeftDisabled" -->
						<div class="tabsRight">right</div>
						<!-- 禁用只需要添加一个样式 class="tabsRight tabsRightDisabled" -->
						<div class="changescale hidden-xs"><i class="fa fa-window-maximize"></i></div>
						<div class="tabsMore">more</div>
					</div>
					<ul class="tabsMoreList">
						<li><a href="javascript:;">我的主页</a></li>
					</ul>
					<div class="navTab-panel tabsPageContent layoutBox">
						<div class="page unitBox homepage" style="overflow: auto;">
						   
						</div>
					</div>
				</div>

	            <div id="footer">
			        <span style="float: left; line-height: 21px;">${footer}</span>
			        <span class="currentRole" style="line-height: 21px;"></span>
			        <span class="currentDept" style="line-height: 21px;"></span>
			        <span class="currentUser" style="line-height: 21px;"></span>
			    </div>
       		 </div>
  		</div>
    
		<div class="right_bottom_message">
		    <p>
		        消息提示
		        <span onclick="hiddenMessage(this)">X</span>
		    </p>
		    <div class="message_text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	
		</div> 
	</div>
</body>
<script type="text/javascript">
//jui 初始化
$(function(){
	DWZ.init("/jui/dwz.frag.xml", {
		loginUrl : "/governor", 
		statusCode:{ok:200, error:300, timeout:301}, //【可选】
		pageInfo:{pageNum:"PageNo", numPerPage:"PageSize", orderField:"orderField", orderDirection:"orderDirection"}, //【可选】
		debug:false,	// 调试模式 【true|false】
		callback:function(){
			initEnv();
			$("#themeList").theme({themeBase:"/jui/themes"}); // themeBase 相对于index页面的主题base路径
		//	password_date();//密码过期判断
		//	queryDataDate();//查询数据日期
			initMenuCache();//初始化菜单缓存
			
		}
	});
	$(".homepage").loadUrl("/governor?flag=getSystemInfo");
		bindEvent();
	 // setInterval("refresh()",10000);
});
function bindEvent(){
	//左侧菜单
	$("#folderNavMenu").on("click",".side-first",function(){
		$("#folderNavMenu >li >ul >li").removeClass("selected");
		$(this).parent().find(">ul").slideToggle("1500");
		$(this).parent().find(">ul ul").slideUp();			
		$(this).parent().children().size()>1? $("#folderNavMenu .side-first").removeClass("selected"):$("#folderNavMenu li,#folderNavMenu .side-first").removeClass("selected");
		$(this).toggleClass("selected");

		$(this).find("span").toggleClass('up').parents('li').siblings().find(".right-i").removeClass('up');
		$(this).parent().siblings().find("ul").slideUp("1500");
	})
	$("#folderNavMenu").on("click",".side-two",function(){
		$(this).parent().find(">ul").slideToggle("1500");
		$(this).parent().find(">ul ul").slideUp();
	
		$(this).parent().siblings().find("ul").slideUp("1500");
	})
	$("#folderNavMenu").on("click","> li >ul >li",function(){
		$("#folderNavMenu >li>.side-first").removeClass("selected");
		$("#folderNavMenu >li >ul >li").removeClass("selected");
		$(this).addClass("selected");
	})

	var $menu = $("#navMenu");
	$("nav .double-down").click(function(){
	   $menu.find("> .nav-clone").remove(); 
	   $menu.toggleClass("navMenu");
	   $("nav .double-down > .fa").toggleClass("fa-angle-double-down").toggleClass("fa-angle-double-up");
	   if(! $menu.hasClass("navMenu")){
			doubledown($menu);
		 }else{
		  $menu.find(">li").removeClass("nav-hidden");
	   }
	})
	$(document).on('click', function(e) {
		var mouseheight = e.pageY || e.screenY;
		if(mouseheight > $("#headerheight").height() || $(e.target).parents(".double-down").length < 0){
			$menu.removeClass("navMenu");
			$("nav .double-down > .fa").addClass("fa-angle-double-down").removeClass("fa-angle-double-up");
			 $menu.find(">li").removeClass("nav-hidden");
			 doubledown( $menu);
		}
	})
	/*点击头部菜单显示左侧菜单*/
	var isShow = false;
	$menu.on("click",">li",function(){
		if(!isShow){
			$('#sun_toggle').find('i').removeClass('fa-chevron-right').addClass('fa-chevron-left');
		 	isShow = true;
	    	}
			if(!$("body").hasClass("initialise")){
				if($("#sidebar").css("display") == "none"){
					$("#sidebar_s .toggleMark").trigger("click");
				}
			}
			$("body").removeClass("initialise");// 初始化的左侧菜单不显示
			
			doubledown($menu);
			if($('#container').css('padding-left') != '187px'){
				$('#sun_toggle').find('i').removeClass('fa-chevron-right').addClass('fa-chevron-left')
			
				$('#container').animate({'padding-left':'187px'},300);
				$('#sidebar').animate({'left':'0px'},400);
			}
	});
}
// 判断首页配置是否已经加载，只加载一次 
var hasInitHomePageInfo = false;
function messageCount(){
	navTab._switchTab(0);
	$(".homepage").html("");
	initHomePageInfo("", "reload");
	//initHomePageFunc($homePageFuncs);
}

function getUnReadMsgCount(){
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
    + "&oprID=<sc:fmt value='funcpubNews' type='crypto'/>"
    + "&actions=<sc:fmt value='getUnReadMsgCount' type='crypto'/>";
	
	$.ajax({
		global:false,
		type:'POST',
		url: url,
		dataType:'text',
		error: DWZ.ajaxError,
		success:function(data){
			var xmlDoc = parseXmlStr(data);
			var currentRolena = $('count',xmlDoc).eq(0).text();
			$("#msgNums").text("(" + currentRolena +")");
		}
	});
}

// 
function changeTopNavMenu(obj){
	$(obj).siblings().removeAttr("class");
	$(obj).attr("class","selected");
	var menuid = $(obj).find("input").val();
	initFolderMenu(menuid);
}

function getChildMenu(menuArray, menuid){
	for(var i=0; i<menuArray.length;i++ ){
		var menu = menuArray[i];
		if(menuid == menu["@menuid"]){
			return menu.menu;
		}else{
			if(0 == menu["@isleaf"]){
				return getChildMenu(menu.menu, menuid);
			}
		}
	}
}

//初始化树型菜单
function initFolderMenu(menuid){
	$("#folderNavMenu").html("");
	if(menuid == null || menuid == ""){
		 menuid = $("#navMenu ul li:first input").val();
	}
	
	var childCacheArr =[];
	
	var childCacheArr_obj = null;
	for(var i=0; i<Jraf.menuCacheMap.length;i++ ){
		var menu = Jraf.menuCacheMap[i];
		if(menuid == menu["@menuid"]){
			childCacheArr_obj = menu.menu;
		}
	}
	
	if(!(childCacheArr_obj instanceof Array)){
		childCacheArr.push(childCacheArr_obj);
	}else{
		childCacheArr = childCacheArr_obj;
	}
	for(var i = 0; i<childCacheArr.length;i++){
		var childCacheMap = childCacheArr[i];
		var menuid  = childCacheMap["@menuid"];
		var menuname  = childCacheMap["@menuname"];
		var isleaf  = childCacheMap["@isleaf"];
		var linkurl = childCacheMap["@linkurl"];
		var rel     = "";
		var onclick = "";
		if("1" != isleaf){
			
			
			var html="";
			html = "<li><a class='side-first' href='javascript:;'><i class='list-i fa fa-list fa-menu'></i>"+ menuname +"<i class='right-i fa fa-lg fa-angle-right'></i></a><ul style='display:none' id='"+menuid+"'></ul></li>"
			$("#folderNavMenu").append(html);
			initChildFolderMenu(childCacheMap);
			continue;
		}else{
			var s_time = new Date().getTime();
			if(linkurl.indexOf("?")>0){
				linkurl +="&";
			}else{
				linkurl +="?";
			}
			linkurl +="s_time="+s_time;
			if(linkurl != null && "" != linkurl){
				rel = linkurl.substring(linkurl.lastIndexOf("/")+1, linkurl.lastIndexOf("."));
			}else{
				linkurl = "/jui/developed.jsp";
				rel = "developed";
			}
		}
		if(linkurl.indexOf("sysName")>0){
			$.ajax({
				url:"/jui/CryptoUrl.jsp",
				data:{url:linkurl},
				async:false,
				success:function(data){linkurl = data;}
			});
		}
		var html = "<li id='"+menuid+"'><a class='side-first' href=\""+linkurl+"\" target='navTab' rel='"+rel+"' title='"+menuname+"'>"+menuname+"</a></li>";
		$("#folderNavMenu").append(html);
	}
	initUI($("#leftside"));
    if(!hasInitHomePageInfo) {
    	initHomePageInfo();//初始化首页信息 
    	hasInitHomePageInfo = true;  // 首页信息只加载一次
    }
}


//初始化树型子菜单
function initChildFolderMenu(PCacheMap){
	var currentRole =  $("#currentRoleid_id").val(); 
	
	var childCacheArr =[];
	var childCacheArr_obj = PCacheMap.menu;
	if(!(childCacheArr_obj instanceof Array)){
		childCacheArr.push(childCacheArr_obj);
	}else{
		childCacheArr = childCacheArr_obj;
	}
	for(var i = 0; i<childCacheArr.length;i++){
		var childCacheMap = childCacheArr[i];
		var menuid  = childCacheMap["@menuid"];
		var menuname  = childCacheMap["@menuname"];
		var isleaf  = childCacheMap["@isleaf"];
		var linkurl = childCacheMap["@linkurl"];
		var rel     = "";
		var onclick = "";
		if("1" != isleaf){
		//	linkurl = "/jui/menu-list.jsp?menuid="+menuid;
		}else{
			if(linkurl != null && "" != linkurl){
				rel = linkurl.substring(linkurl.lastIndexOf("/")+1, linkurl.lastIndexOf("."));
			}else{
				linkurl = "/jui/developed.jsp";
				rel = "developed";
			}
		}
		if(linkurl.indexOf("sysName")>0){
			$.ajax({
				url:"/jui/CryptoUrl.jsp",
				data:{url:linkurl},
				async:false,
				success:function(data){linkurl = data;}
			});
		}
		var html = "<li><a href=\""+linkurl+"\" target='navTab'  rel='"+rel+"' title='"+menuname+"'>"+menuname+"</a></li>"; 
		$("#"+PCacheMap["@menuid"]).append(html);
	}
}
//修改为governor入口
//初始化菜单缓存
function initMenuCache(){
	var url = "/governor?flag=initConfig&actorName=listMenuAll";
	$.ajax({
		type:'POST',
		url: url,
		dataType:'json',
		error: DWZ.ajaxError,
		async:true,
		success:function(data){
			if(data != null && data.length !=0){
				Jraf.menuCacheMap = eval("(" + data + ")");
				ajaxLoadTopMenuAndLeftMenu();//加载顶部和左边菜单
			}
		}
	});
}
//初始化首页信息
function initHomePageInfo(defaultRoleid, loadType){
	/* var query_url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'
    + '&oprID=<sc:fmt value='initHome' type='crypto'/>'
    + '&actions=<sc:fmt value='queryHomePageInfo' type='crypto'/>';
    var paradata=null;
    if(typeof(defaultRoleid) != "undefined"){
    	paradata = "defaultRoleid="+defaultRoleid;
    }
    $.ajax({
		type:'POST',
		url: query_url,
		dataType:'text',
		data:paradata,
		success:function(data){
			//解析XML 
			var xmlDoc = parseXmlStr(data);
			
			//初始化首页功能配置
			var $homePageFuncs = $('homePageFuncs',xmlDoc);
			initHomePageFunc($homePageFuncs);
			
			if(loadType != "reload" ){
				var currentRolena = $('currentRolena',xmlDoc).eq(0).text();
				var currentUsercode = $('currentUsercode',xmlDoc).eq(0).text();
				var currentUserna = $('currentUserna',xmlDoc).eq(0).text();
				var currentDeptna = $('currentDeptna',xmlDoc).eq(0).text();
				var currentRoleid = $('currentRoleid',xmlDoc).eq(0).text();
				
				$(".currentRole").eq(0).text("角色："+currentRolena);
				$(".currentUser").eq(0).text("用户：("+currentUsercode+")"+currentUserna);
				$(".currentDept").eq(0).text("机构："+currentDeptna);
				$("#currentRoleid_id").val(currentRoleid);
				
				//初始化Tab标签页
				var $homePageTabs = $('homePageTabs',xmlDoc);
				initHomePageTab($homePageTabs);
			}
		}
	}); */
	var $homePageTabs = $('homePageTabs',"");
	initHomePageTab($homePageTabs);
    navTab._scrollTab(0);//首页标签页偏移 
}

// 初始化首页配置功能 
function initHomePageFunc($homePageFuncs, loadType){
	var homepageDiv = $(".homepage");
	homepageDiv.empty();   //初始化之前 先清空
	if($homePageFuncs.length>0){
		for(var i=1;i<=3;i++){
			for(var j=1;j<=3;j++){
				var rc = i+""+j;
				$('Record',$homePageFuncs).each(function(i,record){
					var funrc = $('cell_coordinate',record).text();
					if(rc == funrc){
						var funname = $('function_name',record).text();
						var fundetailurl = $('function_detail_url',record).text();
						var funurl = $('function_url',record).text();
						var funwidth = $('width_rate',record).text();
						var funheight = $('height',record).text();
						if(funheight.endsWith("%")){
							funheight = parseInt(funheight)+"%";
						}else{
							funheight = parseInt(funheight)+"px";
						}
						funwidth = parseInt(funwidth)+"%";
						addHomeTableCell(funwidth,funheight,funname,funurl,fundetailurl);//初始化首页的配置功能
					}
				});
			}
		}
	}else{
		$(homepageDiv).html("");//清空首页内容
	}
	initUI($(homepageDiv));
}

//添加首页配置功能
function addHomeTableCell(funwidth,funheight,funname,funurl,fundetailurl){
	var rel = funurl.substring(funurl.lastIndexOf("/")+1, funurl.lastIndexOf("."));
	var html = "<div class='homepagecell' style='width:"+funwidth+";height:"+funheight+";'>"
				 + "<div class='homepagetitle'>"+funname;
	if(!fundetailurl.isBlank()){
		html = html +"<a href='"+fundetailurl+"' target='navTab' rel='"+rel+"' title='"+funname+"'>详细</a>";
	}
	html = html + "</div>"
				 + "<div id='homepagecontent'>"
				 + "</div>"
			 + "</div>";
	$(".homepage").append(html);
}
//打开详细
function openFuncDetail(funid,funname,funurl){
	navTab.openTab(funid, funurl, { title:funname, fresh:false, data:{} });
	//navTab.openTab("dataQualityCheckInfo_Src", funurl, { title:'公共校验配置', fresh:false, data:{} });
}



// 初始化首页Tab标签页 
function initHomePageTab($homePageTabs){
	if($homePageTabs.length>0){
		$('Record',$homePageTabs).each(function(i,record){
			var tabname = $('function_name',record).text();
			var taburl = $('function_url',record).text();
			navTab.openTabNoInit("homepage"+i, taburl, { title:tabname, fresh:false, data:{} });
		});
	}
	navTab._switchTab(0);//选择首页标签页
}

//重构表格 
 /*
function resizeGrid(){
	$(window).trigger(DWZ.eventType.resizeGrid);
} */

 //解析字符串格式XML
function parseXmlStr(xmlStr) {
	var responseStr = xmlStr.substring(xmlStr.indexOf("Response"), xmlStr
			.lastIndexOf("Response"));
	var dataStr = responseStr.substring(responseStr.indexOf("Data") - 1,
			responseStr.lastIndexOf("Data") + 5);
	var xmlDoc = null;
	try //Internet Explorer
	{
		xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
		xmlDoc.async = "false";
		xmlDoc.loadXML(dataStr);
	} catch (e) {
		try //Firefox, Mozilla, Opera, etc.
		{
			parser = new DOMParser();
			xmlDoc = parser.parseFromString(dataStr, "text/xml");
		} catch (e) {
			alert(e.message);
			return;
		}
	}
	return xmlDoc;
}
// 切换角色
function changeRole(){
	var currentRole =  $("#currentRoleid_id").val();
	var queryrole_url = '/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'
	    + '&oprID=<sc:fmt value='initHome' type='crypto'/>'
	    + '&actions=<sc:fmt value='queryUserRoles' type='crypto'/>&forward=<sc:fmt value='/jui/userrolelist.jsp' type='crypto'/>&currentRole='+currentRole;
	$.pdialog.open(queryrole_url,"changeLoginUserRole","切换角色", {width:600,height:400,maxable:false,mask:"true"});
}

//切换角色
function changeRoleInit(defaultRoleid){
	//navTab.closeAllTab();
	//initHomePageInfo(defaultRoleid);
	$("#flushTopNavMenu").submit();
}

//修改密码 提交
function updatePassword(){  
	 
	//var userpwd = $("userpwd").val;
	var userpwd = document.getElementById("userpwd").value; //原密码 
	var userpwd_old = document.getElementById("userpwd_old").value;  //输入的原密码
	var userpwd_new = document.getElementById("userpwd_new").value;  //输入的新密码
	var userpwd_new_sure = document.getElementById("userpwd_new_sure").value; //输入的 确认新密码 
	
	
	if(userpwd_old==null||userpwd_old==''){  //原密码检验	
		return false;
	}else if(userpwd_old!=userpwd){
		alert("原密码输入不正确!");
		return false;
	}
	if(userpwd_new==null||userpwd_new==''){ //新密码校验 
		alert("新密码不能为空!"); 
		return false;
	}
	if(userpwd_new_sure==null||userpwd_new_sure==''){  //确认新密码检验
		alert("确认新密码不能为空!"); 
		return false;
	}else if(userpwd_new_sure!=userpwd_new){
		alert("确认新密码输入不正确!"); 
		return false;
	}
	
	document.getElementById("password_pageFrom").submit();
}

function toupdate_password(msg){
	var updatepasswd_url = '/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'
	    + '&oprID=<sc:fmt value='EditPassword' type='crypto'/>'
	    + '&actions=<sc:fmt value='findPasswordById' type='crypto'/>&forward=<sc:fmt value='/jui/password.jsp' type='crypto'/>';
	    updatepasswd_url += '&msg=' +msg; 
    if(msg==1){
    	//修改密码完成 刷新页面
    	$.pdialog.open(updatepasswd_url,"updatepassword","修改密码", {width:500,height:400,maxable:false,mask:"true",close:function(){window.location.href="/jui/index.jsp";return true;} });
    }else{
    	/* $.pdialog.open(updatepasswd_url,"updatepassword","修改密码", {width:500,height:400,maxable:true,mask:"true"}); */
    	$("#userInfoManagerBox2").loadUrl(updatepasswd_url,{},function(){});
    }	
}

function password_date() {
	// AJAX 判断 当前用户密码是否到期
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='Login' type='crypto'/>"+
            "&actions=<sc:fmt value='checkdate' type='crypto'/>";
    $.ajax({
           type: "POST",
           url: url,
           data: null,//前台发给后台的数据。     
           dataType : "xml",    
           processData: false,   
           success:function(data){    
        	  /*  var msg = $(data).find("msg").text(); 
         	  if("error" == msg){	
         		 toupdate_password('1'); //1代表过期标志！  	 
         	  }else{     		  
         		// judgeHasRole();//判断用户是否拥有角色
         		  return;
         	  } */
           }
       });
		
}
//常用菜单配置
function deployMenu(){
    var url = "/jui/userMenuDeploy.jsp";
    $.pdialog.open(url,"deployMenu","配置个人常用功能", {
    width:600,
    height:400
    });
}
<%--
/* 用户登录后，进入主页面:
 * 1）判断是否有分配角色，如果没有则提示“用户无任意角色权限，请联系管理员分配。” ； flag=0
 * 2）判断是否开启“切换角色”功能:
 * a）如果未开启，则直接查询所有角色分配的菜单（合并的菜单）, 其中查询不到菜单权限，提示“未分配任意角色菜单权限！请联系管理员分配。”; flag=1
 * b）如果开启，则判断“默认角色（default_role）”是否未配置角色或配置的角色已经不存在，
 *    i）如果是，则弹出“角色切换”页面，必需选择一个角色（如果用户只有一个角色，直接赋值为默认角色flag=1）flag=2，然后页面显示“默认角色”的菜单权限，其中查询不到菜单权限，提示“未分配任意角色菜单权限！请联系管理员分配。”;
 *    ii）如果否，则直接在页面显示当前“默认角色"的菜单权限，其中查询不到菜单权限，提示“未分配任意角色菜单权限！请联系管理员分配。”; flag=1
 */
 --%>
function judgeHasRole(){
	var url = "/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='initHome' type='crypto'/>"+
            "&actions=<sc:fmt value='judgeHasRole' type='crypto'/>";
    $.ajax({
           type: "POST",
           url: url,
           data: null,//前台发给后台的数据。     
           dataType : "JSON",    
           processData: false,   
           success:function(data){  
        	   
        	   //处理是否显示“切换角色”
        	   var switchrole = data.switchrole;
        	   if("1" == switchrole){
        		   $("#changeRole").show();
        		   $(".currentRole").show();
        	   }else{
        		   $("#changeRole").hide();
        		   $(".currentRole").hide();
        	   }
        	   
        	   var flag = data.flag;
        	   if("0" == flag){
        		   alertMsg.warn("用户无任意角色权限，请联系管理员分配！\n 点击确认按钮将退出系统！", {
          			 okCall:function(){
          				 location.href="/logout.jsp";
          			 }
          		 });
        	   }else if("1" == flag){
        		   ajaxLoadTopMenuAndLeftMenu();
        		
        	   } else if("2" == flag){
        		   //选择角色
        		   changeRole();
        	   }else{
        		   alertMsg.error("角色查询异常！");
        	   }
       
           }
       });
	
}

//查询数据日期
function queryDataDate(){
	var url = "/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='initHome' type='crypto'/>"+
    "&actions=<sc:fmt value='queryDataDate' type='crypto'/>";
	$.ajax({
	       type: "POST",
	       url: url,
	       data: null,//前台发给后台的数据。     
	       dataType : "JSON",    
	       processData: false,   
	       success:function(data){  
	    	$("#dataDateSpan").text("数据日期："+data);
	       }
	   });
}

/*
 * 加载顶部和左边菜单
 */
function ajaxLoadTopMenuAndLeftMenu(){
	 var html = "";
	 for(var i=0; i<Jraf.menuCacheMap.length;i++ ){
		 var menu = Jraf.menuCacheMap[i];
		 if(i==0){
			 html += "<li class='selected' onclick='changeTopNavMenu(this)'><input type='hidden' value='"+menu["@menuid"]+"'><a href='javascript:;'>"+menu["@menuname"]+"</a></li>";
		 }else{
			 html += "<li onclick='changeTopNavMenu(this)'><input type='hidden' value='"+menu["@menuid"]+"'><a href='javascript:;'>"+menu["@menuname"]+"</a></li>";
		 }
	 }
	 $("#navMenu").append(html);
}
function refresh(){
	$(".homepage").empty();
	$(".homepage").loadUrl("/governor?flag=getSystemInfo");
}
</script>
</html>