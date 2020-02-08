<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/governor/common/common.jsp"%>

<html>
<head>
</head>
<body onload="init();" margin="0" leftmargin="0" topmargin="0" padding="0" >
 <input type="hidden" id="curpos" value="您当前位置："/>
 <div id="pagetip">
 </div>
</body>
<script language="javascript">
function init(){
    var pagetip = document.getElementById('pagetip');
	var rightTopHtml = "<li><a><span class='current'>系统状态监控</span></a></li>";
	var curpos = document.getElementById('curpos').value;
	var ulStr="";
	ulStr+="<ul>";
	ulStr+="<li><a>"+curpos+"</a></li>";
	ulStr+=rightTopHtml;
	ulStr+="</ul>";
	pagetip.innerHTML = ulStr;
}
</script>
</html>