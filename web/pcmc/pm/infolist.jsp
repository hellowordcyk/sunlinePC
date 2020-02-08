<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations"%>
<%@ page import="com.sunline.jraf.util.DatetimeUtil"%>
<%@ page import="com.sunline.jraf.web.Format"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="java.util.List"%>
<%@ include file="/public/checkLogin.jsp"%>

<HTML><HEAD><TITLE><%=BimisConf.getSiteName()%></TITLE>
<link rel="stylesheet" type="text/css" href="/css/font.css">
</HEAD>
<BODY style="BACKGROUND-ATTACHMENT: fixed" >
<form action="/pcmc/pm/infolist.jsp">
<input type="hidden" name="infotype" value="<%=request.getParameter("infotype")%>">
<input type="hidden" name="size" value="<%=request.getParameter("size")%>">

<CENTER>
<TABLE cellSpacing=0 cellPadding=0 width=779 border=0>
  <TBODY>
  <TR>
    <TD width=779 height=96>
      <TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
        <TBODY>
        <TR>
          <TD width="30%" height=83><IMG height=75 src="/images/title.gif"
            width=255 alt=""></TD>
          <TD width="70%" height=83>
           </TD></TR></TBODY>
		</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=779 border=0>
  <TBODY>
  <TR>
    <TD width=779 bgColor=#496EB5>&nbsp;</TD></TR>
  </TBODY>
</TABLE>
<TABLE cellSpacing=0 cellPadding=0 width=790 align=center border=0>
  <TBODY>
  <TR>
    <TD height="16">&nbsp;</TD></TR>
  <TR>
    <TD height="42"><IMG height=40 src="/images/t_shkd.gif"
width=411 alt=""></TD></TR></TBODY></TABLE>
<Table cellSpacing=0 cellPadding=2 width=779 border=0>
<TR>
   <TD width="3%">&nbsp;</TD>
   <TD width="3%" style="font-size: 12pt; border-bottom: 1px dashed #aaaaaa"
          align=center height=10>&nbsp;</TD>
   <TD width="70%" style="font-size: 12pt; border-bottom: 1px dashed #aaaaaa"
          align=center height=10>&nbsp;</TD>
   <TD width="8%" style="font-size: 12pt; border-bottom: 1px dashed #aaaaaa"
          align=center height=10>&nbsp;</TD>
   <TD width="20%" style="font-size: 12pt; border-bottom: 1px dashed #aaaaaa"
          align=center height=10>&nbsp;</TD>
</TR>
<TR>
   <TD width="3%" height=10>&nbsp;</TD>
   <TD width="3%" >&nbsp;</TD>
   <TD width="70%">&nbsp;</TD>
   <TD width="4%">&nbsp;</TD>
   <TD width="20%">&nbsp;</TD>
</TR>
<tr>
    <td colspan="5" bgcolor="white">
        <table width="100%" border=0  cellspacing="0">
        <tr align="right">
        <td height="1" align="left" valign="bottom">查询结果：
        <%
			Element resultnews = PmInformations.getInformations(request.getParameter("infotype"),request.getParameter("size"),request.getParameter("PageNo"));
            int recordCount = 0;
            int pageCount   = 0;
            int pageNo      = 0;
            if (resultnews!= null)
            {
                Element pageInfo = resultnews.getChild("PageInfo");
                recordCount = Integer.parseInt(pageInfo.getChildText("RecordCount"));
                pageCount = Integer.parseInt(pageInfo.getChildText("PageCount"));
                pageNo = Integer.parseInt(pageInfo.getChildText("PageNo"));
            }
        %>
        共<font color='#008000'><b> <%=recordCount%> </b></font>条记录，
        第<font color='#008000'><b> <%=pageNo%> </b></font>页，
        共<font color='#008000'><b> <%=pageCount%> </b></font>页。
        </td>
        <input type="hidden" name="PageNo" value="<%=pageNo%>">
        <input type="hidden" name="PageCount" value="<%=pageCount%>">
        <td align="right">
        到<input type="text" name="go" value="" class="inputtext" size=1 customtype="int" displayname="输入页码">页&nbsp;&nbsp;<a href="#" onClick="goPage();"><b>GO</b></a>
        <%
        if ((pageCount==0)||(pageCount==1)) {
        %>
        <img src="/images/ICON_FIRST.gif" alt="首页" align="middle" border=0>
        <img src="/images/ICON_PRIOR.gif" alt="上页" align="middle" border=0>
        <img src="/images/ICON_NEXT.gif" alt="下页" align="middle" border=0>
        <img src="/images/ICON_LAST.gif" alt="末页" align="middle" border=0>
        <%} else {
            if (pageNo==1) {
        %>
        <img src="/images/ICON_FIRST.gif" alt="首页" align="middle" border=0>
        <img src="/images/ICON_PRIOR.gif" alt="上页" align="middle" border=0>
        <a href="#" onClick="javascript:next();"><img src="/images/ICON_NEXT.gif" alt="下页" align="middle" border=0></a>
        <a href="#" onClick="javascript:last();"><img src="/images/ICON_LAST.gif" alt="末页" align="middle" border=0></a>
        <%  } else if (pageNo==pageCount) {
        %>
        <a href="#" onClick="javascript:first();"><img src="/images/ICON_FIRST.gif" alt="首页" align="middle" border=0></a>
        <a href="#" onClick="javascript:prior();"><img src="/images/ICON_PRIOR.gif" alt="上页" align="middle" border=0></a>
        <img src="/images/ICON_NEXT.gif" alt="下页" align="middle" border=0>
        <img src="/images/ICON_LAST.gif" alt="末页" align="middle" border=0>
        <%  } else {
        %>
        <a href="#" onClick="javascript:first();"><img src="/images/ICON_FIRST.gif" alt="首页" align="middle" border=0></a>
        <a href="#" onClick="javascript:prior();"><img src="/images/ICON_PRIOR.gif" alt="上页" align="middle" border=0></a>
        <a href="#" onClick="javascript:next();"><img src="/images/ICON_NEXT.gif" alt="下页" align="middle" border=0></a>
        <a href="#" onClick="javascript:last();"><img src="/images/ICON_LAST.gif" alt="末页" align="middle" border=0></a>
        <%
            }
        }
        %>
        </td>
        </tr>
        </table>
    </td>
</tr>
<TBODY>
		<%
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
                 for(int i = 0; i < countnews; i++)
				{
		%>
                  <tr class="trinfo">
                  <td width="3%">&nbsp;</td>
                  <td width="3%" height="9"><img src="/images/b1.gif" width="5" height="5" alt=""></td>
                  <td width="70%"><a target="_blank" href="info.jsp?infoid=<%=((Element)recordnews.get(i)).getChildTextTrim("infoid")%>"> <%=((Element)recordnews.get(i)).getChildTextTrim("title")%></a></td>
                  <td width="4%" align="right"><img src="/images/new.gif" width="25" height="6" alt=""></td>
	   			<td align="right" width="20%" class="infofont"><%=Format.dateFormat(((Element)recordnews.get(i)).getChildTextTrim("createtime"))%></td>
                </tr>
				</TR>
        <%
			    }
			}
			else
			{
        %>
           <TR>
                <TD width="3%" height=10>&nbsp;</TD>
               <TD width="3%" >&nbsp;</TD>
               <TD width="60%">无信息</TD>
               <TD width="8%">&nbsp;</TD>
                <TD width="24%">&nbsp;</TD>
           </TR>
        <%
			}
        %>
<TR>
   <TD width="3%">&nbsp;</TD>
   <TD width="3%" style="font-size: 12pt; border-bottom: 1px dashed #aaaaaa"
          align=center height=10>&nbsp;</TD>
   <TD width="60%" style="font-size: 12pt; border-bottom: 1px dashed #aaaaaa"
          align=center height=10>&nbsp;</TD>
   <TD width="8%" style="font-size: 12pt; border-bottom: 1px dashed #aaaaaa"
          align=center height=10>&nbsp;</TD>
   <TD width="24%" style="font-size: 12pt; border-bottom: 1px dashed #aaaaaa"
          align=center height=10>&nbsp;</TD>
</TR>
</TBODY>
</TABLE>
<P align=left>&nbsp;</P>
<TABLE cellSpacing=0 cellPadding=0 width=779 border=0>
  <tr>
     <td width="100%" height="10" style="FONT-WEIGHT: normal; FONT-SIZE: 12px; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-VARIANT: normal" align=center><FONT style="FONT-WEIGHT: normal; FONT-SIZE: 11px; LINE-HEIGHT: normal; FONT-STYLE: normal; FONT-VARIANT: normal" face="Verdana, Arial, Helvetica, sans-serif">Copyright &copy; 郑州市商业银行1997 - 2004 </FONT></td></tr>
</TABLE>
</form>
</BODY>
<Script LANGUAGE="JavaScript" type="">
function first()
{
    document.getElementById('PageNo').value=1;
    document.forms[0].submit();
}
function last()
{
    document.getElementById('PageNo').value=document.getElementById('PageCount').value;
    document.forms[0].submit();
}
function prior()
{
    document.getElementById('PageNo').value=parseInt(document.getElementById('PageNo').value)-1;
    document.forms[0].submit();
}
function next()
{
    document.getElementById('PageNo').value=parseInt(document.getElementById('PageNo').value)+1;
    document.forms[0].submit();
}
function goPage()
{
    if (checkForm(document.forms[0]))
    {
        document.getElementById('PageNo').value=document.getElementById('go').value;
        document.forms[0].submit();
    }
}
</Script>
