<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form class="pageForm required-validate" method="post" onsubmit="return validateCallback(this,dialogAjaxDone)" 
	action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='updateSysParam' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
	<div class="pageContent" >
		<div class="pageFormContent">
			<sc:hidden name="paracd" value="%"/>
			<table class="form-table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="form-label"><span class="redmust">*</span>参数主类</td>
					<td class="form-value" width="30%">
						<sc:text name="subscd" readonly="true" index="1" validate="required alphanumeric"/>
					</td>
					<td class="form-label"><span class="redmust">*</span>参数次类</td>
					<td class="form-value"  width="30%">
						<sc:text name="paratp" readonly="true" index="1" validate="required alphanumeric"/>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>参数名称</td>
					<td class="form-value">
						<sc:text name="parana" index="1" validate="required"  attributesText="maxlength='80'"  />
					</td>
					<td class="form-label">金额参数</td>
					<td class="form-value">
						<sc:text name="paraam" index="1" _class="number"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">参数日期</td>
					<td class="form-value">
						<sc:date readonly="true" id="paradt" name="paradt" index="1"/>
					</td>
					<td class="form-label">排序</td>
					<td class="form-value">
						<sc:text name="sortno" index="1" _class="number"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">参数字符A</td>
					<td class="form-value">
						<sc:text name="parach" index="1"/>
					</td>
					<td class="form-label">参数字符B</td>
					<td class="form-value">
						<sc:text name="parbch" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">参数字符C</td>
					<td class="form-value">
						<sc:text name="parcch" index="1"/>
					</td>
					<td class="form-label">参数字符D</td>
					<td class="form-value">
						<sc:text name="pardch" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">参数字符E</td>
					<td class="form-value">
						<sc:text name="parech" index="1"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
		<ul>
			<li><button class="savebtn" type="submit">保存</button></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>
</form>