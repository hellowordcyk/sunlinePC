<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
    <%@ include file="/common.jsp" %>
</head>
<body bgcolor="#ffffff">
<div class="warning-content">
    <div class="warning-form">
        <div class="warning-form-top">
            <div class="warning-info"></div>
            <div class="warning-text">
                <span class="warning">JSP页面出错</span>
                <br/>发现一个页面错误. 错误信息是: <%= exception==null?"null":exception.toString() %>
                <br/>调用堆栈 : 
                <pre>
                    <font color="red">
                    <%
                     if(exception!=null){
                     java.io.CharArrayWriter cw = new java.io.CharArrayWriter(); 
                     java.io.PrintWriter pw = new java.io.PrintWriter(cw,true); 
                     exception.printStackTrace(pw); 
                     out.println(cw.toString()); 
                     }
                     %> 
                    </font>
                 </pre>
            </div>
        </div>
    </div>
</div>
</body>
</html>
