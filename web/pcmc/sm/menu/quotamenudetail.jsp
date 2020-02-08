<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<%
  response.setHeader("Cache-Control","no-cache");
  response.setHeader("Pragma","no-cache");
  response.setDateHeader ("Expires", 0);
%>
<%-- 根节点时（子系统）无上级节点pmenuid=='' 或者可编辑（不能修改所属子系统） --%>
<c:if test="${not empty param.pmenuid || param.editable =='true'}">
	<sc:hidden name="subsysid" index="1"/>
</c:if>
<sc:hidden name="levelp" index="1"/>
<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
	<tr><th colspan="10">修改菜单信息</th></tr>
	<tr>
		<td class='form-label' style="width: 130px;"><strong>菜单编号：</strong></td>
		<td class='form-value'><sc:fmt name="menuid" index="1"/><sc:hidden name="menuid" index="1"/></td>
	</tr>
	<tr>
		<sc:text name="menuname" index="1" size="20" req="1" dspName="菜单名称" dsp="td" />
	</tr>
  <c:if test="${empty param.pmenuid }">
	<tr>
		<%-- 可编辑状态（不能修改所属子系统） --%>
		<c:if test="${param.editable =='true' }">
			<sc:select dsp="td" dspName="所属子系统" index="1" attributesText="disabled='disabled'" 
			nullOption="--请选择--" name="subsysid" type="subsys" key="" />
		</c:if>
		<c:if test="${param.editable !='true' }">
			<sc:select dsp="td" dspName="所属子系统" index="1" 
			nullOption="--请选择--" name="subsysid" type="subsys" key="" />
		</c:if>
	</tr>
  </c:if>
  <c:if test="${not empty param.pmenuid }">
	<tr>
		<sc:text name="pmenuid"  index="1" size="10" dspName="上级菜单ID" attributesText="readonly='readonly'" dsp="td" />
	</tr>
	<tr>
		<sc:textarea name="linkurl" index="1" dspName="超链接地址" dsp="td" rows="5" cols="80"/>
	</tr>
  </c:if>
	<tr>
		<sc:text name="sortno" index="1" size="5" req="1" dspName="显示序号" dsp="td" type="num"/>
	</tr>
	<tr>
		<td class="form-label"><strong>是否公网发布：</strong></td>
		<td class="form-value"><sc:select name="isinternet" type="dict" key="pcmc,boolflag" includeTitle="false" index="1" /></td>
	</tr>
	<tr>
		<sc:textarea name="remark" index="1" dspName="备注" dsp="td" rows="5" cols="80"/>
	</tr>
</table>