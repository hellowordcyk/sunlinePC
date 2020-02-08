<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.web.RequestParamUtil" %>
<%@ page import="com.sunline.bimis.pcmc.flow.FlowChart" %>
<html xmlns:v="urn:schemas-microsoft-com:vml">
<style>v\:*{behavior:url(#default#VML)}</style>
<head>
	<%@ include file="/common.jsp"%>
	<title>流程授权配置</title>
</head>
<body>
<sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="flowActor" actions="refreshFlowGrant">
  <sc:hidden attributesText="id='flowid'" name="flowid"/>
  <sc:hidden attributesText="id='detlcd'" name="detlcd"/>
  <table width="100%" height="90%" cellpadding="0" cellspacing="0" class="form-table">
    <tr>
	  <td width="25%" valign="top">
	  	<!-- 流程过程显示部分 -->
	  	<div class="page-title"><span class="title">流程过程</span>
	      <div style="height:630px;overflow:auto;">
	        <%=FlowChart.drawFlowChart(((RequestParamUtil)request.getAttribute("jrafrpu")).getRspPkg().getRspRcdDataMaps())%>
	      </div>
	   </div>
      </td>
	  <td>
	  	<table width="100%" height="100%" cellpadding="0" cellspacing="0">
	  	  <tr>
	  	    <!-- 角色授权部分-->
	  	    <td width="45%" valign="top">
	  	      <div style="height:325px;overflow:auto;" class="page-title"><span class="title">未授权角色</span>
	  	        <select id="rnogrant" name="rnogrant" style="width:100%;height:90%" ondblclick="rGrantSingle()" multiple>
	  	        </select>
	  	      </div>
	  	    </td>
	  	    <td width="10%">
	  	      <table cellpadding="0" cellspacing="0">
	  	        <tr><td align="center"><input type="button" class="btn_mail" value=" 授权 >>" onclick="rGrantSingle()"></td></tr>
	  	        <tr><td>&nbsp;</td></tr>
	  	        <tr><td align="center"><input type="button" class="btn_mail" value="<< 取消 " onclick="rUnGrantSingle()"></td></tr>
	  	        <tr><td>&nbsp;</td></tr>
	  	        <tr><td align="center"><input type="button" class="btn_mail" value="全授权 >>" onclick="rGrantAll()"></td></tr>
	  	        <tr><td>&nbsp;</td></tr>
	  	        <tr><td align="center"><input type="button" class="btn_mail" value="<< 全取消" onclick="rUnGrantAll()"></td></tr>
	  	      </table>
	  	    </td>
	  	    <td width="45%" valign="top">
	  	      <div style="height:325px;overflow:auto;" class="page-title"><span class="title">已授权角色</span>
	  	        <select id="rgranted" name="rgranted" style="width:100%;height:90%" ondblclick="rUnGrantSingle()" multiple>
	  	        </select>
	  	      </div>
	  	    </td>
	      </tr>
	  	  <tr>
	  	    <!-- 用户授权部分-->
	  	    <td width="45%" valign="top">
	  	      <div style="height:325px;overflow:auto;" class="page-title"><span class="title">未授权用户</span>
	  	        <select id="unogrant" name="unogrant" style="width:100%;height:90%" ondblclick="uGrantSingle()" multiple>
	  	        </select>
	  	      </div>
	  	    </td>
	  	    <td width="10%">
	  	      <table cellpadding="0" cellspacing="0">
	  	        <tr><td align="center"><input type="button" class="btn_mail" value=" 授权 >>" onclick="uGrantSingle()"></td></tr>
	  	        <tr><td>&nbsp;</td></tr>
	  	        <tr><td align="center"><input type="button" class="btn_mail" value="<< 取消 " onclick="uUnGrantSingle()"></td></tr>
	  	        <tr><td>&nbsp;</td></tr>
	  	        <tr><td align="center"><input type="button" class="btn_mail" value="全授权 >>" onclick="uGrantAll()"></td></tr>
	  	        <tr><td>&nbsp;</td></tr>
	  	        <tr><td align="center"><input type="button" class="btn_mail" value="<< 全取消" onclick="uUnGrantAll()"></td></tr>
	  	      </table>
	  	    </td>
	  	    <td width="45%" valign="top">
	  	      <div style="height:325px;overflow:auto;" class="page-title"><span class="title">已授权用户</span>
	  	        <select id="ugranted" name="ugranted" style="width:100%;height:90%" ondblclick="uUnGrantSingle()" multiple>
	  	        </select>
	  	      </div>
	  	    </td>
	  	  </tr>
	    </table>
	  </td>
    </tr>
  </table>
  <div align="center" class="page-bottom">
    <sc:button value="保存" onclick="saveGrant()" />
    <sc:button value="退出" onclick="quit()" />
  </div>
</sc:form>
</body>
<script type="text/javascript">
/**
 * ======================================================================================================================
 * 流程授权配置界面方法 		作者：曾慧磊		日期：2012-01-04
 * ======================================================================================================================
 */
/** 全局变量 */
var isInit;						//初始化状态
var isSaved = false;			//是否已经保存过
var flowid;						//流程主键
var detlcds = new Array();		//过程代码数组
 
/* 初始化界面 */
window.onload = function init() {
	isInit = true;
	flowid = $('flowid').value;		//流程主键
 	/* 过程代码数组初始化 */
	var rectArr = document.getElementsByName("detlcdRect");
	for(var i = 0; i < rectArr.length; i++){
		detlcds[i] = rectArr[i].value;
	}
	/* 默认选择首条显示 */
	onSelRect(detlcds[0]);
};

/* 按钮事件 */
/* 更新流程授权信息 */
function saveGrant() {
	/* select 后台获值特殊处理 */
	setSelOpt('rgranted', true);
	setSelOpt('ugranted', true);
	ajaxSubmit("form", "更新授权成功！", "更新授权失败！");
	/* select 后台获值特殊处理 */
	setSelOpt('rgranted', false);
	setSelOpt('ugranted', false);
	isSaved = true;
}
/** 退出 */
function quit() {
	window.close();
}

/* VML选择结点事件 */
var rGrantedArr, uGrantedArr;
function onSelRect(detlcd) {
	/* 提示是否保存已修改的授权信息 */
	if(!isInit && !isSaved && isOptsChanged() && confirm("授权信息已修改，是否保存？")){
		saveGrant();
	}
	$('detlcd').value = detlcd;  	//隐置detlcd参数赋值
	/* 切换节点高亮变色效果 */
	for(var i = 0; i < detlcds.length; i++){
		$(detlcds[i]).fillcolor = 'white';
	}
	if($(detlcd) != null && $(detlcd) != undefined){
		$(detlcd).fillcolor = 'yellow';	
	}
	refreshGrantInfo(detlcd);		//刷新显示授权
	isInit = false;
	isSaved = false;
}

/* 授权选择相关方法 */
/** 查询用户角色授权信息并展现  */
function refreshGrantInfo(detlcd) {
	/* 初始化清空选择控件 */
	removeSelOpt('rnogrant');
	removeSelOpt('rgranted');
	removeSelOpt('unogrant');
	removeSelOpt('ugranted');
	
	var ajax = new Jraf.Ajax({evalJS:false, evalJSON:false});
	/* 查询流程角色授权信息展现 */
	var grRoleParams = {
		sysName:  "<sc:fmt value='pcmc' type='crypto'/>",
		  oprID:  "<sc:fmt value='flowActor' type='crypto'/>",
		actions:  "<sc:fmt value='queryFlowGrantRole' type='crypto'/>",
		 flowid:  flowid,
		 detlcd:  detlcd};
	ajax.sendForXml('/xmlprocesserservlet', grRoleParams, 
		function(grRoleXml){
			try{
				rGrantedArr = new Array();		//全局变量临时存储
   				var pkg = new Jraf.Pkg(grRoleXml);
   				/* 分类赋值选择控件展现 */
   				var roleid, rolename, status;
				var roleArr = pkg.rspDatas().Record;
				for(var i = 0; i < roleArr.length; i++){
					status = roleArr[i].status;
					roleid = roleArr[i].roleid;
					rolename = roleArr[i].rolename;
					if(status == '0') {
						/* 未授权角色添加 */
						addGrantSelOpt('rnogrant', roleid + '/' + rolename, rolename, rolename);
					} else if(status == '1') {
						/* 已授权角色添加 */
						addGrantSelOpt('rgranted', roleid + '/' + rolename, rolename, rolename);
						rGrantedArr[i] = roleid;
					}
				}
			} catch (e) {
				alert('ERROR:'+e);
			}
		}
	);
	/* 查询流程用户授权信息展现 */
	var grUserParams = {
		sysName:  "<sc:fmt value='pcmc' type='crypto'/>",
		  oprID:  "<sc:fmt value='flowActor' type='crypto'/>",
		actions:  "<sc:fmt value='queryFlowGrantUser' type='crypto'/>",
		 flowid:  flowid,
		 detlcd:  detlcd};
	ajax.sendForXml('/xmlprocesserservlet', grUserParams, 
		function(grUserXml){
			try{
				uGrantedArr = new Array();		//全局变量临时存储
   				var pkg = new Jraf.Pkg(grUserXml);
   				/* 分类赋值选择控件展现 */
   				var userid, username, userdisp, status;
				var userArr = pkg.rspDatas().Record;
				for(var i = 0; i < userArr.length; i++){
					status = userArr[i].status;
					userid = userArr[i].userid;
					username = userArr[i].username;
					userdisp = userArr[i].userdisp;
					if(status == '0') {
						/* 未授权用户添加 */
						addGrantSelOpt('unogrant', userid + '/' + username, userdisp, username);
					} else if(status == '1') {
						/* 已授权用户添加 */
						addGrantSelOpt('ugranted', userid + '/' + username, userdisp, username);
						uGrantedArr[i] = userid;
					}
				}
			} catch (e) {
				alert('ERROR:'+e);
			}
		}
	);
}
/** 选择控件添加项 */
function addGrantSelOpt(selId, value, text, title) {
	var option = new Option();
	option.value = value;
	option.text = text;
	option.title = title;
	$(selId).options.add(option, $(selId).length);
}
/** 初始化清空选择控件 */
function removeSelOpt(selId) {
	var opts = $(selId).options;
	var length = opts.length;
	for(var i = length - 1; i >= 0; i--){
		opts.remove(i);
	}
}
/** 角色单授权按钮事件 */
function rGrantSingle() {
	grantSelOpt(false, 'rnogrant', 'rgranted');
}
/** 角色单取消按钮事件 */
function rUnGrantSingle() {
	grantSelOpt(false, 'rgranted', 'rnogrant');
}
/** 角色全授权按钮事件 */
function rGrantAll() {
	grantSelOpt(true, 'rnogrant', 'rgranted');
}
/** 角色全取消按钮事件 */
function rUnGrantAll() {
	grantSelOpt(true, 'rgranted', 'rnogrant');
}
/** 用户单授权按钮事件 */
function uGrantSingle() {
	grantSelOpt(false, 'unogrant', 'ugranted');
}
/** 用户单取消按钮事件 */
function uUnGrantSingle() {
	grantSelOpt(false, 'ugranted', 'unogrant');
}
/** 用户全授权按钮事件 */
function uGrantAll() {
	grantSelOpt(true, 'unogrant', 'ugranted');
}
/** 用户全取消按钮事件 */
function uUnGrantAll() {
	grantSelOpt(true, 'ugranted', 'unogrant');
}
/** 设置选择控件状态 */
function setSelOpt(setId, isSel) {
	var opts = $(setId).options;
	for(var i = 0; i < opts.length; i++){
		opts[i].selected = isSel;
	}
}
/** 初始授权与保存前对比 */
function isOptsChanged() {
	var rCurOpts = $('rgranted').options;
	var uCurOpts = $('ugranted').options;
	/* 个数不相同时，一定改变 */
	if((rCurOpts.length != rGrantedArr.length) || (uCurOpts.length != uGrantedArr.length)){
		return true;
	}
	/* 分别判别角色、用户授权信息是否完全相同 */
	var rOptsArr = new Array();		//汇总原先和现在的角色授权信息
	for(var i = 0; i < rCurOpts.length; i++){
		rOptsArr[i] = rCurOpts[i].value.split('/')[0];
	}
	rOptsArr = rOptsArr.concat(rGrantedArr);
	if(rOptsArr.uniq().length != rCurOpts.length){
		return true;
	}
	var uOptsArr = new Array();		//汇总原先和现在的用户授权信息
	for(var m = 0; m < uCurOpts.length; m++){
		uOptsArr[m] = uCurOpts[m].value.split('/')[0];
	}
	uOptsArr = uOptsArr.concat(uGrantedArr);
	if(uOptsArr.uniq().length != uCurOpts.length){
		return true;
	}
	return false;
}

/** 通用授权工具方法 */
function grantSelOpt(isAll, fromSelId, toSelId) {
	var rNoGropts = $(fromSelId).options;
	var length = rNoGropts.length;
	/* 正序添加 */
	for(var i = 0; i < length; i++){
		if(isAll || rNoGropts[i].selected){
			addGrantSelOpt(toSelId, rNoGropts[i].value, rNoGropts[i].text, rNoGropts[i].title);
		}
	}
	for(var i = length - 1; i >= 0; i--){
		if(isAll || rNoGropts[i].selected){
			rNoGropts.remove(i);
		}
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
					text:	'<p class="success">' + pkg.allMsgs('<br>') + '</p>'
				});
			}
		} catch(e) {
			alert('ERROR:' + e);
		}
	});
}
</script>
</html>