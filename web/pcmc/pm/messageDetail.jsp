<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.util.ITEMS" %>
<%@ page import="com.sunline.jraf.web.Format" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
%>

<html>
<head>
<title>阅读短消息</title>
	<link href="/css/style.css" type="text/css" rel="stylesheet">
</head>

<body background="/images/background.gif"
	style="border-right: medium none; border-top: medium none; margin: 0px; 
	border-left: medium none; border-bottom: medium none"
	oncopy="return false;" bgcolor=#FFFFFF>
<%@ include file="/public/checkLogin.jsp"%>

<form action="/httpprocesserservlet" method="post">

<table border=0 cellSpacing=0 cellPadding=0 align="center" width="99%">
	<tr>
		<td valign=top width="100%">
			<fieldset>
				<legend>
					<table border=0 cellSpacing=0 cellPadding=0 width=100 bgColor="#E0F0F0">
						<tr>
							<td style="padding-top: 2px" align="center" background="/images/login_title_bg.gif" height=18>
								<font color="#FFFFFF">短消息服务</font>
							</td>
						</tr>
					</table>
				</legend>
				<table border=0 cellpadding=4 cellspacing=0 align="center" width="99%">
					<tr>
						<td>
							<table border=0 cellpadding=0 cellspacing=0 bgcolor="#EFF0F1" width="100%">
								<tr width="100%">
									<td background="/images/navigation_ico_2.gif" class="navigation" width="100%">
										<table border=0 cellpadding=2 cellspacing=0 width="100%">
											<tr>
												<td width="10%">&nbsp;<font color="#FFFFFF">详细内容</font></td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td>
										<table width="100%" border=0 cellpadding=3 cellspacing=0 class="navigation2">
										    <tr class="sysdisplay">
										        <td width="20%" align=right>标题：</td>
										        <td><%=record.getChildTextTrim("title")%></td>
										    </tr>
										    <tr class="sysdisplay">
										        <td width="20%" align=right valign="top">内容：</td>
										        <td>
										        		<textarea name="content" rows="8" cols="80" readonly><%out.println(record.getChildText("content").replaceAll("\n","<br>").replaceAll(" ","&nbsp;"));%></textarea>
										        	</td>
										    </tr>
										    <tr class="sysdisplay">
										        <td width="20%" align=right>发送人：</td>
										        <td><%=record.getChildTextTrim("createusername")%></td>
										    </tr>
										    <tr class="sysdisplay">
										        <td width="20%" align=right>发送时间：</td>
										        <td><%=Format.dateFormat(record.getChildTextTrim("createtime"))%></td>
										    </tr>
										</table>
										<table width="100%">
										    <tr>
										        <td align="center">
										        		<input type="button" class=btn value="返回" onclick="goBack();">
										        </td>
										    </tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</td>
	</tr>
</table>

</form>
</body>
</html>

<Script language="JavaScript">
function goBack()
{
    document.location.href = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMessageList' type='crypto'/>&isread=1&forward=<sc:fmt value='/pcmc/pm/messagelist.jsp' type='crypto'/>'";
}
</Script>
