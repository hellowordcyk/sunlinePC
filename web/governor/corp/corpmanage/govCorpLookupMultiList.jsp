<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<table class="table" width="100%" layoutH="170" style="table-layout: fixed;">
	<thead>
		<tr>
			<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="checkboxgroup" /></th>
			<th width="30%">法人编码</th>
			<th>法人名称</th>
			<th width="30%">法人简称</th>
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
			<c:forEach var="corp" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
				<tr <c:if test="${Index.index%2 != 0}"> class="evenrow" </c:if> >
					<td class="checkbox">
                         <input type="checkbox" name="checkboxgroup" value="{${param.lookupcode}:'${corp.corpCode}', ${param.lookupname}:'${corp.corpName}'}"/>
					</td>
					<td>${corp.corpCode}</td>
					<td>${corp.corpName}</td>
					<td>${corp.corpShortname}</td>
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