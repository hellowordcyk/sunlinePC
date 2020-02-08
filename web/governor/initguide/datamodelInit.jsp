 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">   
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/governor/common/common.jsp" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@ page import="com.sunline.governor.bean.TaskBean" %>
<%@ page import="java.util.*" %>
 <%
    ArrayList<TaskBean>   taskList = (ArrayList<TaskBean>)request.getAttribute("taskBeanList");
 %>
<div style="padding: 0 5px 0 5px;">
<div class="page-title">
<span class="title">监管数据模型初始化</span>
<table id ='table' align="center" class="list-table" border="0" width="100%" height="10%" cellspacing=0 cellpadding=0>
	<thead>
	<tr>
		<th style="width: 3%"><center><input type='checkbox' name='allbox' onclick='checkAll(this)'></center></th>
		<th style="width: 5%">任务编号</th>
		<th style="width: 15%">任务类别</th>
		<th style="width: 32%">任务名称（点击任务名称预览脚本文件）</th>
		<th style="width: 20%">任务中文描述</th>
		<th style="width: 15%">任务执行结果</th>
		<th style="width: 10%">操作</th>
	</tr>
	</thead>
	<tbody>
		<c:forEach items='<%=taskList%>' var='item' varStatus="status">
			<tr class="<c:if test='${status.index%2 == 0}'>odd</c:if><c:if test='${status.index%2 != 0}'>even</c:if>">
				<td style="width: 3%; text-align: center;"><input type="checkbox" name="taskid" value='${item.taskNo}'/></td>
				<td id="task_no_${item.taskNo}" style="width: 5%;">${item.taskNo}</td>
				<td style="width: 15%">${item.taskType}</td>
				<td style="width: 32%" title="点击预览脚本文件"><a href="#;return false;" onclick="opensqlfile('${item.filePath}')">${item.taskName}</a></td>
				<td style="width: 20%">${item.taskDesc}</td>
				<td id="res_${item.taskNo}" style="width: 15%">${item.taskResult}</td>
				<td style="width: 10%">
					<input type="hidden" id="da_ckxq_${item.taskNo}" value="" />
					<input type="hidden" id="object_name_${item.taskNo}" value="${item.objectname }" />
					<input type="button" class="button-link" id="ckxq_${item.taskNo}" value="查看详情" onclick="toDetails('da_ckxq_${item.taskNo}')" disabled=“disabled" />
				</td>
			</tr>
		</c:forEach>
	</tbody>
	<tfoot>
		<tr>
			<td colspan='7' align='center' style="padding: 5px 0;">
				<input type="button" class="button" name="up"    value="上一步" onclick="toFirst()"/>
				<input type="button" class="button" name="exec"  value="执行" onclick="execute()"/>
				<input type="button" class="button" name="next"  value="下一步" onclick="toThreeth()"/>
			</td>
		</tr>
	</tfoot>
</table>
</div>
</div>
<script type="text/javascript" defer="defer">

/********************** 全局变量 **********************/
var g_param = "";
var g_parameter = "";
var g_eachid = 0;
var ajax = new Jraf.Ajax();

new Jraf.Outlinetor(".list-table tbody tr");

datamodelInit();
function datamodelInit() {
	var isfirst = document.getElementById("isfirst").value;
	if (isfirst == "1"){
		var ck = $$("input[name='allbox']");
		checkAll(ck);
	}
}

//跳转到第一步
function toFirst(){
    //不存在时加载
        tabs.refresh(1,true);//兼容修改页面
    	dspTab(1);//切换title样式
}

//下一步
function toThreeth(){
	var reqparams = {
		url:    '/governor',
		flag:    'toplatformInit',
		subname:  'pcmc'
	};
	tabs.changeAction(3, reqparams);
	tabs.refresh(3, false);
	dspTab(3);//切换title样式
}
var m = {    
	createXHR:function(){
		if(window.XMLHttpRequest){
			var xhr = new XMLHttpRequest();
			return xhr;
		}else if(window.ActiveXObject){
			var xhr = new ActiveXObject("Microsoft.XMLHTTP");
			return xhr;
		}
	},
	sendRequest:function(method,url,data,callback){
		var xhr = this.createXHR();
		xhr.open(method,url);
		if(method=="GET"){
			xhr.send(null);
		}else if(method=="POST"){
			xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			xhr.send(data);
		}
		xhr.onreadystatechange=function(){
			if(xhr.readyState==4&&xhr.status==200){
				var p = {
					text:xhr.responseText,
					xml:xhr.responseXML
				};
				callback(p);
			}
		};
	}
};

//任务执行结果
function fun(c){
	var isContinue = true;
	var responeText = c.responseText;
	if (g_param!="" && g_param!=null){
		var reText = responeText.trim();
		var para = g_param.trim();
		var objectname = document.getElementById("object_name_"+para).value;
		if (reText=="0"){
			reText = "文件不存在";
			colorRed(para);
			var notexist = notExist(para);
			if (!notexist){
				document.getElementById("res_"+para).innerText = reText;
				document.getElementById("da_ckxq_"+para).value = objectname+"  "+reText;
				document.getElementById("ckxq_"+para).disabled = false;
				stopExe();
				return false;
			}
		}else if (reText=="1"){
			reText = "编译成功";
			colorGreen(para);
		}else if (reText=="2"){
			reText = "建表成功";
			colorGreen(para);
		}
		if (reText.indexOf("-1")!=-1){
			document.getElementById("res_"+para).innerText = "编译失败";
			reText = reText.replace('-1', '编译失败');
			colorRed(para);
			isContinue = executeException(para);
			if (!isContinue){
				document.getElementById("res_"+para).innerText = reText;
				document.getElementById("da_ckxq_"+para).value = objectname+"  "+reText;
				document.getElementById("ckxq_"+para).disabled = false;
				stopExe();
				return false;
			}
		}else if (reText.indexOf("-2")!=-1){
			document.getElementById("res_"+para).innerText = "建表失败";
			reText = reText.replace('-2', '建表失败');
			colorRed(para);
			isContinue = executeException(para);
			if (!isContinue){
				document.getElementById("res_"+para).innerText = reText;
				document.getElementById("da_ckxq_"+para).value = objectname+"  "+reText;
				document.getElementById("ckxq_"+para).disabled = false;
				stopExe();
				return false;
			}
		}else{				
			document.getElementById("res_"+para).innerText = reText;
		}
		document.getElementById("da_ckxq_"+para).value = objectname+"  "+reText;
		document.getElementById("ckxq_"+para).disabled = false;
		g_param = g_parameter[g_eachid];
		eachexecute(ajax, g_parameter[g_eachid]);
		g_eachid++;
		if (g_eachid==g_parameter.length){
			btnDisabledFalse();
		}
		if (g_eachid>g_parameter.length){
			return false;
		}
	}
}

//终止执行
function stopExe(){
	btnDisabledFalse();
	for (var i = g_eachid; i<=g_parameter.length; i++){					
		document.getElementById("res_"+g_parameter[i]).innerText = "未执行";
		document.getElementById("ckxq_"+g_parameter[i]).disabled = true;
		colorYellow(g_parameter[i]);
		g_eachid++;
	}
}

//执行脚本文件出现异常
function executeException(para){
	if(confirm("第"+para+"条脚本执行失败，是否继续执行？")){
	 	return true;
	}
	return false;
}

//脚本文件不存在
function notExist(para){
	if(confirm("第"+para+"条脚本文件不存在，是否继续执行？")){
	 	return true;
	}
	return false;
}

//执行
function execute(){
	g_param = "";
	g_parameter = "";
	g_eachid = 0;
	
	btnDisabledTrue();
	gparameter();
	//restore();
	
	
	for (var i = 0; i < g_parameter.length; i++){
		document.getElementById("ckxq_"+g_parameter[i]).disabled = true;
		$("res_"+g_parameter[i]).update("<span class='loading' style='font-size: 11px;color:black;'>等待执行</span>");
	}
	
	if (g_parameter.length>0){		
		g_param = g_parameter[g_eachid];
		eachexecute(ajax, g_parameter[g_eachid]);
		g_eachid++;
	}
}

//用全局变量保存选中的脚本
function gparameter(){
	var obj = $$("input[name='taskid']");
	var task_no = "";
	var count = 0;
	for(var i=0;i<obj.length;i++){
		if(obj[i].checked == true){
			count++;
			task_no+=obj[i].value+",";
		}
	}
	if(count<1){
		ischecked();
		btnDisabledFalse();
	}else{
		task_no=task_no.substring(0,task_no.length-1);
		g_parameter = task_no.split(",");
	}
}

function ischecked(){
	Jraf.showMessageBox({text: "<span class='info'>" + "请选择一条数据" + "</span>"});
	return false;
}

function eachexecute(ajax, objv){
	var flag = 'datamodelInit';
	var subname = "governor";
	data = "objv="+objv+"&flag="+flag+"&subname="+subname;
	$("res_"+objv).update("<span class='loading' style='font-size: 11px;color: black;'>正在执行...</span>");
	ajax.request("/governor",data,fun);
}

//界面按钮不可用状态
function btnDisabledTrue(){
	document.getElementsByName("exec")[0].disabled=true;
	document.getElementsByName("up")[0].disabled=true;
	document.getElementsByName("next")[0].disabled=true;
}

//界面按钮可用状态
function btnDisabledFalse(){
	document.getElementsByName("exec")[0].disabled=false;
	document.getElementsByName("up")[0].disabled=false;
	document.getElementsByName("next")[0].disabled=false;
}

//复选框全选功能
function checkAll(ck){
var inputs = document.getElementsByName("taskid");
  for (var i=0;i<inputs.length;i++){
    var ele = inputs[i];
    if ((ele.type=="checkbox")){
      if(ck.checked!=ele.checked)
        ele.click();
    }
  }
}

/**
 * 弹出详情页面
 */
function toDetails(xqid) {
	var detailsInfo = encodeURI(encodeURI(document.getElementById(xqid).value));
	var url = "/governor/initguide/lookdetails.jsp";
	openModalByParams(url,detailsInfo,600,400,false);
}

function funres(c){
	Jraf.ProgressEnd();
	var responeText = c.responseText;
	if (responeText=="-1"){
		alert("文件不存在");
	}
}

/**
 * 预览脚本文件
 */
function opensqlfile(sqlpath) {
	if (sqlpath=="" || sqlpath==null){
		alert("文件不存在");
		return false;
	}
	var flag = 'openfile';
	var subname = 'governor';
	var fpath = encodeURI(encodeURI(sqlpath));
	data = "flag="+flag+"&subname="+subname+"&sqlpath="+fpath;
	Jraf.ProgressStart("加载中，请稍后……");
	ajax.request("/governor",data,funres);
}

function colorRed(para){
	var obj = $("task_no_"+para);
	obj.style.backgroundColor = "red";
	
	$("res_"+para).style.color = "red";
}

function colorGreen(para){
	var obj = $("task_no_"+para);
	obj.style.backgroundColor = "green";
	
	$("res_"+para).style.color = "green";
}

function colorYellow(para){
	var obj = $("task_no_"+para);
	obj.style.backgroundColor = "yellow";
	
	$("res_"+para).style.color = "black";
}

function restore(){
	var tableObject = document.getElementById('table');
	for(var i=0;i<tableObject.rows.length-2;i++){
		if (i%2 == 0){
			var obj = tableObject.rows[i+1].cells[1];
			obj.style.backgroundColor = "rgb(255, 255, 255)";
		}else{
			var obj = tableObject.rows[i+1].cells[1];
			obj.style.backgroundColor = "rgb(241, 244, 248)";
		}
	}
}
</script>