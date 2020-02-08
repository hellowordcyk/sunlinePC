<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<style type="text/css" >
		 .weekDay > div  input{
		     margin-left:10px;
		 }
</style>
</head>
<form method="post" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)"
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='holiday' type='crypto'/>&actions=<sc:fmt value='addBacthHoliday' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>开始日期
                    </td>
                    <td class="form-value">
                       <sc:date id="startDate" name="startDate" validate="required"  />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>结束日期
                    </td>
                    <td class="form-value">
                       <sc:date name="endDate" validate="required" minDate="#startDate"  />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>工作日设置
                    </td>
                    <td class="form-value weekDay" >
                       <sc:dcheckbox  name="weekDay"  type="dict" key="pcmc,weekDay" validate="required"   />
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
