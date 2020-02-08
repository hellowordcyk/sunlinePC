<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page buffer="10kb"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.SmartUpload"%>
<%@ page import="com.sunline.jraf.util.FileUtil"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="java.io.*"%>
<%   String fileName=null;
    String filePath=null;
    String sPath =null;
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    String decodeFlag = request.getParameter("decodeFlag");
    String deleteFlag = request.getParameter("deleteFlag");
    if(null != xmlDoc)
    {
        Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data");
        filePath = record.getChildText("filepath");
        fileName = record.getChildText("filename");
    }else{
	   filePath = request.getParameter("filepath");
       fileName = request.getParameter("filename");
       if(decodeFlag != null && decodeFlag.equals("true") ){
    	   if(!(null==fileName||"".equals(fileName)))
    	   {
               fileName = java.net.URLDecoder.decode(fileName, "UTF-8");        
    	   }
    	   if(!(null==filePath||"".equals(filePath)))
    	   {
        	   filePath = java.net.URLDecoder.decode(filePath, "UTF-8");
        	   //System.out.print("ttt"+filePath);
    	   }
       }
    }
    if(!(filePath==null||"".equals(filePath)))
    {
    	sPath = filePath;
    }else{
        sPath = FileUtil.getHomePath() + "data" + File.separator+fileName;     
    }
        response.reset();
        SmartUpload su = new SmartUpload();
        su.initialize(pageContext);
        su.setContentDisposition(null);
        if(fileName!=null){
       		final String userAgent = request.getHeader("USER-AGENT");
	       	if(StringUtils.contains(userAgent, "MSIE")){//IE
	       		fileName = URLEncoder.encode(fileName,"UTF8");
	     	}else if(StringUtils.contains(userAgent, "Mozilla")){//google,FF
	     		fileName = new String(fileName.getBytes(), "ISO8859-1");
	      	}else{
	      		fileName = URLEncoder.encode(fileName,"UTF8");//other
	        }
	        su.downloadFile(sPath, null, fileName);
	    }else{
        	su.downloadFile(sPath);
	    }
        response.flushBuffer();
        out.clear();
        out = pageContext.pushBody();
    if ("true".equals(deleteFlag)) {
	    //FileUtil.deleteFile(sPath);  
	} 
%>

