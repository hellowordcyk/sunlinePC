<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.security.UserAuthenticator"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="com.sunline.funcpub.util.SysConstants"%>
<%@ page import="java.util.*"%>
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
	String menuId = request.getParameter("menuid");
	String params = request.getParameter("params");
%>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<title>${sitename}</title>
<%@include file="/jui/jui_common_header.jsp"%>
<%@include file="/jui/jui_common_foot.jsp"%>

</head>
<body scroll="no">
    <div id="layout">
        <div id="container" style="width:100%; position: absolute; top: 5px; left: 5px; padding: 0px;">
            <div id="navTab" class="tabsPage" style="padding-top:0px;">
                <div class="tabsPageHeader" style="display: none;">
                    <div class="tabsPageHeaderContent">
                        <!-- 显示左右控制时添加 class="tabsPageHeaderMargin" -->
                        <ul class="navTab-tab">
                            <li tabid="main" class="main" style="display:none;">
                                <a href="javascript:;">
                                    <span>
                                        <span class="home_icon">首页</span>
                                    </span>
                                </a>
                            </li>
                        </ul>
                    </div>
                    <div class="tabsLeft tabsLeftDisabled">left</div>
                    <!-- 禁用只需要添加一个样式 class="tabsLeft tabsLeftDisabled" -->
                    <div class="tabsRight tabsRightDisabled">right</div>
                    <!-- 禁用只需要添加一个样式 class="tabsRight tabsRightDisabled" -->
                    <div class="tabsMore">more</div>
                </div>
                <ul class="tabsMoreList" style="display: none;">
                    
                </ul>
                <div class="navTab-panel tabsPageContent layoutBox" style="padding-top:0px;">
                    <div class="page unitBox homepage" style="overflow: auto;"></div>
                </div>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript">
//jui 初始化
var ismenuVisitLog = false;  //菜单访问日志是否启动
$(function(){
	DWZ.init("/jui/dwz.frag.xml", {
        loginUrl:"/login_dialog.jsp", 
        loginTitle:"登录",	// 弹出登录对话框
        /**loginUrl:"/index.jsp",	// 跳到登录页面**/
		statusCode:{ok:200, error:300, timeout:301}, //【可选】
		pageInfo:{pageNum:"PageNo", numPerPage:"PageSize", orderField:"orderField", orderDirection:"orderDirection"}, //【可选】
		debug:false,	// 调试模式 【true|false】
		callback:function(){
			initEnv();
			$("#themeList").theme({themeBase:"/jui/themes"}); // themeBase 相对于index页面的主题base路径
			password_date();//密码过期判断
			queryDataDate();//查询数据日期
			getMenuInfo();
		}
	});
});

/*
 * 记录菜单访问日志
 */
function menuVisitLog(linkurl,menuid,menuname) {
	if(linkurl==null||linkurl.length<1) {
        return false;
    }
	var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
        + "&oprID=<sc:fmt value='menuLogActor' type='crypto'/>"
        + "&actions=<sc:fmt value='insertMenuVisitLog' type='crypto'/>"
        + "&menuId="+menuid+"&menuName="+encodeURI(encodeURI(menuname))+"&url="+linkurl;
	$.ajax({
        type:'POST',
        url: url,
        dataType:'text',
        error: DWZ.ajaxError,
        async:true,
        success:function(){
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
        type:'POST',
        url: url,
        dataType:'json',
        error: DWZ.ajaxError,
        async:true,
        success:function(data){
        	if("1"==data) {
        		ismenuVisitLog = true;
        	}else{
        		ismenuVisitLog = false;
        	}
        }
    });
}

//初始化首页Tab标签页 
function initSSOPageTab(menuid,menuname,linkurl){
	navTab.openTab(linkurl, linkurl, { title:menuname, fresh:false, data:{} });
}


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
        	   var msg = $(data).find("msg").text(); 
         	  if("error" == msg){	
         		 toupdate_password('1'); //1代表过期标志！  	 
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

function hasMenuPriv(menuid){
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>"+
    "&actions=<sc:fmt value='hasMenuPriv' type='crypto'/>&menuid="+menuid;
    var status = false;
    $.ajax({
	       type: "POST",
	       url: url,
	       data: {},//前台发给后台的数据。     
	       dataType : "xml",    
	       async:false,
	       success:function(data){  
	    	 var priv = $(data).find("DataPacket Response Data hasMenuPriv").first().text();
	    	 if("true"==priv) {
	    		 status = true;
	    	 }
	      }
	   });
    return status;
}

function getCryptoUrl(url) {
	var result = url;
	$.ajax({
        url:"/jui/CryptoUrl.jsp?_st="+(new Date().getTime()),
        data:{"url":url},
        async:false,
        success:function(data){result = data;}
    });
	return result;
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

function getMenuInfo(){
	var menuid = '<%=menuId%>';
	if(!menuid || "null"==menuid) {
		alertMsg.error("参数错误！");
		return;
	}
	if(!hasMenuPriv(menuid)) {
		alertMsg.error("您没有该菜单的访问权限！");
		return;
	}
	var params = '<%=params%>';
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>"+
    "&actions=<sc:fmt value='getMenuInfoById' type='crypto'/>&menuid="+menuid;
    var tempMenuId = "";
    var tempMenuName = "";
    var tempMenuUrl ="";
    $.ajax({
	       type: "POST",
	       url: url,
	       data: {"menuid":menuid},
	       dataType : "xml",    
	       async:true,
	       success:function(data){  
	    	 tempMenuId = $(data).find("DataPacket Response Data Record menuid").first().text();
	    	 tempMenuName = $(data).find("DataPacket Response Data Record menuname").first().text();
	    	 tempMenuUrl = $(data).find("DataPacket Response Data Record linkurl").first().text();
			 
			 tempMenuUrl = getCryptoUrl(tempMenuUrl);
			 tempMenuUrl = tempMenuUrl.replace(/(^\s*)|(\s*$)/g,'');
			 var paramUrl = params.replace(/,/g,"&");
			 var seperator = "?";
			 if(tempMenuUrl.indexOf("&")>-1||tempMenuUrl.indexOf("?")>-1) {
				 seperator = "&";
			 }
			 initSSOPageTab(tempMenuId,tempMenuName,tempMenuUrl+seperator+paramUrl);
			 menuVisitLog(tempMenuUrl,tempMenuId,tempMenuName);
	      },
	      error:function(err) {
	    	  alert(err);
	      }
	   });
    
     
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
</script>
</html>