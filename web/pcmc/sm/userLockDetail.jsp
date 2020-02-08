<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@include file="/common.jsp" %>
<script type="text/javascript" src="/workflow/common/common_wf.js"></script>
</head>
<body style="padding: 0 5px">
		<!-- 查询面板 -->
	<sc:form action="/pcmc/sm/userLockList.so" forward="/pcmc/sm/userLockDetail.jsp" oprID="smUserLock" 
	sysName="pcmc" name="query_form" actions="getUserLockedList" method="post">
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
    		<tr><th colspan="2">查询条件</th></tr>
    		<tr>   	 
    			<sc:text name="rolename" dspName="用户名或账号" dsp="td" />
    		</tr>
    		<tr>
			     <td colspan="2" class="form-bottom" align="center">
			      	<sc:button value="查询" onclick="doSearch();"/>
			     	<sc:button value="重置" onclick="reSet();"/>
			     </td>
			</tr>
		</table>
	</sc:form>
        <div class="page-title" style="margin:0px;" id="userList">
            <span id="workflowpageTitleId" class="title">已锁定用户 </span>
            <div id='shetlist' >
                 <div id ="userLockList_div"
                       jraf_pageid="userLockList_div" 
                       jraf_url="/pcmc/sm/userLockList.so"
                       jraf_sysName="<sc:fmt value='pcmc' type='crypto'/>"
                       jraf_oprID="<sc:fmt value='smUserLock' type='crypto'/>"
                       jraf_actions="<sc:fmt value='getUserLockedList' type='crypto'/>"
                       jraf_params=""
                       jraf_callback="">
                 </div>
            </div>         
        </div>


</body>
<script type="text/javascript">
var g_oLoadPageTo = null;
var g_winHeight = null;
var g_r_winHeight = null;
var g_workflowinfoid =null;
/*
 * 页面加载完成后加载方法
 */
document.observe("dom:loaded", function () {
	//初始化数据
    initData();
});

/*
 * 页面加载完成后，查询数据给页面
 */
function initData(){
    new Jraf.DimensionsAuto(window, "#userList", "height", 0);
    g_winHeight =  $("userList").getHeight();//window.document.documentElement.offsetHeight;
    g_oLoadPageTo = new Jraf.LoadPageTo();
    g_oLoadPageTo.doLoad('userLockList_div');
}

/*
 * 重置查询条件
 */
function reSet(){
	document.getElementsByName("rolename")[0].value="";
}

/*
 * 查询js方法
 */
function doSearch()
{
	var rolename = document.getElementsByName('rolename')[0].value;
	//jraf标签重新复制，再次加载div
	var load_div = document.getElementById("userLockList_div");
	load_div.setAttribute("jraf_actions",
			"<sc:fmt value='getUserLockedList' type='crypto'/>");
	load_div.setAttribute("jraf_params","rolename="+rolename);
	//再次加载div
	new Jraf.LoadPageTo().doLoad("userLockList_div");
			
}

/*
 * 跳转到锁定用户登录信息页面
 */
function toGetUserLoginList(userid){
	var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>'+
	'&oprID=<sc:fmt type="crypto" value="smUserLock"/>'+
	'&actions=<sc:fmt type="crypto" value="getAllUserLoginByUserId"/>'+
	'&forward=<sc:fmt value='/pcmc/sm/userloginlist.jsp' type='crypto'/>&userid='+userid;
	//打开弹出窗
	var rsgpid = openModalToIframe(url,null,800, 400);
}

/*
 * 执行解除用户锁定操作
 */
function toUnlockUser(userid)
{
	var param = {
		    sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
		    oprID:      '<sc:fmt type="crypto" value="smUserLock"/>',
		    actions:    '<sc:fmt type="crypto" value="doUnLockUser"/>',
		    action:    '<sc:fmt type="crypto" value="/pcmc/sm/userLockList.so"/>',
		    forward:	'<sc:fmt type="crypto" value="/pcmc/sm/userLockDetail.jsp"/>',
		    userid:     userid
		};
		var ajax = new Jraf.Ajax();
		ajax.sendForXml('/xmlprocesserservlet', param, function(xml){
		        try{
		            var pkg = new Jraf.Pkg(xml);
		            if(pkg.result() != '0'){
			            Jraf.showMessageBox({title: "解锁用户出现异常", text: "<span class='error'>" + '异常：' + pkg.allMsgs('<br>') + "</span>"});
		                return;
		            }
		            else{
		            	Jraf.showMessageBox({title: "提示成功", text: "<span class='info'>" + '解锁用户成功！' + "</span>", 
		            		onOk: function(){
		            			//再次加载div
		            		    new Jraf.LoadPageTo().doLoad("userLockList_div");
		            		}});	
		            }
		        }catch(e){
				Jraf.showMessageBox({title: "解锁用户出现异常", text: "<span class='error'>" + e + "</span>"});
			}
		});
		
}

</script>
</html>
