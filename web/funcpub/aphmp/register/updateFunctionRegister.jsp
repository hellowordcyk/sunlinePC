<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 修改首页配置
 * description: 
 *     1.修改首页配置
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
 <form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-functionRegister' type='crypto'/>&actions=<sc:fmt value='updateFunctionRegister' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="form-label"><span class="redmust">*</span>功能编号</td>
				<td class="form-value">
					 <sc:text id="function_id" name="function_id" validate="required" readonly="true" index="1" attributesText='maxlength="200"'/> 
				</td>
			</tr>
			<tr>
				<td class="form-label"><span class="redmust">*</span>功能名称</td>
				<td class="form-value"><sc:text id="functionName" name="function_name" validate="required" index="1"/></td>
			</tr>
			<tr>
				<td class="form-label"><span class="redmust">*</span>功能地址</td>
				<td class="form-value"><sc:text id="functionUrl" name="function_url" validate="required" index="1"/></td>
			</tr>
			<tr>
				<td class="form-label">功能参数</td>
				<td class="form-value">
					<sc:textarea id="functionParams" name="function_params" index="1"/>
					<span class="info">多个参数使用英文分号隔开，如param1=value1;param2=value2</span>
				</td>
			</tr>
			<tr>
				<td class="form-label">描述</td>
				<td class="form-value"><sc:textarea id="describe" name="describe" index="1"/></td>
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
