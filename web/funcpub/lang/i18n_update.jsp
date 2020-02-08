<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 语言资源管理
 * description: 
 * author: daoge
 * createtime: 20170204
 * logs:
 *--%>
<form method="post" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)"
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='i18nActor' type='crypto'/>&actions=<sc:fmt value='update' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>资源编码
                    </td>
                    <td class="form-value">
                        <sc:text name="code" validate="alphanumeric required" readonly="true" attributesText="maxlength='100' minlength='4'" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        	默认值
                    </td>
                    <td class="form-value">
                        <sc:text name="langDefault" index="1" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>简体中文</td>
                    <td class="form-value">
                        <sc:text name="langZHCN" validate="required" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                       	繁体中文
                    </td>
                    <td class="form-value">
                        <sc:text name="langZHTW" index="1" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                       	英文（美国）
                    </td>
                    <td class="form-value">
                        <sc:text name="langENUS" index="1" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="formBar">
        <ul>
            <li>
                <button class="savebtn" type="submit">保存</button>
            </li>
            <li>
                <button class="close" type="button">取消</button>
            </li>
        </ul>
    </div>
</form>
