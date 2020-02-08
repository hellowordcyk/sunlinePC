<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 执行表备份
 * description: 
 *     1.执行表备份
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->
<form action="/httpprocesserservlet" class="pageForm required-validate" method="post" onsubmit="return validateCallback(this,dialogAjaxDone)">
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>">
    <input type="hidden" name="oprID" value="<sc:fmt value='MysqlBackupsTable' type='crypto'/>">
    <input type="hidden" name="actions" value="<sc:fmt value='BackupsMysql' type='crypto'/>">
    <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />">
    <div class="pageContent">
    	<div class="pageFormContent">
    		<table class="form-table" cellpadding="0" cellspacing="0" >
    			<tr>	
    				<td class="form-label"><span class="redmust">*</span>备份数据分隔符</td>
    				<td class="form-value">
    					<sc:text name="fg" validate="required" value="@_@" />
    				</td>
    			</tr> 
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>表名</td>
    				<td class="form-value">
    					<sc:text name="org3.tablename" validate="required"/>
    					<a class="btnLook" href="/funcpub/dbback/table/mysql/tablelookup.jsp" title="选择备份表" lookupGroup="org3"></a>
    				</td>
    			</tr>
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>储存地址</td>
    				<td class="form-value">
    					  <sc:text name="direction" validate="required"/> 
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