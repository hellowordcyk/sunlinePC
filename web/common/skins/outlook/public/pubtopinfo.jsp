<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp"%>
<link href="<%=contextPathStr + skinCssPath %>/style_new.css" type="text/css" rel="stylesheet">
<sc:doPost var="subsyspkg" sysName="pcmc" oprId="sm_query" action="getSubSyss" all="true"/>
<c:set var="subsysRcds" value="${subsyspkg.rspRcdDataMaps}"/>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="headerbg">
    <tr>
        <td align="left"><img src="<%=contextPathStr + BimisConf.getBankpic()%>" /></td>
        <td align="right" valign="top" style="padding: 0;">
           <div class="topbar" style="width:300px; ">
                <span class="skin" style="height: 18px;">
                    <a href="javascript:changeSkin()">换肤</a>
                </span>
                <span class="passwordedit">
                    <a href="#" onClick="openModal('/pcmc/sm/userPwdModify.jsp', 500, 200);">修改密码</a>
                </span>
                <span class="help">
                    <a href="#" onclick="alert('暂无帮助')">帮助</a>
                </span>
                <span class="logout">
                    <a href="#" onclick="parent.window.location='/logout.jsp'">注销</a>
                </span>
                <span class="user" style="display: inline-block; margin-bottom: 0px">
                    欢迎您，<b><%=loginJrafAuth.getUser().getUserName()%></b>
                </span>
            </div>
        </td>
    </tr>
</table>
<script type="text/javascript" defer="defer">
function changeSkin(){
	var value = openModal('/pcmc/sm/userSkinModify.jsp?s_time='+(new Date().getTime()), 400, 150);
	if(value!=null)
	    doChangeSkin(value);
}

function doChangeSkin(value){
	
	var params = {
		    sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
	        oprID:      '<sc:fmt type="crypto" value="SkinUtilActor"/>',
	        actions:    '<sc:fmt type="crypto" value="changeSkinname"/>',
	        skinname:   value
	    };
	var url = '/cookieUtil.jsp?skinname='+value;
	var ajax = new Jraf.Ajax();
	ajax.loadPageTo(url,null,'divId');
	ajax.sendForXml('/xmlprocesserservlet', params, function(xml){
	   	window.parent.location.reload();
	});
}
</script>
