<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 岗位管理
 * description: 
 *     1.维护（新增、修改、删除）岗位信息；
 * author:
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this)" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='PostMain' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='queryPost' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/post/post_main.jsp' />" />
			<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<input type="hidden" name="pageNum" value="1" />
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">岗位编号 </td>
				    <td class="form-value"><sc:text name="postNo"/></td>
				    <td class="form-label">岗位名称</td>
				    <td class="form-value"><sc:text name="postName"/></td>
                    <td class="form-btn">
                        <ul>
                            <li>
                                <button class="querybtn" jraf_initsubmit type="submit">查询</button>
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
<div class="pageContent" >
    <div class="panelBar">
        <ul class="toolBar">
            <li>
                <a class="add" href="/funcpub/portal/post/post_add.jsp" height="300" width="500"
                    target="dialog" rel="post_add">
                    <span>新增</span>
                </a>
            </li>
            <li>
                <a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PostMain' type='crypto'/>&actions=<sc:fmt value='delPost' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th width="10%">岗位编号</th>
				<th width="40%">岗位名称</th>
				<th width="10%">排序</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="5">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="post" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                    <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                        <td class="checkbox">
                            <input type="checkbox" name="paramp"
                                value="${post.paracd}" />
                        </td>
                        <td>${post.paracd}</td>
                        <td>${post.parana}</td>
                        <td>${post.sortno}</td>
                        <td>
                            <a class="btnEdit" rel="post_update" target="dialog"
                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PostMain' type='crypto'/>&actions=<sc:fmt value='queryPost' type='crypto'/>&postNo=${post.paracd}&forward=<sc:fmt value='/funcpub/portal/post/post_update.jsp' type='crypto'/>"
                                height="300" width="500">修改 </a>
                            <a class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"
                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PostMain' type='crypto'/>&actions=<sc:fmt value='delPost' type='crypto'/>&paramp=${post.paracd}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="navTab" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div>   
