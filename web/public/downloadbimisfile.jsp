<%@ page buffer = "1kb"%>
<%@page import="com.sunline.jraf.web.SmartUpload"%>
<%@page import="com.sunline.jraf.services.BimisFile"%>
<%@page import="com.sunline.jraf.services.JrafSession"%>
<%@page import="com.sunline.jraf.services.JrafSessionFactory"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" errorPage="/jsp_error.jsp" %>
<%
//page buffer = 0kb时会出错,java.lang.IllegalStateException: getWriter() has already been called for this response
JrafSession jrafsession=null;
try{
	jrafsession = JrafSessionFactory.getInstance(
					JrafSession.BIMIS_SESSION).openSession();					
  String fileid = request.getParameter("fileid");
  BimisFile bf = BimisFile.getInfo(jrafsession,Integer.parseInt(fileid));
  if (bf == null) {
%>
<Script language="JavaScript" >
alert("文件ID不存在");
window.close();
</Script>
<%
    return;
  }
	java.io.InputStream filedata=bf.getFileDataAsStream();
  if (filedata == null) {
  out.println("文件数据已损坏或不存在");
%>
<Script language="JavaScript" >
alert("文件数据已损坏或不存在");
window.close();
</Script>
<%
  return;
  }
  
  response.reset();

  SmartUpload su = new SmartUpload();
  su.initialize(pageContext);  
  su.setBrowseType(request.getHeader("User-Agent"));
  su.downloadFile(filedata, bf.getContentType(), bf.getName(),0);
  filedata.close();
  response.flushBuffer();
} catch (Exception ex) {
	ex.printStackTrace();
}finally{
	if(jrafsession!=null)
			jrafsession.close();
			
}
%>