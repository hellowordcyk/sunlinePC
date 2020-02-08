<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.util.MenuUtil"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.jdom.*"%>
<%@ include file="/common.jsp"%>
<sc:doPost var="subsyspkg" sysName="pcmc" oprId="sm_query" action="getSubSyss" all="true"/>
<c:set var="subsys" value="${subsyspkg.rspRcdDataMaps[0]}"/>
<sc:doPost var="userpkg" sysName="pcmc" oprId="sm_query" action="getUserList" all="false"
    params="usercode=${usercode}"/>
<c:set var="user" value="${userpkg.rspRcdDataMaps[0]}"/>
<html>
<head>
	<title><c:out value="${subsys.cnname}"/></title>
	
	<link href="/common/skins/default/theme/style_new.css" type="text/css" rel="stylesheet">
<script language="javascript" defer="defer">
var oPopup;
var popTop=50;
var mytime;
//弹出窗口
queryPcmcInfos();

//是否开启检车默认密码功能
isStartCheckDefaultFunc();


setInterval(queryPcmcInfos, 180000);
// setInterval(queryPcmcInfos, 5000);
var ajax = new Jraf.Ajax();
function fullscreen(){
    window.resizeTo(screen.availWidth,screen.availHeight);
    window.moveTo(0,0);
    window.focus();
}

function showparent()
{
    if(window.opener){     
       window.opener.focus();
    }
}
window.onunload = showparent;
function popmenu(linkurl)
{
    workframe.location=linkurl;
}
//查询公告  并弹出窗口
function queryPcmcInfos(){
    var reqparams = {
            sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
            oprID:      '<sc:fmt type="crypto" value="info"/>',
            actions:    '<sc:fmt type="crypto" value="queryNoticeInfo"/>'
            };
    var ajax = new Jraf.Ajax();
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
        try{
        var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                //alert('取公告数据出错：\n'+pkg.allMsgs());
                return;
            }
            var rcds = pkg.rspDatas().Record;
            if(!rcds) rcds=[];
            if(!Object.isArray(rcds)) rcds = [rcds];
            popmsg(rcds.length,rcds);
        }catch(e){alert('sendForXml,ERROR:'+e);}
    });
}
//弹出公告窗口
function popmsg(msgnum,msgstr){
    if(msgstr.length<1){
        return ;
    }
    oPopup = window.createPopup();
    var winstr='<table style="border-top: #FFFFFF 1px solid; border-left: #FFFFFF 1px solid" cellSpacing=0 cellPadding=0 width="100%" bgcolor=#cfdef4 border=0>';
    winstr   +='<tr>';
    winstr   +='    <td style="font-size: 12px; background-image: url(msgTopBg.gif); color: #0f2c8c" width=200 height=24></td>';
    winstr   +='    <td style="font-weight: normal; font-size: 12px; background-image: url(msgTopBg.gif); color: #1f336b; padding-top: 4px;padding-left: 4px" valign=center width="100%"> 管理平台消息提示</td>';
    winstr   +='    <td style="background-image: url(msgTopBg.gif); padding-top: 2px;padding-right:2px" valign=center align=right width=19><span title=关闭 style="cursor: hand;color:red;font-size:12px;font-weight:bold;margin-right:4px;" onclick="window.parent.closemsg();">×</span></td>';
    winstr   +='</tr>';
    winstr   +='<tr>';
    winstr   +='    <td style="padding-right: 1px; background-image: url(1msgBottomBg.jpg); padding-bottom: 1px" colSpan=3 height=90>';
    winstr   +='    <div style="border-right: #b9c9ef 1px solid; padding-right: 13px; border-top: #728eb8 1px solid; padding-left: 13px; font-size: 12px; padding-bottom: 13px; border-left: #728eb8 1px solid; width: 100%; color: #1f336b; padding-top: 6px; border-bottom: #b9c9ef 1px solid; height: 100%">'
    winstr   +='    您有<font color=#FF0000>'+msgnum+'</font>条未读公告：<br><br>';
    winstr   +='    <div align=left style="word-break:break-all;">';
    for(var i=0;i<msgstr.length;i++){
        var infoid = msgstr[i].infoid;
        winstr += '<a href="#" onclick="window.parent.openwin('+infoid+');">'+(i+1)+'>  '+msgstr[i].title+'</a><br>';
    }
    winstr   +='    </div>';
    winstr   +='    </div>';
    winstr   +='    </td>';
    winstr   +='</tr>';
    winstr   +='</table>';  
    oPopup.document.body.innerHTML = winstr;
    popshow();
}
//控制弹出窗口的显示
function popshow(){
    if(popTop>1160){
        closemsg();
        return;
    }
    if(popTop>1040&&popTop<1160){
        oPopup.show(screen.width-195,screen.height,180,1160-popTop);
    }
    if(popTop<160){
        oPopup.show(screen.width-195,screen.height-popTop,180,116);
    }
    popTop+=10;
    mytime=setTimeout("popshow();",100);
}
//关闭弹出窗口
function closemsg(){
    try{
        clearTimeout(mytime);
        popTop=50;
    }catch(e){}
    oPopup.hide();
}
//打开公告详情
function openwin(infoid)
{
    var  url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="info"/>';
    url = url + '&actions=<sc:fmt type="crypto" value="getPcmcInfoById"/>&forward=<sc:fmt value='/pcmc/pm/show_pcmcinfo.jsp' type='crypto'/>&infoid='+infoid+"&s_time=" + new Date().getTime();
    openModal(url,800,450);
}

//验证是否使用默人密码，如果是，弹出修改密码
function checkAndModifyDefaultPwd(){
//检查是否是默认密码
var reqparams = {
            sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
            oprID:      '<sc:fmt type="crypto" value="smUserLock"/>',
            actions:    '<sc:fmt type="crypto" value="checkDefaultPwd"/>'
            };
    var ajax = new Jraf.Ajax();
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
        try{
        var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                //alert('取公告数据出错：\n'+pkg.allMsgs());
                return;
            }
            var rcds = pkg.rspDatas();
            if(!rcds) rcds=[];
            if(!Object.isArray(rcds)) rcds = [rcds];
            var isDefaultPwd = rcds[0].isDefaultPwd;
            //如果是默认密码
            if("true" == isDefaultPwd)
            {
            	var s = openModal('/pcmc/sm/userDefaultPwdModify.jsp', 380, 300);
            	//Jraf.showMessageBox({url:"/pcmc/sm/userPwdModify.jsp"});
        		
            	 oPopup = window.createPopup();
                 //oPopup.document.body.innerHTML = winstr;
                 popshow();
                 if("1" == s)
        	      {
                	 //提示信息
                	alert("为了您的账号安全，请修改密码。");
                	 //返回到登录页面
        	        window.location='/login.jsp';
        	      }
            }	
            
        }catch(e){alert('sendForXml,ERROR:'+e);}
    });
	
}

/*
 * 是否开启检查锁定用户功能 
 */
function isStartCheckDefaultFunc()
{
	//检查是否是默认密码
	var reqparams = {
	            sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
	            oprID:      '<sc:fmt type="crypto" value="smUserLock"/>',
	            actions:    '<sc:fmt type="crypto" value="isStartLockUserFunc"/>'
	            };
	    var ajax = new Jraf.Ajax();
	    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
	        try{
	        var pkg = new Jraf.Pkg(xml);
	            if(pkg.result() != '0'){
	                //alert('取公告数据出错：\n'+pkg.allMsgs());
	                return;
	            }
	            var rcds = pkg.rspDatas();
	            if(!rcds) rcds=[];
	            if(!Object.isArray(rcds)) rcds = [rcds];
	            var isStart = rcds[0].isStart;
	            //如果是默认密码
	            if("1" == isStart)
	            {
	            	//验证是否使用默人密码，如果是，弹出修改密码
	            	checkAndModifyDefaultPwd();
	            }	
	            
	        }catch(e){alert('sendForXml,ERROR:'+e);}
	    });
	
}
</script>
</head>
<BODY  onunload="showparent();" onload="fullscreen();" onfocus="fullscreen();"  bgcolor="#4A7DA4" style="BORDER-RIGHT: medium none; BORDER-TOP: medium none; MARGIN: 0px; OVERFLOW: hidden; BORDER-LEFT: medium none; BORDER-BOTTOM: medium none" bgColor=#ffffff>

<table border="0" width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">
  <tr width="100%">
     <td>
     	<iframe name="pubinfo" width="100%" height="51" scrolling=no frameborder=0 
     		src="<c:out value="${param.pubinfourl}?subsysid=${param.subsysid}"/>"></iframe></td>
  </tr>
<c:if test="${user.menutype=='1'}">
  <tr width="100%">
    <td>
    	<table width="100%" height="28" border="0" cellpadding="0" cellspacing="0" class="topmenu">
    		<tr>
    			<td id="menufrm">
						<div id="tomenu"></div>
					</td>
				</tr>
			</table>
    </td>
  </tr>
  <tr width="100%" height="88%">
    <td class=tdstyle2>
        <div id="workdiv">
            <iframe name="workframe" width="100%" height="100%" scrolling="yes" frameborder=0 src="/workstation/manage/workstation_main.jsp"></iframe>
        </div>
    </td>
  </tr>
	<jsp:include page="dropdownMenu.jsp" flush="true"/>
</c:if>
<c:if test="${user.menutype=='2'}">
  <tr width="100%" height="88%">
    <td class=tdstyle2>
    <div id="workdiv">
	<table width="100%" height="100%" border="0">
	  <tr>
	    <td width="20%" height="100%" valign="top" id="menufrm" >
		    <div id="tomenu" style="overflow:auto;height:500;"></div>
			</td>
	    <td width="1%" id="switchPoint" valign="middle"  title="打开/关闭菜单"
	    	style="color: #003300; cursor: hand; font-family: Webdings; font-size: 9pt">
				7
			</td>
			<td width="79%" class=tdstyle2>
			  <iframe name="workframe" width="100%" height="100%" scrolling='auto' frameborder=0 src="/public/welcome.html"></iframe>
			</td>
	   </tr>
	  </table>
	  </div>
	</td>
  </tr>
	<jsp:include page="treeMenu.jsp" flush="true"/>
</c:if>
  <tr height="10">
     <td align="center" valign="middle" background="/common/images/right_bottom.gif" height="28px" style="font-size: 12px;">
     	用户：<c:out value="${user.username}"/>[<c:out value="${user.usercode}"/>]，部门：<c:out value="${user.deptname}"/>[<c:out value="${user.deptcode}"/>]
			<FONT style="FONT-WEIGHT: normal; FONT-SIZE: 12px; LINE-HEIGHT: normal;  face="Verdana, Arial, Helvetica, sans-serif">
     	<!-- Copyright &copy; 1997 - 2008 </FONT> --></FONT>
     	</td>
  </tr>
</table>
</BODY>
</HTML>