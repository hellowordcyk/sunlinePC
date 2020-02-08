<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.sunrpt.report.ExportReport" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>报表导出</title>
</head>
<%
    String rptuid=request.getParameter("rptuid");
    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
    
    List<Element> expReportBaseInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildren("expReportBaseInfo");
    
    List<Element>  expReportPropertyList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("expReportPropertyList").getChildren("Record");
    
    List<Element> expReportHeaderList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("expReportHeaderList").getChildren("Record");
    
    //Element downDataEle = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("downDataList");

    ExportReport.beginExport(rptuid,expReportBaseInfo,expReportPropertyList,expReportHeaderList,response);
    out.clear();
    out = pageContext.pushBody();
%>
<body scroll="no">

</body>
</html>