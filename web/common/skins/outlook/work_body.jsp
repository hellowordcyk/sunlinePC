<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	long timenum = new java.util.Date().getTime();

    String work_body_leftTreeJspStr = "work_body_leftTree.jsp?s_time="+timenum;
    String tool_midJspStr = "tool_mid.jsp?s_time="+timenum;
    String work_body_rightStr = "work_body_right.jsp?s_time="+timenum;
    
%>
<html>
<head>
<title></title>
<%@include file="/common.jsp"%>
<script type="text/javascript">
function init() {
	//第一次初始化二级菜单或刷新菜单
	top.frames("topFrame").g_JrafMenu.refreshCurrentMenu();
}
</script>
</head>
<frameset onload="init();" rows="*" cols="18%,10,*" framespacing="0" frameborder="no" border="0" id="oa_frame">
	<frame src="<%=work_body_leftTreeJspStr %>" name="leftFrame" >
	<frame src="<%=tool_midJspStr %>" scrolling="no" name="middleqwe" noresize="noresize">
	<frame src="<%=work_body_rightStr %>" name="rightFrame" noresize="noresize">
</frameset>
</html>