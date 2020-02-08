<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="com.sunline.bimis.pcmc.util.MenuUtil"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations" %>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%
    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
    Element userInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
    session.setAttribute("userid",userInfo.getChildTextTrim("userid"));
    session.setAttribute("usercode",userInfo.getChildTextTrim("usercode"));
    session.setAttribute("username",userInfo.getChildTextTrim("username"));
    session.setAttribute("deptid",userInfo.getChildTextTrim("deptid"));
    session.setAttribute("deptcode",userInfo.getChildTextTrim("deptcode"));
    session.setAttribute("deptname",userInfo.getChildTextTrim("deptname"));
    session.setAttribute("PageSize",userInfo.getChildTextTrim("pagesize"));
	session.setAttribute("menutype",userInfo.getChildTextTrim("menutype"));
%>
<%
    Document reqXml = HttpProcesser.createRequestPackage("pcmc","sm_query","getUserPcmcSubsys",request);
    Document repXml = SwitchCenter.doPost(reqXml);
    List records = repXml.getRootElement().getChild("Response").getChild("Data").getChildren("Record");
%>    
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td valign="top"><img src="/common/images/pcmc/1_qiege_09.gif" width="153" height="103"></td>
      </tr>
<%
    if (records!=null)
    {
		String url = "";
        for (int i=0;i<records.size();i++)
        {
            Element record = (Element)records.get(i);
			url = "";
			url = record.getChildTextTrim("linkurl") +
                  "?shortname=" + record.getChildTextTrim("shortname") +
                  "&subsysid=" + record.getChildTextTrim("subsysid") +
                  "&cnname=" + record.getChildTextTrim("cnname") +
                  "&roleid=" + record.getChildTextTrim("roleid") +
                  "&rolename=" + record.getChildTextTrim("rolename") +
                  "&pubinfourl=" + record.getChildTextTrim("pubinfourl");
%>
       <tr><td valign="top">
	   <a href="#" onclick="openwin('<%=url%>','<%=record.getChildTextTrim("cnname")%>')"
				onmouseover="changeImages('<%=record.getChildTextTrim("shortname")%>', '<%=record.getChildTextTrim("imgurl")%>-Over.gif'); return true;"
				onmouseout="changeImages('<%=record.getChildTextTrim("shortname")%>', '<%=record.getChildTextTrim("imgurl")%>.gif'); return true;"
				onmousedown="changeImages('<%=record.getChildTextTrim("shortname")%>', '<%=record.getChildTextTrim("imgurl")%>-Over.gif'); return true;"
				onmouseup="changeImages('<%=record.getChildTextTrim("shortname")%>', '<%=record.getChildTextTrim("imgurl")%>-Over.gif'); return true;">
	   <img name="<%=record.getChildTextTrim("shortname")%>" src="<%=record.getChildTextTrim("imgurl")%>.gif" width="153" border="0" alt=""></a></td></tr>

<%
        }
    }
%>
      <tr>
        <td><img src="/common/images/pcmc/1_qiege_24.gif" width="153" height="13"></td>
      </tr>
      <tr>
        <td><img src="/common/images/pcmc/1_qiege_27.gif" width="153" height="1"></td>
      </tr>
      <tr>
        <td><img src="/common/images/pcmc/1_qiege_28.gif" width="153" height="32"></td>
      </tr>
<%
    java.util.List shortCuts = MenuUtil.getMenuShortCuts("",request);
%>
	  <tr>
	      <td bgcolor="#D5E2E9" align="right"><a href="#" onclick="openwin('/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getUserDetail' type='crypto'/>&userid=<%=session.getAttribute("userid")%>&forward=<sc:fmt value='/pcmc/sm/UserShortUpdate.jsp' type='crypto'/>')";><B><font color="red">修改个人信息&nbsp;</font></B></a></td>
	  </tr>
<%
    if (shortCuts != null)
    {
        for (int i=0;i<shortCuts.size();i++)
        {
            Element shortCut = (Element)shortCuts.get(i);
%>
        <tr bgcolor="#D5E2E9" align="right"><td><a href="#" onclick="openwin('<%=Crypto.encodeUrl(request,shortCut.getChildTextTrim("linkurl"))%>')"><%=shortCut.getChildTextTrim("menuname")%>&nbsp;</a></td></tr>
<%
        }
    }
%>
    </table>
