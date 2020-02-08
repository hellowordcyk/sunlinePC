<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 语言资源管理
 * description: 
 * author: daoge
 * createtime: 20170204
 * logs:
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this)" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='i18nActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='query' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/lang/i18n_main.jsp' />" />
			<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">资源编码</td>
				    <td class="form-value" colspan="3"><sc:text name="code" /></td>
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
                <tr>
                	<td class="form-label">语言</td>
				    <td class="form-value">
					    <sc:text name="langText" />
				    </td>
				    <td class="form-label">类型</td>
				    <td class="form-value">
					    <sc:select name="qType">
					    	<sc:option value="1">默认</sc:option>
					    	<sc:option value="2">英文</sc:option>
					    	<sc:option value="3">简体中文</sc:option>
					    	<sc:option value="4">繁体中文</sc:option>
					    </sc:select>
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
                <a class="add" href="/funcpub/lang/i18n_add.jsp" height="400" width="600"
                    target="dialog" rel="i18n_add">
                    <span>新增</span>
                </a>
            </li>
            <li>
                <a class="delete" group="code" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='i18nActor' type='crypto'/>&actions=<sc:fmt value='delete' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li>
                <a class="run" target="ajaxTodo" title="确定要刷新语言资源缓存吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='i18nActor' type='crypto'/>&actions=<sc:fmt value='refresh' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>刷新语言缓存</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox">
					<input type="checkbox" class="checkboxCtrl" group="code" />
				</th>
				<th width="20%">资源编码</th>
				<th width="20%">默认值</th>
				<th >简体中文</th>
				<th >繁体中文</th>
				<th >英文(美国)</th>
				<th width="10%">操作</th>
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="7">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="i18n" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                    <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                        <td class="checkbox">
                            <input type="checkbox" name="code" 
                                value="${i18n.code}" />
                        </td>
                        <td>${i18n.code }</td>
                        <td>${i18n.langDefault}</td>
                        <td>${i18n.langZHCN}</td>
                        <td>${i18n.langZHTW}</td>
                        <td>${i18n.langENUS}</td>
                        <td>
                            <a class="btnEdit" rel="i18n_update" target="dialog"
                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='i18nActor' type='crypto'/>&actions=<sc:fmt value='query' type='crypto'/>&code=${i18n.code}&forward=<sc:fmt value='/funcpub/lang/i18n_update.jsp' type='crypto'/>"
                                height="400" width="600">修改 </a>
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
