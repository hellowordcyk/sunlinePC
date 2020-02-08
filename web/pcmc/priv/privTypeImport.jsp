<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>引入功能类型</title>
</head>
<body>
  <table width="100%" height="90%" cellpadding="0" cellspacing="5" >
    <tr>
	  <td width="36%" valign="top">
	  	  <!-- 功能类型代码树显示部分 -->
	  	  <div class="page-title"><span id="treeDiv" class="title">功能类型代码树</span>
	  	    <div id="prvtree" style="width:300px;height:485px;overflow:auto;"></div>
	     </div>
      </td>
	  <td width="64%" valign="top">
	    <sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="privActor" actions="savePrvButn">
	      <sc:hidden attributesText="id='bscode'" name="bscode"/>
	      <sc:hidden attributesText="id='funcrl'" name="funcrl"/>
	      <sc:hidden attributesText="id='typecd'" name="typecd"/>
	      <sc:hidden attributesText="id='typena'" name="typena"/>
	      <sc:hidden attributesText="id='oldtypecd'" name="oldtypecd"/>
	      <div class="page-title" style="height:514px;overflow:auto;"><span id="jspDiv" class="title">JSP 要素权限配置</span>
	  	  	<div id="recodeDiv" style="height:485px;overflow:auto;"></div>
	  	  </div>
	    </sc:form>
	  </td>
    </tr>
  </table>
  <div style="width:100%" align="center" class="page-bottom">
      <sc:button value="保存" onclick="btnSure()"/>
	  <sc:button value="退出" onclick="quit()"/>
  </div>
</body>
<script type="text/javascript">
/**
 * ======================================================================================================================
 * 引入功能类型配置界面方法 		作者：曾慧磊		日期：2012-02-22
 * ======================================================================================================================
 */
 /** 全局变量 */
var bscode = $('bscode').value;				//系统权限分类
var funcrl = $('funcrl').value;				//权限角色代码
var ajax = new Jraf.Ajax();					//Ajax 抽象类
 
/** 树控件 */
var prvTree = new Jraf.Tree({
	selector:  '#prvtree',
	onexpand:  function(srcNode){expandNode(prvTree, srcNode);}
});

/* 初始化界面 */
window.onload = function init() {
	loadPrvTree(prvTree);		//加载树结点
	$('recodeDiv').hide();		//隐藏显示配置列表
};

/* 按钮事件 */
/** 保存 */
function btnSure() {
	if(saveCheck()){
		var selTag = prvTree.treeContext.getSelectedNode().tag;
		$('typecd').value = selTag.typecd;
		$('typena').value = selTag.typena;
		ajaxSubmit("form", "保存功能类型、权限要素成功！", "保存功能类型、权限要素失败！");
	}
}
/** 退出 */
function quit() {
	window.close();
}
 
/* 树相关方法 */
/** 展开树结点的加载 */
function expandNode(prvTree, srcNode){
	srcNode.icon.src = srcNode.treeContext.imageList.item["hfold_open"].src;
	if (srcNode.first && srcNode.first.tag == 'asyncloading') {
		loadPrvTree(prvTree, srcNode.tag.typecd);
	}
}
/** 加载树结点 */
function loadPrvTree (prvTree, typecd) {
	/* 初始化参数变量 */
	var params = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID:		'<sc:fmt type="crypto" value="privActor"/>',
		actions:	'<sc:fmt type="crypto" value="queryPrvTypeTree"/>',
		bscode:		bscode,
		typecd:		''
	};
	if(typecd) {Object.extend(params, {typecd:typecd});}
	/* 查询初始化树结点 */
	ajax.sendForXml('/xmlprocesserservlet', params, function(xml){initPrvTree(xml, prvTree, typecd);});
}
/** 树结点赋值 */
function initPrvTree (xml, prvTree, typecd) {
	try{
		var pkg = new Jraf.Pkg(xml);
		if (pkg.result() != '0') {
			alert('获取功能类型树异常！\n' + pkg.allMsgs());		//查询失败处理
		}
		var rcds = pkg.rspDatas().Record;
		if(!rcds) {rcds = [];}
		if(!Object.isArray(rcds)) {rcds = [rcds];}
		rcds.each( function(rcd){addPrvNode(prvTree, rcd);}, this);		//循环添加结点
		if(typecd){
			var pNode = prvTree.treeContext.nodes[typecd];
			if (pNode.first && pNode.first.tag == 'asyncloading') {
				pNode.first.remove();		//消除是否含子结点的标志行
			}
		}
	} catch(ex) {
		alert('ERROR:' + ex);
	}
}
/** 树结点添加结点 */
function addPrvNode(prvTree, rcd){
	var item = {
		name:		rcd.typena,
		key:		rcd.typecd,
		pkey:		rcd.ptypecd,
		onClick:	viewPrvButn,	//点击结点响应事件
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
	return prvNode;
}
/** 结点选择显示Jsp要素 */
function viewPrvButn(prvNode){
	var selTag = prvTree.treeContext.getSelectedNode().tag;
	var selFiletype = selTag.filetype;
	if(selFiletype == 'directory'){
		$('recodeDiv').hide();		//隐藏显示配置列表
	} else if(selFiletype == 'jspfile') {
		$('recodeDiv').show();		//显示配置列表
		var params = {
			sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
			oprID: 		'<sc:fmt type="crypto" value="privActor"/>',
			actions:	'<sc:fmt type="crypto" value="queryPrvButn"/>',
			typecd: 	selTag.typecd
		};
		ajax.loadPageTo('/pcmc/priv/privButnTable.so', params, 'recodeDiv');
	}
}
/** 保存时的校验  */
function saveCheck() {
	if(treeSelCheck() && jspTabCheck()) {
		return true;
	}
	return false;
}
/** 树结点选择的校验  */
function treeSelCheck() {
	var selNode = prvTree.treeContext.getSelectedNode();
	if(!selNode || selNode.tag.filetype == 'directory'){
		hint_alert($('treeDiv'), "请选择“功能类型代码树”的 JSP 结点配置！");
		return false;
	}
	return true;
}
/** JSP配置的校验  */
function jspTabCheck() {
	/* 获取列表是否有值的标志 */
	var ele, rownum;
	var inputTags = document.form.tags("input");
	for (var i = 0; i < inputTags.length; i++) {
	    ele = inputTags[i];
	    if (ele.type == "hidden" && ele.name == "rownums") {
	    	rownum = ele.id;
	    }
	}
	if(!rownum){
		hint_alert($('jspDiv'), "“JSP 要素权限配置”为空，请重新选择 JSP 结点配置！");
		return false;
	}
	return true;
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
				Jraf.showMessageBox({
					title:	succMsg,
					text:	'<p class="success">' + pkg.allMsgs('<br>') + '</p>',
					onOk:   function() {reValue(getRetArr());}		
				});
			}
		} catch(e) {
			alert('ERROR:' + e);
		}
	});
}
/** 定义返回值 */
function getRetArr() {
	var selTag = prvTree.treeContext.getSelectedNode().tag;
	var retArr = new Array();
	retArr[0] = selTag.typecd;
	retArr[1] = selTag.typena;
	return retArr;
}
</script>
</html>