<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>

<!-- 方法地址 /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='choiceCaCtlDataClear' type='crypto'/>&actions=<sc:fmt value='queryDataClear' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
    		 <tr>
    			<td class="form-label"><span class="redmust">*</span>日期</td>
    			<td class="form-value">
    				<%-- <sc:date name="dataDate" dateFmt="yyyy-MM-td" /> --%>
    				<input type="text" name="dataDate" class="required date" dateFmt="yyyy-MM-dd" />
    				<%-- <sc:text name="dataDate"/> --%>
    			</td>
    		</tr>
    		<tr>
    			<td class="form-label"><span class="redmust">*</span>区域号</td>
    			<td class="form-value">
    				<sc:text name="areaNo" validate="required"/>
    			</td>
    		</tr>
    		
    		<tr>
    			<td class="form-label">表名</td>
    			<td class="form-value">
    				<input name="choiceCaCtlDataClear.tableName" type="text" readonly="true" class="required alphanumeric"/>
    				<a class="btnLook" href="/funcpub/dataclear/table/choice/choiceCaCtlDataClearLookUp.jsp" lookupGroup="choiceCaCtlDataClear"></a>
    			</td>
    		</tr>
    		<tr>
    		     <td class="form-label">&nbsp;</td>
                 <td class="form-value">
                    <span class="info">备份的表必须包含area_no字段和相应的数据日期键字段才能执行成功！</span>
                 </td>
            </tr>
            </table>
    	</div>
    </div>
	<div class="formBar">
        <ul>
            <li><button class="savebtn" type="submit">执行</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>
	
<script type="text/javascript">
	function customvalidXxx(element){
		if ($(element).val() == "xxx") 
			 return false;
		return true;
	}
	
</script>