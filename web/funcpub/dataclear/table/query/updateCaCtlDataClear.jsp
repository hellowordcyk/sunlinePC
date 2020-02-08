<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 修改数据清理 配置
 * description: 
 *     1. 修改数据清理 配置
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<!-- 方法地址 /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataClearTable' type='crypto'/>&actions=<sc:fmt value='updateCaCtlDataClear' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>清理表名</td>
    				<td class="form-value">
    					<sc:text name="tableName" readonly="true"/>
    				</td>
    				<td class="form-label">清理表信息</td>
    				<td class="form-value">
    					<sc:text name="tableInfo" index = "1"/>
    				</td>
    			</tr>
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>清理类型</td>
    				<td>
    					<%-- <sc:text name="clearType"/> --%>
    					 <sc:dradio id="clearType" name="clearType" validate="required" type="dict" key="pcmc,clearType" index = "1"/>
    				</td>
    				<td class="form-label"><span class="redmust">*</span>清理顺序</td>
    				<td class="form-value">
    					<sc:text name="validatorOrder" validate="validate digits required" req="1" attributesText="alt='请输入整数！'" index = "1"/>
    				</td>
    			</tr>
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>数据日期键</td>
    				<td class="form-value">
    					<sc:text name="dateKey" validate="required" req="1" index = "1"/>
    				</td>
    				<td class="form-label"><span class="redmust">*</span>保留天数</td>
    				<td class="form-value">
    					<sc:text name="keepDay" validate="validate digits required" req="1" attributesText="alt='请输入整数！'" index = "1"/>
    				</td>
    			</tr>
    			<tr>
    				<td class="form-label">清理状态</td>
    				<td>
    					<sc:dradio name="status"  type="dict" key="pcmc,boolen" index = "1" />
    				</td>
    			</tr>
            </table>
    	</div>
    </div>
	<div class="formBar">
        <ul>
            <li><button type="submit" class="button">提交</button></li>
            <li><button type="button" class="close">取消</button></li>
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
