<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	long timenum = new java.util.Date().getTime();

	String work_body_top = "work_body_top.jsp?s_time="+timenum;
	String work_body_leftTreeJspStr = "work_body_leftTree.jsp";
%>
<html>
<%@include file="/common.jsp"%>
<frameset rows="32,*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=work_body_top %>" name="topFrame" frameborder="0" 
        marginheight="0" marginwidth="0" noresize="noresize" scrolling="no">
  <frame src="initPanel.jsp" name="bodyFrame" frameborder="0"
        marginheight="0" marginwidth="0" noresize="noresize" >
<!--   <frame src="initPanel.jsp" name="bodyFrame" frameborder="0"
        marginheight="0" marginwidth="0" noresize="noresize" > -->
</frameset>
</html>