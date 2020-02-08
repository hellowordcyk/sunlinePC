<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="com.sunline.jraf.util.DatetimeUtil"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="org.jdom.*" %>
<%@ page import="java.util.List"%>

<% request.setCharacterEncoding("UTF-8");%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title><%=BimisConf.getSiteName()%></title>
</head>
<body bgcolor="#EEEEEE" onload="form1.usercode.focus();">
<form name="form1" method="post" action="/httpprocesserservlet">
<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
<input type="hidden" name="oprID" value="<sc:fmt value='sm_permission' type='crypto'/>">
<input type="hidden" name="actions" value="<sc:fmt value='login' type='crypto'/>">

<table border="0" cellpadding="0" cellspacing="0" align="center">
  <tr>
    <td rowspan="7">&nbsp;</td>
    <td colspan="7"> <img src="/common/images/pic01/denglu_03.gif" width="659" height="108" alt=""></td>
  </tr>
  <tr>
    <td rowspan="5"> <img src="/common/images/pic01/denglu_05.gif" width="299" height="361" alt=""></td>
    <td colspan="5"> <img src="/common/images/pic01/denglu_06.gif" width="317" height="81" alt=""></td>
    <td rowspan="5"> <img src="/common/images/pic01/denglu_07.gif" width="43" height="361" alt=""></td>
  </tr>
  <tr>
    <td colspan="5" background="/common/images/pic01/denglu_08.gif" width="317" height="104" valign="bottom"></td>
  </tr>
  <tr>
    <td rowspan="3"> <img src="/common/images/pic01/denglu_09.gif" width="81" height="176" alt=""></td>
    <td background="../..//common/images/pic01/denglu_10.gif" width="55" height="54" alt=""></td>
    <td colspan="3" background="/common/images/pic01/denglu_11.gif" width="181" height="54" alt="">
      <table>
        <tr>
          <td width="53%" valign="middle" style="font-size: 9pt;"><font color="#FFFFFF">用户:</font><input class="formtextfield" type="text" name="usercode" onkeypress="checkUser();" style="FONT-WEIGHT: normal; FONT-SIZE: 12px; WIDTH: 120px; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-VARIANT: normal" maxLength=25></td>
        </tr>
        <tr>
          <td colspan="2" valign="middle" style="font-size: 9pt;"><font color="#FFFFFF">密码:</font><input class="formtextfield" type="password" name="userpwd" onkeypress="checkPwd();" style="FONT-WEIGHT: normal; FONT-SIZE: 12px; WIDTH: 120px; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-VARIANT: normal" maxLength=25></td>
        </tr>
    </table></td>
  </tr>
  <tr>
    <td colspan="2" rowspan="2"> <img src="/common/images/pic01/denglu_12.gif" width="116" height="122" alt=""></td>
    <td> <img src="/common/images/pic01/denglu_13.gif" width="76" height="48" alt="" onclick="clickLogin();" style="cursor:hand"></td>
    <td rowspan="2"> <img src="/common/images/pic01/denglu_14.gif" width="44" height="122" alt=""></td>
  </tr>
  <tr>
    <td> <img src="/common/images/pic01/denglu_15.gif" width="76" height="74" alt=""></td>
  </tr>
  <tr>
    <td colspan="7"></td>
  </tr>
  <tr>
    <td> <img src="/common/images/spacer.gif" width="60" height="1" alt=""></td>
    <td> <img src="/common/images/spacer.gif" width="299" height="1" alt=""></td>
    <td> <img src="/common/images/spacer.gif" width="81" height="1" alt=""></td>
    <td> <img src="/common/images/spacer.gif" width="55" height="1" alt=""></td>
    <td> <img src="/common/images/spacer.gif" width="61" height="1" alt=""></td>
    <td> <img src="/common/images/spacer.gif" width="76" height="1" alt=""></td>
    <td> <img src="/common/images/spacer.gif" width="44" height="1" alt=""></td>
    <td> <img src="/common/images/spacer.gif" width="43" height="1" alt=""></td>
    <td> <img src="/common/images/spacer.gif" width="81" height="1" alt=""></td>
  </tr>
</table>
</form>
</body>
</html>
<Script language="JavaScript" >

String.prototype.trim = function()
{
    return this.replace(/(^\s*)|(\s*$)/g,"");
}
function checkUser()
{
	if(13 == event.keyCode)
	{
		if("" == form1.usercode.value.trim())
		{
			alert("请输入用户名");
			return;
		}
		form1.userpwd.focus();
	}
}
function checkPwd()
{
	if(13 == event.keyCode)
	{
		if("" == form1.userpwd.value.trim())
		{
			alert("请输入用户密码");
			return;
		}
		form1.submit();
	}
}

function clickLogin()
{
		if("" == form1.userpwd.value.trim())
		{
			alert("请输入用户密码");
			return;
		}
		form1.submit();
}

</Script>