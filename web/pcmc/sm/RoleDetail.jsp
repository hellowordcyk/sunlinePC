<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.util.Crypto"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="/common.jsp"%>
</head>
<body>
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
    String act = rpu.getString("act", "");
    String roleid = rpu.getString("roleid", "");

    if (! act.equals("list")) { 				
		if (!roleid.equals("")) {
			StringBuffer  forwardbuf  = rpu.createReqUrl(request, "pcmc",
					"sm_query", "getSubRoleDetail").append("&act=list")
					.append("&roleid=").append(roleid).append("&forward=<sc:fmt value='/pcmc/sm/RoleDetail.jsp' type='crypto'/>");
			response.sendRedirect(forwardbuf.toString());
			return;
		}
	}
   Document xmlDoc = (Document) request.getAttribute("xmlDoc");
   Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
%>	
<sc:fieldset name="角色维护">
	<form name="form" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
		<input type="hidden" name="oprID" value="<sc:fmt value='sm_query' type='crypto'/>">
		<input type="hidden" name="actions" value="<sc:fmt value='getSubRoleDetail' type='crypto'/>">
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/pcmc/sm/RoleUpdate.jsp' />">
		<input type="hidden" name="roleid" value="<%=record.getChildText("roleid")%>">
		
		<!-- 异常显示面板 -->
		<table border="0" width="100%" height="4" cellspacing="0">
			<% if (request.getAttribute("ERROR_TEXT")!=null) { %>
			<tr align="center">
				<td><font color="red"><%=request.getAttribute("ERROR_TEXT")%></font></td>
			</tr>
			<% } %>
		</table>
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<tr><th colspan="4">角色详细信息</th></tr>
			<tr>
		        <td class="form-label">角色名称：</td>
		        <td class="form-value"><%=record.getChildText("rolename")%></td>
		    </tr>
		    <tr>
		    	<td class="form-label">所属系统：</td>
		        <td class="form-value">
		        	<sc:optd value='<%=record.getChildText("subsysid")%>' type="subsys"/>
		         </td>
		    </tr>
		    <tr>
		    	<td class="form-label">所属部门：</td>
		        <td class="form-value"><%=record.getChildText("deptname")%></td>
		    </tr>
		    <tr>
		    	<td class="form-label">备注：</td>
		        <td class="form-value">
		        	<textarea name="remark" readonly="true" class="inputarea" rows="4" cols="70%"><%=record.getChildText("remark")%></textarea>
		        </td>
		    </tr>
		    <tr>
		        <td colspan="4" class="form-bottom">
		        	<sc:button value="修改" onclick="saveOk();"/>
		        	<sc:button value="菜单授权" onclick="accredit();"/>
		        	<sc:button value="用户授权" onclick="userAccredit();"/>
		        	<sc:button value="机构授权" onclick="deptAccredit();"/>
        			<sc:button value="返回" onclick="goBack();"/>
		        </td>
		    </tr>
		</table>
	</form>
</sc:fieldset>
</body>
<Script language="JavaScript">
function saveOk(){
    document.forms[0].submit();
}

function accredit(){
    var rolename = escape('<%=record.getChildText("rolename")%>');//中文编码
    var cnname = escape("<sc:optd value='<%=record.getChildText("subsysid")%>' type='subsys'/>");//中文编码
    document.location.href = '/pcmc/sm/RoleAccredit.jsp?roleid=<%=record.getChildText("roleid")%>&rolename='+ escape(rolename) +'&cnname='+escape(cnname);
}

function userAccredit(){
    var rolename = escape('<%=record.getChildText("rolename")%>');//中文编码
    var cnname = escape("<sc:optd value='<%=record.getChildText("subsysid")%>' type='subsys'/>");//中文编码
    document.location.href = '/pcmc/sm/RoleAccreditUser.jsp?roleid=<%=record.getChildText("roleid")%>&rolename='+ escape(rolename) +'&cnname='+escape(cnname);
}

function deptAccredit(){
    var rolename = escape('<%=record.getChildText("rolename")%>');//中文编码
    var cnname = escape("<sc:optd value='<%=record.getChildText("subsysid")%>' type='subsys'/>");//中文编码
    document.location.href = '/pcmc/sm/RoleAccreditDept.jsp?roleid=<%=record.getChildText("roleid")%>&rolename='+ escape(rolename) +'&cnname='+escape(cnname);
}

function ldapObjAccredit(){
	document.forms[0].oprID.value='<sc:fmt value='LdapMaintenance' type='crypto'/>';
	document.forms[0].actions.value='<sc:fmt value='listLdapRoles' type='crypto'/>';
	document.forms[0].forward.value='/pcmc/sm/ldapRoles.jsp';	
	document.forms[0].submit();
}

function goBack() {
    var url = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getRoleList' type='crypto'/>&PageNo=1&forward=<sc:fmt value='/pcmc/sm/RoleList.jsp' type='crypto'/>'
    document.location.href = url;
}
</Script>
</html>