<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>新增权限模块分类</title>
</head>
<body>
<sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="privActor" actions="addPrvFunc">
	<sc:hidden name="curFunccds" attributesText="id='curFunccds'" />
	<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
		<tr><th colspan="4">权限模块分类</th></tr>
		<tr>
			<sc:text name="bscode" dspName="系统分类代码" dsp="td" attributesText="readOnly" />
		</tr>
		<tr>
			<sc:text name="funccd" dspName="功能模块代码" dsp="td" req="1" attributesText="id='funccd' maxLength='32'" />
		</tr>
		<tr>
			<sc:text name="funcna" dspName="功能代码名称" dsp="td" req="1" attributesText="id='funcna' maxLength='64'" />
		</tr>
	</table>
	<div style="width:100%" align="center" class="page-bottom">
        <sc:button value="保存" onclick="addPrvFunc()"/>
	    <sc:button value="重置" type="reset"/>
	    <sc:button value="退出" onclick="quit()"/>
    </div>
</sc:form>
</body>
<script type="text/javascript">
/**
 * ======================================================================================================================
 * 新增权限模块分类界面方法 		作者：曾慧磊		日期：2012-02-16
 * ======================================================================================================================
 */
/* 按钮事件 */
/** 新增 */
function addPrvFunc() {
	if (checkForm(document.form) && saveCheck()){
		ajaxSubmit("form", "新增权限模块分类成功！", "新增权限模块分类失败！");
	}
}
/** 退出 */
function quit() {
	window.close();
}

/** 主键唯一性校验 */
function saveCheck() {
	var curFunccds = $('curFunccds').value.split(',');
	if(curFunccds.without($('funccd').value).length < curFunccds.length){
		hint_alert($('funccd'), "“功能模块代码”已存在，请重新输入！");
		return false;
	}
	return true;	
}

/* Ajax 提交方法 */
function ajaxSubmit(formName, successMsg, failMsg) {
	var ajax = new Jraf.Ajax({evalJS:false, evalJSON:false});
	ajax.submitFormXml(formName, function(xml){
		try {
			var pkg = new Jraf.Pkg(xml);
			if(pkg.result() != '0'){
				Jraf.showMessageBox({
					title: 	failMsg,
					text:	'<p class="error">' + pkg.allMsgs('<br>') + '</p>'
				});
			} else {
				Jraf.showMessageBox({
					title:	successMsg,
					text:	'<p class="success">' + pkg.allMsgs('<br>') + '</p>',
					onOk:	function(){reValue(getRetVal());}
				});
			}
		} catch(e) {
			alert('ERROR:' + e);
		}
	});
}
/** 获取返回的界面值 */
function getRetVal() {
	var retArr = new Array();
	retArr[0] = $('funccd').value;
	retArr[1] = $('funcna').value;
	return retArr;
}
</script>
</html>