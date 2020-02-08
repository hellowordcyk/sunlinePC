<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增组织
 * description: 
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20170505
 *--%>
<form method="post" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)"
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='organizationActor' type='crypto'/>&actions=<sc:fmt value='add' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>组织编码
                    </td>
                    <td class="form-value">
                        <sc:text name="orgcode" validate="alphanumeric" attributesText="maxlength='32' minlength='4'" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>组织名称
                    </td>
                    <td class="form-value">
                        <sc:text name="orgname" validate="required" />
                    </td>
                </tr>
                <tr>
                	<td class="form-label">组织类型</td>
                	<td >
                		<sc:select name="orgType" type="knp" key="pcmc,organizationType" includeTitle="false" nullOption="--请选择--"></sc:select>
                	</td>
                </tr>
                <tr>
                	<td class="form-label"><span class="redmust">*</span>是否禁用</td>
                	<td >
                		<sc:dradio name="disable" default="0" type="dict" key="pcmc,boolflag"></sc:dradio>
                	</td>
                </tr>
                <tr>
                    <td class="form-label">排序</td>
                    <td class="form-value">
                        <sc:text name="sortNum" validate="digits" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                       	 描述
                    </td>
                    <td class="form-value">
                        <sc:textarea name="remark" rows="3" cols="50" />
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
