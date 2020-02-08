<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.List"%>
<% request.setCharacterEncoding("UTF-8");
	int count = Integer.parseInt(request.getParameter("count"));
	String userid = request.getParameter("userid");
	String infotype = request.getParameter("infotype");
	String infoname = request.getParameter("infoname");
	StringBuffer urlDetail = new StringBuffer();
	urlDetail.append("/httpprocesserservlet?sysName=").append(Crypto.encode(request,"oams"))
			.append("&oprID=").append(Crypto.encode(request,"pi_issu"))
			.append("&actions=").append(Crypto.encode(request,"getInfosOfList"))
			.append("&sortfld=").append("00")
			.append("&forward=").append("/oams/pi/pubInfoQryIndex.jsp")
			.append("&menuid=").append(infotype).append("&lab=").append(infoname);
%>

<html>
<body topMargin=0>
<link rel="stylesheet" type="text/css" href="../../css/font.css">

<table width="100%" border="0" cellspacing="0" cellpadding="2" class="defaultTable">
	<%
			Element resultnews = PmInformations.getPersonInformations(userid,request.getParameter("infotype"),
					request.getParameter("size"),"1");
			List recordnews = null;
			if(resultnews != null)
			{
			recordnews = resultnews.getChildren("Record");
			}
			int countnews = 0;
			if(recordnews != null)
			{
			countnews = recordnews.size();
			}
			if(countnews > 0)
			{
			for(int i = 0 ; i < countnews ; i++)
			{
			Element elt = (Element)recordnews.get(i);
			String days = elt.getChildTextTrim("days");
			int iDays = Integer.parseInt(days);
			%>

	<tr class="trinfo">
		<td width="4%" height="9"><img src="../../images/b1.gif" width="5" height="5" alt=""></td>
		<td><a title="<%=((Element)recordnews.get(i)).getChildTextTrim("title")%>" target="_blank"
			href="info.jsp?infoid=<%=((Element)recordnews.get(i)).getChildTextTrim("infoid")%>">
			<%=Format.formatTitle(50,((Element)recordnews.get(i)).getChildTextTrim("title"))%></a>
		</td>
		<%if (iDays > 1){%>
		<td width="5%"></td>
		<%}
			else{%>
		<td align="right" width="5%"><img src="../../images/new.gif" width="25" height="6" alt=""></td>
		<%}%>
		<td align="right" width="15%" class="infofont">
		<%=Format.dateFormat(((Element)recordnews.get(i)).getChildTextTrim("createtime"))%>
		</td>
	</tr>
	<%
			}
			}
		else{
			%>
	<tr class="trinfo" valign="top">
		<td width="4%" height="9"></td>
		<td></td>
		<td width="5%"></td>
		<td align="right" width="15%"></td>
	</tr>
	<%
			}
			%>
</table>
</body>
</html>
