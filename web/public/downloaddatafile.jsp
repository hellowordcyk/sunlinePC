<%@ page buffer="10kb"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.SmartUpload"%>
<%@ page import="com.sunline.jraf.util.FileUtil"%>
<%@ page import="java.io.*"%>
<%  String fileName=null;
    String filePath=null;
    String sPath =null;
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    //�����־
    String decodeFlag = request.getParameter("decodeFlag");
    //ɾ����־: Ϊtrueʱ����ɾ���ļ���������
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
    	   }
       }
    }
    if(!(filePath==null||"".equals(filePath)))
    {
    	sPath = filePath;
    }else{
        sPath = FileUtil.getHomePath() + "data" + File.separator+fileName;     
    }
    if (!"true".equals(deleteFlag)) {
        response.reset();
        SmartUpload su = new SmartUpload();
        su.initialize(pageContext);
        //���õ���������Ƿ��Զ���������Ի���
        su.setContentDisposition(null);
        su.downloadFile(sPath);
        su.setBrowseType(request.getHeader("User-Agent"));
        response.flushBuffer();
        out.clear();
        out = pageContext.pushBody();
    }
   // FileUtil.deleteFile(sPath);  //ɾ���ļ�(���ش��ڣ�ѡ��ȡ�������ж����أ��ļ���ɾ������)
%>