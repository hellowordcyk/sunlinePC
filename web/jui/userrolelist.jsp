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
<title>切换角色</title>
<style type="text/css">
.v-auto {
	float:left;
	width:auto;
	height:auto;
	margin:20px;
}
.v-auto>div{
	text-align:center;
	cursor:pointer;
}
.v-auto>div>div{
	height:30px;
	line-height:30px;
	text-align:center;	
}
</style>
</head>
<body scroll="no">
	<div class="">
		<c:forEach var="role" items="${jrafrpu.rspPkg.rspRcdDataMaps }">
			<div class="v-auto">			
				<div onclick="changeDefaultRole('${role.roleid}')" > 
					<img src="/common/func-images/menu-icon/icon${role.roletp}.png" width="90" height="90" />
					<div>${role.rolename}</div>
				</div>				
			</div>
			<%-- <div class="v-auto">
				<div >
					<a onclick="changeDefaultRole('${role.roleid}')"> 
						<img src="/common/func-images/menu-icon/icon${role.roletp}.png" width="90" height="90" />
						<div ><span>${role.roleid} ${role.rolename}</span></div>
					</a>
				</div>
			</div> --%>
		</c:forEach>
	</div>
</body>
</html>
<script type="text/javascript">
//切换角色
function changeDefaultRole(defaultRoleid){
	//这个方法是点击角色之后进行方法操作
	var currentRole = '${param.currentRole}';
	$.pdialog.closeCurrent();
	if(currentRole!=defaultRoleid){
		//修改默认角色
		var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'
	    + '&oprID=<sc:fmt value='initHome' type='crypto'/>'
	    + '&actions=<sc:fmt value='updateDefaultRole' type='crypto'/>';
	    $.ajax({
			type:'POST',
			url: url,
			dataType:'text',
			data:"roleid="+defaultRoleid,
			success:function(data){
				window.location.reload();
				//changeRoleInit(defaultRoleid);
			}
		});
	}
}
</script>