<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:数据清理登记管理
 * description: 
 *     1.数据清理登记管理
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
	<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataClearTable' type='crypto'/>&actions=<sc:fmt value='queryCaCtlDataClear' type='crypto'/>&forward=<sc:fmt value='/funcpub/dataclear/table/query/QueryCaCtlDataClear.jsp' type='crypto'/>" method="post">
	<input type="hidden" name="pageNum" value="1" />
	<%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
        
	<div class="searchBar">
		<table class="searchContent" cellpadding="0" cellspacing="0">
		    <tr>
			    <td class="form-label">清理表名</td>
			    <td class="form-value"><sc:text name="tableName1" /></td>
			    <td class="form-label">清理表信息</td>
			    <td class="form-value"><sc:text name="tableInfo1"/></td>
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
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="/funcpub/dataclear/table/query/addCaCtlDataClear.jsp" height="400" width="800" target="dialog" mask="true"><span>新增</span></a></li>
            <li><a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataClearTable' type='crypto'/>&actions=<sc:fmt value='delCaCtlDataClear' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>
        </ul>
	</div>	
	<table class="table list" width="100%" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th>清理表名</th>
				<th>清理表信息</th>
				<th>清理类型</th>
				<th>清理顺序</th>
				<th>数据日期键</th>
				<th>保留天数</th>
				<th>清理状态</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
             <c:choose>
                <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                    <tr>
                        <td class="empty" colspan="9">查询无数据。</td>
                    </tr>
                </c:when>
                <c:otherwise>
        			<c:forEach var="TableClear" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="TableClearindex">
        				<tr <c:if test="${TableClearindex.index%2 != 0}"> class="evenrow"</c:if> >
        					<td class="checkbox"><input type="checkbox"  name="paramp" value="${TableClear.tableName}"/></td>
        					<td>${TableClear.tableName}</td>
        					<td>${TableClear.tableInfo}</td>
        					<td>
        					<sc:optd  name="clearType"  type="dict" key="pcmc,clearType" value="${TableClear.clearType}" /></td>
        					<td>${TableClear.validatorOrder}</td>
        					<td>${TableClear.dateKey}</td>
        					<td>${TableClear.keepDay}</td>
        					<td><sc:optd  name="status"  type="dict" key="pcmc,boolen" value="${TableClear.status}" /></td>
        					<td>
        						<a  class="btnEdit" rel="QueryCaCtlDataClear" target="dialog" 
        						  href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataClearTable' type='crypto'/>&actions=<sc:fmt value='queryCaCtlDataClear' type='crypto'/>&tableName=${TableClear.tableName}&forward=<sc:fmt value='/funcpub/dataclear/table/query/updateCaCtlDataClear.jsp' type='crypto'/>" height="500" width="800" >修改</a>
        						<a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo" rel="QueryCaCtlDataClear"
        						  href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataClearTable' type='crypto'/>&actions=<sc:fmt value='delCaCtlDataClear' type='crypto'/>&paramp=${TableClear.tableName}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
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
