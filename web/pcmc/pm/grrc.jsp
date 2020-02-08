<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="com.sunline.jraf.util.*"%>
<% request.setCharacterEncoding("UTF-8"); %>

<html>
<head>
	<meta http-equiv="Expires" CONTENT="0">
	<meta http-equiv="Cache-Control" CONTENT="no-cache">
	<meta http-equiv="Pragma" CONTENT="no-cache">
	<link rel="stylesheet" type="text/css" href="../../css/font.css">
</head>

<BODY bgcolor="#F6F6F6" leftmargin="0" topmargin="0" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; MARGIN: 0px; OVERFLOW: hidden; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none" oncopy="return false;">
<%@ include file="/public/checkLogin.jsp"%>
<form action="/httpprocesserservlet" method="post">
    <input type="hidden" name="sysName" value="<sc:fmt value='oams' type='crypto'/>">
    <input type="hidden" name="oprID" value="<sc:fmt value='po_grrc' type='crypto'/>">
    <input type="hidden" name="actions" value="<sc:fmt value='getRcList' type='crypto'/>">
    <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/oams/po/planIndex.jsp' />">
</form>

<%
    Document reqXml = HttpProcesser.createRequestPackage("oams", "po_grrc", "getRcList", request);
    Document respXml = SwitchCenter.doPost(reqXml);
%>

<table class="trinfo" width="100%" border="0" cellspacing="0" cellpadding="0">
<%
    List recordList = respXml.getRootElement().getChild("Response").getChild("Data").getChildren("Record");
    for(int i= 0; i < recordList.size(); i ++)
    {
        Element ele = (Element)recordList.get(i);
%>

  <tr valign="middle">
  	<td  width="100%" align="left">
  		<a target="_blank" style="font-size: 9pt;color:black" 
  			href="/httpprocesserservlet?sysName=<sc:fmt value='oams' type='crypto'/>&oprID=<sc:fmt value='po_grrc' type='crypto'/>&actions=<sc:fmt value='getPlanDetail' type='crypto'/>&planid=<%=ele.getChildTextTrim("planid")%>&forward=<sc:fmt value='/oams/po/PlanDetail.jsp' type='crypto'/>">
  		&nbsp;&nbsp;<%=Format.dateFormat(ele.getChildTextTrim("sdate"))%>&nbsp;<%=ele.getChildTextTrim("title")%>&nbsp;
	  	</a>
	  </td>
</tr>
  
<%}%>

</table>
</BODY>

<script language="JavaScript">
    function myopen(pendjobid,url,name)
    {
        openwin(url,name);
    }
    function openwin(url,name)
    {
        window.open(url,name,"height=600, width=800,toolbar=no , menubar=no, scrollbars=yes, resizable=yes, location=no, status=yes");
    }
</script>