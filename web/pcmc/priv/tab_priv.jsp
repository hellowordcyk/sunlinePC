<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/common.jsp" %>
</head>
<body>
<div id="tab">
<!--
			<ul id="menus-tab">
				<li targetid="mangerRole">角色管理</li>
				<li targetid="role_grant_tab_id">角色资源授权</li>
  		    <li targetid="mangerPriv">权限配置</li>
		        <li targetid="grantPriv">权限功能授权</li>

		    </ul>
		    <div class="content" id="mangerRole" ></div>
		    <div class="content" id="role_grant_tab_id" ></div>
		    <div class="content" id="mangerPriv" ></div>
		    <div class="content" id="grantPriv" ></div>-->
	<ul id="menus-tab">
		<li jraf_tabid="mangerRole"
			jraf_onAfterClick=""     
	        jraf_url="/pcmc/priv/iframe_managerRole.jsp">角色管理</li>
		<li jraf_tabid="role_grant_tab_id"    
     	 	jraf_onAfterClick="initRoleGrantData()"      
         	jraf_url="/bdss/resource/manager_role_grant_resc.jsp">角色资源授权</li>
	</ul>
</div>
</body> 
<script language="javascript" defer="defer">
//var parserTab = new Jraf.Tabs({
//	tabid:			"menus-tab",
//	displayStyle:	"div",
//	displayID:{mangerRole: 'mangerRole',role_grant_tab_id:"role_grant_tab_id"},
//	displayID:{mangerRole: 'mangerRole',mangerPriv: 'mangerPriv', grantPriv: 'grantPriv'},
//	globalRefresh:  false   // 是否清空其他页签面板标志
//}); 
//init();
/* 初始化界面 */

function init(){
//	 new Jraf.DimensionsAuto(window, '#tab', 'height', 0);
//	parserTab.addAction(1, {url: '/pcmc/priv/iframe_managerRole.jsp'});
//	parserTab.addAction(2, {url: '/bdss/resource/manager_role_grant_resc.jsp'});
//	parserTab.addAction(2, {url: '/pcmc/priv/iframe_managerPriv.jsp'});
//	parserTab.addAction(3, {url: '/pcmc/priv/iframe_grantPriv.jsp'});
//	parserTab.init(1);
	 var menusTabH = $("menus-tab").getHeight() -2;
	 var tabH = $("tab").getHeight() -2;
     $$(".content").each(function (obj) {
         obj.setStyle({height: (tabH - menusTabH) +"px"});
     });
};





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
		$$(".content").each(function (obj) {
	         obj.setStyle({height: 408 +"px"});
	     });
	});

/******************************第四个tab页面js代码结束*******************************/
/**
 * 查询用户已授权资源
 */
function queryRoleGrantResc(){
	var roleIdObj = document.getElementsByName("roleId")[0];
	var roleCodeObj = document.getElementById("roleCodeId");
	if(roleIdObj.value == null || roleIdObj.value == "" ){
		hint_alert(roleCodeObj,"请从下拉框中选择一个，下拉框能根据您的输入模糊查询数据！");
		return ;
	}
	var oLoadPageTo = new Jraf.LoadPageTo();
	oLoadPageTo.doLoad("role_resc_list_id");
}

function initRoleGrantData(){
	oShetDivSlct = new Jraf.DivSlct({
	    selector:       "roleCodeId", //id
	    queryParams:  {
	        sysName:    "<sc:fmt value='bdss' type='crypto'/>",
	        oprID:      "<sc:fmt value='bdss_resc_grant' type='crypto'/>",
	        actions:    "<sc:fmt value='queryRoleListLike' type='crypto'/>",
	        likefq:     "true"
	    },
	    optionKeyName: "roleid",
	    optionLabelName: "rolename",
	    /* optionParamsName: "roleid", */
	    doOthersAfterSel: function(params){
	    	document.getElementsByName("roleId")[0].value = params.roleid;
	    	document.getElementsByName("rolename")[0].value = params.rolename;
	    	var roleCodeObj = document.getElementById('roleCodeId');
	    	roleCodeObj.disabled = true;
	    	roleCodeObj.value = params.rolename;
	    	//添加修改按钮
	    	document.getElementById("role_edit_id").style.display = "";
	    }
	});
}
function getRoleParams(){
	return Form.serialize(document.forms('role_query_form'));
}
function editRoleCode(){
	var userCodeObj = document.getElementById('roleCodeId');
	userCodeObj.value='';
	userCodeObj.disabled = false;
	document.getElementsByName("roleId")[0].value="";
	document.getElementsByName("rolename")[0].value = "";
	document.getElementById("role_edit_id").style.display = "none";
	var jarfDivObj = document.getElementById('role_resc_list_id');
	var divInnerHTML = document.getElementById('role_display_div_id').innerHTML;
	if(jarfDivObj!= null){
		jarfDivObj.innerHTML = divInnerHTML;
	}

}

function addRolePrivResc(){
	var roleObj = document.getElementsByName("roleId")[0];
	var roleid = roleObj.value;
	if(roleid == null || roleid ==""){
		hint_alert(roleObj,"请从下拉框中选择一个，下拉框能根据您的输入模糊查询数据！");
		return ;
	}
	var rolename = document.getElementsByName("rolename")[0].value;
	var subsysId = document.getElementsByName("subsysId")[0].value;
    var resctp  = document.getElementsByName("resctp")[0].value;
	url='/bdss/resource/query_role_ungrant_resc.jsp?flag=1&roleid='+roleid+'&rolename='+encodeURI(encodeURI(rolename))+'&scgptp='+1+"&subsys="+subsysId+"&resctp="+resctp;
	var rescList = openModalToIframe(url,null,700,500);
	//添加授权信息
	if(rescList == null || rescList.length == 0){
		return;
	}
	addRoleGrantRescource(rescList,roleid,1);
	
}

function addRolePrivGroup(){
	var roleObj = document.getElementsByName("roleId")[0];
	var roleid = roleObj.value;
	if(roleid == null || roleid ==""){
		hint_alert(roleObj,"请从下拉框中选择一个，下拉框能根据您的输入模糊查询数据！");
		return ;
	}
	var rolename = document.getElementsByName("rolename")[0].value;
	var subsysId = document.getElementsByName("subsysId")[0].value;
    var resctp  = document.getElementsByName("resctp")[0].value;
	url='/bdss/resource/query_role_ungrant_resc.jsp?flag=1&roleid='+roleid+'&rolename='+encodeURI(encodeURI(rolename))+'&scgptp='+2+"&subsys="+subsysId+"&resctp="+resctp;
	var rescList = openModalToIframe(url,null,700,500);
	//添加授权信息
	if(rescList == null || rescList.length == 0){
		return;
	}
	addRoleGrantRescource(rescList,roleid,2);
	
}


function deleteRolePrivResc(){
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
		   	queryRoleGrantResc();
	}catch(e){alert('sendForXml,ERROR:'+e);}
	});
}
/**
 * 添加用户资源授权信息
 */
function addRoleGrantRescource(rescAry,roleid,scgptp){
	var reqparams = {
			sysName:	'<sc:fmt type="crypto" value="bdss"/>',
			oprID: 		'<sc:fmt type="crypto" value="bdss_resc_grant"/>',
			actions:	'<sc:fmt type="crypto" value="addRoleGrantResource"/>',
			roleid: 	roleid,
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
			queryRoleGrantResc();
	}catch(e){alert('sendForXml,ERROR:'+e);}
	});
}

function doAfterLoad_role_resc_list_id(){
	var search_div_height = $('role_resc_query_div').getHeight();
	var span_title_height = $('span_titile').getHeight();
	// tab 60 间隙 15
	new Jraf.ReTable({
        selector: "#role_resc_record_id", 
        titleTabObj: null,
        height: g_windowHeight-search_div_height-span_title_height -75,
        tableOffsetW: 70
   });
}
</script>
</html>