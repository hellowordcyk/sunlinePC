<%@ page import="java.io.*" %><%
String filename = request.getParameter("filename");
String realname = request.getParameter("realname");
request.getSession().setAttribute("downfilena",filename);
request.getSession().setAttribute("realname",realname);
response.sendRedirect("/public/download.jsp");
%>