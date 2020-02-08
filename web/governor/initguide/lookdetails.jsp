<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<%@ page import="com.sunline.jraf.util.DatetimeUtil" %>
<%@ include file="/governor/common/common.jsp" %>
<html>
<head>
<title>任务执行结果详情信息</title>
</head>
<body>
	<table align="center" class="form-table" border="0" width="100%" height="100%" style="margin:0;" cellspacing=0 cellpadding=0>
		<tbody  id="tb">
			 <tr>
			 	<td>
			 		<textarea id="xqxx" name="xqxx" class="inputarea" style="width:560px;height:328px;padding:5px;margin-bottom:12px;margin-top:12px;"></textarea>
			 	</td>
			 </tr>
		</tbody>
		<tbody>
			<tr>
				<td class="form-bottom" align="center">
			    	<sc:button value="复制详情信息" name="copyBtn" onclick="copycontent();"/>
			        <sc:button value="关闭" onclick="window.close()"/>
			    </td>
			</tr>
		</tbody>
	</table>
</body>
<script type="text/javascript" defer="defer">
	var args = window.dialogArguments;
	var detailsInfo = decodeURI(decodeURI(args));
	document.getElementById("xqxx").value = detailsInfo;
	
	function copycontent(){
		if (navigator.userAgent.indexOf("MSIE") == -1)
		{
			alert("您的浏览器不支持此功能,请手工复制文本框中内容");
			return false;
		}
		var xqxx = document.getElementById("xqxx");
		var xqxxv = document.getElementById("xqxx").value;
		xqxx.value = xqxxv;
		xqxx.focus();
		xqxx.select();
		document.execCommand('copy');
		alert("复制成功!");
	}
</script>
</html>