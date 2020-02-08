<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<form class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)" method="post" 
	action="/httpprocesserservlet" >
	<input type="hidden" name="sysName" value="<sc:fmt value='sunrpt' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='sunrpt-report' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='addRpt' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>"/>
	<div class="pageContent" width="100%">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="form-label"><span class="redmust">*</span>报表名称</td>
				    <td class="form-value"><sc:text name="rptName" validate="required" style="width:90%"/></td>
				</tr>
				<tr> 				      
					<td class="form-label"><span class="redmust">*</span>超链接地址</td>
					<td class="form-value"><sc:text name="linkUrl" validate="required" style="width:90%"/></td> 
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
		<ul>
			<li><button type="submit" class="button">保存</button></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>
</form>