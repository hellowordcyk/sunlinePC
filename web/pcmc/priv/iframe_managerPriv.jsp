<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
    <%@ include file="/common.jsp" %>
</head>
<body> 
<iframe name='priv_manager_frame' id="priv_manager_frame" 
src='/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="privActor"/>&actions=<sc:fmt type="crypto" value="queryPrvBase"/>&forward=<sc:fmt value='/pcmc/priv/privMain.jsp' type='crypto'/>' width="99%" height="99%" frameborder="0" scrolling="no">


	<h1>${linkurl }</h1>
</iframe>
</body>
</html>