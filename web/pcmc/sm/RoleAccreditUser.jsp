<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.util.ITEMS"%>
<%@ page import="com.sunline.jraf.util.Crypto"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/common.jsp"%>
</head>
<body>
<sc:fieldset name="角色授权">
    <form action="/httpprocesserservlet" method="post">
        <input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
        <input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
        <input type="hidden" name="actions" value="<sc:fmt value='saveUserPermissions' type='crypto'/>">
        <input type="hidden" name="forward" value="/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getRoleList' type='crypto'/>&PageNo=1&forward=<sc:fmt value='/pcmc/sm/RoleList.jsp' type='crypto'/>">
        <input type="hidden" name="roleid" value="<%=request.getParameter("roleid")%>">
        
        <table width="100%" cellpadding="0" cellspacing="5">
            <tr>
                <td width="30%" valign="top">
                    <table width="100%" cellpadding="0" cellspacing="0" class="form-table">
                        <tr><th colspan="4">角色详细信息</th></tr>
                        <tr>
                            <td class="form-label" width="23%">角色名称：</td>
                            <td id="rolenameid" class="form-value"></td>
                        </tr>
                        <tr>
                            <td class="form-label">所属子系统：</td>
                            <td id="cnnameid" class="form-value"></td>
                        </tr>
                    </table>
                </td>
                <td valign="top">
                    <%-- String ifile = "/pcmc/sm/UserList_sel.jsp?roleid="+request.getParameter("roleid");
                    <jsp:include page="<%=ifile%>"/> --%>
                    <table width="100%">
                        <tr>
                            <td id="query_user_id">
                                <table class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0">
                                    <tr><th colspan="2">用户查询</th></tr>
                                    <tr>
                                        <sc:text dsp="td" name="userna" dspName="用户名称/编号" req="0"/> 
                                    </tr>
                                    <tr>
                                        <td colspan="2" class="form-bottom" align="center">
                                            <sc:button value="查询" onclick="queryUser();" name="dosubmit"/>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                         <tr>
                            <td>
                                <div class="page-title" style="margin:0px;"><span id="pageTitleId" class="title">用户列表</span>
                                <div id="userListId" style="overflow: auto"
                                        jraf_pageid="userListId" 
                                        jraf_url="/pcmc/sm/UserList_sel.so"
                                        jraf_sysName="<sc:fmt value='pcmc' type='crypto'/>"
                                        jraf_oprID="<sc:fmt value='sm_query' type='crypto'/>"
                                        jraf_actions="<sc:fmt value='getUserListByRole' type='crypto'/>"
                                        jraf_params="">
                                </div>
                                <input type="hidden" name="addUsers" value="" />
                                <input type="hidden" name="delUsers" value="" />
                                </div>
                            </td>
                        </tr>
                         <tr>
                            <td id="save_user_id">
                                <div class="page-bottom">
                                    <sc:button value="保存" name="saveBtn" onclick="saveOk();"/>
                                    <sc:button value="重置" type="reset"/>
                                    <sc:button value="返回" onclick="history.go(-1);"/>
                                </div>
                            </td>
                        </tr>
                    </table>
                    
                    
                    
                </td>
            </tr>
        </table>
    </form>
</sc:fieldset>
</body>
<script type="text/javascript">
var g_roleid = null;
document.observe("dom:loaded", function (){
	var height = document.getElementById('query_user_id').clientHeight+document.getElementById('save_user_id').clientHeight+80;
	new Jraf.DimensionsAuto(window, '#userListId', 'height', -height);
    var cnname = unescape('${param.cnname}');
    var rolename = unescape('${param.rolename}');
    $("cnnameid").update(cnname);
    $("rolenameid").update(rolename);
    g_roleid = '${param.roleid}';
    queryUser();
});

function saveOk(){
    if (window.confirm("确定要保存用户授权信息吗？")){
    	//Added by zhengmzh on 2013-08-08
    	var userids = document.getElementsByName('userid');
    	var addUsers = new Array();
    	var delUsers = new Array();
    	var m = 0;
    	var n = 0;
    	for(var i = 0;i < userids.length; i ++){
    		var useridObj = userids[i];
    		if(useridObj.checked != useridObj.defaultChecked){
    			if(useridObj.checked == true){
    				addUsers[m++] = useridObj.value;
    			}
    			else{
    				delUsers[n++] = useridObj.value;
    			}
    		}
    	}
    	if(addUsers.length > 0){
	    	document.getElementsByName('addUsers')[0].value = addUsers.join(",");
    	}
    	if(delUsers.length > 0){
    		document.getElementsByName('delUsers')[0].value = delUsers.join(",");
    	}
        document.forms[0].submit();
    }
}
function queryUser() {
	var userna = document.getElementsByName('userna')[0].value;
	document.getElementById("userListId").setAttribute("jraf_params","roleid="+g_roleid+"&userna="+userna);
	new Jraf.LoadPageTo().doLoad("userListId");
}
</script>
</html>
