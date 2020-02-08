<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 机构下人员信息
 * description: 
 *     1.  机构下人员信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<div class="pageHeader">
    <form id="pagerForm" action="/httpprocesserservlet" onsubmit="return divSearch(this, 'deptManagerBox3');" method="post">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
        <input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>" />
        <input type="hidden" name="actions" value="<sc:fmt value='getUserByDeptid' type='crypto'/>" />
        <input type="hidden" name="forward"  value="<sc:fmt type='crypto' value='/funcpub/portal/userpriv/childUser.jsp' />" />
        <input type="hidden" name="pageNum" value="1" />
        <%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit" />
        <sc:hidden name="deptid" />
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">用户代码/名称</td>
                    <td class="form-value">
                        <sc:text name="looks.usercodeOrName" index="1" />
                    </td>
                    <td class="form-label">机构层级</td>
                    <td class="form-value">
                        <select name="all" class="combox">
                            <c:choose>
                                <c:when test="${param.all eq '0' }">
                                    <option value="1">所有</option>
                                    <option value="0" selected="true">直属</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="1" selected="true">所有</option>
                                    <option value="0">直属</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </td>
                    <td class="form-btn">
                        <ul>
                            <li>
                                <button class="querybtn" id="selectChildUserBtn" jraf_initsubmit
                                    type="submit">查询</button>
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
    <table class="table" cellpadding="0" cellspacing="0">
        <thead>
            <tr>
                <th>用户编码/名称</th>
                <th>所属机构</th>
                <th width="20%">操作</th>
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
                    <c:forEach var="user" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="index">
                        <tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if> onclick="toViewInTree('${user.userid}','${user.orgseq }','${user.usercode }','user');">
                            <td>[${user.usercode}]&nbsp;${user.username}</td>
                            <td>${user.deptname}</td>
                            <td>
                                
                                <a id="user_priv_tab" href="javascript:void(0)"  onclick="toViewInTree('${u.userid}','${u.orgseq }','${u.usercode }','user');"> 
	                            	<span>资源授权</span>
								</a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    <div class="panelBar">
        <div rel="deptManagerBox3" class="pagination" targetType="navTab"
            totalCount="${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}"
            numPerPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
            currentPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}"></div>
    </div>
</div>
