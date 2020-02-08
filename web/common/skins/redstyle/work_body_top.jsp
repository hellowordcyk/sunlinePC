<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/common.jsp"%>
<html>
<head>
</head>
<body margin="0" leftmargin="0" topmargin="0" padding="0" >
	<input type="hidden" id="curpos" value="您当前位置："/>
	<div id="pagetip">
		<ul><li><a>您当前位置：</a></li><li id="pathId"></li></ul>
	</div>
</body>
<!-- <script language="javascript">
function init(){
    var pagetip = document.getElementById('pagetip');
	var rightTopHtml = top.topFrame.rightTopHtml;
	var curpos = document.getElementById('curpos').value;
	var ulStr="";
	ulStr+="<ul>";
	ulStr+="<li><a>"+curpos+"</a></li>";
	ulStr+=rightTopHtml;
	ulStr+="</ul>";
	pagetip.innerHTML = ulStr;
}
</script> -->
</html>