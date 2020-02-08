<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:登录日志查询列表
 * description: 
 *     显示所有登录记录
 * author: hzx
 * createtime: 20160907
 * logs:
 *
 *--%>
<div class="pageHeader">
	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
    	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
    	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='menuLogActor'/>"/>
    	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='queryMenuVisitLog'/>"/>
    	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/log/menulog/menuLogList.jsp' />"/>
        
        <sc:hidden name="jraf_initsubmit" />
     	<div class="searchBar">
    		<table class="searchContent" cellpadding="0" cellspacing="0" >
    			<tr>
    				<td class="form-label">菜单名称</td>
    				<td class="form-value" ><sc:text name="qMenuName" id="qMenuName" index="1" /></td>
					<td class="form-label">开始日期</td>
    				<td class="form-value"><sc:date name="startDate" id="startDate" readonly="true" validate="required" maxDate="%y-%M-%d" default="$nintyDaysAgo$"/></td>
    				<td class="form-btn" rowspan="2">
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
    			<tr>
    				<td class="form-label">用户编码</td>
                    <td class="form-value">
                       <sc:text name="qUserCode" index="1"/>
                    </td>	
    				<td class="form-label">结束日期</td>
    				<td class="form-value"><sc:date name="endDate" id="endDate" readonly="true" validate="required" maxDate="%y-%M-%d"
    										attributesText="compareDate='#startDate,>'" default="$today$"/></td>
    			</tr>
    		</table>
    	</div>
	</form>
</div>
<div class="pageContent">
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th>菜单名称</th>
				<th>访问用户</th>
				<th>IP地址</th>
				<th>访问时间</th>
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
    			<c:forEach var="menuLog" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
    				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
    					<td>${menuLog.menuName }[${menuLog.menuId}]</td>
    					<td>${menuLog.userCode }</td>
    					<td>${menuLog.ip }</td>
    					<td>
                            <sc:fmt value="${menuLog.visitTime }" type="date" pattern="yyyy-MM-dd HH:mm:ss"/>
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