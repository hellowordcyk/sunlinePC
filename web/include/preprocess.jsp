<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="com.sunline.jraf.security.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.*"%>
<%@ page errorPage="/jsp_error.jsp"%>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://www.sunline.cn/jsp/common" prefix="sc"%>
<%@ taglib uri="/WEB-INF/tagtld/displaytag-el.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/tagtld/prize/treetag.tld" prefix="tree" %>
<%@ taglib uri="/WEB-INF/tagtld/prize/requesttags.tld" prefix="request" %>
<%@ taglib uri="/WEB-INF/tagtld/prize/ajaxtags.tld"    prefix="ajax" %>
<%@ taglib uri="/WEB-INF/tagtld/prize/templatetag.tld"    prefix="tmpl" %>
<%@ taglib uri="/WEB-INF/tagtld/prize/tabbedpanetag.tld"    prefix="tabs" %>

<%
//anti cache of browser
//response.setHeader("Pragma", "No-cache"); 
//response.setHeader("Cache-Control", "no-cache"); 
//response.setDateHeader("Expires", 0); 
//get cookie


Authenticator jrafAuth = null;
jrafAuth = (Authenticator) request.getSession().getAttribute("jraf_auth");
//Authenticator.setAuthenticator(jrafAuth);

com.sunline.jraf.web.RequestParamUtil rpu=null;
if(session.getAttribute("encoding")==null
||((String)session.getAttribute("encoding")).length()==0){
 rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, "UTF-8");
}else{
 rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, (String)session.getAttribute("encoding"));
}
%>