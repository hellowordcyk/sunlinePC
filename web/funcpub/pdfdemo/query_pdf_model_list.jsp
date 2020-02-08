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
            <th width="10%">模板名称</th>
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
        <c:forEach var="pdfTemp" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
            <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                <td class="checkbox">
                	<input type="checkbox" name="paramp" value="${pdfTemp.tempid}"/>
                </td>
                <td width="80%">${pdfTemp.tempname}</td>
                <td>
                    <a class="btnKey" target="dialog" rel="view_pdf" title="修改合同" width="1000" height="550" fresh="false" 
                       href="/funcpub/pdfdemo/view_pdf.jsp?tempid=${pdfTemp.tempid}"
                       >
                       <span>查看修改合同</span>
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
