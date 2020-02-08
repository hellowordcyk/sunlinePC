<%@ page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<%-- <%

	String roleid =  request.getParameter("roleid");
	String rolename = request.getParameter("rolename");
	
	
%> --%>
<div class="window-top-box" style="height: 10%" >
<form id="pagerForm" onsubmit="return dialogSearch(this);" action="/httpprocesserservlet?=&=&=&=" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='queryRoleUser' type='crypto'/>" />
		<sc:hidden name="roleid"/>
		<sc:hidden name="pageNum"/>
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
        
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/role/role_accredict_user.jsp' />" />
		<sc:hidden name="selected" value="${jrafrpu.rspPkg.rspDataMap.selected}"/>
		
	
		
		<div class="searchBar">
				
			<table class="searchContent" >
			    <tr>
				    <td align="right">角色名称 </td>
				    <td align="left"><input type="text" name="roleNameT"></td>
				    <td align="center"><input type="submit"   jraf_initsubmit class="button" value="查询"/></td>
			    </tr>
		    </table>
	    </div>
	
	
	</form>
</div>


	<div class="window-left-box" style=" width: 40% ;height:50%; text-align: center" id="userTable">
	
		
			
		<table class="table" width="100%" border="0" cellpadding="0" cellspacing="0"  title="未选">
			<thead>
				<tr>
					<th width="30px"><input type="checkbox" class="checkboxCtrl" group="userids" /></th>
					 
					<th>用户编号</th>
					<th>用户名称</th>
					<th>所在机构</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="user" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
					<tr>
						 <c:if test="${user.isSelected == 1}">
							<td><input type="checkbox" checked="checked"  name="userids" value="${user.userid}" onchange="changeChose(this)"/></td>
						</c:if>
						<c:if test="${user.isSelected == 0}">
							<td><input type="checkbox"  name="userids" value="${user.userid}" onchange="changeChose(this)"/></td>
						</c:if>
						<%-- <td width="30px" align="center"><input type="checkbox" name="userids" class="checkboxCtrl" value="${user.userid }"/></td>
						 --%>
						<td align="center">${user.usercode}</td>
						<td align="center">${user.username}</td>
						<td align="center">${user.deptname}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	
	<div class="panelBar">
		<div rel=""  class="pagination" targetType="dialog" 
			totalCount="${jrafrpu.rspPkg.rspRecordCount}" 
			numPerPage="${jrafrpu.rspPkg.rspPageSize }" 
			currentPage="${jrafrpu.rspPkg.rspPageNo}">
		</div>
		
	</div>
</div>
	<div class="window-center-button" style=" width: 15%;height: 50%">
		<button class="add" onclick="choseSelected();" type="button">选择--></button><br><br>
		<button class="delete" onclick="deleteSelected()" type="button"><--删除</button><br><br>
		<!-- <button class="delete" onclick="deleteAll()" type="button"><--全删</button><br><br> -->
		<button class="close" onclick="submit()" type="button">确定</button>
	</div>
	
	<div class="window-right-box" style=" width: 40%;height:50%;text-align: center;" >
	
		<ul id="selectedUserTree" class="ztree"></ul>
		
		<div class="panelBar">
			<div rel=""  class="pagination" targetType="dialog" 
				totalCount="${jrafrpu.rspPkg.rspRecordCount}" 
				numPerPage="${jrafrpu.rspPkg.rspPageSize }" 
				currentPage="${jrafrpu.rspPkg.rspPageNo}">
			</div>
		
		</div>
	</div>
	<script type="text/javascript">
	$(function(){
		var isforward = "<%=isforward%>";
		if(isforward != "false"){
			$("#selectUserBtn",$.pdialog.getCurrent()).trigger("click");
		}
		$.fn.zTree.init($("#selectedUserTree",$.pdialog.getCurrent()),userSelectedSetting,null);//id 对象 数据
		initselectedUserTree();
	});	

	function choseSelected(){
		var treeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
		var tr = $("#userTable",$.pdialog.getCurrent()).find("tbody tr.selected");
		if(null != tr && tr.length>0){
			treeObj.cancelSelectedNode();
			$(tr).each(function(){
				var usercode = $(this).find("[name='usercode']").val();
				var username = $(this).find("[name='username']").val();
				var deptname = $(this).find("[name='deptname']").val();
				if(multi){
					addSelectedNode(usercode,username,deptname);
				}else{
					deleteAll();
					addSelectedNode(usercode,username,deptname);
				}
			});
			setForward();
		}
	}
	
function changeChose(event){
	
	var isSelected = $(event)[0].checked;
	var userids = $(event).val();
	var selected = new Array();
	var selectedStr = $("input[name='selected']",$.pdialog.getCurrent()).val();
	if(null != selectedStr && selectedStr != ""){
		selected = selectedStr.split(",");
	}
	if(isSelected){
		selected.push(userids);
	}else{
		selected.splice(jQuery.inArray(userids,selected),1); 
	}
	$("input[name='selected']",$.pdialog.getCurrent()).val(selected.toString());
}

function toadd(){
	
	 var checkbox=document.getElementsByName("userids");
	 var length=checkbox.length;
	 var j=0;
	 var check=new Array();
	 var checked=false;
	 for(var i=0;i<length;i++){
		 if(checkbox[i].checked){
			 check[j]=checkbox[i].value;
			 j++;
		 }
	 }
	
	 //document.r
	
	 /* var userids=document.getElementById("userid").value();
	 
	 var username=document.getElementById("username").value();
	 
	 var usercode=document.getElementById("usercode").value();
	 
	 var deptname=document.getElementById("deptname").value(); */
	
}

</script>