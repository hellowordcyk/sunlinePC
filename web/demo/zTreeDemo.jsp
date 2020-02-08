<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>使用zTree实现异步树样例</title>
<%
	String sysName = Crypto.encode(request, "funcpub");
	String oprID = Crypto.encode(request, "funcpub-logconfig");
	String actions = Crypto.encode(request, "getOperationTree");
%>
<body>
<div class="pageContent">
	<div class="accordion" style="width:300px;float:left;margin:5px;" >
		<div class="accordionHeader">
			<h2>功能操作列表</h2>
		</div>
		<div class="accordionContent" style="height:435px;">
			<ul id="tree" class="ztree" style="width:280px; overflow:auto;"></ul>
		</div>
    </div>
    <div id="jbsxBox" class="unitBox"></div>
</div>
<div style="text-align: center;color: #FF0000;">关于zTree更详细的使用请查阅SVN目录【03支持过程\02配置管理\zTree_v3\】</div>
</body>
<script type="text/javascript">
var setting = {
	view: {
		dblClickExpand: true,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: false,// 是否多选
		showIcon : true// 是否显示图标
	},
	async: {
		enable: true,// 是否异步
		url: "/xmlprocesserservlet?sysName=<%=sysName%>&oprID=<%=oprID%>&actions=<%=actions%>",
		dataType: "xml",// 返回数据类型
		dataFilter : extractTreeNodeDatas,// 数据拦截器，可以将返回的数据组装成你需要的样子
		autoParam: ["id"]// 异步时传到后台的参数
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
		beforeAsync: function(treeId, treeNode){return true;},
		onAsyncSuccess:onAsyncSuccess,//兼容JUI
		onAsyncError:function(event, treeId, treeNode, msg){return true;},
		beforeClick: beforeClick,
		onClick: onClick
	}
};


$(function(){
	$.fn.zTree.init($('#tree'), setting);
});

/**
 * 从后台提取数据，后台将数据拼装为JSON格式
 */
function extractTreeNodeDatas(treeId, parentNode, responseData){
	var zNodes = $(responseData).find('DataPacket Response Data operdata').text();
	return $.parseJSON(zNodes);
}

/**
 * 在点击事件之前将rel值存入到a标签中（可以做一些点击前的操作如绑定参数等）
 */
function beforeClick(treeId, treeNode){
	$('#'+treeNode.tId+'_a').attr('rel',treeNode.rel);
	// 当非父节点时才允许点击，即叶子节点才允许点击
	return (!treeNode.isParent);
}

/**
 * 节点点击事件
 */
function onClick(event, treeId, treeNode, clickFlag){
	// 连接参数，该参数可以从后端绑定，也可以在前端进行绑定
	// 如果需要根据不同的层级跳转不同链接，则在beforeClick中根据具体情况进行绑定即可
	var url = treeNode.url + "?id=" + treeNode.id;
	$('#jbsxBox').loadUrl(url);// 取代<a/>标签  兼容JUI
}

/**
 * 异步请求成功后调用逻辑
 */
function onAsyncSuccess(event, treeId, treeNode, msg){
	// 调用方法与DWZ兼容
	initUI($('#'+treeId));
}
</script>
</html>