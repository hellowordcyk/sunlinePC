<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:用户解锁
 * description: 
 *     1.用户解锁
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<div class="pageHeader">
	<div class="pageContent">
		<div class="pageFormContent" >
			<table class="form-table" cellpadding="0" cellspacing="0">
				<tr>
                    <td class="form-label">用户编码</td>
                    <td class="form-value">
                        <sc:text name="userCode" readonly="true" value="${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].userCode}"/>
                    </td>
                      <td class="form-label">用户名称</td>
                    <td class="form-value">
                        <sc:text name="userName" readonly="true" value="${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].userName}"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">最近登录时间</td>
                    <td class="form-value">
                        <input type="text" name="lastdt" readonly="true" value="<sc:fmt value='${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].lastdt}' type='date' pattern='yyyy-MM-dd HH:mm:ss'/>"/>
                    </td>
                    <td class="form-label">最近登录ip</td>
                    <td class="form-value">
                       <sc:text name="lastip" readonly="true" value="${jrafrpu.rspPkg.rspRcdDataMapsResults2[0].lastip}"/>
                    </td>
                </tr>
               <tr>
                    <td class="form-label">登录总次数</td>
                    <td class="form-value">
                       <sc:text name="lognno" readonly="true" value="${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].lognno}"/>
                    </td>
                    <td class="form-label">当前状态</td>
                    <td class="form-value">
                    	<c:if test='${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].disable == 0}'>
                    		<sc:text name="disable" readonly="true" value="激活"/>
                    	</c:if>
    					<c:if test='${jrafrpu.rspPkg.rspRcdDataMapsResults1[0].disable == 1}'>
    						<sc:text name="disable" readonly="true" value="冻结"/>
    					</c:if>
                      
                    </td>
                </tr>
			</table>
		</div>
	</div>

	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
    	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
    	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='loginLogActor'/>"/>
    	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='getLoginLogUserDetail'/>"/>
    	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/log/login/loginLogUserDetail.jsp' />"/>
        
        <sc:hidden name="userId" index="1"/>
        
	</form>
</div>
<div class="pageContent">
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th>登录时间</th>
				<th>登录状态</th>
				<th>登录IP地址</th>
				<th>解锁用户</th>
				<th>解锁时间</th>
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
    			<c:forEach var="userLoginLog" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
    				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
    					<td>
    						<sc:fmt value="${userLoginLog.logndt}" type="date" pattern="yyyy-MM-dd HH:mm:ss"/>
    					</td>
    					<td>
    						<c:if test="${userLoginLog.lognst == 0}">失败</c:if>
    						<c:if test="${userLoginLog.lognst == 1}">成功</c:if>
    					</td>
    					<td>${userLoginLog.lognip }</td>
    					<td>${userLoginLog.ulokid }</td>
    					<td>
    						<sc:fmt value="${userLoginLog.uloktm}" type="date" pattern="yyyy-MM-dd HH:mm:ss"/>
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
</div>
