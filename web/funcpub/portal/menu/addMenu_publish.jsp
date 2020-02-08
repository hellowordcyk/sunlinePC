<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>

<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-menupublish' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='addMenu' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent" width="100%">
		<div class="pageFormContent">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>上级菜单:</td>
					<td>
						<sc:hidden name="pmenuid" index="1"/>
						<sc:text name="pmenuname" readonly="true" index="1"/>
					</td>
				</tr>
				<tr>
					<td>所属子系统:</td>
					<td>
						<sc:hidden name="subsysid" index="1"/>
						<sc:select name="subsysid" type="subsys" index="1" nullOption ="---请选择----" attributesText='disabled="disabled"'/>
					</td>
				</tr>
				<tr>
					<td>菜单名称:</td>
					<td><sc:text name="menuname" validate="required"/><span class="redmust">*</span></td>
				</tr>
				<tr>
					<td>菜单层次:</td>
					<td><sc:text name="levelp" readonly="true" index="1"/></td>
				</tr>
				<tr>
					<td>显示序号:</td>
					<td><sc:text name="sortno" validate="digits"/></td>
				</tr>
				<tr>
					<td>是否公网发布:</td>
					<td><sc:dradio name="isinternet" type="dict" key="pcmc,boolflag" default="0"/></td>
				</tr>
				<tr>
					<td>备注</td>
					<td><sc:textarea name="remark" rows="1" cols="30" style="resize:none;"/></td>
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
