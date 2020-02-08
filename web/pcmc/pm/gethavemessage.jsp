<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations"%>
<%@ include file="/public/checkLogin.jsp"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
     String userid = (String)session.getAttribute("userid");
     boolean isread = PmInformations.isHaveNewMes("0",request);
     String[] msgs = PmInformations.getNewMsgAndNum("0",request);
%>

<html>
<head>
	<link rel="stylesheet" type="text/css" href="/css/font.css">
	<title>短消息</title>
	<meta http-equiv="refresh" content="1200"; url="/pcmc/pm/gethavemessage.jsp">
</head>

<script language="JavaScript">
var oPopup;
var popTop=50;
var mytime;
function closemsg(){
	try{
		clearTimeout(mytime);
	}catch(e){}
	oPopup.hide();
}

function popshow(){
	//window.status=popTop;
	if(popTop>1160){
		closemsg();
		return;
	}
	if(popTop>1040&&popTop<1160){
		oPopup.show(screen.width-195,screen.height,180,1160-popTop);
	}
	if(popTop>1000&&popTop<1040){
		oPopup.show(screen.width-195,screen.height+(popTop-1160),180,116);
	}
	if(popTop<120){
		oPopup.show(screen.width-195,screen.height,180,popTop);
	}
	if(popTop<160){
		oPopup.show(screen.width-195,screen.height-popTop,180,116);
	}
	popTop+=10;
	mytime=setTimeout("popshow();",50);
}

function popmsg(msgnum,msgstr){
	oPopup = window.createPopup();
	var winstr='<table style="border-top: #FFFFFF 1px solid; border-left: #FFFFFF 1px solid" cellSpacing=0 cellPadding=0 width="100%" bgcolor=#cfdef4 border=0>';
	winstr   +='		<tr>';
	winstr   +='			<td style="font-size: 12px; background-image: url(msgTopBg.gif); color: #0f2c8c" width=30 height=24></td>';
	winstr   +='			<td style="font-weight: normal; font-size: 12px; background-image: url(msgTopBg.gif); color: #1f336b; padding-top: 4px;padding-left: 4px" valign=center width="100%"> 管理平台消息提示：</td>';
	winstr   +='			<td style="background-image: url(msgTopBg.gif); padding-top: 2px;padding-right:2px" valign=center align=right width=19><span title=关闭 style="cursor: hand;color:red;font-size:12px;font-weight:bold;margin-right:4px;" onclick="window.parent.closemsg();">×</span></td>';
	winstr   +='		</tr>';
	winstr   +='		<tr>';
	winstr   +='			<td style="padding-right: 1px; background-image: url(1msgBottomBg.jpg); padding-bottom: 1px" colSpan=3 height=90>';
	winstr   +='				<div style="border-right: #b9c9ef 1px solid; padding-right: 13px; border-top: #728eb8 1px solid; padding-left: 13px; font-size: 12px; padding-bottom: 13px; border-left: #728eb8 1px solid; width: 100%; color: #1f336b; padding-top: 6px; border-bottom: #b9c9ef 1px solid; height: 100%">'
	winstr   +='                    您有<font color=#FF0000>'+msgnum+'</font>条新短消息<br><br>';
	winstr   +='        			<div align=center style="word-break:break-all">';
	winstr   +=msgstr;
	winstr   +='					</div>';
	winstr   +='				</div>';
	winstr   +='			</td>';
	winstr   +='		</tr>';
	winstr   +='</table>';
		
	oPopup.document.body.innerHTML = winstr;
	popshow();
}
</script>

<body style="border-right: medium none; border-top: medium none; margin: 0px; 
	border-left: medium none; border-bottom: medium none" oncopy="return false;" bgcolor=#FFFFFF>
	
<%
if(new Long(msgs[0]).longValue()<1){
	%>
	<table border=0 bgcolor="#D5E2E9" width="100%">
		<tr>
			<td width="30%">&nbsp;</td>
			<td height="27" style="font-size: 9pt;cursor:hand" onclick="openwin('/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMessageList' type='crypto'/>&isread=1&forward=<sc:fmt value='/pcmc/pm/messagelist.jsp' type='crypto'/>');">			
				<font face="宋体" color="green">无新短消息</font>
			</td>
			<td width="30%">&nbsp;</td>
		</tr>
	</table>
	<%
}
else{
	%>		
		&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="#" onclick="openwin();document.location.href='/pcmc/pm/gethavemessage.jsp';"><img src="../../images/pcmc/1_qiege_18.gif" width="160" height="27" border=0></a>
		<%
		if("1".equals(msgs[3])){
			%>
			<script language="JavaScript">
				var msgstr='<a href="#" onclick="window.parent.openwin();">'+'<%=msgs[2]%>'+'</a>';
				popmsg('<%=msgs[0]%>',msgstr);
			</script>	
		<%
	}
}
%>

</body>
</html>

<script language="JavaScript">
function openwin(name)
{
	var url = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMessageList' type='crypto'/>&isread=0&forward=<sc:fmt value='/pcmc/pm/messagelist.jsp' type='crypto'/>';
    window.open(url,null,"height=600, width=800,toolbar=no , menubar=no, scrollbars=yes, resizable=yes, location=no, status=yes");
	//location.reload();
}
</script>