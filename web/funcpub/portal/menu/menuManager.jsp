<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>菜单管理</title>
</head>
<body>
<div onclick="hideRightClickMenu()" class="managerPrdpara">
    
    
	<div class="prdinfoBox-left" style="overflow-x:hidden;" layoutH="1">
		<div style="height:100%;padding-bottom:36px;overflow:auto;">
		  <ul id="menuTree" class="ztree" style="width:100%;"></ul>
		</div>
		<div style="position:absolute;width:100%; bottom:0px;background:#fff;" align="center">
			<table>
				<tr align="center">
				    
					<td><a class="button" target="dialog" rel="importExcel" 
            		   width="600" height="300" minable="false" maxable="false" mask="true" resizable="false" drawable="false"
            		   href="/funcpub/portal/menu/menuexcelImport.jsp" >
            		     <span>导入Excel</span>
            	       </a>
					</td>
					<td><a class="button" href="#" onclick="exprolExcel()">导出Excel</a></td>
					
				</tr>
			</table>
		</div>
	</div>
		
	<div id="menuBox" class="prdinfoBox"></div>
	
	<div id="rightClickMenu1" class="rightClickMenu">  <!-- 根目录的右键菜单 -->
		<li onclick="addMenu()" class="rightadd">新增下级菜单</li>
	</div>
	<div id="rightClickMenu2" class="rightClickMenu">  <!-- 菜单的右键菜单 -->
		<li onclick="addMenu()" class="rightadd">新增下级菜单</li>
		<!-- 
		<li onclick="addFuncPage()" class="rightadd">新增功能页面</li>
		<li onclick="addFuncMethod()" class="rightadd">新增功能点</li>
		 -->
		<li onclick="deleteMenu()" class="rightdelete">删除菜单</li>
	</div>
	<div id="rightClickMenu5" class="rightClickMenu">  <!-- 叶子节点的右键菜单，不能新增子菜单 longjian -->
		<!-- 
		<li onclick="addFuncPage()" class="rightadd">新增功能页面</li>
		<li onclick="addFuncMethod()" class="rightadd">新增功能点</li>
		 -->
		<li onclick="deleteMenu()" class="rightdelete">删除菜单</li>
	</div>
	<!-- 功能页面的右键菜单 -->
	<!-- 
	<div id="rightClickMenu3" class="rightClickMenu">  
        <li onclick="addFuncPage()" class="rightadd">新增功能页面</li>
        <li onclick="addFuncMethod()" class="rightadd">新增功能点</li>
        <li onclick="deleteFuncPage()" class="rightdelete">删除功能页面</li>
    </div>
     -->
    <!-- 功能点的右键菜单 -->
    <!-- 
    <div id="rightClickMenu4" class="rightClickMenu">  
        <li onclick="deleteFuncMethod()" class="rightdelete">删除功能点</li>
    </div>
     -->
	
</div>
</body>
<script type="text/javascript">
var currentTreeNode = null; //记录当前操作的treeNode
var menuSetting = {
	view: {
		dblClickExpand: true,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: false,// 是否多选
		showIcon : true// 是否显示图标
	},
	async: {
		enable: true,// 是否异步
		url: "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>&actions=<sc:fmt value='getMenuTree' type='crypto'/>",
		dataType: "xml",// 返回数据类型
		dataFilter : function (treeId, parentNode, responseData){// 数据拦截器，可以将返回的数据组装成你需要的样子
						var zNodes = $(responseData).find('DataPacket Response Data menutree').text();
						var nodeList = $.parseJSON(zNodes);
						for(var i in nodeList){
							var tempNode = nodeList[i];
							if(tempNode.info=="func_page") {
								tempNode.icon = "/common/func-images/menu-icon/functionpage.png";
							}else if(tempNode.info=="func_method") {
								tempNode.icon = "/common/func-images/menu-icon/actionicon.png";
							}else if(tempNode.isParent==false) {
								tempNode.icon = "/common/func-images/menu-icon/menuicon.png";
							}else{
								tempNode.icon = "/common/func-images/menu-icon/webfolder.png";
							}
						}
						return nodeList;
					},
		autoParam: ["id","level"]// 异步时传到后台的参数
	},
	data: {
		simpleData: {
			enable:true,
			idKey: "id",
			pIdKey: "pId",
			rootPId: ""
		}
	},
	/* edit:{
		enable:true,
		showRenameBtn:false,
		showRemoveBtn:false,
		drag:{
			autoExpandTrigger:true,
			isCopy:false,
			isMove:true,
			prev:true,
			next:true,
			inner:true,
		}
	}, */
	callback: {
		beforeAsync: function(treeId, treeNode){
			return true;
		},
		onAsyncSuccess:function(event, treeId, treeNode, msg){
			initUI($('#'+treeId));//兼容JUI
		},
		onAsyncError:function(event, treeId, treeNode, msg){return true;},
		beforeClick: function(treeId, treeNode){
				if(treeNode.level == 0){
					return false;
				}else{
					return true;
				}
			},
		onClick: function(event, treeId, treeNode, clickFlag){
			var type = treeNode.info;
			var parentType = treeNode.getParentNode().info;
			var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>&actions=<sc:fmt value='getMenuInfoById' type='crypto'/>";
            url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/menu/menuInfo.jsp' />&menuid="+treeNode.id+"&pmenuid="+treeNode.pId;
			if(type=="func_page") {
				var id = treeNode.id.substring(3,treeNode.id.length);
				url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='func-page' type='crypto'/>&actions=<sc:fmt value='getFuncPage' type='crypto'/>";
                url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/func/page/FuncPageInfo.jsp' />&pageCode="+id+"&pType="+parentType+"&pmenuid="+treeNode.pId;
			}else if(type=="func_method") {
				var id = treeNode.id.substring(3,treeNode.id.length);
				url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='func-method' type='crypto'/>&actions=<sc:fmt value='getFuncMethod' type='crypto'/>";
                url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/func/method/FuncMethodInfo.jsp' />&methodCode="+id+"&pType="+parentType+"&pmenuid="+treeNode.pId;
			}else{
				url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>&actions=<sc:fmt value='getMenuInfoById' type='crypto'/>";
	            url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/menu/menuInfo.jsp' />&menuid="+treeNode.id+"&pmenuid="+treeNode.pId;
			}
			$('#menuBox').loadUrl(url);// 取代<a/>标签  兼容JUI
		},
		beforeRightClick:function(treeId, treeNode){
			hideRightClickMenu();
		    var type = 	treeNode.info;
			if(treeNode.level == 0){
				$("#rightClickMenu1",navTab.getCurrentPanel()).css("display","block");//显示右键菜单
			}else if(treeNode.isParent == false){
			    if(type=="menu") {
			    	$("#rightClickMenu5",navTab.getCurrentPanel()).css("display","block");//显示右键菜单
			    }else if(type=="func_page") {
			    	$("#rightClickMenu3",navTab.getCurrentPanel()).css("display","block");//显示右键菜单
			    }else if(type=="func_method") {
                    $("#rightClickMenu4",navTab.getCurrentPanel()).css("display","block");//显示右键菜单
                }
			}else{
			    if(type=="menu") {
			    	$("#rightClickMenu2",navTab.getCurrentPanel()).css("display","block");//显示右键菜单
                }else if(type=="func_page") {
                    $("#rightClickMenu3",navTab.getCurrentPanel()).css("display","block");//显示右键菜单
                }else if(type=="func_method") {
                	$("#rightClickMenu4",navTab.getCurrentPanel()).css("display","block");//显示右键菜单
                }
			}
			return true;
		},
		onRightClick:function(event, treeId, treeNode){
			//设置右键菜单位置
			var left= event.clientX;
			var top = event.clientY;
			$("div.rightClickMenu", navTab.getCurrentPanel()).css("left", left);
			$("div.rightClickMenu", navTab.getCurrentPanel()).css("top", top);
			currentTreeNode = treeNode;
			var treeObj = $.fn.zTree.getZTreeObj("menuTree");
			treeObj.cancelSelectedNode();
			treeObj.selectNode(treeNode,false);
		},
		beforeDrop:function(treeId, treeNodes, targetNode, moveType,isCopy){
				if(!targetNode.isParent && "inner" == moveType){
					return false;
				}else{
					return true;
				}
		},
		onDrop:function(event, treeId, treeNodes, targetNode, moveType,isCopy){
			
		}
		
	}
};
$(function(){
	$.fn.zTree.init($('#menuTree'), menuSetting);
});
///////////////////////////////////////////////
//隐藏右键菜单
function hideRightClickMenu(){
	$("div[id^=rightClickMenu]",navTab.getCurrentPanel()).css("display","none");
}
function addMenu(){
	if(currentTreeNode == null ){
		alertMsg.error("请选择上级菜单!");
		return;
	}
	var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>&actions=<sc:fmt value='getPmenuInfo' type='crypto'/>";
	url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/menu/addMenu.jsp' />&id="+currentTreeNode.id+"&level="+currentTreeNode.level;
	
	//var url = "/funcpub/portal/menu/addMenu.jsp?id="+currentTreeNode.id+"&level="+currentTreeNode.level;
	$.pdialog.open(url,"addMenu","新增菜单", {width:800,height:500,minable:false,maxable:false,mask:true,close:function(){
		var treeObj = $.fn.zTree.getZTreeObj("menuTree");
		treeObj.reAsyncChildNodes(currentTreeNode, "refresh");
		return true;
	}});
}
function deleteMenu(){
	if(currentTreeNode == null ){
		alertMsg.error("请选择菜单!");
		return;
	}else{
		alertMsg.confirm("您确定要删除所选菜单及其以下菜单吗?", {
			okCall: function(){
				var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
					    + "&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>"
					    + "&actions=<sc:fmt value='deleteMenu' type='crypto'/>"
					    + "&menuid="+currentTreeNode.id;
				$.ajax({
			    	type:'POST',
			    	url: url,
			    	dataType:'xml',
			    	success:function(data){
			    		var msg = $(data).find('DataPacket Response Data msg').text();
			    		if("success" == msg){
			    			alertMsg.correct('删除成功');
			    			var treeObj = $.fn.zTree.getZTreeObj("menuTree");
			    			treeObj.reAsyncChildNodes(currentTreeNode.getParentNode(), "refresh");
			    		}else{
			    			alertMsg.error(msg);
			    		}
			    	}
				}); 
			}
		});
	}
}

function addFuncPage() {
	if(currentTreeNode == null ){
        alertMsg.error("请选择上级菜单!");
        return;
    }
	var treeObj = $.fn.zTree.getZTreeObj("menuTree");
	var rootNode = treeObj.getNodeByParam("level",0,null);
	var subsysid = rootNode.id.substring(3,rootNode.id.length);
	var type = currentTreeNode.info;
	var id = currentTreeNode.id;
	var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>&actions=<sc:fmt value='getPmenuInfo' type='crypto'/>";
    url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/func/page/addFuncPage.jsp' />&id="+currentTreeNode.id+"&level="+currentTreeNode.level+"&pType=menu" + "&subsysid="+subsysid;
	if("func_page"==type) {
		id = id.substring(3,id.length);
		var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='func-page' type='crypto'/>&actions=<sc:fmt value='getFuncPage' type='crypto'/>";
	    url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/func/page/addFuncPage.jsp' />&pageCode="+id+"&pType=page" + "&subsysid="+subsysid;
	}
    
    //var url = "/funcpub/portal/menu/addMenu.jsp?id="+currentTreeNode.id+"&level="+currentTreeNode.level;
    $.pdialog.open(url,"addFuncPage","新增功能页面", {width:800,height:500,minable:false,maxable:false,mask:true,close:function(){
        var treeObj = $.fn.zTree.getZTreeObj("menuTree");
        treeObj.reAsyncChildNodes(currentTreeNode.getParentNode(), "refresh");
        return true;
    }});
}

function addFuncMethod() {
    if(currentTreeNode == null ){
        alertMsg.error("请选择上级菜单!");
        return;
    }
    var treeObj = $.fn.zTree.getZTreeObj("menuTree");
	var rootNode = treeObj.getNodeByParam("level",0,null);
	var subsysid = rootNode.id.substring(3,rootNode.id.length);
    var type = currentTreeNode.info;
    var id = currentTreeNode.id;
    var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>&actions=<sc:fmt value='getPmenuInfo' type='crypto'/>";
    url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/func/method/addFuncMethod.jsp' />&id="+currentTreeNode.id+"&level="+currentTreeNode.level+"&pType=menu" + "&subsysid="+subsysid;
    if("func_page"==type) {
        id = id.substring(3,id.length);
        var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='func-page' type='crypto'/>&actions=<sc:fmt value='getFuncPage' type='crypto'/>";
        url += "&forward=<sc:fmt type='crypto' value='/funcpub/portal/func/method/addFuncMethod.jsp' />&pageCode="+id+"&pType=page" + "&subsysid="+subsysid;
    }
    
    
    //var url = "/funcpub/portal/menu/addMenu.jsp?id="+currentTreeNode.id+"&level="+currentTreeNode.level;
    $.pdialog.open(url,"addFuncMethod","新增功能点", {width:800,height:500,minable:false,maxable:false,mask:true,close:function(){
        var treeObj = $.fn.zTree.getZTreeObj("menuTree");
        treeObj.reAsyncChildNodes(currentTreeNode.getParentNode(), "refresh");
        return true;
    }});
}

function deleteFuncPage() {
	if(currentTreeNode == null ){
        alertMsg.error("请选择功能页面!");
        return;
    }else{
        alertMsg.confirm("您确定要删除所选功能页面及其子页面、功能点吗?", {
            okCall: function(){
            	var id = currentTreeNode.id.substring(3,currentTreeNode.id.length);
            	var pType = currentTreeNode.getParentNode().info;
            	var pCode = currentTreeNode.getParentNode().id;
                if(pType=="func_page") {
                    pCode = currentTreeNode.getParentNode().id.substring(3,currentTreeNode.getParentNode().id.length);
                }
                var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
                        + "&oprID=<sc:fmt value='func-page' type='crypto'/>"
                        + "&actions=<sc:fmt value='deleteFuncPage' type='crypto'/>"
                        + "&pageCode="+id + "&pType="+pType + "&pCode="+pCode;
                $.ajax({
                    type:'POST',
                    url: url,
                    dataType:'xml',
                    success:function(data){
                    	var code = $(data).find('DataPacket Response Data retCode').text();
                        var msg = $(data).find('DataPacket Response Data retMessage').text();
                        if(code=="200"){
                            alertMsg.correct(msg);
                            var treeObj = $.fn.zTree.getZTreeObj("menuTree");
                            treeObj.reAsyncChildNodes(currentTreeNode.getParentNode(), "refresh");
                        }else{
                            alertMsg.error(msg);
                        }
                    }
                }); 
            }
        });
    }
}


function exprolExcel() {
	var url = "/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>&actions=<sc:fmt value='getMenuExport' type='crypto'/>";
	url += "&dt=" + new Date()+"&csrftoken="+g_csrfToken;
	location.href = url;
}

function deleteFuncMethod() {
    if(currentTreeNode == null ){
        alertMsg.error("请选择功能点!");
        return;
    }else{
        alertMsg.confirm("您确定要删除所选功能点吗?", {
            okCall: function(){
                var id = currentTreeNode.id.substring(3,currentTreeNode.id.length);
                var pType = currentTreeNode.getParentNode().info;
                var pCode = currentTreeNode.getParentNode().id;
                if(pType=="func_page") {
                	pCode = currentTreeNode.getParentNode().id.substring(3,currentTreeNode.getParentNode().id.length);
                }
                var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
                        + "&oprID=<sc:fmt value='func-method' type='crypto'/>"
                        + "&actions=<sc:fmt value='deleteFuncMethod' type='crypto'/>"
                        + "&methodCode="+id+ "&pType="+pType + "&pCode="+pCode;
                $.ajax({
                    type:'POST',
                    url: url,
                    dataType:'xml',
                    success:function(data){
                        var code = $(data).find('DataPacket Response Data retCode').text();
                        var msg = $(data).find('DataPacket Response Data retMessage').text();
                        if(code=="200"){
                            alertMsg.correct(msg);
                            var treeObj = $.fn.zTree.getZTreeObj("menuTree");
                            treeObj.reAsyncChildNodes(currentTreeNode.getParentNode(), "refresh");
                        }else{
                            alertMsg.error(msg);
                        }
                    }
                }); 
            }
        });
    }
}
</script>
</html>