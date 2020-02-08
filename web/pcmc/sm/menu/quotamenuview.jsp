<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%
  response.setHeader("Cache-Control","no-cache");
  response.setHeader("Pragma","no-cache");
  response.setDateHeader ("Expires", 0);
%>
<c:if test="${not empty param.pmenuid }">
<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
	<tr><th colspan="2">菜单信息</th></tr>
	<tr>
		<td class='form-label' style="width: 130px;">菜单编号：</td>
		<td class='form-value'><sc:fmt name="menuid" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">菜单名称：<span style="color: red;">*</span></td>
		<td class='form-value'><sc:fmt name="menuname" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">上级菜单ID：</td>
		<td class='form-value'><sc:fmt name="pmenuid" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">超链接地址：</td>
		<td class='form-value'><sc:fmt name="linkurl" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">显示序号：<span style="color: red;">*</span></td>
		<td class='form-value'><sc:fmt name="sortno" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">是否公网发布：</td>
		<td class='form-value'><sc:optd name="isinternet" type="dict" key="pcmc,boolflag" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">备注：</td>
		<td class='form-value'><sc:fmt name="remark" index="1"/>&nbsp;</td>
	</tr>
</table>
</c:if>
<c:if test="${empty param.pmenuid }">
<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
	<tr><th colspan="2">菜单信息</th></tr>
	<tr>
		<td class="form-label" style="width: 130px;">菜单名称：<span style="color: red;">*</span></td>
		<td class='form-value'><sc:fmt name="menuname" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<sc:select dsp="td" dspName="所属子系统" req="1" index="1" attributesText="disabled='disabled'"
		nullOption="--请选择--" name="subsysid" type="subsys" key="" />
	</tr>
	<tr>
		<td class="form-label">超链接地址：</td>
		<td class='form-value'><sc:fmt name="linkurl" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">显示序号：<span style="color: red;">*</span></td>
		<td class='form-value'><sc:fmt name="sortno" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">是否公网发布：</td>
		<td class='form-value'><sc:optd name="isinternet" type="dict" key="pcmc,boolflag" index="1"/>&nbsp;</td>
	</tr>
	<tr>
		<td class="form-label">备注：</td>
		<td class='form-value' style="word-break: break;"><sc:fmt name="remark" index="1"/>&nbsp;</td>
	</tr>
</table>
</c:if>