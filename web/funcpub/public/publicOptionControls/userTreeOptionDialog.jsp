<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<style type="text/css">
	#selectedTree li span.button.switch.level0 {visibility:hidden; width:1px;}
	#selectedTree li ul.level0 {padding:0; background:none;}
</style>
<div class="window-left-box">
	<ul id="userTree" class="ztree"></ul>
</div>
<div class="window-center-button">
	<button class="add" onclick="choseSelected();" type="button">选择--></button><br><br>
	<button class="delete" onclick="deleteSelected()" type="button"><--删除</button><br><br>
	<button class="delete" onclick="deleteAll()" type="button"><--全删</button><br><br>
	<button class="close" onclick="submit()" type="button">确定</button>
</div>

<div class="window-right-box" >
	<ul id="selectedTree" class="ztree"></ul>
</div>
<script>
var filter = "<c:out value='${param.filter}' />";
var multi = "<c:out value='${param.multi}' />";
if("true"==multi){multi = true;}else{multi = false;}
var callback = "<c:out value='${param.callback}' />";
var selected = "<c:out value='${param.selected}' />";
var selectedColumn = "<c:out value='${param.selectedColumn}' />";
var userTreeSetting = {
	view:{
		dblClickExpand: true,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: multi,// 是否多选
		showIcon : true// 是否显示图标
	},
	data:{simpleData: {enable:true}},
	callback:{
		beforeClick:function(treeId,treeNode){
			if(!treeNode.isParent && null != treeNode.id && treeNode.id != ""){
				return true;
			}else{
				return false;
			}
		},
		onDblClick:function(){
			choseSelected();
		}
	}
};

var selectedTreeSetting = {
	view:{
		dblClickExpand:function(treeId,treeNode){return treeNode.level > 0;},
		showLine:false,// 是否显示连接线
		selectedMulti:multi,// 是否多选
		showIcon:true// 是否显示图标
	},
	data:{simpleData: {enable:true}},
	callback:{
		onDblClick:function(){
			deleteSelected();
		}
	}
};
$(function(){
	var treeObj = null;
	var selectedObj = null;
	var url = "/xmlprocesserservlet?"
		+ "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
		+ "&oprID="+'<sc:fmt value='publicOptionControls' type='crypto'/>'
		+ "&actions="+'<sc:fmt value='getUserTreeOptionData' type='crypto'/>'
		+ "&selected="+selected
		+ "&selectedColumn="+selectedColumn
		+ unescape(filter);
	$.ajax({
	   type: "POST",
	   url: url,
	   dataType: "XML",
	   async:false,
	   success: function(data){
		   treeObj = $(data).find("DataPacket Response Data treeObj").text();
		   selectedObj = $(data).find("DataPacket Response Data selectedObj").text();
		   treeObj = $.parseJSON(treeObj);
		   selectedObj = $.parseJSON(selectedObj);
	   },
	   error:function(){
		   treeObj={id:"",name:"初始化人员选择数据失败",isParent:false};
	   }
	});
	//初始化树
	$.fn.zTree.init($("#userTree"),userTreeSetting,treeObj);
	$.fn.zTree.init($("#selectedTree"),selectedTreeSetting,selectedObj);
});
function choseSelected(){
	var userTreeObj = $.fn.zTree.getZTreeObj("userTree");
	var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedTree");
	var nodes = userTreeObj.getSelectedNodes();
	if($(nodes).length>0){
		userTreeObj.cancelSelectedNode();
		selectedTreeObj.cancelSelectedNode();
	}
	$(nodes).each(function(){
		var node = selectedTreeObj.getNodeByParam("id",this.id,null);
		if(node == null){
			if(multi){
				addSelectedNode(this);
			}else{
				deleteAll();
				addSelectedNode(this);
			}
		}else{
			selectedTreeObj.selectNode(node,true);
		}
	});
}
function deleteSelected(){
	var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedTree");
	var nodes = selectedTreeObj.getSelectedNodes();
	$(nodes).each(function(){
		selectedTreeObj.removeNode(this);
	});
}
function deleteAll(){
	var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedTree");
	var nodes = selectedTreeObj.transformToArray(selectedTreeObj.getNodes());
	$(nodes).each(function(){
		selectedTreeObj.removeNode(this);
	});
}
function addSelectedNode(node){
	var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedTree");
	if(node != null){
		var addNode = selectedTreeObj.addNodes(null,{id:node.id,name:node.name,rel:node.rel,isParent:false,info:node.info});
		if(addNode.length>0){
			selectedTreeObj.selectNode(addNode[0],true);
		}
	}
}
function submit(){
	var userID = "";
	var userCode = "";
	var userName = "";
	var resultArray = new Array();
	var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedTree");
	var nodes = selectedTreeObj.transformToArray(selectedTreeObj.getNodes());
	$(nodes).each(function(){
		var user = $.parseJSON(this.info);
		userID += user.userID+",";
		userCode += user.userCode+",";
		userName += user.userName+",";
		resultArray.push(user);
	});
	userID = userID.substring(0,userID.length-1);
	userCode = userCode.substring(0,userCode.length-1);
	userName = userName.substring(0,userName.length-1);
	var resultObj = {userID:userID,userCode:userCode,userName:userName};
	eval(callback+"(resultArray,resultObj)");
}
</script>
