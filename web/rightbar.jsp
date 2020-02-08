<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="com.sunline.bimis.pcmc.util.MenuUtil"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations" %>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.*"%>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><img src="/common/images/pcmc/1_qiege_12.gif" width="158" height="122"></td>
      </tr>
      <tr>
        <td><img src="/common/images/pcmc/1_qiege_16.gif" width="158" height="37"></td>
      </tr>
      <tr>
        <td valign="top" width="158"><iframe width="158" height="30" frameborder=0 scrolling=no  src="/pcmc/pm/gethavemessage.jsp"></iframe></td>
      </tr>
      <tr>
        <td valign="top" width="158" align="center" height="120"><iframe width="158" height="100%" frameborder=0 scrolling=no  src="/pcmc/pm/pendjob.jsp"></iframe></td>
      </tr>
      <tr>
        <td><img src="/common/images/pcmc/1_qiege_31.gif" width="158" height="43"></td>
      </tr>
	  <tr>
	     <td width="158">
              <table border="1" width="100%" bordercolorlight="#A0AAB4" cellspacing="0" height="100%" bordercolor="#C0C0C0" bordercolordark="#C0C0C0">
			  <tbody>
<%
    java.util.List frdlinkList = PmInformations.getFrdlink();
    if ((frdlinkList!=null)&&(frdlinkList.size()>0))
    {
        for (int i=0;i<frdlinkList.size();i++)
        {
            Element record = (Element)frdlinkList.get(i);
%>
                <tr class="trinfo">
                  <td width="100%" height="48" valign="top"><a href='<%=record.getChildTextTrim("linkurl")%>' target=_blank"><img border="0" src="<%=record.getChildTextTrim("imgurl")%>" width="152" height="48"></a></td>
                </tr>
<%
        }
    }
%>
			  </tbody>
              </table>
         </td>
	   </tr>
    </table>
