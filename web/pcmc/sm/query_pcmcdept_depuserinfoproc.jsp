<%--[addBrchUser:新增用户;updateBrchUser:更新用户;deleteBrchUser:删除用户]--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <%@ include file="/common.jsp" %>
</head>
<body>
<div id="div">
   <sc:form name="query_form" action="/pcmc/sm/query_pcmcdept_depuserinfoproc.so" method="post" sysName="pcmc" oprID="sm_query" actions="getDeptUsers" attributesText="onSubmit='return checkForm(this);'">
		<sc:hidden name="deptid" value='${param.deptid}'/>
		<table class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0">
		    <tr><th colspan="4">查询条件</th></tr>
			<tr>
				<sc:text dsp="td" name="usercode" dspName="用户编号" req="0"/>
				<sc:text dsp="td" name="username" dspName="用户名称"/>
			</tr>
			<tr>
			     <td colspan="4" class="form-bottom" align="center">
			         <sc:button value="查询" onclick="doSearch();" name="dosubmit"/>
			     </td>
			</tr>
		</table>
	</sc:form>
	<div class="page-title" style="margin:0px;"><span id="pageTitleId" class="title">查询结果</span>
		<sc:form name="page_form" method="post" action="/pcmc/sm/query_pcmcdept_depuserinfoproc.so" sysName="pcmc" oprID="sm_query" actions="getDeptUsers" attributesText="onSubmit='return checkForm(this);'">
	      <sc:hidden name="deptid" value='${param.deptid}'/>
	       <display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet"
	                      sort="list">
	            <display:column  title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
                    <input type="checkbox" name="userid" onclick="outlineMyRow(this)" value='${record.userid }'/>
                    <input type="hidden" name="myusercode" onclick="outlineMyRow(this)" value='${record.usercode }'/>
                    <input type="hidden" name="mydeptid" onclick="outlineMyRow(this)" value='${record.deptid }'/>
		        </display:column>
	            <display:column property="usercode" title="用户编号"/>
	            <display:column property="username" title="用户名称"/>
	            <display:column property="phone" title="联系电话" />
	            <display:column property="email" title="电子邮件" />
	            <display:footer>
	     			<tr>
	                   <td colspan="6">
	                       <div class="operator" >
			                   <input type="button" class="add"    value="新增" _jraf_sys_usersync id="addBrchUser" onclick="toAdd();"/>
			                   <input type="button" class="edit"   value="修改" id="updateBrchUser" onclick="toEdit();"/>
			                   <input type="button" class="delete" value="删除" _jraf_sys_usersync id="deleteBrchUser" onclick="doDelete();"/>
			               </div>
			               <%@ include file="/include/pager.jsp" %>
	                   </td>
	               </tr>
	            </display:footer>
	        </display:table>
</sc:form>
</div>
</div>
</body>
<script type="text/javascript" defer="defer">
var deptname='';
if(parent.g_deptname!=null){
deptname =parent.g_deptname;
}
setHeightAuto();
function doSearch()
{   
	var formObj = document.forms["query_form"];
	if(!checkForm(formObj)){
	    return false;
	}
	formObj.oprID.value='<sc:fmt type="crypto" value="sm_query"/>';
	formObj.actions.value='<sc:fmt type="crypto" value="getDeptUsers"/>';
	formObj.elements("dosubmit").disabled=true;
	formObj.submit();
	formObj.elements("dosubmit").disabled=false;
}
function toAdd()
{
	var deptid = $$("input[name='deptid']")[0].value; 
	if(deptid == ''){
	  alert("请先添加机构");
	  return;
	}
	var	nodetype = 'childnode';
	var url = '/pcmc/sm/OrgUserAdd.jsp?editFlag=false&deptid='+deptid+'&exitButtonShow=true'+'&deptname='+encodeURI(encodeURI(deptname)) + "&ts_date=" + new Date();;
	var winResults = openModal(url,800,500);
    if (winResults != null) {
       var formObj = document.forms["query_form"];
       formObj.elements("usercode").value = winResults["usercode"];
       formObj.elements("username").value = winResults["username"];
       var usercode = winResults["usercode"];
       var username = winResults["username"];
       var userid = winResults["userid"];
       var item={
					name:		username+'['+usercode+']',
					key:		'nu'+userid,
					pkey:		'n'+deptid,
					onClick:	window.parent.viewItem,
					onRightClick: 	window.parent.addRightMenu,//右击
					tag: 			{usercode:usercode,username:username,deptid:deptid,pdeptid:deptid,nodetype:nodetype,userid:userid}
				};
		var nNode=window.parent.jraftreemenu.addNode(item);
	    nNode.parent.expand(true);
	    
	    var results = {
	                deptcode: usercode,
	                deptname: username,
	                nodetype: "childnode",
	                deptid: userid,
	                pdeptid:deptid
	            };
	     window.returnValue = results;
         doSearch();
    }
}


function toEdit()
{
    var obj = $$("input[name='userid']");
    var myusercode;
    var mydeptid;
	var count = 0;
	var usercode = "";
	var deptid = "";
    for(var i = 0 ; i < obj.length; i ++ ){
    	if(obj[i].checked == true){
    		count ++;
    		myusercode = $$("input[name='myusercode']")[i].value;
    		mydeptid  = $$("input[name='mydeptid']")[i].value;
    	}
    }
    if(count != 1){
		Jraf.showMessageBox({text: "<span class='info'>" + "请选择一条数据" + "</span>"});
    }else{
    	var userid = document.getElementsByName("userid");
    	var usr=new Array();
		for(var i=0;i<userid.length;i++)
		{
		 if(userid[i].checked)
		 {
		   usr[usr.length]=userid[i].value;
		 }
		}
		var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="sm_query"/>&actions=<sc:fmt type="crypto" value="getUserList"/>&forward=<sc:fmt value='/pcmc/sm/OrgUserAdd.jsp' type='crypto'/>&exitButtonShow=true&editFlag=true&usercode='+myusercode+'&deptid='+mydeptid+'&userid='+usr[0]+'&dt='+new Date();
		var winResults = openModal(url,800,500);
		if (winResults != null) {
			doSearch();
	    var usercode = winResults["usercode"];
	    var username = winResults["username"];
	    var key = 'nu'+usr[0];
		var node= window.parent.jraftreemenu.treeContext.nodes[key];
		if(!node) return;
		node.label.innerHTML=username+'['+usercode+']';
	    Object.extend(node.tag,{deptid:usr[0],usercode:usercode,username:username});
	    
	  }
    }
}

function doDelete()
{
	var ajax = new Jraf.Ajax();
	var usr = document.getElementsByName("userid");
	var userid=new Array();
	
	for(var i=0;i<usr.length;i++)
	{
		 if(usr[i].checked)
		 {
		   userid[userid.length]=usr[i].value;
		 }
	}
	if(userid.length==0){
	 Jraf.showMessageBox({
                    text: '<span class="info">请选择要删除的用户！\n' + '</span>'
                });
                return;
	}
	if (!confirm("您确认要删除该用户吗？"))
	{
		return;
	}
	  var reqparams = {
			sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
			oprID: 		'<sc:fmt type="crypto" value="sm_maintenance"/>',
			actions:	'<sc:fmt type="crypto" value="deleteUser"/>',
			userid:		userid
			};
	ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
			try{
			var pkg = new Jraf.Pkg(xml);
	   		if(pkg.result()!= '0'){
                Jraf.showMessageBox({
                    text: '<span class="error">删除出错！\n'+pkg.allMsgs() + '</span>'
                });
                return;
            }
             Jraf.showMessageBox({
                text: '<span class="success">删除成功！</span>'
            });
            
            /*删除节点*/
             for(var i=0;i<userid.length;i++){
          	 var key = 'nu'+userid[i];
			 var node= window.parent.jraftreemenu.treeContext.nodes[key];
			 node.remove();
	        }
	         doSearch();
	         window.parent.refresh();
			}catch(e)
			{
				alert('ERROR:'+e);
			}
	});
}
function setHeightAuto() {
	parent.$("dept_userinfo").setStyle({height: ($("div").getHeight()) + "px"});
	//parent.$("dept_userinfo").setStyle({width: ($("div").getWidth()) + "px"});
}
</script>
<%@include file="/common_priv_usersync.jsp" %>
</html>
