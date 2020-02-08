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
	textarea { margin:0 auto; min-width:892px; max-width:950px; min-height:50px; max-height:100px; }
	.td_css { text-align:right; }
</style>
</head>
<sc:doPost var="sourceInfo" scope="request" sysName="governor" oprId="initConfig" action="isFirstLogin" ></sc:doPost>
<c:forEach var="sourceInfo" items="${sourceInfo.rspRcdDataMaps}">
	<input id="isfirst" type="hidden" value='${sourceInfo.firstlogin }' />
	<c:if test="${sourceInfo.firstlogin=='1' }">
		<body id="tipsbody" onbeforeunload="return '第一次使用系统，需配置保存数据库连接信息。';">
	</c:if>
	<c:if test="${sourceInfo.firstlogin=='0' }">
		<body>
	</c:if>
</c:forEach>
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
        <li id="liId2"><a href="#">监管数据模型初始化</a></li>
        <li id="liId3"><a href="#">监管平台初始化</a></li>
        <li id="liId4"><a href="#">监管子系统初始化</a></li>
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

<sc:doPost var="sourceInfo" scope="request" sysName="governor" oprId="initConfig" action="getDataSourceInfo" ></sc:doPost>
<c:forEach var="sourceInfo" items="${sourceInfo.rspRcdDataMaps}">
<input id="dbtype" type="hidden" value='${sourceInfo.dbType }' />
<input id="dbdriver" type="hidden" value='${sourceInfo.dbDriver }' />
<input id="address" type="hidden"  value='${sourceInfo.serverAddr }'/>
<input id="dbname" type="hidden" value='${sourceInfo.dbName }'/>
<input id="username" type="hidden" value='${sourceInfo.userName }' />
<input id="driverurl" type="hidden" value='${sourceInfo.driverURL }' />
<input id="testsql" type="hidden" value='${sourceInfo.testSQL }' />
<input id="testbeforeuse" type="hidden" value='${sourceInfo.testBeforeUse }' />
<input id="testafteruse" type="hidden" value='${sourceInfo.testAfterUse }' />
<input id="verbose" type="hidden" value='${sourceInfo.verbose }' />
<input id="trace" type="hidden" value='${sourceInfo.trace }' />
<input id="sleeptime" type="hidden" value='${sourceInfo.sleepTime }' />
<input id="maxconnlifetime" type="hidden" value='${sourceInfo.maxConnLifetime }' />
<input id="maxconn" type="hidden"  value='${sourceInfo.maxConn }'/>
<input id="minconn" type="hidden" value='${sourceInfo.minConn }' />
<input id="buildthrottle" type="hidden" value='${sourceInfo.buildThrottle }' />
<input id="startedthreshold" type="hidden" value='${sourceInfo.startedThreshold }' />
<input id="maxactivetime" type="hidden" value='${sourceInfo.maxActiveTime }' />
<input id="prototypecount" type="hidden" value='${sourceInfo.prototypeCount }' />
</c:forEach>
</body>
<script type="text/javascript" >
/*******全局变量*********/
var tabs = null;
var dbtype = document.getElementById("dbtype").value;
var dbdriver = document.getElementById("dbdriver").value;
var address = document.getElementById("address").value;
var dbname = document.getElementById("dbname").value;
var username = document.getElementById("username").value;
var driverurl = document.getElementById("driverurl").value;
var testsql = document.getElementById("testsql").value;
var testbeforeuse = document.getElementById("testbeforeuse").value;
var testafteruse = document.getElementById("testafteruse").value;
var verbose = document.getElementById("verbose").value;
var trace = document.getElementById("trace").value;
var sleeptime = document.getElementById("sleeptime").value;
var maxconnlifetime = document.getElementById("maxconnlifetime").value;
var maxconn = document.getElementById("maxconn").value;
var minconn = document.getElementById("minconn").value;
var buildthrottle = document.getElementById("buildthrottle").value;
var startedthreshold = document.getElementById("startedthreshold").value;
var maxactivetime = document.getElementById("maxactivetime").value;
var prototypecount = document.getElementById("prototypecount").value;
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
        url:    '/governor/initguide/dataSourceConfig.jsp',
       	dbType: dbtype,
       	dbDriver: dbdriver,
       	serverAddr:  address,
       	dbName  : dbname,
       	userName :username,
       	driveURL: driverurl,
       	testSQL: testsql,
       	testBeforeUse: testbeforeuse,
       	testAfterUse: testafteruse,
       	verbose: verbose,
       	trace: trace,
       	sleepTime: sleeptime,
       	maxConnLifetime: maxconnlifetime,
       	maxConn: maxconn,
       	minConn: minconn,
       	buildThrottle: buildthrottle,
       	startedThreshold: startedthreshold,
       	maxActiveTime: maxactivetime,
       	prototypeCount: prototypecount
    };
    tabs.addAction(1, reqparams);
    
    
     var reqparams = {
        url:    '/governor/initguide/datamodelInit.jsp'
    };
    tabs.addAction(2, reqparams);
    
    
    
     var reqparams = {
        url:    '/governor/initguide/platformInit.jsp'
    };
    tabs.addAction(3, reqparams);
     
     
     var reqparams = {
        url:    '/governor/initguide/subsysInit.jsp'
    };
    tabs.addAction(4, reqparams);
    tabs.init(1);
}

</script>
</html>