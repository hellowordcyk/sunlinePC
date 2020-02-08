<%--[id1:name1];[id2:name2];[id3:name3]--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>权限授权配置</title>
</head>
<body>
  <sc:hidden attributesText="id='bscode'" name="bscode"/>
  <table width="100%" height="100%" cellpadding="0" cellspacing="5" >
    <tr>
	  <td width="36%" valign="top">
	  	  <!-- 权限模块角色树显示部分 -->
	  	  <div class="page-title"><span class="title">权限模块角色树</span>
	  	    <div align="center" class="page-toolbar">
	  	        <sc:button _class="add" value="添加模块" onclick="addPrvFunc()" />
	  	 	    <sc:button _class="add" value="添加角色" onclick="addPrvRole()" attributesText="id='addRoleBtn'" />
	  	 	    <sc:button _class="edit" value="修改" onclick="updateFuncOrRole()" attributesText="id='modifyBtn'" />
	  	 	    <sc:button _class="delete" value="删除" onclick="delFuncOrRole()" attributesText="id='delBtn'" />
	  	    </div>
	  	    <div id="prvtree" style="height:600px;overflow:auto;"></div>
	     </div>
      </td>
	  <td width="64%" valign="top">
	    <sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="privActor" actions="saveOrUpdatePrvType">
	      <sc:hidden attributesText="id='typetp'" name="typetp"/>
	      <sc:hidden attributesText="id='funcrl'" name="funcrl"/>
	  	  <div class="page-title" style="width:610px;height:670px;overflow:auto;"><span class="title">功能类型配置</span>
	  	  	  <div id="tab" style="width:607px;height:601px;">
	  	  	  	  <ul id="menus-tab">
			        <li id='queryli' targetid='queryLi'>查询类型</li>
			        <li id='jspli' targetid='jspLi'>JSP 类型</li>
			      </ul>
			      <div class="content" id="queryDiv" style="width:100%;height:558px;overflow:auto;"></div>
                  <div class="content" id="jspDiv" style="width:100%;height:558px;overflow:auto;"></div>
	  	  	  </div>
	  	  </div>
	    </sc:form>
	  </td>
    </tr>
  </table>
</body>
<script type="text/javascript">
/**
 * ======================================================================================================================
 * 权限授权配置界面方法 		作者：曾慧磊		日期：2012-02-16
 * ======================================================================================================================
 */
/** 全局变量 */
var bscode = $('bscode').value;		//系统权限分类
var ajax = new Jraf.Ajax();			//Ajax 抽象类
var curFunccds = new Array();		//当前功能分类代码集
var curFuncrls = new Array();		//当前角色分类代码集

/** 树控件 */
var prvTree = new Jraf.Tree({
	selector:  '#prvtree',
	onexpand:  function(srcNode){expandNode(prvTree, srcNode);}
});
/** 页签控件 */
var curTabIndex;
var queryTabIndex = 1;
var jspTabIndex = 2;
var prvTab = new Jraf.Tabs({
	tabid:			"menus-tab",
	displayStyle:	"div",
	displayID:{queryLi: 'queryDiv', jspLi: 'jspDiv'}
});

/* 初始化界面 */
window.onload = function init() {
	/* 按钮默认状态 */
	$('addRoleBtn').disabled = true;
	$('modifyBtn').disabled = true;
	$('delBtn').disabled = true;
	loadPrvTree(prvTree);		//加载树结点
	/* 初始化页签事件 */
	prvTab.addAction(queryTabIndex, function(x){queryPrvType(queryTabIndex); return 'Loading...';});
	prvTab.addAction(jspTabIndex, function(x){queryPrvType(jspTabIndex); return 'Loading...';});
	$('tab').hide();		//默认隐藏显示
};

/* 树相关方法 */
/** 展开树结点的加载 */
function expandNode(prvTree, srcNode){
	srcNode.icon.src = srcNode.treeContext.imageList.item["hfold_open"].src;
	if (srcNode.first && srcNode.first.tag == 'asyncloading') {
		loadPrvTree(prvTree, srcNode.tag.funccd, srcNode.tag.funcrl);
	}
}
/** 加载树结点 */
function loadPrvTree (prvTree, funccd, funcrl) {
	/* 初始化参数变量 */
	var params = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID:		'<sc:fmt type="crypto" value="privActor"/>',
		actions:	'<sc:fmt type="crypto" value="queryPrvFuncRole"/>',
		bscode:		bscode,
		funccd:		'',
		funcrl:		''
	};
	if(funccd) {Object.extend(params, {funccd:funccd});}
	if(funcrl) {Object.extend(params, {funcrl:funcrl});}
	/* 查询初始化树结点 */
	ajax.sendForXml('/xmlprocesserservlet', params, function(xml){initPrvTree(xml, prvTree, funccd, funcrl);});
}
/** 树结点赋值 */
function initPrvTree (xml, prvTree, funccd, funcrl) {
	try{
		var pkg = new Jraf.Pkg(xml);
		if (pkg.result() != '0') {
			alert('获取权限树异常！\n' + pkg.allMsgs());		//查询失败处理
		}
		var rcds = pkg.rspDatas().Record;
		if(!rcds) {rcds = [];}
		if(!Object.isArray(rcds)) {rcds = [rcds];}
		rcds.each( function(rcd){addPrvNode(prvTree, rcd);}, this);		//循环添加结点
		if(funccd){
			var pNode = prvTree.treeContext.nodes[funccd + ',' + funcrl];
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
		name:		rcd.nodename,
		key:		rcd.funccd + ',' + rcd.funcrl,
		pkey:		rcd.funccd + ',' + 'null',
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
	/* 赋值全局变量 */
	curFunccds[curFunccds.length] = rcd.funccd;
	curFuncrls[curFuncrls.length] = rcd.funcrl;
	return prvNode;
}
/** 结点选择显示功能类型 */
function viewPrvType(prvNode){
	/* 设置按钮状态 */
	var selNode = prvTree.treeContext.getSelectedNode();
	if(selNode){
		$('addRoleBtn').disabled = false;
		$('modifyBtn').disabled = false;
		$('delBtn').disabled = false;
	}
	/* 当结点类型为角色时，查询权限功能类型 */
	var selType = prvTree.treeContext.getSelectedNode().tag.nodetype;
	if(selType == 'func'){
		$('tab').hide();		//隐藏显示
	}else if(selType == 'role'){
		$('tab').show();		//显示功能类型
		prvTab.init(queryTabIndex);
	}
}
/** 私有工具：后台查询集成页签方法 */
function queryPrvType(typeIndex) {
	var selFuncrl = prvTree.treeContext.getSelectedNode().tag.funcrl;
	var params = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID: 		'<sc:fmt type="crypto" value="privActor"/>',
		actions:	'<sc:fmt type="crypto" value="queryPrvType"/>',
		funcrl: 	selFuncrl,
		typetp:		typeIndex
	};
	if(typeIndex == queryTabIndex){
		curTabIndex = queryTabIndex;
		ajax.loadPageTo('/pcmc/priv/privSearchTab.so', params, 'queryDiv');
	}else if(typeIndex == jspTabIndex){
		curTabIndex = jspTabIndex;
		ajax.loadPageTo('/pcmc/priv/privJspTab.so', params, 'jspDiv');
	}
}

/* 按钮事件 */
/** 新增模块 */
function addPrvFunc() {
	var url = "/pcmc/priv/privFuncAdd.jsp?bscode=" + bscode + "&curFunccds=" + curFunccds;
		url += '&s_time=' + new Date().getTime();
	var ret = openModal(url, 380, 200);
	if(ret){
		var rcd = {
			bscode:		bscode,
			childnum:	'0',
			funccd:		ret[0],
			funcna:		ret[1],
			funcrl:		'null',	
			nodename:	ret[1] + "[" + ret[0] + "]",
			nodetype:   'func',
			rolena:		'null'
		};
		var prvNode = addPrvNode(prvTree, rcd);
		prvNode.select();		//选定新增结点
		/* 并设置按钮状态 */
		$('addRoleBtn').disabled = false;
		$('modifyBtn').disabled = false;
		$('delBtn').disabled = false;
	}
}
/** 新增角色 */
function addPrvRole() {
	/* 获取当前选择的结点值集*/
	var selTag = prvTree.treeContext.getSelectedNode().tag;
	var url = "/pcmc/priv/privRoleAdd.jsp?bscode=" + bscode + "&funccd=" + selTag.funccd + "&curFuncrls=" + curFuncrls;
		url += '&s_time=' + new Date().getTime();
	var ret = openModal(url, 380, 200);
	if(ret){
		var rcd = {
			bscode:		bscode,
			childnum:	'0',
			funccd:		selTag.funccd,
			funcna:		selTag.funcna,
			funcrl:		ret[0],	
			nodename:	ret[1] + "[" + ret[0] + "]",
			nodetype:   'role',
			rolena:		ret[1]
		};
		var prvNode = addPrvNode(prvTree, rcd);
		prvNode.select();		//选定新增结点
	}
}
/** 修改模块或角色 */
function updateFuncOrRole() {
	/* 根据结点类型执行相应操作 */
	var selType = prvTree.treeContext.getSelectedNode().tag.nodetype;
	if(selType == 'func'){
		updatePrvFunc();
	}else if(selType == 'role'){
		updatePrvRole();
	}
}
/** 删除模块或角色 */
function delFuncOrRole() {
	/* 根据结点类型执行相应操作 */
	var selType = prvTree.treeContext.getSelectedNode().tag.nodetype;
	if(selType == 'func'){
		delPrvFunc();
	}else if(selType == 'role'){
		delPrvRole();
	}
}
/** 修改模块 */
function updatePrvFunc() {
	/* 获取当前选择的结点值集*/
	var prvNode = prvTree.treeContext.getSelectedNode();
	var selTag = prvNode.tag;
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>'+
	'&oprID=<sc:fmt type="crypto" value="privActor"/>'+
	'&actions=<sc:fmt type="crypto" value="queryPrvFuncByID"/>&forward=<sc:fmt value='/pcmc/priv/privFuncUpdate.jsp' type='crypto'/>'+
	'&bscode='+bscode+'&funccd='+selTag.funccd;
		url += '&s_time=' + new Date().getTime();
	var ret = openModal(url, 380, 155);
	if(ret){
		var rcd = {
			bscode:		bscode,
			childnum:	selTag.childnum,
			funccd:		ret[0],
			funcna:		ret[1],
			funcrl:		'null',	
			nodename:	ret[1] + "[" + ret[0] + "]",
			nodetype:   'func',
			rolena:		'null'
		};
		prvNode.tag = rcd;		//修改当前结点属性
		prvNode.label.innerHTML = rcd.nodename;		//显示标题修改
		prvNode.select();		//选定修改的结点
	}
}
/** 修改角色 */
function updatePrvRole() {
	/* 获取当前选择的结点值集*/
	var prvNode = prvTree.treeContext.getSelectedNode();
	var selTag = prvNode.tag;
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>'+
	'&oprID=<sc:fmt type="crypto" value="privActor"/>'+
	'&actions=<sc:fmt type="crypto" value="queryPrvPoleByID"/>'+
	'&forward=<sc:fmt value='/pcmc/priv/privRoleUpdate.jsp' type='crypto'/>&funcrl='+selTag.funcrl;
	url += '&s_time=' + new Date().getTime();
	var ret = openModal(url, 380, 185);
	if(ret){
		var rcd = {
			bscode:		bscode,
			childnum:	'0',
			funccd:		selTag.funccd,
			funcna:		selTag.funcna,
			funcrl:		ret[0],	
			nodename:	ret[1] + "[" + ret[0] + "]",
			nodetype:   'role',
			rolena:		ret[1]
		};
		prvNode.tag = rcd;		//修改当前结点属性
		prvNode.label.innerHTML = rcd.nodename;		//显示标题修改
		prvNode.select();		//选定修改的结点
	}
}
/** 删除模块 */
function delPrvFunc() {
	if(!confirm("是否删除所选择的模块及其关联的角色？"))		return;
	var selFunccd = prvTree.treeContext.getSelectedNode().tag.funccd;
	curFunccds = curFunccds.without(selFunccd);	// 赋值全局变量
	prvTree.treeContext.getSelectedNode().remove();		//界面去除结点
	var delParams = {
		sysName:  "<sc:fmt value='pcmc' type='crypto'/>",
		  oprID:  "<sc:fmt value='privActor' type='crypto'/>",
		actions:  "<sc:fmt value='deletePrvFunc' type='crypto'/>",
		 bscode:  bscode,
		 funccd:  selFunccd};
	ajax.sendForXml('/xmlprocesserservlet', delParams, function(xml){});
}
/** 删除角色 */
function delPrvRole() {
	if(!confirm("是否删除所选择的角色？"))		return;
	var prvNode = prvTree.treeContext.getSelectedNode();
	var selFuncrl = prvNode.tag.funcrl;
	curFuncrls = curFuncrls.without(selFuncrl);	// 赋值全局变量
	prvNode.remove();		//界面去除结点
	var delParams = {
		sysName:  "<sc:fmt value='pcmc' type='crypto'/>",
		  oprID:  "<sc:fmt value='privActor' type='crypto'/>",
		actions:  "<sc:fmt value='deletePrvRole' type='crypto'/>",
		 funcrl:  selFuncrl};
	ajax.sendForXml('/xmlprocesserservlet', delParams, function(xml){});
	/* 父结点唯一子结点时特殊图标处理 */
	var parentNode = prvNode.parent;
	if (!parentNode.hasChild) {
		parentNode.icon.src = parentNode.treeContext.imageList.item["default"].src;
	}
}
/** 退出 */
function quit() {
	window.close();
}

/* 引入的页签方法 */
/* 列表选择框事件 */
function checkAll(ck) {
  for (var i = 0; i < ck.form.all.tags("input").length; i++) {
    var ele = ck.form.all.tags("input")[i];
    if ((ele.type == "checkbox")) {
      if(ck.checked != ele.checked) {
    	  ele.click();
      }
    }
  }
}
function outlineMyRow(ckr) {
    var otr = ckr.parentElement.parentElement;
    if (otr.tagName.toUpperCase() == "TR") {
     if (ckr.checked == true) {
      ckr.ocls = otr.className;
      otr.className = "select";
     } else {
       otr.className = ckr.ocls;
     }
   }
}
/* 保存时的对比操作 */
var delTypecds = new Array();		//删除行操作的初始化功能类型代码集
var delTypeIndexs = new Array();	//删除行操作的初始化标识集

/** 初始化保存的数据状态：新增、修改、删除 */
function initSaveStatus() {
	var delVals = "";
	var addVals = "";
	var updateVals = "";
	var oldTypecds = getTagArr("typecd", false, true).without("");		//初始时功能类型代码集
	var oldTypenas = getTagArr("typena", false, true).without("");		//初始时功能类型名称集
	var oldTypeIndexs = getTagArr("typecdindex", false, false);			//初始时标识集
	/* 添加删除操作的初始化集 */
	oldTypecds = oldTypecds.concat(delTypecds);
	oldTypeIndexs = oldTypeIndexs.concat(delTypeIndexs);
	var newTypecds = getTagArr("typecd", true, false);				//当前功能类型代码集
	var newTypenas = getTagArr("typena", true, false);				//当前功能类型名称集
	var newTypeIndexs = getTagArr("typecdindex", false, false);		//当前标识集
	/* 定义保存状态的过程代码集 */
	var oldIndex;
	var delIndexArr = oldTypeIndexs;
	if(oldTypeIndexs.length <= 0){
		for(var i = 0; i < newTypecds.length; i++){
			addVals += newTypecds[i] + ",";
		}
	}else{
		for(var i = 0; i < newTypeIndexs.length; i++){
			oldIndex = oldTypeIndexs.indexOf(newTypeIndexs[i]);
			if(newTypecds[i] != oldTypecds[oldIndex]){
				addVals += newTypecds[i] + ",";
				delVals += oldTypecds[oldIndex] + ",";
			} else if(newTypenas[i] != oldTypenas[oldIndex]) {
				updateVals += newTypecds[i] + ",";
			}
			if(i == 0){
				delIndexArr = oldTypeIndexs.without(newTypeIndexs[i]);
			}else{
				delIndexArr = delIndexArr.without(newTypeIndexs[i]);
			}
		}
		for(var j = newTypeIndexs.length; j < newTypecds.length; j++){
			addVals += newTypecds[j] + ",";
		}
		for(var k = 0; k < delIndexArr.length; k++){
			oldIndex = oldTypeIndexs.indexOf(delIndexArr[k]);
			delVals += oldTypecds[oldIndex] + ",";
		}
	}
	$('delTypecds').value = delVals.substr(0, delVals.length - 1);
	$('addTypecds').value = addVals.substr(0, addVals.length - 1);
	$('updateTypecds').value = updateVals.substr(0, updateVals.length - 1);
}

/** 工具方法：根据标签名称封装值数组 */
function getTagArr(tagName, isValue, isOldValue) {
	var tagArr = new Array();
	var tagEle = document.getElementsByName(tagName);
	for(var i = 0; i < tagEle.length; i++){
		if(isValue){
			tagArr[i] = tagEle[i].value;
		} else if(isOldValue) {
			tagArr[i] = tagEle[i].oldvalue;
		} else{
			tagArr[i] = tagEle[i].id;
		}
	}
	return tagArr;
}

/* 按钮事件 */
/** 引入类型 */
function importType(typecdInputId, typenaInputId) {
	/* 特殊处理，考虑引入重复会删除旧类型代码 */
	var oldtypecd = $(typecdInputId).value;
	var curTypecds = getTagArr("typecd", true, false);	// 当前功能类型代码集
	if (curTypecds.without(oldtypecd).length != curTypecds.length - 1) {
		oldtypecd = '';
	}
	var selFuncrl = prvTree.treeContext.getSelectedNode().tag.funcrl;
	var url = '/pcmc/priv/privTypeImport.jsp?bscode=' + bscode + '&funcrl=' + selFuncrl + '&oldtypecd=' + oldtypecd;
	var ret = openModal(url, 760, 570);
	if(ret != undefined){
		$(typecdInputId).value = ret[0];
		$(typenaInputId).value = ret[1];
		/* 校验引入重复 */
		var newTypecds = getTagArr("typecd", true, false);	// 当前功能类型代码集
		if (newTypecds.without(ret[0]).length != newTypecds.length - 1) {
			hint_alert($(typecdInputId), "“功能类型代码”引入重复，请重新配置！");
		}
		resetBtn();//刷新页面
	}
}
/** 保存 */
function saveBtn() {
	/* 初始化后台所需提交参数 */
	$('typetp').value = curTabIndex;
	$('funcrl').value = prvTree.treeContext.getSelectedNode().tag.funcrl;		
	initSaveStatus();		//对比保存状态
	if (checkForm(document.form) && saveCheck()){
		ajaxSubmit("form", "保存功能类型成功！", "保存功能类型失败！");
	}
}
/** 重新查询列表加载 */
function refreshPrvType() {
	queryPrvType(curTabIndex);		
}
/** 重置 */
function resetBtn() {
	refreshPrvType();
}
/** 新增行 */
var rowIndex = 0;
function addRow() {
	var cell, row;
	if(curTabIndex == queryTabIndex){
		/* 查询类型 */
		row = document.all.record.insertRow();
		rowIndex += 1;
		cell = row.insertCell();
		cell.innerHTML = "<input type='checkbox' name='childbox' />";
		cell.style.cssText = "text-align:center";
		cell = row.insertCell();
		cell.innerHTML = "<input type='text' class='inputtext' id='inputtypecd" + rowIndex + "' name='typecd' oldvalue='' onblur='typecdInputCheck(this)' maxLength='128' />";
		cell.style.cssText = "text-align:center";
		cell = row.insertCell();
		cell.innerHTML = "<input type='text' class='inputtext' id='inputtypena" + rowIndex + "'name='typena' oldvalue='' onblur='typenaInputCheck(this)' maxLength='64' />";
		cell.style.cssText = "text-align:center";
	}else if(curTabIndex == jspTabIndex){
		/* JSP类型 */
		row = document.all.jspRecord.insertRow();
		rowIndex += 1;
		cell = row.insertCell();
		cell.innerHTML = "<input type='checkbox' name='childbox' />";
		cell.style.cssText = "text-align:center";
		cell = row.insertCell();
		cell.innerHTML = "<input type='text' class='inputtext' id='inputtypecd" + rowIndex + "' name='typecd' oldvalue='' maxLength='128' readOnly />";
		cell.style.cssText = "text-align:center";
		cell = row.insertCell();
		cell.innerHTML = "<input type='text' class='inputtext' id='inputtypena" + rowIndex + "'name='typena' oldvalue='' maxLength='64' readOnly />";
		cell.style.cssText = "text-align:center";
		cell = row.insertCell();
		cell.innerHTML = "<input type='button' class='button' value='引入类型' onclick='importType(inputtypecd" + rowIndex + ", inputtypena" + rowIndex + ")' />";
		cell.style.cssText = "text-align:center";
	}
	$("recodeDiv").scrollTop = $("recodeDiv").scrollHeight;		//记录滚动条放置最后
}
/** 删除行 */
function deleteRow() {
	var inputTags = document.all.form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
    	var ele = inputTags[i];
    	if (curTabIndex == queryTabIndex && ele.type == "checkbox" && ele.checked && ele.name != "allbox" ) {
        	/* 查询类型  */
    		document.all.record.deleteRow(ele.parentElement.parentElement.rowIndex);
    		/* 赋值删除初始化的变量 */
    		if(ele.name != "childbox"){
    			delTypecds[delTypecds.length] = ele.value;
    			delTypeIndexs[delTypeIndexs.length] = ele.id;
    		}
    	}else if(curTabIndex == jspTabIndex && ele.type == "checkbox" && ele.checked && ele.name != "allbox" ){
        	/* JSP类型 */
        	document.all.jspRecord.deleteRow(ele.parentElement.parentElement.rowIndex);
        	/* 赋值删除初始化的变量 */
        	if(ele.name != "childbox"){
        		delTypecds[delTypecds.length] = ele.value;
        		delTypeIndexs[delTypeIndexs.length] = ele.id;
        	}
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
				Jraf.showMessageBox({
					title:	succMsg,
					text:	'<p class="success">' + pkg.allMsgs('<br>') + '</p>',
					onOk:   function() {refreshPrvType();}		//确定后删除列表
				});
			}
		} catch(e) {
			alert('ERROR:' + e);
		}
	});
}
/* 页签中各种校验 */
/** 功能类型代码失去焦点事件 */
function typecdInputCheck(typecdCell){
	if(typecdCell.value == ''){
		hint_alert(typecdCell, "“功能类型代码”不可以省略，请重新输入！");
		return;
	}
	var tempTypecd;
	var typecdArr = document.getElementsByName("typecd");
	for(var i = 0; i < typecdArr.length; i++){
		tempTypecd = typecdArr[i].value;
		if(tempTypecd != '' && tempTypecd == typecdCell.value && typecdCell.id != typecdArr[i].id){
			hint_alert(typecdCell, "“功能类型代码”不能重复，请重新输入！");
			return;
		}
	}
}
/** 功能类型名称失去焦点事件 */
function typenaInputCheck(typenaCell){
	if(typenaCell.value == ''){
		hint_alert(typenaCell, "“功能类型名称”不可以省略，请重新输入！");
		return;
	}
}
/** 统一输入校验 */
function saveCheck() {
	if(typecdCheck() && typenaCheck()){
		return true;
	}
	return false;
}
/** 功能类型代码保存时校验 */
function typecdCheck() {
	var typecdValArr = new Array();
	var typecdArr = document.getElementsByName("typecd");
	for(var i = 0; i < typecdArr.length; i++){
		typecdValArr[i] = typecdArr[i].value;
		if(typecdArr[i].value == ''){
			hint_alert(typecdArr[i], "“功能类型代码”不可以省略，请重新输入！");
			return false;
		}
	}
	for(var i = 0; i < typecdArr.length; i++){
		if(typecdValArr.without(typecdArr[i].value).length != typecdArr.length - 1){
			hint_alert(typecdArr[i], "“功能类型代码”不能重复，请重新输入！");
			return false;
		}
	}
	return true;
}
/** 功能类型名称保存时校验 */
function typenaCheck() {
	var typenaArr = document.getElementsByName("typena");
	for(var i = 0; i < typenaArr.length; i++){
		if(typenaArr[i].value == ''){
			hint_alert(typenaArr[i], "“过程描述”不可以省略，请重新输入！");
			return false;
		}
	}
	return true;
}
</script>
</html>