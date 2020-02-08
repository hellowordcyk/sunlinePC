<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp" %>
<table width="100%" cellpadding="0" cellspacing="0" class="list-table">
	<tr>
		<td>
			&nbsp;&nbsp;<img src="/common/skins/default/images/pisa_plus.gif" width="15" height="15" onclick="addRow()" style="cursor:hand">&nbsp;&nbsp;
			<img src="/common/skins/default/images/pisa_minus.gif" width="15" height="15" onclick="deleteRow()" style="cursor:hand">
		</td>
	</tr>
	<tr>
	    <td style=" padding: 0;">
	    <div id="recodeDiv" style="height:477px;overflow:auto;">
	    	<sc:hidden attributesText="id='delTypecds'" name="delTypecds"/>
			<sc:hidden attributesText="id='addTypecds'" name="addTypecds"/>
			<sc:hidden attributesText="id='updateTypecds'" name="updateTypecds"/>
			<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet" sort="list">
				<display:column style="width:7%;text-align:center" title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
	           		<input type="checkbox" id="typecd_${record_rowNum}" name="typecdindex" onclick="outlineMyRow(this)" value='${record.typecd}'/>
				</display:column>
				<display:column title="功能类型代码" style="text-align:center">
	           		<input type="text" name="typecd" onclick="outlineMyRow(this)" value='${record.typecd}' oldvalue='${record.typecd}' maxLength='128'/>
				</display:column>
				<display:column title="功能类型名称" style="text-align:center">
					<input type="text" name="typena" onclick="outlineMyRow(this)" value='${record.typena}' oldvalue='${record.typena}' maxLength='64'/>
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
