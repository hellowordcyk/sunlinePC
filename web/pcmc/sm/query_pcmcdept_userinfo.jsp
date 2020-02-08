<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
   <%@ include file="/common.jsp" %>
 
<div id="tab">
    <ul id="menus-tab">
        <li targetid="userinfo">用户信息</li>
        <li targetid="user_grant_tab_id" >用户资源授权</li>
    </ul>
    <div class="content" id="userinfo" style="height:400px;"></div>
    <div class="content" id="user_grant_tab_id" style="height:400px;"></div>
    
</div>
<script  type="text/javascript" defer="defer">

var windowInfo = null;
/* 初始化界面 */
var g_windowHeight = null;
var g_resctp = null;
var g_subsys = null;
var g_rsgpid = null;
var g_oTab = null;

document.observe("dom:loaded", function () {
	g_oTab = new Jraf.NewTabs("menus-tab");
	windowInfo = new Jraf.Dimensions();
	g_windowHeight =  windowInfo.getHeight();
});


	function initRoot(){
			rootAction();
		}
		
	function rootAction(){
	 var parserTab = new Jraf.Tabs({
		 tabid:"menus-tab",
		 displayStyle:"div",
		 displayID:{userinfo: 'userinfo',user_grant_tab_id:"user_grant_tab_id"},
	     globalRefresh:  true
	});
    var param1 = {
           sysName:    "<sc:fmt value='pcmc' type='crypto'/>",
           oprID:      "<sc:fmt value='sm_query' type='crypto'/>",
           actions:    "<sc:fmt value='getUserInfo' type='crypto'/>",
           url:        "/pcmc/sm/OrgUserAdd.so",
           editFlag:	true,
           exitButtonShow: false,
           deptid:     '${param.deptid}',
           userid:     '${param.userid}',
           usercode:   '${param.usercode}'
    };     
    var param2 = {
            sysName:    "<sc:fmt value='bdss' type='crypto'/>",
            oprID:      "<sc:fmt value='bdss_resc_grant' type='crypto'/>",
            actions:    "<sc:fmt value='queryUserRescList' type='crypto'/>",
	        url:        "/bdss/resource/manager_user_grant_resc.jsp",
            editFlag:	true,
            exitButtonShow: false,
            deptid:     '${param.deptid}',
            userId:     '${param.userid}',
            userCode:	'${param.usercode}'
     };     
    parserTab.addAction(1, param1);
    parserTab.addAction(2, param2);
	parserTab.init(1);
	
}
initRoot();

/******************************第三个tab页面js代码**********************************/

/**
 * 查询用户已授权资源
 */
function queryUserGrantResc(){
	var userIdObj = document.getElementsByName("userId")[0];
	var userCodeObj = document.getElementById("userCodeId");
	if(userIdObj.value == null || userIdObj.value == "" ){
		hint_alert(userCodeObj,"请从下拉框中选择一个，下拉框能根据您的输入模糊查询数据！");
		return ;
	}
	
	var oLoadPageTo = new Jraf.LoadPageTo();
	oLoadPageTo.doLoad("user_resc_list_id");
}

function initUserGrantData(){
	oShetDivSlct = new Jraf.DivSlct({
	    selector:       "userCodeId", //id
	    queryParams:  {
	        sysName:    "<sc:fmt value='bdss' type='crypto'/>",
	        oprID:      "<sc:fmt value='bdss_resc_grant' type='crypto'/>",
	        actions:    "<sc:fmt value='queryUserListLike' type='crypto'/>",
	        likefq:     "true"
	    },
	    optionKeyName: "usercd",
	    optionLabelName: "userna",
	    optionParamsName: "userid",
	    doOthersAfterSel: function(params){
	    	//alert($H(params).inspect())
	    	document.getElementsByName("userId")[0].value = params.userid;
	    	var userCodeObj = document.getElementById('userCodeId');
	    	userCodeObj.disabled = true;
	    	userCodeObj.value = params.userna;
	    	//添加修改按钮
	    	document.getElementById("user_edit_id").style.display = "";
	    }
	});
}

function doAfterLoad_user_resc_list_id(){
	var search_div_height = $('user_resc_query_div').getHeight();
	var span_title_height = $('span_titile').getHeight();
	// tab 60 间隙 15
/*
	new Jraf.ReTable({
        selector: "#user_resc_record_id", 
        titleTabObj: null,
        height: g_windowHeight-search_div_height-span_title_height -75,
        tableOffsetW: 70
   });
*/
}


function editUserCode(){
	var userCodeObj = document.getElementById('userCodeId');
	userCodeObj.value='';
	userCodeObj.disabled = false;
	document.getElementsByName("userId")[0].value="";
	document.getElementById("user_edit_id").style.display = "none";
	var jarfDivObj = document.getElementById('user_resc_list_id');
	var divInnerHTML = document.getElementById('display_div_id').innerHTML;
	if(jarfDivObj != null){
		jarfDivObj.innerHTML = divInnerHTML;
	}
	userCodeObj.focus();
}


function addUserPrivResc(){
	var userCode = document.getElementById('userCodeId').value;
	var userid = document.getElementsByName("userId")[0].value;
	var subsysId = document.getElementsByName("subsysId")[0].value;
    var resctp  = document.getElementsByName("resctp")[0].value;
    userCode = encodeURI(encodeURI(userCode));
	url='/bdss/resource/query_user_ungrant_resc.jsp?flag=1&userid='+userid+'&userCode='+userCode+'&scgptp='+1+"&subsys="+subsysId+"&resctp="+resctp;;
	var rescList = openModalToIframe(url,null,700,500);
	//添加授权信息
	if(rescList == null || rescList.length == 0){
		return;
	}
	addUserGrantRescource(rescList,userid,1);
	
}

function addUserPrivGroup(){
	var userCode = document.getElementById('userCodeId').value;
	userCode = encodeURI(encodeURI(userCode)); 
	var userobj = document.getElementsByName("userId")[0];
	var subsysId = document.getElementsByName("subsysId")[0].value;
    var resctp  = document.getElementsByName("resctp")[0].value;
	var userid = userobj.value;
	if(userid == null || userid ==""){
		hint_alert(userobj,"请从下拉框中选择一个，下拉框能根据您的输入模糊查询数据！");
		return ;
	}
	url='/bdss/resource/query_user_ungrant_resc.jsp?flag=1&userid='+userid+'&userCode='+userCode+'&scgptp='+2+"&subsys="+subsysId+"&resctp="+resctp;
	var rescList = openModalToIframe(url,null,700,500);
	//添加授权信息
	if(rescList == null || rescList.length == 0){
		return;
	}
	addUserGrantRescource(rescList,userid,2);
	
}
/**
 * 添加用户资源授权信息
 */
function addUserGrantRescource(rescAry,userid,scgptp){
	var reqparams = {
			sysName:	'<sc:fmt type="crypto" value="bdss"/>',
			oprID: 		'<sc:fmt type="crypto" value="bdss_resc_grant"/>',
			actions:	'<sc:fmt type="crypto" value="addUserGrantResource"/>',
			userid: 	userid,
			rescid:		rescAry,
			scgptp:		scgptp
	};
	var ajax = new Jraf.Ajax();
	ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
	try{
		   	var pkg = new Jraf.Pkg(xml);
		   	if(pkg.result() != '0'){
		          Jraf.showMessageBox({
		          	text: pkg.allMsgs(),
		          	type: 'error'
		           });
		           return;
		    }
		   	Jraf.showMessageBox({
	          	text: "资源授权成功",
	          	type: 'success'
	 		 });
			queryUserGrantResc();
	}catch(e){alert('sendForXml,ERROR:'+e);}
	});
}


function deleteUserPrivResc(){
	var radioAry = document.getElementsByName('rsprid');
	var rsprAry = new Array();
	for(var i=0;i<radioAry.length;i++){
	  if(radioAry[i].checked == true){
	    rsprAry[rsprAry.length] = radioAry[i].value;
	  }
	}
	if(rsprAry == null || rsprAry.length ==0){
		Jraf.showMessageBox({
          	text: '请至少选择一条数据！',
          	type: 'warn'
        });
		return;
	}
	var reqparams = {
			sysName:	'<sc:fmt type="crypto" value="bdss"/>',
			oprID: 		'<sc:fmt type="crypto" value="bdss_resc_grant"/>',
			actions:	'<sc:fmt type="crypto" value="deleteUserGrantResource"/>',
			rsprid:		rsprAry
	};
	var ajax = new Jraf.Ajax();
	ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
	try{
		   	var pkg = new Jraf.Pkg(xml);
		   	if(pkg.result() != '0'){
		          Jraf.showMessageBox({
		          	text: pkg.allMsgs(),
		          	type: 'error'
		           });
		           return;
		    }
		   	Jraf.showMessageBox({
	          	text: "资源授权信息删除成功",
	          	type: 'success'
	  		});
		   	queryUserGrantResc();
	}catch(e){alert('sendForXml,ERROR:'+e);}
	});
}
function getParams(){
    return Form.serialize(document.forms('query_form'));
}
</script>	    
</html>
