<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>PDF显示</title>
</head>
<body scroll="no">

		<p style="margin-top:-45px;margin-bottom:0px;"></p>
		<!-- 通过模板ID查询模板路径信息 -->
       <sc:doPost sysName="funcpub" oprId="examplePdf" action="getPdfTempById" scope="request" var="rspPkg" all="true"></sc:doPost>               
        <!--   OBJECT标签，客户端控件引用    -->   
       <object id="PDFCtrl"  height="600" width="100%" classid="clsid:CA8A9780-280D-11CF-A24D-444553540000">            
  			<param name="SRC" value="<c:out value='${rspPkg.rspRcdDataMaps[0].temppath}' />"/>
            <div style="color:red;text-align:center"><br /><br /><br />
	            本机尚未安装Adobe Acrobat软件，阅读此文档需要Adobe Acrobat 9.0版本软件支持，请安装此软件。</div>
       </object> 
</body>

</html>