<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 报表管理
 * description: 
 *     1.查询，导入，导出，删除报表信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='searchReport' type='crypto'/>&forward=<sc:fmt value='/sunrpt/report/manager_report.jsp' type='crypto'/>" method="post">
		<input type="hidden" name="pageNum" value="1" />
			
	<%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
	
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">报表名称</td>
					<td class="form-value"><sc:text name="q_rptsna"/></td>
					<td class="form-label">报表类型</td>
		            <td class="form-value">
		            	<sc:select name="repttype" type="dict" key="rpt,repttype" includeTitle="false" nullOption="--请选择--"/>
		            </td>
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
			 <!-- <li><a class="add" href="/sunrpt/report/addrpt.jsp" mask="true" height="300" width="600" target="dialog" rel="addReport" title="新增手工开发报表"><span>新增</span></a></li> --> 
		    <li><a class="import" href="/sunrpt/report/import_report.jsp" mask="true" height="300" width="600" target="dialog" rel="importReport"><span>导入报表模板</span></a></li> 
			<li><a class="export" href="javascript:exportReport()" ><span>导出报表模板</span></a></li>
			<li><a class="delete" rel="rptuidreportcheckbox" target="selectedTodo" title="确定要删除所选记录吗?" 
					href="/httpprocesserservlet?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='delRptReport' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" >
				<span>删除</span>
				</a>
			</li>
			<li><a href="javascript:;" class="btnDeploy" onclick="beforePublishMenu()"><span>发布菜单</span></a></li>
        </ul>
	</div>	
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="rptuidreportcheckbox" /></th>
				<th width="10%">报表代码</th>
				<th>报表名称</th>
				<th width="10%">报表类型</th>
				<th>数据源名称</th>
				<th width="10%">创建用户</th>
				<th width="10%">创建时间</th>
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="7">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
        	    <c:forEach var="rpt" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
        			<tr target="paramp1" rel="${rpt.rptuid}" <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
        				<td class="checkbox">
        					<input type="checkbox"  name="rptuidreportcheckbox" value="${rpt.rptuid}" />
        					<input type="hidden" name="rpt_reptype" value="${rpt.reptype}"/>
        				</td>
        				<td>${rpt.rptuid}
        					<input type="hidden" name="rpt_hidden_name" value="${rpt.rptsna}"/>
        					<input type="hidden" name="rpt_hidden_rptuid" value="${rpt.rptuid}"/>
        					<input type="hidden" name="rpt_hidden_isinqr" value="${rpt.isinqr}"/>
        				</td>
        				<td><a  rel="${rpt.rptuid}" title="${rpt.rptsna}"  href="/httpprocesserservlet?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='queryReport' type='crypto'/>&forward=<sc:fmt value='/sunrpt/report/export_show.jsp' type='crypto'/>&rptuid=${rpt.rptuid}&isinqr=${rpt.isinqr}" target="navTab">${rpt.rptsna}</a></td>
        				<td>
        					<sc:optd name="repttype"  value="${rpt.reptype }"  type="dict" key="rpt,repttype" />
        				</td>
        				<td>${rpt.tabsql}</td>
        				<td>${rpt.credus}</td>
        				<td>${rpt.crecdt}</td>
        			</tr>
        	    </c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="navTab" 
			totalCount="${ jrafrpu.rspPkg.rspRecordCount}" 
			numPerPage="${ jrafrpu.rspPkg.rspPageSize }" 
			currentPage="${ jrafrpu.rspPkg.rspPageNo}">
		</div>
	</div>
</div>   
<script type="text/javascript">
//发布菜单
function beforePublishMenu(){
	 var jsonArray = new Array();  //json对象的数组
	 if($("input[name='rptuidreportcheckbox']:checked").length<1) {
		 alertMsg.warn("请选择要发布的配置！");
		 return;
	 }
	 $("input[name='rptuidreportcheckbox']:checked").each(function (index,obj){
	 	var rptname = $(obj).parent().parent("td").parent("tr").children().eq(1).find("div input[name='rpt_hidden_name']").eq(0).val();
		var rptisinqr = $(obj).parent().parent("td").parent("tr").children().eq(1).find("div input[name='rpt_hidden_isinqr']").eq(0).val();
		var rptuid = $(obj).parent().parent("td").parent("tr").children().eq(1).find("div input[name='rpt_hidden_rptuid']").eq(0).val();
		
		var linkurl = "/httpprocesserservlet?sysName=sunrpt&oprID=sunrpt-report&actions=queryReport&forward=/sunrpt/report/export_show.jsp";
		//var linkurl = "/httpprocesserservlet?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='queryReport' type='crypto'/>&forward=<sc:fmt value='/sunrpt/report/export_show.jsp' type='crypto'/>";
		linkurl = linkurl+"&rptuid="+rptuid+"&isinqr="+rptisinqr;
		var menuJson = {
	  			name:rptname,
	  			url:linkurl
	  	   };
		jsonArray.push(menuJson);
		
	  });
	 publishMenu(jsonArray);
	   	
}

//导出报表模板
function exportReport(){  
	var rptuidList='';
	var seperator='';
	var count =0;
	var boxArr=document.getElementsByName("rptuidreportcheckbox");
	for(var i=0;i<boxArr.length;i++){
		var singleBox=boxArr[i];
		if(singleBox.checked){
			rptuidList=rptuidList+seperator+singleBox.value;
       		seperator=',';
       		count++;
		}
	}	
	if(rptuidList==""){
		alertMsg.warn("请选择需要导出的报表");
		return ;
	}
	if(count>1){
		alertMsg.warn("一次只能选一张报表");
		return ;
	}
	var url = "/download?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='queryReport' type='crypto'/>&rptuid="+rptuidList+"&isdownload=true";
	window.location.href=url+"&csrftoken="+g_csrfToken; 
}
//导出基础模板
function exportTemplete(){
	
	var url = "/download?sysName=<sc:fmt value='sunrpt' type='crypto'/>&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>&actions=<sc:fmt value='exportExcelTp' type='crypto'/>";
    url += "&dt="+new Date(),
     location.href= url+"&csrftoken="+g_csrfToken;
	
	
}
</script>
