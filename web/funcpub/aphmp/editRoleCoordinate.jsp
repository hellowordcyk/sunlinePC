<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate"  onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
	<input type="hidden" name="oprID" value="<sc:fmt value='aphmp-functionRegister' type='crypto'/>" />
	<input type="hidden" name="actions" value="<sc:fmt value='editRoleCoordinate' type='crypto'/>" />
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />" />
	<div class="pageContent">
		<div class="pageFormContent">
			<table width="100%">
				<tr>
					<td align="right">角色编号:</td>
					<td>
						<sc:hidden name="roleID"/>
                        <c:out value="${param.roleID }"></c:out>
					</td>
				</tr>
				<tr>
					<td align="right">行数:</td>
					<td><sc:text name="rowNum" index="1" validate="digits required" attributesText="alt='请输入一个1-3的整数' min='1' max='3'"/><span class="redmust">*</span></td>
				</tr>
				<tr>
					<td align="right">列数</td>
					<td><sc:text name="columnNum" index="1" validate="digits required" attributesText="alt='请输入一个1-3的整数' min='1' max='3'"/><span class="redmust">*</span></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
		<ul>
			<li><input type="submit" class="button" value="提交" /></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>
</form>

