<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 根目录所有机构信息
 * description: 
 *     1.根目录所有机构信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
	<table class="table" cellpadding="0" cellspacing="0"  >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="checkboxgroup" /></th>
				<th width="20%">机构编码</th>
				<th>机构名称</th>
				<th width="10%">操作</th>
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
    			<c:forEach var="u" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
    				<tr <c:if test="${Index.index%2 != 0}"> class="evenrow" </c:if>>
    					<td class="checkbox"><input type="checkbox" name="checkboxgroup" value="{${param.lookupcode}:'${u.deptcode}', ${param.lookupname}:'${u.deptname}'}"/></td>
    					<td>${u.deptcode}</td>
    					<td>${u.deptname}</td>
                        <td>
                            <a class="btnRun"
                                onclick="toViewInTree('${u.deptid}','${u.orgseq}', '${u.deptcode }', 'dept');"
                                href="#;return false;">
                                <span>详情</span>
                            </a>
                        </td>
                    </tr>
    			</c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
    <div class="panelBar">
        <div  class="pagination" rel="deptManagerBox1"
            totalCount="${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}"
            numPerPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
            currentPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}"></div>
    </div>
