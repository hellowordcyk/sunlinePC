<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>日志配置管理</title>
<%
	String sysName = Crypto.encode(request, "funcpub");
	String oprID = Crypto.encode(request, "funcpub-logconfigmanage");
	String actions = Crypto.encode(request, "getOperationTree");
%>
<body>
<div class="managerPrdpara">
	<div class="prdinfoBox-left" >
		<ul id="tree" class="ztree" ></ul>
	</div>
		<!-- <div class="formBar">
				<a href="" target='ajax' rel=''><button type="button">导入日志配置</button></a>
				<a onclick="alert('TODO')"><button type="button">导出日志配置</button></a>
		</div> -->
   <div id="jbsxBox" class="prdinfoBox" ></div>
</div>
</body>
<script type="text/javascript">
var setting = {
	view: {
		dblClickExpand: true,
		showLine: true,
		selectedMulti: false,
		showIcon : true
	},
	async: {
		enable: true,
		url: "/xmlprocesserservlet?sysName=<%=sysName%>&oprID=<%=oprID%>&actions=<%=actions%>",
		dataType: "xml",
		dataFilter : extractTreeNodeDatas,
		autoParam: ["id"]
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
		onAsyncSuccess:function(event, treeId, treeNode, msg){initUI($('#'+treeId));},//兼容JUI
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
 * 在点击事件之前将rel值存入到a标签中
 */
function beforeClick(treeId, treeNode){
	if(treeNode.isParent){
		return false;
	}else{// 当非父节点时才允许点击，即叶子节点才允许点击
		$('#'+treeNode.tId+'_a').attr('rel',treeNode.rel);
		return true;
	}
}

function onClick(event, treeId, treeNode, clickFlag){
	var url = treeNode.url + "?id=" + treeNode.id;
	$('#jbsxBox').loadUrl(url);// 取代<a/>标签  兼容JUI
}

</script>
</html>