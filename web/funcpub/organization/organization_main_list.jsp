<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 根目录所有人员信息
 * description: 
 *     1.根目录所有人员信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<table class="table" cellpadding="0" cellspacing="0" >
	<thead>
		<tr>
			<th class="checkbox">
				<input type="checkbox" class="checkboxCtrl" group="orgcode" />
			</th>
			<th width="20%">组织编码</th>
			<th width="30%">组织名称</th>
			<th>组织类型</th>
			<th >组织描述</th>
			<th width="10%">排序</th>
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
               <c:forEach var="org" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                   <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                       <td class="checkbox">
                           <input type="checkbox" name="orgcode" 
                               value="${org.orgcode}" />
                       </td>
                       <td>${org.orgcode }</td>
                       <td>${org.orgname}</td>
                       <td>
                       	<sc:optd type="knp" key="pcmc,organizationType" value="${org.orgType}"></sc:optd>
                       </td>
                       <td>${org.remark}</td>
                       <td>${org.sortNum}</td>
                       <td>
                           <a class="btnEdit" rel="organization_update" target="dialog"
                               href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='organizationActor' type='crypto'/>&actions=<sc:fmt value='query' type='crypto'/>&orgcode=${org.orgcode}&forward=<sc:fmt value='/funcpub/organization/organization_update.jsp' type='crypto'/>"
                               height="450" width="600">修改 </a>
                       </td>
                   </tr>
               </c:forEach>
           </c:otherwise>
       </c:choose>
	</tbody>
</table>
<div class="panelBar">
	<div class="pagination"   targetType="navTab" 
		totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
		numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
		currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
	</div>
</div>