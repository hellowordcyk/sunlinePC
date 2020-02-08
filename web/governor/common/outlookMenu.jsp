<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/governor/common/common.jsp"%>
<%
    //String pubinfourl = request.getParameter("pubinfourl");
    String top_bgGifStr = skinPath +"/img/top_bg.gif";
    String work_bodyJspStr = "/governor/common/work_body.jsp";
    String maincss = skinPath + "/css/main.css";
    
    request.setAttribute("maincss", maincss);
    request.setAttribute("top_bgGifStr", top_bgGifStr);
    request.setAttribute("work_bodyJspStr", work_bodyJspStr);
%>
<html>
<head>
<link href="<c:out value='${maincss}' />" type="text/css" rel="stylesheet" >
<Meta http-equiv="Pragma" Content="No-cach">
<Meta http-equiv="Expires" Content="0">
<style type="text/css">
    <!--
    .topbg1 {
        background-image: url(<c:out value='${top_bgGifStr}' />);
    }
    -->
</style>
</head>
<body>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
<tr> 
    <td>
        <jsp:include page="${param.pubinfourl }"/>
    </td>
  </tr>
<tr>
    <td valign="bottom">
    <table width="100%" cellpadding="0" cellspacing="0">
        <tr>
          <td width="100%" class="topbg1">
             <div id="header"><div style="height: 3px;"></div></div>
          </td>
        </tr>
    </table>
    </td>
</tr>
</table>
</body>
<script language="javascript">
//显示点击之后一级菜单的画面
top.frames("bodyFrame_all").window.location.href = "<c:out value='${work_bodyJspStr}' />";
</script>
</html>