<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<table class="table" cellpadding="0" cellspacing="0" >
	<thead>
		<tr>
			<th width="20%">实体编码</th>
			<th width="30%">实体名称</th>
			<th >数据库实体表</th>
			<th width="10%">数据拥有者字段</th>
			<th width="10%">数据部门字段</th>
			<th>所属子系统</th>
			<th width="10%">操作</th>
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
               <c:forEach var="entity" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                   <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                       <td>${entity.entityCode }</td>
                       <td>${entity.entityName}</td>
                       <td>${entity.dbTable}</td>
                       <td>${entity.dbColumnOwner}</td>
                       <td>${entity.dbColumnDept}</td>
                       <td>
                       	<sc:optd name="systemCode" type="subsyscd" index="1" value="${entity.systemCode }"/>
                       </td>
                       <td>
                           <a class="btnSelect" 
								href="javascript:$.bringBack({'${param.lookupid}':'${entity.entityCode }','${param.lookupcode}':'${entity.entityCode }','${param.lookupname}':'${entity.entityName }','pkColumn':'${entity.dbColumnPK }','pkaColumn':'${entity.dbColumnPKA }','pkbColumn':'${entity.dbColumnPKB }','pkcColumn':'${entity.dbColumnPKC }','pkdColumn':'${entity.dbColumnPKD }' })" title="查找带回">选择</a>
                       </td>
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
