<%@page import="com.sunline.jraf.util.Crypto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>用户公告列表</title>
</head>
<body scroll="no">
	<div class="pageHeader">
		<sc:form name="query_form" action="/httpprocesserservlet" method="post" sysName="funcpub" oprID="info" actions="getUserSysInfolistPage" attributesText="onSubmit='return navTabSearch(this);'">
			<sc:hidden name="pageNum" value="1" />
			
			
			<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/workstation/query_usersysinfo_manager.jsp' />"/>
            
            <sc:hidden name="jraf_initsubmit" />
            
            <sc:hidden name="jraf_initsubmit" />
			<table class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0">
			    <tr>    
				    <td class='form-label'>所属系统：</td>
				    <td class='form-value' colspan="3">
				    	<sc:select name="subsyscd"  type="subsyscd"  nullOption ="--所有子系统--" validate="required"/>
			       	</td>
			       	<td><input type="submit" jraf_initsubmit class="button" value="查询"/></td>
			    </tr>
			    <tr>
			        <sc:text dsp="td" name="title" dspName="公告标题" req="0"/> 
			        <sc:text dsp="td" name="username" dspName="发布公告用户" req="0"/> 
			    </tr>
			   <tr>
			        <td class="form-label">
			        	公告生效时间:
			        </td>
			        <td class="form-value">
			        	<sc:date name="startdate" attributesText="style='width: 155px;'"></sc:date>
			        </td>
			        <td class="form-label">
						公告终止时间
			        </td>
			        <td class="form-value">
			        	<sc:date name="enddate" attributesText="style='width: 155px;'"></sc:date>
			        </td>
			    </tr>
			</table>
		</sc:form>
	</div>
	<br><br>
	<div class="pageContent">
		<table class="table list" width="100%">
			<thead>
				<tr>
					<th>公告标题 </th>
					<th>所属系统 </th>
		   			<th>发布公告用户</th>
					<th>发布时间</th>
					<th>生效日期</th>
					<th>终止时间</th>
					<th>状态</th>
					<th width="15%">操作</th>
				</tr>
			</thead>
			<tbody>
			    <c:forEach var="record" items="${rspPkg.rspRcdDataMaps}" varStatus="status">
			     	 <tr >
						<td align="center">${record.title}</td>
						<td align="center">${record.cnname}</td>
						<td align="center">${record.username}</td>
						
						<td align="center"><sc:fmt type="date" value="${record.createtime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				        <td align="center"><sc:fmt type="date" value="${record.startdt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				        <td align="center"><sc:fmt type="date" value="${record.enddt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				        <td align="center">
							<c:choose>
								<c:when test="${record.isread != null && record.isread != '' }">
									已读
								</c:when>
								<c:otherwise>
									未读
								</c:otherwise>
							</c:choose>
						</td>
						<td align="center">
							<a class="btnEdit" rel="QueryCaCtlDataClear" target="dialog" 
									href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
									&oprID=<sc:fmt value='info' type='crypto'/>&actions=<sc:fmt value='readPcmcInfo' type='crypto'/>
									&infoid=${record.infoid}&forward=<sc:fmt value='/funcpub/workstation/pm/show_pcmcinfo.jsp' type='crypto'/>" 
									height="520" width="725"
							>详情</a>
							<c:if test="${record.isread == null || record.isread == '' }">
								<a target="ajaxTodo" 
								href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='info' type='crypto'/>&actions=<sc:fmt value='markNoCare' type='crypto'/>&infoid=${record.infoid}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" 
								>不关心</a>
							</c:if>
						</td>
					</tr>
		       </c:forEach>
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
	</body>
</html>

