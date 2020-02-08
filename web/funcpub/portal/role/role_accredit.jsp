<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 将角色 授权用户
 * description: 
 *     1.将角色 授权用户
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160624 优化布局
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return dialogSearch(this);" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='queryUngrantRoleUser' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/role/role_accredit.jsp' />" />
	  	<sc:hidden name="selected" value="${jrafrpu.rspPkg.rspDataMap.selected}"/> 
		
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
        
		<div class="searchBar">
			<sc:hidden name="roleid"/>
			<sc:hidden name="pageNum"/>
			
			<table class="searchContent">
			    <tr>
					<td class="form-label">用户名称</td>
					<td class="form-value"><sc:text name="username" /></td>
					<td class="form-label">机构名称</td>
					<td class="form-value">
					<sc:hidden name="deptID" /> 
					<sc:text name="deptname" readonly="true" /> 
					<a class="btnLook" title="选择机构"  lookupGroup="" width="900" height="500"
                            href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=deptID&lookupname=deptname"></a>
					</td>
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
<div class="pageContent" >
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="btnNormal" rel="paramp" targetType="dialog" target="selectedTodo" title="确定要授权所选记录吗?" callback="reloadUngrantD2"
    			   href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='grantRoleUser' type='crypto'/>&roleid=<c:out value="${param.roleid }"/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" >
                <span>选择确认</span>
                </a>
            </li>
			<li class="line">line</li>
		</ul>
	</div>
    <table id="ungrant_table"  class="table" cellpadding="0" cellspacing="0" >
			<thead>
				<tr>
					<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
					<th>用户编号</th>
					<th>用户名称</th>
					<th>所在机构</th>
				</tr>
			</thead>
			<tbody>
            <c:choose>
                <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                    <tr>
                        <td class="empty" colspan="4">查询无数据。</td>
                    </tr>
                </c:when>
                <c:otherwise>
    				<c:forEach var="user" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
    					<tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if> >
    						<td class="checkbox"><input type="checkbox"  name="paramp" value="${user.userid}"/></td>
    						<td>${user.usercode}</td>
    						<td>${user.username}</td>
    						<td>${user.deptname}</td>
    					</tr>
    				</c:forEach>
                </c:otherwise>
            </c:choose>
			</tbody>
		</table>
	
	<div class="panelBar">
		<div rel=""  class="pagination" targetType="dialog" 
			totalCount="${jrafrpu.rspPkg.rspRecordCount}" 
			numPerPage="${jrafrpu.rspPkg.rspPageSize }" 
			currentPage="${jrafrpu.rspPkg.rspPageNo}">
		</div>
	</div>	
</div>

<script type="text/javascript">
function reloadUngrantD2() {
	$("form",$.pdialog.getCurrent()).submit();
    return true;
}
</script>

