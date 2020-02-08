<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="/jsp_error.jsp"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.sunline.bimis.oams.mail.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%
	String folderID = "0";
	String folderName = "新邮件";
	String forwardID = "/oams/webmail/mailNewInBox.jsp";
	String sessUserId = (String)request.getSession().getAttribute("userid");
%>

<html>
<head>
<meta http-equiv="Expires" content="0">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Pragma" content="no-cache">
<link rel="stylesheet" type="text/css" href="../../css/font.css">
</head>

<body bgcolor="#F6F6F6" leftmargin="0" topmargin="0"
	style="border-right: medium none; border-top: medium none; margin: 0px; overflow: hidden; 
	border-left: medium none; border-bottom: medium none"
	oncopy="return false;">

<%@ include file="/public/checkLogin.jsp"%>

<form action="/httpprocesserservlet" method="post" target=""><input
	type="hidden" name="sysName" value="<sc:fmt value='oams' type='crypto'/>">
<input type="hidden" name="oprID"
	value="<sc:fmt value='mail_list' type='crypto'/>"> <input type="hidden"
	name="actions" value="<sc:fmt value='getNewMailList' type='crypto'/>"><input
	type="hidden" name="forward" value="<sc:fmt type='crypto' value='/oams/webmail/mailIndex.jsp' />"></form>

<%
		Document reqXml = HttpProcesser.createRequestPackage("oams", "mail_list", "getNewMailList", request);
		Element sessionEle = new Element("Session");
		sessionEle.addContent(new Element("userid").setText((String)request.getSession().getAttribute("userid")));
		reqXml.getRootElement().addContent(sessionEle);
		reqXml.getRootElement().getChild("Request").getChild("Data").addContent(new Element("iFolderId").setText(folderID));
		reqXml.getRootElement().getChild("Request").getChild("Data").addContent(new Element("vFolderName").setText(folderName));
		Document respXml = SwitchCenter.doPost(reqXml);
		%>

<table class="trinfo" width="100%" border=0 cellspacing=0
	cellpadding="0">
	<%
			List recordList = respXml.getRootElement().getChild("Response").getChild("Data").getChildren("Record");
			for(int i= 0; i < recordList.size(); i ++){
			Element record = (Element)recordList.get(i);
			%>
	<tr>
		<td width="100%" style="font-size: 9pt" align="left"><a
			target="_blank" style="font-size: 9pt;color:black"
			href='/httpprocesserservlet?sysName=<sc:fmt value='oams' type='crypto'/>&oprID=<sc:fmt value='mail_list' type='crypto'/>&actions=<sc:fmt value='getMailMsg' type='crypto'/>&iFolderId=<%=folderID%>&vFolderName=<%=folderName%>&iSrvrId=0&iMsgId=<%=record.getChildTextTrim("msgid")%>&forward=<sc:fmt value='/oams/webmail/mailDetailInBox.jsp' type='crypto'/>'>&nbsp;&nbsp;<%=record.getChildTextTrim("subject")%></a></td>
	</tr>
	<%}%>
</table>
</body>

<script language="JavaScript">
		function myopen(pendjobid,url,name){
			openwin(url,name);
		}
		
		function openwin(url,name){
			window.open(url,name,"height=600,width=800,toolbar=no,menubar=no,scrollbars=yes,resizable=yes,location=no,status=yes");
		}
	</script>