<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<div class="pageHeader">
    <form id="pagerForm" onsubmit="return navTabSearch(this)"  method="post" action="/httpprocesserservlet">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='getPcmcUserDeptList' type='crypto'/>"/>
        <input type="hidden" name="forward" value="<sc:fmt value='/funcpub/portal/userpriv/user_priv.jsp' type='crypto'/>"/>
        
        <input type="hidden" name="pageNum" value="1" />
		<sc:hidden name="lookupcode" value="usercode" />
		<sc:hidden name="lookupname" value="username" />
		
		<sc:hidden name="jraf_initsubmit"/>
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0" >
                <tr>
                   <td class="form-label">机构编码/名称</td>
					<td class="form-value">
					   <sc:text name="deptname"/>
					</td>
					<td class="form-label">用户编码/名称</td>
                    <td class="form-value"><sc:text name="username" /></td>
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
        </div>
    </form>
</div>
<div class="pageContent">
    <table class="table" cellpadding="0" cellspacing="0"  >
    <thead>
        <tr>
            <th width="22%">用户编码/名称</th>
            <th>机构编码/名称</th>
            <th width="10%">操作</th>
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
                <c:forEach var="u" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
                    <tr <c:if test="${Index.index%2 != 0}"> class="evenrow" </c:if>>
                        <td>[${u.usercode}]&nbsp;${u.username}</td>
                        <td>[${u.deptcode}]&nbsp;${u.deptname}</td>
                        <td>
                          	<a id="user_priv_tab"
								href="/funcpub/portal/userpriv/grantResource.jsp?userid=${u.userid}"
								target="navTab" rel="user_priv_tab"> <span>资源授权</span>
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
		totalCount="${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}"
            numPerPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
            currentPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}"></div>
</div>
</div>
