<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<style type="text/css">
	#selectedTree li span.button.switch.level0 {visibility:hidden; width:1px;}
	#selectedTree li ul.level0 {padding:0; background:none;}
</style>
<div class="pageHeader">
    <form>
		<div class="searchBar">
		   <table class="searchContent" cellpadding="0" cellspacing="0" >
		         <tr>
				<td class="form-label">机构编码/名称</td>
				<td><input type="text" class="textInput" id="deptcdOrNa" name="deptcdOrNa"/><span class="info">按住CTRL键可以多选</span></td>
				<td class="form-btn">
		               <ul>
		                   <li>
		                       <input type="button" class="querybtn" style="display: inline-block;" value="查询" onclick="searchDept()"/>
		                   </li>
		                   <li>
		                       <button class="resetbtn" type="reset">清空</button>
		                   </li>
		               </ul>
		           </td>
		       </tr>
		   </table>
		</div>
</form>
</div>
<div>
	<div class="window-left-box" style="width:42%;">
		<ul id="deptTree" class="ztree"></ul>
	</div>
	<div class="window-center-button">
		<button class="add" onclick="choseSelected();" type="button">选择--&gt;</button><br><br>
		<button class="delete" onclick="deleteSelected()" type="button">&lt;--删除</button><br><br>
		<button class="delete" onclick="deleteAll()" type="button">&lt;--全删</button><br><br>
		<button class="close" onclick="submit()" type="button">确定</button>
	</div>
	
	<div class="window-right-box" style="width:42%;">
		<ul id="selectedTree" class="ztree"></ul>
	</div>
</div>
<script type="text/javascript">

var lookupid = "<c:out value='${param.lookupid}' />";
var lookupcode = "<c:out value='${param.lookupcode}' />";
var lookupname = "<c:out value='${param.lookupname}' />";
var selectedCode = '${param.elmId}';
var selectedArr = new Array();
var getColumn = "";
if(lookupid==null || lookupid.length<1){
    lookupid = "lookupid";
}else{
    getColumn = "id";
}
if(lookupcode==null || lookupcode.length<1){
    lookupcode = "lookupcode";
}else{
    if(getColumn.length<1) {
        getColumn = "info";
    }
}

if(lookupname==null || lookupname.length<1){
    lookupname = "lookupname";
}

var multi = true;
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
	if(selectedCode && selectedCode.length>0) {          //初始化 已选中的值
        var defs =selectedCode.split(",");
        for(var i = 0; i < defs.length;i++) {
            selectedArr.push(defs[i]);
        }
    }
	initDeptTree();
});

function initDeptTree(){
	var treeObj = null;
	var selectedObj = null;
	var url = "/xmlprocesserservlet?"
		+ "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
		+ "&oprID="+'<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>'
		+ "&actions="+'<sc:fmt value='getDeptTree' type='crypto'/>';
	$.ajax({
	   type: "POST",
	   url: url,
	   dataType: "XML",
	   async:false,
	   success: function(data){
		   treeObj = $(data).find("DataPacket Response Data treeObj").text();
		   treeObj = $.parseJSON(treeObj);
		   if(selectedArr!=null && selectedArr.length>0) {
		        if(treeObj!=null && treeObj.length>0) {
		        	selectedObj = new Array();
		            for(var i = 0; i < treeObj.length;i++) {
		            	var t = treeObj[i];
		            	for(var j = 0; j <selectedArr.length;j++) {
		            		var s = selectedArr[j];
		            		if(s==t[getColumn]) {
		            			var newItem = new Object();
		            			var selectedItem = $.extend(newItem,t);
		            			selectedObj.push(selectedItem);
		            		}
		            	}
		            }
		        }
		    }
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
		//var dept = $.parseJSON(this.info);
		var dept = this.info.split("-");
		deptID += dept[0]+",";
		deptCode += dept[1]+",";
		deptName += dept[2]+",";
		resultArray.push(dept);
	});
	//$.bringBack({'${param.lookupcode}':'${u.deptcode }','${param.lookupid}':'${u.deptid }', '${param.lookupname}':'${u.deptname }' });
	deptID = deptID.substring(0,deptID.length-1);
	deptCode = deptCode.substring(0,deptCode.length-1);
	deptName = deptName.substring(0,deptName.length-1);
	var resultObj = $.parseJSON("{\""+lookupid+"\":\""+deptID+"\",\""+lookupcode+"\":\""+deptCode+"\",\""+lookupname+"\":\""+deptName+"\"}");
	$.bringBack(resultObj);
	//eval(callback+"(resultArray,resultObj)");
}

function searchDept(){
	var deptcdOrNa = $('#deptcdOrNa').val();
	// 根据节点名称模糊查询机构树
	deptTreeObj.cancelSelectedNode();
	var nodes = deptTreeObj.getNodesByParamFuzzy("name", deptcdOrNa);
	if (nodes != "" && nodes != null) {
		// 循环节点，并展开
		for( var i=0, l=nodes.length; i<l; i++) {
			deptTreeObj.expandNode(nodes[i],true);
			deptTreeObj.selectNode(nodes[i],true);
		}
	} else {
		alertMsg.info("未找到机构："+deptcdOrNa);
	}
}

</script>
