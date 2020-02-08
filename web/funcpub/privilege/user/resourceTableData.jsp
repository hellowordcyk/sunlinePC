<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 用户资源授权
 * description: 
 *     1.用户资源授权
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<table class="table" cellpadding="0" cellspacing="0" >
	<thead>
		<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
	    <th width="25%">资源编码</th>
	    <th>资源名称</th>
	</thead>
	<tbody>
    <c:choose>
        <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
            <tr>
                <td class="empty" colspan="3">查询无数据。</td>
            </tr>
        </c:when>
        <c:otherwise>
			<c:forEach var="privmsg" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
    			<tr <c:if test="${Index.index%2 != 0}"> class="evenrow"</c:if> >
    				<td class="checkbox">
    					<input type="checkbox" name="paramp"/>
    					<input type="hidden" id="subsysCode" name="subSysCode" value="${privmsg.subsysCode }"/>
    					<input type="hidden" id="privCode" name="privCode" value="${privmsg.privCode }"/>
    					<input type="hidden" id="privType" name="privType" value="${privmsg.privType }"/>
    				</td>
    				<td>${privmsg.privCode}</td>
    				<td>${privmsg.privName}</td>
                 </tr>
			 </c:forEach>
        </c:otherwise>
    </c:choose>
	</tbody>
</table>
<div class="panelBar">
<form id="pagerForm" name="pagerForm" action="#rel#" method="post">
	<sc:hidden name="pageNum" value="1" />
</form>	
<div class="pagination" totalCount="${jrafrpu.rspPkg.rspRecordCount}" rel="resclist"
numPerPage="${jrafrpu.rspPkg.rspPageSize}" currentPage="${jrafrpu.rspPkg.rspPageNo}"></div>
</div>
<script type="text/javascript">
$(function () {
	initUI($("#userManagerBox2"));//初始化分页控件等
});

</script>