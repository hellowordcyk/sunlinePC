<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>文档管理</title>
</head>
<body>
<div onclick="hideRightClickMenu()" class="managerPrdpara">
	<div class="prdinfoBox-left">
		<ul id="fileTree" class="ztree" style="width:300px; overflow:auto;"></ul>
	</div>
		
	<div id="fileBox" class="prdinfoBox"></div>
	
	<div id="rightClickMenu1" class="rightClickMenu">
		<li class="rightcontent" onclick="addFile()"><span class="rightcontent" >创建子目录</span></li>
		<li class="rightrefresh" onclick="refreshTreeNode()"><span class="rightrefresh" >刷新</span></li>
	</div>
	<div id="rightClickMenu2" class="rightClickMenu">
		<li class="rightcontent" onclick="addFile()"><span class="rightcontent" >创建子目录</span></li>
		<li class="rightdelete" onclick="deleteDirOrFile('false', 'true')"><span class="rightdelete">删除目录</span></li>
		<li class="rightupload" onclick="uploadFile('true')"><span class="rightupload" >上传文件</span></li>
		<li class="rightrefresh" onclick="refreshTreeNode()"><span class="rightrefresh" >刷新</span></li>
	</div>
	<%-- 待增加右键文件下载功能 --%>
	<div id="rightClickMenu3" class="rightClickMenu">
		<li class="rightdelete" onclick="deleteDirOrFile('true', 'true')"><span class="rightdelete" >删除文档</span></li>
	</div>
	
</div>
</body>
<script type="text/javascript">
var currentTreeNode = null; //记录右键操作的treeNode
var currentSelectedTreeNode = null; //记录当前选中的treeNode
var fileSetting = {
	view: {
		dblClickExpand: false,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: false,// 是否多选
		showIcon : true,// 是否显示图标
		fontCss: function (treeId, treeNode) {
			if ((""+treeNode.isEditable) === 'false') {
				return {"color":"grey"};
			}
			return {};
		}
	},
	edit: {
		showRemoveBtn: true,
		removeTitle: "删除文件或目录"
	},
	async: {
		enable: true,// 是否异步
		url: '/xmlprocesserservlet?sysName=<sc:fmt type="crypto" value="funcpub"/>&oprID=<sc:fmt type="crypto" value="funcpub-filemanager"/>&actions=<sc:fmt type="crypto" value="queryFileTree"/>',
		dataType: "xml",// 返回数据类型
		dataFilter : function (treeId, parentNode, responseData){// 数据拦截器，可以将返回的数据组装成你需要的样子
						var zNodes = $(responseData).find('DataPacket Response Data filetree').text();
						return $.parseJSON(zNodes);
					},
		autoParam: ["id","level", "code", "path"]// 异步时传到后台的参数
	},
	data: {
		simpleData: {
			enable:true,
			idKey: "id",
			pIdKey: "pId",
			rootPId: ""
		}
	},
	callback: {
		beforeAsync: function(treeId, treeNode){
			return true;
		},
		onAsyncSuccess:function(event, treeId, treeNode, msg){
			initUI($('#'+treeId));//兼容JUI
		},
		onAsyncError:function(event, treeId, treeNode, msg){return true;},
		beforeClick: function(treeId, treeNode){
				/* if ((""+treeNode.isEditable) === 'false') {
					return false;
				} */
			},
		onClick: function(event, treeId, treeNode, clickFlag){
			if (treeNode.isParent == true) {
				var url = "/funcpub/filemanager/search/fileSearch.jsp?subName="+treeNode.code+"&path="+encodeURI(treeNode.path||'')+"&priv="+(treeNode.isEditable==null?"":treeNode.isEditable);
				$('#fileBox').loadUrl(url);// 取代<a/>标签  兼容JUI
			} else {
				
			}
			currentSelectedTreeNode = treeNode;
		},
		beforeRightClick:function(treeId, treeNode){
			hideRightClickMenu();
			
			<%-- FIXME: 无权限可提供右键刷新功能和下载功能  --%>
			if ((""+treeNode.isEditable) === 'false') {
				alertMsg.error("无权限修改!");
				return false;
			}
			if(treeNode.level == 0){
				$("#rightClickMenu1").css("display","block");//显示右键菜单
			}else if(treeNode.isParent == false){
				$("#rightClickMenu3").css("display","block");//显示右键菜单
			}else{
				$("#rightClickMenu2").css("display","block");//显示右键菜单
			}
			return true;
		},
		onRightClick:function(event, treeId, treeNode){
			//设置右键菜单位置
			if( $("#sidebar").css("display") == "block"){
				$("div[id^=rightClickMenu]").css("margin-left",event.clientX-210+"px");
				$("div[id^=rightClickMenu]").css("margin-top",event.clientY-130+"px"); 
			}else{
				$("div[id^=rightClickMenu]").css("margin-left",event.clientX-15+"px");
				$("div[id^=rightClickMenu]").css("margin-top",event.clientY-130+"px"); 
			}
			currentTreeNode = treeNode;
		}
	}
};
$(function(){
	$.fn.zTree.init($('#fileTree'), fileSetting);
});
///////////////////////////////////////////////
//隐藏右键菜单
function hideRightClickMenu(){
	$("#rightClickMenu1").css("display","none");
	$("#rightClickMenu2").css("display","none");
	$("#rightClickMenu3").css("display","none");
}
function addFile(){
	if(currentTreeNode == null ){
		alertMsg.error("请选择文档目录!");
		return;
	}
	var url = "/funcpub/filemanager/addDir.jsp?id="+currentTreeNode.id+"&level="+currentTreeNode.level+"&subName="+currentTreeNode.code+"&path="+encodeURI(currentTreeNode.path)+"&name="+encodeURI(encodeURI(currentTreeNode.name));
	$.pdialog.open(url,"addDir","新增文档目录", {width:300,height:200,minable:false,maxable:false,mask:true,close:function(){
		var treeObj = $.fn.zTree.getZTreeObj("fileTree");
		treeObj.reAsyncChildNodes(currentTreeNode, "refresh");
		return true;
	}});
}
function deleteDirOrFile(isFile, isRightClick){
	var treeNode = null;
	var paths = "";
	if (isRightClick) {
		treeNode = currentTreeNode;
		paths = treeNode.path;
	} else {
		//树右侧，列表批量删除
		treeNode = currentSelectedTreeNode;
		
		var obj = $("input[name='check']", $('#dataId'));
		var count = 0;
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked == true) {
				count++;
				paths = paths + obj[i].value + "|";
			}
		}

		if (count < 1) {
			alertMsg.error("请至少选择一条数据!");
			return;
		}
	}
	
	if(treeNode == null ){
		if (isFile == "true") {
			alertMsg.error("请选择文件！");
		} else {
			alertMsg.error("请选择目录！");
		}
		return;
	}
	
	var hint = "您确定要删除当前目录及其所有目录或文件吗?";
	if (isFile == "true") {
		hint = "您确定要删除当前文件吗?";
	} 
	<%-- sysName=<sc:fmt value='funcpub' type='crypto'/>"
    + "&oprID=<sc:fmt value='funcpub-filemanager' type='crypto'/>"
    + "&actions=<sc:fmt value='deleteDir' type='crypto'/>"
    + "&path="+paths --%>
	alertMsg.confirm(hint, {
		okCall: function(){
			var url = "/xmlprocesserservlet";
			$.post(url,
		    	{
		    		"sysName": '<sc:fmt type="crypto" value="funcpub"/>',
		    		"oprID": '<sc:fmt type="crypto" value="funcpub-filemanager"/>',
		    		"actions": '<sc:fmt type="crypto" value="deleteDir"/>',
		    		"path": paths,
		    		"subName": treeNode.code
	    		},
		    	function(data){
		    		var msg = $(data).find('DataPacket Response Data msg').text();
		    		if("success" == msg){
		    			alertMsg.correct('删除成功');
		    			var treeObj = $.fn.zTree.getZTreeObj("fileTree");
		    			treeObj.reAsyncChildNodes(treeNode.getParentNode(), "refresh");
		    		}else{
		    			alertMsg.error("删除失败！");
		    		}
		    	}
			, "xml"); 
		}
	});
}

function uploadFile(isRightClick) {
	var treeNode = null;
	if (isRightClick) {
		treeNode = currentTreeNode;
		if(treeNode == null ){
			alertMsg.error("请选择文档目录!");
			return;
		}
	} else {
		treeNode = currentSelectedTreeNode;
		if(treeNode.level == "0" ){
			alertMsg.error("此文档目录下不能上传文件!");
			return;
		}
	}
	var url = "/funcpub/filemanager/search/uploaddatafile.jsp?id="+treeNode.id+"&level="+treeNode.level+"&path="+encodeURI(treeNode.path)+"&subName="+treeNode.code;
	$.pdialog.open(url,"uploadFiles","上传文件", {width:500,height:300,minable:false,maxable:false,mask:true,close:function(){
		var treeObj = $.fn.zTree.getZTreeObj("fileTree");
		treeObj.reAsyncChildNodes(treeNode, "refresh");
		return true;
	}});
}

function refreshTreeNode() {
	var treeObj = $.fn.zTree.getZTreeObj("fileTree");
	treeObj.reAsyncChildNodes(currentTreeNode, "refresh");
}
</script>
</html>