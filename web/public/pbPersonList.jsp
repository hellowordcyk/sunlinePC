<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.jdom.*" %>
<%@ page import="java.util.*" %>
<%
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    List recordList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildren("Record");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/common.jsp" %>
	<title></title>
</head>

<body>

<form name = "frmList" action="/httpprocesserservlet" method="post">
<select size="20" multiple name="listPerson" style="width: 100%; height: 400px;" >
	<option value="-1">-----------------</option>
	<%
	if (recordList != null &&recordList.size()>0){
   				for (int i=0;i<recordList.size();i++){
       				Element record = (Element)recordList.get(i);
			String usercode = record.getChildTextTrim("usercode");
			String userid = record.getChildTextTrim("userid");
			String username = record.getChildTextTrim("username");
			if (usercode == null || usercode.equals("")){
				%>
				<option value="<%=userid%>"><%=username%></option>
				<%
			}else{
				%>
				<option value="<%=userid%>"><%=username%>[<%=usercode%>]</option>
				<%
			}
		}
	}
	%>
</select>
</form>
</body>
</html>

<script language="JavaScript">
	function add()
	{
		var temp = document.forms[0].menuid.value;
		var menuname = document.forms[0].lab.value;
	    var urlStr = '/oams/pi/pubInfoAdd.jsp?menuid='+temp+'&menuname='+menuname;
	    location.href = urlStr;
	}
	
	function doSearch()
	{
		frmList.submit();
	}
</script>
