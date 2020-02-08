<%@ include file="/js/calendar/calendar.html"%>
<%@ page import="com.sunline.jraf.util.JDomUtil"%>
<%@ page import="com.sunline.bimis.pcmc.util.ITEMS"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.List"%>
<head>
    <meta http-equiv="Expires" CONTENT="0">
    <meta http-equiv="Cache-Control" CONTENT="no-cache">
    <meta http-equiv="Pragma" CONTENT="no-cache">

</head>
<Script language="JavaScript" src="/js/checkForm.js"></Script>
<Script language="JavaScript" src="/js/mousemove.js"></Script>
<%
//    String userid = (String) request.getSession().getAttribute("userid");
//    String acctid = (String) request.getSession().getAttribute("acctid");
//    if ((userid == null) || (acctid == null) || ("".equals(userid)) || ("".equals(acctid)))
//    {
//        out.print("<script language=JavaScript>");
//        out.print("    window.alert('');");
//        out.print("    top.location.replace('/index.jsp');");
//        out.print("</script>");
//        return;
//    }
%>
<LINK href="/css/style.css" type=text/css rel=stylesheet>
