<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 首页管理
 * description: 
 *     1. 首页管理
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<script>
function exportFunctionRegister(){
	var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-functionRegister' type='crypto'/>&actions=<sc:fmt value='functionRegister_export' type='crypto'/>";
	url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
	location.href = url;
}
</script>
<div class="pageHeader">
	<form  id="pagerForm" onsubmit="return navTabSearch(this);" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='aphmp-functionRegister' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='getFunctionRegisterList' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/aphmp/register/functionRegisterList.jsp' />"  />
		<input type="hidden" name="pageNum" value="1"  />
		  <%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">功能名称</td>
					<td class="form-value"><sc:text name="functionName"     /></td>
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
			<li><a class="add" href="/funcpub/aphmp/register/addFunctionRegister.jsp" height="400" width="600" target="dialog" rel="addFunctionRegister"><span>新增</span></a></li>
			<li>
            	<a class="import" target="dialog" rel="importExcel" 
            		width="600" height="300" minable="false" maxable="false" mask="true" resizable="false" drawable="false"
            		href="/funcpub/aphmp/register/functionRegister_import.jsp" >
            		<span>导入Excel</span>
            	</a>
            </li>
			<li><a class="exportExcel" href="#" onclick="exportFunctionRegister()"><span>导出Excel</span></a></li>
			<li><a class="delete" rel="functionId" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-functionRegister' type='crypto'/>&actions=<sc:fmt value='delFunctionRegister' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>
		</ul>
	</div>	
	<table class="table list" width="100%" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="functionId" /></th>
				<th>功能编号</th>
				<th>功能名称</th>
				<th>功能地址</th>
				<th>功能参数</th>
				<th>描述</th>
				<th width="15%">操作</th>
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
    			<c:forEach var="function" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
    				<tr <c:if test="${Index.index%2 != 0}"> class="evenrow"</c:if> >
    					<td class="checkbox"><input type="checkbox" name="functionId" value="${function.function_id}"/></td>
    					<td>${function.function_id}</td>
    					<td>${function.function_name}</td>
    					<td>${function.function_url}</td>
    					<td>${function.function_params}</td>
    					<td>${function.describe}</td>
    					<td>
    						<a  class="btnEdit"  rel="updateFunctionRegister"  target="dialog" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-functionRegister' type='crypto'/>&actions=<sc:fmt value='getFunctionRegisterById' type='crypto'/>&functionId=${function.function_id}&forward=<sc:fmt value='/funcpub/aphmp/register/updateFunctionRegister.jsp' type='crypto'/>" height="400" width="600" >修改</a>
    						<a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo" 
                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-functionRegister' type='crypto'/>&actions=<sc:fmt value='delFunctionRegister' type='crypto'/>&functionId=${function.function_id}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
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
