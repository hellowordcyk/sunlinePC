<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>应用系统配置</title>
</head>
<body>
<form name="importReportForm" encType="multipart/form-data" method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return iframeCallback(this,dialogAjaxDone)" >
<input type="hidden" name="filePath" value="/jui/themes/default/images/"/>
<input type="hidden" name="sysName" value='<sc:fmt value='funcpub' type='crypto'/>'/>
<input type="hidden" name="oprID" value='<sc:fmt value='funcpub-basicinfo' type='crypto'/>'/>
<input type="hidden" name="actions" value='<sc:fmt value='importBankLogo' type='crypto'/>'/>
<sc:doPost sysName="funcpub" oprId="funcpub-basicinfo" action="queryBasicInfo" scope="request" var="rspPkg" all="true"></sc:doPost>
<div class="pageContent">
	<div class="pageFormContent">
		<table cellpadding="0" cellspacing="0" width="100%">
			<tr>
				<td align="right">系统名称：<span style="color:red;">*</span></td>
				<td><input  id="sitename" type="text" value="${rspPkg.rspRcdDataMaps[0].sitename}" style='width:350px;'></input></td>
			</tr>
			<tr>
				<td align="right">登录页面页脚：<span style="color:red;">*</span></td>
				<td><input id="loginfooter" type="text" value="${rspPkg.rspRcdDataMaps[0].loginfooter}" style='width:350px;'></input></td>
			</tr>
			<tr>
				<td align="right">系统页脚：<span style="color:red;">*</span></td>
				<td><input id="systemfooter" type="text" value="${rspPkg.rspRcdDataMaps[0].footer}"  style='width:350px;'></input></td>
			</tr>
			<tr>
				<td align="right">应用系统Logo：<span style="color:red;">*</span></td>
			 	<td><input id='fileName' name='fileName' type='file' style='height:20px;' onchange="getFilePath(this)" ></td>
			</tr>
			<tr>
				<td align="right">应用系统Logo预览</td>
				<td>
	                <div style="margin-top:7px;margin-bottom:7px;">                        
	                    <img id="bank_logo" alt="应用系统logo" src="${rspPkg.rspRcdDataMaps[0].bankpic}" /> 
	                </div>
           		</td>
			</tr>
		</table>
	</div>
</div>  
<div class="formBar">
     <ul>
         <li><input type="button" name="save"  class="button"  value="保存" onclick="saveOK()" /></li>
         <li><input type="reset" value="重置"  class="button" /></li>
     </ul>
</div>
</form>
</body>
<script type="text/javascript">

function getFilePath(Object) {
	var filePath = $("[name='filePath']",navTab.getCurrentPanel()).val();
	var fileName = $(Object).val();
	var form = $("[name='importReportForm']",navTab.getCurrentPanel());
	form.submit();
	$("#bank_logo",navTab.getCurrentPanel())[0].src = filePath + fileName;
}

//保存
function saveOK() {
	var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-basicinfo' type='crypto'/>&actions=<sc:fmt value='updateBasicInfo' type='crypto'/>';
	var sitename = document.getElementById("sitename").value;
    var loginfooter = document.getElementById("loginfooter").value;
    var systemfooter = document.getElementById("systemfooter").value;
    sitename = encodeURI(sitename);
    sitename = encodeURI(sitename);
    loginfooter = encodeURI(loginfooter);
    loginfooter = encodeURI(loginfooter);
    systemfooter = encodeURI(systemfooter);
    systemfooter = encodeURI(systemfooter);
    var filePath = $("[name='filePath']",navTab.getCurrentPanel()).val();
    var fileName = $("[name='fileName']",navTab.getCurrentPanel()).val();
    var path = filePath + fileName;
    if (fileName == null || typeof(fileName) == "undefined" || fileName == '') {
    	path = null;
    }
    path = encodeURI(path);
    path = encodeURI(path);
   	$.ajax({
	   type: "POST",
	   url: url+"&dt="+new Date()+"&sitename="+sitename+"&loginfooter="+loginfooter+"&systemfooter="+systemfooter+"&path="+path,
	   data: "sitename="+sitename+"loginfooter="+loginfooter+"systemfooter="+systemfooter+"path="+path,
	   dataType: "xml",
	   processData: false,
	   success: function(data){
		   var retCode = $(data).find("DataPacket Response Data retCode").text();
		   if(retCode == "200"){
				alertMsg.correct("保存成功！", {
				   okCall: function(){
					   //刷新当前页面，重新调用一次查询功能
					   navTab.reload();
				   }
				}); 
		   }else{
		   		alertMsg.error("保存失败！");
		   }
	   },error:function(){
       	   alertMsg.error("保存失败！");
       }
	});
      
}
</script>
</html>
</html>