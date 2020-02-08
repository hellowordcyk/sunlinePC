<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 标签权限配置机构树页面
 * description: 
 *     1.选择权限页面
 * author: daoge
 * createtime: 2016.12.6
 * logs:
 *--%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>标签权限管理</title>
<body>
<div class="managerPrdpara">
	<div class="prdinfoBox-left" >
		<div style="width:100%;">
			<h2 id="roleInfo" class="contentTitle" style="text-align:left; margin: 0;">角色信息：rolename&nbsp;&nbsp;[roleid] 
				<a class="btnNormal" style="margin-left:50px;"  href="javascript:refreshPagePriv(this);">
                    <span>刷新</span>
                </a>
			</h2>
		</div>
		<div style="overflow-x:hidden;overflow-y:auto;">
			<ul id="tree_pagePriv" class="ztree" style="min-height:400px;_height:400px;*height:400px;"></ul>
		</div>
	</div>
   <div id="pagePrivBox" class="prdinfoBox" ></div>
</div>
</body>
<script type="text/javascript">
var pageScope = navTab.getCurrentPanel().find("#page_priv_ctt");
var page_priv_setting = {
	treeId:"page_priv_tree",
	view: {
		dblClickExpand: true,
		showLine: true,
		selectedMulti: false,
		showIcon : true
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
		onClick: function(event, treeId, treeNode, clickFlag){
			if(!treeNode.isParent){
				var url = "/httpprocesserservlet?"
					+ "sysName=<sc:fmt value='funcpub' type='crypto'/>"
					+ "&oprID=<sc:fmt value='page-privilege' type='crypto'/>"
					+ "&actions=<sc:fmt value='getPagePrivList' type='crypto'/>"
					+ "&forward=<sc:fmt value='/funcpub/privilege/pageprivilege/priv_update.jsp' type='crypto'/>"
					+ "&pageNamespace="+treeNode.id+"&roleId=<c:out value='${param.roleId}'/>";
				url = url.replaceAll("#", "%23");
				$('#pagePrivBox',pageScope).loadUrl(url);// 取代<a/>标签  兼容JUI
			}
		}
	}
};


$(function(){
	var treeObj = null;
	var roleId = '${param.roleId}';
	var roleName = null;
	var url = "/xmlprocesserservlet?"
		+ "sysName=<sc:fmt value='funcpub' type='crypto'/>"
		+ "&oprID=<sc:fmt value='page-privilege' type='crypto'/>"
		+ "&actions=<sc:fmt value='queryPagePrivTree' type='crypto'/>"+"&roleid="+roleId; 
	$.ajax({
	   type: "POST",
	   url: url,
	   dataType: "XML",
	   async:false,
	   success: function(data){
		   var tempData = $(data).find("DataPacket Response Data jsonDataStr").text();
		   treeObj = $.parseJSON(tempData);
		   for(var i in treeObj){
               var tempNode = treeObj[i];
			   if(tempNode.isParent==false) {
                   tempNode.icon = "/common/func-images/menu-icon/menuicon.png";
               }else{
                   tempNode.icon = "/common/func-images/menu-icon/webfolder.png";
               }
		   }
		   var roleInfo = $(data).find("DataPacket Response Data roleInfo").text();
		   roleId = roleInfo.split(",")[1];
		   roleName = roleInfo.split(",")[0];
	   },
	   error:function(){
		   treeObj={id:"",name:"初始化机构树数据失败",isParent:false};
	   }
	});
	$.fn.zTree.init($("#tree_pagePriv",pageScope),page_priv_setting,treeObj);
	var html = $("#roleInfo",pageScope).html();
	html = html.replace("rolename",roleName).replace("roleid",roleId);
	$("#roleInfo",pageScope).html(html);
});

function refreshPagePriv(){
	var url = "/xmlprocesserservlet?"
		+ "sysName=<sc:fmt value='funcpub' type='crypto'/>"
		+ "&oprID=<sc:fmt value='page-privilege' type='crypto'/>"
		+ "&actions=<sc:fmt value='refreshPagePriv' type='crypto'/>";
	$.ajax({
	   type: "POST",
	   url: url,
	   dataType: "XML",
	   async:false,
	   success: function(data){
		   var retCode = $(data).find("DataPacket Response Data retCode").text();
		   if("200"==retCode) {
			   alertMsg.correct("刷新成功！");
			   reloadPagePrivTab();
		   }else{
			   alertMsg.error("刷新失败！");
		   }
	   },
	   error:function(){
		  alertMsg.error("刷新失败！");
	   }
	});
}

function reloadPagePrivTab(elm) {
	$("#tree_pagePriv",pageScope).closest("div.tabs").find("div.tabsHeader").find("a#page_priv_tab").click();
}
</script>
</html>