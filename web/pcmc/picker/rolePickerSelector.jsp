<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="/jsp_error.jsp"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="com.sunline.jraf.security.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.*"%>
<%@ include file="/include/preprocess.jsp"%>
<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	PkgUtil reqpkg = rpu.createReqPkg("pcmc","sm_query","getRoleList");
	reqpkg.addReqData("subsysid",rpu.getString("subsysid"));
	SwitchCenter.doPost(reqpkg.getPkg());
	List rcds = reqpkg.getRspRcdDataMaps();
	  
	String multi = request.getParameter("multi");
%>
<select size="18" name="selector">
<%
for (int i=0;i<rcds.size();i++){
	Map rcd=(Map)rcds.get(i);
	String roleid= (String)rcd.get("roleid");
	String rolena= (String)rcd.get("rolename");
%><option value="<%=roleid%>"><%=rolena%></option>
<%}%></select>