<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.net.URLDecoder"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<div class="pageHeader" id="userDeptTree">
    <form onsubmit="return searchDept();">
	    <div class="searchBar">
	        <table class="searchContent" cellpadding="0" cellspacing="0" >
	              <tr>
	             <td class="form-label">机构编码/名称</td>
	             <td><input type="text" class="textInput" id="deptcdOrNa" name="deptcdOrNa"/></td>
	             <input type="hidden" class="textInput" id="rootDeptId" name="rootDeptId"/>
	              <input type="hidden" class="textInput" id="currentDeptCode" name="currentDeptNode"/>
	             <td class="form-label">行员编码/名称</td>
	             <td><input type="text" class="textInput" id="usercdOrNa" name="usercdOrNa"/></td>
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
	<div  style="width:70%;float:right; " layoutH="130">
        <table class="form-table" id="selectDeptUserTable" cellpadding="0" cellspacing="0" style="width:100%;float:right;" >
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
	                  <div class="panelBar" id="pagin_unselected">
					
			      </div>
                </td>
            </tr>
            <tr>
               <td></td>
               <td><a href="javaScript:void(0)" id="to_top" style="display:none" onclick="toTop()">回到顶部</a></td>
            </tr>
        </table>
    </div>
    </div>
</div>   
<div class="formBar">
    <ul>
        <li><button type="button" class="button" lookupGroup="" multLookup="selected_userinfo" warn="请勾选人员">选择带回</button></li>
        <li><button class="close" type="button">取消</button></li>
    </ul>
</div>

<script>
//分页
var pageNo= 1;
var pageSize = 16;
var queryName = "";
var pubResource = "no";
var nScrollHight = 0; //滚动距离总长(注意不是滚动条的长度)
var nScrollTop = 0;   //滚动到的当前位置
var pageScope = navTab.getCurrentPanel();
var pageInfo;
var rootPid="";
var isAjax=false;
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
	async: {
		enable: true,// 是否异步
		url: "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>&actions=<sc:fmt value='getDeptTree' type='crypto'/>&async=true",
		dataType: "xml",// 返回数据类型
		dataFilter : function (treeId, parentNode, responseData){// 数据拦截器，可以将返回的数据组装成你需要的样子
				var zNodes = $(responseData).find('DataPacket Response Data treeObj').text();
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
	callback:{
		onClick: function(event, treeId, treeNode, clickFlag){
            // 连接参数，该参数可以从后端绑定，也可以在前端进行绑定
            // 如果需要根据不同的层级跳转不同链接，则在beforeClick中根据具体情况进行绑定即可
            var deptcode = treeNode.info.split("-")[1];
            //设置为空模糊查询条件
            var deptcdOrNa = $('#deptcdOrNa',$.pdialog.getCurrent()).val("");
            var usercdOrNa = $('#usercdOrNa',$.pdialog.getCurrent()).val();
            var currentDeptCode =$("#currentDeptCode",$.pdialog.getCurrent());
            currentDeptCode.val(deptcode);
            pageNo=1;
            nScrollTop=0;//重置值
            isAjax=false;
            queryUserByDeptCode(deptcode,usercdOrNa,"");
            //var treeInstance = $.fn.zTree.getZTreeObj("deptTree");
            treeInstance.selectNode(treeNode,false);
            return false;
        },
        onAsyncSuccess:function(event, treeId, treeNode, msg){
        	 var firstRootId=$(msg).find('DataPacket Response Data firstRootId').text();
        	 var  $rootDeptId =$("#rootDeptId",$.pdialog.getCurrent());
        	 $rootDeptId.val(firstRootId);
        }
	}
};

$(function(){
	$selectedUser =$("#selectedUser",$.pdialog.getCurrent());
	$unselectedUser =$("#unselectedUser",$.pdialog.getCurrent());
	if(selectedCode && selectedCode.length>0) {          //初始化 已选中的值
		var defs =selectedCode.split(",");
		for(var i = 0; i < defs.length;i++) {
			selectedArr.push(defs[i]);
		}
	}
	queryUserByUserCode(selectedCode);
	//初始化树
	treeInstance = $.fn.zTree.init($("#deptTree"),deptTreeSetting);
	queryUserByDeptCode("-1","");
    var nDivHight = $("#selectDeptUserTable").parent("div").height();
    $("#selectDeptUserTable").parent("div").scroll(function(){
       nScrollHight = $(this)[0].scrollHeight;
       var currentScrollTop= $(this)[0].scrollTop;
      console.log(nScrollTop + nDivHight-2+"wengdanggaodu"+nScrollHight);
      if(currentScrollTop>nScrollTop){ //向下滑动
    	  nScrollTop=currentScrollTop;
    	  if(nScrollTop + nDivHight -2>= nScrollHight){
    	      //  console.log(nScrollTop + nDivHight-2+"wengdanggaodu"+nScrollHight);
    	        if(!isAjax){
    	          pageNo++;
    	          var deptcdOrNa = $('#deptcdOrNa').val();
    	          var usercdOrNa = $('#usercdOrNa').val();
    	          var currentDeptCode =$("#currentDeptCode",$.pdialog.getCurrent()).val();
    	          //正在加载中
    	          isAjax=true;
    	          queryUserByDeptCode(currentDeptCode,usercdOrNa,deptcdOrNa);
    	        }
    	      }
      }
      });

});

function queryUserByUserCode(usercode) {
	var selectedList = null;
	var url = "/xmlprocesserservlet?"
	    + "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
	    + "&oprID="+'<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>'
	    + "&actions="+'<sc:fmt value='findPcmcUserByUserCodes' type='crypto'/>';
	$.ajax({
	   type: "POST",
	   url: url,
	   dataType: "XML",
	   async:false,
	   data:{
		   usercode:usercode
	   },
	   success: function(data){
		   var selectedListStr = $(data).find("DataPacket Response Data userList").text();
		   selectedList = $.parseJSON(selectedListStr);
		
	   },
	   error:function(){
	       alertMsg.error("数据加载失败！");
	   }
	});
	var selectedHtml = "";
	if(selectedList==null|| selectedList==undefined){
		   return;
	}
	var length=selectedList.length;
	for(var i =0; i < selectedList.length;i++) {
		   var user = selectedList[i];
		   var checkboxVal = "{"+lookupid+":'"+user.userid+"', "+lookupcode+":'"+user.usercode+"', "+lookupname+":'"+user.username+"'}";
		   selectedHtml+='<span style="width: 200px; padding: 2px 5px 2px 0; display: inline-block; overflow: hidden; white-space: nowrap;" title="'+user.username+'">';
		   selectedHtml+='    <label for="selected_'+user.usercode+'"> ';
		   selectedHtml+='       <input type="checkbox" name="selected_userinfo" id="selected_'+user.usercode+'" value="'+checkboxVal+'" />';
		   selectedHtml+='       <span style="color: gray;">'+user.username+'</span>';
		   selectedHtml+='    </label>';
		   selectedHtml+=' </span>';
		   var tempItem = $(selectedHtml).appendTo($selectedUser);
		   selectedHtml = "";
		   for(var j = 0;j < selectedArr.length;j++) {
			   var selectedVal = selectedArr[j];
			   if(user[getColumn]==selectedVal) {
				   tempItem.find("input[name='unselected_userinfo']").click();
				   break;
			   }
		   }
	}
}

function queryUserByDeptCode(deptcode,usercdOrNa,deptcdOrNa) {
	var unselectedList = null;
	var url = "/xmlprocesserservlet?"
        + "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
        + "&oprID="+'<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>'
        + "&actions="+'<sc:fmt value='queryUserByDeptCode' type='crypto'/>';
    $.ajax({
       type: "POST",
       url: url,
       dataType: "XML",
       async:false,
       data:{
    	   deptcode:deptcode,
    	   usercdOrNa:usercdOrNa,
    	   deptcdOrNa:deptcdOrNa,
    	   pageNo:pageNo,
    	   pageSize:pageSize
       },
       success: function(data){
    	   var unselectedListStr = $(data).find("DataPacket Response Data userList").text();
    	   unselectedList = $.parseJSON(unselectedListStr);
    	 /*   if(pageNo>1){
    		   var  $to_top =$("#to_top");
    		   $to_top.css("display","block");
	        }else{
	           $to_top.css("display","none");
	        } */
       },
       error:function(){
           alertMsg.error("数据加载失败！");
       }
    });
   var unselectedHtml = "";
   if(pageNo==1){
     $unselectedUser.empty();
   }
   if(unselectedList==null|| unselectedList==undefined){
	   return;
   }
   var length=unselectedList.length;
   for(var i =0; i < unselectedList.length;i++) {
	   var user = unselectedList[i];
	   var checkboxVal = "{"+lookupid+":'"+user.userid+"', "+lookupcode+":'"+user.usercode+"', "+lookupname+":'"+user.username+"'}";
	   unselectedHtml+='<span style="width: 48%; padding: 2px 5px 2px 0; display: inline-block; overflow: hidden; white-space: nowrap;" title="'+user.username+'">';
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
   if(length==pageSize){
     isAjax=false;
   }else if(length<pageSize){//已经加载完毕
	 isAjax=true;
	 console.log("到达最后一页没有数据啦");
   }else{
	   
   }
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
	}else if(!$(this).attr("checked")){
		$selectedUser.find("#"+$(this).attr("id").substring(2)).attr("checked",false);
		$selectedUser.find("#"+$(this).attr("id").substring(2)).closest("span").remove();
	}
}

function delFromSelected() {
	if(!$(this).attr("checked")){
		$unselectedUser.find("#un"+$(this).attr("id")).attr("checked",false);
		$(this).closest("span").remove();
	}
}
function searchDept(){
	 //重置变量
    pageNo=1;
    nScrollTop=0;
    isAjax=false;
    //为了获取机构编码和行员编码值
    var deptcdOrNa = $('#deptcdOrNa').val();
    var usercdOrNa = $('#usercdOrNa').val();
    if(deptcdOrNa != null && deptcdOrNa != ""){
    	// 根据节点名称模糊查询机构树
        treeInstance.cancelSelectedNode();
        var nodes = treeInstance.getNodesByParamFuzzy("name", deptcdOrNa);
        if (nodes != "" && nodes != null) {
            // 循环节点，并展开
            for( var i=0, l=nodes.length; i<l; i++) {
             //   treeInstance.expandNode(nodes[i],true);
                treeInstance.selectNode(nodes[i],true);
                deptcd=nodes[i].name.substr(1,nodes[i].name.indexOf("]")-1);
               queryUserByDeptCode(deptcd,usercdOrNa,deptcdOrNa);
            }
        } else {
          //  alertMsg.info("未找到机构："+deptcdOrNa);
         //  var deptCode=getOrgSeqByCodeorName(deptcdOrNa);
           queryUserByDeptCode("",usercdOrNa,deptcdOrNa);
        }
    }else{    	
    	 treeInstance.cancelSelectedNode();
    	// queryUserByDeptCode("",usercdOrNa,deptcdOrNa);
    }
    queryUserByDeptCode("",usercdOrNa,deptcdOrNa);
    return false;
}
function toTop(){
	//回到顶部暂时没用
	 $("#selectDeptUserTable").parent("div").animate({scrollTop: 0}, 300);
}
//标记父节点
var node_parent=null;
var isAjaxing=false;
function expand(deptId,i) {
	   treeInstance.cancelSelectedNode();
	   var node;
	   if(i==1){
           node = treeInstance.getNodesByParam("id",deptId,node_parent);
	   }else{
		   node = treeInstance.getNodesByParamFuzzy("name",deptId,node_parent);
	   }
	
	    if(i==-1){
		   treeInstance.selectNode(node[0],true);
	    }else{
		   treeInstance.expandNode(node[0], true, false, false);
	   }
	    node_parent=node[0];
}
function getOrgSeqByCodeorName(deptcdOrNa){
	var url = "/xmlprocesserservlet?"
        + "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
        + "&oprID="+'<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>'
        + "&actions="+'<sc:fmt value='getPcmcDeptByDeptNameOrCode' type='crypto'/>';
    $.ajax({
       type: "POST",
       url: url,
       dataType: "XML",
       async:false,
       data:{
    	   deptcdOrNa:deptcdOrNa
       },
       success: function(data){
    	  var deptSearch=$.parseJSON($(data).find("DataPacket Response Data jsonDataStr").text());
    	  for(var j=0;j<deptSearch.length;j++){
    	  var deptCodeArray= deptSearch[j].orgseq.split(".");
    	  if(deptCodeArray!=null){
    		  for(var i=1;i<deptCodeArray.length-1;i++){
    			var deptCodeStr= deptCodeArray[i];
    			  if(i==deptCodeArray.length-2){
    				  i=-1;//表示最后一级
    			  }
    			  expand(deptCodeStr,i);
        	  }
    	  }
    	 }
       },
       error:function(){
           alertMsg.error("数据加载失败！");
       }
  });
}
</script>
