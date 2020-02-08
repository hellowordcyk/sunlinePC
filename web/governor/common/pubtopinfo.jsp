<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%-- <%
	String initname = request.getParameter("initname");
%> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/governor/common/common.jsp"%>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <Meta http-equiv="Pragma" Content="No-cach">
    <Meta http-equiv="Expires" Content="0">
    <title></title>
    <link href="<%=contextPathStr + skinCssPath %>/style_new.css" type="text/css" rel="stylesheet">
</head>
<body topMargin=0 leftmargin="0" rightmargin="0">
<table width="100%" height="51" cellpadding="0" cellspacing="0" border="0">
    <tr>
        <td  colspan="2">
            <table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" class="headerbg">
                <tr>
                    <td align="left"><img src="<%=contextPathStr + skinImgPath %>/sunline-logo.gif" ></td>
                    
                    <td style='margin-top: 0'>
					  
					</td>
                    <td align="right" valign="top" style="padding:0;">
                        <div class="topbar" style="width:300px; padding-top: 3px; background-image: url(/common/skins/outlook/images/index/top/header-topbarbg.png);">
                            <span style="height: 18px;"></span> 
                            <span  class="help"><a href="#" onclick="alert('暂无帮助')">帮助</a></span> 
                            <span  class="logout">
                                <a href="#" onclick="parent.window.location='/governor'">注销</a>
                            </span> 
                            <br/>
                            <span  class="user" style="padding-top: 8px; display: inline-block; margin-bottom: 0px; padding-right: 0px;">欢迎您，<b><c:out value='${param.initname }' /></b></span>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</body>
</html>
