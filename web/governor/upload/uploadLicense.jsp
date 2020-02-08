<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jstl/core_rt" prefix="c"%>
<%@ taglib uri="http://www.sunline.cn/jsp/common" prefix="sc"%>
<%@ page import="com.sunline.jraf.util.DatetimeUtil" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" type="text/css" href="/common/skins/default/theme/style-sys.css">
<link rel="stylesheet" type="text/css" href="/common/skins/default/theme/style-custom.css">
<script type="text/javascript" src="/common/scripts/prototype1.7.js"></script>
<script type="text/javascript" src="/common/scripts/Jraf_prototype.js"></script>
<title>license上传</title>

</head>
<body >
<FIELDSET>
<legend></legend>
<div class="page-tip" style="text-align:center">
    <span class="tip-title">
        <c:if test="${ jrafrpu.rspPkg.hintMsg[0] == 'no' }">
                 license文件验证失败，请重新上传
         </c:if>
         <c:if test="${ jrafrpu.rspPkg.hintMsg[0] == 'yes' }">
                 license文件验证成功!
         </c:if>
          <c:if test="${ jrafrpu.rspPkg.hintMsg[0] == null }">
                                             系统未注册，请先上传license文件注册
          </c:if>
        </span>
 </div>
 <div class="page-tip">
    <span class="tip-title">温馨提示</span>
    <p>上传的license必须以“suncrs_lincense.xml”命名</p>
    <p>正版lincense请到长亮科技购买</p>
</div>
 <div id="createIndex" class="page-title" style="display:none; width: 100%; margin: 0px;"></div>
 <sc:form name="frmcog" action="/httpprocesserservlet" sysName="governor" oprID="uploadfile" encType="multipart/form-data" 
        forward="/uploadLicense.jsp" actions="uploadLicense"  method="post">
 
        <sc:hidden name="subname" value="${param.sysName}"/>
		<table align="center" class="form-table" border="0" width="100%" height="100%" cellspacing=0 cellpadding=0>
		<tbody  id="tb">
			 
			 <tr><td  class='form-label' style="text-align:center">licence文件地址：<input name='filename' type='file' style='height:20px;width:300px'></td></tr>
			 </tbody>
			 <tbody>
			<tr>
			     <td  class="form-bottom" align="center">
			        <sc:button value="上传" name="saveBtn" onclick="saveOk();"/>
			         <sc:button value="重置" type="reset"/>
			          <sc:button value="关闭" onclick="window.close()"/>
			     </td>
			</tr>
			</tbody>
		</table>
		
	</sc:form>
	

   </FIELDSET>
</body>
<script type="text/javascript">
init();

function init(){
	var hint = "${ jrafrpu.rspPkg.hintMsg[0]}";
	if(hint=='yes'){
		  window.returnValue=true;
	}
    }
	function saveOk() {
		var oForm = document.forms["frmcog"];
		var filepath = oForm.elements("filename").value;
		var strs = filepath.split("\\");
		var filename = strs[strs.length-1];
		if(filename!='suncrs_license.xml'){
			 Jraf.showMessageBox({
		            text: "文件名称不正确！",
		            type: "info"
		        });
			 return;
		}
		oForm.submit();
	
		
		/* var ajax = new Jraf.Ajax();
		//oBtn.disabled = true;
		//$("createIndex").style.display = "";
		//$("createIndex").innerHTML = "<span class='loading'>上传中，请稍后。。。</span>";
		ajax.submitFormXml(oForm, function(xml) {
			try {
				var pkg = new Jraf.Pkg(xml);
				if (pkg.result() != '0') {
					Jraf.showMessageBox({
						text : 'license文件不正确！',
						type : "info"
					});
					return;
				}
				window.returnValue=true;
			} catch (e) {
				alert(e.message);
			}
		});
		oBtn.disabled = false;
 */
	}
	
</script>
</html>