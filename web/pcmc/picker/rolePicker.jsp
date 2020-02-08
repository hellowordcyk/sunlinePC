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
	  
	String multi = request.getParameter("multi");
	String strRcvRoleIds = request.getParameter("roleids");
	String[] rcvRoleIds;;
	if(strRcvRoleIds!=null)
		rcvRoleIds =  strRcvRoleIds.split(",");
%>
<sc:doPost var="pkg" sysName="pcmc" oprId="sm_query" action="getRoleList" all="true"/>
<c:set target="${jrafrpu}" property="xmlDoc" value="${pkg.pkg}"/>
<c:set var="rescd" value="${pkg.result}"/>
<html>
<head>
		<title>角色选择器</title>
		<link href="/css/style.css" type="text/css" rel="stylesheet">
		<link href="/css/Jraf.css" type="text/css" rel="stylesheet">
		<LINK href="/css/displaytag.css" media="All" type=text/css rel=stylesheet>
		<script type="text/javascript" src="/js/prototype.js"></script>
		<script type="text/javascript" src="/js/Jraf_prototype.js"></script>
</head>
<body background="/images/background.gif"
	style="border-right: medium none; border-top: medium none; margin: 0px; 
	border-left: medium none; border-bottom: medium none"
	bgColor=#FFFFFF>
<sc:form name="form1" action="/xmlprocesserservlet"
	sysName="pcmc" oprID="sm_query" actions="getRoleList">	
<sc:select name="subsysid" type="subsys" key="" includeTitle="false" attributesText="onchange ='return chgsubsys();'" />
<div id="roleslistor">
			<select size="18" name="roleids">
<c:forEach var="rcd" items="${pkg.rspRcdDataMaps}">
<option value="<c:out value="${rcd.roleid}"/>"
<c:forTokens items="${param.roleids}" delims=","
var="rcvRoleId">
<c:if test="${rcvRoleId==rcd.roleid}">selected</c:if>
</c:forTokens>
><c:out value="${rcd.rolename}"/></option>
</c:forEach>
	  	</select>
</div>
<sc:button  value="确定" onclick="btnsure();"/>
</sc:form>
<script language="JavaScript">
	function chgsubsys(){
		var ajax = new Jraf.Ajax();
		ajax.submitFormXml('form1', function(xml){
		try{
   		var pkg = new Jraf.Pkg(xml);
			if(pkg.result() != '0'){
				alert("获取角色清单失败!\n"+pkg.allMsgs);
				return;
			}
			var slEL = $('roleids');
			slEL.update('');
			var rcds=pkg.rspDatas().Record;
			if(!rcds)
				return;
			if(!Object.isArray(rcds)){
				rcds=[rcds];
			}
			rcds.each(function(rcd){
				slEL.insert(new Element('option',{value:rcd.roleid}).update(rcd.rolename));
				});
		}catch(e){alert('ERROR:'+e);}
		});
		return false;
	}
	function btnsure(){
		var slEL=$('roleids');
		var roleids = slEL.value;
		var rolenas ="aa";
		rolenas=slEL.options[slEL.selectedIndex].innerHTML;
		var ret = {roleid:roleids,rolename:rolenas};
		window.returnValue=ret;
		window.close();
	}
</script>
</body>
</html>
