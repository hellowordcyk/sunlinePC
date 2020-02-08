<%@ page import="sun.misc.BASE64Decoder"%><%@ page import="org.jdom.*"%><%@ page import="com.sunline.jraf.web.SmartUpload"%><%@ page import="com.sunline.jraf.util.Crypto"%><%
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
	if(null != xmlDoc)
    {
    	Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
    	String fileName = record.getChildText("name");
        String sdoc = record.getChildText("downfile");
        BASE64Decoder base64de = new BASE64Decoder();
        byte[] doc = base64de.decodeBuffer(sdoc);
        SmartUpload su = new SmartUpload();
        su.initialize(pageContext);
        su.downloadBytes(doc,null,fileName);
    }
	else
	{
		String fileName = (String)request.getSession().getAttribute("downfilena");
		String realName = (String)request.getSession().getAttribute("realname");
		if(null != fileName)
		{
			SmartUpload su = new SmartUpload();
        	su.initialize(pageContext);
			su.setContentDisposition(null);
			su.setBrowseType(request.getHeader("User-Agent"));
			if (realName == null){
        	su.downloadFile(fileName);
			}else{
				fileName = Crypto.decode(request,fileName) ;
				realName = Crypto.decode(request,realName) ;
        		su.downloadFile(fileName,null,realName);
				request.getSession().removeAttribute("realname");
			}
		}
		request.getSession().removeAttribute("downfilena");
	}
%>