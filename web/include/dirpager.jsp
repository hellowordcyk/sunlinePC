<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="org.jdom.*"%>
<table width="100%" border=0  cellspacing="0" cellpadding="5">
<tr height="1" class="toolbar" valign="right" border=0>
		<td valign="bottom" align="left">
<%
    Document xmlDoc = null;
    int recordCount = 0;
    int pageCount   = 0;
    int pageNo      = 0;
    int pageSize    = 15;
    int pager_pageCount =0;
    int pager_pageNo = 0;
    int pager_rcds = 0;
    PkgUtil pkg=null;
    if (request.getAttribute("xmlDoc")!= null)
    {
        xmlDoc = (Document) request.getAttribute("xmlDoc");
        pkg=new PkgUtil(xmlDoc);
        recordCount = pkg.getRspRecordCount();
        pageCount = pkg.getRspPageCount();
        pageNo = pkg.getRspPageNo();
        pageSize = pkg.getRspPageSize();
    }
    
    String pager_dir = request.getParameter("pager_dir");
    if(pager_dir==null) pager_dir="f";
    
    String pager_pageNo_str = request.getParameter("pager_pageNo");
    if(pager_pageNo_str==null) 
    	pager_pageNo=0;
  	else
  		pager_pageNo=Integer.parseInt(pager_pageNo_str);
  		
    String pager_rcds_str = request.getParameter("pager_rcds");
    if(pager_rcds_str==null) 
    	pager_rcds=0;
  	else
  		pager_rcds=Integer.parseInt(pager_rcds_str);

    String pager_pageCount_str = request.getParameter("pager_pageCount");
    if(pager_pageCount_str==null) 
    	pager_pageCount=0;
  	else
  		pager_pageCount=Integer.parseInt(pager_pageCount_str);
  		  		
  	//System.out.println("pager_rcds="+pager_rcds+"recordCount="+recordCount+"pager_dir="+pager_dir);
    if(pager_dir.equalsIgnoreCase("f")){
    	if(recordCount>0 ){
	    	pager_pageNo++;
	    	if(pager_pageNo>pager_pageCount){
		    	pager_rcds+=recordCount;    	
	    		pager_pageCount++;
	    	}
    	}
  	}else{  	
    	if(pager_pageNo>0){
	    	pager_pageNo--;
    	}  		
  	}
    
%>
			<input type="hidden" name="pager_dir" value="<%=pager_dir%>">
			<input type="hidden" name="pager_pageNo" value="<%=pager_pageNo%>">
			<input type="hidden" name="pager_rcds" value="<%=pager_rcds%>">
			<input type="hidden" name="pager_pageCount" value="<%=pager_pageCount%>">
			已查询到<font color='#008000'> <%=pager_rcds%> </font>条记录
			<font color='#008000'> <%=pager_pageCount%> </font>页,
			显示第<font color='#008000'> <%=pager_pageNo%> </font>页
</td>
<td align="right">
<%
if (pager_rcds<pageSize) {
%>
<img src="/images/ICON_PRIOR.gif" alt="上页" align="absmiddle" border=0>
<img src="/images/ICON_NEXT.gif" alt="下页" align="absmiddle" border=0>
<%} else {
    if (pager_pageNo<=1) {
%>
<img src="/images/ICON_PRIOR.gif" alt="上页" align="absmiddle" border=0>
<a href="#" onClick="javascript:nextPage();"><img src="/images/ICON_NEXT.gif" alt="下页" align="absmiddle" border=0></a>
<%  } else if (recordCount<pageSize) {
%>
<a href="#" onClick="javascript:priorPage();"><img src="/images/ICON_PRIOR.gif" alt="上页" align="absmiddle" border=0></a>
<img src="/images/ICON_NEXT.gif" alt="下页" align="absmiddle" border=0>
<%  } else {
%>
<a href="#" onClick="javascript:priorPage();"><img src="/images/ICON_PRIOR.gif" alt="上页" align="absmiddle" border=0></a>
<a href="#" onClick="javascript:nextPage();"><img src="/images/ICON_NEXT.gif" alt="下页" align="absmiddle" border=0></a>
<%
    }
}
%>
</td>
</tr>
</table>
<Script LANGUAGE="JavaScript">
function priorPage()
{
		//document.all.pager_dir.value="b";
    //goPage();
    history.go(-1);
}
function nextPage()
{
		document.all.pager_dir.value="f";
    goPage();
}
function goPage()
{
	document.forms[0].submit();
}
</Script>