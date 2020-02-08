<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
*   logs:
*       edited by beidao 20160707 优化界面 
 --%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
	<script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
	<title>系统资源维护</title>
</head>
<body>
<div class="pageHeader">
	<form  id="pagerForm"  onsubmit="return divSearch(this,'jbsxBox1');" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="pageNum" value="1" />
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='sys_res' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='querySysResourseWithPage' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/resource/query_sysresourse.jsp' />" />
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" width="100%">
				<tr>
              		<td class="form-label">资源类型</td>
		      		<td class="form-value">
		      			<sc:select id="resctp" name="looks.resctp" type="knp" key="pcmc,resctp"  nullOption ="---请选择----"  includeTitle="false" index="1"/>
					</td>
					<td class="form-label">子系统</td>
		      		<td class="form-value">
		         		<sc:select id="subsys" name="looks.subsys" type="subsys" nullOption ="---请选择----" includeTitle="false" index="1"/>
		     		</td> 
		      		<td class="form-label">资源代码</td>
			  		<td class="form-value"><sc:text id="resccd" name="looks.resccd" /></td>
                    <td class="form-btn">
                        <ul>
                            <li>
                                <button class="querybtn" onclick="doRefrech()">刷新系统资源</button>
                            </li>
                            <li>
                                <button class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                        </ul>
                    </td>
         		</tr>
		  		<tr>  
					<td class="form-label">资源名称</td>
					<td class="form-value"><sc:text id="rescna" name="looks.rescna" /></td>  
			   		<td class="form-label">资源启用日期</td>
				 	<td class="form-value">
				    	<sc:date id="begndt"  name="looks.begndt" dateFmt="yyyy-MM-dd" minDate="2000-01-15" maxDate="2020-12-15"  readonly="true" />
				 	</td> 
				 	<td class="form-label">资源终止日期</td>
				 	<td class="form-value">
				    	<sc:date id="matudt"  name="looks.matudt" dateFmt="yyyy-MM-dd" minDate="2000-01-15" maxDate="2020-12-15"  readonly="true" />
				 	</td>
		  		</tr>
    		</table>
    	</div>
	</form>
</div>
    
<div class="pageContent" >
	 <div class="panelBar">
		<ul class="toolBar">
		    <li><a class="add" href="/funcpub/portal/resource/add_sysresourse.jsp" height="350" width="800" target="dialog" ><span>新增</span></a></li> 
		    <li><a class="delete" callback="deleteCallback" rel="rescid" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sys_res' type='crypto'/>&actions=<sc:fmt value='deleteSysResourse' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>
			<!-- <li><a class="buttonContent" href="javascript:allowResource()"><span>授权</span></a></li> -->
			<li class="line">line</li> 
        </ul>
	</div>	 
	<table class="table" width="100%" layoutH="240">
		<thead>
			<tr>
				<th width="25px"><input type="checkbox" class="checkboxCtrl" group="rescid" /></th>
				<th>资源类型</th>
				<th>子系统</th>
				<th>资源代码</th>
				<th>资源名称</th>
				<th>启用日期</th>
				<th>终止日期</th>
				<th width="20%">操作</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="sysResourse" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
			<tr >
			    <td><input type="checkbox"  name="rescid" value="${sysResourse.rescid}"/></td>
				<td><sc:optd  name="resctp"  type="knp" key="pcmc,resctp" index="${index.count}"/></td>		
				<td><sc:optd  name="subsys"  type="subsys" index="${index.count}"/></td>
				<td>${sysResourse.resccd}</td>
				<td>${sysResourse.rescna}</td>
				<td>${sysResourse.begndt}</td>
				<td>${sysResourse.matudt}</td>
				<td>
						<a class="btnEdit"  target="dialog" 
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
						&oprID=<sc:fmt value='sys_res' type='crypto'/>
						&actions=<sc:fmt value='querySysResourseById' type='crypto'/>
						&rescid=${sysResourse.rescid}&forward=<sc:fmt value='funcpub/portal/resource/update_sysresourse.jsp' type='crypto'/>" height="400" width="800" >修改</a>
						
						<a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo" callback="deleteCallback"  
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
						&oprID=<sc:fmt value='sys_res' type='crypto'/>&actions=<sc:fmt value='deleteSysResourse' type='crypto'/>
						&rescid=${sysResourse.rescid}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a>
						
						<a class="btnKey"  target="dialog" 
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
						&oprID=<sc:fmt value='sys_res_gr' type='crypto'/>
						&actions=<sc:fmt value='querySysResourseGr' type='crypto'/>
						&rescid=${sysResourse.rescid}&resccd=${sysResourse.resccd}&resctp=${sysResourse.resctp}&flag=1&forward=<sc:fmt value='/funcpub/portal/resource/grant_sysresourse.jsp' type='crypto'/>" height="550" width="800" >授权</a>
				</td>
			</tr>
		 </c:forEach>
	  </tbody>
	</table>
	<div class="panelBar">
		<div rel="jbsxBox1"  class="pagination" targetType="navTab" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div>   
</body>
<script>
function doRefrech() {   //刷新资源
	var resctp = $("#resctp").val();
	var subsys = $("#subsys").val();
	if (resctp == null || resctp == "" || subsys == null || subsys == "") {
		alertMsg.info('请选择你要刷新的资源类型和子系统!');
		return false;
	}
	
		var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sys_res' type='crypto'/>'
			+ '&actions=<sc:fmt value='RefreshResc' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/resource/query_sysresourse.jsp' type='crypto'/>';
		$.ajax({
			   type: "POST",
			   url: url,
			   data: {"resctp":resctp,"subsys":subsys},
			   dataType : "xml",
			   success: function(data){
				  var msg = $(data).find('DataPacket Response Data msg').text();
				  if(msg == "success"){
					  alertMsg.correct('刷新成功!');
				  	$("#querySysresourseBtn").trigger("click");
				  }else{
					  alertMsg.error('刷新失败!');
				  }
			   }
		});
	
}


	function compareDate(begndtInput, overdtInput) {

		// 校验结束日期不早于开始日期
		var begnDate = new Date(begndtInput.value.replace(/-/g, "/"));
		var overDate = new Date(overdtInput.value.replace(/-/g, "/"));
		if (Date.parse(overDate) - Date.parse(begnDate) < 0) {
			return false;
		}
		return true;
	}
	
	function deleteCallback(){
		divSearch('#pagerForm','jbsxBox1');
	}
</script>
</html>
