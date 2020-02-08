<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>

<%
    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
	String roleid = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record").getChildTextTrim("roleid");
%>
<div class="pageContent">
	<div class="pageFormContent">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>角色名称：</td>
				<td>
					 <sc:text name="rolename" readonly="true" index="1"/>
				</td>
			</tr>
			<tr>
				<td>所属机构：</td>
				<td>
					<sc:text name="deptname" readonly="true" index="1"/>
				</td>
			</tr>
			<tr>
				<td>备注</td>
				<td>
					<sc:text name="remark" readonly="true" index="1"/>
				</td>
			</tr>
		</table>
	</div>
</div>	
<div class="formBar">
	<ul>
		<li>
			<a rel="rolegrant" target="dialog" class="button" width="600" height="300"
			   href="/funcpub/portal/role/role_update.jsp?roleid=<%=roleid%>">修改
			</a>
		</li>
		<li>
			<a rel="rolegrant" target="dialog" class="button" width="800" height="600" 
			   href="/funcpub/portal/role/role_accredict_user.jsp?roleid=<%=roleid%>">用户授权
			</a>
		</li>
		<li>
			<a rel="menugrant" target="dialog" class="button" width="600" height="400" 
			   href="/funcpub/portal/role/role_menu.jsp?roleid=<%=roleid%>">菜单授权
			</a>
		</li>
		<li><button type="button" class="close">取消</button></li>
	</ul>
</div>
<from id="">
</from>




