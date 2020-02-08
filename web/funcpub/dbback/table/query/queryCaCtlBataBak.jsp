<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 表备份登记管理
 * description: 
 *     1.表备份登记管理
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
	<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this);"  method="post" 
            action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='MysqlBackupsTableManage' type='crypto'/>&actions=<sc:fmt value='queryCaCtlDataBak' type='crypto'/>&forward=<sc:fmt value='/funcpub/dbback/table/query/queryCaCtlBataBak.jsp' type='crypto'/>">
    	<input type="hidden" name="pageNum" value="1" />
    	<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
    	<div class="searchBar">
    		<table class="searchContent" cellpadding="0" cellspacing="0" >
    		    <tr>
    			    <td class="form-label">表名 </td>
    			    <td class="form-value"><sc:text name="tableName1" /></td>
    			    <td class="form-label">表中文名 </td>
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
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="/funcpub/dbback/table/query/addCaCtlDataBak.jsp" rel="queryCaCtlBataBak" height="330" width="500" target="dialog"><span>新增</span></a></li>
            <li><a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='MysqlBackupsTableManage' type='crypto'/>&actions=<sc:fmt value='delCaCtlDataBak' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>
			<li><a class="import" rel="paramp" target="selectedTodo" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='MysqlBackupsTableManage' type='crypto'/>&actions=<sc:fmt value='backCaCtlDataBak' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>备份</span></a></li>
        </ul>
	</div>	
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th width="10%">表名</th>
				<th width="15%">表中文名</th>
				<th>对应语句</th>
				<th>是否备份</th>
				<th width="20%">操作</th>
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
    			<c:forEach var="bak" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
    				<tr <c:if test="${Index.index%2 != 0}"> class="evenrow"</c:if> >
    					<td class="checkbox"><input type="checkbox"  name="paramp" value="${bak.tableName}"/></td>
    					<td>${bak.tableName}</td>
    					<td>${bak.tableInfo}</td>
    					<td>${bak.bakCond}</td>
    					<td><sc:optd name="bakFlag" type="dict" key="pcmc,boolen" value="${bak.bakFlag}"  /></td>
    					<td>
    						<a  class="btnEdit" rel="queryCaCtlBataBak" height="330" width="500" target="dialog" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='MysqlBackupsTableManage' type='crypto'/>&actions=<sc:fmt value='queryCaCtlDataBak' type='crypto'/>&tableName=${bak.tableName}&ad=1&forward=<sc:fmt value='/funcpub/dbback/table/query/addCaCtlDataBak.jsp' type='crypto'/>" >修改</a>
    						<a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='MysqlBackupsTableManage' type='crypto'/>&actions=<sc:fmt value='delCaCtlDataBak' type='crypto'/>&paramp=${bak.tableName}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
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
