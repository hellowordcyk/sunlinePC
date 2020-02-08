<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增菜单
 * description: 
 *     1.新增菜单
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160624 优化布局
 *--%>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-menumanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='addMenuInfo' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">上级菜单</td>
					<td class="form-value">
						<sc:hidden name="pmenuid" index="1"/>
						<sc:text name="pmenuname" readonly="true" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">所属子系统</td>
					<td class="form-value">
						<sc:hidden name="subsysid" index="1"/>
						<sc:select name="subsysid" type="subsys" index="1" nullOption ="---请选择----" attributesText='disabled="disabled"'/>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>菜单名称</td>
					<td class="form-value"><sc:text name="menuname" validate="required"/></td>
				</tr>
				<tr>
					<td class="form-label">图片地址</td>
					<td class="form-value"><sc:text name="imgurl" style="width:400px;"/></td>
				</tr>
				<tr>
					<td class="form-label">超链接地址</td>
					<td class="form-value"><sc:text name="linkurl" style="width:400px;"/></td>
				</tr>
				<tr>
					<td class="form-label">打开方式</td>
					<td  class="form-value"><sc:select name="displaytype" type="dict" key="pcmc,menu_displaytype" index="1" includeTitle="false" default="01"/></td>
				</tr>
				<tr>
					<td class="form-label">菜单层次</td>
					<td class="form-value"><sc:text name="levelp" readonly="true" index="1"/></td>
				</tr>
				<tr>
					<td class="form-label">显示序号</td>
					<td class="form-value"><sc:text name="sortno" validate="digits" index="1"/></td>
				</tr>
				<tr>
					<td class="form-label">是否叶子节点</td>
					<td><sc:dradio name="isleaf" type="dict" key="pcmc,boolflag" default="0" /></td>
				</tr>
				<tr>
					<td class="form-label">是否公网发布</td>
					<td><sc:dradio name="isinternet" type="dict" key="pcmc,boolflag" default="0"/></td>
				</tr>
				<tr>
					<td class="form-label">备注</td>
					<td class="form-value"><sc:textarea name="remark" rows="1" cols="30" style="resize:none;"/></td>
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
