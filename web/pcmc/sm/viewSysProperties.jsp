<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page errorPage="/jsp_error.jsp"%>
<%@ include file="/include/preprocess.jsp"%>
<head>
   <title>系统环境信息</title>
	<LINK href="/css/style.css" type=text/css rel=stylesheet>
	<LINK href="/css/displaytag.css" media="All" type=text/css
		rel=stylesheet>
</head>
<BODY>
<p style="font:large;text-align:center;">系统环境变量(System.getProperties)</p>
<HR style="width:100%">
<display:table uid="roww" name="<%=System.getProperties().entrySet()%>"  class="its" style="width:100%;"/>     
</body>