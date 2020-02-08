<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/governor/common/common.jsp"%>
<%
	String work_body_top = "/governor/common/work_body_top.jsp";
	String work_body_leftTreeJspStr = "/governor/common/work_body_leftTree.jsp";
%>
<html>

<frameset onload="initframe();" rows="32,*" frameborder="no" border="0" framespacing="0">
  <frame src="<%=work_body_top %>" name="topFrame" frameborder="0" 
        marginheight="0" marginwidth="0" noresize="noresize" scrolling="no">
  <frame src="/governor/common/initPanel.jsp" name="bodyFrame" frameborder="0"
        marginheight="0" marginwidth="0" noresize="noresize" >
</frameset>
<script language="javascript">
function initframe(){
	top.bodyFrame_all.leftFrame.window.location.href = "<%=work_body_leftTreeJspStr %>";
}
</script>
</html>