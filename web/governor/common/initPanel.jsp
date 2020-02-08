<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- <%@include file="/governor/common/common.jsp"%>
<%
	String bodyJpg = skinPath +"/images/body.jpg";
	
%>
<html>
<head>
<title>Title</title>
</head>
<body margin="0" leftmargin="0" topmargin="0" >
<!--  
<img src="<%=bodyJpg %>" width="100%" height="99%" />
-->
</body>
</html>--%>

<%
	String subsysid = request.getParameter("subsysid");
	String s_time = request.getParameter("s_time");
	if (subsysid==null) {		
		response.sendRedirect("/governor/monitor/systemInfo.jsp?s_time="+s_time);
	}else{
		if (subsysid.equals("2")){
			response.sendRedirect("/governor/datasource/connpool.jsp?s_time="+s_time);
		}else if (subsysid.equals("3")){
			response.sendRedirect("/governor/provider/dsprovider.jsp?s_time="+s_time);
		}else if (subsysid.equals("4")){
			response.sendRedirect("/governor/filestore/temppath.jsp?s_time="+s_time);
		}else if (subsysid.equals("5")){
			response.sendRedirect("/governor/basicinfo/basicinfo.jsp?s_time="+s_time);
		}else if (subsysid.equals("6")){
			response.sendRedirect("/governor/download/logDownload.jsp?s_time="+s_time);
		}else if (subsysid.equals("7")){
			response.sendRedirect("/governor/maintain/tableMaintain.jsp?s_time="+s_time);
		}else if(subsysid.equals("8")){
			response.sendRedirect("/governor/sqlmonitor/sqlmonitor.jsp?s_time="+s_time);
		}else{
			response.sendRedirect("/governor/monitor/systemInfo.jsp?s_time="+s_time);
		}
	}
%>