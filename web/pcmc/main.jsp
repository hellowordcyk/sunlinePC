<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/common.jsp"%>
<%
	request.getRequestDispatcher("/common/skins/"+skinname+"/main.jsp").forward(request,response); 
%>