<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增表备份配置
 * description: 
 *     1.新增表备份配置
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form id="addCaCtlDataBak" method="post" action="" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
        		<tr>
        			<td class="form-label"><span class="redmust">*</span>表名</td>
        			<td class="form-value">
        				<c:if test="${param.ad eq 1}">
        				    <sc:text name="tableName" index="1" readonly="true"/>
        				</c:if>
        				<c:if test="${param.ad ne 1}">
        				    <sc:text name="tableName" index="1" validate="required alphanumeric"/>
        				</c:if>
        			</td>
        		</tr>
        		<tr>
        			<td class="form-label">表中文名</td>
        			<td class="form-value">
        				<sc:text name="tableInfo" index="1"/>
        			</td>
        		</tr>
        		
        		<tr>
        			<td class="form-label">对应条件</td>
        			<td class="form-value">
        				<sc:textarea rows="2" cols="30" name="bakCond" index="1"/>
        			</td>
        		</tr>
        		<tr>
        			<td class="form-label">是否备份</td>
        			<td>
        				<c:if test="${param.ad eq 1}">
        					<sc:dradio name="bakFlag"  type="dict" key="pcmc,boolen" index = "1"/>
        				</c:if>
        				<c:if test="${param.ad ne 1}">
        					<sc:dradio name="bakFlag"  type="dict" key="pcmc,boolen" default="1"/>
        				</c:if>
        			</td>
        		</tr>
            </table>
    	</div>
    </div>
	<div class="formBar">
		<ul>
			<c:if test="${param.ad eq 1}">
                <li><button class="savebtn" type="button" onclick="tijiao(1);">保存</button></li>
			</c:if>
			<c:if test="${param.ad ne 1}">
				<li><button class="savebtn" type="button" onclick="tijiao(0);">保存</button></li>
			</c:if>
			<li><button class="close" type="button">取消</button></li>
		</ul>
	</div>
</form>
	
<script type="text/javascript">
	function tijiao(act){
		if(act == "1"){
			$("#addCaCtlDataBak", $.pdialog.getCurrent()).attr("action","/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='MysqlBackupsTableManage' type='crypto'/>&actions=<sc:fmt value='updateCaCtlDataBak' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>");
		}else{
			$("#addCaCtlDataBak", $.pdialog.getCurrent()).attr("action","/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='MysqlBackupsTableManage' type='crypto'/>&actions=<sc:fmt value='addCaCtlDataBak' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>");
		}
		$("#addCaCtlDataBak", $.pdialog.getCurrent()).submit();
		navTab.reloadFlag("queryCaCtlBataBak");
	}
</script>
