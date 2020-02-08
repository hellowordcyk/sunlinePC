<%@page import="net.sf.json.JSONArray"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.List"%>
<%@ page import="com.sunline.jraf.util.*"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    

  </head>
  
  <body>
<%
	Document doc = (Document)request.getAttribute("xmlDoc");
	Element root = doc.getRootElement();//获得根元素element

    StringBuffer bf = new StringBuffer();
    List<Element> list = root.getChild("Response").getChild("Data").getChildren("Record");
    
    for(Element user:list){
    	String username = user.getChildTextTrim("USERNAME");
    	String usercode = user.getChildTextTrim("USERCODE");
    	String userid = user.getChildTextTrim("USERID");
    	String deptid = user.getChildTextTrim("DEPTID");
    	bf.append("<p id=\"un"+userid+"\"").append(" onclick=\"unSelectedUserClick('"+deptid+"','"+userid+"','"+usercode+"','"+username+"')\" >");
    	bf.append("["+usercode+"]"+username).append("</p>");
    }
   
    System.out.println("***"+bf.toString());
    response.setHeader("Content-Type","text/xml; charset=utf-8");
    PrintWriter out1 = null;
    out1 = response.getWriter();
    out1.print(bf.toString());
    out1.flush();
    out1.close();
 %>
  </body>
</html>
