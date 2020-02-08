<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>机构新增</title>
</head>
<body scroll="no">
<h2 class="contentTitle">新增机构信息</h2>
<div class="pageContent">
	<sc:form method="post" action="/httpprocesserservlet" _class="pageForm required-validate" onsubmit="return validateCallbackWithTag(this,dialogAjaxDone)">
		<sc:hidden name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
		<sc:hidden name="oprID" value="<sc:fmt type='crypto' value='funcpub-jui'/>"/>
		<sc:hidden name="actions" value="<sc:fmt type='crypto' value='insertPcmcDept'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
		<div class="pageFormContent nowrap" layoutH="90">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>	
					<td>机构ID：</td>
					<td><sc:text name="deptid" validate="required" attributesText='maxlength="20" '/></td>
					<td>机构编码：</td>
					<td><sc:text name="deptcode" validate="required" attributesText='maxlength="20" ' /></td>
				</tr>
				<tr>
					<td>机构名称：</td>
					<td><sc:text name="deptname" validate="required" attributesText='maxlength="20" ' /></td>
					<td>机构级别：</td>
					<td><sc:text name="levelp" validate="digits" attributesText='maxlength="20" ' /></td>
				</tr>
				<tr>
					<td>父机构ID</td>
					<td colspan="3"><sc:text name="pdeptid" validate="required" attributesText='maxlength="20" ' />
					<span class="remarks">基于h标签，且无动态新增，提交form时请使用validateCallbackWithTag方法取代原先DWZ提供的validateCallback方法；</span>
					</td>
				</tr>
			</table>
			<div class="formbutton_bg">
				<span>
					<button type="submit" class="formbutton">提交</button>
					<button type="button" class="formbutton">取消</button>
				</span>
			</div>
		</div>
		
	</sc:form>
</div>
</body>
</html>