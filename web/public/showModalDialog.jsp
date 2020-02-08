<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/common.jsp" %>
    <title>模式窗口</title>
    <style type="text/css">
        html, iframe html, iframe body{
            overflow-x: hidden;
            overflow-y: hidden;
        }
        
    </style>
</head>
<body style="overflow: hidden;">
    <iframe name="mainIframe" frameborder="0" scrolling="yes" marginheight="0" marginwidth="0" src=""></iframe>
</body>
<script type="text/javascript">
document.observe("dom:loaded", function () {
    new Jraf.DimensionsAuto(window, "iframe");
    
    var args = window.dialogArguments;
    if (args && args.url) {
        var oIframe = $$("iframe")[0];
        var argHash = $H(args);
        argHash.unset("url");
        var params = argHash.toQueryString();
        if (params != null && params != "") {
            params += "&s_item=" + (new Date().getTime());
        } else {
            params += "s_item=" + (new Date().getTime());
        }
        var url = args.url;
        url = (url.indexOf("?") != -1)?url: url+"?";
        oIframe.src = url+ "&" + params;
        if (args.title) {
            document.title = args.title;
        }
    }
});
</script>
</html>