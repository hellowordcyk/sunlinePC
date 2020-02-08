<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    //ie8 用户名称有缓存问题
    long timenum = new java.util.Date().getTime();
%>
<html>
<head>
<%@include file="/common.jsp"%>
<sc:doPost var="subsyspkg" sysName="pcmc" oprId="sm_query" action="getSubSyss" all="true"/>
<c:set var="subsys" value="${subsyspkg.rspRcdDataMaps[0]}"/>
<Meta http-equiv="Pragma" Content="No-cach">
<Meta http-equiv="Expires" Content="0">
<title><c:out value="${subsys.cnname}"/></title>
<script language="javascript" defer="defer">
    var oPopup;
    var popTop=50;
    var mytime;
    //弹出窗口
    queryPcmcInfos();
    
    
  //是否开启检车默认密码功能
    isStartCheckDefaultFunc();
    
    setInterval(queryPcmcInfos, 60000);
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
                	var s = openModal('/pcmc/sm/userDefaultPwdModify.jsp?s_time='+(new Date().getTime()), 380, 300);
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
        var winstr='<table style="border-top: #ffffff 1px solid; border-left: #ffffff 1px solid" cellSpacing="3px" cellPadding="0" width="100%" bgcolor="#cfdef4" border="0">';
        winstr   +='<tr>';
        winstr   +='    <td style="font-weight: normal; font-size: 12px; background-image: url(msgTopBg.gif); color: #1f336b; padding-top: 4px;padding-left: 4px" valign=center width="100%"> 管理平台消息提示</td>';
        winstr   +='    <td style="background-image: url(msgTopBg.gif); padding-top: 2px;padding-right:2px" valign=center align=right width=19><span title=关闭 style="cursor: hand;color:red;font-size:12px;font-weight:bold;margin-right:4px;" onclick="window.parent.closemsg();">×</span></td>';
        winstr   +='</tr>';
        winstr   +='<tr>';
        winstr   +='    <td style="padding-right: 1px; background-image: url(1msgBottomBg.jpg); padding-bottom: 1px" colSpan="3" height="88px">';
        winstr   +='    <div style="width: 100%; height: 100%; overflow: auto; padding: 8px; border-right: #b9c9ef 1px solid; border-top: #728eb8 1px solid; border-left: #728eb8 1px solid; border-bottom: #b9c9ef 1px solid; font-size: 12px; color: #1f336b;">'
        winstr   +='    您有<font color=#FF0000>'+msgnum+'</font>条未读公告：';
        winstr   +='    <div align=left style="width: 100%; font-size: 11px; overflow: hidden; padding: 3px; word-break:break-all;">';
        for(var i=0;i<msgstr.length;i++){
            var infoid = msgstr[i].infoid;
            winstr += '<a href="#" onclick="window.parent.openwin('+infoid+');" title="'+msgstr[i].title+'">'+(i+1)+'>  '+msgstr[i].title+'</a><br>';
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
</script>
<script type="text/javascript">
function quit() {
	window.location='/logout.jsp';
};
</script>
</head>
<frameset onunload="quit()" rows="79,*,28" frameborder="NO" border="0" framespacing="0">
  <frame src="<%=skinPath %>/outlookMenu.jsp?pubinfourl=<%=skinPath %><c:out value="${subsys.pubinfourl}"/>&subsysid=<c:out value="${subsys.subsysid}"/>&s_time=<%=timenum %>" 
         name="topFrame" scrolling="no" noresize/>
  <frame src="<%=skinPath %>/homePage.jsp?subsysid=<c:out value="${subsys.subsysid}"/>" name="bodyFrame_all" scrolling="no" noresize>
  <%-- <frame src="<%=skinPath %>/work_body.jsp?subsysid=<c:out value="${subsys.subsysid}"/>" name="bodyFrame_all" scrolling="no" noresize> --%>
  <frame src="<%=skinPath %>/copyright.jsp" scrolling="no" noresize>
</frameset>
</html>