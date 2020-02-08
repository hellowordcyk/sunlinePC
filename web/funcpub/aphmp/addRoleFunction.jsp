<%@page import="java.util.Map"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<% 
	Document xmlDoc = (Document)request.getAttribute("xmlDoc");
	Element data = xmlDoc.getRootElement().getChild("Response").getChild("Data");
	List<Element> roleFunction = data.getChild("Results2").removeContent();
	String rowNum  = data.getChild("Results1").getChild("Record").getChildTextTrim("rowNum");
	String columnNum  = data.getChild("Results1").getChild("Record").getChildTextTrim("columnNum");
	int row = Integer.parseInt(rowNum);//行
	int col = Integer.parseInt(columnNum);//列
%>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
	<input type="hidden" name="oprID" value="<sc:fmt value='aphmp-functionRegister' type='crypto'/>" />
	<input type="hidden" name="actions" value="<sc:fmt value='editRoleFunction' type='crypto'/>" />
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />" />
	<input type="hidden" name="roleID" value="${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].roleID}" />
	<input type="hidden" name="columnNum" value="${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].columnNum}" />
	<input type="hidden" name="rowNum" value="${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].rowNum}" />
	<div class="pageContent">
		<div class="pageFormContent">
			<table width="100%">
				<%for(int r=1;r<=row;r++){%>
				<tr>
					<%for(int c=1;c<=col;c++){%>
					<td align="right">坐标:</td>
					<td><%=r%>,<%=c%></td>
					<%}%>
				</tr>
				<tr>
					<%for(int c=1;c<=col;c++){
						String functionID1 = "";
						if(null != roleFunction && roleFunction.size()>0){
							for(Element element:roleFunction){
								String cellCoordinate = element.getChildTextTrim("cellCoordinate");
								if( (r+""+c).equals(cellCoordinate) ){
									functionID1 = element.getChildTextTrim("functionID");
								}
							}
						}		
					%>
					<td align="right">功能</td>
					<td>
						<select name="functionID_<%=r%><%=c%>">
							<option value="">--请选择--</option>
							<c:forEach var="function" items="${jrafrpu.rspPkg.rspRcdDataMapsResults3}" varStatus="index1">
								<%String functionID2 = (String)((Map)pageContext.getAttribute("function")).get("functionID");%>
								<%if(functionID1.equals(functionID2)){%>
								<option value="${function.functionID}" selected="selected">${function.functionName}</option>
								<%}else{%>
								<option value="${function.functionID}">${function.functionName}</option>	
								<%}%>
								
							</c:forEach>
						</select>
					</td>	
					<%}%>
				</tr>
				<tr><td></td></tr>
				<%}%>
			</table>
		</div>
	</div>
	<div class="formBar">
		<ul>
			<li><input type="submit" class="button" value="提交" /></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>
</form>	
