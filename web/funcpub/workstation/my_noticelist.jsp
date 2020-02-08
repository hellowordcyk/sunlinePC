<%@page import="com.sunline.jraf.util.Crypto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<script type="text/javascript">
	$(function(){
		initUI($(".homepage"));
	});
</script>
<sc:doPost sysName="funcpub" oprId="info" action="getUserSysInfolistPage" scope="request" var="rspPkg" all="true"></sc:doPost>
<table class="table list" width="100%">
	<tbody>
	    <c:forEach var="record" items="${rspPkg.rspRcdDataMaps}" varStatus="status">
	     	 <tr >
				<td>
					<a class="btnEdit" rel="show_pcmcinfo" target="dialog" height="650" width="725" 
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='info' type='crypto'/>&actions=<sc:fmt value='readPcmcInfo' type='crypto'/>&infoid=${record.infoid}&forward=<sc:fmt value='/funcpub/workstation/pm/show_pcmcinfo.jsp' type='crypto'/>">
						${record.title} &nbsp;&nbsp;&nbsp; <sc:fmt type="date" value="${record.createtime}" pattern="yyyy-MM-dd HH:mm:ss"/>
						<c:choose>
							<c:when test="${record.isread != null && record.isread != '' }">
								&nbsp;&nbsp;&nbsp;已读
							</c:when>
							<c:otherwise>
								&nbsp;&nbsp;&nbsp;未读
							</c:otherwise>
						</c:choose>
					</a>
					<c:if test="${record.isread == null || record.isread == '' }">
						<a class="" 
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='info' type='crypto'/>&actions=<sc:fmt value='markNoCare' type='crypto'/>&infoid=${record.infoid}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" 
						rel="container" target="ajaxToDo" callback="callbackMg" >&nbsp;&nbsp;&nbsp;不关心</a>
					</c:if>
				</td>
			</tr>
       </c:forEach>
	</tbody>
</table>

