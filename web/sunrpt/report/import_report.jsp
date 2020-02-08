<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--规范：每个页面前必需增加注释。1）说明主要功能；2）主要功能修改日志 --%>
<%--
 * title: 角色管理
 * description: 
 *     1.维护（新增、修改、删除）角色信息；
 *     2.分配角色菜单权限；
 *     3.分配角色资源权限；
 *     4.设置角色权限分组：根据不同权限组设置，获取相应数据访问权限（目前主要是机构访问权限）
 * author: longjian
 * createtime: 2015-05-01 10:30
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<form name="importReportForm" encType="multipart/form-data" method="post"
    action="/jui/callMessage.so?csrftoken=${csrftoken }" class="pageForm required-validate"
    onsubmit="return iframeCallback(this,dialogAjaxDone)">
    <input type="hidden" name="sysName" value='<sc:fmt value='sunrpt' type='crypto'/>' /> 
    <input type="hidden" name="oprID" value='<sc:fmt value='sunrpt-report' type='crypto'/>' /> 
    <input type="hidden" name="actions" value='<sc:fmt value='impReport' type='crypto'/>' /> 
   <%--  <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" /> --%>
        
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">请选择Excel文件</td>
                    <td class="form-value">
                        <input type="file" name="impFile" class="required" style="width:90%;" multiple="multiple"/>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <p>校验不通过，解决方法：</p>
                        <p>1、提示：编码格式不符合UTF-8!</p>
                        <p>&nbsp;&nbsp;&nbsp;&nbsp;将不通过校验部分复制到记事本，另存为ANSI或UTF-8编码。</p>
                        <p>&nbsp;&nbsp;&nbsp;&nbsp;关闭后再重新打开，去除特殊字符后，替换Excel中的相关内容。</p>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="formBar">
        <ul>
            <li>
                <a class="export" onclick="exportTemplete();"
                    style="cursor: pointer;">
                    <span>模板下载</span>
                </a>
            </li>
            <li>
                <button class="savebtn" type="submit">导入</button>
            </li>
            <li>
                <button class="close" type="button">取消</button>
            </li>
        </ul>
    </div>
</form>
