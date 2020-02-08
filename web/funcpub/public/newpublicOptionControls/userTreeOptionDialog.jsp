<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<div class="pageHeader">
    <form>
	    <div class="searchBar">
	        <table class="searchContent" cellpadding="0" cellspacing="0" >
	              <tr>
	             <td class="form-label">机构编码/名称</td>
	             <td><input type="text" class="textInput" id="deptcdOrNa" name="deptcdOrNa"/></td>
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
<div class="pageContent">
    <div class="pageFormContent">
    <div class="window-left-box" style="width:28%;" layoutH="130">
	    <ul id="deptTree" class="ztree"></ul>
	</div>
        <table class="form-table" cellpadding="0" cellspacing="0" style="width:100%;float:right;" layoutH="130">
            <tr>
                <td class="form-label" style="min-width: 80px;width: 80px;*width: 80px;" valign="top">
                    <span style="padding: 2px 5px 2px 0; display: inline-block; overflow: hidden; white-space: nowrap;" title="全选">
					    <label for="selected_all"> 
					        <input type="checkbox" class="checkboxCtrl" group="selected_userinfo"  id="selected_all" />
					        <input type="hidden" name="selected_userinfo" />
					        <span style="color: gray;">已选人员</span>
					    </label>
					</span>
                </td>
                <td style="white-space: normal;">
                    <div id="selectedUser">
                    </div>
                    
                </td>
            </tr>
            <tr>
                <td colspan="2" style="height: 5px; padding: 0;">
                    <hr style="width: 90%;"/>
                </td>
            </tr>
            <tr>
                <td class="form-label" style="min-width: 80px;width: 80px;*width: 80px;" valign="top">
                    <span style="padding: 2px 5px 2px 0; display: inline-block; overflow: hidden; white-space: nowrap;" title="全选">
                        <label for="unselected_all"> 
                            <input type="checkbox" class="checkboxCtrl" group="unselected_userinfo"  id="unselected_all" />
                            <input type="hidden" name="unselected_userinfo" />
                            <span style="color: gray;">可选人员</span>
                        </label>
                    </span>
                </td>
                <td style="white-space: normal;">
	                 <div id="unselectedUser">
	                 </div>
                </td>
            </tr>
        </table>
    </div>
</div>   
<div class="formBar">
    <ul>
        <li><button type="button" class="button" lookupGroup="" multLookup="selected_userinfo" warn="请勾选角色">选择带回</button></li>
        <li><button class="close" type="button">取消</button></li>
    </ul>
</div>

<script>
var lookupid = "<c:out value='${param.lookupid}' />";
var lookupcode = "<c:out value='${param.lookupcode}' />";
var lookupname = "<c:out value='${param.lookupname}' />";
var selectedCode = '${param.elmId}';
var selectedArr = new Array();
var getColumn = "";
if(lookupid==null || lookupid.length<1){
	lookupid = "lookupid";
}else{
	getColumn = "userid";
}
if(lookupcode==null || lookupcode.length<1){
	lookupcode = "lookupcode";
}else{
	if(getColumn.length<1) {
		getColumn = "usercode";
	}
}

if(lookupname==null || lookupname.length<1){
	lookupname = "lookupname";
}

var selectedList = null;
var $selectedUser =null;  //$("#selectedUser",$.pdialog.getCurrent());
var $unselectedUser = null; // $("#unselectedUser",$.pdialog.getCurrent());
var treeInstance = null;
var deptTreeSetting = {
	view:{
		dblClickExpand: true,//是否双击展开树
		showLine: true,// 是否显示连接线
		selectedMulti: true,// 是否多选
		showIcon : false// 是否显示图标
	},
	data:{simpleData: {enable:true}},
	callback:{
		onClick: function(event, treeId, treeNode, clickFlag){
            // 连接参数，该参数可以从后端绑定，也可以在前端进行绑定
            // 如果需要根据不同的层级跳转不同链接，则在beforeClick中根据具体情况进行绑定即可
            
            var deptcode = treeNode.info.split("-")[1];
            queryUserByDeptCode(deptcode);
            //var treeInstance = $.fn.zTree.getZTreeObj("deptTree");
            treeInstance.selectNode(treeNode,false);
            return false;
        }
	}
};

$(function(){
	var firstRootId = "1";
	$selectedUser =$("#selectedUser",$.pdialog.getCurrent());
	$unselectedUser =$("#unselectedUser",$.pdialog.getCurrent());
	
	if(selectedCode && selectedCode.length>0) {          //初始化 已选中的值
		var defs =selectedCode.split(",");
		for(var i = 0; i < defs.length;i++) {
			selectedArr.push(defs[i]);
		}
	}
	var treeObj = null;
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
		   firstRootId = $(data).find("DataPacket Response Data firstRootId").text();
	   },
	   error:function(){
		   treeObj={id:"",name:"初始化机构树数据失败",isParent:false};
	   }
	});
	//初始化树
	treeInstance = $.fn.zTree.init($("#deptTree"),deptTreeSetting,treeObj);
	var newNode = treeInstance.getNodeByParam("id",firstRootId, null);
	treeInstance.expandNode(newNode, true, false, false);
	var initDeptCode = newNode.info.split("-")[1];
	queryUserByDeptCode(null);
});

function queryUserByDeptCode(deptcode) {
	var unselectedList = null;
	var url = "/xmlprocesserservlet?"
        + "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
        + "&oprID="+'<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>'
        + "&actions="+'<sc:fmt value='queryUserByDeptCode' type='crypto'/>&deptcode='+deptcode;
    $.ajax({
       type: "POST",
       url: url,
       dataType: "XML",
       async:false,
       success: function(data){
    	   var unselectedListStr = $(data).find("DataPacket Response Data userList").text();
    	   unselectedList = $.parseJSON(unselectedListStr);
       },
       error:function(){
           alertMsg.error("数据加载失败！");
       }
    });
   var unselectedHtml = "";
   $unselectedUser.empty();
   for(var i =0; i < unselectedList.length;i++) {
	  /*  if(i>0&&i%3==0) {
		   $unselectedUser.append("<br/>");
       } */
	   var user = unselectedList[i];
	   var checkboxVal = "{"+lookupid+":'"+user.userid+"', "+lookupcode+":'"+user.usercode+"', "+lookupname+":'"+user.username+"'}";
	   unselectedHtml+='<span style="width: 200px; padding: 2px 5px 2px 0; display: inline-block; overflow: hidden; white-space: nowrap;" title="'+user.username+'">';
	   unselectedHtml+='    <label for="unselected_'+user.usercode+'"> ';
	   unselectedHtml+='       <input type="checkbox" name="unselected_userinfo" id="unselected_'+user.usercode+'" value="'+checkboxVal+'" />';
	   unselectedHtml+='       <span style="color: gray;">'+user.username+'</span>';
	   unselectedHtml+='    </label>';
	   unselectedHtml+=' </span>';
	   var tempItem = $(unselectedHtml).appendTo($unselectedUser);
	   tempItem.find("input[name='unselected_userinfo']").bind("change",addToSelected); 
	   for(var j = 0;j < selectedArr.length;j++) {
		   var selectedVal = selectedArr[j];
		   if(user[getColumn]==selectedVal) {
			   tempItem.find("input[name='unselected_userinfo']").click();
			   break;
		   }
	   }
	   unselectedHtml = "";
   }
  
  
  // $unselectedUser.find("input[name='unselected_userinfo']");
   
}

function addToSelected() {
	if($(this).attr("checked")){
		var $addItem = $(this).closest("span").clone();
		var existCount = $selectedUser.find("#"+$addItem.find("input[name='unselected_userinfo']").eq(0).attr("id").substring(2)).length;
		if(existCount>0) {  //相同元素已存在
			return;
		}
		$addItem.find("label").eq(0).attr("for",$addItem.find("label").eq(0).attr("for").substring(2));
		$addItem.find("input[name='unselected_userinfo']").eq(0).attr("id",$addItem.find("input[name='unselected_userinfo']").eq(0).attr("id").substring(2));
		
		$addItem.find("input[name='unselected_userinfo']").eq(0).attr("name","selected_userinfo");
		$addItem.find("input[name='unselected_userinfo']").eq(0).unbind("change",addToSelected);
		
		$addItem.appendTo($selectedUser).find("input[name='selected_userinfo']").bind("change",delFromSelected);
		/* var selectedLength = $selectedUser.children("span").length;
		if(selectedLength > 0 && selectedLength%3==0){
			$selectedUser.append("<br/>");
		} */
	}
}

function delFromSelected() {
	if(!$(this).attr("checked")){
		$unselectedUser.find("#un"+$(this).attr("id")).attr("checked",false);
		$(this).closest("span").remove();
	}
}

function searchDept(){
    var deptcdOrNa = $('#deptcdOrNa').val();
    // 根据节点名称模糊查询机构树
    treeInstance.cancelSelectedNode();
    var nodes = treeInstance.getNodesByParamFuzzy("name", deptcdOrNa);
    if (nodes != "" && nodes != null) {
        // 循环节点，并展开
        for( var i=0, l=nodes.length; i<l; i++) {
            treeInstance.expandNode(nodes[i],true);
            treeInstance.selectNode(nodes[i],true);
        }
    } else {
        alertMsg.info("未找到机构："+deptcdOrNa);
    }
}

</script>
