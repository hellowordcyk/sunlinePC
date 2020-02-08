<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.util.ITEMS"%>
<%@ page import="com.sunline.bimis.pcmc.util.DeptUtil"%>
<% request.setCharacterEncoding("UTF-8"); %>

<html>
<head>
	<title>写短消息</title>
	<link href="/css/style.css" type="text/css" rel="stylesheet">
	<style>
	    body,td{ font-size: 9pt;  }
	    .clsNoExpand { list-style-image: url('/images/solid.gif'); }
	    .clsItemShow { list-style-image:url('/images/treenode_minus.gif'); cursor: hand; font-family: "Arial", "Helvetica", "sans-serif"; font-size: 12px; font-weight: normal; color: #000080; background-color: #eff0f1; line-height: 5mm }
	    .clsItemHide { list-style-image:url('/images/treenode_plus.gif'); cursor: hand; font-family: "Arial", "Helvetica", "sans-serif"; font-size: 12px; font-weight: normal; color: #000080; background-color: #eff0f1; line-height: 5mm }
	    .clsItemsShow1 { list-style-image:url('/images/treenode_solid.gif');font-family: "Arial", "Helvetica", "sans-serif"; font-size: 12px; font-weight: normal; color: #000080; background-color: #eff0f1; line-height: 5mm }
	    ul.clsItemsShow { list-style-image:url('/images/treenode_solid.gif');font-family: "Arial", "Helvetica", "sans-serif"; font-size: 12px; font-weight: normal; color: #000080; background-color: #eff0f1; line-height: 5mm }
	    ul.clsItemsHide { display:none;  }
	</style>
</head>

<body background="/images/background.gif"
	style="border-right: medium none; border-top: medium none; margin: 0px; 
	border-left: medium none; border-bottom: medium none"
	oncopy="return false;" bgColor=#FFFFFF>
<%@ include file="/public/checkLogin.jsp"%>

<form  name="frmcog" action="/httpprocesserservlet" method="post">
<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
<input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
<input type="hidden" name="actions" value="<sc:fmt value='addMessage' type='crypto'/>">
<input type="hidden" name="isread" value="1">
<input type="hidden" name="forward" value="/httpprocesserservlet?sysNam=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMessageList' type='crypto'/>&forward=<sc:fmt value='/pcmc/pm/messagelist.jsp' type='crypto'/>">

<table border=0 cellSpacing=0 cellPadding=0 align="center" width="99%">
	<tr>
		<td valign=top width="100%">
			<fieldset>
				<legend>
					<table border=0 cellSpacing=0 cellPadding=0 width=100 bgColor="#E0F0F0">
						<tr>
							<td style="padding-top: 2px" align="center" background="/images/login_title_bg.gif" height=18>
								<font color="#FFFFFF">短消息服务</font>
							</td>
						</tr>
					</table>
				</legend>
				
				<table width="100%" border=0 align="center" cellpadding=4 cellspacing=0>
					<tr>	
				    		<td>
							<table width="100%" border=0 cellpadding="0" cellspacing=0 bgcolor="#EFF0F1">
								<tr width="100%">
									<td width="100%" background="/images/navigation_ico_2.gif" class="navigation">
										<table width="100%" border=0 cellpadding=2 cellspacing=0>
											<tr>
												<td width="100%">&nbsp;<font color="#FFFFFF">写短消息</font></td>
											</tr>
										</table>
									</td>
								</tr>
				        			<tr>
				        				<td>
										<table border=0 width="100%" height="4" cellspacing="1" class="DefaultTable">
											<tr class="sysdisplay">
												<td width="20%" align=right><font color="red">*</font>标题：</td>
												<td class="fieldname">
													<input type="text" name="title" class="inputtext" size="110" req="1" displayname="标题">
												</td>
											</tr>
											<tr>
												<td width="20%" align=right><font color="red">*</font>接收人：</td>
												<td>
													<input type="hidden" name="targetuser" readonly class="inputtext"  req="1" displayname="接收人">
													<textarea name="targetusername" rows="2" cols="95"></textarea>
													<img src="../../images/pic01/sel_person.gif" border=0 align="absmiddle" style="cursor: hand" onClick="javascript:getPerson_people();">															
											</td>
											</tr>	
											<tr class="sysdisplay">
												<td width="20%" align=right>内容：</td>
												<td class="fieldname"><textarea name="content" rows="8" cols="95"></textarea></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</fieldset>
		</td>
	</tr>
</table>
<table width="100%">
    <tr>
        <td align="center">
        <input type="button" class=btn name="save" value="发送" onclick="saveOk();">&nbsp;&nbsp;
        <input type="button" class=btn value="返回" onclick="history.go(-1);">
        </td>
    </tr>
</table>

</form>
</body>
</html>

<script src="/js/form.js" language="JavaScript"></script>
<script language="JavaScript" src="/js/openW.js"></script>
<script src="/js/VBScript/translate.vbs" language="VBScript"></script>
<script src="/js/checkValid.js" language="JavaScript"></script>
<script src="/js/checkForm.js" language="JavaScript"></script>
<Script language="JavaScript">
function saveOk()
{
    if (!checkForm(document.forms[0]))
    {
        return false;
    }
    document.forms[0].submit();
}

function getPerson_people()
{
	var tmp1 = document.frmcog.targetuser.value;
	var tmp= document.frmcog.targetusername.value;
	var urlStr = '/oams/public/pbSelPerson.jsp?deptid=&receiveuser='+tmp+'&receiveuserid='+tmp1+'&multi=1';
	var w = openModal(urlStr,800,540);
	if(w !=null||w !=undefined)
	{
		document.frmcog.targetuser.value = w[0];
		document.frmcog.targetusername.value = w[1];
	}
}

var cTime = new Date();
function  OnItemClick( )
{
    var dtNow = new Date();
    dd = dtNow.getTime() - cTime.getTime();
    if( dd < 500 )
    {
        return;
    }
    cTime = dtNow;
    var c = window.event.srcElement.id.substring(window.event.srcElement.id.length-1,window.event.srcElement.id.length);
    if (c==""){
        return;
    }
    
    if( window.event.srcElement.className == "clsItemsShow1" ){
        window.event.srcElement.className = "clsItemsShow1";
        return;
    }
    
    if( window.event.srcElement.className == "clsItemShow" ){
        window.event.srcElement.className = "clsItemHide";
        document.all( window.event.srcElement.id + 'u').className = "clsItemsHide";
    }
    else{
        window.event.srcElement.className = "clsItemShow";
        document.all( window.event.srcElement.id + 'u' ).className = "clsItemsShow";
    }
}
</Script>
