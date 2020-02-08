<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>机构人员管理</title>
<script type='text/javascript' src='/common/func-scripts/jquery.autocomplete.js'></script>
<link rel="stylesheet" type="text/css" href="/common/func-css/jquery.autocomplete.css" />
</head>

<sc:doPost sysName="funcpub" oprId="funcpub-deptusermanager" action="getDeptUserConfig" var="config"></sc:doPost>
<body>
	<div class="managerPrdpara"  style="position:relative;">
		<div class="prdinfoBox-left" style="position:relative;padding-bottom: 30px;">
			<div style="height:100%;width:100%;overflow:auto">
				<ul id="userGrantManager" class="ztree"></ul>
			</div>
		</div>
		<div id="userGrantManagerBox" class="prdinfoBox" layoutH="0" ></div>
	</div>
</body>

<script type="text/javascript">
var currentTreeNode = null; //记录当前操作的treeNode
var currentId = null;//其它页面点击时的ID，通过此ID在自动展开树后，添加点击样式
var idArray = new Array("d-1");//默认根节点的code为d-1
var rootPid = "${config.rspDataMap.ROOTDEPTID}";
var deptUserSetting = {
	view: {
		dblClickExpand: true,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: false,// 是否多选
		showIcon : true// 是否显示图标
	},
	async: {
		enable: true,// 是否异步
		url: "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>&actions=<sc:fmt value='getDeptUserDataNew' type='crypto'/>",
		dataType: "xml",// 返回数据类型
		dataFilter : function (treeId, parentNode, responseData){// 数据拦截器，可以将返回的数据组装成你需要的样子
				var zNodes = $(responseData).find('DataPacket Response Data deptusertree').text();
				return $.parseJSON(zNodes);
			},
			autoParam : [ "id", "level", "code" ]
	},
	data : {
		simpleData : {
			enable : true,
			idKey : "id",
			pIdKey : "pId",
			rootPId : rootPid
		}
	},
	callback : {
		beforeAsync : function(treeId, treeNode) {},
		onAsyncSuccess : function(event, treeId, treeNode, msg) {
			initUI($('#' + treeId, navTab.getCurrentPanel()));
			var treeObj = $.fn.zTree.getZTreeObj("userGrantManager"); // 默认打开第一级
			var orgs = treeObj.getNodesByParam("pId", rootPid, null);
			for(var i=0;orgs && i <orgs.length;i++) {
				treeObj.expandNode(orgs[i], true, false, false);
			}
			if (treeNode) {
				//添加当前节点选中样式
				if (currentId == treeNode.code) {//最后一个节点
					var treeObj = $.fn.zTree.getZTreeObj("userGrantManager");
					treeObj.selectNode(treeNode, false);
					return;
				}
				expandNodes(treeNode.children);//展开节点
			}

		},
		onAsyncError : function(event, treeId, treeNode, msg) {},
		beforeClick : function(treeId, treeNode) {
			$('#' + treeNode.tId + '_a', navTab.getCurrentPanel()).attr('rel', treeNode.rel+new Date().getTime());
			
			return true;
		},
		onClick : function(event, treeId, treeNode, clickFlag) {
			// 连接参数，该参数可以从后端绑定，也可以在前端进行绑定
			// 如果需要根据不同的层级跳转不同链接，则在beforeClick中根据具体情况进行绑定即可
			var tempUrl = treeNode.url+"&t="+new Date().getTime();
			if (treeNode.id==treeNode.pId || treeNode.pId == rootPid) {
				tempUrl = tempUrl+"&isRoot=root";
			}
			$('#userGrantManagerBox', navTab.getCurrentPanel()).loadUrl(tempUrl);// 取代<a/>标签  兼容JUI 
			currentTreeNode = treeNode;
			return false;
		}
	}
};
$(function() {
	$.fn.zTree.init($('#userGrantManager'), deptUserSetting);
	$('#userGrantManagerBox', navTab.getCurrentPanel()).loadUrl("/funcpub/portal/userpriv/deptManagerRoot.jsp?id="+rootPid);
});
/*
 * 定位机构人员在树中的位置（异步加载）
 */
function toViewInTree(deptid, orgseq, code, type) {
	//通过机构ID去查询机构的orgseq信息，因为orgseq信息是由deptcode组成，
	//而ztree机构数的id是以deptid组成,所以需要在后台查询获取由deptid组成的orgseq信息
	if (!deptid || !orgseq || !code || !type) {
		return;
	}

	//当当前节点已经展开时
	var treeObj = $.fn.zTree.getZTreeObj("userGrantManager");
	var treeNode = null;
	//定位机构
	if ("dept" == type) {
		treeNode = treeObj.getNodeByParam("code", "d" + code, null);
	} else if ("user" == type) {//定位人员
		treeNode = treeObj.getNodeByParam("code", "u" + code, null);
	}

	//当当前节点已经展开时
	if (treeNode) {
		treeObj.selectNode(treeNode, false);
		$('#' + treeNode.tId + '_a', navTab.getCurrentPanel()).attr('rel', treeNode.rel+new Date().getTime());
		var tempUrl = treeNode.url+"&t="+new Date().getTime();
		if (treeNode.id==treeNode.pId || treeNode.pId == rootPid) {
			tempUrl = tempUrl+"&isRoot=root";
		}
		$('#userGrantManagerBox', navTab.getCurrentPanel()).loadUrl(tempUrl);// 取代<a/>标签  兼容JUI 
		currentTreeNode = treeNode;
		return;
	}

	//解析Orgseq放到idArray中
	var codeArray = orgseq.split(".");

	for (var i = 0; i < codeArray.length; i++) {
		if (null == codeArray[i] || "" == codeArray[i]) {
			continue;
		}
		idArray[idArray.length] = "d" + codeArray[i];

	}

	if ("user" == type) {
		idArray[idArray.length] = "u" + code;
	}
	currentId = idArray[idArray.length - 1];
	//展开节点
	expandAll();
}
/*
 * 展开所有节点
 */
function expandAll() {
	var zTree = $.fn.zTree.getZTreeObj("userGrantManager");
	expandNodes( zTree.transformToArray(zTree.getNodes()));
}

/*
 * 根据节点展开节点
 */
function expandNodes(nodes) {
	if (!nodes)
		return;
	var zTree = $.fn.zTree.getZTreeObj("userGrantManager");
	for (var i = 0, l = nodes.length; i < l; i++) {
		var treeNode = nodes[i];
		if (isContains(treeNode.code)) {
			zTree.expandNode(treeNode, true, false, false);
		}
		if (treeNode.isParent && treeNode.zAsync) {
			if (isContains(treeNode.code)) {
				expandNodes(treeNode.children);
			}
		}
		if (currentId == treeNode.code) {//最后一个节点是人员时，添加样式
			var treeObj = $.fn.zTree.getZTreeObj("userGrantManager");
			treeObj.selectNode(treeNode, false);
			$('#' + treeNode.tId + '_a', navTab.getCurrentPanel()).attr('rel', treeNode.rel+new Date().getTime());
			var tempUrl = treeNode.url+"&t="+new Date().getTime();
			if (treeNode.id==treeNode.pId || treeNode.pId == rootPid) {
				tempUrl = tempUrl+"&isRoot=root";
			}
			$('#userGrantManagerBox', navTab.getCurrentPanel()).loadUrl(tempUrl);// 取代<a/>标签  兼容JUI 
			currentTreeNode = treeNode;
			return;
		}
	}
}
/*
 * 通过Code判断当前节点是否需要展开
 */
function isContains(code) {
	for (var i = 0; i < idArray.length; i++) {
		if (code == idArray[i]) {
			return true;
		}
	}
	return false;
}
</script>

</html>