<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 

<table class="table" cellpadding="0" cellspacing="0" >
	<thead>
		<tr>
			<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="shareId" /></th>
			<th>标题</th>
			<th width="15%">所属子系统</th>
			<th width="30%">实体名称</th>
			<th width="12%">分享人</th>
			<th width="12%">拥有者</th>
		</tr>
	</thead>
	<tbody>
      <c:choose>
        <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
            <tr>
                <td class="empty" colspan="6">查询无数据。</td>
            </tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="share" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                    <td class="checkbox">
                        <input type="checkbox" name="shareId" 
                        	pkval="${share.dbColumnPK }" 
                        	pkvala="${share.dbColumnPKA }" 
                        	pkvalb="${share.dbColumnPKB }" 
                        	pkvalc="${share.dbColumnPKC }" 
                        	pkvald="${share.dbColumnPKD }" 
                            value="${share.shareId}" />
                    </td>
                    <td>${share.title }</td>
                    <td>
                    	${share.subsysCnName }
                    </td>
                    <td>${share.entityName}[${share.entityCode }]</td>
                    <td>${share.sharerName}</td>
                    <td>${share.ownerName}</td>
                </tr>
            </c:forEach>
        </c:otherwise>
    </c:choose>
	</tbody>
</table>
<div class="panelBar">
	<div class="pagination" targetType="navTab" rel="priv_share_main_list"
		totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
		numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
		currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
	</div>
</div>
