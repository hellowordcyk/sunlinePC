<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations"%>
<%@ page import="com.sunline.jraf.util.DatetimeUtil"%>
<%@ page import="com.sunline.jraf.web.Format"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.List"%>
<% request.setCharacterEncoding("UTF-8");
   int count = Integer.parseInt(request.getParameter("count"));
%>
<HTML>
<HEAD>
<TITLE></TITLE>
<link rel="stylesheet" type="text/css" href="../../css/font.css">
</HEAD>
<BODY bgcolor="#E9EAEE">
<table width="100%" border="0" align="left" cellpadding="0" cellspacing="2">
                       <%
	                        Element resultpolicy = PmInformations.getInformations(request.getParameter("infotype"),request.getParameter("size"),"1");
							List recordpolicy = null;
							if(resultpolicy != null)
							{
								recordpolicy  = resultpolicy.getChildren("Record");
							}
							int countpolicy = 0;
							if(recordpolicy != null)
							{
								countpolicy = recordpolicy.size();
							}
							if(countpolicy > 0)
							{
								for(int i = 0 ; i < countpolicy ; i++)
								{
						%>
						<tbody>
                          <tr class="trinfo">
                            <td width="5%" height="10"><img src="../../images/b1.gif" width="5" height="5" alt=""></td>
                            <td width="95%" class="infofont">
							
							</td>
                          </tr>
						</tbody>
                        <%
                           }
					       if(countpolicy < count)
						   {
							   for(int i = 0; i < count-countpolicy; i++)
						    	{
					    %>
						<tbody>
                          <tr class="trinfo">
                            <td width="5%" height="10"><img src="../../images/b1.gif" width="5" height="5" alt=""></td>
							<td>&nbsp;</td>
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
                            <td width="5%" height="10"><img src="../../images/b1.gif" width="5" height="5" alt=""></td>
							<td>&nbsp;</td>
                          </tr>
						  </tbody>
						 <%
								}
							}
						 %>
						 <tr class="trinfo">
                            <td>&nbsp;</td>
                            <td align="right"><img src="../../images/more.gif" width="57" height="13" border="0" alt="" ></td>
                          </tr>
                        </table>
</BODY>
</HTML>
