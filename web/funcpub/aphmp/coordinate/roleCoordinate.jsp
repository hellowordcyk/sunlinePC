<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--规范：每个页面前必需增加注释。1）说明主要功能；2）主要功能修改日志 --%>
<%--
 * title: 角色首页功能配置
 * description: 
 *     1.角色首页功能配置
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
 <script>
function exportAphmp(){
	var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-roleFunc' type='crypto'/>&actions=<sc:fmt value='aphmp_export' type='crypto'/>";
	url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
	location.href = url;
}
</script>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this);" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='aphmp-roleFunc' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='getRoleFuncPage' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/aphmp/coordinate/roleCoordinate.jsp' />" />
		<input type="hidden" name="pageNum" value="1" />
		 <%-- 规范： 初始化查询必加隐藏表单 --%>
         <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">角色名称</td>
					<td class="form-value"><sc:text name="roleName" /></td>
					<td class="form-label">菜单名称</td>
					<td class="form-value"><sc:text name="functionName" /></td>
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
   		   <li>
               <a  class="add"  title="新增配置" target="dialog" width="680" height="392" minable="false" maxable="false" mask="true" rel="addKpiValueI"
    			href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-roleFunc' type='crypto'/>&actions=<sc:fmt value='getRoleFunction' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/aphmp/coordinate/addRoleFunc.jsp' />&roleid=${role.roleid}"  ><span>新增</span></a>
			</li>
			<li>
            	<a class="import" target="dialog" rel="importExcel" 
            		width="600" height="300" minable="false" maxable="false" mask="true" resizable="false" drawable="false"
            		href="/funcpub/aphmp/coordinate/roleFunc_import.jsp" >
            		<span>导入Excel</span>
            	</a>
            </li>
			<li><a class="exportExcel" href="#" onclick="exportAphmp()"><span>导出Excel</span></a></li>
            <li><a class="delete" rel="ids" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-roleFunc' type='crypto'/>&actions=<sc:fmt value='deleteRoleFunc' type='crypto'/>&forward=<sc:fmt type='crypto' value='/jui/callMessage.jsp' />" ><span>删除</span></a></li>
		</ul>
	</div>
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="ids"/></th>
				<th width="10%">角色编号</th>
				<th>角色名称</th>
				<th>菜单名称</th>
				<th>配置类型</th>
				<th>操作</th>
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
    			<c:forEach var="role" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
    				<tr target="roleid" rel="${role.roleid}" <c:if test="${Index.index%2 != 0}"> class="evenrow"</c:if> >
    					<td class="checkbox"><input type="checkbox" name="ids" value="${role.registertype}-${role.id}"/></td>
    					<td align="center">${role.roleid}</td>
    					<td align="center">${role.rolename}</td>
    					<td align="center">${role.functionname}</td>
    					<td align="center"><sc:optd value="${role.registertype}" default="1" index="1" type="dict" key="pcmc,registerType"/></td>
    					<td align="center">
    						<a  class="btnEdit" rel="QueryCaCtlDataClear" target="dialog" 
    								href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-roleFunc' type='crypto'/>&actions=<sc:fmt value='getRoleFuncDetail' type='crypto'/>&ids=${role.registertype}-${role.id}&roleid=${role.roleid}&forward=<sc:fmt value='/funcpub/aphmp/coordinate/updateRoleFunc.jsp' type='crypto'/>" 
    								height="392" width="680" >修改</a>
    								
    						<a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"  
    							href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-roleFunc' type='crypto'/>&actions=<sc:fmt value='deleteRoleFunc' type='crypto'/>&ids=${role.registertype}-${role.id}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
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
</body>
</html>
<script>
function addRoleFunction(roleid){
	var url = "/xmlprocesserservlet"
			+ "?sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
			+ "&oprID="+'<sc:fmt value='aphmp-functionRegister' type='crypto'/>'
			+ "&actions="+'<sc:fmt value='checkRoleCoordinate' type='crypto'/>'
			+ "&roleid="+roleid;
	$.ajax({    
        type:'post',        
        url:url,
        async:false,   
        dataType:'XML', 
        success:function(data){   
        	var msg = $(data).find("msg").text();
        	if(msg == "success"){
        		$.pdialog.open("/funcpub/aphmp/roleFunction.jsp?roleID="+roleid,"addRoleFunction","角色首页功能配置",{width:800,height:500,mask:true,minable:false,maxable:false});
        	}else{
        		alertMsg.error(msg);
        	}
        }    
    });    
}
</script>
