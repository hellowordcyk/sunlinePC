<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.sunline.jraf.util.DatetimeUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="/governor/common/common.jsp" %>
	<title>图片上传</title>
</head>
<body>
<div id="msg" style="text-align:center;color:red;width:100%; " ><sc:showrsmsg /></div>
<fieldset>
<legend>上传图片</legend>
<div id="createIndex" class="page-title" style="display:none; width: 100%; margin: 0px;"></div>
<sc:form name="frmcog" action="/httpprocesserservlet" sysName="governor" oprID="initConfig" 
	forward="/governor/basicinfo/uploaddatafile.jsp" encType="multipart/form-data" actions="upload"  method="post">
	<table align="center" class="form-table" border="0" width="100%" cellspacing=0 cellpadding=0>
		<tbody  id="tb">
			 <tr>
			 	<td  class='form-label'>应用系统Logo地址：</td><td ><input id='filename' name='filename' type='file'style='height:20px;'></td>
			 </tr>
		</tbody>
		<tbody>
			<tr>
				<td colspan="3" class="form-bottom" align="center">
			    	<sc:button value="上传" name="saveBtn" onclick="checkFiles();"/>
			        <sc:button value="重置" type="reset"/>
			        <sc:button value="关闭" onclick="window.close()"/>
			    </td>
			</tr>
		</tbody>
	</table>
	<div class="page-tip" style="maring: 0;">
		<span class="tip-title">温馨提示</span>
		<p>上传文件名称必须是<b>非中文字符</b>；</p>
	</div>
</sc:form>
</fieldset>
</body>
<script type="text/javascript">

function saveOk(){
	 var oForm = document.forms["frmcog"];
	 var oBtn = oForm.elements("saveBtn");
	 oBtn.disabled = true; 
   	 $("createIndex").style.display = "";
	 $("createIndex").innerHTML = "<span class='loading'>上传中，请稍后。。。</span>";
	 window.returnValue=true;
 	 oForm.submit();
 	 oBtn.disabled = false;
}

//验证上传图片路径是否为空
function checkPath(){
	var filename = document.getElementById("filename").value;
	if (filename!=null&&filename!=""){
		return true;
	}
	return false;
}

function checkFiles(){
	if(!checkPath()){
		Jraf.showMessageBox({title: "消息", text: "请先上传一张图片"});
	}else{
		var path = document.getElementById("filename").value;
		var param = {
		    sysName:    '<sc:fmt type="crypto" value="governor"/>',
		    oprID:      '<sc:fmt type="crypto" value="initConfig"/>',
		    actions:    '<sc:fmt type="crypto" value="checkBankpics"/>',
		    path:       path
		};
		var ajax = new Jraf.Ajax();
		ajax.sendForXml('/xmlprocesserservlet', param, function(xml){
	        try{
	            var pkg = new Jraf.Pkg(xml);
	            if(pkg.result() != '0'){
	                Jraf.showMessageBox({title: "校验异常", text: "<span class='error'>" + '异常：' + pkg.allMsgs('<br>') + "</span>"});
                	return;
            	}
	            var msg = pkg.rspData("Record/msg");
				if(msg!='0'){
					if (confirm(msg)){
						saveOk();
				    }
				}else{
					saveOk();
				}
	        }catch(e){
				Jraf.showMessageBox({title: "检验异常", text: "<span class='error'>" + e + "</span>"});
			}
		});
	}
}
</script>
</html>