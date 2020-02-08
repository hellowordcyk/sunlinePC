<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
<title>用户资源授权</title>
</head>
<body>
<div class="pageHeader">
	<form id="pagerForm" name="searchForm" action="/httpprocesserservlet" onsubmit="return divSearch(this, 'userManagerBox2');" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='getUserResource' type='crypto'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/organization/manager_user_grant_resc.jsp' />?userid=<%=userid%>"/>
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<input type="hidden" name="pageNum" value="1" />
		<div class="searchBar">
			<table class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0">
			    <tr>
			    	<td align="right">用户</td>
			    	<td><sc:text name="looks.userid" readonly="true" validate="required"/></td>
			    	<td align="right">资源代码/名称</td>
				    <td><sc:text name="looks.resccd"/></td>
				    <%-- <td align="right">授权途径</td>
				    <td><sc:select name="looks.grantTp"  type="dict" key="pcmc,usgrtp"  nullOption ="---请选择----" /></td> 
                     --%>
                    <td align="right" rowspan="2">
                        <button id="getUserResource" class="button"  jraf_initsubmit type="submit">查询</button>
                    </td>
				</tr>
			    <tr>
					<td align="right">资源类型</td>
				    <td><sc:select  name="looks.resctp"  type="knp" key="pcmc,resctp"  nullOption ="---请选择----" /></td>
				    <td align="right">子系统 </td>
			        <td><sc:select  name="looks.subsys"  type="subsys"  nullOption ="---请选择----" /></td> 
				</tr>
			</table>
  		</div>
	</form>
</div>

<div class="pageContent" >
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="javascript:void(0)" onclick="grantResource(1);"><span>资源授权</span></a></li> 
			<!-- <li><a class="add" href="javascript:void(0)" onclick="grantResource(2);"><span>资源组授权</span></a></li> -->
			<li><a class="delete" rel="rsprids" target="selectedTodo" title="确定要删除所选记录吗?" 
				href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>
				&actions=<sc:fmt value='delUserResource' type='crypto'/>&forward=/jui/callMessage.jsp"><span>删除</span></a></li>
			<li class="line">line</li> 
        </ul>
	</div>	 
	<table class="table" width="100%">
		<thead>
			<tr>				
				 <th width="25px"><input type="checkbox" class="checkboxCtrl" group="rsprids" /></th>
	             <th>资源代码</th>
	             <th>资源名称</th>
	             <th>资源类型</th>
	             <th>子系统</th>
	             <!-- <th>资源组</th> -->
	             <th>角色</th>
	             <th>来源</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="usergrantresc" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
				<tr >
				    <td><input type="checkbox"  name="rsprids" value="${usergrantresc.rsprid}"/></td>
				    <td>${usergrantresc.resccd}</td>
					<td>${usergrantresc.rescna}</td>
					<td><sc:optd  name="resctp"  type="knp" key="pcmc,resctp" index="${index.count}"/></td>		
					<td><sc:optd  name="subsys"  type="subsys" index="${index.count}"/></td>
					<%-- <td>${usergrantresc.rsgpna}</td> --%>
					<td>${usergrantresc.rolena}</td>
					<td><sc:optd  name="grantTp"  type="dict" key="pcmc,usgrtp" index="${index.count}"/></td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="panelBar">
		<div rel="userManagerBox2" class="pagination" targetType="navTab" 
            totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
            numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
            currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
        
	</div>
</div>   
</body>
<script>
function grantResource(scgptp){
	var url = "/funcpub/portal/organization/grantResource.jsp?looks.userid=<c:out value='${param["looks.userid"] }'/>&looks.scgptp="+scgptp;
	$.pdialog.open(url,"grantResource","用户资源授权", {width:800,height:600,maxable:false,close:function(){
		$("#getUserResource").trigger("click");
		return true;
	}});
	
}
</script>
</html>	