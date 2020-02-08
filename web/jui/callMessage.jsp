<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%
		    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
			String   statusCode = "";
			String      message = "";
			String     navTabId = "";
			String callbackType = "";
			String   forwardUrl = "";
			String   		rel = "";
			String      retData = "";
			if(null != xmlDoc)
			{
				  statusCode = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildTextTrim("retCode");
			         message = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildTextTrim("retMessage");
			        navTabId = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildTextTrim("navTabId");
			    callbackType = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildTextTrim("callbackType");
			      forwardUrl = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildTextTrim("forwardUrl");
			             rel = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildTextTrim("rel");
			         retData = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildTextTrim("retData");
			}else
			{
			      statusCode = request.getParameter("retCode");
			         message = request.getParameter("retMessage");
			        navTabId = request.getParameter("navTabId");
			    callbackType = request.getParameter("callbackType");
			      forwardUrl = request.getParameter("forwardUrl");
			             rel = request.getParameter("rel");
			         retData = request.getParameter("retData");
			}	

		    if(statusCode==null||statusCode.equals(""))
		    {
		    	statusCode = "200";
		    }
		    if(message==null||message.equals(""))
		    {
		    	message = "未知操作！";
		    }
		    if(navTabId==null)
		    {
		    	navTabId = "";
		    }
		    if(callbackType==null)
		    {
		    	callbackType = "";
		    }
		    if(forwardUrl==null)
		    {
		    	forwardUrl = "";
		    }
		    if(rel==null)
		    {
		    	rel = "";
		    }
		    if(retData==null)
		    {
		        retData = "";
		    }
 %>
{
	"statusCode":"<%=statusCode %>",
	"message":"<%=message %>",
	"navTabId":"<%=navTabId %>",
	"rel":"<%=rel %>",
	"callbackType":"<%=callbackType %>",
	"forwardUrl":"<%=forwardUrl %>",
	"confirmMsg":"",
	"retData":"<%=retData %>"
}






