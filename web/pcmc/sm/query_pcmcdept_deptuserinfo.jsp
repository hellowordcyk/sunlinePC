<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <%@ include file="/common.jsp" %>
</head>
<body>
 <iframe name='query_form' id="dept_userinfo" src="/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc" />
&oprID=<sc:fmt type="crypto" value="sm_query" />
&actions=<sc:fmt type="crypto" value="getDeptUsers" />&deptid=${param.deptid}&forward=<sc:fmt value='/pcmc/sm/query_pcmcdept_depuserinfoproc.jsp' type='crypto'/>" width="99.9%" height="100%" frameborder="0" scrolling="no">
</iframe>
</body>
</html>
