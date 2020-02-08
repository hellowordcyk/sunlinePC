<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">   
<%@ include file="/governor/common/common.jsp" %>
<%@ page import="java.util.*" %>
<%@page import="com.sunline.governor.bean.*" %>
<% 
/* String title = request.getParameter("title"); 
//String subname = request.getParameter("subname");  */
ArrayList<TaskBean>  sysTaskBeanlist = (ArrayList<TaskBean>)request.getAttribute("sysTaskBeanlist");
int listSize = 0;
if (sysTaskBeanlist!=null && sysTaskBeanlist.size()>0){
    listSize = sysTaskBeanlist.size();
}
%>
<div class="page-title">
<span class="title"><c:out value='${param.title }' /></span>
<table id ="<c:out value='${param.subname }' />table" class="list-table" border="0" width="100%" cellspacing=0 cellpadding=0>
<thead>
    <tr>
        <th style="width: 3%"><center><input type='checkbox' name='allbox' onclick='checkAll(this)'></center></th>
        <th style="width: 5%">任务编号</th>
        <th style="width: 15%">任务类别</th>
        <th style="width: 32%">任务名称（<b>点击名称预览</b>）</th>
        <th style="width: 20%">任务中文描述</th>
        <th style="width: 15%">任务执行结果</th>
        <th style="width: 10%">操作</th>
    </tr>
</thead>
<tbody>
	    <c:forEach items='<%=sysTaskBeanlist%>' var='item' varStatus="status">
	      <tr class="<c:if test='${status.index%2 == 0}'>odd</c:if><c:if test='${status.index%2 != 0}'>even</c:if>">
                <td style="width: 3%; text-align: center;"><input type="checkbox" name="<c:out value='${param.subname' />_taskid" value='${item.taskNo}'/></td>
                <td id="task_no_<c:out value='${param.subname' />_${item.taskNo}" style="width: 5%">${item.taskNo}</td>
	            <td style="width: 15%">${item.taskType}</td>
	            <td style="width: 32%" title="点击预览脚本文件"><a href="#;return false;" onclick="opensqlfile('${item.filePath}')">${item.taskName}</a></td>
	            <td style="width: 20%">${item.taskDesc }</td>
	            <td id="res_<c:out value='${param.subname' />_${item.taskNo}" style="width: 15%">${item.taskResult}</td>
	            <td style="width: 10%">
	                <input type="hidden" id="co_<c:out value='${param.subname' />_${item.taskNo}" value="" />
	                <input type="hidden" id="object_<c:out value='${param.subname' />_${item.taskNo}" value="${item.objectname }" />
	                <input type="button" class="button-link" id="ckxq_<c:out value='${param.subname' />_${item.taskNo}" value="查看详情" onclick="toDetails('co_<c:out value='${param.subname' />_${item.taskNo}')" disabled=“disabled" />
	            </td>
	      </tr>
	  </c:forEach>
</tbody>
<tfoot>
	<tr>
	     <td colspan='7' align='center' style="padding: 5px 0;">
	      <input type="button" class="button" name='<c:out value='${param.subname' />up'   value="上一步" onclick="tothird()"/>
	      <input type="button" class="button" name='<c:out value='${param.subname' />exec' value="执行" onclick="toexecute()"/>
	      <input type="button" class="button" name='<c:out value='${param.subname' />next'  value="完成" onclick="finish()"/>
	     </td>
	 </tr>
</tfoot>
</table>
</div>
<script type="text/javascript" defer="defer">
/*******************全局变量*********************/
var g_param = "";
var g_parameter = "";
var g_eachid = 0;
var ajax = new Jraf.Ajax();

new Jraf.Outlinetor(".list-table tbody tr");

initTask();
function initTask() {
    var tasksize = "<%=listSize%>";
    var isfirst = document.getElementById("isfirst").value;
    if (isfirst == "1"){
        var ck = $$("input[name='allbox']");
        checkAll(ck);
    }
    //if (tasksize == 0) {
        //document.getElementsByName('<%=subname%>exec')[0].disabled=true;
        //document.getElementsByName('<%=subname%>up')[0].disabled=true;
    //}
}

var comAjax = {    createXHR:function(){
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

//上一步
function tothird()
{
    tabs.refresh(3,true);
    dspTab(3);//切换title样式
}

//执行
function toexecute(){
	g_param = "";
	g_parameter = "";
	g_eachid = 0;
	
    btnDisabledTrue();
    gparameter();
    //restore();
    
    for (var i = 0; i < g_parameter.length; i++){
    	document.getElementById("ckxq_<c:out value='${param.subname' />_"+g_parameter[i]).disabled = true;
        $("res_<c:out value='${param.subname' />_"+g_parameter[i]).update("<span class='loading' style='font-size: 11px;color: black;'>等待执行</span>");
    }
    
    if (g_parameter.length>0){    	
	    g_param = g_parameter[g_eachid];
	    eachexecute(ajax, g_parameter[g_eachid]);
	    g_eachid++;
    }
}

//任务执行结果
function test(c){
    var isContinue = true;
    var responeText = c.responseText;
    if (g_param!="" || g_param!=null){
        var reText = responeText.trim();
        var para = g_param.trim();
        var objectname = document.getElementById("object_<c:out value='${param.subname }' />_"+para).value;
        if (reText=="0"){
            reText = "文件不存在";
            colorRed(para);
            var notexist = notExist(para);
            if (!notexist){
                document.getElementById("res_<c:out value='${param.subname }' />_"+para).innerText = reText;
                document.getElementById("co_<c:out value='${param.subname }' />_"+para).value = objectname+"  "+reText;
                document.getElementById("ckxq_<c:out value='${param.subname }' />_"+para).disabled = false;
                stopExe();
                return false;
            }
        }else if (reText=="1"){
            reText = "编译成功";
            colorGreen(para);
        }else if (reText=="2"){
            reText = "建表成功";
            colorGreen(para);
        }else if (reText=="3"){
            reText = "初始化表成功";
            colorGreen(para);
        }
        if (reText.indexOf("-1")!=-1){
            document.getElementById("res_<c:out value='${param.subname }' />_"+para).innerText = "编译失败";
            reText = reText.replace('-1', '编译失败');
            colorRed(para);
            isContinue = executeException(para);
            if (!isContinue){
                document.getElementById("res_<c:out value='${param.subname }' />_"+para).innerText = reText;
                document.getElementById("co_<c:out value='${param.subname }' />_"+para).value = objectname+"  "+reText;
                document.getElementById("ckxq_<c:out value='${param.subname }' />_"+para).disabled = false;
                stopExe();
                return false;
            }
        }else if (reText.indexOf("-2")!=-1){
            document.getElementById("res_<c:out value='${param.subname }' />_"+para).innerText = "建表失败";
            reText = reText.replace('-2', '建表失败');
            colorRed(para);
            isContinue = executeException(para);
            if (!isContinue){
                document.getElementById("res_<c:out value='${param.subname }' />_"+para).innerText = reText;
                document.getElementById("co_<c:out value='${param.subname }' />_"+para).value = objectname+"  "+reText;
                document.getElementById("ckxq_<c:out value='${param.subname }' />_"+para).disabled = false;
                stopExe();
                return false;
            }
        }else if (reText.indexOf("-3")!=-1){
            document.getElementById("res_<c:out value='${param.subname }' />_"+para).innerText = "初始化表失败";
            reText = reText.replace('-3', '初始化表失败');
            colorRed(para);
            isContinue = executeException(para);
            if (!isContinue){
                document.getElementById("res_<c:out value='${param.subname }' />_"+para).innerText = reText;
                document.getElementById("co_<c:out value='${param.subname }' />_"+para).value = objectname+"  "+reText;
                document.getElementById("ckxq_<c:out value='${param.subname }' />_"+para).disabled = false;
                stopExe();
                return false;
            }
        }else{                
            document.getElementById("res_<c:out value='${param.subname }' />_"+para).innerText = reText;
        }
        document.getElementById("co_<c:out value='${param.subname }' />_"+para).value = objectname+"  "+reText;
        document.getElementById("ckxq_<c:out value='${param.subname }' />_"+para).disabled = false;
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
        document.getElementById("res_<c:out value='${param.subname }' />_"+g_parameter[i]).innerText = "未执行";
        document.getElementById("ckxq_<c:out value='${param.subname }' />_"+g_parameter[i]).disabled = true;
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

//用全局变量保存选中的脚本
function gparameter(){
    var obj = $$("input[name='<c:out value='${param.subname }' />_taskid']");
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
    var flag = 'execsubsystask';
    var subname = "<c:out value='${param.subname }' />";
    data = "objv="+objv+"&flag="+flag+"&subname="+subname;
    $("res_<c:out value='${param.subname }' />_"+objv).update("<span class='loading' style='font-size: 11px;color:black;'>正在执行...</span>");
    ajax.request("/governor",data,test);
}

//界面按钮不可用状态
function btnDisabledTrue(){
    document.getElementsByName('<c:out value="${param.subname }" />exec')[0].disabled=true;
    document.getElementsByName('<c:out value="${param.subname }" />up')[0].disabled=true;
    document.getElementsByName('<c:out value="${param.subname }" />next')[0].disabled=true;
}

//界面按钮可用状态
function btnDisabledFalse(){
    document.getElementsByName('<c:out value="${param.subname }" />up')[0].disabled=false;
    document.getElementsByName('<c:out value="${param.subname }" />next')[0].disabled=false;
    document.getElementsByName('<c:out value="${param.subname }" />exec')[0].disabled=false;
}

//完成
function finish(){
     var isfirst = document.getElementById("isfirst").value;
     if (isfirst=="1") {
         if(confirm("退出系统点击确定"))
         {
          
            var flag = 'logout';
            comAjax.sendRequest("POST","/governor?flag="+flag,null,test);
            window.opener=null;
            self.location="index.jsp";
         }
     } else {
         if(confirm("是否登录银行综合监管平台")) {
                if (isfirst=="1"){
                    document.getElementById("tipsbody").onbeforeunload = window.close();    
                }else{            
                    window.close();
                }
                window.open('/index.jsp');
             }else{
                 if (isfirst=="1"){
                    document.getElementById("tipsbody").onbeforeunload = window.close();    
                 }else{         
                    window.close();
                 }
             }
     }
}

//复选框全选功能
function checkAll(ck){
var inputs = document.getElementsByName("<c:out value='${param.subname }' />_taskid");
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
    var subname = '<c:out value="${param.subname }" />';
    var fpath = encodeURI(encodeURI(sqlpath));
    data = "flag="+flag+"&subname="+subname+"&sqlpath="+fpath;
    Jraf.ProgressStart("加载中，请稍后……");
    ajax.request("/governor",data,funres);
}

function colorRed(para){
	var obj = $("task_no_<c:out value='${param.subname }' />_"+para);
	obj.style.backgroundColor = "red";
	
	$("res_<c:out value='${param.subname }' />_"+para).style.color = "red";
}

function colorGreen(para){
	var obj = $("task_no_<c:out value='${param.subname }' />_"+para);
	obj.style.backgroundColor = "green";
	
	$("res_<c:out value='${param.subname }' />_"+para).style.color = "green";
}

function colorYellow(para){
	var obj = $("task_no_<c:out value='${param.subname }' />_"+para);
	obj.style.backgroundColor = "yellow";
	
	$("res_<c:out value='${param.subname }' />_"+para).style.color = "black";
}

function restore(){
	var tableObject = document.getElementById("<c:out value='${param.subname }' />table");
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