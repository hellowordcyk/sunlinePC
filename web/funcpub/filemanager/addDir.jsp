<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jui_tag.jsp"%>

<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='funcpub-filemanager'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='addDir'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<sc:hidden name="subName"/>
	<sc:hidden name="path"/>
	<div class="pageContent">	
		<div class="pageFormContent">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>上级目录：</td>
					<td>
						<c:out value='<%=URLDecoder.decode(request.getParameter("name"), "UTF-8") %>' />
					</td>
				</tr>
				<tr>
					<td>文档目录</td>
					<td>
						<sc:text id="dirNameId" name="dirName" validate="required"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
		<ul>
			<li><input class="button" type="submit" value="创建" /></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>
</form>
