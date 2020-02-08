<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<div class="pageHeader">
	<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='choiceCaCtlDataClear' type='crypto'/>&actions=<sc:fmt value='querychoiceCaCtlDataClearLookUp' type='crypto'/>&forward=<sc:fmt value='/funcpub/dataclear/table/choice/choiceCaCtlDataClearLookUp.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return dwzSearch(this, 'dialog');">
    	<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
        
    	<div class="searchBar">
             <table class="searchContent" width="100%" cellpadding="0" cellspacing="0">
        		<tr>
    				<td><label>表名:</label></td>
    				<td>
                        <sc:text name="tableName1" validate="alphanumeric"/>
                    </td>
    				<td><label>表信息:</label></td>
    				<td>
                        <sc:text name="tableInfo1" />
                    </td>
    				<td><button type="submit" jraf_initsubmit class="button" >查询</button></td>
    				<td><button type="button" multLookup="orgId" class="button">选择带回</button></td>
    			</tr>
            </table>
    	</div>
	</form>
</div>

<table class="table" layoutH="118" targetType="dialog" width="100%">
	<thead>
		<tr>
			<th width="4%"><input type="checkbox" class="checkboxCtrl" group="orgId" /></th>
			<th orderfield="tableName">表名</th>
			<th orderfield="tableInfo">表信息</th>
			<th orderfield="clearType">清理类型</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="lookup" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
			<tr>
				<td><input type="checkbox"  name="orgId" value="{tableName: '${lookup.tableName}'}"/></td>
				<td>${lookup.tableName}</td>
				<td>${lookup.tableInfo}</td>
				<td>
				    <sc:optd name="clearType"  type="dict" key="pcmc,clearType" value="${lookup.clearType}" /> 
                </td>
			</tr>
		</c:forEach>
	</tbody>
</table>

