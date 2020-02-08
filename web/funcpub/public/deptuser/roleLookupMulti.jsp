<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 角色页面，多选
 * description: 
 *     1.角色页面，多选
 * author: 
 * createtime: 
 * logs:
 *     edited by lixutong on 20180321 优化布局
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return dialogSearch(this);" action="/httpprocesserservlet"
	  method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='getPcmcRoleList' type='crypto'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/public/deptuser/roleLookupMulti.jsp' />"/>
		<input type="hidden" name="pageNum" value="1" />
		<sc:hidden name="lookupcode" index="1" default="lookupcode"/>
		<sc:hidden name="lookupname" index="1"  default="lookupname"/>
		<sc:hidden name="lookupid" index="1"  default="lookupid"/>
		<sc:hidden name="lookuptype" index="1"  default="${param.lookuptype}"/>
	    <sc:hidden name="jraf_initsubmit" />
	   
		<div class="searchBar">
			<table class="searchContent" width="100%">
				<tr>	
					<td class="form-label">角色编码/名称</td>
					<td class="form-value"><sc:text name="${param.lookupname}" /></td>
					<td></td>
					<td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <button id="selectChildUserBtn" class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button type="button" class="button" multLookup="checkboxgroup" warn="请选择机构">选择带回</button>
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
	<table class="table" width="100%" layoutH="170" style="table-layout: fixed;">
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="checkboxgroup" /></th>
				<th width="22%">角色ID</th>
				<th width="22%">角色名称</th>
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
				<c:forEach var="u" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
					<tr <c:if test="${Index.index%2 != 0}"> class="evenrow" </c:if> >
						<td  class="checkbox">
						    <input type="checkbox" name="checkboxgroup" value="{${param.lookupcode}:'${u.roleid}', ${param.lookupname}:'${u.rolename}'}"/>
						</td>
						<td>${u.roleid}</td>
						<td>${u.rolename}</td>
					</tr>
				</c:forEach>
			</c:otherwise>
		</c:choose>
		</tbody>
	</table>
	<div class="panelBar">
	    <div class="pagination" targetType="dialog"
	        totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
	        numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
	        currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
	    </div>
	</div>
</div>