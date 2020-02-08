<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 角色选择带回，多选
 * description: 
 *     1. 角色选择带回，多选
 * author: longjian
 * createtime: 20160719
 *--%>
<%-- <div class="pageHeader">                                                                                                                                                                                                                                              
	<form id="pagerForm"  onsubmit="return dialogSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='queryRole' type='crypto'/>&forward=/funcpub/portal/role/role_bringback_muitl.jsp" method="post">
		<input type="hidden" name="pageNum" value="1" />
		<!-- 丢失参数，需要input  hidden 增加 edit by longjian 20160615 night-->
		<input type="hidden" name="lookupid" value="${param.lookupid }"/>
		<input type="hidden" name="lookupname" value="${param.lookupname }"/>
		规范： 初始化查询必加隐藏表单
        <sc:hidden name="jraf_initsubmit"/>
    
		<div class="searchBar">
			<table class="searchContent" width="100%">
			    <tr>
				    <td align="right">子系统</td>
				    <td><sc:select name="subsys"  type="subsys"  nullOption ="--所有子系统--" validate="required"/></td>
				    <td align="right">角色名称 </td>
				    <td colspan="2"><sc:text name="rolename"/></td> 
				    <td align="right"><input type="submit"   jraf_initsubmit  class="button" value="查询"/></td>
			    </tr>
		    </table>
	    </div>
	</form>
</div> --%>
<div class="pageContent">
    <div class="pageFormContent">
        <table class="form-table" cellpadding="0" cellspacing="0">
            <tr>
                <td class="form-label" style="width: 100px;">已拥有角色</td>
                <td>
                    <sc:doPost scope="request" var="grantPkgObj" sysName="funcpub" oprId="PcmcRole" action="queryGrantRole" all="true"/>
                    <c:if test="${empty grantPkgObj.rspRcdDataMaps}">无.</c:if>
                    <c:forEach var="role" items="${grantPkgObj.rspRcdDataMaps}" varStatus="status">
                        <%-- <sc:dcheckbox attributesText="checked='checked'" name="roleitem" sysName="funcpub"
                            oprID="PcmcRole" actions="queryGrantRole" nameField="roleid"
                            valueField="rolename" params="userid=${param.userid}" /> --%>
                        <span style="width: 200px; padding: 2px 5px 2px 0; display: inline-block; overflow: hidden; white-space: nowrap;" title="${role.rolename}">
                            <label for="roleitem_${status.index }"> 
                                <%--isnull判断待授权用户的当前角色是否在登录用户所拥有的角色中 --%>                           
                                <c:if test="${not empty role.isnull}">
                                    <input type="checkbox" checked="checked" id="roleitem_${status.index }" name="roleitem" value="{${param.lookupid}:'${role.roleid}', ${param.lookupname}:'${role.rolename}'}"/>
                                    ${role.rolename}
                                </c:if>
                                <c:if test="${empty role.isnull}">
                                    <input type="checkbox" checked="checked" disabled="disabled" id="roleitem_${status.index }" />
                                    <input type="hidden" name="roleitem" value="{${param.lookupid}:'${role.roleid}', ${param.lookupname}:'${role.rolename}'}"/>
                                    <span style="color: gray;">${role.rolename}</span>
                                </c:if>
                            </label>
                        </span>
                        <c:if test="${status.count %4==0}"><br/></c:if>
                    </c:forEach>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 5px; padding: 0;">
                    <hr style="width: 90%;"/>
                </td>
            </tr>
            <tr>
                <td class="form-label">可分配角色</td>
                <td>
                    <sc:doPost scope="request" var="grantPkgObj" sysName="funcpub" oprId="PcmcRole" action="queryUngrantRole" all="true"/>
                    <c:if test="${empty grantPkgObj.rspRcdDataMaps}">无.</c:if>
                    <c:forEach var="role" items="${grantPkgObj.rspRcdDataMaps}" varStatus="status">
                        <%-- <sc:dcheckbox attributesText="checked='checked'" name="roleitem" sysName="funcpub"
                            oprID="PcmcRole" actions="queryGrantRole" nameField="roleid"
                            valueField="rolename" params="userid=${param.userid}" /> --%>
                        <span style="width: 200px; padding: 2px 5px 2px 0; display: inline-block; overflow: hidden; white-space: nowrap;" title="${role.rolename}">
                            <label for="roleitem_un_${status.index }">
                                <input type="checkbox" id="roleitem_un_${status.index }" name="roleitem" value="{${param.lookupid}:'${role.roleid}', ${param.lookupname}:'${role.rolename}'}"/>
                                ${role.rolename}
                            </label>
                        </span>
                         <c:if test="${status.count %4==0}"><br/></c:if>
                    </c:forEach>
                    <%-- <sc:dcheckbox name="roleitem" sysName="funcpub" oprID="PcmcRole"
                        actions="queryUngrantRole" nameField="roleid" valueField="rolename"
                        params="userid=${param.userid}" /> --%>
                </td>
            </tr>
        </table>
    </div>
    <%-- <table class="table list" width="100%" >
		<thead>
			<tr>
			    <th class="checkbox">
			        <input type="checkbox" class="checkboxCtrl" group="roleitem"/> 
			    </th>
				<th>角色编号</th>
				<th>角色名称</th>
				<th>所属系统</th>
				<th>所属类型</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="role" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
				<tr >
				    <td class="checkbox"><input type="checkbox" name="roleitem" value="{${param.lookupid}:'${role.roleid}', ${param.lookupname}:'${role.rolename}'}"/></td>
					<td align="center">${role.roleid}</td>
					<td align="center">${role.rolename}</td>
					<td align="center">${role.cnname}</td>
					<td align="center"><sc:optd name="roletype" type="dict" key="pcmc,roletp" value="${role.roletp }" /></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="dialog" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div> --%>
</div>   
<div class="formBar">
    <ul>
        <li><button type="button" class="button" lookupGroup="" multLookup="roleitem" warn="请勾选角色">选择带回</button></li>
        <li><button class="close" type="button">取消</button></li>
    </ul>
</div>
