<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="com.sunline.governor.bean.TaskBean" %>
<%@ page import="java.util.ArrayList" %>
<html>
<head>
<title>监管初始化配置 - 向导</title>
<%
    ArrayList<TaskBean>   taskList = (ArrayList<TaskBean>)request.getAttribute("taskBeanList");
 %>
<%@ include file="/governor/common/common.jsp" %>
<link rel="stylesheet" type="text/css" href="<%=contextPathStr + skinCssPath %>/item/item_calc_pub.css">
<link rel="stylesheet" type="text/css" href="<%=contextPathStr + skinCssPath %>/config.css">
<link rel="stylesheet" type="text/css" href="<%=contextPathStr + skinCssPath %>/style-custom.css">

<style type="text/css">
	textarea { margin:0 auto; min-width:912px; max-width:920px; min-height:50px; max-height:100px; }
</style>
</head>
<body>
<input id="isfirst" type="hidden" value='1' />
<div id="tabId">
    <!-- 隐藏，只用其JS方法 -->
    <ul id="menus-tab" style="display: none;">
        <li targetid="tab1">第一步,修改指标定义信息</li>
        <li targetid="tab2">第二步,修改对象授权</li>
        <li targetid="tab3">第三步,修改版本取数口径及其试计算</li>
        <li targetid="tab4">第四步,提交</li>
    </ul>
    <div>
    <!-- 真正展示的标题头 -->
    <ul id="ulId">
        <li id="liId1" class="first"><a href="#">数据源配置</a></li>
        <!-- <li id="liId2"><a href="#">监管数据模型初始化</a></li>
        <li id="liId3"><a href="#">监管平台初始化</a></li>
        <li id="liId4"><a href="#">监管子系统初始化</a></li> -->
    </ul>
    </div>
    <div id="tab1" class="content">
    </div>
    <div id="tab2" class="content">
    </div>
    <div id="tab3" class="content">
    </div>
    <div id="tab4" class="content">
    </div>
</div>
</body>
<script type="text/javascript" >
/*******全局变量*********/
var tabs = null;
/***********************/
document.observe('dom:loaded',function (){
    initTab();          //初始化选项卡
   Event.observe(document,"contextmenu", function (event){
       event.returnValue = false;
   });
});
/**
 * 初始化选项卡
 */
function initTab() {
    createTabs();           //未传值，则新增
}
function dspTab(idNum){
    $("ulId").select("li").each(function (obj) {
        if (obj.readAttribute("id") == "liId"+idNum) {
            if (idNum==1) {
                obj.className = "first";
            } else {
                obj.className = "on";
            }
        }else{
            obj.className = "";
        }
    });
}
/**
 * 新增页面tab初始化
 */
function createTabs(){
    var options = {
        tabid: "menus-tab",
        displayStyle: "div",
        displayID:{"tab1":"tab1","tab2": "tab2","tab3": "tab3", "tab4": "tab4"}
    };
    tabs = new Jraf.Tabs(options);
     reqparams = {
     	url:    '/governor/firstlogin/dataSourceConfig.jsp',       	
       	dbType : '${database.dbType}',
       	dbDriver : '${database.dbDriver}',
       	serverAddr : '${database.serverAddr}',
       	dbName : '${database.dbName}',
       	userName : '${database.userName}',
       	driverURL : '${database.driverURL}',
       	testSQL : '${database.testSQL}',
       	testBeforeUse : '${database.testBeforeUse}',
       	testAfterUse : '${database.testAfterUse}',
       	verbose : '${database.verbose}',
       	trace : '${database.trace}',
       	sleepTime : '${database.sleepTime}',
       	maxConnLifetime : '${database.maxConnLifetime}',
       	maxConn : '${database.maxConn}',
       	minConn : '${database.minConn}',
       	buildThrottle : '${database.buildThrottle}',
       	startedThreshold : '${database.startedThreshold}',
       	maxActiveTime : '${database.maxActiveTime}',
       	prototypeCount : '${database.prototypeCount}'
    };
    tabs.addAction(1, reqparams);
    
     var reqparams = {
        url:    '/governor/firstlogin/datamodelInit.jsp'
    };
    tabs.addAction(2, reqparams);
    
    
    
     var reqparams = {
        url:    '/governor/firstlogin/platformInit.jsp'
    };
    tabs.addAction(3, reqparams);
     
     
     var reqparams = {
        url:    '/governor/firstlogin/subsysInit.jsp'
    };
    tabs.addAction(4, reqparams);
    tabs.init(1);
}

</script>
</html>