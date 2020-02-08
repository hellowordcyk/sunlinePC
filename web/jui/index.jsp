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
    
	response.setHeader("Cache-Control", "no-cache");  
	response.setHeader("Pragma", "no-cache");  
	response.setDateHeader("Expires", 0);  
	
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
	<!-- 顶部Logo以及左侧菜单根据不同的风格在JS中加载不同的页面 -->
	<div id="menuType"></div>
	
	<!-- 右侧 -->			
	<div id="container">
		<!-- 显示区域 -->
		<div id="navTab" class="tabsPage">
			<!-- 叶签栏 -->
			<div class="tabsPageHeader">
				<div class="tabsPageHeaderContent">
					<!-- 显示左右控制时添加 class="tabsPageHeaderMargin" -->
					<ul class="navTab-tab">
						<!-- 叶签 --> 
						<li tabid="main" class="main">
							<a href="javascript:;">
								<span>
									<span><i class="fa fa-home fa-lg"></i> &nbsp;首页</span>
								</span>
							</a>
						</li>
					</ul>
				</div>
				
				<!-- 叶签较多时左箭头  禁用只需要添加一个样式 class="tabsLeft tabsLeftDisabled"-->
				<div class="tabsLeft">left</div>
				
				<!-- 叶签较多时右箭头  禁用只需要添加一个样式 class="tabsLeft tabsLeftDisabled"-->
				<div class="tabsRight">right</div>
				
				<!-- 叶签栏右边全屏按钮 -->
				<div class="changescale hidden-xs"><i class="fa fa-window-maximize"></i></div>
				
				<!-- 叶签栏右边更多按钮 -->
				<div class="tabsMore">more</div>
			</div>
			
			<!-- 叶签栏向下更多箭头展示 -->
			<ul class="tabsMoreList">
				<li><a href="javascript:;">我的主页</a></li>
			</ul>
			
			<!-- 内容区域 -->
			<div class="navTab-panel tabsPageContent layoutBox">
				<div class="page unitBox homepage" style="overflow: auto;"></div>
			</div>
		</div>
		
		<!-- 底部 -->
		<div id="footer">
			<input type="hidden" name="currentUserCode"/>
   			<input type="hidden" name="currentCorpCode"/>
   			<input type="hidden" id="currentRoleid_id">
   			<input type="hidden" id="userFavorMenu_id" value="<%=SysConstants.USER_FAVOR_ID%>" />
			<span style="float: left; line-height: 21px;">${footer}</span>
			<span class="currentRole" style="line-height: 21px;"></span>
			<span class="currentDept" style="line-height: 21px;"></span>
			<span id="dataDateSpan" style="line-height: 21px;"></span>
		</div>
		
	</div>
	</div>
</body>

<script type="text/javascript">
var hasInitHomePageInfo = false;//判断首页配置是否已经加载，只加载一次 
var ismenuVisitLog = false; //菜单访问日志是否启动
var switchRole = false; //切换角色标志

/**
 * JUI初始化
 */
$(function() {
	DWZ.init("/jui/dwz.frag.xml", {
		loginUrl: "/login_dialog.jsp",
		loginTitle: "登录",
		statusCode: {ok: 200, error: 300, timeout: 301},
		pageInfo: {pageNum: "PageNo", numPerPage: "PageSize", orderField: "orderField", orderDirection: "orderDirection"},
		debug: false,//调试模式  true|false
		callback : function() {
			initEnv();
			//设置themeBase相对于index页面的主题base路径
			$("#themeList").theme({themeBase: "/jui/themes"});

			//检查用户角色
			judgeHasRole();
			//判断密码是否过期
			checkPasswordDate();
			//是否记录菜单访问日志
			getMenuVisitLogStatus();
			//底部显示数据日期
			queryDataDate();
		}
	});
});

/**
 * 检查用户角色
 */
function judgeHasRole(){
	var url = "/jsonprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+ "&oprID=<sc:fmt value='initHome' type='crypto'/>"
			+ "&actions=<sc:fmt value='judgeHasRole' type='crypto'/>";
	$.ajax({
		type: "POST",
		url: url,
		dataType: "JSON",
		processData: false,
		success: function(data) {

			//处理是否显示“切换角色”

			//角色切换之后请求查询完之后的操作
			var switchrole = data.switchrole;
			if ("1" == switchrole) {
				switchRole = true;
				$(".currentRole").show();
				//重新调用一下页面重新加载的方法
				//initHomePageInfo();

			} else {
				switchRole = false;
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
				//initHomePageInfo();
				loadMenu();
				//window.location.reload();
			} else if ("2" == flag) {
				//切换角色
				changeRole();
			} else {
				alertMsg.error("角色查询异常！");
			}
		}
	});	
}

/**
 * 判断用户是否第一次登录或密码是否过期
 */
function checkPasswordDate() {
	var url = "/xmlprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+ "&oprID=<sc:fmt value='Login' type='crypto'/>"
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
				openPassWordDialog(1); //1代表过期标志！  	 
			}
		}
	});
}

/**
 * 打开修改密码Dialog
 * @param flag 密码过期标志
 */
function openPassWordDialog(flag,obj){
	var url = "/httpprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+ "&oprID=<sc:fmt value='EditPassword' type='crypto'/>"
			+ "&actions=<sc:fmt value='findPasswordById' type='crypto'/>"
			+ "&forward=<sc:fmt value='/jui/password.jsp' type='crypto'/>"
			+ "&msg=" + flag;
	if (flag == 1) {
		//修改密码完成 刷新页面
		$.pdialog.open(url, "updatepassword", "修改密码", 
		    {
				width: 500, height: 350, maxable: false, mask: "true",
				close: function(param){
					if (!param || param.success != true) {
						alertMsg.confirm("正常使用系统前，请修改密码！<br/><span class='info'><i><确定>修改密码，<取消>退出系统</i></span>",{
							cancelCall: function() {
								window.location.href = "/logout.jsp";
							}
						});
						return false;
					} else {
						window.location.href = "/jui/index.jsp";
						return true;
					} 
				 }
			}
		);
	} else {

		$("#"+obj).loadUrl(url, {}, function() {});
	}
}
	
/**
 * 是否记录菜单访问日志
 */
function getMenuVisitLogStatus() {
	var url = "/jsonprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
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

/**
 * 查询数据日期
 */
function queryDataDate() {
	var url = "/jsonprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+ "&oprID=<sc:fmt value='initHome' type='crypto'/>"
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

/**
 * 切换角色
 */
function changeRole() {

	var currentRole = $("#currentRoleid_id").val();
	var url = "/httpprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+ "&oprID=<sc:fmt value='initHome' type='crypto'/>"
			+ "&actions=<sc:fmt value='queryUserRoles' type='crypto'/>"
			+ "&forward=<sc:fmt value='/jui/userrolelist.jsp' type='crypto'/>"
			+ "&currentRole=" + currentRole;
	$.pdialog.open(url, "changeLoginUserRole", "切换角色", {width: 600, height : 400, maxable : false, mask : "true"});
}

/**
 * 切换角色回调
 */
function changeRoleInit(defaultRoleid) {
	judgeHasRole();
}

/**
 * 初始化角色首页
 */
function initHomePageInfo(defaultRoleid) {
	var url = "/xmlprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+ "&oprID=<sc:fmt value='initHome' type='crypto'/>"
			+ "&actions=<sc:fmt value='queryHomePageInfo' type='crypto'/>";
	if(defaultRoleid){
		url += 	"&defaultRoleid=" + defaultRoleid;	
	}
	$.ajax({
		type: "POST",
		url: url,
		dataType: "xml",
		success: function(data) {

			var currentRolena = $(data).find("currentRolena").text();
			var currentUsercode = $(data).find("currentUsercode").text();
			var currentUserna = $(data).find("currentUserna").text();

			var currentDeptna = $(data).find("currentDeptna").text();
			var currentRoleid = $(data).find("currentRoleid").text();
			var indexlogoPath = $(data).find("indexlogoPath").text();
			var currentCorpCode = $(data).find("Session corpcode").text();
			//alert("页面刷新之后调用的方法:"+currentUserna);
			$(".currentRole").eq(0).text("角色："+currentRolena);
			$(".currentUser").eq(0).text(currentUserna + "("+currentUsercode+")");
			//console.log("====zzz==="+$("#currentUser").text());


			// $("input[name='currentUserCode']").val(currentUsercode);
			$("input[name='currentCorpCode']").val(currentCorpCode);
			$(".currentDept").eq(0).text("机构："+currentDeptna);
			$("#currentRoleid_id").val(currentRoleid);
			
			if(indexlogoPath != null && indexlogoPath != ""){
				$("#indexlogo").css("background","url('"+indexlogoPath+"') no-repeat 0 0");
			}
			
			//初始化首页功能配置
			initHomePageFunc($(data).find("homePageFuncs"));
			
			//初始化Tab标签页
			initHomePageTab($(data).find("homePageTabs"));
		}
	});
	navTab._scrollTab(0);//首页标签页偏移 
}

/**
 * 初始化首页配置功能  
 */
function initHomePageFunc($homePageFuncs) {
	var homepageDiv = $(".homepage");
	//初始化之前 先清空
	homepageDiv.empty(); 
	
	if ($homePageFuncs.length > 0) {
		for (var i = 1; i <= 9; i++) {
			for (var j = 1; j <= 9; j++) {
				var rc = i + "" + j;
				$("Record", $homePageFuncs).each(function(i, record) {
					var funrc = $("cell_coordinate", record).text();
					if (rc == funrc) {
						var funname = $("function_name", record).text();
						var funurl = $("function_url",record).text();
						var function_id = $("function_id",record).text();
						var funwidth = $("width_rate",record).text();
						var funheight = $("height", record).text();
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

/**
 * 添加首页配置功能
 */
function addHomeTableCell(funwidth, funheight, funname, funurl,function_id) {
	var rel = funurl.substring(funurl.lastIndexOf("/") + 1, funurl.lastIndexOf("."));
	var html = "<div class='homepagecell' style='width:"+funwidth+";height:"+funheight+";'>" + "</div>";
	$(".homepage").append(html);
	var data = {"function_id":function_id};
	$(".homepage").find("div.homepagecell:last").loadUrl(funurl, data);
}

/**
 * 打开详细
 */
function openFuncDetail(funid, funname, funurl) {
	navTab.openTab(funid, funurl, {title: funname, fresh: false, data: {}});
}

/**
 * 初始化首页Tab标签页 
 */
function initHomePageTab($homePageTabs) {
	if ($homePageTabs.length > 0) {
		$("Record", $homePageTabs).each(function(i, record) {
			var tabname = $("function_name", record).text();
			var taburl = $("function_url", record).text();

			navTab.openTabNoInit("homepage" + i, taburl, {
				title : tabname,
				fresh : false,
				data : {}
			});
		});
	}
	navTab._switchTab(0);//选择首页标签页
}

/**
 * 加载菜单
 */
function loadMenu(){

	getMenuStyle();
	if(Jraf.menuStyle){
		var url = "/jui/menustyle"+Jraf.menuStyle+".jsp";

		$("#menuType").ajaxUrl({
			type: "POST", 
			url: url,
			
		
		});
	}else{
		alertMsg.error("查询菜单样式失败");
	}
}

/**
 * 查询菜单样式
 */
function getMenuStyle() {
	var url = "/xmlprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
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

/**
 * 初始化菜单缓存
 */
function initMenuCache(menuid, currentRole) {
	var url = "/jsonprocesserservlet"
			+ "?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+ "&oprID=<sc:fmt value='initMenu' type='crypto'/>"
			+ "&actions=<sc:fmt value='initLeftNavMenu' type='crypto'/>"
			+ "&menuid=" + menuid 
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
				Jraf.menuCacheMap[menuid] = data;
			}
		}
	});
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
			setSkin(skinname);
		},
		complete:function(serverData){
		}
	});	
}

//修改皮肤颜色
function setSkin(themeName){
	 var options={};
	 var op=$.extend({themeBase:"themes"},options);
	 var _themeHref=op.themeBase+"/#theme#/style.css";
	$("head").find("link[href$='style.css']").attr("href",_themeHref.replace("#theme#",themeName));
	if($.isFunction($.cookie))$.cookie("dwz_theme",themeName);
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
//常用菜单配置
function deployMenu() {
	var url = "/jui/userMenuDeploy.jsp";
	$.pdialog.open(url, "deployMenu", "配置个人常用功能", {
		width : 600,
		height : 400
	});
}
</script>
</html>