<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:新增首页配置
 * description: 
 *     1.新增首页配置
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<form action="/httpprocesserservlet" onsubmit="return validateCallback(this,dialogAjaxDone)" class="pageForm required-validate" method="post">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
	<input type="hidden" name="oprID" value="<sc:fmt value='aphmp-functionRegister' type='crypto'/>" />
	<input type="hidden" name="actions" value="<sc:fmt value='addFunctionRegister' type='crypto'/>" />
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />" />
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
            	<tr>
					<td class="form-label"><span class="redmust">*</span>功能名称</td>
					<td class="form-value"><sc:text id="functionName" name="functionName" validate="required" /></td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>功能地址</td>
					<td class="form-value"><sc:text id="functionUrl" name="functionUrl" validate="required" /></td>
				</tr>
				<tr>
					<td class="form-label">功能参数</td>
					<td class="form-value">
						<sc:textarea id="functionParams" name="functionParams" />
						<span class="info">多个参数使用英文分号隔开，如param1=value1;param2=value2</span>
					</td>
				</tr>
				<tr>
					<td class="form-label">描述</td>
					<td class="form-value">
						<sc:textarea id="describe" name="describe"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
        <ul>
            <li><button class="savebtn" type="submit">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>


