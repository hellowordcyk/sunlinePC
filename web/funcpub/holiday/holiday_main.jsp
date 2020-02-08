<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html>
<div class="pageHeader">
   <form id="pagerForm" onsubmit="return navTabSearch(this)" action="/httpprocesserservlet" method="post" >
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='holiday' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='queryHolidayListPage' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/holiday/holiday_main.jsp' />" />
			<%-- 规范： 初始化查询必加隐藏表单 --%>
		<sc:hidden name="jraf_initsubmit" />
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">日期</td>
				    <td class="form-value"><sc:date name="calendarDate"  /></td>
				    <td class="form-label">日期类型</td>
				    <td class="form-value"><sc:select name="dateType"  key="pcmc,dateType"  type = "knp"  nullOption="请选择"  excludes="dateType" /></td>
				</tr>
				<tr>
				    <td class="form-label">是否假期</td>
				    <td class="form-value"><sc:select name="isHoliday"   key="pcmc,boolflag"  type = "dict"  nullOption="请选择"   /></td>
				    <td class="form-label">星期</td>
				    <td class="form-value"><sc:select name="weekDay"  key="pcmc,weekDay"  type = "dict"    nullOption="请选择" excludes="%" /></td>
                    <td align="right">
	                    <button class="querybtn" jraf_initsubmit type="submit">查询</button>                           
	                    <button class="resetbtn" type="reset">清空</button>                        
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
                <a class="add" href="/funcpub/holiday/holiday_add.jsp"  width="600" height="500"
                    target="dialog" rel="holiday_add">
                    <span>新增</span>
                </a>
            </li>
            <li>
                <a class="add" href="/funcpub/holiday/holiday_addBacth.jsp"  width="600" height="500"
                    target="dialog" rel="holiday_addBacth">
                    <span>批量生成</span>
                </a>
            </li>
            <li>
                <a class="delete" group="calendarDate" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='holiday' type='crypto'/>&actions=<sc:fmt value='deleteHoliday' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
    </div>

 <table class="table" cellpadding="0" cellspacing="0" >	<thead>
		<tr>
		    <th width="40" class="checkbox">
				<input type="checkbox" class="checkboxCtrl" group="calendarDate" />
			</th>
			<th width="10%">日期</th>
			<th width="15%">星期</th>
			<th width="10%">日期类型</th>
			<th width="10%">是否为假期</th>
			<th >描述</th>
			<th width="320">操作</th>
		</tr>
	</thead>
	<tbody>
		<c:choose>
			<c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
		        <tr class="null-notice"><td colspan="8"><div>暂时没有数据...</div></td></tr>
		    </c:when>
		    <c:otherwise>
				<c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
					<tr>
						 <td class="checkbox">
	            			<input type="checkbox" name="calendarDate"  value="<sc:fmt value='${record.calendarDateStr}' type='Date' pattern='yyyy-mm-dd'/>"  />		                                
	            		 </td>
	            		 <td><sc:fmt value='${record.calendarDateStr}' type='Date' pattern="yyyy-mm-dd" /></td>
						 <td><sc:optd type="dict" key="pcmc,weekDay"  value="${record.weekDay}" /></td>
                         <td><sc:optd name="dateType"  key="pcmc,dateType"  type = "knp"  value="${record.dateType}" /></td>
                         <td><sc:optd type="dict" key="pcmc,boolflag" value="${record.isHoliday}" /></td>
                         <td>${record.dateDesc}</td>
                         <td>
	                	  <a class="btnEdit" rel="post_update" target="dialog"
	                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='holiday' type='crypto'/>&actions=<sc:fmt value='getHoliday' type='crypto'/>&forward=<sc:fmt value='/funcpub/holiday/holiday_update.jsp' type='crypto'/>&calendarDate=${record.calendarDateStr}" height="500" width="600">修改 </a>
	                		 <a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"  
    							href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='holiday' type='crypto'/>&actions=<sc:fmt value='deleteHoliday' type='crypto'/>&&calendarDate=${record.calendarDateStr}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
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
