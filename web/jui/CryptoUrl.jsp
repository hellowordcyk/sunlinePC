<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%=Crypto.encodeUrl(request, request.getParameter("url"))%>