<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style type="text/css">
	#selectedTree li span.button.switch.level0 {visibility:hidden; width:1px;}
	#selectedTree li ul.level0 {padding:0; background:none;}
</style>
<div class="searchBar">
	<form onsubmit="return false;">
	   <table class="searchContent" cellpadding="0" cellspacing="0" >
		   <tr>
			   <td class="form-label">机构编码/名称</td>
			   <td><input type="text" class="textInput" id="deptcdOrNa"  name="deptcdOrNa" onkeyup = "enterSearch()"/></td>
			   <td class="form-btn">
		           <ul>
			           <li>
			           	<input type="submit" class="querybtn" id = "enterSearchBtn" style="display: inline-block;" value="查询" onclick="searchDept()"/>
			           </li>
			           <li>
			           	<button class="resetbtn" type="reset">清空</button>
			           </li>
		            </ul>
			   </td>
		   </tr>
	   </table>
   </form>
</div>
<div>
	<div class="window-left-box">
		<ul id="deptTree" class="ztree"></ul>
	</div>
	<div class="window-center-button">
		<button class="add" onclick="choseSelected();" type="button">选择--&gt;</button><br><br>
		<button class="delete" onclick="deleteSelected()" type="button">&lt;--删除</button><br><br>
		<button class="delete" onclick="deleteAll()" type="button">&lt;--全删</button><br><br>
		<button class="close" onclick="submit()" type="button">确定</button>
	</div>
	
	<div class="window-right-box" >
		<ul id="selectedTree" class="ztree"></ul>
	</div>
</div>
<script type="text/javascript">
function enterSearch(){
	if (event.keyCode == "13") {
            //回车执行查询
            $('#enterSearchBtn').trigger('click');
        }
}
var filter = "<c:out value='${param.filter}' escapeXml='false'/>";
var multi = "<c:out value='${param.multi}' />";
if("true"==multi){multi = true;}else{multi = false;}
var callback = "<c:out value='${param.callback}' />";
var selected = "<c:out value='${param.selected}' />";
var selectedColumn = "<c:out value='${param.selectedColumn}' />";
// 待机构树对象
var deptTreeObj;
// 已选择机构树对象
var selectedTreeObj;
var deptTreeSetting = {
	view:{
		dblClickExpand: false,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: multi,// 是否多选
		showIcon : true// 是否显示图标
	},
	data:{simpleData: {enable:true}},
	callback:{
		beforeClick:function(treeId,treeNode){
			if(treeNode.isParent && null != treeNode.id && treeNode.id != ""){
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
	initDeptTree();
});

function initDeptTree(){
	var treeObj = null;
	var selectedObj = null;
	var url = "/xmlprocesserservlet?"
		+ "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
		+ "&oprID="+'<sc:fmt value='publicOptionControls' type='crypto'/>'
		+ "&actions="+'<sc:fmt value='getDeptTreeOptionData' type='crypto'/>'
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
		   treeObj={id:"",name:"初始化机构选择数据失败",isParent:false};
	   }
	});
	//初始化树
	deptTreeObj = $.fn.zTree.init($("#deptTree"),deptTreeSetting,treeObj);
	selectedTreeObj = $.fn.zTree.init($("#selectedTree"),selectedTreeSetting,selectedObj);
}

function choseSelected(){
	var deptTreeObj = $.fn.zTree.getZTreeObj("deptTree");
	var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedTree");
	var nodes = deptTreeObj.getSelectedNodes();
	if($(nodes).length>0){
		deptTreeObj.cancelSelectedNode();
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
		var addNode = selectedTreeObj.addNodes(null,{id:node.id,name:node.name,rel:node.rel,isParent:true,info:node.info});
		if(addNode.length>0){
			selectedTreeObj.selectNode(addNode[0],true);
		}
	}
}
function submit(){
	var deptID = "";
	var deptCode = "";
	var deptName = "";
	var resultArray = new Array();
	var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedTree");
	var nodes = selectedTreeObj.transformToArray(selectedTreeObj.getNodes());
	$(nodes).each(function(){
		var dept = $.parseJSON(this.info);
		deptID += dept.deptID+",";
		deptCode += dept.deptCode+",";
		deptName += dept.deptName+",";
		resultArray.push(dept);
	});
	deptID = deptID.substring(0,deptID.length-1);
	deptCode = deptCode.substring(0,deptCode.length-1);
	deptName = deptName.substring(0,deptName.length-1);
	var resultObj = {deptID:deptID,deptCode:deptCode,deptName:deptName};
	eval(callback+"(resultArray,resultObj)");
}

function searchDept(){
	var deptcdOrNa = $('#deptcdOrNa').val();
	// 根据节点名称模糊查询机构树
	var nodes = deptTreeObj.getNodesByParamFuzzy("name", deptcdOrNa);
	if (nodes != "" && nodes != null) {
		// 循环节点，并展开
		for( var i=0, l=nodes.length; i<l; i++) {
			deptTreeObj.expandNode(nodes[i],true);
		}
	} else {
		alertMsg.info("未找到机构："+deptcdOrNa);
	}
}

</script>
