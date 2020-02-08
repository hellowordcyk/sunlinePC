<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html>
<div class="loginForm" style="margin-top:40px">
    <form name="loginForm" action="/httpprocesserservlet" class="pageForm required-validate" 
		onsubmit="return false" method="post">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>">
        <input type="hidden" name="oprID" value="<sc:fmt value='Login' type='crypto'/>">
        <input type="hidden" name="actions" value="<sc:fmt value='login' type='crypto'/>">
		<input type="hidden" name="usercode" value="${sessionScope.usercode }"/>
    	<input type="hidden" name="corpcode" value="${sessionScope.corpcode }"/>
        <input type="hidden" id="jraf_usercode" name="jraf_usercode" />
  	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
            	<tr>
                    <td class="form-label">用户名：</td>
                    <td class="form-value">${sessionScope.usercode }</td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>密&nbsp;&nbsp;&nbsp;码：</td>
                    <td class="form-value">
                         <input type="text" id="jraf_password" onkeydown="enter(this)" size="20" class="login_input required" /><!--修改此处请修改js中"设置浏览器不记住密码"，"兼容火狐不记住密码"相应的代码  -->
                         <input type="hidden" name="jraf_password" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="formBar">
        <ul>
            <li><button class="savebtn" type="button"  onclick="checkLogin(this)">解锁</button></li>
            <li><button class="savebtn" type="button" onclick="logout()">退出</button></li>
        </ul>
    </div>
    </form>
</div>
<%
//加载用户信息后，再注销sessionid
session.invalidate();
%>
<script>
var usercode = $("input[name='currentUserCode']").val();
var corpcode = $("input[name='currentCorpCode']").val();
 $(function(){
	$(".form-value:first",$.pdialog.getCurrent()).text(usercode);
});

/*  设置浏览器不记住密码*/
function verifyPassword(thisObj){
	 $(thisObj).prev("input").val($(thisObj).val());
} 
$(function() { 
	if($.browser.msie) {
		/* 不记住密码  兼容ie */
		var $password = $("#jraf_password");
		var html="<input  type='text' style='display:none'> <input id='jraf_password' type='hidden'> <input type='password' size='20' autocomplete='off' class='login_input required'  onkeyup='verifyPassword(this)' onkeydown='enter(this)' />";
		$password.after(html);
		$password.remove();
	}else{
		/* 兼容其他浏览器 */
		$("#jraf_password",$.pdialog.getCurrent()).keyup(function(){
			$("#jraf_password",$.pdialog.getCurrent()).prop("type","password");
		})
	}
}) 


function checkLogin(event) {
	var form = $(event).closest("form");
	if(!$(form).valid()){
		return;
	}
	var password = $("#jraf_password",$.pdialog.getCurrent()).val();

	//$("input[name='corpcode']", $.pdialog.getCurrent()).val(corpcode);
	//$("input[name='usercode']", $.pdialog.getCurrent()).val(usercode); 
	var usercode = $("input[name='usercode']", $.pdialog.getCurrent()).val();
	var corpcode = $("input[name='corpcode']", $.pdialog.getCurrent()).val();
	
	$("input[name='jraf_usercode']", $.pdialog.getCurrent()).val(usercode + "/" + corpcode);
	
	if($.browser.mozilla){
		//兼容火狐不记住密码
		$("#jraf_password",$.pdialog.getCurrent()).val("");
		$("#jraf_password",$.pdialog.getCurrent()).prop("type","text");
    } 
	
	//将加密后的密码给隐藏框
	password=$.md5(password);
	$("input[name='jraf_password']", $.pdialog.getCurrent()).val(password);
	var params = {
		sysName : '<sc:fmt type="crypto" value="funcpub"/>',
		oprID : '<sc:fmt type="crypto" value="Login"/>',
		actions : '<sc:fmt type="crypto" value="checklogin"/>',
		userCode : usercode,
		jraf_password: password,
		corpcode: corpcode
	};
	$.ajax({
		url : '/xmlprocesserservlet',
		type : 'POST',
		data : params,
		dataType : 'xml',
		success : function(data) {
			var msg = $(data).find("msg").text();
			if ("success" == msg) {
				login(form);
            }else{
				alertMsg.error(msg);
			}
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert(textStatus + "：系统异常,请稍后重试或联系管理员!");
		}
	});
}
function login(form){
	$.ajax({
		url : '/xmlprocesserservlet',
		type : 'POST',
		data : $(form).serialize(),
		dataType : 'xml',
		success : function(data) {
			$.ajax({url: "/getToken.jsp", async: false,success: function(token) {
				g_csrfToken = token;
			}});
			$.pdialog.closeCurrent();
			Jraf.appendToken();
		},
		error : function(XMLHttpRequest, textStatus, errorThrown) {
			alert(textStatus + "：系统异常,请稍后重试或联系管理员!");
		}
	});
}
function logout(){
	window.top.location.href = "/login.jsp";
}


function enter(target) {
	if (event.keyCode == 13) {
		checkLogin(target);
	}else{
		return false;
	}
}
</script>
