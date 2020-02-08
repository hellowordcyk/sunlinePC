<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html>
<form method="post" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)"
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='holiday' type='crypto'/>&actions=<sc:fmt value='updateHoliday' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>日期
                    </td>
                    <td class="form-value">
			 			 <span id="calendarDate" ><sc:fmt value='${jrafrpu.rspPkg.rspRcdDataMaps[0].calendarDate}' type='Date' pattern='yyyy-mm-dd'/></span>
		   				 <sc:hidden name="calendarDate" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].calendarDate}"   />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>日期类型
                    </td>
                    <td class="form-value">
                        <sc:select name="dateType" type="knp"  key="pcmc,dateType" validate="required" index="1" excludes="%" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">描述</td>
                    <td class="form-value">
                        <sc:text name="dateDesc" index="1"  />
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


<script>
     $(function(){
    	  var calendarDate = $("#calendarDate",$.pdialog.getCurrent()).html();
    	  $("[name='calendarDate']",$.pdialog.getCurrent()).val(calendarDate);
     })
</script>