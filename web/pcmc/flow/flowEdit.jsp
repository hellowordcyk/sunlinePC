<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>修改流程配置</title>
</head>
<body>
<sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="flowActor" actions="updateFlow">
	<sc:hidden name="flowid"/>
	<sc:hidden attributesText="id='delDetlcds'" name="delDetlcds"/>
	<sc:hidden attributesText="id='addDetlcds'" name="addDetlcds"/>
	<sc:hidden attributesText="id='updateDetlcds'" name="updateDetlcds"/>
	<!-- 流程配置部分 -->
	<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
		<tr><th colspan="4">流程配置</th></tr>
		<tr>
        	<sc:text name="flowna" dspName="流程名称" dsp="td" req="1" index="1" attributesText="maxLength='64'" />
        	<sc:select name="isclos" dspName="是否允许挂靠" type="dict" key="pcmc,boolflag" default="1" includeTitle="false" dsp="td" index="1" />
   		</tr>
   		<tr>
   			<sc:datepicker name="begndt" dspName="有效开始时间" pattern="%Y-%m-%d" dsp="td" req="1" index="1" attributesText="readOnly" />
   			<sc:datepicker name="overdt" dspName="有效结束时间" pattern="%Y-%m-%d" dsp="td" index="1" attributesText="readOnly" />
   		</tr>
   		<tr>
   			<sc:textarea name="remark" dspName="备注" cols="38%" rows="4" dsp="td" index="1" />
   		</tr>
	</table>
	<!-- 流程过程配置部分 -->
	<div style="width:100%" class="page-title"><span class="title" id='deltitle'>流程过程配置</span>
	<table width="100%" cellpadding="0" cellspacing="0" class="list-table">
		<tr>
			<td>
				&nbsp;&nbsp;<img src="/common/skins/default/images/pisa_plus.gif" width="15" height="15" onclick="addRow()" style="cursor:hand">&nbsp;&nbsp;
				<img src="/common/skins/default/images/pisa_minus.gif" width="15" height="15" onclick="deleteRow()" style="cursor:hand">
			</td>
		</tr>
		<tr>
		    <td>
		    <div id="recodeDiv" style="height:330px;overflow:auto">
				<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet" sort="list">
					<display:column style="width:7%;text-align:center" title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
		           		<input type="checkbox" id="detlcd${record_rowNum}" name="detlcdindex" onclick="outlineMyRow(this)" value='${record.detlcd}'/>
					</display:column>
					<display:column title="过程位置" style="text-align:center">
		           		<input type="text" name="detlpo" onclick="outlineMyRow(this)" value='${record.detlpo}' readOnly/>
					</display:column>
					<display:column title="过程代码" style="text-align:center">
						<input type="text" name="detlcd" onclick="outlineMyRow(this)" value='${record.detlcd}' maxLength='32'/>
					</display:column>
					<display:column title="过程类型" style="text-align:center">
						<input type="text" name="detltp" onclick="outlineMyRow(this)" value='${record.detltp}' readOnly/>
					</display:column>
					<display:column title="过程描述" style="text-align:center">
						<input type="text" name="detlds" onclick="outlineMyRow(this)" value='${record.detlds}' maxLength='512'/>
					</display:column>
				</display:table>
			</div>
			</td>
		</tr>
	</table>
	</div>
	<div style="width:100%" align="center" class="page-bottom">
        <sc:button value="保存" onclick="updateFlow()"/>
	    <sc:button value="重置" type="reset"/>
	    <sc:button value="退出" onclick="quit()"/>
    </div>
</sc:form>
</body>
<script type="text/javascript">
/**
 * ======================================================================================================================
 * 修改流程配置界面方法 		作者：曾慧磊		日期：2011-12-26
 * ======================================================================================================================
 */
 /** 全局变量 */
var oldDetlcds = new Array();;				//页面初始过程代码集
var oldDetltps = new Array();;				//页面初始过程类型集
var oldDetlds = new Array();;				//页面初始过程描述集
var oldDetlIndexs = new Array();;			//页面初始标识集
 
 /* 初始化界面 */
window.onload = function init() {
	if(getDetlNums() == 0){
		document.all.record.deleteRow(1);		//消除无数据显示行
	}
	/* 赋值变量集 */
	oldDetlcds = getTagArr("detlcd", true);
	oldDetltps = getTagArr("detltp", true);
	oldDetlds = getTagArr("detlds", true);
	oldDetlIndexs = getTagArr("detlcdindex", false);
};

/* 按钮事件 */
/** 修改 */
function updateFlow() {
	initFlowStatus();		//初始化保存数据的状态
	/* 更新流程 */
	if (checkForm(document.form) && personalCheck()){
		ajaxSubmit("form", "修改流程成功！", "修改流程失败！");
	}
}
/** 统一校验 */
function personalCheck() {
	if(dtCheck() && detlCheck() && detlcdCheck() && detldsCheck()){
		return true;
	}
	return false;
}
/** 初始化保存的数据状态：新增、修改、删除 */
function initFlowStatus() {
	var delVals = "";
	var addVals = "";
	var updateVals = "";
	var newDetlcds = getTagArr("detlcd", true);				//当前过程代码集
	var newDetltps = getTagArr("detltp", true);				//当前过程类型集
	var newDetlds = getTagArr("detlds", true);				//当前过程描述集
	var newDetlIndexs = getTagArr("detlcdindex", false);	//当前标识集
	/* 定义保存状态的过程代码集 */
	var oldIndex;
	var delIndexArr = oldDetlIndexs;
	if(oldDetlIndexs.length <= 0){
		for(var i = 0; i < newDetlcds.length; i++){
			addVals += newDetlcds[i] + ",";
		}
	}else{
		for(var i = 0; i < newDetlIndexs.length; i++){
			oldIndex = oldDetlIndexs.indexOf(newDetlIndexs[i]);
			if(newDetlcds[i] != oldDetlcds[oldIndex]){
				addVals += newDetlcds[i] + ",";
				delVals += oldDetlcds[oldIndex] + ",";
			} else if(newDetltps[i] != oldDetltps[oldIndex] || newDetlds[i] != oldDetlds[oldIndex]) {
				updateVals += newDetlcds[i] + ",";
			}
			if(i == 0){
				delIndexArr = oldDetlIndexs.without(newDetlIndexs[i]);
			}else{
				delIndexArr = delIndexArr.without(newDetlIndexs[i]);
			}
		}
		for(var j = newDetlIndexs.length; j < newDetlcds.length; j++){
			addVals += newDetlcds[j] + ",";
		}
		for(var k = 0; k < delIndexArr.length; k++){
			oldIndex = oldDetlIndexs.indexOf(delIndexArr[k]);
			delVals += oldDetlcds[oldIndex] + ",";
		}
	}
	$('delDetlcds').value = delVals.substr(0, delVals.length - 1);
	$('addDetlcds').value = addVals.substr(0, addVals.length - 1);
	$('updateDetlcds').value = updateVals.substr(0, updateVals.length - 1);
}

/** 新增行 */
var detlcdIndex = 0;
function addRow() {
	var cell;
	var row = document.all.record.insertRow();
	cell = row.insertCell();
	cell.innerHTML = "<input type='checkbox' name='childbox' />";
	cell.style.cssText = "text-align:center";
	cell = row.insertCell();
	var detlpoVal = Number(getMaxDetlpo()) + 1;
	cell.innerHTML = "<input type='text' class='inputtext' name='detlpo' value='" + detlpoVal + "' req='1' customtype='plus' readOnly />";
	cell.style.cssText = "text-align:center";
	cell = row.insertCell();
	detlcdIndex += 1;
	cell.innerHTML = "<input type='text' class='inputtext' id='detlcd" + detlcdIndex + "' name='detlcd' onblur='detlcdInputCheck(this)' maxLength='32' />";
	cell.style.cssText = "text-align:center";
	cell = row.insertCell();
	cell.innerHTML = "<input type='text' class='inputtext' name='detltp' maxLength='32' readOnly />";
	cell.style.cssText = "text-align:center";
	cell = row.insertCell();
	cell.innerHTML = "<input type='text' class='inputtext' name='detlds' onblur='detldsInputCheck(this)' maxLength='512' />";
	cell.style.cssText = "text-align:center";
	$("recodeDiv").scrollTop = $("recodeDiv").scrollHeight;		//记录滚动条放置最后
	refreshDetltp();		//刷新过程类型
}
/** 过程位置初始化值 */
function getMaxDetlpo(){
	var maxDetlpo = 0;
	var detlpoArr = document.getElementsByName("detlpo");
	var tempDetlpo;
	for(var i = 0; i < detlpoArr.length; i++){
		tempDetlpo = Number(detlpoArr[i].value);
		if(tempDetlpo != '' && tempDetlpo > maxDetlpo){
			maxDetlpo = tempDetlpo;
		}
	}
	return maxDetlpo;
}
/** 流程过程配置是否为空校验 */
function detlCheck() {
	if(getDetlNums() == 0){
		hint_alert($('deltitle'), "“流程过程配置”不能为空，请配置！");
		return false;
	}
	return true;
}
/** 过程代码保存时校验 */
function detlcdCheck() {
	var detlcdValArr = new Array();
	var detlcdArr = document.getElementsByName("detlcd");
	for(var i = 0; i < detlcdArr.length; i++){
		detlcdValArr[i] = detlcdArr[i].value;
		if(detlcdArr[i].value == ''){
			hint_alert(detlcdArr[i], "“过程代码”不可以省略，请重新输入！");
			return false;
		}
	}
	for(var i = 0; i < detlcdArr.length; i++){
		if(detlcdValArr.without(detlcdArr[i].value).length != detlcdArr.length - 1){
			hint_alert(detlcdArr[i], "“过程代码”不能重复，请重新输入！");
			return false;
		}
	}
	return true;
}
/** 过程描述保存时校验 */
function detldsCheck() {
	var detldsArr = document.getElementsByName("detlds");
	for(var i = 0; i < detldsArr.length; i++){
		if(detldsArr[i].value == ''){
			hint_alert(detldsArr[i], "“过程描述”不可以省略，请重新输入！");
			return false;
		}
	}
	return true;
}
/** 过程代码失去焦点事件 */
function detlcdInputCheck(detlcdCell){
	if(detlcdCell.value == ''){
		hint_alert(detlcdCell, "“过程代码”不可以省略，请重新输入！");
		return;
	}
	var detlcdArr = document.getElementsByName("detlcd");
	var tempDetlcd;
	for(var i = 0; i < detlcdArr.length; i++){
		tempDetlcd = detlcdArr[i].value;
		if(tempDetlcd != '' && tempDetlcd == detlcdCell.value && detlcdCell.id != detlcdArr[i].id){
			hint_alert(detlcdCell, "“过程代码”不能重复，请重新输入！");
			return;
		}
	}
}
/** 过程描述失去焦点事件 */
function detldsInputCheck(detldsCell){
	if(detldsCell.value == ''){
		hint_alert(detldsCell, "“过程描述”不可以省略，请重新输入！");
		return;
	}
}
/** 检验开始与结束日期 */
function dtCheck(){
	if($('overdt').value != '' && $('begndt').value >= $('overdt').value){
		hint_alert($('begndt'), "“开始时间”不能晚于“结束时间”，请重新输入！");
		return false;
	}
	return true;
}
/** 删除行 */
function deleteRow() {
	var inputTags = document.all.form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
	    var ele = inputTags[i];
	    if (ele.type == "checkbox" && ele.checked && ele.name != "allbox") {
	    	document.all.record.deleteRow(ele.parentElement.parentElement.rowIndex);
	    }
	}
	refreshDetltp();	//刷新过程类型
}
/** 刷新过程类型值 */
function refreshDetltp() {
	var detltpArr = document.getElementsByName("detltp");
	for(var i = 0; i < detltpArr.length; i++){
		detltpArr[i].value = "中间过程";
		detltpArr[detltpArr.length - 1].value = "结束过程";
		detltpArr[0].value = "开始过程";
	}
}
/** 工具方法：根据标签名称封装值数组 */
function getTagArr(tagName, isValue) {
	var tagArr = new Array();
	var tagEle = document.getElementsByName(tagName);
	for(var i = 0; i < tagEle.length; i++){
		if(isValue){
			tagArr[i] = tagEle[i].value;
		}else{
			tagArr[i] = tagEle[i].id;
		}
	}
	return tagArr;
}

/** 退出 */
function quit() {
	window.close();
}

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
/** 获取列表当前行数 */
function getDetlNums() {
	var num = 0;
	var inputTags = document.form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
	    var ele = inputTags[i];
	    if (ele.type == "checkbox" && ele.name != "allbox") {
	    	num += 1;
	    }
	}
	return num;
}

/* Ajax 提交方法 */
function ajaxSubmit(formName, successMsg, failMsg) {
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