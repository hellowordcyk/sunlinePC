<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 区域管理
 * description: 
 *     1.区域管理
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160628 布局调整
 *--%>
<script>
function exportArea(){
	var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='SysPubArea' type='crypto'/>&actions=<sc:fmt value='area_export' type='crypto'/>";
	url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
	location.href = url;
}
</script>
<div class="pageHeader">
	<form id="pagerForm"  onsubmit="return navTabSearch(this);" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='SysPubArea' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='queryArea' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/para/area/area_main.jsp' />" />
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<input type="hidden" name="pageNum" value="1" />
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">区域编号</td>
				    <td class="form-value"><sc:text name="areaNo"/></td>
				    <td class="form-label">区域名称 </td>
				    <td class="form-value"><sc:text name="areaName"/></td>
				    <td align="right">
			            <button class="querybtn" jraf_initsubmit type="submit">查询</button>
			            <button class="resetbtn" type="reset">清空</button>
					</td>
			    </tr>
			</table>
	    </div>
	</form>
 </div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="/funcpub/portal/para/area/area_add.jsp" height="400" width="500" target="dialog" mask="true" minable="false" maxable="false"><span>新增</span></a></li>
            <li>
            	<a class="import" target="dialog" rel="importExcel" 
            		width="600" height="300" minable="false" maxable="false" mask="true" resizable="false" drawable="false"
            		href="/funcpub/portal/para/area/import_area.jsp" >
            		<span>导入Excel</span>
            	</a>
            </li>        
            <li><a class="exportExcel" href="#" onclick="exportArea()"><span>导出Excel</span></a></li>
            <li><a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='SysPubArea' type='crypto'/>&actions=<sc:fmt value='delArea' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>
        </ul>
	</div>	
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th>区域编号</th>
				<th>区域名称</th>
				<th>顺序号</th>
				<th>是否使用</th>
				<th>总行区域</th>
				<th>表空间</th>
				<th>区域机构</th>
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
				<c:forEach var="area" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
					<tr <c:if test="${Index.index%2 != 0}"> class="evenrow"</c:if> >
						<td class="checkbox"><input type="checkbox"  name="paramp" value="${area.areaNo}"/></td>
						<td>${area.areaNo}</td>
						<td>${area.areaName}</td>
						<td>${area.sortNum}</td>
						<td><sc:optd  name="hoFlag"  type="dict" key="pcmc,boolflag" index="${Index.count}"/></td>
						<td><sc:optd  name="hqFlag"  type="dict" key="pcmc,boolflag" index="${Index.count}"/></td>
						<td>${area.tabSpace}</td>
						<td>${area.orgStr}</td>
						<td>
							<a  class="btnEdit" rel="QueryCaCtlDataClear" target="dialog" 
							href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='SysPubArea' type='crypto'/>&actions=<sc:fmt value='queryArea' type='crypto'/>&areaNo=${area.areaNo}&forward=<sc:fmt value='/funcpub/portal/para/area/area_update.jsp' type='crypto'/>" height="400" width="500" mask="true" minable="false" maxable="false">修改
							</a>
							<a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo" 
							href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='SysPubArea' type='crypto'/>&actions=<sc:fmt value='delArea' type='crypto'/>&paramp=${area.areaNo}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
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