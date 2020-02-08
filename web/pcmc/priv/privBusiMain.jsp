<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
	<%@ include file="/common.jsp"%>
</head>
<body>
<sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="privActor" actions="savePrvGrantInfo">
  <sc:hidden name="funcrl" attributesText="id='funcrl'"/>
  <sc:hidden name="typecd" attributesText="id='typecd'"/>
  <sc:hidden name="objtid" attributesText="id='objtid'"/>
  <sc:hidden name="nodetype" attributesText="id='nodetype'"/>
  <table width="100%" height="100%" cellpadding="0" cellspacing="5" >
    <tr>
	  <td width="36%" valign="top">
	  	  <!-- 权限功能树显示部分 -->
	  	  <div class="page-title">
            <span class="title">权限功能树</span>
	  	  	<div align="right" class="page-toolbar">
	  	  		<span class="hint_info">请选择功能类型根节点进行配置授权用户或角色！
  	        	    <sc:button _class="save" value="保存配置" onclick="saveGrant()" />
                </span>
  	    	</div>
	  	    <div id="prvtree" style="width:450px;height:415px;overflow:auto;"></div>
	     </div>
      </td>
	  <td width="64%" valign="top">
	    <table width="100%" height="100%" cellpadding="0" cellspacing="0">
	  	  <tr>
	  	    <!-- 角色授权部分-->
	  	    <td width="45%" valign="top">
	  	      <div style="height:230px;overflow:auto;" class="page-title"><span class="title">未授权角色</span>
	  	        <select id="rnogrant" name="rnogrant" style="width:100%;height:88%" ondblclick="rGrantSingle()" multiple>
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
	  	      <div style="height:230px;overflow:auto;" class="page-title"><span class="title">已授权角色</span>
	  	        <select id="rgranted" name="rgranted" style="width:100%;height:88%" ondblclick="rUnGrantSingle()" multiple>
	  	        </select>
	  	      </div>
	  	    </td>
	      </tr>
	  	  <tr>
	  	    <!-- 用户授权部分-->
	  	    <td width="45%" valign="top">
	  	      <div style="height:230px;overflow:auto;" class="page-title"><span class="title">未授权用户</span>
	  	        <select id="unogrant" name="unogrant" style="width:100%;height:88%" ondblclick="uGrantSingle()" multiple>
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
	  	      <div style="height:230px;overflow:auto;" class="page-title"><span class="title">已授权用户</span>
	  	        <select id="ugranted" name="ugranted" style="width:100%;height:88%" ondblclick="uUnGrantSingle()" multiple>
	  	        </select>
	  	      </div>
	  	    </td>
	  	  </tr>
	    </table>
	  </td>
    </tr>
  </table>
</sc:form>
</body>
<script type="text/javascript">
/**
 * ======================================================================================================================
 * 权限授权配置界面方法 		作者：曾慧磊		日期：2012-02-16
 * ======================================================================================================================
 */
/** 全局变量 */
var isInit;						//初始化状态
var isSaved = false;			//是否已经保存过
var isBefore = false;			//是否保存以前标志
var ajax = new Jraf.Ajax();		//Ajax 抽象类
var rGrantedArr, uGrantedArr;   //初始化授权集
var lastfuncrl, lasttypecd, lastobjtid, lastnodetype;		//上次选择的结点值

/** 树控件 */
var prvTree = new Jraf.Tree({
	selector:  '#prvtree',
	onexpand:  function(srcNode){
		expandNode(prvTree, srcNode);
	}
});

/* 初始化界面 */
window.onload = function init() {
	isInit = true;
	setBtnStatus(true);			//设置按钮状态
	loadPrvTree(prvTree);		//加载树结点
};

/* 树相关方法 */
/** 展开树结点的加载 */
function expandNode(prvTree, srcNode){
	srcNode.icon.src = srcNode.treeContext.imageList.item["hfold_open"].src;
	if (srcNode.first && srcNode.first.tag == 'asyncloading') {
		var srcTag = srcNode.tag;
		loadPrvTree(prvTree, srcTag.bscode, srcTag.funccd, srcTag.funcrl, srcTag.typetp, srcTag.typecd);
	}
}
/** 加载树结点 */
function loadPrvTree (prvTree, bscode, funccd, funcrl, typetp, typecd) {
	/* 初始化参数变量 */
	var params = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID:		'<sc:fmt type="crypto" value="privActor"/>',
		actions:	'<sc:fmt type="crypto" value="queryPrvBusiTree"/>',
		bscode:		'',
		funccd:		'',
		funcrl:		'',
		typetp:		'',
		typecd:		''
	};
	if(bscode) {Object.extend(params, {bscode:bscode});}
	if(funccd) {Object.extend(params, {funccd:funccd});}
	if(funcrl) {Object.extend(params, {funcrl:funcrl});}
	if(typetp) {Object.extend(params, {typetp:typetp});}
	if(typecd) {Object.extend(params, {typecd:typecd});}
	/* 查询初始化树结点 */
	ajax.sendForXml('/xmlprocesserservlet', params, function(xml){initPrvTree(xml, prvTree, bscode, funccd, funcrl, typetp, typecd);});
}
/** 树结点赋值 */
function initPrvTree (xml, prvTree, bscode, funccd, funcrl, typetp, typecd) {
	try{
		var pkg = new Jraf.Pkg(xml);
		if (pkg.result() != '0') {
			alert('获取权限功能树异常！\n' + pkg.allMsgs());		//查询失败处理
		}
		var rcds = pkg.rspDatas().Record;
		if(!rcds) {rcds = [];}
		if(!Object.isArray(rcds)) {rcds = [rcds];}
		rcds.each( function(rcd){addPrvNode(prvTree, rcd);}, this);		//循环添加结点
		
	} catch(ex) {
		alert('ERROR:' + ex);
	}
}
/** 树结点添加结点 */
function addPrvNode(prvTree, rcd){
	var item = {
		name:		rcd.nodename,
		key:		rcd.key,
		pkey:		rcd.pkey,
		onClick:	viewPrvType,	//点击结点响应事件
		tag:		rcd
	};
	var prvNode = prvTree.addNode(item);
	if(rcd.childnum != '0'){
		prvTree.addNode({
			name:	'Loading...',
			key:	'load',
			pkey:	item.key,
			tag:	'asyncloading'
		});
		prvNode.expand(false, true);
	}
	/* 消除父结点 Loading 结点 */
	var pNode = prvTree.treeContext.nodes[rcd.pkey];
	if (pNode && pNode.first && pNode.first.tag == 'asyncloading') {
		pNode.first.remove();		//消除是否含子结点的标志行
	}
	return prvNode;
}
/** 结点选择显示功能类型 */
function viewPrvType(){
	/* 提示是否保存已修改的授权信息 */
	var selType = prvTree.treeContext.getSelectedNode().tag.nodetype;
	if(!isInit && !isSaved && isOptsChanged() && confirm("授权信息已修改，是否保存？")){
		isBefore = true;
		saveGrant();
	}
	/* 当结点类型为查询类型结点或JSP配置结点时，可授权信息 */
	var selTag = prvTree.treeContext.getSelectedNode().tag;
	var selType = selTag.nodetype;
	if(selType == 'stypecd' || selType == 'butn'){
		setBtnStatus(false);	// 设置按钮都可用
		refreshGrantInfo(selType, selTag.funcrl, selTag.typecd, selTag.objtid);	 // 刷新查询授权信息
	}else{
		setBtnStatus(true);
		removeAllSelOpt();	// 清空所有选择控件
	}
	/* 全局变量赋值 */
	lastfuncrl = selTag.funcrl;
	lasttypecd = selTag.typecd;
	lastobjtid = selTag.objtid;
	lastnodetype = selTag.nodetype;
	if(selType == 'stypecd' || selType == 'butn'){
		isInit = false;
	}
	isSaved = false;
}

/* 按钮事件 */
/** 保存 */
function saveGrant() {
	/* select 后台获值特殊处理 */
	setSelOpt('rgranted', true);
	setSelOpt('ugranted', true);
	var selTag = prvTree.treeContext.getSelectedNode().tag;
	/* 后台参数的赋值 */
	if(isBefore){
		$('funcrl').value = lastfuncrl;
		$('typecd').value = lasttypecd;
		$('objtid').value = lastobjtid;
		$('nodetype').value = lastnodetype;
	}else{
		$('funcrl').value = selTag.funcrl;
		$('typecd').value = selTag.typecd;
		$('objtid').value = selTag.objtid;
		$('nodetype').value = selTag.nodetype;
	}
	ajaxSubmit(document.forms["form"], "保存权限授权成功！", "保存权限授权失败！");
	/* select 后台获值特殊处理 */
	setSelOpt('rgranted', false);
	setSelOpt('ugranted', false);
	isSaved = true;
}
/** 设置按钮状态 */
function setBtnStatus(isDisabled) {
	var inputTags = document.form.tags("input");
	var length = inputTags.length;
	for (var i = 0; i < length; i++) {
	    var ele = inputTags[i];
	    if (ele.type == "button") {
		    ele.disabled = isDisabled;
	    }
	}
}

/* 授权选择相关方法 */
/** 清空所有选择控件 */
function removeAllSelOpt(){
	removeSelOpt('rnogrant');
	removeSelOpt('rgranted');
	removeSelOpt('unogrant');
	removeSelOpt('ugranted');
}
/** 查询用户角色授权信息并展现  */
function refreshGrantInfo(nodetype, funcrl, typecd, objtid) {
	removeAllSelOpt();		// 初始化清空选择控件
	var ajax = new Jraf.Ajax({evalJS:false, evalJSON:false});
	/* 查询角色授权信息展现 */
	var grRoleParams = {
		sysName:  "<sc:fmt value='pcmc' type='crypto'/>",
		  oprID:  "<sc:fmt value='privActor' type='crypto'/>",
		actions:  "<sc:fmt value='queryPrvGrantRole' type='crypto'/>",
	   nodetype:  nodetype,
	     funcrl:  '',
	     typecd:  '',
	     objtid:  ''};
	if(funcrl) {Object.extend(grRoleParams, {funcrl:funcrl});}
	if(typecd) {Object.extend(grRoleParams, {typecd:typecd});}
	if(objtid) {Object.extend(grRoleParams, {objtid:objtid});}
	ajax.sendForXml('/xmlprocesserservlet', grRoleParams, 
		function(grRoleXml){
			try{
				rGrantedArr = new Array();		//全局变量临时存储
   				var pkg = new Jraf.Pkg(grRoleXml);
   				/* 分类赋值选择控件展现 */
   				var roleid, rolename, status;
				var roleArr = pkg.rspDatas().Record;
				if(!roleArr) roleArr=[];
				if(!Object.isArray(roleArr)) roleArr = [roleArr];
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
						rGrantedArr[rGrantedArr.length] = roleid;
					}
				}
			} catch (e) {
				alert('ERROR:'+e);
			}
		}
	);

	/* 查询用户授权信息展现 */
	var grUserParams = {
		sysName:  "<sc:fmt value='pcmc' type='crypto'/>",
		  oprID:  "<sc:fmt value='privActor' type='crypto'/>",
		actions:  "<sc:fmt value='queryPrvGrantUser' type='crypto'/>",
	   nodetype:  nodetype,
	     funcrl:  '',
	     typecd:  '',
	     objtid:  ''};
	if(funcrl) {Object.extend(grUserParams, {funcrl:funcrl});}
	if(typecd) {Object.extend(grUserParams, {typecd:typecd});}
	if(objtid) {Object.extend(grUserParams, {objtid:objtid});}
	ajax.sendForXml('/xmlprocesserservlet', grUserParams, 
		function(grUserXml){
			try{
				uGrantedArr = new Array();		//全局变量临时存储
   				var pkg = new Jraf.Pkg(grUserXml);
   				/* 分类赋值选择控件展现 */
   				var userid, username, userdisp, status;
				var userArr = pkg.rspDatas().Record;
				if(!userArr) userArr=[];
				if(!Object.isArray(userArr)) userArr = [userArr];
				for(var i = 0; i < userArr.length; i++){
					status = userArr[i].status;
					usercode = userArr[i].usercode;
					username = userArr[i].username;
					userdisp = userArr[i].userdisp;
					if(status == '0') {
						/* 未授权用户添加 */
						addGrantSelOpt('unogrant', usercode + '/' + username, userdisp, username);
					} else if(status == '1') {
						/* 已授权用户添加 */
						addGrantSelOpt('ugranted', usercode + '/' + username, userdisp, username);
						uGrantedArr[uGrantedArr.length] = usercode;
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
function ajaxSubmit(formName, succMsg, failMsg) {
	var ajax = new Jraf.Ajax({ evalJS:false, evalJSON:false });
	ajax.submitFormXml(formName, function(xml){
		try {
			var pkg = new Jraf.Pkg(xml);
			if(pkg.result() != '0'){
				Jraf.showMessageBox({
					title: 	failMsg,
					text:	'<p class="error">' + pkg.allMsgs('<br>') + '</p>'
				});
			} else {
				if(!isBefore){
					//如果保存以前的无需提示保存成功
					Jraf.showMessageBox({
						title:	succMsg,
						text:	'<p class="success">' + pkg.allMsgs('<br>') + '</p>'
					});
				}
				isBefore = false;
			}
		} catch(e) {
			alert('ERROR:' + e);
		}
	});
}
</script>
</html>