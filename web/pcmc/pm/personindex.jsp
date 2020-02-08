<%@ page buffer = "0kb"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.conf.BimisConf"%>
<%@ page import="java.util.*"%>
<%@ include file="/common.jsp"%>
<%
  if (request.getParameter("logoff") != null) {
    response.sendRedirect("/logout.jsp");
    return;
  }

    // 取出线程内的认证信息(登录交易中成功登录后生成)
    com.sunline.jraf.security.UserAuthenticator loginJrafAuth2 = (com.sunline.jraf.security.UserAuthenticator) com.sunline.jraf.security.UserAuthenticator.getAuthenticator();
    if(loginJrafAuth2==null){
        response.sendRedirect("/logout.jsp");
        return;     
    }else{
        // 认证信息回存到session
        com.sunline.jraf.security.UserAuthenticator.setSessionAttribute(session,loginJrafAuth2.getUser());
    }
%>
<c:set var="userInfo" value="${jrafrpu.rspPkg.rspDataMap}"/>
<c:set var="deptcode" value="${userInfo.deptcode}" scope="session"/>
<c:set var="deptname" value="${userInfo.deptname}" scope="session"/>
<!--  取用户的子系统  -->
<sc:doPost sysName="pcmc" oprId="sm_query" action="getUserPcmcSubsys" var="subsysPkg" all="true"  encoding="UTF-8"/>
<c:set var="subsyss" value="${subsysPkg.rspRcdDataMaps}"/>
<sc:doPost var="userpkg" sysName="pcmc" oprId="sm_query" action="getUserList" all="false"
    params="usercode=${usercode}"/>
<c:set var="user" value="${userpkg.rspRcdDataMaps[0]}"/>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><%=BimisConf.getSiteName()%></title>
    <link href="/common/skins/default/theme/index-style.css" type="text/css" rel="stylesheet">
</head>
<%
    Calendar cld = Calendar.getInstance();
        int year = cld.get(Calendar.YEAR);
        int month = cld.get(Calendar.MONTH) + 1;
        int day = cld.get(Calendar.DAY_OF_MONTH);
        String week = ChinTraCalendar.getCHWeek(cld.get(Calendar.DAY_OF_WEEK));
        long[] chtracal = ChinTraCalendar.calElement(year, month, day);
        String cmonth = ChinTraCalendar.getCHMonth((int)(chtracal[1]));
        String cday = ChinTraCalendar.getCHDay((int)(chtracal[2]));
%>

<body onLoad="MM_preloadImages()">
<div id="index-header">
    <div id="index-logo"></div>
    <div id="header-toolbar">
        <span valign="center" class="password"><a href="#" onClick="openModal('/pcmc/sm/userPwdModify.jsp', 380, 155);">修改密码</a></span>
        <span valign="center" class="logout"><a href="#" onclick=''>注销</a></span>
        

    </div>
</div>
<div id="header-nav">
    <span class="user">当前登录<B>：<c:out value="${user.username}"/>[<c:out value="${user.usercode}"/>]</B>&nbsp; | &nbsp;<c:out value="${user.deptname}"/>[<c:out value="${user.deptcode}"/>]</span>
</div>
<div id="index-container">
    <div class="index-tab">
        <ul>
            <li class="current"><a href="#"><span>子系统入口</span></a></li>
            <li><a href="/pcmc/pm/personplatform.jsp"><span>我的工作台</span></a></li>
        </ul>
    </div>
    <div class="index-content">
        <c:forEach var="subsys" varStatus="status" items="${subsyss}">
            <c:if test="${subsys.orderidx>0}">
            <div class="index-panel">
            <div class="images1" >
            <span>
                <c:set var="url" value="${subsys.linkurl}?shortname=${subsys.shortname}&subsysid=${subsys.subsysid}&cnname=${subsys.cnname}&roleid=${subsys.roleid}&rolename=${subsys.rolename}&pubinfourl=${subsys.pubinfourl}"/>
                        <a href="#" onClick="openwin('<sc:fmt value="${url}"/>','<sc:fmt value="${subsys.cnname}"/>')"
                onmouseover="changeImages('<sc:fmt value="${subsys.shortname}"/>', '<sc:fmt value="${subsys.imgurl}"/>-Over.gif'); return true;"
                onmouseout="changeImages('<sc:fmt value="${subsys.shortname}"/>', '<sc:fmt value="${subsys.imgurl}"/>.gif'); return true;"
                onmousedown="changeImages('<sc:fmt value="${subsys.shortname}"/>', '<sc:fmt value="${subsys.imgurl}"/>-Over.gif'); return true;"
                onmouseup="changeImages('<sc:fmt value="${subsys.shortname}"/>', '<sc:fmt value="${subsys.imgurl}"/>-Over.gif'); return true;">
                <img name="<sc:fmt value="${subsys.shortname}"/>" src="<sc:fmt value="${subsys.imgurl}"/>.gif" border="0" alt=""></a>
            </span> 
            </div>
            </div>
            </c:if>
        </c:forEach>
        
    </div>
</div>
<div id="index-footer">
    <span id="copyright">2009 恒丰银行版权所有 | 鲁ICP备05031325号 | 总行地址：中国?烟台市南大街248号 邮编：264000</span> 

</div>
 
</body>
</html>

<script language="javascript">
    function openwin(url,name){
        window.open(url,name,"height=600, width=800,toolbar=no , menubar=no, scrollbars=yes, resizable=yes, location=no, status=yes");
    }
    
    function opensmallwin(url,name){
        window.open(url,name,"height=400, width=700,toolbar=no , menubar=no, scrollbars=yes, resizable=yes, location=no, status=yes");
    }
    
    function newImage(arg) {
        if (document.images) {
            rslt = new Image();
            rslt.src = arg;
            return rslt;
        }
    }
    
    function changeImages() {
        if (document.images && (preloadFlag == true)) {
            for (var i=0; i<changeImages.arguments.length; i+=2) {
                document[changeImages.arguments[i]].src = changeImages.arguments[i+1];
            }
        }
    }
    
    var preloadFlag = false;
    function preloadImages() {
        if (document.images) {
            /*id1_qiege_03_Over = newImage("/common/images/pic01/1_qiege_03-Over.gif");
            id1_qiege_04_Over = newImage("/common/images/pic01/1_qiege_04-Over.gif");
            id1_qiege_05_Over = newImage("/common/images/pic01/1_qiege_05-Over.gif");
            id1_qiege_06_Over = newImage("/common/images/pic01/1_qiege_06-Over.gif");
            id1_qiege_07_Over = newImage("/common/images/pic01/1_qiege_07-Over.gif");
            id1_qiege_08_Over = newImage("/common/images/pic01/1_qiege_08-Over.gif");
            id1_qiege_15_Over = newImage("/common/images/pic01/1_qiege_15-Over.gif");
            id1_qiege_17_Over = newImage("/common/images/pic01/1_qiege_17-Over.gif");
            id1_qiege_20_Over = newImage("/common/images/pic01/1_qiege_20-Over.gif");
            id1_qiege_22_Over = newImage("/common/images/pic01/1_qiege_22-Over.gif");
            id1_qiege_23_Over = newImage("/common/images/pic01/1_qiege_23-Over.gif");*/
            preloadFlag = true;
        }
    }
    
    function MM_swapImgRestore() { 
        //v3.0
        var i,x,a=document.MM_sr; 
        for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
    }
    
    function MM_preloadImages() { 
        //v3.0
        var d=document; 
        if(d.images){ 
            if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; 
            for(i=0; i<a.length; i++)
                    if (a[i].indexOf("#")!=0){ 
                        d.MM_p[j]=new Image; 
                        d.MM_p[j++].src=a[i];
                    }
                }
        preloadImages();
    }
    
    function MM_findObj(n, d) { 
        //v4.01
        var p,i,x;  
        if(!d) d=document; 
        if((p=n.indexOf("?"))>0&&parent.frames.length) {
                d=parent.frames[n.substring(p+1)].document; 
                n=n.substring(0,p);
            }
        if(!(x=d[n])&&d.all) x=d.all[n]; 
        for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
        for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
        if(!x && d.getElementById) x=d.getElementById(n); return x;
    }
    
    function MM_swapImage() { //v3.0
        var i,j=0,x,a=MM_swapImage.arguments; 
        document.MM_sr=new Array; 
        for(i=0;i<(a.length-2);i+=3)
            if ((x=MM_findObj(a[i]))!=null){
                document.MM_sr[j++]=x; 
                if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];
            }
    }
    
    function goLinkWeb(){
        var iIndex = selectLink.selectedIndex;
        var ss = selectLink.options[iIndex].value;
        openwin(ss,'友情链接');
    }

</script>
