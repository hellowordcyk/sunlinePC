<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="com.sunline.jraf.framework.FrameWorkConfiguration" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp"%>
<link href="<%=contextPathStr + skinCssPath %>/style_new.css" type="text/css" rel="stylesheet">
<sc:doPost var="subsyspkg" sysName="pcmc" oprId="sm_query" action="getSubSyss" all="true"/>
<c:set var="subsysRcds" value="${subsyspkg.rspRcdDataMaps}"/>
<div class="headerbg">
    <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
            <td>
                <div id="logo" align="left" style='text-align: left'><img src="<%=contextPathStr + skinImgPath%>/sunline-logo.gif">
                    <%-- <img src="<%=BimisConf.getBankpic()%> " style="height:50px; width:250px" align="">--%>
                </div>
            </td>
            <td>
                <div class="topbar" style="width: 300px; text-align: left">
                    <span class="logout">
                        <a href="#" onclick="parent.window.location='/logout.jsp'">注销</a>
                    </span>
                    <span class="help">
                        <a href="#" onclick="alert('暂无帮助')">帮助</a>
                    </span>
                    <span class="passwordedit">
                        <a href="#" onClick="openModal('/pcmc/sm/userPwdModify.jsp', 500, 200);">修改密码</a>
                    </span>
                    <span class="skin">
                        <a href="javascript:" onclick="changeSkin()">换肤</a>
                    </span>
                    <span class="user">
                        欢迎您，<b><%=loginJrafAuth.getUser().getUserName()%></b>
                    </span>
                </div>
            </td>
        </tr>


        <%--<td  rowspan="2" align="center" style="FILTER: progid:DXImageTransform.Microsoft.Gradient(gradientType=1,startColorStr=#005EACF0,endColorStr=#FF62A4E4);">
                        <strong><font size="5" face="Tahoma"> <c:out value="${subsysRcds[0].cnname}"/> </font></strong></td>--%>

        <!-- 
                        <a href="/pcmc/sublogon.jsp?sys=oa&forward=<sc:fmt value='/webmail.jsp' type='crypto'/>" target="workframe"><img src="/common/images/pic01/mail_sendmail.gif" width="53" height="70" style="cursor:hand" border="0" alt="进入邮件系统"></a><a href="/oams/pi/ggtxl.jsp"  target="workframe"><img src="/common/images/pic01/mail_wap.gif" width="60" height="70" border="0" style="cursor:hand" alt="查看公共通讯录"></a><a href="/pcmc/bbslogon.jsp" target="workframe" title="电子论坛"><img src="/common/images/pic01/mail_bbs.gif" width="60" height="70" border="0" style="cursor:hand" alt="进入电子论坛"></a>
                         -->
        <!-- 
                         <a  href="#" onclick="openModal('/pcmc/sm/userPwdModify.jsp', 380, 155);"><img src="/common/images/pic01/edit-password.png"  border="0" style="cursor:hand" alt="修改密码"></a>
                        <a  href="#" onClick="parent.window.location='/logout.jsp'"><img src="/common/images/pic01/exit.gif" width="90" height="24" border="0" style="cursor:hand" alt="退出系统"></a>
                         -->


    </table>
</div>
</body>
<script type="text/javascript" defer="defer">
	function changeSkin(){
		var value = openModal('/pcmc/sm/userSkinModify.jsp?s_time='+(new Date().getTime()), 400, 150);
		if(value!=null)
		 doChangeSkin(value);
	}

	var ajax = new Jraf.Ajax();
	
	
	function doChangeSkin(value){
		
		var params = {
			    sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
		        oprID:      '<sc:fmt type="crypto" value="SkinUtilActor"/>',
		        actions:    '<sc:fmt type="crypto" value="changeSkinname"/>',
		        skinname:   value
		    };
		var url = '/cookieUtil.jsp?skinname='+value;
		ajax.loadPageTo(url,null,'divId');
		
		 ajax.sendForXml('/xmlprocesserservlet', params, function(xml){
		    	window.parent.location.reload();
		    	
		    });
	}
	
</script>

</html>
