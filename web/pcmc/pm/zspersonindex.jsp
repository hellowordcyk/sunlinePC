<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="com.sunline.bimis.pcmc.util.MenuUtil"%>
<%@ page import="com.sunline.bimis.pcmc.pm.PmInformations" %>
<%@ page import="org.jdom.*"%>
<%@ page import="java.util.List"%>
<%
    System.out.println( request.getParameter("usercode"));
    Document reqXml = HttpProcesser.createRequestPackage("pcmc","sm_zs","zslogin",request);
	Element userElem = new Element("usercode");
    userElem.setText(request.getParameter("usercode"));
    reqXml.getRootElement().getChild("Request").getChild("Data").addContent(userElem);


    Document xmlDoc = SwitchCenter.doPost(reqXml);
	System.out.println("ddddddddddddddddddd");

	request.setAttribute("xmlDoc",xmlDoc);
    request.getRequestDispatcher("/pcmc/pm/personindex.jsp").forward(request,response);
//    response.sendRedirect("/pcmc/pm/personindex.jsp");

%>