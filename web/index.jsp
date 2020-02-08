<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.sunline.cn/jsp/common" prefix="sc"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="java.util.Properties" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="com.sunline.jraf.util.FileUtil" %>
<%
String str = null;
Properties pro = null;
BufferedInputStream in = null;
try{
    String path = FileUtil.getHomePath()+"suncrs_config.properties";
    in = new BufferedInputStream(new FileInputStream(path));
     pro = new Properties();
    pro.load(in);
    in.close();
     str = pro.getProperty("isFirstLogin");
    if(!str.equals("0")||str==null)
        response.sendRedirect("/governor/initlogin/config.jsp");
    }catch(Exception e){
        log.error(e.getMessage());
    }
    response.setHeader("Pragma", "No-cach");
    response.setHeader("Expires", "0");
    response.setHeader("Widow-target", "_top");

    Cookie[] cookies = request.getCookies();
    
    String cookVal = "";
	String cssPath = "common/skins/outlook";
	String username="";
	String userpwd="";
    if(cookies!=null){
	    for(Cookie c:cookies){
	    	if("skinname".equals(c.getName())){
	    		cookVal = c.getValue();
	    	
	    	}
	    	if("usercode".equals(c.getName())){
	    		username = c.getValue();
	    	
	    	}
	    	if("userpwd".equals(c.getName())){
	    		userpwd = c.getValue();
	    	
	    	}
	    }
	    if("redstyle".equals(cookVal)){
	    	cssPath = "common/skins/redstyle";
	    }
    }
    }catch (Exception e) {
		
	}finally{
    	try {
			os.close();
		} catch (IOException e) {
		}
    }
%>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><%=BimisConf.getSiteName()%></title>
    <script type="text/javascript" src="/common/scripts/prototype1.7.js"></script>
    <script type="text/javascript" src="/common/scripts/Jraf_prototype.js"></script>
    <script type="text/javascript" src="/common/scripts/checkForm.js"></script>
    <link rel="stylesheet" type="text/css" href="<%=cssPath %>/theme/login.css"/>
     <link rel="stylesheet" type="text/css" href="<%=cssPath %>/theme/style-custom.css"/> 
<link rel="stylesheet" href="theme/login.css" type="text/css" media="all" />  

<style type="text/css"> 

ul, li{
	margin:0;
	padding:0;
}
input{
	border:1px solid #908f8f;
	height:22px;
}
.inputover{
	border:1px solid #4792b9;
	background-color:#fff;
}
.inputout{
	border:1px solid #908f8f;
}

</style>
</head>
<body style="background-color:#eee;">
<div id="contaniner">
	<div id="main-content">
	<div id="login-logo" style="width: 500px;height: 70px;margin-top: 100px"></div>
    	<div class="centertable" style="padding-top: 0px">
    	<form name="form1" method="post" action="/httpprocesserservlet" style="margin-top: 20px">
		<input type="hidden" name="sysName" value='<sc:fmt type="crypto" value="pcmc"/>' />
		<input type="hidden" name="oprID" value='<sc:fmt type="crypto" value="sm_permission"/>' />
		<input type="hidden" name="actions" value='<sc:fmt type="crypto" value="login"/>' />
			<table width="100%" cellpadding="0" cellspacing="0" class="content" align="center">
			  <tr>
				<td align="right">用户名：</td>
				<td align="left"> 
					<input type="text" name="usercode" style="width: 180px;line-height: 20px" value="<%=username %>" id="name" 
                   onkeydown="if (event.keyCode==13) {if (checkUser()) $('password').focus();}"
                   onmouseover="this.className='inputover'" onmouseout="this.className='inputout'" 
                   req="1" displayname="用户名" customtype='userNo'/>
                   </td>
			  </tr>
			  <tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr>
				<td align="right">密&nbsp;&nbsp;&nbsp;码：</td>
				<td align="left">
					<input type="password" name="userpwd" style="width: 180px;" id="password"  value="<%=userpwd %>"
                   onkeydown="if (event.keyCode==13) {clickLogin();}"
                   onmouseover="this.className='inputover'" onmouseout="this.className='inputout'"
                   req="1" displayname="密码" customtype='password'/></td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			  <tr>
				  <td>&nbsp;</td>
				  <td align="left" >
					  <input type="button" name="btn" onclick="clickLogin();" onmouseover="this.className='btn-over'" onmouseout="this.className='btn'" class="btn" value="" />
				  </td>						
			  </tr>
			</table>
			</form>
		</div>
	</div>
</div>
<div id="footer">版权所有：深圳长亮科技 2012-2014 Sunline Co.Ltd. V1R2| 建议使用IE6以上版本   1024*768以上屏幕分辨率</div>
</body>
<script language="javascript" defer="defer">
var obj = document.getElementById("name");
obj.focus();

var g_oForm = document.forms("form1");

if (window.top != window.self) {
    window.top.location.href="/index.jsp";
}

function checkUser() {
    if (!checkForm($("name"))){
        return false;
    }
    return true;
}

function checkPassword() {
    if (!checkForm($("password"))){
        return false;
    }
    return true;
}

function clickLogin() {
    if (!checkUser() || !checkPassword()) {
        return;
    }
    checklogin();
}

function checklogin(){

    var ajax = new Jraf.Ajax();
    var params = {
            sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
            oprID:      '<sc:fmt type="crypto" value="sm_permission"/>',
            actions:    '<sc:fmt type="crypto" value="checklogin"/>',
            usercode :  $$('input[name="usercode"]')[0].value,
            userpwd :   $$('input[name="userpwd"]')[0].value
         };
        
        ajax.sendForXml('/xmlprocesserservlet', params, function(xml){
             try {
                 var pkg = new Jraf.Pkg(xml);
                 if (pkg.result() != '0') {
                     if(pkg.result() == '9999') {
                         hint_alert($$('input[name="userpwd"]')[0],pkg.allMsgs().replace("ERROR:",''));
                     } else {
                         hint_alert($$('input[name="usercode"]')[0],pkg.allMsgs().replace("ERROR:",''));
                     }
                     return;
                 } else {
                     g_oForm.submit();
                 }
             } catch(ex) {
                 alert('[method=checklogin]ERROR:' + ex);
             }
        }); 
}
</script>
</html> 