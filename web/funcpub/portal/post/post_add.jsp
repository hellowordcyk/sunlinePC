<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增岗位
 * description: 
 *    新增岗位信息；
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局  
 *--%>
<form method="post" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)"
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='postActor' type='crypto'/>&actions=<sc:fmt value='add' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>岗位编码
                    </td>
                    <td class="form-value">
                        <sc:text name="postCode" validate="alphanumeric" attributesText="maxlength='32' minlength='4'" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>岗位名称
                    </td>
                    <td class="form-value">
                        <sc:text name="postTitle" validate="required" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>排序</td>
                    <td class="form-value">
                        <sc:text name="sortNo" validate="digits required" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                       	 岗位描述
                    </td>
                    <td class="form-value">
                        <sc:textarea name="postDescription" rows="3" cols="50" />
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
