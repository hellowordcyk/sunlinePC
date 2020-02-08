<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 数据清理 执行
 * description: 
 *     1.数据清理 执行
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='caCtlDataClear' type='crypto'/>&actions=<sc:fmt value='queryDataClear' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
        		 <tr>
        			<td class="form-label"><span class="redmust">*</span>日期</td>
        			<td class="form-value">
        				<%-- <sc:date name="dataDate" dateFmt="yyyy-MM-dd" /> --%>
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
        		  <td class="form-label">&nbsp;</td>
        		     <td class="form-value" colspan="2">
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