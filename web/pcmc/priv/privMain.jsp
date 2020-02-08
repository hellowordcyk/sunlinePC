<%--[id1:name1];[id2:name2];[id3:name3]--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
	<%@ include file="/common.jsp" %>
</head>
<body>

	<!-- 查询部分 -->
	<sc:form name="query_form" action="/pcmc/priv/privMain.so" method="post" sysName="pcmc" oprID="privActor" actions="queryPrvBase">
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table" >
			<tr><th colspan="4">查询条件</th></tr>
			<tr><sc:text name="bsname" dspName="系统分类名称" dsp="td" /></tr>
			<tr>
			     <td colspan="4" class="form-bottom" align="center">
			     	<sc:button attributesText="id='queryBtn'" value="查询" onclick="queryPrvBase()" />
			     	<sc:button value="重置" type="reset" />
			     </td>
			</tr>
		</table>
	</sc:form>
	<!-- 列表部分 -->
	<sc:form name="page_form" action="/pcmc/priv/privMain.so" method="post" sysName="pcmc" oprID="privActor" actions="queryPrvBase">
		<input type="hidden"/>
		<sc:hidden name="bsname"/>
		<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/pcmc/priv/privMain.so" sort="list">
			<display:column  title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
           		<input type="checkbox" name="bscode" onclick="outlineMyRow(this)" value='${record.bscode}'/>
			</display:column>
			<display:column property="bscode" title="系统分类代码" sortable="true" />
			<display:column property="bsname" title="系统分类名称" sortable="true" />
			<display:column  title="权限分类状态" sortable="true">
				<sc:optd name="status" value="${record.status}" type="dict" key="pcmc,status" />
			</display:column>
			<display:column property="opernaUI" title="系统管理员" sortable="true" />
			<display:footer>
	              <tr>
	                  <td colspan="8">
	                      <div class="operator" >
		                      <sc:button value="新增" _class="add" onclick="addPrvBase()" /> 
		                      <sc:button value="修改" _class="edit" onclick="updatePrvBase()" /> 
		                  	  <sc:button value="删除" _class="delete" onclick="deletePrvBase()" />
		                  	  <sc:button value="授权" _class="edit" onclick="grantPriv()" /> 
		               	  </div>
		                  <%@ include file="/include/pager.jsp" %>
	                  </td>
	              </tr>
	           </display:footer>
		</display:table>
	</sc:form>
</body>
<script type="text/javascript">
/**
 * ==============================================================================================
 * 权限配置界面方法 		作者：曾慧磊		日期：2012-02-13
 * ==============================================================================================
 */
/* 按钮事件 */
/** 查询 */
function queryPrvBase() {
	$("queryBtn").disabled = true;
	document.query_form.submit();
}
/*重置*/
 function reSet(){
	document.getElementsByName("bsname")[0].value="";
}
/** 新增 */
function addPrvBase() {
	var url = "/pcmc/priv/privBaseAdd.jsp";
	var ret = openModal(url, 400, 220);
	if(ret != null && ret == 1){
		queryPrvBase();		//刷新界面
	}
}
/** 修改 */
function updatePrvBase() {
	if(getSelNums() != 1){
		alert("请选择一行记录操作！");
		return;	
	}
	var bscode = getSelBsCode();
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="privActor"/>&actions=<sc:fmt type="crypto" value="queryPrvBase"/>&forward=<sc:fmt value='/pcmc/priv/privBaseUpdate.jsp' type='crypto'/>&oldbscode=' + bscode;
		url += '&s_time=' + new Date().getTime();
	var ret = openModal(url, 450, 220);
	if(ret != null && ret == 1){
		queryPrvBase();		//刷新界面
	}
}
/** 删除 */
function deletePrvBase() {
	if(getSelNums() == 0){
		alert("请选择需要操作的记录！");
		return;
	}
	if(confirm("是否删除所选择的记录？")){
		var pageForm = document.forms["page_form"];
		pageForm.actions.value='<sc:fmt type="crypto" value="deletePrvBase"/>';
		pageForm.forward.value='/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="privActor"/>&actions=<sc:fmt type="crypto" value="queryPrvBase"/>&forward=<sc:fmt value='/pcmc/priv/privMain.jsp' type='crypto'/>';
		pageForm.submit();
	}
}
/** 授权 */
function grantPriv() {
	if(getSelNums() != 1){
		alert("请选择一行记录操作！");
		return;
	}
	var bscode = getSelBsCode();
	var url = '/pcmc/priv/privGrant.jsp?bscode=' + bscode;
	openModal(url, 960, 691);
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
/** 获取列表勾选的行数 */
function getSelNums() {
	var num = 0;
	var inputTags = document.page_form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
	    var ele = inputTags[i];
	    if (ele.type == "checkbox" && ele.checked && ele.name != "allbox") {
	    	num += 1;
	    }
	}
	return num;
}
/** 获取列表唯一勾选的值 */
function getSelBsCode() {
	var flowid;
	var inputTags = document.page_form.tags("input");
	for (var i = inputTags.length - 1; i >= 0; i--) {
	    var ele = inputTags[i];
	    if (ele.type == "checkbox" && ele.checked && ele.name != "allbox") {
	    	flowid = ele.value;
	    }
	}
	return flowid;
}
</script>
</html>