<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ include file="/jui_tag.jsp" %>
<%-- <%
	String roleid = request.getParameter("roleid");
%> --%>
<style>
	.ztree_addDiv li a{
		width: 50%;
	}
	
	.ztree_addDiv li div{
		float: right;
		margin-right: 150px;
	}
	
</style>
<input type="hidden" id="roleid" name="roleid" value="<c:out value='${param.roleid }' />">
<div class="pageContent" width="100%" style="overflow-x:hidden;overflow-y:auto;" layoutH="50">
	<ul id="menuGrantTree" class="ztree ztree_addDiv" style="padding-bottom:50px;"></ul>
</div> 
<div class="formBar" >
	<ul>
		<li><button type="button" class="button" onclick="grantMenu()">提交</button></li>
		<li><button type="button" class="close" onclick="closeRolePrivTab();">取消</button></li>
	</ul>
</div>

<script type="text/javascript">
var pageScope = navTab.getCurrentPanel().find("#menu_priv_ctt");
var menuGrantSetting = {
	treeId:"menu_grant_tree",
	view: {
		dblClickExpand: true,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: false,// 是否多选
		showIcon : true,// 是否显示图标
		addDiyDom: null  //addDiyDom
	},
	check: {
		enable: true,
		autoCheckTrigger: true
	},
	data: {
		simpleData: {
			enable:true
		}
	}
};
$(function(){
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='queryRoleMenu' type='crypto'/>&roleid=${param.roleid}";
	$.ajax({    
        type:'post',        
        url:url,
        async:false,   
        dataType:'XML', 
        success:function(data){   
        	var zNodes = $(data).find('DataPacket Response Data menutree').text();
        	var nodeList = $.parseJSON(zNodes);
            for(var i in nodeList){
                var tempNode = nodeList[i];
                if(tempNode.code=="func_page") {
                    tempNode.icon = "/common/func-images/menu-icon/functionpage.png";
                }else if(tempNode.code=="func_method") {
                    tempNode.icon = "/common/func-images/menu-icon/actionicon.png";
                }else if(tempNode.isParent==false) {
                    tempNode.icon = "/common/func-images/menu-icon/menuicon.png";
                }else{
                    tempNode.icon = "/common/func-images/menu-icon/webfolder.png";
                }
            }
        	$.fn.zTree.init($('#menuGrantTree'), menuGrantSetting,nodeList);
        }    
    });    
});


function grantMenu(){
	var treeObj = $.fn.zTree.getZTreeObj("menuGrantTree");
	var nodes = treeObj.getChangeCheckedNodes();
	var menuids = new Array();
	var funcPages = new Array();
	var funcMethods = new Array();
	//获取复选框的值
	var permStrs = getPermStrs();
 	$(nodes).each(function(index,node){
 		if(node.code=="func_page") {
 			funcPages.push(node.id.substring(3,node.id.length));
        }else if(node.code=="func_method") {
        	funcMethods.push(node.id.substring(3,node.id.length));
        }else{
        	menuids.push(node.id);
        }
 		 //因为本页面授权成功后，没有重新加载ZTree，所有需要保存勾选状态，不然获取 被改变的状态，将和最开始的数据对比 longjian
 		node.checkedOld = node.checked;  
	});	

  	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
 			+ "&oprID=<sc:fmt value='PcmcRole' type='crypto'/>"
 			+ "&actions=<sc:fmt value='mergeRoleMenu' type='crypto'/>"
 			+ "&roleid=<c:out value='${param.roleid}' />"
 			+ "&menuids="+menuids
 			+ "&permStrs=" + permStrs
 			+ "&funcPages="+funcPages
 			+ "&funcMethods="+funcMethods;
	$.ajax({    
        type:'post',        
        url:url,
        dataType:'xml', 
        success:function(data){ 
        	var msg = $(data).find('DataPacket Response Data msg').text();
        	if(msg == "success"){
        		alertMsg.correct("授权成功");
        		//判断当前角色是否为被授权角色，如果是刷新菜单
        		/* if($("#roleid").val() == $("#currentRoleid_id").val()){
        			Jraf.menuCacheMap = [];
        			ajaxLoadTopMenuAndLeftMenu();
        		} */
        	}else{
                alertMsg.error(msg);
            }
        }    
    });    
}


//添加自定义节点
function addDiyDom(treeId, treeNode) {
	var roletp = "${param.roletp}";
	if("2" == roletp || "3" == roletp){
		return;
	}
	if(!treeNode || treeNode.level == 0){
		return;
	}
	var aObj = $("#" + treeNode.tId + "_a", pageScope);
	var name = "checkbox" + treeNode.id;
	
	if(!treeNode.isParent){
		//根据数据字典初始化权限规则
		var editStr = '<sc:dcheckbox name="filterrule'+treeNode.id+'" key="pcmc,filterrule"  type="dict" dsp="span" validate="required" />';
		aObj.parent().append(editStr);
	}
	
	//初始化选中项
	initChecked(treeNode);
	
	
}


function initChecked(treeNode){
	if(!treeNode.info){
		return;
	}
	
	var permArray = treeNode.info.split("_");
	var aObj = $("#" + treeNode.tId + "_a", pageScope);
	if(permArray){
		var checkboxs = $("input[name='filterrule"+treeNode.id+"']", pageScope);
		if(checkboxs){
			var checkedVal = null;
			for(var i = 0; i < permArray.length; i ++){
				checkedVal = permArray[i];
				for(var j = 0; j < checkboxs.length; j ++){
					if(checkedVal == checkboxs[j].value){
						$(checkboxs[j]).attr("checked", "checked");
					}
				}
			}
		}
	}
}


function getPermStrs(){
	var treeObj = $.fn.zTree.getZTreeObj("menuGrantTree");
	var nodes = treeObj.getCheckedNodes();

	var permStrs = new Array();
	var permStr = null;
 	$(nodes).each(function(index,node){
 		//获取权限ID  
 		if(node.code!='func_page' && node.code!='func_method') {   //排除功能页面和功能点，
 			permStr = getPermStr(node.id);
 	        //不管permStr是否为空，都放到参数里。 为空时，就清除权限信息
 	        permStrs.push(node.id + "@" + permStr);
 		}
	});	
 	
 	return permStrs;
}
/*
 * 获取权限字符串
 */
function getPermStr(nodeid){
	var permStr = "";
	var checkboxs = $("input[name='filterrule"+nodeid+"']:checked",pageScope);
	for(var i = 0; i < checkboxs.length; i ++){
		if(i == checkboxs.length - 1){
			permStr += checkboxs[i].value;
		}else{
			permStr += checkboxs[i].value +"_";
		}
	}
	return permStr;	
}

</script>