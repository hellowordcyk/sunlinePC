<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jui_tag.jsp" %>
<form class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)" method="post"
      action="/httpprocesserservlet">
    <input type="hidden" name="sysName" value="<sc:fmt value='governor' type='crypto'/>"/>
    <input type="hidden" name="oprID" value="<sc:fmt value='sqlMonitor' type='crypto'/>"/>
    <input type="hidden" name="actions" value="<sc:fmt value='deleteSqlMonitor' type='crypto'/>"/>
    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" />
    
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
		        <tr>
		        	<td class="form-label">删除频率：</td>
		        	<td class="form-value" style="width:100px">
		        		<sc:text name="time" validate="required digits" attributesText="maxLength='1'"/>
		             </td>
		        	<td>
		        		<select id="unit" name="unit" class="inputselect">
		        			<option value="h">小时</option>
		        			<option value="d">天</option>
		        		</select>
		        	</td>
		        </tr>
		        <tr >
		        	<td colspan='3' align='center' class="form-bottom">
		        		<input type="submit" class="button" value="提交"/>
		        		<input type="reset" class="button" value="重置" />
		             </td>
		        </tr>
    		</table>
    	</div>
    </div>
</form>
