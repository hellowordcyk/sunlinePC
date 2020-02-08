<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.util.ITEMS"%>
<%@ page import="com.sunline.jraf.util.Crypto"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.List"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<% 
		request.setCharacterEncoding("UTF-8"); 
		String rolename1 = request.getParameter("rolename");
		String rolename = new String(rolename1.getBytes("ISO8859-1"),"UTF-8");
		String cnname1 = request.getParameter("cnname");
		String cnname = new String(cnname1.getBytes("ISO8859-1"),"UTF-8");	
	%>
</head>
<body>
<sc:fieldset name="角色授权">
	<form action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
		<input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
		<input type="hidden" name="actions" value="<sc:fmt value='savePermissions' type='crypto'/>">
		<input type="hidden" name="forward" value="/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getRoleList' type='crypto'/>&PageNo=1&forward=<sc:fmt value='/pcmc/sm/RoleList.jsp' type='crypto'/>">
		<input type="hidden" name="roleid" value="<%=request.getParameter("roleid")%>">
		
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<tr>
				<td width="35%" valign="top">
					<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
						<tr><th colspan="4">角色详细信息</th></tr>
						<tr>
					        <td class="form-label" width="23%">角色名称：</td>
					        <td class="form-value"><%=rolename%></td>
					    </tr>
					    <tr>
					        <td class="form-label">所属子系统：</td>
					        <td class="form-value"><%=cnname%></td>
					    </tr>
					</table>
				</td>
				<td width="65%" valign="top">
					<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
						<tr><th colspan="4">交易授权信息</th></tr>
						<tr>
							<td>
								<input type="button" class="selectall" value="全选" onclick="javascript:selectAll(false);">&nbsp;
								<input type="button" class="cancelall" value="全消" class=btn onclick="javascript:selectAll(true);">
							</td>
						</tr>
						<tr><td>
						<table width="100%" cellpadding="0" cellspacing="0" class="list-table">
							<tr>
						      <th width="7%">选择</th>
							  <th width="40%">业务描述</th>
							  <th>交易描述</th>
						    </tr>
							<%
								Document doc = ITEMS.getRoleSubsysDetail(request.getParameter("subsysid"));
								boolean isSave = false;
								boolean isExits = false;
								if (null != doc)
								{
									List oprList = doc.getRootElement().getChildren("Operation");
									for (int i=0;i<oprList.size();i++)
									{
										 isExits = false;
										Element oprElement = (Element)oprList.get(i);
										List actionList = oprElement.getChildren("Action");
										for (int j=0;j<actionList.size();j++)
										{
											Element actionElement = (Element)actionList.get(j);
											if ("true".equals(actionElement.getAttributeValue("accredit")))
											{
												isExits = true;
												isSave = true;
												break;
											}
										}
										if (isExits)
										{
											for (int j=0;j<actionList.size();j++)
											{
												Element actionElement = (Element)actionList.get(j);
												if ("true".equals(actionElement.getAttributeValue("accredit")))
												{
													out.println("<tr>");
													out.println("<td><input type=\"checkbox\" name=\"chkOpr\" value=\""+oprElement.getAttributeValue("id")+","+actionElement.getAttributeValue("name")+"\" "+ITEMS.getRoleActExits(request.getParameter("roleid"),oprElement.getAttributeValue("id"),actionElement.getAttributeValue("name"))+"></td>");
													out.println("<td>"+oprElement.getAttributeValue("desc")+"</td>");
													out.println("<td>"+actionElement.getAttributeValue("desc")+"</td>");
													out.println("</tr>");
												}
											}
										}
									}
								}
								%>
						</table></td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
		        <td colspan="4" class="form-bottom">
		            <sc:button value="保存" onclick="saveOk();"/>
		            <sc:button value="重置" type="reset"/>
		            <sc:button value="返回" onclick="history.go(-1);"/>
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

function selectAll(sel){
    var selected = sel;
  	var oForm = document.forms[0];
	if (!selected){
		for (var i=0;i<oForm.all.tags("input").length;i++){
	    	var ele = oForm.all.tags("input")[i];
	    	var ct = ele.getAttribute("type");
	    	if ((ele.type=="checkbox"))
	        	ele.checked = true;
	    }
	}else{
      for (var i=0;i<oForm.all.tags("input").length;i++){
        var ele = oForm.all.tags("input")[i];
        var ct = ele.getAttribute("type");
        if ((ele.type=="checkbox"))
          ele.checked = false;
      }
  	}
}
</Script>
</html>
