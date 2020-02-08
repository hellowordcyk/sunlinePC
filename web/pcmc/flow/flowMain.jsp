<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp" %>
</head>
<body>
	<!-- 查询部分 -->
	<sc:form name="query_form" action="/pcmc/flow/flowMain.so" method="post" sysName="pcmc" oprID="flowActor" actions="queryFlow">
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<tr><th colspan="4">查询条件</th></tr>
			<tr><sc:text name="flowna" dspName="流程名称" dsp="td" /></tr>
			<tr>
			     <td colspan="4" class="form-bottom" align="center">
			     	<sc:button attributesText="id='queryBtn'" value="查询" onclick="queryFlow()" />
			     	<sc:button value="重置" type="reset" />
			     </td>
			</tr>
		</table>
	</sc:form>
	<!-- 列表部分 -->
	<sc:form name="page_form" action="/pcmc/flow/flowMain.so" method="post" sysName="pcmc" oprID="flowActor" actions="queryFlow">
		<input type="hidden"/>
		<sc:hidden name="flowna"/>
		<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/pcmc/flow/flowMain.so" sort="list">
			<display:column style="width:7%;text-align:center" title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
           		<input type="checkbox" name="flowid" onclick="outlineMyRow(this)" value='${record.flowid}'/>
			</display:column>
			<display:column property="flowna" title="流程名称" sortable="true" />
			<display:column style="width:8%;text-align:center" title="是否允许挂靠" sortable="true">
				<sc:optd name="isclos" value="${record.isclos}" type="dict" key="pcmc,boolflag" />
			</display:column>
			<display:column property="begndt" title="有效开始时间" sortable="true" />
			<display:column property="overdt" title="有效结束时间" sortable="true" />
			<display:column property="username" title="创建人" />
			<display:column property="creatm" title="创建时间" sortable="true" />
			<display:column style="width:3%;text-align:center" title="操作">
				<sc:button value="详细信息" onclick="viewFlow('${record.flowid}')" />
			</display:column>
			<display:footer>
              <tr>
                  <td colspan="8">
                      <div class="operator" >
	                      <sc:button value="新增" _class="add" onclick="addFlow()" /> 
	                      <sc:button value="修改" _class="edit" onclick="editFlow()" /> 
	                  	  <sc:button value="删除" _class="delete" onclick="deleteFlow()" />
	                  	  <sc:button value="授权" _class="edit" onclick="grantFlow()" /> 
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
 * =========================================================================
 * 流程配置界面方法 		作者：曾慧磊		日期：2011-12-26
 * =========================================================================
 */
/* 按钮事件 */
/** 查询 */
function queryFlow() {
	$("queryBtn").disabled = true;
	document.query_form.submit();
}
/** 新增 */
function addFlow() {
	var url = "/pcmc/flow/flowAdd.jsp";
	var ret = openModal(url, 800, 600);
	if(ret != null && ret == 1){
		queryFlow();	//刷新界面
	}
}
/** 修改 */
function editFlow() {
	if(getSelNums() != 1){
		alert("请选择一行记录操作！");
		return;	
	}
	var flowid = getSelFlowId();
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="flowActor"/>&actions=<sc:fmt type="crypto" value="queryFlowDetl"/>&forward=<sc:fmt value='/pcmc/flow/flowEdit.jsp' type='crypto'/>&flowid=' + flowid;
		url += '&s_time=' + new Date().getTime();
	var ret = openModal(url, 800, 600);
	if(ret != null && ret == 1){
		queryFlow();	//刷新界面
	}
}
/** 查看 */
function viewFlow(flowid) {
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="flowActor"/>&actions=<sc:fmt type="crypto" value="queryFlowDetl"/>&forward=<sc:fmt value='/pcmc/flow/flowView.jsp' type='crypto'/>&flowid=' + flowid;
		url += '&s_time=' + new Date().getTime();
	openModal(url, 800, 600);
}
/** 删除 */
function deleteFlow() {
	if(getSelNums() == 0){
		alert("请选择需要操作的记录！");
		return;
	}
	if(confirm("是否删除所选择的记录？")){
		var pageForm = document.forms["page_form"];
		pageForm.actions.value='<sc:fmt type="crypto" value="deleteFlow"/>';
		pageForm.forward.value='/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="flowActor"/>&actions=<sc:fmt type="crypto" value="queryFlow"/>&forward=<sc:fmt value='/pcmc/flow/flowMain.jsp' type='crypto'/>';
		pageForm.submit();
	}
}
/** 授权 */
function grantFlow() {
	if(getSelNums() != 1){
		alert("请选择一行记录操作！");
		return;
	}
	var flowid = getSelFlowId();
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="flowActor"/>&actions=<sc:fmt type="crypto" value="queryFlowDetl"/>&forward=<sc:fmt value='/pcmc/flow/flowGrant.jsp' type='crypto'/>&flowid=' + flowid;
	    url += '&s_time=' + new Date().getTime();
	openModal(url, 960, 720);
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
function getSelFlowId() {
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