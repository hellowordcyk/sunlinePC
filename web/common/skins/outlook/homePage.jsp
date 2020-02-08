<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto"%>
<%
	String subsysid = request.getParameter("subsysid");
    String contextPathStr = request.getContextPath();
    com.sunline.jraf.security.UserAuthenticator loginJrafAuth = (com.sunline.jraf.security.UserAuthenticator) com.sunline.jraf.security.UserAuthenticator.getAuthenticator();
	if(loginJrafAuth==null)
	{
	    response.sendRedirect("/logout.jsp");
	    return;		
	}else{
		int userid = loginJrafAuth.getUser().getUserID();
		//String forward = "/pcmc/pm/homePage.so?sysName="+Crypto.encode(request,"pcmc")+"&oprID="+Crypto.encode(request,"hmpg")+"&actions="+Crypto.encode(request,"getUserTemplateInfo")+"&userid="+userid+"&subsysid="+subsysid; 
		//response.sendRedirect(forward);
    	//response.sendRedirect("/workstation/manage/workstation_main.jsp?subsysid="+subsysid);
		return;
	}
%>