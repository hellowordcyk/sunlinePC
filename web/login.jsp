<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.FileUtil"%>
<%@ page import="com.sunline.jraf.util.Crypto"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="java.util.Properties"%>
<%@ page import="java.io.BufferedInputStream"%>
<%@ page import="java.io.FileInputStream"%>
<%@ page import="com.sunline.funcpub.service.lang.SysPubI18nService"%>
<%@ include file="/jui_tag.jsp"%>
<%@ page import="com.sunline.jraf.security.UserAuthenticator"%>
<%
    String str = null;
    Properties pro = null;
    BufferedInputStream in = null;
    try {
        String path = FileUtil.getHomePath() + "suncrs_config.properties";
        in = new BufferedInputStream(new FileInputStream(path));
        pro = new Properties();
        pro.load(in);
        in.close();
        in = null;

        str = pro.getProperty("isFirstLogin");
        pro.clear();
        pro = null;

        if (str == null || !str.equals("0"))
            response.sendRedirect("/governor");
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (in != null) {
            in.close();
        }
    }
    response.setHeader("Pragma", "No-cach");
    response.setHeader("Cache-Control", "no-cache");
    response.setHeader("Expires", "0");
    response.setHeader("Widow-target", "_top");
    
    String sitename = BimisConf.getSiteName();
    String bankpic = BimisConf.getLoginBankpic();
    String loginfooter = BimisConf.getLoginFooter();
    
    request.setAttribute("sitename", sitename);
    request.setAttribute("bankpic", bankpic);
    request.setAttribute("loginfooter", loginfooter);
    String i18nCode = request.getParameter("i18nCode");
    
    /**
    *判断是否显示 语言选择框
    */
    boolean isOpenI18n = SysPubI18nService.isOpenI18n();
    
%>
<c:set var="varIsOpenI18n" value="<%=isOpenI18n %>" />
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>${sitename}</title>
<%--@include file="/jui/jui_common.jsp" --%>
<link href="/jui/themes/css/login.css" rel="stylesheet" type="text/css" />
<link href="/jui/themes/blue/style.css" rel="stylesheet" type="text/css"
	media="screen" />
<link href="/jui/themes/css/defaultStyle.css" rel="stylesheet"
	type="text/css" media="screen" />
<link href="/jui/themes/css/core.css" rel="stylesheet" type="text/css"
	media="screen" />
<link href="/jui/themes/css/jraf.css" rel="stylesheet" type="text/css"
	media="screen" />
<link href="/jui/themes/css/print.css" rel="stylesheet" type="text/css"
	media="print" />

<script src="/jui/js/jquery-1.7.2.js" type="text/javascript"></script>
<!-- <script src="/jui/encrypt/jquery.md5.js" type="text/javascript"></script>
 -->
<script src="/jui/bin/dwz.min.js" type="text/javascript"></script>
<script src="/jui/js/dwz.regional.zh.js" type="text/javascript"></script>

<script type="text/javascript"
	src="/jui/encrypt/components/rollups/tripledes.js"></script>
<script type="text/javascript" src="/jui/encrypt/components/mode-ecb.js"></script>

<style type="text/css">
input {
	border: none !important;
	border-style: none !important;
}

.pageForm {
	overflow: visible !important;
}
</style>
</head>
<body>
	 <div id="login">
        <div id="login_header">
            <h1 class="login_logo">
                <a href="/login.jsp">
                    <img src="${bankpic}" />
                </a>
            </h1>
        </div>
    </div>
	<div id="newlogin">
		<div class="left_bg">
			<div class="system-title">${sitename}</div>
		</div>
		<div class="right_content">
			<div id="login_bg">
				<div id="login_content">
					<div class="loginForm">
						<form name="loginForm" action="/httpprocesserservlet"
							class="pageForm required-validate" method="post"
							autocomplete="off">
							<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>">
							<input type="hidden" name="oprID" value="<sc:fmt value='Login' type='crypto'/>">
							<input type="hidden" name="actions" value="<sc:fmt value='login' type='crypto'/>">
							<input type="hidden" name="corpcode" value="" /> <input type="hidden" name="usercode" />

							<div class="banklogo"></div>

							<div class="user">
								<!--  <label for="usercode"><sc:message code="demo_add_username" default="用户名：" /></label> -->
								<label for="usercode"></label> <span
									style="display: inline-block;"> <input type="text"
									id="usercodeId" name="temp_usercode" size="20"
									placeholder="请输入用户名" class="login_input"
									onkeyup="cleanSpan(this)" value="${param.ucode }"
									onkeydown="enter(this,'password');" />
								</span>
							</div>


							<div class="password">
								<!-- <label for="userpwd"><sc:message code="demo_add_pwd" default="密&nbsp;&nbsp;&nbsp;码："></sc:message></label> -->
								<label for="userpwd"></label>
								<%--   <span id="forbidSavePasswordId" style="display: none;">
		                            禁用浏览器保存的密码提交到后台
		                        </span> --%>
								<input type="hidden" name="jraf_password" /> <span
									id="passwordSpan" style="display: inline-block;"> <!--修改此处请修改js中"设置浏览器不记住密码"，"兼容火狐不记住密码"相应的代码  -->
									<input id='password' type='text' size="20" placeholder="请输入密码"
									autocomplete='off' class="login_input"
									onkeyup="cleanSpan(this)" onkeydown="enter()" />
								</span>
							</div>
							<c:if test="${varIsOpenI18n }">
								<br />
								<br />
								<div>
									<label for="i18nCode"><sc:message code="language"
											default="语言切换：" /></label> <span style="display: inline-block;">
										<sc:select name="i18nCode" type="dict" key="pcmc,i18nCode"
											default="${param.lang }" includeTitle="false"
											attributesText=" onchange='changeI18n(this.value)'"
											nullOption="---请选择---"></sc:select>
									</span>
								</div>
							</c:if>

							<div class="login_bar">

								<button class="login_btn" type="button" name="btnsubmit"
									onclick="checkLogin(true)">登录</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div id="login_footer">${loginfooter}</div>
		</div>
	</div>
</body>
<script>
var g_csrfToken;
/*  设置浏览器不记住密码*/
function verifyPassword(thisObj){
	 $(thisObj).prev("input").val($(thisObj).val());
} 

$(function () {
    String.prototype.trim = function() {
        return this.replace(/(^\s*)|(\s*$)/g, "");
    };
    
    if($.browser.msie) {
		/* 不记住密码  兼容ie */
		var $password = $("#password");
		var html="<input  type='text' style='display:none'> <input id='password' type='hidden'> <input type='password' size='20' autocomplete='off' class='login_input'  onkeyup='cleanSpan(this),verifyPassword(this)'  onkeydown='enter()' />";
		$password.after(html);
		$password.remove();
	}else{
		/* 兼容其他浏览器 */
		$("#password").keyup(function(){
			$("#password").prop("type","password");
		})
	}
    
    jQuery.ajax({
		type:'GET',
		url:'/jui/dwz.frag.xml',
		dataType:'xml',
		timeout: 50000,
		cache: false,
		success: function(xml){
			$(xml).find("_PAGE_").each(function(){
				var pageId = $(this).attr("id");
				if (pageId) DWZ.frag[pageId] = $(this).text();
			});
			$(xml).find("_MSG_").each(function(){
				var id = $(this).attr("id");
				if (id) DWZ._msg[id] = $(this).text();
			});
		}
	});
    
});

   /**
    * 校验登录
    *
    */
function checkLogin(submitFlag) {

	var usercodeObj = document.getElementById("usercodeId");
	var userpwdObj = document.getElementById("password");
	var usercode = usercodeObj.value.trim();
	var userpwd = userpwdObj.value.trim();
	if (null == usercode || usercode == "") {
		hint_alert(usercodeObj, "用户名不能为空!");
		return;
	}
	if (null == userpwd || userpwd == "") {
		hint_alert(userpwdObj, "密码不能为空!");
		return;
	}
	if($.browser.mozilla){
		//兼容火狐不记住密码
		$("#password").val("");
		$("#password").prop("type","text");
       } 
	var arr = usercode.split("/");
	usercode = arr[0];
	var corpcode = arr[1];
	$("input[name='corpcode']").val(corpcode);
	$("input[name='usercode']").val(usercode);

	//userpwd = $.md5(userpwd);
		var key = "SUNLINES";
		var srcs = CryptoJS.enc.Utf8.parse(userpwd);
		var key = CryptoJS.enc.Utf8.parse(key);//Latin1 w8m31+Yy/Nw6thPsMpO5fg==
		var userpwd = CryptoJS.DES.encrypt(srcs, key, 
				{
			mode:CryptoJS.mode.ECB,
			padding: CryptoJS.pad.Pkcs7});
	var params = {
		sysName : '<sc:fmt type="crypto" value="funcpub"/>',
		oprID : '<sc:fmt type="crypto" value="Login"/>',
		actions : '<sc:fmt type="crypto" value="checklogin"/>',
		userCode : usercode,
		jraf_password: userpwd.toString(),//密码加密
		corpcode:corpcode
	};
	 
	$.ajax({
		url : '/xmlprocesserservlet',
		type : 'POST',
		data : params,
		//dataType : 'xml',
		success : function(data) {

			var msg = $(data).find("msg").text();
			if ("success" == msg && submitFlag==true) {
				//$("#forbidSavePasswordId").html("");
				//将加密后的密码回填到隐藏框，不将明文密码提交到后台
				//Input不设置name属性，就不会将属性值提交到后台
				 $("input[name='jraf_password']").val(userpwd);
                   $("form[name='loginForm']").submit();
               }else if("ssologin" == msg && submitFlag==true){
	            	alertMsg.confirm(DWZ.msg("ssologin_login"),{
	            		okCall:function(){
	            			$("input[name='jraf_password']").val(userpwd);
	                    	$("form[name='loginForm']").submit();
	            		}
	            	});
            	} else {
					if (msg.indexOf("用户") != -1) {
						hint_alert(usercodeObj, msg);
						cleanSpan(userpwdObj);
						return false;
					} else if (msg.indexOf("密码") != -1) {
						hint_alert(userpwdObj, msg);
						cleanSpan(usercodeObj);
						return false;
					} else if(msg.indexOf("法人编码")!=-1){
						hint_alert(usercodeObj, msg);
						cleanSpan(userpwdObj);
						return false;
	               	}else{
						hint_alert(usercodeObj, msg);
						cleanSpan(userpwdObj);
						return false;
					}
			}
			cleanSpan(usercodeObj);
			cleanSpan(userpwdObj);
			return true;
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert(textStatus + "：系统异常,请稍后重试或联系管理员!");
		}
	});
}

/**
 * 在元素旁边弹出浮动提示框
 * 注意： 元素的名称（name）值要唯一
 * @param obj        html元素对象
 * @param message   要显示的提示信息
 * @return
 */
function hint_alert(obj, message){
    if(obj == null) {
        alert("[filena=checkForm.js][method=hint_alert]ERROR: 第一个参数不能为空！");
        return;
    }
    if(message == null) {
        alert("[filena=checkForm.js][method=hint_alert]ERROR: 第二个参数不能为空！");
        return;
    }
    var idStr = (obj.id || obj.name) + "_hint_span";
    var spanEle = document.getElementById(idStr);
    if(!!spanEle){
        //$(idStr).remove();
    	spanEle.parentNode.removeChild(spanEle);
    }
    $(obj).after('<span id="'+idStr+'" class="hintspan"></span>');
    $(idStr).addClass("hintspan");
    spanEle = document.getElementById(idStr);
    	
    obj.setAttribute("__Jraf_Check_borerStyle", obj.style.borderStyle); 
    obj.setAttribute("__Jraf_Check_borerColor", obj.style.borderColor); 
    
    //设置位置
    $(obj).parent().css({"position": "relative"});
    spanEle.onclick= function (event){
       event.cancelBubble=true;
       //$(idStr).remove();
       cleanSpan(obj);
    };
    spanEle.innerHTML=message;
    //$(obj).after(spanEle);
    //限制宽度
    var spanW = $(spanEle).width();
   // $(spanEle).css({"left": $(obj).outerWidth()});
    $(spanEle).css({"left": (150)+"px"});
    if (spanW < 50) {
        $(spanEle).css({width: (50)+"px"});
    } else if (spanW > 400) {
        $(spanEle).css({width: (400)+"px"});
    }
    //输入框样式
    obj.style.borderStyle="dotted";
    obj.style.borderColor="#ff3300";
}

/**
 * 清除提示框
 * @param inputObj
 * @return
 */
function cleanSpan(inputObj){
    if(inputObj == null) {
        alert("[filena=checkForm.js][method=cleanSpan]ERROR: 参数不能为空！");
        return;
    }

    var borderStyle = inputObj.getAttribute("__Jraf_Check_borerStyle") || "";
    var borderColor = inputObj.getAttribute("__Jraf_Check_borerColor") || "";
    inputObj.style.borderStyle = (borderStyle=="dotted"?"":borderStyle);
    inputObj.style.borderColor = (borderColor=="#ff3300"||borderColor=="rgb(255, 51, 0)"?"":borderColor);
    
    var hintSpanObj = document.getElementById((inputObj.id || inputObj.name) + "_hint_span");
    if (!!hintSpanObj) {
        hintSpanObj.parentNode.removeChild(hintSpanObj);
    }
}

//ie添加enter登录事件
function enter(thisObj, nextId) {
	if (event.keyCode == 13) {
		event.returnValue = false;
		event.cancelBubble = true;
		event.cancel = true;
		
		if (thisObj != null && thisObj.id == "usercodeId") {
			//recreatePassword();
			$("#"+nextId).focus();
			return false;
		}
		$("[name='btnsubmit']").click();
	}
}

function changeI18n(i18nCode) {
	var url = window.location.href;
	var tempUserCode = document.getElementById("usercodeId").value.trim();
	if(url.indexOf("lang")>-1) {
		url = url.substring(0,url.indexOf("lang")+5)+i18nCode+"&ucode="+tempUserCode;
	}else{
		url = url+ "?lang="+i18nCode+"&ucode="+tempUserCode;
	}
	window.location.href = url+"&csrftoken="+g_csrfToken;
}
</script>
</html>