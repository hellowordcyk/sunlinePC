<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="org.jdom.*" %>
<%
	String subsysid = "";
    String menuid = "";
    String pmenuid = "";
    String menuname = "";

    String opttype = request.getParameter("opttype");
    subsysid = request.getParameter("subsysid");
    pmenuid = request.getParameter("pmenuid");
    menuname = request.getParameter("menuname");
    if("add".equals(opttype))
    {
        Document xmlDoc = (Document) request.getAttribute("xmlDoc");
	    Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
        menuid = record.getChildText("menuid");
    }
    else
    {
        menuid = request.getParameter("menuid");
    }
	Document xmlDoc1 = (Document) request.getAttribute("xmlDoc");
	String result1 = "";
	if (xmlDoc1 != null)
	{
		Element record1 = xmlDoc1.getRootElement().getChild("Response");
		result1 = record1.getAttributeValue("result");
		
	}

    
%>
<html>
<head>
</head>
<LINK href="/css/style.css" type="text/css" rel="stylesheet">
<BODY  background="/images/background.gif" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; MARGIN: 0px; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none" bgColor=#ffffff>
<%@ include file="/public/checkLogin.jsp"%>
<form name="form1" method="POST">
<table width="99%" border="0" align="center" cellpadding="4" cellspacing="0">

</table>
</form>
</body>
</html>
<script language="JavaScript">


	<%
		if (request.getAttribute("ERROR_TEXT")!=null)
		{				
	%>
			
		alert("<%=request.getAttribute("ERROR_TEXT")%>");
	<%
		}
	%>
	


	<%
		if (!"1".equals(result1))
		{
	%>
				<%
					if("add".equals(opttype))
					{
				%>
					window.parent.execScript('addNewItem("<%=pmenuid%>","<%=menuid%>","<%=subsysid%>","<%=menuname%>");');
				<%
					}
					else if("edit".equals(opttype))
					{
				%>
					window.parent.execScript('delItem("<%=menuid%>","<%=subsysid%>");');
				    window.parent.execScript('addNewItem("<%=pmenuid%>","<%=menuid%>","<%=subsysid%>","<%=menuname%>");');
				<%
					}
					else if("del".equals(opttype))
					{
				%>
					window.parent.execScript('delItem("<%=menuid%>","<%=subsysid%>");');
				<%
					}
				%>
	<%	
		}
	%>

		




</script>
