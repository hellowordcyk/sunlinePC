<%@include file="/governor/common/common.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
	String p_1GifStr = "/common/skins/redstyle/img/p_1.gif";
	String p_2GifStr = "/common/skins/redstyle/img/p_2.gif";
	String AbgGifStr = "/common/skins/redstyle/img/Abg.gif";
	String bg_1_hrGifStr = "/common/skins/tool_mid.jsp/img/bg_1_hr.gif";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script>
function oa_tool(){
    var bodyFrame = window.parent.document.getElementById("oa_frame");
    var frameshow = document.getElementById("frameshow");
    var oa_tree = document.getElementById("oa_tree");
	if (bodyFrame.cols=="0,10,*") {
	    frameshow.src="<%=p_1GifStr %>";
		oa_tree.title="隐藏工具栏";
		bodyFrame.cols="180,10,*";
	}
	
	else{
		frameshow.src="<%=p_2GifStr %>";
		oa_tree.title="显示工具栏";
	    bodyFrame.cols="0,10,*";
	}
}
</script>
<style type="text/css">
<!--
body {
	background-image: url(<%=AbgGifStr %>);
}
-->
</style></head>
<body text="#000000" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" bgcolor="#d80000">
<table width="9" border="0" height="100%" cellpadding="0" cellspacing="0" align="left">
  <tr align="center"> 
    <td background="<%=bg_1_hrGifStr %>" width="10"> 
      <!-- <div id="oa_tree" onclick="oa_tool();" title=隐藏工具栏><br>
        <img id="frameshow" src="<%=p_1GifStr %>" width="9" height="50" ></div> -->
    </td>
  </tr>
</table>
</body>
</html>