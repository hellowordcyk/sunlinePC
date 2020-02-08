<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String tool_midJspStr = "/governor/common/tool_mid.jsp";
    String work_body_rightStr = "/governor/common/work_body_right.jsp";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title></title>
    <%@include file="/governor/common/common.jsp"%>
</head>
<frameset rows="*" cols="230,10,*" framespacing="0" frameborder="no" border="0" id="oa_frame">
	<!-- work_body_leftTreeJspStr 的赋值操作放在 work_body_right中,避免出现对象找不到的情况 -->
	<frame src="" name="leftFrame" noresize="noresize">
	<frame src="<%=tool_midJspStr %>" scrolling="no" name="middleqwe" noresize="noresize">
	<frame src="<%=work_body_rightStr %>" name="rightFrame" noresize="noresize">
</frameset>
</html>