<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.List"%>
<% request.setCharacterEncoding("UTF-8");
   int count = Integer.parseInt(request.getParameter("count"));
	StringBuffer urlDetail = new StringBuffer();
	String infotype = request.getParameter("infotype");
	String infoname = request.getParameter("infoname");
    urlDetail.append("/httpprocesserservlet?sysName=").append(Crypto.encode(request,"oams"))
        .append("&oprID=").append(Crypto.encode(request,"pi_issu"))
        .append("&actions=").append(Crypto.encode(request,"qryInfosOfList"))
        .append("&sortfld=").append("00")
        .append("&forward=").append("/oams/pi/pubInfoQryDetail.jsp")
		.append("&menuid=").append(infotype).append("&lab=").append(infoname);

%>
<HTML>
<HEAD>
<TITLE> New Document </TITLE>
<link rel="stylesheet" type="text/css" href="../../css/font.css">
</HEAD>

<BODY bgcolor="#FFFFFF">
<table width="100%" heigth="10%" border="0" cellspacing="0" cellpadding="2">
		<%
			Element resultnews = PmInformations.getInformations(request.getParameter("infotype"),request.getParameter("size"),"1");
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
			             <tbody>
                          <tr class="trinfo">
                            <td width="3%">&nbsp;</td>
                            <td width="3%" height="9"><img src="../../images/b1.gif" width="5" height="5" alt=""></td>
                            <td width="60%"><a title="<%=elt.getChildTextTrim("title")%>" target="_blank" href="info.jsp?infoid=<%=elt.getChildTextTrim("infoid")%>">
							<%=Format.formatTitle(21,elt.getChildTextTrim("title"))%></A></td>
                            <%if (iDays > 1){%>
								<td width="8%"></td>
                            <%}
							else{%>
                            	<td width="8%"><img src="../../images/new.gif" width="25" height="6" alt=""></td>
							<%}%>
							<td align="left" width="24%" class="infofont"><%=Format.dateFormat(elt.getChildTextTrim("createtime"))%></td>
                          </tr>
						  </tbody>
            <%
                }
				if(countnews < count)
				{
					for(int i = 0; i < count-countnews; i++)
				{
			%>
			              <tbody>
                          <tr class="trinfo">
                            <td width="3%">&nbsp;</td>
                            <td width="3%" height="9"><img src="../../images/b1.gif" width="5" height="5" alt=""></td>
                            <td width="60%"></td>
                            <td width="8%"></td>
							<td align="left" width="24%"></td>
                          </tr>
						  </tbody>
			<%
				}
				}
				}
				else
				{
				    for(int i =0 ;i < count; i++)
				{
			%>
			              <tbody>
                          <tr class="trinfo">
                            <td width="5%">&nbsp;</td>
                            <td width="5%" height="9"><img src="../../images/b1.gif" width="5" height="5" alt=""></td>
                            <td width="60%"></td>
                            <td width="8%"></td>
							<td align="left" width="24%"></td>
                          </tr>
						  </tbody>
			<%
				}
				}
			%>
						 <tr class="trinfo">
                            <td></td>
                            <td></td>
                            <td></td>
							<td></td>
                            <td><a target="_blank" href="infolist.jsp?infotype=<%=request.getParameter("infotype")%>&size=10&PageNo=1"><img src="../../images/more.gif" width="57" height="13" border="0" alt=""></a></td>
                          </tr>
</table>

</BODY>
</HTML>
