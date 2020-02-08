<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>修改系统权限分类</title>
</head>
<body>
<sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="privActor" actions="updatePrvBase">
	<sc:hidden name="oldbscode"/>
	<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
		<tr><th colspan="4">系统权限分类</th></tr>
		<tr>
		    <td class="form-label"><font color="red">*</font>系统分类代码 ：</td>
		    <td class="form-value">
		    	<sc:text name="bscode" dspName="系统分类代码" req="1" index="1" attributesText="id='bscode' maxLength='32' readOnly" />
		    	<input type="button" id="#" name="bscode_search" onclick="getBsCode();" src="" class="search" /> 
		    </td>
		</tr>
		<tr>
			<sc:text name="bsname" dspName="系统分类名称" dsp="td" req="1" index="1" attributesText="maxLength='64'" />
		</tr>
		<tr>
			<sc:select name="status" dspName="权限分类状态" type="dict" key="pcmc,status" default="1" includeTitle="false" dsp="td" req="1" index="1" />
		</tr>
		<tr>
			<td class="form-label"><font color="red">*</font>系统管理员代码 ：</td>
		    <td class="form-value">
		    	<sc:text name="sysopr" dspName="系统管理员代码" req="1" index="1" attributesText="id='sysopr' maxLength='32' readOnly" />
		    	<img src="/common/images/pic01/sel_person.gif" border=0 style="CURSOR: hand" onClick="getUserInfo()">
		    </td>
		</tr>
		<tr>
			<sc:text name="operna" dspName="系统管理员名称" dsp="td" index="1" attributesText="id='operna' maxLength='64' readOnly" />
		</tr>
	</table>
	<div style="width:100%" align="center" class="page-bottom">
        <sc:button value="保存" onclick="updatePrvBase()"/>
	    <sc:button value="重置" type="reset"/>
	    <sc:button value="退出" onclick="quit()"/>
    </div>
</sc:form>
</body>
<script type="text/javascript">
/**
 * ======================================================================================================================
 * 新增流程配置界面方法 		作者：曾慧磊		日期：2011-12-26
 * ======================================================================================================================
 */
/* 按钮事件 */
/** 新增 */
function updatePrvBase() {
	if (checkForm(document.form)){
		ajaxSubmit("form", "修改系统权限分类成功！", "修改系统权限分类失败！");
	}
}
/** 退出 */
function quit() {
	window.close();
}

/* 选择控件赋值 */
/** 获取系统分类代码 */
function getBsCode() {
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="privActor"/>&actions=<sc:fmt type="crypto" value="queryBsCode"/>&forward=<sc:fmt value='/pcmc/priv/bsCodeSel.jsp' type='crypto'/>&bscode=' + $('bscode').value;
		url += '&s_time=' + new Date().getTime();
	var ret = openModal(url, 350, 385);
	if (ret != null && ret != undefined) {
		$('bscode').value = ret;
	}
}
/** 获取用户信息 */
function getUserInfo() {
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="privActor"/>&actions=<sc:fmt type="crypto" value="queryPcmcUser"/>&forward=<sc:fmt value='/pcmc/priv/userSel.jsp' type='crypto'/>&usercode=' + $('sysopr').value;
		url += '&s_time=' + new Date().getTime();
	var ret = openModal(url, 350, 385);
	if (ret != null && ret != undefined) {
		$('sysopr').value = ret[1];
		$('operna').value = ret[2];
	}
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
					onOk:	function(){reValue(1);}
				});
			}
		} catch(e) {
			alert('ERROR:' + e);
		}
	});
}
</script>
</html>