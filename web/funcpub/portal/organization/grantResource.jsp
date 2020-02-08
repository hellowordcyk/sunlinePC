<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body>
<div id="grantResource">
<div class="pageHeader">

	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return dialogSearch(this);">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='getResource' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/organization/grantResource.jsp' />?userid=<%=userid%>&scgptp=<%=scgptp%>"/>
	<input type="hidden" name="pageNum" value="1" />
	<%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
	<sc:hidden  name="looks.scgptp"/>
	<div class="searchBar">
			<table class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0">
			    <tr>
			    	<td align="right">用户</td>
			    	<td><sc:text name="looks.userid" readonly="true"/></td>
			    	<td align="right">资源代码/名称</td>
				    <td><sc:text name="looks.resccd"/></td>
				    <td align="right">资源类型</td>
				    <td><sc:select  name="looks.resctp"  type="knp" key="pcmc,resctp"  nullOption ="---请选择----" /></td>
				</tr>
			    <tr>
				    <td align="right">子系统 </td>
			        <td colspan="4"><sc:select  name="looks.subsys"  type="subsys"  nullOption ="---请选择----" /></td>
			        <td align="right"><button class="button"   	jraf_initsubmit type="submit">查询</button></td>
				</tr>
			</table>
  		</div>
	</form>
</div>
<div class="pageContent" >
	<form id="grantResourceForm" action="/httpprocesserservlet" method="post">
		<sc:hidden name="looks.userid" />
		<sc:hidden  name="looks.scgptp"/>
		<div class="panelBar">
			<ul class="toolBar">
				<li><a class="add" href="javascript:void(0);" onclick="grantResource()"><span>授权</span></a></li>
	        </ul>
		</div>
		<table class="table" width="100%">
			<thead>
				<tr>				
					<th width="25px"><input type="checkbox" class="checkboxCtrl" group="rescids" /></th>
					<th>资源代码</th>
					<th>资源/资源组名称</th>
					<th>资源类型</th>
					<th>子系统</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="resource" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
					<tr >
					    <td><input type="checkbox"  name="rescids" value="${resource.rescid}"/></td>
					    <td>${resource.resccd}</td>
					    <td>${resource.rescna}</td>
					   <%--  <td><sc:optd  name="resctp"  type="knp" key="pcmc,resctp" index="${index.count}"/></td>		
						<td><sc:optd  name="subsys"  type="subsys" index="${index.count}"/></td> --%>
						<td><sc:optd  name="resctp"  type="knp" key="pcmc,resctp" index="${index.count}"/></td>		
						<td><sc:optd  name="subsys"  type="subsys" value="${resource.subsys}"/></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</form>
	<div class="panelBar">
		<div rel="grantResource" class="pagination" targetType="dialog" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
            numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
            currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div> 
</div>  
</body>
</html>
<script>
function grantResource(){
	var count = 0;
	var checkbox = document.getElementsByName('rescids');
	for(var i=0;i<checkbox.length;i++){
		if(checkbox[i].checked){
			count++;
		}
	}
	if(count <= 0){
		alertMsg.info('请选择一条记录');
		return;
	}else{
		var  sysName = '<sc:fmt value='funcpub' type='crypto'/>';
		var    oprID = '<sc:fmt value='funcpub-deptusermanager' type='crypto'/>';
		var  actions = '<sc:fmt value='userResourceGrant' type='crypto'/>';
		var      url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions;
		$.ajax({    
	        type:'post',        
	        url:url,
	        async:false,   
	        dataType:'XML', 
	        data:$("#grantResourceForm").serialize(),
	        success:function(data){   
	        	var msg = $(data).find('DataPacket Response Data msg').text();
	        	if("success" == msg){
	        		alertMsg.correct('授权成功',{
	        			okCall:function(){
	        				$.pdialog.closeCurrent();
	        			}
	        		});
	        	}else{
	        		alertMsg.error(msg);
	        	}
	        }    
	    });    
	}
}
</script>