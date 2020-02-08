<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp" %>
</head>
<body>
<sc:form name="form" action="/pcmc/priv/privBaseAdd.so" method="post" sysName="pcmc" oprID="privActor" actions="queryBsCode">
  <div style="width:100%" class="page-title"><span class="title">选择【系统分类】</span>
	<sc:hidden name="bscode" attributesText="id='bscode'"/>
	<div id="recodeDiv" style="height:310px;overflow:auto">
		<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/pcmc/priv/privBaseAdd.so" sort="list">
			<display:column style="width:7%;text-align:center">
	          		<input type="radio" name="bscode" onclick="outlineMyRow(this)" value='${record.bscode}'/>
			</display:column>
			<display:column property="bscode" title="系统分类代码"/>
		</display:table>
	</div>
  </div>
  <div style="width:100%" align="center" class="page-bottom">
    <sc:button value="确定" onclick="btnSure()"/>
	<sc:button value="退出" onclick="quit()"/>
  </div>
</sc:form>
</body>
<script type="text/javascript">
/**
 * ==============================================================================================
 * 权限配置界面方法 		作者：曾慧磊		日期：2012-02-13
 * ==============================================================================================
 */
/* 初始化界面 */
window.onload = function init() {
	setSelBscode($('bscode').value);		//默认选择行
};
 
 /* 按钮事件 */
 /** 确定选择 */
function btnSure() {
	reValue(getSelBscode());	//返回选择的系统分类
}
/** 退出 */
function quit() {
	window.close();
}
 
/* 列表选择框事件 */
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
/** 设置列表初始勾选值 */
function setSelBscode(bscode) {
	if(bscode == null || bscode == "" || bscode == undefined){
		return;
	}
	var inputTags = document.form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
	    var ele = inputTags[i];
	    if (ele.type == "radio" && bscode == ele.value) {
	    	ele.checked = true;
	    }
	}
}
/** 获取列表唯一勾选的值 */
function getSelBscode() {
	var bscode;
	var inputTags = document.form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
	    var ele = inputTags[i];
	    if (ele.type == "radio" && ele.checked) {
	    	bscode = ele.value;
	    }
	}
	return bscode;
}
</script>
</html>