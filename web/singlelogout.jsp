<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	session.invalidate();
%>
<html>
<head>
</head>
<body>
<div style="margin: 15px; width: 100%; height: 200px; line-height: 200px; text-align: center; font-weight: bold;">
    用户无权限或会话已失效！
</div>
</body>
<script type="text/javascript">
//if(confirm("用户无权限或会话已失效， 确定要关闭窗口吗？")) {
    if(window.top != window.self){
        window.top.close();
    }else{
        window.close();
    }
//}
</script>
</html>