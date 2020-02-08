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
 <script>
function exportPrivEntity(){
	var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='privEntityActor' type='crypto'/>&actions=<sc:fmt value='privEntity_export' type='crypto'/>";
	url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
	location.href = url;
}
</script>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this)" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='privEntityActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='querySysPrivEntity' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/privilege/syspriventity/priv_entity_main.jsp' />" />
			<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">实体名称</td>
				    <td class="form-value"><sc:text name="entityName" /></td>
				    <td class="form-label">子系统</td>
				    <td class="form-value">
				    	<sc:select name="systemCode" type="subsyscd" nullOption="--请选择--" />
				    </td>
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
                <a class="add" href="/funcpub/privilege/syspriventity/priv_entity_add.jsp" height="500" width="750"
                    target="dialog" rel="priv_entity_add">
                    <span>新增</span>
                </a>
            </li>
            <li>
            	<a class="import" target="dialog" rel="importExcel" 
            		width="600" height="300" minable="false" maxable="false" mask="true" resizable="false" drawable="false"
            		href="/funcpub/privilege/syspriventity/privEntity_import.jsp" >
            		<span>导入Excel</span>
            	</a>
            </li>
            <li><a class="exportExcel" href="#" onclick="exportPrivEntity()"><span>导出Excel</span></a></li>
            <li>
                <a class="delete" rel="entity_id" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='privEntityActor' type='crypto'/>&actions=<sc:fmt value='deleteSysPrivEntity' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="entity_id" /></th>
				<th width="20%">实体编码</th>
				<th width="30%">实体名称</th>
				<th >数据库实体表</th>
				<th width="10%">数据拥有者字段</th>
				<th width="10%">数据部门字段</th>
				<th>所属子系统</th>
				<th width="10%">操作</th>
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="8">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="entity" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                    <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                        <td class="checkbox">
                            <input type="checkbox" name="entity_id"
                                value="${entity.entityCode}#${entity.systemCode}" />
                        </td>
                        <td>${entity.entityCode }</td>
                        <td>${entity.entityName}</td>
                        <td>${entity.dbTable}</td>
                        <td>${entity.dbColumnOwner}</td>
                        <td>${entity.dbColumnDept}</td>
                        <td>
                        	<sc:optd name="systemCode" type="subsyscd" index="1" value="${entity.systemCode }"/>
                        </td>
                        <td>
                            <a class="btnEdit" rel="priv_entity_update" target="dialog"
                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='privEntityActor' type='crypto'/>&actions=<sc:fmt value='querySysPrivEntity' type='crypto'/>&entityCode=${entity.entityCode}&systemCode=${entity.systemCode }&forward=<sc:fmt value='/funcpub/privilege/syspriventity/priv_entity_update.jsp' type='crypto'/>"
                                height="500" width="750">修改 </a>
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
