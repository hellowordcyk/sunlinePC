<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page session="false" %>
<%
response.setHeader("Pragma", "No-cach");
response.setHeader("Expires", "0");
response.setHeader("Widow-target", "_top");
%>
<html>
<head>
	<script src="/jui/js/jquery-1.12.4.min.js" type="text/javascript"></script>
</head>
<style>
body{
	position:relative;
	background:url(/common/skins/default/images/login/config/login_top_line.jpg) repeat right 0;
}
table{
	position:absolute;
	width: 501px;
	height: 277px;
	font-size:12px;
	background: url(/common/skins/default/images/login/config/login-table.jpg) no-repeat center 0; 
	display: block;	
	border-collapse: collapse;
	vertical-align: middle;
	top: 50%;
	left: 50%;
	margin-left:-250px;
	margin-top: -138px; 
}
.btn:hover{
	background: url(/common/skins/default/images/login/config/login-button-hover.gif) no-repeat;
}
.btn{
	background: url(/common/skins/default/images/login/config/loginbutton.gif) no-repeat;
	font-family: Arial, Helvetica, sans-serif;
    width: 70px;
    border: 0;
    height: 25px;
    line-height: 20px;
    color: #000;
    padding: 3px 7px 0;
    font: 12px;
    cursor: pointer;
    margin-right: 20px;
}
tbody{
	position:absolute;
	top: 60px;
	left: 160px;
}
tr {
	height: 30px;
}
input{
	width: 150px;
    height: 20px;
    background-color: #fff;
    border: 1px solid #248cbe;
}
</style>

<body>
	<form id="login_form" action="/governor" method="post" onsubmit="return checkPassword()">
		<input type="hidden" name="flag" value="login"/>
		<table>
			<tr>
				<td colSpan="2" align="center" style="color: red;"><c:if test="${isFirstLogin}">首次登陆，请先设置密码</c:if></td>
			</tr>
			<tr>
				<td align="right" style="font-weight: bold;">用户名</td>
				<td align="left" style="padding-left: 8px;"><input type="text" id="username" name="username" value="sysadmin"/></td>
			</tr>
			<tr>
				<td align="right" style="font-weight: bold;">密码</td>
				<td align="left" style="padding-left: 8px;"><input type="password" id="password" name="password"/></td>
			</tr>
			<tr>
				<td align="right" style="font-weight: bold;"><c:if test="${isFirstLogin}">确认密码</c:if></td>
				<td align="left" style="padding-left: 8px;"><c:if test="${isFirstLogin}"><input type="password" id="confirmpwd" name="confirmpwd"/></c:if></td>
			</tr>
			<tr>
				<td id="msg" colSpan="2" align="center" style="color: red;">${msg}</td>
			</tr>
			<tr>
				<td colSpan="2" align="center">
					<button class="btn" type="submit">确定</button>
					<button class="btn" type="reset">重置</button>
				</td>
			</tr>
		</table>
	</form>
</body>

<script language="javascript">
$(function(){
	var username = $("#username").val();
	if(username){
		$("#password").focus();
	}else{
		$("#username").focus();
	}
});
function checkPassword(){
	var $confirmpwd = $("#confirmpwd");
	if($confirmpwd){
		var password = $("#password").val();
		var confirmpwd = $("#confirmpwd").val();
		if(password.length < 4){
			$("#msg").html("请输入至少4位密码");
			return false;
		}else if(password != confirmpwd){
			$("#msg").html("两次密码不一致");
			return false;
		}
	}
	return true;
}
</script>
</html>