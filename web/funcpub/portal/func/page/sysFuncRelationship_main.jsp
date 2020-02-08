<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 页面关系管理
 * description: 
 *     1.维护（新增、删除）页面关系；
 * author: ZhaoXuePing
 * create time: 
 * logs:
 *--%>
<div class="pageHeader">
	<form id="page_relationship_ctt_pagerForm" onsubmit="return divSearch(this, 'page_relationship_ctt')" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='sysFuncRelationshipActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='querySysFuncRelationship' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/func/page/sysFuncRelationship_main.jsp'/>" />
		<sc:hidden name="funcSuperCode" index="1"/>
			<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<input type="hidden" name="pageNum" value="1" />
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">页面编号 </td>
				    <td class="form-value"><sc:text name="funcCode"/></td>
				    <td class="form-label">页面名称</td>
				    <td class="form-value"><sc:text name="funcName"/></td>
                    <td class="form-btn">
                        <ul>
                            <li>
                                <button id="relationship_queryBtn" class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
                </tr>
		    </table>
	    </div>
	</form>
</div>
<div class="pageContent" id="page_relationship_ctt">
    <div class="panelBar">
        <ul class="toolBar">
			<li>
				<a class="add" rel="relationship_update" target="dialog" close="reloadGrantDl" 
					href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncRelationshipActor' type='crypto'/>&actions=<sc:fmt value='queryUnRelationPages' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/portal/func/page/sysFuncPageSelected.jsp' />&funcSuperCode=<c:out value='${param.funcSuperCode}'/>" height="550" width="900" fresh="true" >
					<span>关联</span>
				</a>
			</li>
            <li>
                <a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncRelationshipActor' type='crypto'/>&actions=<sc:fmt value='deleteSysFuncRelationships' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th width="5%">序号</th>
				<th width="15%">子页面代码</th>
				<th width="15%">子页面名称</th>
				<th width="50%">子页面路径</th>
				<th>操作</th>
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
                <c:forEach var="fet" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                    <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                        <td class="checkbox">
                            <input type="checkbox" name="paramp" value="${fet.funcId}" />
                        </td>
                        <td>${fet.funcId}</td>
                        <td>${fet.funcSubCode}</td>
                        <td>${fet.funcSubName}</td>
                        <td>${fet.funcSubUrl}</td>
                        <td>
                            <a class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"
                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncRelationshipActor' type='crypto'/>&actions=<sc:fmt value='deleteSysFuncRelationship' type='crypto'/>&funcId=${fet.funcId}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" rel="page_relationship_ctt" targetType="navTab" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div>   
<script>

function reloadGrantDl() {
	$("#relationship_queryBtn", navTab.getCurrentPanel()).click();
	return true;
}
</script>