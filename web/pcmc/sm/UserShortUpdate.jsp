<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/preprocess.jsp"%>
<%String sysName = Crypto.encode(request, "pcmc");
			String oprID = Crypto.encode(request, "sm_maintenance");
			String actions = Crypto.encode(request, "updateUser");
			String act = rpu.getString("act", "");
			String userid = rpu.getString("userid", "");

			PkgUtil reqpkg = null;
			if (rpu.getXmlDoc() != null) {
				reqpkg = new PkgUtil(rpu.getXmlDoc());
				session.setAttribute("menutype",reqpkg.getRspDataStr("menutype"));
				session.setAttribute("PageSize",reqpkg.getRspDataStr("pagesize"));				
			}
%>
<Script language="JavaScript">
function showparent()
{
	if(window.opener){	   
	   window.opener.focus();
	}
}
window.onunload = showparent;
window.focus();
</Script>
<html>
<head>
<link rel="stylesheet" type="text/css" href="../../css/style.css">
<Script language="JavaScript" src="/js/checkValid.js"
	type="text/javascript"></Script>
<Script language="JavaScript" src="/js/checkForm.js"
	type="text/javascript"></Script>
	<TITLE>修改个人信息</TITLE>
</head>

<BODY background="/images/background.gif"
	style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; MARGIN: 0px; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none"
	 bgColor=#ffffff>
<form action="/httpprocesserservlet" method="post">
	<input type="hidden" name="sysName" value="<%=sysName%>"/>
	<input type="hidden" name="oprID" value="<%=oprID%>"/>
	<input type="hidden" name="actions" value="<%=actions%>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/pcmc/sm/UserShortUpdate.jsp' />"/>
	<sc:hidden name="userid" /> 
	<sc:hidden name="usercode" /> 
	<sc:hidden name="username" /> 
  <sc:fieldset name="修改个人信息">
	<sc:showrsmsg />
												<table border="0" width="100%" height="4" cellspacing="1" class="DefaultTable">
													<tr class="sysdisplay">
														<td width="30%" class="inputname" >用户编号：</td>
														<td class="inputvalue" width="70%"><sc:fmt name="usercode" />
															</td>
													</tr>
													<tr class="sysdisplay">
														<td width="30%" class="inputname" >用户名：</td>
														<td class="fieldvalue" width="70%"><sc:fmt name="username" />
															</td>
													</tr>													
													<tr class="sysdisplay">
														<td width="30%" class="inputname" >旧密码：</td>
														<td class="fieldvalue" width="70%">
															<input value="" type="password" name="userpwd" class="inputtext" size="20">
															(要修改密码必须输入旧密码，否则密码不会修改)</td>
													</tr>
													<tr class="sysdisplay">
														<td width="30%" class="inputname" >新密码：</td>
														<td class="fieldvalue" width="70%">
															<input value="" type="password" name="userpwd1" class="inputtext" size="20">
															</td>
													</tr>
													<tr class="sysdisplay">
														<td width="30%" class="inputname" >确认新密码：</td>
														<td class="fieldvalue" width="70%">
														<input value="" type="password" name="userpwd2" class="inputtext" size="20"></td>
													</tr>
													<tr class="sysdisplay">
														<td width="30%" class="inputname" >菜单类型：</td>
														<td class="fieldvalue" width="70%">
															<sc:select name="menutype" type="org" key="pcmc_menutype"/>
														</td>
													</tr>
													<tr class="sysdisplay">
														<sc:text name="phone" size="20" dspName="联系电话" dsp="td"/>
													</tr>
													<tr class="sysdisplay">
														<sc:text name="pagesize" default="15" size="20" 
															type="number" req="1" dspName="每页显示记录数" dsp="td"/>
													</tr>
												</table>
			<table width="100%">
				<tr>
					<td align="center">
						<sc:button value="保存" name="save" onclick="saveOk();"/>
						<sc:button value="重写" name="reset" type="reset" />
						<sc:button value="返回" onclick="window.close();" />
					</td>
				</tr>
			</table>
		</sc:fieldset>
		</form>
	</body>
</html>
<Script language="JavaScript">
	function saveOk()
	{
		if (!checkForm(document.forms[0]))
		{
			return false;
		}
		if (!selfCheckForm())
		{
			return false;
		}
		document.forms[0].submit();
	}
	function selfCheckForm()
	{
		var userpwd  = document.getElementById("userpwd").value;
		var userpwd1 = document.getElementById("userpwd1").value;
		var userpwd2 = document.getElementById("userpwd2").value;
		if (userpwd.trim()!="")
		{
			if (userpwd1!=userpwd2 || userpwd1.trim()=="" || userpwd2.trim()=="")
			{
				alert("两次输入的新密码必须一致而且密码不能为空！");
				return false;
			}
		}
		return true;
	}
	String.prototype.trim = function()
	{
		return this.replace(/(^\s*)|(\s*$)/g,"");
	}
</Script>
