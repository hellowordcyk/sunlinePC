<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增数据字典
 * description: 
 *     1.新增数据字典；
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='addSysParam' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
		<div class="pageFormContent">
			<table cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="form-label"><span class="redmust">*</span>参数主类</td>
					<td class="form-value">
						<sc:text id="paramp" name="subscd"  validate="required alphanumeric" attributesText="maxlength='4'"/>
					</td>
				</tr>
				<tr>
				    <td class="form-label">&nbsp;</td>
				    <td class="form-value"><span class="info">最多4个字符</span></td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>参数次类</td>
					<td class="form-value">
						<sc:text id="paratp" name="paratp" validate="required alphanumeric" attributesText="maxlength='30'" />
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>参数名称</td>
					<td class="form-value">
						<sc:text id="parana" name="parana" validate="required" attributesText="maxlength='80'" />
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

