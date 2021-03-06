<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 查询系统参数
 * description: 
 *     1.查询系统参数信息；
 * author:
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
 
 <head>
    <style  type="text/css">
       .warningSecr{color:red}
     </style>
 </head>
<div class="pageHeader">
	<form  id="pagerForm" onsubmit="return navTabSearch(this);" method="post" action="/httpprocesserservlet"> 
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-syspara' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='getSyspara' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/para/syspara/query/querySyspubpara.jsp' />"/>
	<input type="hidden" name="pageNum" value="1" />
	<%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">参数编号</td>
					<td class="form-value"><sc:text name="paracode" /></td>
					<td class="form-label">参数名称</td>
					<td class="form-value"><sc:text name="paraname" /></td>
					<td class="form-btn">                      
                        <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                        <button class="querybtn" jraf_initsubmit type="submit">查询</button>                           
                        <button class="resetbtn" type="reset">清空</button>
                    </td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div class="pageContent" >
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th width="5%">序号</th>
				<th width="15%">参数编号</th>
				<th width="25%">参数名称</th>
				<th width="10%">参数值</th>
				<th>说明</th>
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
    			<c:forEach var="para" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
        			<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
        				<td>${index.index+1}</td>
        				<td>${para.paracode}</td>
        				<td title="${para.paraname}">${para.paraname}</td>
        				<td>${para.paravalue}</td>
        				<td title="${para.remark}">${para.remark}</td>
        				
        			</tr>
        		</c:forEach>
            </c:otherwise>
        </c:choose>
	   </tbody>
    </table>
<div class="panelBar">
	<div class="pagination" targetType="navTab" 
		totalCount="${jrafrpu.rspPkg.rspRecordCount}" 
		numPerPage="${jrafrpu.rspPkg.rspPageSize }" 
		pageNumShown="${jrafrpu.rspPkg.rspPageCount}" 
		currentPage="${jrafrpu.rspPkg.rspPageNo}">
	</div>
</div>
