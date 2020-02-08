<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--规范：每个页面前必需增加注释。1）说明主要功能；2）主要功能修改日志 --%>
<%--
 * title: 角色管理-新增
 * description: 
 *     新增角色信息；
 * author: WengZhiYong
 * createtime: 2015-05-01 10:30
 * logs:
 *     edited by Sean on 20160529 优化布局
 *--%>

<%--规范：form属性顺序：class->onsubmit->method->其他->action --%>
<form class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)" method="post"
      action="/httpprocesserservlet" >
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
    <input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>"/>
    <input type="hidden" name="actions" value="<sc:fmt value='addRole' type='crypto'/>"/>
    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" />
    
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
                <tr>
                    <td class="form-label"><span class="redmust">*</span>所属系统</td>
                    <td class="form-value">
                        <sc:select name="subsysid" _class="combox" type="subsys" validate="required" default="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>角色名称</td>
                    <td class="form-value">
                        <sc:text name="rolename" validate="required"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>所属机构</td>
                    <td class="form-value">
                        <sc:hidden name="deptid"/>
                        <sc:hidden name="deptcode"/>
                        <sc:text name="deptname" readonly="true" validate="required"/>
                        <a class="btnLook" title="机构信息-单选" width="800" height="450" lookupGroup=""
                           href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=deptid&lookupcode=deptcode&lookupname=deptname" >
                        </a>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">权限分组</td>
                    <td class="form-value">
                        <%-- 不能增加超级管理员 value=3 --%>
                        <!-- 角色类型 标签 name=roletp， 后台取值也是roletp longjian 20160615 -->
                        <sc:select name="roletp" type="dict" key="pcmc,roletp" 
                            includeTitle="false" excludes="3" nullOption ="---请选择---" />
                        <span class="info">默认数据权限分组。</span>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">备注</td>
                    <td class="form-value">
                        <textarea class="textInput" name="remark" cols="50" rows="2" />
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
