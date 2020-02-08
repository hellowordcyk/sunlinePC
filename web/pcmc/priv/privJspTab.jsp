<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp" %>
<table width="100%" cellpadding="0" cellspacing="0" class="list-table">
	<tr>
		<td>
			&nbsp;&nbsp;<img src="/common/skins/default/images/pisa_plus.gif" width="15" height="15" onclick="addRow()" style="cursor:hand">&nbsp;&nbsp;
			<img src="/common/skins/default/images/pisa_minus.gif" width="15" height="15" onclick="deleteRow()" style="cursor:hand">
		</td>
	</tr>
	<tr>
	    <td>
	    <div id="recodeDiv" style="height:477px;overflow:auto">
	    	<sc:hidden attributesText="id='delTypecds'" name="delTypecds"/>
			<sc:hidden attributesText="id='addTypecds'" name="addTypecds"/>
			<sc:hidden attributesText="id='updateTypecds'" name="updateTypecds"/>
			<display:table uid="jspRecord" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet" sort="list">
				<display:column style="width:7%;text-align:center" title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
	           		<input type="checkbox" id="typecd_${jspRecord_rowNum}" name="typecdindex" onclick="outlineMyRow(this)" value='${jspRecord.typecd}'/>
				</display:column>
				<display:column title="功能类型代码" style="text-align:center">
	           		<input type="text" id="typecd${jspRecord_rowNum}" name="typecd" onclick="outlineMyRow(this)" value='${jspRecord.typecd}' oldvalue='${jspRecord.typecd}' maxLength='128' readOnly />
				</display:column>
				<display:column title="功能类型名称" style="text-align:center">
					<input type="text" id="typena${jspRecord_rowNum}" name="typena" onclick="outlineMyRow(this)" value='${jspRecord.typena}' oldvalue='${jspRecord.typena}' maxLength='64' readOnly />
				</display:column>
				<display:column title="JSP 选择" style="text-align:center">
					<sc:button value="引入类型" onclick="importType('typecd${jspRecord_rowNum}', 'typena${jspRecord_rowNum}')" />
				</display:column>
			</display:table>
		</div>
		</td>
	</tr>
</table>
<div align="center" class="page-bottom">
   <sc:button value="保存" onclick="saveBtn()" />
   <sc:button value="重置" onclick="resetBtn()" />
</div>
