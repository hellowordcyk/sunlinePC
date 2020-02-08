<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:系统参数配置
 * description: 
 *     系统参数配置
 * author:hzx
 * createtime:20161018
 * 
 *--%>

<sc:doPost sysName="governor" oprId="sysparaActor" action="getSyspara" scope="request" var="rspPkg"></sc:doPost>
<form class="pageForm required-validate" action="/httpprocesserservlet"
	onsubmit="return validateCallback(this,navTabAjaxDone)" method="post">
	<input type="hidden" name="sysName" value="<sc:fmt value='governor' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='sysparaActor' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updateSyspara' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp'/>"/>
	<div class="pageContent">
		<div class="pageFormContent">
			<c:forEach var="sysparas" items="${rspPkg.rspRcdDataMaps}"
				varStatus="status">
				<h2 class="contentTitle">${sysparas.paraType}</h2>
				<table class="form-table" cellpadding="0" cellspacing="0">
					<c:forEach var="syspara" items="${sysparas.sublist}"
						varStatus="high">
						<c:choose>
							<c:when test="${syspara.inputType eq 'select' }">
								<tr>
									<td class="form-label" style="width:20%">${syspara.paraName}</td>
									<td><sc:select name="${syspara.paraCode}" type="dict"
											key="${syspara.scType}" default="${syspara.paraValue }"/>
										<span class="info">${syspara.remark}</span>
									</td>
								</tr>
							</c:when>
							<c:when test="${syspara.inputType eq 'date' }">
								<tr>
									<td class="form-label" style="width:20%">${syspara.paraName}</td>
									<td><sc:date name="${syspara.paraCode}"
											dateFmt="yyyy-MM-dd" value="${syspara.paraValue}" />
										<span class="info">${syspara.remark}</span>
									</td>
								</tr>
							</c:when>
							<c:when test="${syspara.inputType eq 'radio' }">
								<tr>
									<td class="form-label" style="width:20%">${syspara.paraName}</td>
									<td><sc:dradio name="${syspara.paraCode}" type="dict"
											key="${syspara.scType}" default="${syspara.paraValue }">
										</sc:dradio>
										<span class="info">${syspara.remark}</span>
									</td>
								</tr>
							</c:when>
							<c:otherwise>
								<tr>
									<td class="form-label" style="width:20%">${syspara.paraName}</td>
									<td><sc:text name="${syspara.paraCode}"
											validate="${syspara.inputCheck}" value="${syspara.paraValue}"/>
										<span class="info">${syspara.remark}</span>
									</td>
									
								</tr>
								<tr>
							</c:otherwise>
						</c:choose>
					</c:forEach>
					<tr >
						<td style="height:30px"></td>
					</tr>
				</table>
			</c:forEach>
		</div>
	</div>
	<div class="formBar">
		<ul>
			<li><button class="savebtn" type="submit">保存</button></li>
			<li><button class="close" type="button">取消</button></li>
		</ul>
	</div>
</form>
