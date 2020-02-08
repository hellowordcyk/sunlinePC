<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<style>
      .pageContent{
		      padding-left: 30px;
              padding-top: 10px;
	  }
	  #pg{
		   display:none;
	  }
</style>
<div class="pageHeader">
	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
		<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='governor'/>"/>
    	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='initData'/>"/>
    	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='getStepFile'/>"/>
    	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/governor/initdata/initdata.jsp' />"/>
		<input type="hidden" name="expendFile" id="expendFile" />
    	<div class="searchBar">
    		<table class="searchContent">
    			<tr>
    				<td class="form-label">文件路径:</td>
    				<td class="form-value" style="width: 80%;"><sc:text name="filePath" id="filePath" value="${jrafrpu.rspPkg.reqDataMap}"   /></td>
    			</tr>
    		</table>
    	</div>
	</form>
</div>
<div class="pageContent">
	<div class="panelBar">
        <ul class="toolBar">
            <li>
            	<a class="run"
	            	href="javascript:void(0)" id="executeDataFile">
	            	<span>执行初始化</span>
            	</a>
            </li>
             <li>
            	<a class="run" 
	            	href="javascript:void(0)"  id="initDataByStep">
	            	<span>按步骤执行全部初始化</span>
            	</a>
            </li>
             <li>
            	<a class="run" 
	            	href="javascript:void(0)"  id="reloadConfig">
	            	<span>刷新内存</span>
            	</a>
            </li>
         </ul>
    </div>
	<div class="pageContent" >
	   <progress max="100" value="0" id="pg"></progress>
	   <div class="initFile">
    
	   </div>
	</div>
<div class="page-tip" style="margin-top:22px;margin-right:10px">
	<span class="tip-title">温馨提示</span>
	<p>1.数据初始化功能，用于数据库建表和初始化平台基础数据，schema维护表结构，data维护表数据；</p>
    <p  style="color:red">2.执行时默认将删除数据库数据和表结构，数据可通过xx_data.xlsx[是否保留原始数据]列来控制，y:保留原始数据，n：不保留原始数据</p>
    <p>3.Setp0：jraf基础平台初始化数据，必选；
                 setp1：jraf平台下etl产品、报表产品、工作流产品，根据需要选择执行；
                setp2：基于jraf框架的业务外围系统初始化数据；
    <p>4.执行初始化：根据项目需要，自由勾选产品的schema和data，setp0为必选项；</p>
    <p>5.按步骤全部初始化：无需勾选，会自动按照顺序从setp0全部初始化；<p>
       <p>6.刷新内存：当初始化所有文件后，点击刷新内存按钮，即重启服务；</p>
</div>
</div>
<script>
$(function(){
	//进度条
	var pg=document.getElementById('pg');
    setInterval(function(e){
      if(pg.value!=100) pg.value++;
      else pg.value=0;
    },100);
	var deptUserSetting = {
	view: {
		dblClickExpand: true,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: false,// 是否多选
		showIcon : true// 是否显示图标
	},
	check: {
            enable: true
        },
      data : {
			simpleData : {
				enable : true,
				idKey : "id",
				pIdKey : "pId",
				rootPId : ""
			}
		}
	};
	 var ztreeContainer=$(".initFile", navTab.getCurrentPanel());
	var respUrl = "/governor?flag=initData&actorName=getStepFile";
		$.ajax({
			type : 'POST',
			url : respUrl,
			dataType : "json",
			async : false,
			success : function(data) {
				var filePath=data.filePath;
				$("#filePath").val(filePath);
				$("#filePath").attr("disabled",true);
				$("#filePath").css("border","none");
				var dataList=data.fileStepTree;
				   ztreeContainer.children("div>ul").remove();
				  for(var item in dataList){
					var jValue=dataList[item];//key所对应的value
					 var zTreeId="ztreeStep"+item;
					 var stepZtree=" <div><ul id='"+zTreeId+"' class='ztree'></ul></div>";
                     ztreeContainer.append(stepZtree);
					 var treeObj=$.fn.zTree.init($('#'+zTreeId+''), deptUserSetting,jValue);
					 if(0==item){//默认展开树 step0
						 treeObj.expandAll(true); 
						 treeObj.checkAllNodes(true);
					 }
					}
			},
			error : function(json){
				DWZ.ajaxError(json);
			}
		});
	//执行全部文件（有序）	
	$("#initDataByStep").click(function(){
		alertMsg.confirm("执行前请仔细阅读上述温馨提示，是否继续？", {
              okCall: function(){
            		$("body").jrafAjaxSend();
            	    	initDataByStep();
                      }
                   });
	});
	//执行单个文件 
	$("#executeDataFile").click(function(){
		alertMsg.confirm("执行前请仔细阅读上述温馨提示，是否继续？", {
            okCall: function(){
            	$("body").jrafAjaxSend();
            	      executeDataFile();
                    }
                 });
	});
	//刷新内存
	$("#reloadConfig").click(function(){
		reloadConfig();
	});
});


//执行单个文件
function executeDataFile(){
	 //获取选中节点的值 
	 	var filePath="";
	    $(".initFile>div>ul").each(function(){
			var zThreeId=$(this).attr("id");
			var zTree=$.fn.zTree.getZTreeObj(zThreeId);
			var nodes=zTree.getCheckedNodes(true);
			var index=0;
		   for(var i=0;i<nodes.length;i++){
			  var isParent=nodes[i].isParent;
			  if(!isParent && isParent!=null && isParent!=undefined){
				  filePath+=nodes[i].path+",";
			  }
            }
		});
		if(filePath==""){
			alertMsg.error("没有选择任何文件");
			return;
		}
		 $("#pg").css("display","block");
		 $("#executeDataFile").attr("disabled",true);
		setTimeout(function(){
			filePath = filePath.substring(0, filePath.length - 1);
		    var respUrl = "/governor?flag=initData&actorName=exeDataInit";
			$.ajax({
				type : 'POST',
				url : respUrl,
				data:{"filePath":filePath},
				dataType : "json",
				async : false,
				success : function(data) {
					$("#pg").css("display","none");
					$("#executeDataFile").attr("disabled",false);
					console.log(data);
					var statusCode=data.statusCode;
					var message=data.message;
					$("body").jrafAjaxComplete();
					if(statusCode!='200'){
						alertMsg.error(message);
					}else{
						alertMsg.correct(message);
					}
				},
				error : function(json){
					DWZ.ajaxError(json);
				}
			});
		}, 1000);
}


function initDataByStep(){
	 $("#pg").css("display","block");
	    //设置全部选中
	    $(".initFile>div>ul").each(function(){
			var zThreeId=$(this).attr("id");
			var zTree=$.fn.zTree.getZTreeObj(zThreeId);
			zTree.checkAllNodes(true);
		});
	    $("#pg").css("display","block");
		 $("#executeDataFile").attr("disabled",true);
		 setTimeout(function(){
			 var respUrl = "/governor?flag=initData&actorName=exeAllDataInitByStep";
				$.ajax({
					type : 'POST',
					url : respUrl,
					dataType : "json",
					async : false,
					success : function(data) {
						$("#pg").css("display","none");
						 $("#executeDataFile").attr("disabled",false);
						console.log(data);
						var statusCode=data.statusCode;
						var message=data.message;
						$("body").jrafAjaxComplete();
						if(statusCode!='200'){
							alertMsg.error(message);
						}else{
							alertMsg.correct(message);
						}
					},
					error : function(json){
						DWZ.ajaxError(json);
					}
				});
		 },1000);
}

function reloadConfig(){
	 var respUrl = "/reloadConfig";
		$.ajax({
			type : 'POST',
			url : respUrl,
			dataType : "json",
			async : false,
			success : function(data) {
				console.log(data);
				var statusCode=data.msgCode;
				var message=data.message;
				if(statusCode!='1'){
					alertMsg.error("加载失败");
				}else{
					alertMsg.correct("加载成功");
				}
			},
			error : function(json){
				DWZ.ajaxError(json);
			}
		});
}
/*function gotoParentFile(event){
	var parentFile = $(event).siblings("[name='parentFile']").val();
	var flag=$("#pagerForm", navTab.getCurrentPanel()).find("input[name='flag']").val();
	if(flag=="top"){
		$(".goto_pre").css("color","grey");
		return;
	}
    $("#pagerForm", navTab.getCurrentPanel()).find("input[name='flag']").val("..");
	gotoFileDirectory(parentFile);
}
function changeDirectory(event){
	var filePath = $(event).siblings("[name='filePath']").val();
	gotoFileDirectory(filePath);
}
function gotoFileDirectory(filePath){
	$("#pagerForm", navTab.getCurrentPanel()).find("#expendFile").val("true");
	$("#pagerForm", navTab.getCurrentPanel()).find("#filePath").val(filePath);
	$("#pagerForm", navTab.getCurrentPanel()).submit();
}
function goto_step(stepCount){
	var index=parseInt($("input[name='step']").val())+stepCount;
	var finalStepIndex=parseInt($("input[name='finalStepIndex']").val());
	debugger;
	if(index<0){
		$(".goto_pre").css("color","grey");
		return false;
	}else if(index>finalStepIndex){
		$(".goto_next").css("color","grey");
		return false;
	}
	$("input[name='step']").val(index);
	$("#pagerForm", navTab.getCurrentPanel()).submit();
  
}*/

</script>