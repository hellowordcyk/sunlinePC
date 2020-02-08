<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 功能页面管理
 * description: 
 *     1.维护（新增、修改、删除）岗位信息；
 * author: ZhaoXuePing
 * create time: 
 * logs:
 *--%>
 <script>
function exportSysFuncPage(){
	var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncPageActor' type='crypto'/>&actions=<sc:fmt value='sysFunc_export' type='crypto'/>";
	url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
	location.href = url;
}
</script>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this)" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='sysFuncPageActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='querySysFuncPage' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/func/page/sysFuncPage_main.jsp'/>" />
			<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<input type="hidden" name="pageNum" value="1" />
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">功能编号 </td>
				    <td class="form-value"><sc:text name="funcCode"/></td>
				    <td class="form-label">功能名称</td>
				    <td class="form-value"><sc:text name="funcName"/></td>
                    <td align="right">                      
	                    <button class="querybtn" jraf_initsubmit type="submit">查询</button>                            
	                    <button class="resetbtn" type="reset">清空</button>                         
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
                <a class="add" href="/funcpub/portal/func/page/sysFuncPage_add.jsp" height="400" width="600"
                    target="dialog" rel="funcPage_add">
                    <span>新增</span>
                </a>
            </li>
            <li>
            	<a class="import" target="dialog" rel="importExcel" 
            		width="600" height="300" minable="false" maxable="false" mask="true" resizable="false" drawable="false"
            		href="/funcpub/portal/func/page/sysFunc_import.jsp" >
            		<span>导入Excel</span>
            	</a>
            </li>
            <li><a class="exportExcel" href="#" onclick="exportSysFuncPage()"><span>导出Excel</span></a></li>
            <li>
                <a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncPageActor' type='crypto'/>&actions=<sc:fmt value='deleteSysFuncPages' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li>
                <a class="run" target="dialog" href="/funcpub/portal/func/page/sysFuncPage_init.jsp" 
                	 title="初始化系统功能页面" rel="" height="550" width="900" close="reloadTab">
                    <span>初始化系统功能页面</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th width="25%">编号</th>
				<th width="20%">名称</th>
				<th width="10%">是否菜单</th>
				<th width="20%">参数</th>
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
                <c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                    <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                        <td class="checkbox">
                            <input type="checkbox" name="paramp" value="${item.funcCode}" />
                        </td>
                        <td>${item.funcCode}</td>
                        <td>${item.funcName}</td>
                        <td>
                        	<sc:optd name="funcismenu" value="${item.funcIsMenu}" index="1" type="dict" key="pcmc,boolflag"/>
                        </td>
                        <td>${item.funcParam}</td>
                        <td>
                            <a class="btnSet" rel="pageManager" target="navTab" title="页面管理-${item.funcName}"
                                href="/funcpub/portal/func/page/sysFuncPage_box.jsp?funcCode=<c:out value='${item.funcCode}'/>">设置</a>
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

<script>
	function reloadTab() {
		$("button.querybtn", navTab.getCurrentPanel()).click();
		return true;
	}
</script>