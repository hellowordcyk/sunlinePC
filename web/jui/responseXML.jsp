<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.io.PrintWriter"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    

  </head>
  
  <body>
    <%
    StringBuffer bf = new StringBuffer();
    bf.append("<?xml version=\"1.0\" encoding=\"UTF-8\"?>")
    .append("<stulist>").append("<student email=\"1@1.com\">").append("<name>zhangsan</name>").append("<id>1</id>")
    .append("</student>").append("<student email=\"2@2.com\">").append("<name>lisi</name>").append("<id>2</id>")
    .append("</student>").append("</stulist>");
    System.out.println(bf.toString());
    response.setHeader("Content-Type","text/xml; charset=utf-8");
    PrintWriter out1 = null;
    out1 = response.getWriter();
    out1.print(bf.toString());
    out1.flush();
    out1.close();
     %>
  </body>
</html>
