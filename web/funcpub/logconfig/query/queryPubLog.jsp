<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 公共日志查询
 * description: 
 *     1.公共日志查询
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<div class="pageHeader">
	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='funcpub-logconfig'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='queryPubLogs'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/logconfig/query/queryPubLog.jsp' />"/>
 	
    <sc:hidden name="jraf_initsubmit"/>
    
    <div class="searchBar">
		<table class="searchContent" cellpadding="0" cellspacing="0">
			<tr>
				<td align="right">子系统标识</td>
				<td><sc:text name="syscd" /></td>
				<td align="right">操作模块编码</td>
				<td><sc:text name="sysoperid" /></td>
                <td class="form-btn" rowspan="2">
                    <ul>
                        <li>
                            <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                            <button class="querybtn" jraf_initsubmit type="submit">查询</button>
                        </li>
                        <li>
                            <button class="resetbtn" type="reset">清空</button>
                        </li>
                    </ul>
                </td>
            </tr>
            <tr>
				<td align="right">操作模块方法</td>
				<td><sc:text name="sysaction" /></td>
				<td align="right">功能描述</td>
				<td colspan="4"><sc:text name="modname" /></td>
			</tr>
		</table>
	</div>
	</form>
</div>
<div class="pageContent">
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th>系统名称</th>
				<th>模块描述</th>
				<th>操作描述</th>
				<th>操作用户</th>
				<th>操作IP</th>
				<th>操作时间</th>
				<th>操作类别</th>
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="8">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
    			<c:forEach var="log" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
    				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
    					<td>[${log.syscd }]${log.sysname }</td>
    					<td>[${log.sysoperid }]${log.operdesc }</td>
    					<td>[${log.sysaction }]${log.modname }</td>
    					<td>${log.usercode }</td>
    					<td>${log.ipaddr }</td>
    					<td>${log.createdt }</td>
    					<td>${log.opertype }</td>
    				</tr>
    			</c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="navTab" 
			totalCount="${jrafrpu.rspPkg.rspRecordCount }" 
			numPerPage="${jrafrpu.rspPkg.rspPageSize }" 
			currentPage="${jrafrpu.rspPkg.rspPageNo }">
		</div>
	</div>
</div>
