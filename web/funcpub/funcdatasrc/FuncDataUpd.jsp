<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<form action="/httpprocesserservlet" class="pageForm required-validate" method="post" onsubmit="return validateCallback(this,dialogAjaxDone)">
<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>">
<input type="hidden" name="oprID" value="<sc:fmt value='dataconf-jui-user' type='crypto'/>">
<input type="hidden" name="actions" value="<sc:fmt value='updateFuncMenu' type='crypto'/>">
<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />">
<div class="pageContent" width="100%">
	<div class="pageFormContent">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td>功能id：</td>
				<td>
					 <sc:text id="funcid" name="funcid" validate="required" readonly="true" index="1" attributesText='maxlength="20" min="1"'/> 
				</td>
				<td>功能编号：</td>
				<td>
					<sc:text id="funccode" name="funccode" validate="required" index="1" attributesText='maxlength="20"' />
				</td>
			</tr>
			<tr>
				<td>功能名称：</td>
				<td>
					<sc:text id="funcname" name="funcname" validate="required" index="1" attributesText='maxlength="20"' />
				</td>
				<td>功能脚本JAVA路径：</td>
				<td>
					<sc:text id="funcaddres" name="funcaddres" validate="required" index="1" attributesText='maxlength="20"' />
				</td>
			</tr>
			<tr>
				<td>数据源编码：</td>
				<td>
					<sc:text id="func_datasrc" name="func_datasrc" validate="required" index="1" attributesText='maxlength="20"' />
				</td>
			</tr>
			<tr>
				<td>备注</td>
				<td colspan="3">
					<sc:textarea id="remark" name="remark" cols="87" rows="5" index="1" validate="required" />
				</td>
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
