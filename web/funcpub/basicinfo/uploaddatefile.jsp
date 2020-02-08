<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<form name="frmcog" method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-basicinfo' type='crypto'/>&actions=<sc:fmt value='upload' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageFormContent">
       <table width="100%" cellpadding="0" cellspacing="0">
			 <tr>
			 	<td  class='form-label'>应用系统Logo地址</td><td ><input id='filename' name='filename' type='file' style='height:20px;'></td>
			 </tr>
	   </table>
	</div>
	<div class="formBar">
        <ul>
            <li><input class="button" type="button" value="上传" name="saveBtn" onclick="checkFiles();"/>
            <li><input class="button" type="reset"  value="重置"/>
            <li><button type="button" class="close">关闭</button></li>
        </ul>
	</div>
	<div class="page-tip" style="maring: 0;">
		<span class="tip-title">温馨提示</span>
		<p>上传文件名称必须是<b>非中文字符</b>；</p>
	</div>
</form>
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
		    sysName:    '<sc:fmt type="crypto" value="funcpub"/>',
		    oprID:      '<sc:fmt type="crypto" value="funcpub-basicinfo"/>',
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