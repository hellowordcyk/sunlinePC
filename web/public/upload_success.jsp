<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="/common.jsp" %>
</head>
<body>
<div id="info">
<sc:showrsmsg/>
</div>
</body>
<script type="text/javascript">
    var oWindow = parent;
    if (oWindow) {
        var oUpload = oWindow.$$("input[name='${param.button}']")[0];
        oUpload.disabled = false;
        oWindow.uploadCallBack($("info").innerHTML);
    }
</script>
</html>
