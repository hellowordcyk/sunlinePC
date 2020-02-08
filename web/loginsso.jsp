<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="com.sunline.jraf.util.PortalDES"%>
<%@ page import="com.sunline.jraf.services.SubsysManager"%>
<%@ include file="/jui_tag.jsp"%>

<%
    String userid = request.getParameter("userid");
	String menuid = request.getParameter("menuid");
	String params = request.getParameter("params");  // params=dd=5,kk=9
    String isforward = request.getParameter("isforward");
    String path = "/jui/index.jsp";
	if(menuid != null && !"".equals(menuid.trim()) && !"null".equals(menuid.trim())){
		path = "/jui/ssoindex.jsp";
	}
   request.getRequestDispatcher(path).forward(request, response);
%>
