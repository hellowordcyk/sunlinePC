<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
    	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='loginLogActor'/>"/>
    	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='queryLoginLogList'/>"/>
    	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/log/login/loginLogList.jsp' />"/>
        
        <sc:hidden name="jraf_initsubmit" />
     	<div class="searchBar">
    		<table class="searchContent" cellpadding="0" cellspacing="0" >
    			<tr>
    				<td class="form-label">用户编码/名称</td>
    				<td class="form-value"><sc:text name="userCode" id="userCode" /></td>
    				<td class="form-label">开始日期</td>
    				<td class="form-value"><sc:date name="startDate"  maxDate="#endDate"  id="startDate" readonly="true" validate="required" default="$yesterday$"/></td>
    				<td class="form-label">结束日期</td>
    				<td class="form-value"><sc:date name="endDate" id="endDate" readonly="true" validate="required" 
    									 minDate="#startDate"    default="$today$"/></td>
    			</tr>
    			<tr>	
    				<td class="form-btn" colspan="6" style="text-align:center;">
                        <ul style="float:none;">
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
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th>登录时间</th>
				<th>登录用户</th>
				<th>登录状态</th>
				<th>IP地址</th>
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
    			<c:forEach var="loginLog" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
    				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
    					<td>
    						<sc:fmt value="${loginLog.logndt }" type="date" pattern="yyyy-MM-dd HH:mm:ss"/>
    					</td>
    					<td>${loginLog.userName }[${loginLog.userCode}]</td>
    					<td>
    						<c:if test="${loginLog.lognst == 0}">失败</c:if>
    						<c:if test="${loginLog.lognst == 1}">成功</c:if>
    					</td>
    					<td>${loginLog.lognip }</td>
    					<td>
    						<a  class="btnMore" rel="QueryCaCtlDataClear" target="navTab" 
    							href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='loginLogActor' type='crypto'/>&actions=<sc:fmt value='getLoginLogUserDetail' type='crypto'/>&userId=${loginLog.userId }&forward=<sc:fmt value='/funcpub/log/login/loginLogUserDetail.jsp' type='crypto'/>">
    							更多
    						</a>
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