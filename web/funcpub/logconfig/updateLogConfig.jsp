<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--规范：每个页面前必需增加注释。1）说明主要功能；2）主要功能修改日志 --%>
<%--
 * title: 角色管理
 * description: 
 *     1.维护（新增、修改、删除）角色信息；
 *     2.分配角色菜单权限；
 *     3.分配角色资源权限；
 *     4.设置角色权限分组：根据不同权限组设置，获取相应数据访问权限（目前主要是机构访问权限）
 * author: longjian
 * createtime: 2015-05-01 10:30
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>

<div class="pageContent">
	<sc:doPost sysName="funcpub" oprId="funcpub-logconfig" action="getOperationInfo" params="id=${param.id }"/>
	<c:set var="record" value="${jrafPkg.rspRcdDataMaps[0] }"/> 
	<div class="accordion" style="margin:5px;" >
		<div class="accordionHeader">
			<h2>日志配置信息</h2>
		</div> 
	</div>
	<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone)">
		<input type="hidden" name="sysName" value="<sc:fmt type="crypto" value="funcpub"/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt type="crypto" value="funcpub-logconfig"/>"/>
		<input type="hidden" name="actions" value="<sc:fmt type="crypto" value="updateLogConfig"/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
		<sc:hidden name="syscd" value="${record.syscd }"/>
		<sc:hidden name="sysoperid" value="${record.sysoperid }"/>
		<sc:hidden name="sysaction" value="${record.sysaction }"/>
		<div class="pageFormContent" >
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">所属子系统:</td>
					<td class="form-value">${record.sysname }</td>
				</tr>
				<tr>
					<td class="form-label">所属功能模块:</dt>
					<td class="form-value">${record.operdesc }</td>
				</tr>
				<tr>
					<td class="form-label">所属功能:</dt>
					<td class="form-value">${record.actiondesc }</td>
				</tr>
				<tr>
					<td class="form-label">是否记录日志</td>
					<td><sc:dradio name="islog" type="dict" key="pcmc,boolflag" default="${record.islog }"/></td>
				</tr>
			</table>
		</div>
		<div class="formbutton_bg">
			<span>
				<input class="button" type="submit" value="保存" />
			</span>
		</div>
	</form>
</div>
