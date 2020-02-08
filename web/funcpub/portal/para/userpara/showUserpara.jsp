<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<%-- <%
	
	String paracode = request.getParameter("paracode");
	
%> --%>
<sc:doPost sysName="funcpub" oprId="funcpub-userpara" action="showUserparaInfo" scope="request" var="rspPkg" all="true"></sc:doPost>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-userpara' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updateUserpara' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent">
		<div id="content" class="pageFormContent" style="margin-left:10px;">
			<table width="100%" >
				<tr>
					<td>参数名称：</td>
					<td>
						<sc:write name="paraname"/>
					</td>
					<td>区域编码：</td>
					<td>
						<sc:optd name="areano" type="area" index="1"/>
					</td>
				</tr>
				<tr>
					<td>备注：</td>
					<td><sc:write name="remark" /></td>
					<td>状态</td>
					<td><sc:optd name="status" type="dict" key="pams,inptst" index="1"/></td>
				</tr>
			</table>
			<c:forEach var="dateArea" items="${rspPkg.rspRcdDataMapsResults1}"  varStatus="dateAreaStatus">
				<c:if test="${dateAreaStatus.last}">
					<sc:hidden id="dataAreaid" name="dataAreaid" value = "${dateAreaStatus.count}" />
				</c:if>
				<div id="dataArea${dateAreaStatus.count}" style="width:48%;float:left;margin:5px;margin-top:20px;">
					<div style="border:solid #C0C0C0 1px;">
						<table class="list" width="100%" >
							<tr>
								<td width="20%">起止日期</td>
								<td width="30%">${dateArea.enabledate}</td>
								<td width="30%">${dateArea.disenabledate}</td>
							</tr>
						</table>
					</div>
					<div style="border:solid #C0C0C0 1px;margin-top:5px;">
						<table class="list"  width="100%" >
							<thead>
								<tr >
									<td>机构</td>
									<td>参数值</td>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="dept" items="${rspPkg.rspRcdDataMapsResults2}"  varStatus="deptStatus">
									<tr>
										<td>${dept.deptname}</td>
										<td>
											<c:forEach var="detail" items="${rspPkg.rspRcdDataMapsResults3}"  varStatus="detailStatus">
												<c:if test="${dateArea.enabledate == detail.enabledate && dateArea.disenabledate == detail.disenabledate && detail.orgno == dept.deptid}">
													${detail.paravalue}
												</c:if>
											</c:forEach>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</form>