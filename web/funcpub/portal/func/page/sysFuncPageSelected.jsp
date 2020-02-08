<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 配置功能页面关系
 * description: 
 *     1.配置功能页面关系
 * author: 
 * createtime: 
 * logs:
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return dialogSearch(this);" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='sysFuncRelationshipActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='queryUnRelationPages' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/func/page/sysFuncPageSelected.jsp' />" />
	  	<sc:hidden name="selected" value="${jrafrpu.rspPkg.rspDataMap.selected}"/>
	  	<sc:hidden name="funcSuperCode" index="1"/> 
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
        
		<div class="searchBar">
			<sc:hidden name="pageNum"/>
			
			<table class="searchContent">
			    <tr>
					<td class="form-label">页面编号</td>
					<td class="form-value"><sc:text name="funcCode" /></td>
					<td class="form-label">页面名称</td>
					<td class="form-value"><sc:text name="funcName" /></td>
				    <td class="form-btn">
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
		    </table>
	    </div>
	</form>
</div>
<div class="pageContent" >
	<div class="panelBar">
		<ul class="toolBar">
			<li>
				<a class="btnNormal" rel="paramp" targetType="dialog" target="selectedTodo" title="确定要关联所选记录吗?" callback="reloadPageList"
    			   href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncRelationshipActor' type='crypto'/>&actions=<sc:fmt value='addSysFuncRelationship' type='crypto'/>&funcSuperCode=<c:out value="${param.funcSuperCode}"/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" >
                <span>选择确认</span>
                </a>
            </li>
			<li class="line">line</li>
		</ul>
	</div>
    <table id="page_table"  class="table" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
			<thead>
				<tr>
					<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
					<th width="15%">页面编号</th>
					<th width="15%">页面名称</th>
					<th width="60%">页面地址</th>
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
    				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
    					<tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if> >
    						<td class="checkbox"><input type="checkbox"  name="paramp" value="${item.funcCode}"/></td>
    						<td>${item.funcCode}</td>
    						<td>${item.funcName}</td>
    						<td>${item.funcUrl}</td>
    					</tr>
    				</c:forEach>
                </c:otherwise>
            </c:choose>
			</tbody>
		</table>
	
	<div class="panelBar">
		<div rel="" class="pagination" targetType="dialog" 
			totalCount="${jrafrpu.rspPkg.rspRecordCount}" 
			numPerPage="${jrafrpu.rspPkg.rspPageSize }" 
			currentPage="${jrafrpu.rspPkg.rspPageNo}">
		</div>
	</div>	
</div>

<script type="text/javascript">
	function reloadPageList() {
		$("form",$.pdialog.getCurrent()).submit();
	    return true;
	}
</script>