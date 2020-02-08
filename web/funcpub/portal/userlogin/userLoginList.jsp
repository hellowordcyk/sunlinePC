<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 被冻结账户登录 日志
 * description: 
 *     1. 被冻结账户登录 日志
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return dialogSearch(this);">
	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='userLoginDetail'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='getUserLoginDetail'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/userlogin/userLoginList.jsp' />"/>
	<input type="hidden" name="pageNum" value="1" />
	<sc:hidden name='userId' value='${param.userId }' />
</form>
<div class="pageContent">
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th>用户ID</th>
				<th>登录时间</th>
				<th>登录IP</th>
				<th>登录状态</th>
				<!-- <th>失败次数</th> -->
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="4">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
    			<c:forEach var="userLoginLog" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
    				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
    					<td>${userLoginLog.userId }</td>
    					<td>${userLoginLog.lognDt }</td>
    					<td>${userLoginLog.lognIp }</td>
    					<td>${userLoginLog.lognSt }</td>
    					<%-- <td>${userLoginLog.erorNo }</td> --%>
    				</tr>
    			</c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="dialog" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div>
