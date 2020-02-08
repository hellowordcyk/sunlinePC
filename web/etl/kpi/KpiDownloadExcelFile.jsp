<%@page import="com.sunline.jraf.util.FileUtil"%>
<%@page import="java.io.*"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.io.PrintWriter"%>
<%@page import="org.jdom.*"%>
<%
	String filename = null;
	String filepath = null;
	String decodeFlag = request.getParameter("decodeFlag");
    String deleteFlag = request.getParameter("deleteFlag");
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    if(null != xmlDoc){
    	Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data");
        filepath = record.getChildTextTrim("filepath");
        filename = record.getChildTextTrim("filename");
    }else{
    	filepath = request.getParameter("filepath").trim();
    	filename = request.getParameter("filename").trim();
    	if(decodeFlag != null && decodeFlag.equals("true") ){
     		if(!(null==filename||"".equals(filename))){
     			filename = java.net.URLDecoder.decode(filename, "UTF-8");        
     		}
     	    if(!(null==filepath||"".equals(filepath))){
     			filepath = java.net.URLDecoder.decode(filepath, "UTF-8");
     	    }
        }
    }
    if(filepath==null||"".equals(filepath)){
    	response.setContentType("text/html;charset=UTF-8"); 
   	    request.setCharacterEncoding("UTF-8"); 
   	    response.setCharacterEncoding("UTF-8");
   	    PrintWriter myout = response.getWriter();
    	myout.print("下载路径不能为空");
    	myout.close();
    	return;
    }
    File file = new File(filepath);
    if(!file.exists()){
    	response.setContentType("text/html;charset=UTF-8"); 
   	    request.setCharacterEncoding("UTF-8"); 
   	    response.setCharacterEncoding("UTF-8");
   	    PrintWriter myout = response.getWriter();
    	myout.print(filepath+" 文件不存在");
    	myout.close();
    	return;
    }
    if(filename==null||"".equals(filename)){
    	filename = file.getName();
    }
    
    InputStream inStream = new FileInputStream(file);// 文件的存放路径
    
    response.reset();
    //response.setContentType("bin");
    response.setContentType("application/x-msdownload");
    response.setHeader("Content-Disposition","attachment;filename="+new String(filename.getBytes("GBK"),"ISO-8859-1"));
    ServletOutputStream sos = response.getOutputStream();
    byte[] b = new byte[1024];
    int len;
    try {
        while ((len = inStream.read(b)) > 0)
            sos.write(b, 0, len);
        inStream.close();
        sos.flush();
        sos.close();
        out.clear();
        out = pageContext.pushBody();
        out.clearBuffer();
        out.close();
    } catch (IOException e) {
        e.printStackTrace();
    }
    if ("true".equals(deleteFlag)) {
	    //FileUtil.deleteFile(file.getAbsolutePath());  
	}
%>