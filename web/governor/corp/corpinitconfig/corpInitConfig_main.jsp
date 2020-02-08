<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:法人初始化配置查询列表
 * description: 
 *     显示所有法人信息
 * author: hzx
 * createtime: 20160907
 * logs:
 *
 *--%>
<div class="pageHeader">
	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
    	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='governor'/>"/>
    	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='corpInitConfigActor'/>"/>
    	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='queryCorpInitConfigList'/>"/>
    	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/governor/corp/corpinitconfig/corpInitConfig_main.jsp' />"/>
        
        <sc:hidden name="jraf_initsubmit" />
     	<div class="searchBar">
    		<table class="searchContent" cellpadding="0" cellspacing="0" >
    			<tr>
    				<td class="form-label">系统编码</td>
    				<td class="form-value"><sc:text name="systemCode" id="systemCode" /></td>
    				<td class="form-label">功能标题</td>
    				<td class="form-value"><sc:text name="functionTitle" id="functionTitle" /></td>
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
<div class="pageContent">
 	<div class="panelBar">
        <ul class="toolBar">
            <li>
                <%-- 规范：a标签属性顺序：class->target->rel->title->width->height->其他->href（地址单独一行） --%>
                <a class="add" target="dialog" rel="addCorpConfig" title="新增法人初始化配置" width="650" height="500"
                   href="/governor/corp/corpinitconfig/corpInitConfig_edit.jsp">
                   <span>新增</span>
                </a>
            </li>
            <li>
                <a class="delete" target="selectedTodo" rel="paramp" title="确定要删除所选记录吗?" 
                   href="/httpprocesserservlet?forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>&sysName=<sc:fmt value='governor' type='crypto'/>&oprID=<sc:fmt value='corpInitConfigActor' type='crypto'/>&actions=<sc:fmt value='delCorpInitConfig' type='crypto'/>" >
                   <span>删除</span>
                </a>
            </li>
            <%-- 按钮组分隔 --%>
            <li class="line">line</li> 
         </ul>
    </div>
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
			    <th class="checkbox"><input class="checkboxCtrl" type="checkbox" group="paramp" /></th>
				<th>系统编码</th>
				<th>功能标题</th>
				<th>功能表名</th>
				<th>法人字段</th>
				<th>自增字段</th>
				<th>排序</th>
				<th>操作</th>
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
    			<c:forEach var="corp" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
    				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if>>
    					<td class="checkbox">
    						<input type="checkbox" name="paramp" value="${corp.functionId}"/>
    					</td>
    					<td>${corp.systemCode }</td>
    					<td>${corp.functionTitle }</td>
    					<td>${corp.functionTable }</td>
    					<td>${corp.corporationField }</td>
    					<td>${corp.sequenceField }</td>
    					<td>${corp.functionSortno }</td>
    					<td>
    						<a  class="btnEdit" target="dialog" rel="editCorp" title="修改法人初始化配置" width="650" height="500"
    							href="/httpprocesserservlet?sysName=<sc:fmt value='governor' type='crypto'/>&oprID=<sc:fmt value='corpInitConfigActor' type='crypto'/>&actions=<sc:fmt value='getCorpInitConfig' type='crypto'/>&forward=<sc:fmt value='/governor/corp/corpinitconfig/corpInitConfig_edit.jsp' type='crypto'/>&functionId=${corp.functionId}">
    							修改
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