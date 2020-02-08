<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URLDecoder"%>
<%-- <%
	String data= request.getParameter("data");  
	if(!(null==data||"".equals(data))){
		data=URLDecoder.decode(data,"utf-8");
	} 
%> --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>菜单发布</title>
</head>
<body>
<div id="managerPrdpara" onclick="hideRightClickMenu()">
	<div style="float:left;width:100%;height:450px;">
		<ul id="menuTree_publish" class="ztree" style="width:100%;height:100%;overflow:auto;"></ul>
	</div>
	
	<div id="rightClickMenu1" class="rightClickMenu">
		<li onclick="addMenu()" class="rightadd">新增下级菜单</li>
	</div>
	
	<div class="formBar" >
		<ul>
			<li><button type="button" class="button" onclick="publishMenuAfter()">提交</button></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>
</div>
</body>
<script type="text/javascript">
	var currentTreeNode = null; //记录当前操作的treeNode
	var menuSetting_publish = {
		view: {
			dblClickExpand: true,//是否双击展开树
			showLine: true,// 是否显示连接线
			selectedMulti: false,// 是否多选
			showIcon : true// 是否显示图标
		},
		check: {
			enable: true,
			chkStyle:"radio", //单选框
			radioType:"all",  //level：在每一级节点范围内当做一个分组;all:在整棵树范围内当做一个分组
			autoCheckTrigger: true
		},
		async: {
			enable: true,// 是否异步
			url: "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-menupublish' type='crypto'/>&actions=<sc:fmt value='getMenuTree' type='crypto'/>",
			dataType: "xml",// 返回数据类型
			dataFilter : function (treeId, parentNode, responseData){// 数据拦截器，可以将返回的数据组装成你需要的样子
							var zNodes = $(responseData).find('DataPacket Response Data menutree').text();
							return $.parseJSON(zNodes);
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
		callback: {
			beforeAsync: function(treeId, treeNode){
				return true;
			},
			onAsyncSuccess:function(event, treeId, treeNode, msg){
				initUI($('#'+treeId));//兼容JUI
			},
			onClick: function(event, treeId, treeNode, clickFlag){
				 var treeObj = $.fn.zTree.getZTreeObj("menuTree_publish");
				 treeObj.checkNode(treeNode, true, false);
			},
			onAsyncError:function(event, treeId, treeNode, msg){return true;},
			
			beforeRightClick:function(treeId, treeNode){
				hideRightClickMenu();
				$("#rightClickMenu1").css("display","block");//显示右键菜单
				
				return true;
			},
			onRightClick:function(event, treeId, treeNode){
				//设置右键菜单位置
				if( $("#sidebar").css("display") == "block"){
					$("div[id^=rightClickMenu]").css("margin-left",event.clientX-470+"px");
					$("div[id^=rightClickMenu]").css("margin-top",event.clientY-100+"px"); 
				}else{
					$("div[id^=rightClickMenu]").css("margin-left",event.clientX-470+"px");
					$("div[id^=rightClickMenu]").css("margin-top",event.clientY-100+"px"); 
				}
				currentTreeNode = treeNode;
				var treeObj = $.fn.zTree.getZTreeObj("menuTree_publish");
				treeObj.cancelSelectedNode();
				treeObj.selectNode(treeNode,false);
			}
		}
	};

	$(function(){
		$.fn.zTree.init($('#menuTree_publish'), menuSetting_publish);
	});


	function hideRightClickMenu(){  //隐藏右键菜单
		$("#rightClickMenu1").css("display","none");
	}
	
	function addMenu(){
		if(currentTreeNode == null ){
			alertMsg.error("请选择上级菜单!");
			return;
		}
		var url = "/funcpub/portal/menu/addMenu_publish.jsp?id="+currentTreeNode.id+"&level="+currentTreeNode.level;
		$.pdialog.open(url,"addMenu4","新增菜单", {width:500,height:400,minable:false,maxable:false,mask:true,close:function(){
			$.fn.zTree.destroy('menuTree_publish');
			$.fn.zTree.init($('#menuTree_publish'), menuSetting_publish);
			return true;
		}});
	}

	function publishMenuAfter(){
		var treeObj = $.fn.zTree.getZTreeObj("menuTree_publish");
		var nodes = treeObj.getCheckedNodes(true);
		var menuids = new Array();
		var levels = new Array();
	 	$(nodes).each(function(index,node){
	 		menuids.push(node.id);
	 		levels.push(node.level);
		});
	 	
	 	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='sunrpt' type='crypto'/>"
	 			+ "&oprID=<sc:fmt value='sunrpt-report' type='crypto'/>"
	 			+ "&actions=<sc:fmt value='publishMenuAction' type='crypto'/>"
	 			+ "&data="+encodeURI(encodeURI(decodeURI("${param.data}")))
	 			+ "&levels="+levels
	 			+ "&menuids="+menuids;
		$.ajax({    
	        type:'post',        
	        url:url,
	        async:false,   
	        dataType:'XML', 
	        success:function(data){   
	        	var msg = $(data).find('DataPacket Response Data msg').text();
	        	if(msg == "success"){
	        		alertMsg.correct("发布成功"); 
	        		$.pdialog.closeCurrent(); 
	        	}else{
	        		alertMsg.error(msg);
	        	}
	        }    
	    });   
	}
</script>
</html>