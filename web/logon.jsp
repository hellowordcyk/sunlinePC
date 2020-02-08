<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="com.sunline.jraf.util.*"%>
<%@page import="com.sunline.jraf.mailclient.*"%>
<%
com.sunline.jraf.web.RequestParamUtil rpu=null;
if(session.getAttribute("encoding")==null
    ||((String)session.getAttribute("encoding")).length()==0){
    rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, "UTF-8");
}else{
    rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, (String)session.getAttribute("encoding"));
}
%>
<%
session.invalidate();
/*
* 门户系统单点登录入口
*/
//必须是post方式的请求
if(!request.getMethod().equalsIgnoreCase("POST")){
%>	
<Script language="JavaScript" >
	alert("非法请求：<%=request.getMethod()%>");
	window.close();
</Script>
<%		
	return;
}	
//获取请求数据包
String usercode = rpu.getString("userid");
String password = rpu.getString("userpwd");
String sysname = rpu.getString("sysname");
String mode = rpu.getString("mode");
String forward = rpu.getString("forward");

String url = "/httpprocesserservlet" ;
url+="?sysName=" +Crypto.encode(request,"pcmc")+
	"&oprID=" +Crypto.encode(request,"sm_permission")+
	"&actions=" + Crypto.encode(request,"login");
if(usercode!=null){		
	//usercode=PortalDES.decodeByKey(SubsysManager.getDesKey(null),usercode);		
	url+="&usercode="+Helper.escape(usercode);
}
if(password!=null){
	//password=PortalDES.decodeByKey(SubsysManager.getDesKey(null),password);						
	url+="&userpwd="+Helper.escape(password);
}
if(forward!=null){					
	url+="&forward="+Helper.escape(forward);
}	

//String code=PortalDES.encodeByKey(SubsysManager.getDesKey(null), "abcdef!@#");
//out.println("code="+code);
if(url!=null){
	response.reset();
	url=response.encodeRedirectURL(url);
	//response.sendRedirect(url);
	//response.flushBuffer();
	//return;
	request.getRequestDispatcher(url).forward(request,response);
}
%>
