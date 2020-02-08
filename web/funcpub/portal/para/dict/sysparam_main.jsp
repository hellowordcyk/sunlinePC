<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 数据字典管理
 * description: 
 *     1.维护（新增、修改、删除）数据字典；
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 --%>
 <script>
function exportBdssParameter(){
	var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='exportSysParam' type='crypto'/>";
	url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
	location.href = url;
}
</script>
<div class="pageHeader">
    <form id="pagerForm" onsubmit="return navTabSearch(this);" method="post"
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='queryParamHeader' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/para/dict/sysparam_main.jsp' type='crypto'/>">
        <input type="hidden" name="paracd" value="%" />

        <sc:hidden name="jraf_initsubmit" />
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0" >
                <tr>
                    <td class="form-label">参数主类</td>
                    <td class="form-value">
                        <sc:text name="subscd1" />
                    </td>
                    <td class="form-label">参数次类</td>
                    <td class="form-value">
                        <sc:text name="paratp1" />
                    </td>
                    <td class="form-label">参数名称</td>
                    <td class="form-value">
                        <sc:text name="parana1" />
                    </td>
                    <td align="right">                    
	                     <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
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
            <li>
                <a class="add" href="/funcpub/portal/para/dict/sysparam_detail.jsp" height="300"
                    width="600" mask="true" target="dialog" rel="addSysParam">
                    <span>新增</span>
                </a>
            </li>
            <li>
            	<a class="import" target="dialog" rel="importExcel" 
            		width="600" height="300" minable="false" maxable="false" mask="true" resizable="false" drawable="false"
            		href="/funcpub/portal/para/dict/importSysParam.jsp" >
            		<span>导入Excel</span>
            	</a>
            </li>
            <li><a class="exportExcel" href="#" onclick="exportBdssParameter()"><span>导出Excel</span></a></li>
            <li>
                <a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='delSysParam' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li class="line">line</li>
            <li>
                <a class="run"  target="ajaxTodo" 
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='refreshData' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>刷新数据字典</span>
                </a>
            </li>
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0">
        <thead>
            <tr>
                <th class="checkbox">
                    <input type="checkbox" class="checkboxCtrl" group="paramp" />
                </th>
                <th width="10%">参数主类</th>
                <th width="15%">参数次类</th>
                <th width="40%">参数名称</th>
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
                    <c:forEach var="para" items="${jrafrpu.rspPkg.rspRcdDataMaps}"
                        varStatus="status">
                        <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if>>
                            <td class="checkbox">
                                <input type="checkbox" name="paramp"
                                    value="${para.subscd}-${para.paratp}" />
                            </td>
                            <td>${para.subscd}</td>
                            <td>${para.paratp}</td>
                            <td>
                                <a rel="sysparam_main" target="dialog" class="noiconbtn"
                                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='querySysParam1' type='crypto'/>&subscd=${para.subscd}&paratp=${para.paratp}&forward=<sc:fmt value='/funcpub/portal/para/dict/param_update.jsp' type='crypto'/>"
                                    height="700" width="1200">${para.parana} </a>
                            </td>
                            <td>
                                <a class="btnEdit" rel="QueryCaCtlDataClear" target="dialog"
                                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='queryParamHeader' type='crypto'/>&subscd1=${para.subscd}&paratp1=${para.paratp}&forward=<sc:fmt value='/funcpub/portal/para/dict/sysparam_update.jsp' type='crypto'/>"
                                    height="400" width="800">修改</a>

                                <a class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"                                                                          												   
                                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='delSysParam' type='crypto'/>&paramp=${para.subscd}-${para.paratp}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    <div class="panelBar">
        <div class="pagination" targetType="navTab"
            totalCount="${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}"
            numPerPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
            currentPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}"></div>
    </div>
</div>
