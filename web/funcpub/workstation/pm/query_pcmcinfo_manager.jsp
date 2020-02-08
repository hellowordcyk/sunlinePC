<%@page import="com.sunline.jraf.util.Crypto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>


<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>系统参数维护</title>
</head>
<body scroll="no">
	<div class="pageHeader">
		<sc:form name="query_form" action="/httpprocesserservlet" method="post" sysName="funcpub" oprID="info" actions="queryPcmcInfoByManager" attributesText="onSubmit='return navTabSearch(this);'">
			<sc:hidden name="pageNum" value="1" />
			
				
	        <%-- 规范： 初始化查询必加隐藏表单 --%>
            <sc:hidden name="jraf_initsubmit"/>
	
			<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/workstation/pm/query_pcmcinfo_manager.jsp' />"/>
			<table class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0">
			    <tr>    
				    <td class='form-label'>所属系统：</td>
				    <td class='form-value' colspan="3">
				    	<sc:select name="subsyscd"  type="subsyscd"  nullOption ="--所有子系统--" validate="required"/>
			       	</td>
			       	<td><input type="submit"  jraf_initsubmit class="button" value="查询"/></td>
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
	<div class="pageContent">
		<div class="panelBar">
			<ul class="toolBar">
				<li><a class="add" title="新增公告" href="/funcpub/workstation/pm/add_pcmcinfo.jsp" target="dialog" width="980" height="725" minable="false" maxable="false" mask="true" rel="addKpiValueI"><span>新增</span></a></li>
				<li><a class="delete" rel="info" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='info' type='crypto'/>&actions=<sc:fmt value='deletePcmcInfo' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>
			</ul>
		</div>
		<table class="table list" width="100%">
			<thead>
				<tr>
					<th width="25px"><input type="checkbox" class="checkboxCtrl" group="info" /></th>
					<th>公告标题 </th>
					<th>所属系统 </th>
		   			<th>发布公告用户</th>
					<th>发布时间</th>
					<th>生效日期</th>
					<th>终止时间</th>
					<th width="15%">操作</th>
				</tr>
			</thead>
			<tbody>
			    <c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
			     	 <tr >
						<td><input type="checkbox" name="info" value="${record.infoid}"/></td>
						<td align="center">${record.title}</td>
						<td align="center">${record.cnname}</td>
						<td align="center">${record.username}</td>
						
						<td align="center"><sc:fmt type="date" value="${record.createtime}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				        <td align="center"><sc:fmt type="date" value="${record.startdt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
				        <td align="center"><sc:fmt type="date" value="${record.enddt}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
						<td>
							<a  class="btnEdit" rel="QueryCaCtlDataClear" target="dialog" 
									href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
									&oprID=<sc:fmt value='info' type='crypto'/>&actions=<sc:fmt value='getPcmcInfoById' type='crypto'/>
									&infoid=${record.infoid}&forward=<sc:fmt value='/funcpub/workstation/pm/update_pcmcinfo.jsp' type='crypto'/>" 
									height="650" width="725" >修改</a>
						
							<a  class="btnEdit" rel="QueryCaCtlDataClear" target="dialog" 
									href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
									&oprID=<sc:fmt value='info' type='crypto'/>&actions=<sc:fmt value='getPcmcInfoById' type='crypto'/>
									&infoid=${record.infoid}&forward=<sc:fmt value='/funcpub/workstation/pm/show_pcmcinfo.jsp' type='crypto'/>" 
									height="520" width="725" >详情</a>
									
							<a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"  
								href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
								&oprID=<sc:fmt value='info' type='crypto'/>&actions=<sc:fmt value='deletePcmcInfo' type='crypto'/>
								&info=${record.infoid}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
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

