<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增数据清理 配置
 * description: 
 *     1. 新增数据清理 配置
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<!-- 方法地址 /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post"  class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)" 
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataClearTable' type='crypto'/>&actions=<sc:fmt value='addCaCtlDataClear' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>清理表名</td>
    				<td class="form-value">
    					<sc:text name="tableName" validate="required alphanumeric"/> 
                        
    				</td>
    				<td class="form-label">清理表信息</td>
    				<td class="form-value">
    					<sc:text name="tableInfo"/>
    				</td>
    			</tr>
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>清理类型</td>
    				<td >
    					 <sc:dradio name="clearType" validate="required" type="dict" key="pcmc,clearType" default="1" />
    				</td>
    				<td class="form-label"><span class="redmust">*</span>清理顺序</td>
    				<td class="form-value">
    					<sc:text name="validatorOrder" validate="required digits" attributesText="alt='请输入整数！'"/>
    				</td>
    			</tr>
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>数据日期键</td>
    				<td class="form-value">
    					<sc:text name="dateKey" validate="required"/>
    				</td>
    				<td class="form-label"><span class="redmust">*</span>保留天数</td>
    				<td class="form-value">
    					<sc:text name="keepDay" validate="required digits" attributesText="alt='请输入整数！'"/>
    				</td>
    			</tr>
    			<tr>
    				<td class="form-label">清理状态</td>
    				<td>
    					<sc:dradio name="status"  type="dict" key="pcmc,boolen" default="1" />
    				</td>
    			</tr>
            </table>
    	</div>
    </div>
	<div class="formBar">
        <ul>
            <li><button class="savebtn" type="submit">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>