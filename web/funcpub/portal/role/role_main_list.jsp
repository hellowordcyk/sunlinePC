<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 角色管理列表
 * description: 
 * author: WengZhiYong
 * createtime: 2015-05-01 10:30
 * logs:
 *     edited by Sean on 20160530 优化布局
 *--%>
<table class="table" cellpadding="0" cellspacing="0" >
    <thead>
        <tr>
            <%-- 规范：设置表格列宽度， 保证一个td列不设置宽度表示自动计算为100%剩余宽度--%>
            <th class="checkbox"><input class="checkboxCtrl" type="checkbox" group="paramp" /></th>
            <th width="20%">所属系统</th>
            <th>角色名称</th>
            <th width="30%">角色说明</th>
            <th width="10%">权限分组</th>
            <th width="15%">操作</th>
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
        <c:forEach var="role" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
            <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                <td class="checkbox">
                    <%-- 子系统管理员和 超级管理员 不能被删除 --%>
                    <c:if test="${role.roletp!=2&&role.roletp!=3}">
                        <input type="checkbox" name="paramp" value="${role.roleid}"/>
                    </c:if>
                </td>
                <td>${role.cnname}</td>
                <td>${role.rolename}</td>
                <td>${role.remark }</td>
                <td><sc:optd name="roletype" type="dict" key="pcmc,roletp" value="${role.roletp }" /></td>
                <td>
                     <%-- 规范：a标签属性顺序：class->target->rel->title->width->height->其他->href（地址单独一行）
                    <c:if test="${role.roletp!=2&&role.roletp!=3}">
                        <a class="btnEdit" target="dialog" rel="post_update" title="修改角色" width="500" height="330"
                            href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='queryRole' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/portal/role/role_update.jsp' />&roleid=${role.roleid}">
                            <span>修改</span>
                        </a>
                    </c:if>
                     --%>
                    <%--
	                    <a class="btnKey" target="dialog" rel="rolegrant" title="授权用户-${role.rolename}" width="850" height="550" fresh="true" 
	                       href="/funcpub/portal/role/role_accredit_main.jsp?roleid=${role.roleid}">
	                       <span>授权用户</span>
	                    </a>  
	                    <a class="btnKey" target="dialog" rel="menugrant" title="授权菜单" width="600" height="400"
	                       href="/funcpub/portal/role/role_menu.jsp?roleid=${role.roleid}&roletp=${role.roletp}">
	                       <span>授权菜单</span>
	                    </a>
	                    <a class="btnKey" target="dialog" rel="grantResource" title="授权资源" width="1000" height="520" 
	                       href="/funcpub/privilege/role/grantResource.jsp?roleid=${role.roleid}">
	                       <span>授权资源</span>
	                    </a> 
                     --%>
                    <a class="btnSet" target="navTab" rel="privManager" title="角色管理-${role.rolename }" 
                       href="/funcpub/portal/role/grant_box.jsp?roleId=${role.roleid}">
                       <span>设置</span>
                    </a>
                </td>
            </tr>
        </c:forEach>
      </c:otherwise>
    </c:choose>
    </tbody>
</table>
<div class="panelBar">
    <div class="pagination"
        totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
        numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
        currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
    </div>
</div>
