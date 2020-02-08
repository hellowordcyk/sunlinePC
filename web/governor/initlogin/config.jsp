<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- <%@ page import="java.util.Properties" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="com.sunline.jraf.util.FileUtil" %> --%>
<%@ page session="false" %>
<%
/* String str = null;
Properties pro = null; */
String msg = "";
if(request.getAttribute("msg")!=null){
		msg=(String)request.getAttribute("msg");
}
/* try{
	String path = FileUtil.getHomePath()+"suncrs_config.properties";
	BufferedInputStream in = new BufferedInputStream(new FileInputStream(path));
	 pro = new Properties();
	pro.load(in);
	in.close();
	 str = pro.getProperty("isFirstLogin");
	}catch(Exception e){
		e.printStackTrace();
	} */
	response.setHeader("Pragma", "No-cach");
	response.setHeader("Expires", "0");
	response.setHeader("Widow-target", "_top");
	
	Object initPasswordObj = request.getAttribute("initPassword");
	String initPassword = "";
	if (null != initPasswordObj) {
		initPassword = initPasswordObj.toString();
	}
	%>
<html>
<head>
<link rel="stylesheet" type="text/css" href="/common/skins/default/theme/config.css">
</head>
<body class="img_topbg">
<form id="login_form" action="/governor" method="post" onsubmit="return checkPassword()">
<table width="100%" height="96%">
	<tr>
		<td>
			<div>
				<table align="center" cellpadding="0" cellspacing="0" class="congiflogin-table">
				<% 
					if ("true".equals(initPassword)) { 
				%>
					<tr id="captionTr">
						<td id="captionTd" colSpan="4" class="captionTd" style="padding-left: 20px;">首次登陆，请先设置密码</td>
					</tr>
				<%  } %>
					<tr id="promptTr">
						<td id="promptTd" colSpan="4" align="center" style="height:20px;"></td>
					</tr>
					<tr>
						<td width="100px">&nbsp;</td>
						<td align="right" style="padding-left: 50px;">用户名: </td>
						<td align="right"><input id="username" name="username" type="text" value="sysadmin" class="input-box" /></td>
						<td width="100px">&nbsp;</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td align="right" style="padding-left: 50px;">密  &nbsp;码: </td>
						<td align="right"><input id="password" name="password" type="password" class="input-box"/></td>
						<td style='font-size:10px;color:red' align="left"><%=msg%></td>
					</tr>
				<% 
					if ("true".equals(initPassword)) { 
				%>
					<tr id="confirmPasswordTr" align="right">
						<td>&nbsp;</td>
						<td>确认密码: </td>
						<td><input id="confirmPassword" type="password" class="input-box" onblur="checkPassword()"></td>
						<td id="msg" style='font-size:10px;color:red' align="left"></td>
					</tr>
				<%  } %>
					<tr align="right" height="35px">
						<td colspan="2">
						</td>
						<td>
							<input  type="submit" value="确定" onmouseover="this.className='btn-over'"
							onMouseOut="this.className='btn'" class="btn" value="登录" style="margin-right: 0;" />
							<input  type="reset" value="重置" id="reset_btn_ok" onMouseOver="this.className='btn-over'" 
							onMouseOut="this.className='btn'" class="btn" style="margin:0 0 0 7px;" />
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="4">&nbsp;</td>
					</tr>
				</table>
			</div>
		</td>
	</tr>
</table>
</form>
</body>
<script language="javascript">
firstLogin();
function firstLogin(){
	var username = document.getElementById("username").value;
	if (username == null || username == "") {
		document.getElementById("username").focus();
	} else {
		document.getElementById("password").focus();
	}
	<%-- var flage = <%=str%>;
	if(flage=='0'){
		var obj = document.getElementById("captionTd");
		var confirmPassword = document.getElementById("confirmPasswordTr");
		obj.innerHTML = '';
		confirmPassword.style.display='none';
	} --%>
}
function checkPassword(){
	var confirmPasswordObj = document.getElementById("confirmPassword");
	if(confirmPasswordObj != null){
		var password = document.getElementById("password").value;
		var confirmPassword = confirmPasswordObj.value;
		var msg = document.getElementById("msg");	
		if(password.length<4){
		  alert('请输入至少4位密码');
		  return false;
		}else if(password!=confirmPassword){
			msg.innerHTML='两次密码不一致';
			return false;
		}else{
			msg.innerHTML='';
			return true;
		}
	}
	return true;
}
</script>
</html>