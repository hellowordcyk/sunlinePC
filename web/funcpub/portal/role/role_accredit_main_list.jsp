<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<table class="table" cellpadding="0" cellspacing="0" >
	<thead>
		<tr>
			<th class="checkbox"><input type="checkbox" class="checkboxCtrl"
				group="paramp" /></th>
			<th>用户编号</th>
			<th>用户名称</th>
			<th>所在机构</th>
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
       			<c:forEach var="user" items="${jrafrpu.rspPkg.rspRcdDataMaps}"
       				varStatus="Index">
       				<tr <c:if test="${Index.index%2 != 0}"> class="evenrow"</c:if> >
       					<td class="checkbox">
       						<input type="checkbox" name="paramp" value="${user.userid}" />
       					</td>
       					<td>${user.usercode}</td>
       					<td>${user.username}</td>
       					<td>${user.deptname}</td>
       				</tr>
       			</c:forEach>
               </c:otherwise>
           </c:choose>
	</tbody>
</table>
<div class="panelBar">
    <div class="pagination"  rel="user_priv_ctt" 
        totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
        numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
        currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
    </div>
</div>

