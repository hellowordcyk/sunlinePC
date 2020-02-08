<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@page import="com.sunline.jraf.services.*"%>
<%@page import="com.sunline.jraf.conf.bimis.*"%>
<%
com.sunline.jraf.web.RequestParamUtil rpu=null;
if(session.getAttribute("encoding")==null
    ||((String)session.getAttribute("encoding")).length()==0){
    rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, "UTF-8");
}else{
    rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, (String)session.getAttribute("encoding"));
}
PortalConf pc = PortalConf.getInstance();
String url = "";
try {
    url = pc.getLoginUrl();
    if (url == null || "".equals(url)) {
        url = "/index.jsp";
    } else {
        url = pc.getLoginUrl();
    }
} catch (Exception e) {
    e.printStackTrace();
}
%>
<%
PkgUtil reqpkg = null;
if(rpu.getXmlDoc()!=null){
    reqpkg=new PkgUtil(rpu.getXmlDoc());
}
String referer = rpu.getString("referer", request.getHeader("referer"));
if(referer == null || referer.equals("")) {
    referer = "index.jsp";
}
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
      <title>错误</title>
      <%-- <%@include file="/common.jsp" %> 先注释，否则后台抛异常后，JSP会挂掉，必须F5刷新页面才行--%>
      <meta http-equiv="pragma" content="no-cache">
      <meta http-equiv="Cache-Control" content="no-cache, must-revalidate">
      <meta http-equiv="expires" content="0">
      <link rel="stylesheet" type="text/css" href="/jui/themes/css/jraf.css">
</head>
<body>
    <div class="warning-content">
         <div class="warning-form">
             <div class="warning-form-top">
                 <div class="warning-info"></div>
                 <div class="warning-text">
                     <span class="warning">发生错误了</span>
                     <br/>应答码[<%=reqpkg.getResult()%>],出错信息为： 
                     <%
                        Iterator hints=reqpkg.getHintMsg().iterator();
                        while(hints.hasNext()){
                            String hintmsg= (String)hints.next();
                    %>
                     <p><%=hintmsg%></p>
                    <%
                        }
                        Iterator errmsgs=reqpkg.getErrorMsg().iterator();
                        while(errmsgs.hasNext()){
                            String errmsg= (String)errmsgs.next();
                    %>
                      <p><%=errmsg%></p>
                    <%
                        }
                    %>
                 </div>
                 <div class="warning-button">
                     <input class="button" type="button" value="重新登录" onclick="loginAgain();"/>
                     <!-- <input class="button" type="button" value="返回原界面检查" onclick="javascript:window.history.back();"/> -->
                 </div>
             </div>
         </div>
    </div>
</body>
<script type="text/javascript">
function loginAgain() {
    if(window.top != window.self){
        window.top.location.href='<%=url%>';
    }else{
        window.location.href='<%=url%>';
    }
}
</script>
</html>
    