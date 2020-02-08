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
function exportOrganization(){
	var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='organizationActor' type='crypto'/>&actions=<sc:fmt value='organization_export' type='crypto'/>";
	url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
	location.href = url;
}
</script>
<div class="pageHeader">
	<form id="organization_divid_pagerForm" onsubmit="return divSearch(this,'organization_divid')" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='organizationActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='query' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/organization/organization_main_list.jsp' />" />
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">组织编码/名称</td>
				    <td class="form-value"><sc:text name="orgname" /></td>
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
                <a class="add" href="/funcpub/organization/organization_add.jsp" height="450" width="600"
                    target="dialog" rel="organization_add">
                    <span>新增</span>
                </a>
            </li>
            <li>
            	<a class="import" target="dialog" rel="importExcel" 
            		width="600" height="300" minable="false" maxable="false" mask="true" resizable="false" drawable="false"
            		href="/funcpub/organization/organization_import.jsp" >
            		<span>导入Excel</span>
            	</a>
            </li>
            <li><a class="exportExcel" href="#" onclick="exportOrganization()"><span>导出Excel</span></a></li>
            <li>
                <a class="delete" group="orgcode" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='organizationActor' type='crypto'/>&actions=<sc:fmt value='delete' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
    </div>
    <div class="" id="organization_divid" >
	
	</div>
</div>   
