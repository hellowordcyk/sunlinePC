<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="org.jdom.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    

  </head>
  
  <body>
<%
	String flag = request.getParameter("flag");
    Document doc = (Document)request.getAttribute("xmlDoc");
	Element root = doc.getRootElement();
   	String str = root.getChild("Response").getChild("Data").getChildTextTrim(flag);
    response.setHeader("Content-Type","text/xml; charset=utf-8");
    PrintWriter out1 = null;
    out1 = response.getWriter();
    out1.print(str);
    out1.flush();
    out1.close();
%>
  </body>
</html>
