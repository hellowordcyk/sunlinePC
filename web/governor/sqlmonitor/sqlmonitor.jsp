<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jui_tag.jsp" %>
<%@ page import="java.util.Date"%>
<div class="pageHeader">
	<%-- 规范： 分页form的id,规定为列表id+"_pageForm"，如：role_main_listid_pagerForm --%>
	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
		<input type="hidden" name="sysName" value="<sc:fmt value='governor' type='crypto'/>" /> 
		<input type="hidden" name="oprID" value="<sc:fmt value='sqlMonitor' type='crypto'/>" /> 
		<input type="hidden" name="actions" value="<sc:fmt value='getSqlLog' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt value='/governor/sqlmonitor/sqlmonitor.jsp' type='crypto' />"/>
		<input type="hidden" id="userCode" value="null"/>
		<%-- 规范： 初始化查询必加隐藏表单 --%>
		<sc:hidden name="jraf_initsubmit" />
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0">
				<tr>
					<td class="form-label">SQL包含</td>
					<td class="form-value"><input req="1" id="sqlInclude"
						name='sqlInclude' type='text' value="<%=request.getParameter("sqlInclude")==null?"":request.getParameter("sqlInclude")%>"/><span style="color: red;">*</span></td>
					<!-- <td class="form-label">用户编号</td>
					<td class="form-value"><input req="1" name='userCode'
						type='text' /><span style="color: red;">*</span></td> -->
					<td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                                <button class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
				</tr>
				<tr>
					<td class="form-label">
						是否开启日记记录
					</td>
				    <td>
				        <input type="radio" id="no_log" name="debug"
						value="false" checked="checked" onclick="changeLogStatus(0)" />开启
				        <input type="radio" id="yes_log" name="debug"
						value="true" onclick="changeLogStatus(1)" />关闭
						<span style="color: red;">*</span>
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
                <a class="btnNormal" target="dialog" rel="editConfig" title="删除配置" width="500" height="330"
                   href="/governor/sqlmonitor/deleteSqlMonitor.jsp" >
                   <span>删除配置</span>
                </a>
            </li>
            <li>
            	<a class="export" href="javascript:uploadBegin()"><span>导出sql监控</span></a>
            </li>
            <%-- 按钮组分隔 --%>
            <li class="line">line</li> 
         </ul>
    </div>
    <div >
	    <table class="table">
	        <thead>
                <th width="30%">SQL语句</th>
                <th width="10%">执行开始时间</th>
                <th width="10%">执行结束时间</th>
                <th width="10%">执行参数</th>
               <!--  <th width="10%">用户编号</th> -->
	        </thead>
	        <tbody>
				<c:choose>
					<c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}">
						<tr>
							<td class="empty" colspan="5">查询无数据。</td>
						</tr>
					</c:when>
					<c:otherwise>
        				<c:forEach var="sqlmonitor" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
            				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
            					<%-- <td class="checkbox">
            						<input type="checkbox" value="${sqlmonitor.logno}">	
            					</td> --%>
            					<td >
            						${sqlmonitor.sqlInfo}	
            					</td>
            					<td >
            						${sqlmonitor.startTime}	
            					</td>
            					<td >
            						${sqlmonitor.endTime}	
            					</td>
            					<td >
            						${sqlmonitor.sqlPara}	
            					</td>
            					<%-- <td >
            						${sqlmonitor.userCode}	
            					</td> --%>
            				</tr>
            			</c:forEach>
            		</c:otherwise>
            	</c:choose>
			</tbody>
	    </table>
		<div class="panelBar">
			<div class="pagination"
				totalCount="${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}"
				numPerPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
				currentPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
	
	function changeLogStatus(isOpen){
		var userCode = document.getElementById("userCode").value;
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='governor' type='crypto'/>"
		    + "&oprID=<sc:fmt value='sqlMonitor' type='crypto'/>"
		    + "&actions=<sc:fmt value='changeLogStatus' type='crypto'/>"
		    + "&userCode="+userCode
		    + "&isOpen="+isOpen;
		$.ajax({
			global:false,
			type:'POST',
			url: url,
			dataType:'text',
			error: DWZ.ajaxError,
			success:function(data){
				
			}
		});
	}
	
	function uploadBegin(){
		var sqlInclude = document.getElementById("sqlInclude").value;
		var userCode = document.getElementById("userCode").value;
		var url = "/download?sysName=<sc:fmt value='governor' type='crypto'/>"
		    + "&oprID=<sc:fmt value='sqlMonitor' type='crypto'/>"
		    + "&actions=<sc:fmt value='exportSqlLog' type='crypto'/>"
		    + "&dt="+new Date()
		    + "&userCode="+userCode
		    + "&sqlInclude="+sqlInclude;
		location.href= url;
		
		/* var ajax = new Jraf.Ajax();
		ajax.sendForXml('/xmlprocesserservlet', param, function(xml){
			
			var pkg = new Jraf.Pkg(xml);
			if(pkg.result()!=0){
				Jraf.showMessageBox({
					text:"导出出错",
					type:"error"
				});
				return;
			}
			
			var path = pkg.rspData("Record/filePath");
			var name = pkg.rspData("Record/fileName");
			
			var downloadStr = "<a style='display: none;' id='downloadId' href='/governor/download/downloaddatafile.jsp?decodeFlag=true&filepath=" + path + "&filename=" + encodeURI(encodeURI(name)) + "'><span style='color: blue;'>"+name+"</span></a>";
		    Jraf.showMessageBox({
		    	title: "文件下载",
		        text: "<p style='line-height: 20px'>点击<确定>" + downloadStr +"下载,否则<取消>。",
		        type: "success",
		        onOk: function () {
		            $('downloadId').click();
		        },
		        onCancel: function (){},
		        onClose: function () {}
		    }); 
		});*/
	}
	
</script>
</html>