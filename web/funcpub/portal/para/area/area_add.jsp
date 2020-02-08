<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 区域管理-新增
 * description: 
 *     1.区域管理-新增
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160628 布局调整
 *--%>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
	<input type="hidden" name="oprID" value="<sc:fmt value='SysPubArea' type='crypto'/>" />
	<input type="hidden" name="actions" value="<sc:fmt value='addArea' type='crypto'/>" />
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />" />
	<div class="pageContent" style="padding-bottom:50px;">
		<div class="pageFormContent">
			<table  cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td class="form-label"><span class="redmust">*</span>区域编号</td>
					<td class="form-value">
						<input type="text" id="areaNo" name="areaNo" class="required digits"  maxlength="4" minlength ="4" alt="请输入由四位数组成的编号"/>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>区域名称</td>
					<td class="form-value">
						<sc:text id="areaName" name="areaName" validate="required"/>
					</td>
				</tr>
				
				<tr>
					<td class="form-label">顺序号</td>
					<td class="form-value">
						<sc:text id="sortNum" name="sortNum"  validate="digits" attributesText='min="1"' />
					</td>
				</tr>
				<tr>
					<td class="form-label">是否使用</td>
					<td>
						<sc:dradio id="hoFlag" name="hoFlag"  type="dict" key="pcmc,boolflag" default="0" />
					</td>
				</tr>
				<tr>
					<td class="form-label">总行区域</td>
					<td>
						<sc:dradio id="hqFlag" name="hqFlag"  type="dict" key="pcmc,boolflag" default="1" />
					</td>
				</tr>
				<tr>
					<td class="form-label">表空间</td>
					<td class="form-value">
						<sc:text name="tabSpace" attributesText='maxlength="2"'/>
					</td>
				</tr>
				<tr>
					<td class="form-label">区域机构</td>
					<td class="form-value">
						<sc:text name="orgStr"/>
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
