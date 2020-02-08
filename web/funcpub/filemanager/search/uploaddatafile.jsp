<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
<%@ include file="/jui_tag.jsp" %>
<title>文件上传</title>
</head>
<body >
<div id="createIndex" class="page-title" style="display:none; width: 100%; margin: 0px;"></div>
<form name="frmcog" method="post"  action="/jui/callMessage.so?csrftoken=${csrftoken}" class="pageForm required-validate" enctype="multipart/form-data" onsubmit="return iframeCallback(this, dialogAjaxDone);">
	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='funcpub-filemanager'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='upload'/>"/>
	<<%-- input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" /> --%>
	
	<sc:hidden name="subName"/>
	<sc:hidden name="path"/>
	<div class="pageContent">	
		<div class="pageFormContent">
			<table id="tb" cellpadding="0" cellspacing="0" width="100%">
				<tr>
					<td>文件地址</td>
					<td>
						<input name='filename' type='file' class="required" style='height:20px;'>
					</td>
					<td><sc:button value="新增附件" _class="add" onclick="addFile()"/>
		 			</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
		<ul>
			<li><input class="button" type="submit" value="提交" /></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>
</form>
</body>
<script type="text/javascript">

function saveOk(){
	var oForm = document.forms["frmcog"];
	var oBtn = oForm.elements("saveBtn");
	oBtn.disabled = true; 
	$("#createIndex").style.display = "";
	$("#createIndex").innerHTML = "<span class='loading'>上传中，请稍后。。。</span>";
	oForm.submit();
	oBtn.disabled = false;
}

function addFile(obj){
	if($("input[name='filename']").length<=3){
		var td = document.createElement("td");
		var tr = document.createElement("tr");
		var td0 = document.createElement("td");
		tr.appendChild(td0);
		tr.appendChild(td);
		document.getElementById("tb").appendChild(tr);
		td.innerHTML = "<input name='filename' type='file' class='required' style='height:20px;'>";
	}
}

</script>
</html>