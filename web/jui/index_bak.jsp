<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.security.UserAuthenticator"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="com.sunline.funcpub.util.SysConstants"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html>
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
	/* 
	Cookie cookie = new Cookie("usercode",request.getParameter("usercode"));
	Cookie cookie2 = new Cookie("userpwd",request.getParameter("userpwd"));
	cookie.setMaxAge(24*60*60);
	cookie2.setMaxAge(24*60*60);
	response.addCookie(cookie);
	response.addCookie(cookie2); 
	*/
    
	response.setHeader("Cache-Control", "no-cache");  
	response.setHeader("Pragma", "no-cache");  
	response.setDateHeader("Expires", 0);  
    
	/* 
	// 取出线程内的认证信息(登录交易中成功登录后生成)
	UserAuthenticator loginJrafAuth = (UserAuthenticator) UserAuthenticator.currentAuthenticator();
	if(loginJrafAuth==null){
	    response.sendRedirect("/logout.jsp");
	    return;		
	}else{
    	//登录首页,未经过过滤器，必须将认证信息回存至session
		UserAuthenticator.setSessionAttribute(session,loginJrafAuth.getUser());// 认证信息回存到session
	} 
	*/
	
	String skinName = "blue";
	UserAuthenticator loginJrafAuth = (UserAuthenticator) UserAuthenticator.currentAuthenticator();
	  if(loginJrafAuth!=null){
	        String skin = loginJrafAuth.getUser().getSkinname();
	        if(skin!=null && !skin.trim().equals("")){
	            skinName=skin;
	        }
	  }
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
	<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
	<title>${sitename}</title>
	<%@include file="/jui/jui_common_header.jsp"%>
	<%@include file="/jui/jui_common_foot.jsp"%>
</head>

<body scroll="no" class="initialise flip-scroll blackbackground">
	<div class="container-fluid">
		<form id="flushTopNavMenu" method="post" action="/httpprocesserservlet" class="pageForm">
			<input type="hidden" name="sysName" value='<sc:fmt value='funcpub' type='crypto'/>' /> 
			<input type="hidden" name="oprID" value='<sc:fmt value='initMenu' type='crypto'/>' />
			<input type="hidden" name="actions" value='<sc:fmt value='initTopNavMenu' type='crypto'/>' />
			<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/index.jsp' />" />
		</form>
		<nav class="navbar navbar-default navbar-fixed-top">
			<!-- logo-->
			<div class="navbar-header" id="headerheight">			
				<a id="indexlogo" class="navbar-brand">${sitename}</a>		
			</div>
			<!-- 导航 -->
			<div id="navbar" class="navbar-collapse collapse">
				<div class="sun-toggle" id="sun_toggle"><i class="fa fa-chevron-right"></i></div>
				<!-- user dropdown starts -->
				<ul class="nav navbar-nav hidden" id="navMenu" ></ul>
		   		<ul class="nav navbar-nav hidden" id="navDropdown"></ul>
				<ul class="nav navbar-nav navbar-right">			
				    <li class=" hidden-xs ">
				    	<a class="double-down hidden"><i class="fa fa-angle-double-down"></i>&nbsp;<span class="badge navMenusize">0</span></a>
					</li>
					<li class="hidden-xs"><a id="toggle"><i class="fa fa-expand"></i>&nbsp;</a></li>				   
					<li>
						<a class="dropdown-toggle" data-toggle="dropdown">
							<i class="glyphicon glyphicon-user"></i>&nbsp;
							<span class="currentUser"></span> 
							<span class="caret"></span>
						</a>
						<ul class="dropdown-menu">
							<li>
								<a href="/jui/index.jsp?csrftoken=${csrftoken}">
									<i class="jf-btn-home"></i>&nbsp;&nbsp;首页
								</a>
							</li>
							<li class="user">
								<a href="/funcpub/public/userinfo/userInfoManager.jsp" title="个人信息" target="dialog" maxable=false mask=true width="750" height="450">
									<i class="jf-btn-mine"></i>&nbsp;&nbsp;个人信息
								</a>
							</li>
							<li class="user" id="changeRole" style="display: none;">
								<a onclick="changeRole();"> 
									<i class="jf-btn-switch"></i>&nbsp;&nbsp;切换角色
									<input type="hidden" id="currentRoleid_id">
								</a>
							</li>
							<li class="user">
								<!-- 从后台常量类取值 --> 
								<input type="hidden" id="userFavorMenu_id" value="<%=SysConstants.USER_FAVOR_ID%>" />
								<a onclick="deployMenu();">
									<i class="jf-btn-common"></i>&nbsp;&nbsp;常用功能配置
								</a>
							</li>
							<li class="user">
								<a href="/jui/lockScreen.jsp" title="锁屏" target="dialog" close="false"  maxable="false"  width="450" height="250">
									<i class="jf-btn-screen"></i>&nbsp;&nbsp;锁屏
								</a>
							</li>
							
							<sc:doPost sysName="funcpub" oprId="themeActor" action="queryTheme" scope="request" all="false" var="rspPkg"  />
							<c:if test="${fn:length(rspPkg.rspRcdDataMaps) gt 1}" >
								<li id="header">
									<a href="#"><i class="jf-btn-skin" aria-hidden="true"></i>&nbsp;&nbsp;换肤：</a>
									<ul class='themeList' id='themeList'>
										<c:forEach var="item" items="${rspPkg.rspRcdDataMaps }">
				               				 <li theme='${item.theme}'><i class='jf-btn-${item.theme}'></i></li>
			                   			</c:forEach>
		                    		</ul>
								</li>
							</c:if>
							
							<input type="hidden" id="skinName"  value="<%=skinName%>"/>
							<li class="divider"></li>
							<li class="exit">
								<a href="/logout.jsp">
									<i class="jf-btn-sign-out"></i>&nbsp;&nbsp;退出
								</a>
							</li>
						</ul>
					</li>
				</ul>
			</div>
		</nav>
	</div>
	
	<!-- 左侧导航栏的开始1 -->
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
				<div class="page unitBox homepage" style="overflow: auto;"></div>
			</div>
		</div>
		
		<!-- 底部 -->
		<div id="footer">
			<input type="hidden" name="currentUserCode"/>
   			<input type="hidden" name="currentCorpCode"/>
			<span style="float: left; line-height: 21px;">${footer}</span>
			<span class="currentRole" style="line-height: 21px;"></span>
			<span class="currentDept" style="line-height: 21px;"></span>
			<span id="dataDateSpan" style="line-height: 21px;"></span>
		</div>
	</div>

</body>

<script type="text/javascript">
	//jui 初始化
	var ismenuVisitLog = false; //菜单访问日志是否启动
	$(function() {
		DWZ.init("/jui/dwz.frag.xml", {
			loginUrl : "/login_dialog.jsp",
			loginTitle : "登录", // 弹出登录对话框
			/**loginUrl:"/index.jsp",	// 跳到登录页面**/
			statusCode : {
				ok : 200,
				error : 300,
				timeout : 301
			}, //【可选】
			pageInfo : {
				pageNum : "PageNo",
				numPerPage : "PageSize",
				orderField : "orderField",
				orderDirection : "orderDirection"
			}, //【可选】
			debug : false, // 调试模式 【true|false】
			callback : function() {
				initEnv();
				$("#themeList").theme({
					themeBase : "/jui/themes"
				}); // themeBase 相对于index页面的主题base路径

				password_date();//密码过期判断
				judgeHasRole();//判断用户是否拥有角色
				getMenuVisitLogStatus();
				queryDataDate();//查询数据日期
			}
		});
		/* setInterval(function(){
			 getUnReadMsgCount();
		}, 50000); */
		
		$(".themeList li").click(function(){
		     updateTheme($(this).attr("theme"));
		});
		//重新设置cookie的值
		//$.cookie('dwz_theme', $("#skinName").val()); 
	});
	// 判断首页配置是否已经加载，只加载一次 
	var hasInitHomePageInfo = false;
	function messageCount() {
		navTab._switchTab(0);
		$(".homepage").html("");
		initHomePageInfo("", "reload");
		//initHomePageFunc($homePageFuncs);
	}

	function getUnReadMsgCount() {
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='funcpubNews' type='crypto'/>"
				+ "&actions=<sc:fmt value='getUnReadMsgCount' type='crypto'/>";

		$.ajax({
			global : false,
			type : 'POST',
			url : url,
			dataType : 'text',
			error : DWZ.ajaxError,
			success : function(data) {
				var xmlDoc = parseXmlStr(data);
				var currentRolena = $('count', xmlDoc).eq(0).text();
				$("#msgNums").text("(" + currentRolena + ")");
			}
		});
	}

	// 
	function changeTopNavMenu(obj) {
		/* $(obj).siblings().removeAttr("class"); */
		/* $(obj).siblings().removeClass("selected");
		$(obj).attr("class", "selected"); */
		var menuid = $(obj).find("input").val();
		initLeftNavMenu(menuid);	
		if($(obj).hasClass('nav-clone'))return;
		$(obj).siblings().removeClass("selected");
		$(obj).addClass("selected");
		
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
	function getMenuStyle() {
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='initMenu' type='crypto'/>"
				+ "&actions=<sc:fmt value='getMenuStyle' type='crypto'/>";
		$.ajax({
			type : 'POST',
			url : url,
			dataType : 'xml',
			error : DWZ.ajaxError,
			async : false,
			success : function(data) {
				if (data != null) {
					Jraf.menuStyle = $(data).find("menuStyle").text();
				}
			}
		});
	}

	/*
	 * 记录菜单访问日志
	 */
	function menuVisitLog(linkurl, menuid, menuname) {
		var isShow = false;
		$("#navTab .navTab-tab li").each(function(){
			if($(this).attr("url") == linkurl && $(this).find("span:last").text() == menuname)  isShow = true;
		})
		if (linkurl == null || linkurl.length < 1 || isShow) {
			return false;
		}
		
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='menuLogActor' type='crypto'/>"
				+ "&actions=<sc:fmt value='insertMenuVisitLog' type='crypto'/>"
				+ "&menuId="
				+ menuid
				+ "&menuName="
				+ encodeURI(encodeURI(menuname)) + "&url=" + linkurl;
		$("body").jrafAjaxSend();
		$("body").find(".jf-shade").last().hide();
		$.ajax({
			type : 'POST',
			url : url,
			dataType : 'xml',
			error : DWZ.ajaxError,
			async : true,
			success : function(data) {
				console.log("menulog sucess:"+data);
			},
			complete:function(){
				$("body").jrafAjaxComplete();
			}
		});
	}

	/**
	 * 获取是否记录菜单访问日志的状态
	 */
	function getMenuVisitLogStatus() {
		var url = "/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='menuLogActor' type='crypto'/>"
				+ "&actions=<sc:fmt value='getMenuVisitLogStatus' type='crypto'/>";
		$.ajax({
			type : 'POST',
			url : url,
			dataType : 'json',
			error : DWZ.ajaxError,
			async : true,
			success : function(data) {
				if ("1" == data) {
					ismenuVisitLog = true;
				} else {
					ismenuVisitLog = false;
				}
			}
		});
	}

	//初始化菜单缓存
	function initMenuCache(menuid, currentRole) {
		var url = "/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='initMenu' type='crypto'/>"
				+ "&actions=<sc:fmt value='initLeftNavMenu' type='crypto'/>"
				+ "&menuid=" + menuid + "&currentRole=" + currentRole;
		$.ajax({
			type : 'POST',
			url : url,
			dataType : 'json',
			error : DWZ.ajaxError,
			async : false,
			success : function(data) {
				if (data != null && data.length != 0) {
					Jraf.menuCacheMap[menuid] = data;
				}
			}
		});
	}
	//初始化首页信息
	function initHomePageInfo(defaultRoleid, loadType) {
		var query_url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'
				+ '&oprID=<sc:fmt value='initHome' type='crypto'/>'
				+ '&actions=<sc:fmt value='queryHomePageInfo' type='crypto'/>';
		var paradata = null;
		if (typeof (defaultRoleid) != "undefined") {
			paradata = "defaultRoleid=" + defaultRoleid;
		}

		$.ajax({
			type : 'POST',
			url : query_url,
			dataType : 'text',
			data : paradata,
			success : function(data) {
				//解析XML 
				var xmlDoc = parseXmlStr(data);

				//初始化首页功能配置
				var $homePageFuncs = $('homePageFuncs', xmlDoc);
				initHomePageFunc($homePageFuncs);

				if (loadType != "reload") {
					var currentRolena = $('currentRolena',xmlDoc).eq(0).text();
					var currentUsercode = $('currentUsercode',xmlDoc).eq(0).text();
					var currentUserna = $('currentUserna',xmlDoc).eq(0).text();
					var currentDeptna = $('currentDeptna',xmlDoc).eq(0).text();
					var currentRoleid = $('currentRoleid',xmlDoc).eq(0).text();
					var indexlogoPath = $("indexlogoPath",xmlDoc).eq(0).text();
					var currentCorpCode = $(xmlDoc).find("Session corpcode").text();
					$(".currentRole").eq(0).text("角色："+currentRolena);
					$(".currentUser").eq(0).text(currentUserna + "("+currentUsercode+")");
					$("input[name='currentUserCode']").val(currentUsercode);
					$("input[name='currentCorpCode']").val(currentCorpCode);
					$(".currentDept").eq(0).text("机构："+currentDeptna);
					$("#currentRoleid_id").val(currentRoleid);
					
					if(indexlogoPath != null && indexlogoPath != ""){
						$("#indexlogo").css("background","url('"+indexlogoPath+"') no-repeat 0 0");
					}
					
					//初始化Tab标签页
					var $homePageTabs = $('homePageTabs',xmlDoc);
					initHomePageTab($homePageTabs);
				}
			}
		});
		navTab._scrollTab(0);//首页标签页偏移 
	}

	// 初始化首页配置功能 
	function initHomePageFunc($homePageFuncs, loadType) {
		var homepageDiv = $(".homepage");
		homepageDiv.empty(); //初始化之前 先清空
		if ($homePageFuncs.length > 0) {
			for (var i = 1; i <= 9; i++) {
				for (var j = 1; j <= 9; j++) {
					var rc = i + "" + j;
					$('Record', $homePageFuncs).each(
						function(i, record) {
							var funrc = $('cell_coordinate', record).text();
							if (rc == funrc) {
								var funname = $('function_name', record).text();
								var funurl = $('function_url',record).text();
								var function_id = $('function_id',record).text();
								var funwidth = $('width_rate',record).text();
								var funheight = $('height', record).text();
								if (funheight.endsWith("%")) {
									funheight = parseInt(funheight) + "%";
								} else {
									funheight = parseInt(funheight) + "px";
								}
								funwidth = parseInt(funwidth) + "%";
								addHomeTableCell(funwidth, funheight, funname, funurl, function_id);//初始化首页的配置功能
							}
						});
				}
			}
		} else {
			$(homepageDiv).html("");//清空首页内容
		}
		initUI($(homepageDiv));
	}

	//添加首页配置功能
	function addHomeTableCell(funwidth, funheight, funname, funurl,function_id) {
		var rel = funurl.substring(funurl.lastIndexOf("/") + 1, funurl.lastIndexOf("."));
		var html = "<div class='homepagecell' style='width:"+funwidth+";height:"+funheight+";'>" + "</div>";
		$(".homepage").append(html);
		
		var data = {"function_id":function_id};
		$(".homepage").find("div.homepagecell:last").loadUrl(funurl, data);
	}
	
	//打开详细
	function openFuncDetail(funid, funname, funurl) {
		navTab.openTab(funid, funurl, {
			title : funname,
			fresh : false,
			data : {}
		});
		//navTab.openTab("dataQualityCheckInfo_Src", funurl, { title:'公共校验配置', fresh:false, data:{} });
	}

	// 初始化首页Tab标签页 
	function initHomePageTab($homePageTabs) {
		if ($homePageTabs.length > 0) {
			$('Record', $homePageTabs).each(function(i, record) {
				var tabname = $('function_name', record).text();
				var taburl = $('function_url', record).text();
				navTab.openTabNoInit("homepage" + i, taburl, {
					title : tabname,
					fresh : false,
					data : {}
				});
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
		var dataStr = xmlStr.substring(xmlStr.indexOf("DataPacket") - 1,
				xmlStr.lastIndexOf("DataPacket") + 11);
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
	function changeRole() {
		var currentRole = $("#currentRoleid_id").val();
		var queryrole_url = '/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'
				+ '&oprID=<sc:fmt value='initHome' type='crypto'/>'
				+ '&actions=<sc:fmt value='queryUserRoles' type='crypto'/>&forward=<sc:fmt value='/jui/userrolelist.jsp' type='crypto'/>&currentRole='
				+ currentRole;
		$.pdialog.open(queryrole_url, "changeLoginUserRole", "切换角色", {
			width : 600,
			height : 400,
			maxable : false,
			mask : "true"
		});
	}

	//切换角色
	function changeRoleInit(defaultRoleid) {
		//navTab.closeAllTab();
		//initHomePageInfo(defaultRoleid);
		$("#flushTopNavMenu").submit();
	}

	//修改密码 提交
	function updatePassword() {

		//var userpwd = $("userpwd").val;
		var userpwd = document.getElementById("userpwd").value; //原密码 
		var userpwd_old = document.getElementById("userpwd_old").value; //输入的原密码
		var userpwd_new = document.getElementById("userpwd_new").value; //输入的新密码
		var userpwd_new_sure = document.getElementById("userpwd_new_sure").value; //输入的 确认新密码 

		if (userpwd_old == null || userpwd_old == '') { //原密码检验	
			return false;
		} else if (userpwd_old != userpwd) {
			alert("原密码输入不正确!");
			return false;
		}
		if (userpwd_new == null || userpwd_new == '') { //新密码校验 
			alert("新密码不能为空!");
			return false;
		}
		if (userpwd_new_sure == null || userpwd_new_sure == '') { //确认新密码检验
			alert("确认新密码不能为空!");
			return false;
		} else if (userpwd_new_sure != userpwd_new) {
			alert("确认新密码输入不正确!");
			return false;
		}

		document.getElementById("password_pageFrom").submit();
	}

	function toupdate_password(msg) {
		var updatepasswd_url = '/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'
				+ '&oprID=<sc:fmt value='EditPassword' type='crypto'/>'
				+ '&actions=<sc:fmt value='findPasswordById' type='crypto'/>&forward=<sc:fmt value='/jui/password.jsp' type='crypto'/>';
		updatepasswd_url += '&msg=' + msg;
		if (msg == 1) {
			//修改密码完成 刷新页面
			$.pdialog.open(
				updatepasswd_url,
				"updatepassword",
				"修改密码",
				{
					width : 500,
					height : 350,
					maxable : false,
					mask : "true",
					close : function(param) {
						if (!param || param.success != true) {
								alertMsg.confirm(
									"正常使用系统前，请修改密码！<br/><span class='info'><i><确定>修改密码，<取消>退出系统</i></span>",
									{
									cancelCall : function() {
										window.location.href = "/logout.jsp";
										}
								});
								return false;
						} else {
							window.location.href = "/jui/index.jsp";
							return true;
						}
					}
				});
		} else {
			/* $.pdialog.open(updatepasswd_url,"updatepassword","修改密码", {width:500,height:400,maxable:true,mask:"true"}); */
			$("#userInfoManagerBox2").loadUrl(updatepasswd_url, {}, function() {
			});
		}
	}

	function password_date() {
		// AJAX 判断 当前用户密码是否到期
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='Login' type='crypto'/>"
				+ "&actions=<sc:fmt value='checkdate' type='crypto'/>";
		$.ajax({
			type : "POST",
			url : url,
			data : null,//前台发给后台的数据。     
			dataType : "xml",
			processData : false,
			success : function(data) {
				var msg = $(data).find("msg").text();
				if ("error" == msg) {
					toupdate_password('1'); //1代表过期标志！  	 
				}
			}
		});

	}
	//常用菜单配置
	function deployMenu() {
		var url = "/jui/userMenuDeploy.jsp";
		$.pdialog.open(url, "deployMenu", "配置个人常用功能", {
			width : 600,
			height : 400
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
	function judgeHasRole() {
		var url = "/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='initHome' type='crypto'/>"
				+ "&actions=<sc:fmt value='judgeHasRole' type='crypto'/>";
		$.ajax({
			type : "POST",
			url : url,
			data : null,//前台发给后台的数据。     
			dataType : "JSON",
			processData : false,
			success : function(data) {

				//处理是否显示“切换角色”
				var switchrole = data.switchrole;
				if ("1" == switchrole) {
					$("#changeRole").show();
					$(".currentRole").show();
				} else {
					$("#changeRole").hide();
					$(".currentRole").hide();
				}

				var flag = data.flag;
				if ("0" == flag) {
					alertMsg.warn("用户无任意角色权限，请联系管理员分配！\n 点击确认按钮将退出系统！", {
						okCall : function() {
							location.href = "/logout.jsp";
						}
					});
				} else if ("1" == flag) {
					ajaxLoadTopMenuAndLeftMenu();

				} else if ("2" == flag) {
					//选择角色
					changeRole();
				} else {
					alertMsg.error("角色查询异常！");
				}

			}
		});

	}

	//查询数据日期
	function queryDataDate() {
		var url = "/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='initHome' type='crypto'/>"
				+ "&actions=<sc:fmt value='queryDataDate' type='crypto'/>";
		$.ajax({
			type : "POST",
			url : url,
			data : null,//前台发给后台的数据。     
			dataType : "JSON",
			processData : false,
			success : function(data) {
				$("#dataDateSpan").text("数据日期：" + data);
			}
		});
	}

	
	 //初始化菜单
	function initLeftNavMenu(menuid) {
		$("#folderNavMenu").html("");
		$("#navDropdown .dropdown").html("");
		//从js缓存读取菜单样式，如果未进行缓存，则请求后台得到菜单样式，并初始化缓存Jraf.menuStyle
		if (Jraf.menuStyle == null) {
			getMenuStyle();
		}
		//Jraf.menuStyle='1'表示普通菜单样式，'2'表示树型菜单样式
		if (Jraf.menuStyle == "2") {
			initTreeMenu(menuid);
			return;
		}
		if (Jraf.menuStyle == "1") {
		  initFolderMenu(menuid);
			return;
		}
	}
	 
	 
	 
	function initMenu(menuid){
		var currentRole = $("#currentRoleid_id").val();
		
		if (menuid == null || menuid == "") {
			getMenuStyle();
			if(Jraf.menuStyle == "2" || Jraf.menuStyle == "1"){
				menuid = $("#navMenu li:first input").val();
			}else if(Jraf.menuStyle == "3"){
				menuid = $("#navDropdown li:first input").val();
				$(".sun-toggle").hide();
				$(".accordion").hide();
				$("#sidebar").hide();
			}
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
				if(Jraf.menuStyle == "1"){
					linkurl = "/jui/menu-list.jsp?menuid=" + menuid;
				}else if(Jraf.menuStyle == "2"){
					var html = "<li><a class='side-first' ";
					if(linkurl){
						html += "href=\""+linkurl+"\" target=\""+target+"\" rel='"+rel+"'"; 
						if(external){
							html += "external=\"true\" ";
						}
					}
					html += ">";
					//去除图标
					html += menuname
					html += "<span class='right-i down'></span></a><ul style='display:none'id='"+menuid+"'></ul><li>";
					$("#folderNavMenu").append(html);
					initChildFolderMenu(menuid);
					continue;
				}else if(Jraf.menuStyle == "3"){
					 var html ="<li><a title=\""+menuname+"\" ";
					 if(linkurl){
						html += "href=\""+linkurl+"\" target=\""+target+"\" rel='"+rel+"'"; 
						if(external){
							html += "external=\"true\" ";
						}
					 }
					 html += ">";
					 html += menuname + "<span class='right-i down'></span></a><ul id='"+menuid+"'></ul></li>"; 
					 $('#navDropdown .addContent .dropdown-menu').append(html); 
					 initChildFolderMenu(menuid);
					 continue;
				}	
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
				if (ismenuVisitLog && "1" == isleaf) {
					onclick = "menuVisitLog('" + encodeURI(linkurl) + "','"+ menuid + "','" + menuname + "');";
				}
			     if(Jraf.menuStyle == "2"){
					var html = "<li id=\""+menuid+"\"><li><a class=\"side-first\" href=\""+linkurl+"\" target=\""+target+"\" ";
					if(external){
						html += " external=\"true\" ";
					}
					html += "onclick=\""+onclick+"\" rel='"+rel+"' title='"+menuname+"'>";
					html += menuname + "</a></li>";
					$("#folderNavMenu").append(html);
				}else if(Jraf.menuStyle == "3"){
					var html = "<li id='"+menuid+"'><a href=\""+linkurl+"\" target=\""+target+"\" onclick=\""+onclick+"\" ";
					if(external){
						html += " external=\"true\" ";
					}
					html += "rel=\""+rel+"\" title=\""+menuname+"\">";
					html += menuname + "</a></li>";
					$('#navDropdown .addContent .dropdown-menu').append(html); 
				}
			}
			
			if(Jraf.menuStyle == "1"){
				var html = "<li class=\"first\"><a href=\""+linkurl+"\" target=\""+target+"\" onclick=\""+onclick+"\" rel=\""+rel+"\"";
				if(external){
					html += " external=\"true\" ";
				}
				html += " title=\""+menuname+"\">";
				html += menuname + "</a></li>";
				$("#leftNavMenu").append(html);
			}
		}
		if(Jraf.menuStyle == "1" || Jraf.menuStyle == "2"){
			initUI($("#leftside"));
		}else if(Jraf.menuStyle == "3"){
			initUI($("#navDropdown"));
		}
		
		if (!hasInitHomePageInfo) {
			initHomePageInfo();//初始化首页信息 
			hasInitHomePageInfo = true; // 首页信息只加载一次
		}
	}

	/* 初始化top菜单*/

		function initTopMenu(menuid) {
			$('#navDropdown .dropdown-menu >li').remove(); 
			initMenu(menuid);
		}
		//初始化单层树形菜单
		function initFolderMenu(menuid) {
			$("#folderNavMenu").append("<div class='accordionContent'><ul class='tree' id='leftNavMenu'></ul></div>");
			initMenu(menuid);
		}
		
		//初始化树型一级菜单
		function initTreeMenu(menuid) {
			initMenu(menuid);
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
								linkurl = data;
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
		
		
	/*
	 * 加载顶部和左边菜单
	 */
	 
	function ajaxLoadTopMenuAndLeftMenu() {
		getMenuStyle();
		if(Jraf.menuStyle == "2" || Jraf.menuStyle == "1"){
			$("#navMenu").ajaxUrl({
				type : "POST",
				url : "/jui/nav_menu.jsp",
				data : null,
				callback : function(resData) {
					//判断角色一级菜单
					var docArray = $(resData).get();
					var flag=false;
					for(var i=0;i<docArray.length;i++){
						if($(docArray).get(i).tagName=="LI"){
							flag=true;
							break;
						}
					}
					if (!flag) {
						alertMsg.warn("未分配任意角色菜单权限！请联系管理员分配！\n 点击确认按钮将退出系统！", {
							okCall : function() {
								location.href = "/login.jsp";
							}
						});
					}
					//加载左部菜单
					initLeftNavMenu();
					doubledown($("#navMenu"));
				}
			});
		}
		else if(Jraf.menuStyle == "3" ){
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
				}
			});
		} 
	}
	

	function  updateTheme(skinname){
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+ "&oprID=<sc:fmt value='themeActor' type='crypto'/>"
			+ "&actions=<sc:fmt value='updateTheme' type='crypto'/>";
		$.ajax({
			type : 'POST',
			url : url,
			data:{skinname:skinname},
			dataType : 'xml',
			error : DWZ.ajaxError,
			async : true,
			success : function(data) {
				 
			},
			complete:function(serverData){
			}
		});	
	}
	//修改皮肤颜色，从DWZ框架获取
	 function setSkin(themeName){
		 var options={};
		 var op=$.extend({themeBase:"themes"},options);
		 var _themeHref=op.themeBase+"/#theme#/style.css";
		$("head").find("link[href$='style.css']").attr("href",_themeHref.replace("#theme#",themeName));
		if($.isFunction($.cookie))$.cookie("dwz_theme",themeName);}
</script>
</body>
</html>