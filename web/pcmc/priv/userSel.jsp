<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp" %>
</head>
<body>
<sc:form name="form" action="/pcmc/priv/privBaseAdd.so" method="post" sysName="pcmc" oprID="privActor" actions="queryPcmcUser">
  <div style="width:100%" class="page-title"><span class="title">选择【系统管理员】</span>
	<sc:hidden name="usercode" attributesText="id='usercode'"/>
	<div id="recodeDiv" style="height:310px;overflow:auto">
		<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/pcmc/priv/privBaseAdd.so" sort="list">
			<display:column style="width:7%;text-align:center">
	          	<input type="radio" name="userui" onclick="outlineMyRow(this)" value='${record.userui}'/>
			</display:column>
			<display:column property="usercode" title="用户编码"/>
			<display:column property="username" title="用户名称"/>
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
	setSelUser($('usercode').value);		//默认选择行
};
 
 /* 按钮事件 */
 /** 确定选择 */
function btnSure() {
	reValue(getSelUserArr());	//返回选择的用户数组：0 - userid, 1 - usercode, 2 - username
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
function setSelUser(usercode) {
	if(usercode == null || usercode == "" || usercode == undefined){
		return;
	}
	var inputTags = document.form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
	    var ele = inputTags[i];
	    if (ele.type == "radio" && usercode == ele.value.split(',')[1]) {
	    	ele.checked = true;
	    }
	}
}
/** 获取列表唯一勾选的值 */
function getSelUserArr() {
	var userArr;
	var inputTags = document.form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
	    var ele = inputTags[i];
	    if (ele.type == "radio" && ele.checked) {
	    	userArr = ele.value.split(',');
	    }
	}
	return userArr;
}
</script>
</html>