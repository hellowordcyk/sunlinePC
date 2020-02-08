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
<body>
<sc:doPost sysName="funcpub" oprId="funcpub-deptusermanager" action="getDeptUserConfig" var="config">
</sc:doPost>
<div onclick="hideRightClickMenu()"  class="managerPrdpara">
	<div class="prdinfoBox-left" style="position:relative;padding-bottom: 30px;">
		<div style="height:100%;width:100%;overflow:auto">
			<ul id="deptUserTree" class="ztree"></ul>
		</div>
		<div style="position:absolute;width:100%; bottom:0px;" align="center">
			<table>
				<tr align="center">
					<td><a class="button" href="#" onclick="exprolExcel()">导出Excel</a></td>
					<td><a class="button" href="/funcpub/portal/organization/excelImport.jsp"  target="dialog" close="refreshAll">导入Excel</a></td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="deptUserBox" class="prdinfoBox" layoutH="0" ></div>
	
	<div id="rightClickMenu1" class="rightClickMenu">
		<li onclick="showAddDeptDialog()" class="rightadd">新增下级机构</li>
		<li onclick="showAddUserDialog()" class="rightadd">新增机构人员</li>
		<li onclick="deleteDeptBefore()" class="rightdelete">删除机构</li>
	</div>
	<div id="rightClickMenu2" class="rightClickMenu">
		<li onclick="showAddDeptDialog()" class="rightadd">新增下级机构</li>
		<li onclick="showAddUserDialog()" class="rightadd">新增机构人员</li>
	</div>
	<div id="rightClickMenu3" class="rightClickMenu">
		<li onclick="deleteUserBefore()" class="rightdelete">删除用户</li>
	</div>
	<!-- 机构树 root节点右键事件 -->
	<div id="rightClickRoot" class="rightClickMenu">
		<li onclick="showAddDeptDialog('root')" class="rightadd">新增下级机构</li>
	</div>
	
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
		url: "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>&actions=<sc:fmt value='getDeptUserData' type='crypto'/>",
		dataType: "xml",// 返回数据类型
		dataFilter : function (treeId, parentNode, responseData){// 数据拦截器，可以将返回的数据组装成你需要的样子
				var zNodes = $(responseData).find('DataPacket Response Data deptusertree').text();
				return $.parseJSON(zNodes);
			},
			autoParam : [ "id", "level", "code" ]
		// 异步时传到后台的参数
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
			beforeAsync : function(treeId, treeNode) {
			},
			onAsyncSuccess : function(event, treeId, treeNode, msg) {

				//兼容JUI方法
				initUI($('#' + treeId, navTab.getCurrentPanel()));

				var treeObj = $.fn.zTree.getZTreeObj("deptUserTree"); // 默认打开第一级
				var orgs = treeObj.getNodesByParam("pId", rootPid, null);
				for(var i=0;orgs && i <orgs.length;i++) {
					treeObj.expandNode(orgs[i], true, false, false);
				}

				if (treeNode) {
					//添加当前节点选中样式
					if (currentId == treeNode.code) {//最后一个节点
						var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
						treeObj.selectNode(treeNode, false);
						return;
					}
					//展开节点
					expandNodes(treeNode.children);
				}

			},//兼容JUI
			onAsyncError : function(event, treeId, treeNode, msg) {

			},
			beforeClick : function(treeId, treeNode) {
				$('#' + treeNode.tId + '_a', navTab.getCurrentPanel()).attr('rel', treeNode.rel+new Date().getTime());
				// 当非父节点时才允许点击，即叶子节点才允许点击 
				return true;
			},
			onClick : function(event, treeId, treeNode, clickFlag) {
				// 连接参数，该参数可以从后端绑定，也可以在前端进行绑定
				// 如果需要根据不同的层级跳转不同链接，则在beforeClick中根据具体情况进行绑定即可
				var tempUrl = treeNode.url+"&t="+new Date().getTime();
				if (treeNode.id==treeNode.pId || treeNode.pId == rootPid) {
					tempUrl = tempUrl+"&isRoot=root";
				}
				$('#deptUserBox', navTab.getCurrentPanel()).loadUrl(tempUrl);// 取代<a/>标签  兼容JUI 

				currentTreeNode = treeNode;

				return false;
			},
			beforeRightClick : function(treeId, treeNode) {
				hideRightClickMenu();
				// 根节点 只能新增机构
				if (treeNode.id==treeNode.pId && treeNode.id==rootPid) {
					$("#rightClickRoot", navTab.getCurrentPanel()).css(
							"display", "block");//显示右键菜单
				} else if (treeNode.pId == "" || treeNode.pId == rootPid) {
					$("#rightClickMenu2", navTab.getCurrentPanel()).css(
							"display", "block");//显示右键菜单
				} else if (treeNode.url.indexOf("deptManager.jsp") > -1) {
					$("#rightClickMenu1", navTab.getCurrentPanel()).css(
							"display", "block");//显示右键菜单
				} else if (treeNode.url.indexOf("userManager.jsp") > -1) {
					$("#rightClickMenu3", navTab.getCurrentPanel()).css(
							"display", "block");//显示右键菜单
				}
				return true;
			},
			onRightClick : function(event, treeId, treeNode) {
				//设置右键菜单位置
				var left= event.clientX;
				var top = event.clientY;
				$("div.rightClickMenu", navTab.getCurrentPanel()).css("left", left);
				$("div.rightClickMenu", navTab.getCurrentPanel()).css("top", top);
				
				currentTreeNode = treeNode;
				var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
				treeObj.cancelSelectedNode();
				treeObj.selectNode(treeNode, false);
			}
		}
	};
	$(function() {
		$.fn.zTree.init($('#deptUserTree'), deptUserSetting);
		//默认加载 根节点页面 longjian 20160623
		$('#deptUserBox', navTab.getCurrentPanel()).loadUrl("/funcpub/portal/organization/deptManagerRoot.jsp?id="+rootPid);
	});

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

	/*
	 * 展开所有节点
	 */
	function expandAll() {
		var zTree = $.fn.zTree.getZTreeObj("deptUserTree");
		expandNodes( zTree.transformToArray(zTree.getNodes()));
	}

	/*
	 * 根据节点展开节点
	 */
	function expandNodes(nodes) {
		if (!nodes)
			return;
		var zTree = $.fn.zTree.getZTreeObj("deptUserTree");
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
				var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
				treeObj.selectNode(treeNode, false);
				$('#' + treeNode.tId + '_a', navTab.getCurrentPanel()).attr('rel', treeNode.rel+new Date().getTime());
				var tempUrl = treeNode.url+"&t="+new Date().getTime();
				if (treeNode.id==treeNode.pId || treeNode.pId == rootPid) {
					tempUrl = tempUrl+"&isRoot=root";
				}
				$('#deptUserBox', navTab.getCurrentPanel()).loadUrl(tempUrl);// 取代<a/>标签  兼容JUI 
				currentTreeNode = treeNode;
				return;
			}
		}
	}

	//////////////////////////
	//隐藏右键菜单
	function hideRightClickMenu() {
		$("div .rightClickMenu", navTab.getCurrentPanel()).css("display",
				"none");
	}

	//弹出新增下级机构对话框
	function showAddDeptDialog(isRoot) {
		if (null == currentTreeNode) {
			alertMsg.error("请选择上级机构!");
			return;
		}
		
		var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"
				+ "&actions=<sc:fmt value='getDeptById' type='crypto'/>"
				+ "&forward=<sc:fmt value='/funcpub/portal/organization/addDept.jsp' type='crypto'/>"
				+ "&deptid=" + currentTreeNode.id;
		
		if (currentTreeNode.id == rootPid) {
			url = url+"&isRoot=root";
		}
		$.pdialog.open(url, "addDept", "新增机构", {
			width : 800,
			height : 500,
			minable : false,
			maxable : false,
			mask : true,
			close : function() {
				var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
				treeObj.reAsyncChildNodes(currentTreeNode, "refresh");
				return true;
			}
		});
	}
	//弹出新增机构人员对话框
	function showAddUserDialog() {
		if (null == currentTreeNode) {
			alertMsg.error("请选择上级机构!");
			return;
		}
		var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"
				+ "&actions=<sc:fmt value='getDeptById' type='crypto'/>"
				+ "&forward=<sc:fmt value='/funcpub/portal/organization/userInfo.jsp' type='crypto'/>"
				+ "&deptid=" + currentTreeNode.id
				+ "&showType=dialog";

		/* var url = "/funcpub/portal/organization/addUser.jsp?deptid="+currentTreeNode.id; */
		$.pdialog.open(url, "addUser", "新增用户", {
			width : 800,
			height : 600,
			minable : false,
			maxable : false,
			mask : true,
			close : function() {
				var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
				treeObj.reAsyncChildNodes(currentTreeNode, "refresh");
				return true;
			}
		});
	}
	function deleteDeptBefore() {
		if (null == currentTreeNode) {
			alertMsg.warn("请选择机构!");
			return;
		} else if (currentTreeNode.pId == rootPid) {
			alertMsg.warn("不能删除一级机构！");
			return;
		} else {
			var msg = "确定要删除所选机构及其下级机构吗?";
			alertMsg.confirm(msg, {
				okCall : function() {
					deleteDept(currentTreeNode.code.substring(1), 'current');
				}
			});
		}
	}
	//删除机构
	function deleteDept(deptcds, flushlag) {
		if (null == deptcds || "" == deptcds) {
			alertMsg.warn("请选择机构!");
			return;
		}
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"
				+ "&actions=<sc:fmt value='deleteDept' type='crypto'/>";
		$.ajax({
			type : 'POST',
			url : url,
			data : {
				deptcds : deptcds
			},
			dataType : 'xml',
			async : false,
			success : function(data) {
				var msg = $(data).find('DataPacket Response Data msg').text();
				if ("success" == msg) {
					alertMsg.correct('删除成功');
					//移除节点
					//remove();
					/* if(flushlag == "current"){
						var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
						treeObj.reAsyncChildNodes(currentTreeNode, "refresh");
						//$(querybtn).trigger("click");
					}else{
					 */
					//不使用remove方法， 直接刷新 父节点 edit by longjian 
					var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
					treeObj.reAsyncChildNodes(currentTreeNode.getParentNode(),
							"refresh");
					//} 
				} else {
					alertMsg.error(msg);
				}
			}
		});
	}
	function remove(e) {
		var zTree = $.fn.zTree.getZTreeObj("deptUserTree"), nodes = zTree
				.getSelectedNodes(), treeNode = nodes[0];
		if (nodes.length == 0) {
			alert("请先选择一个节点");
			return;
		}
		//var callbackFlag = $("#callbackTrigger").attr("checked");
		zTree.removeNode(treeNode, null);
	};

	function deleteUserBefore() {
		if (null == currentTreeNode) {
			alertMsg.error("请选择 用户!");
			return;
		} else {
			var msg = "确定要删除所选用户吗?";
			alertMsg.confirm(msg, {
				okCall : function() {
					deleteUser(currentTreeNode.id);
				}
			});
		}
	}
	//删除用户
	function deleteUser(userids, flushlag, querybtn) {
		if (null == userids || "" == userids) {
			alertMsg.error("请选择用户!");
			return;
		}
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"
				+ "&actions=<sc:fmt value='deleteUser' type='crypto'/>"
				+ "&userids=" + userids;
		$.ajax({
			type : 'POST',
			url : url,
			dataType : 'xml',
			success : function(data) {
				var msg = $(data).find('DataPacket Response Data msg').text();
				if ("success" == msg) {
					alertMsg.correct('删除成功');
					if (flushlag == "current") {
						var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
						treeObj.reAsyncChildNodes(currentTreeNode, "refresh");
						$(querybtn).trigger("click");
					} else {
						var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
						treeObj.reAsyncChildNodes(currentTreeNode
								.getParentNode(), "refresh");
					}
				} else {
					alertMsg.error(msg);
				}
			}
		});
	}
	//刷新机构树
	function reflush(oldpdeptid, pdeptid) {
		var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");

		if (oldpdeptid == "-1" || null == oldpdeptid || null == pdeptid
				|| "" == oldpdeptid || "" == pdeptid) {
			$.fn.zTree.destroy('deptUserTree');
			$.fn.zTree.init($('#deptUserTree'), deptUserSetting);
		} else {
			var oldNode = "";
			var newNode = "";
			if (oldpdeptid == pdeptid) {
				newNode = treeObj.getNodeByParam("id", pdeptid, null);
				treeObj.reAsyncChildNodes(newNode, "refresh");
			} else {
				oldNode = treeObj.getNodeByParam("id", oldpdeptid, null);
				newNode = treeObj.getNodeByParam("id", pdeptid, null);
				treeObj.reAsyncChildNodes(oldNode, "refresh");
				treeObj.reAsyncChildNodes(newNode, "refresh");
			}
		}
	}

	function exprolExcel() {
		var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>&actions=<sc:fmt value='deptUserExportActor' type='crypto'/>";
		url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
		location.href = url;
	}

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
		var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
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
			$('#deptUserBox', navTab.getCurrentPanel()).loadUrl(tempUrl);// 取代<a/>标签  兼容JUI 
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
	
	

	// 导入成功之后，全部刷新
	function refreshAll() {
		reflush(null, null);
		return true;
	}
</script>
</html>