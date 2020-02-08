<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp" %>
<c:set var="record" value="${jrafrpu.rspPkg.rspRcdDataMaps[0]}"/>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="form-table">
    <tr><th colspan="4">操作员详细信息</th></tr>
    <tr>
        <td width="30%" class="form-label">用户编号：<font color="red">*</font></td>
        <td width="70%" class="form-value">${record.usercode }</td>
    </tr>
    <tr>
        <td class="form-label">用户名：<font color="red">*</font></td>
        <td class="form-value">${record.username}</td>
    </tr>
    <tr>
        <td class="form-label">部门编号：<font color="red">*</font></td>
        <td class="form-value">${record.deptcode}</td>
    </tr>
    <tr>
        <td class="form-label">部门名称：<font color="red">*</font></td>
        <td class="form-value">${record.deptname}</td>
    </tr>
    <tr>
        <td class="form-label">联系电话：</td>
        <td class="form-value">${record.phone}</td>
    </tr>
    <tr>
        <td class="form-label">每页显示记录数：<font color="red">*</font></td>
        <td class="form-value">${record.pagesize}</td>
    </tr>
    <tr>
        <td class="form-label">是否冻结：<font color="red">*</font></td>
        <td class="form-value"><sc:optd name="disable" value="${record.disable}" type="dict" key="pcmc,boolflag" /></td>
    </tr>
    <tr>
        <td class="form-label">备注：</td>
        <td class="form-value">
            <textarea name="remark" readonly="readonly" class="inputarea" cols="20" rows="3">${record.remark}</textarea>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="form-bottom" align="center">
            <sc:button value="关闭" onclick="window.close();"/>
        </td>
    </tr>
    </table>

