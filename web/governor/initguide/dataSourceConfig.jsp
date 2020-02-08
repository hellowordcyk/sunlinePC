<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="/common_tag.jsp" %>
 <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<form id="datasourseFormId">
<sc:doPost var="sourceInfo" scope="request" sysName="governor" oprId="initConfig" action="isFirstLogin" ></sc:doPost>
<c:forEach var="sourceInfo" items="${sourceInfo.rspRcdDataMaps}">
	<input id="isfirst" type="hidden" value='${sourceInfo.firstlogin }' />
</c:forEach>
<table align="center" class="form-table" border="0" width="100%" height="10%" cellspacing=0 cellpadding=0>
       <tr><th colspan="4">数据源配置</th></tr>
       <tr>
        <td class="form-label">数据库类型：<span style="color: red;">*</span></td>
        <td class="form-value" >
            <select id="dbType" onchange="ganged()" style="width:152px;" req="1">
	            <option value="oracle">Oracle</option>
	            <option value="mysql">MySQL</option>
	            <option value="db2">DB2</option>
	            <option value="mssql">MSSQL</option>
	            <option value="hsql">HSQL</option>
	            <option value="access">Access</option>
	            <option value="informix">Informix</option>
	            <option value="sybase">Sybase</option>
            </select>
        </td>
        <td class="form-label">数据库驱动：<span style="color: red;">*</span></td>
        <td class="form-value">
        	<select id="dbDriver" style="width: 152px;"></select>
        </td>
      	</tr>
       <tr>
       	<td class="form-label">服务器地址：<span style="color: red;">*</span></td>
      		<td class="form-value"><input id="address" req="1" type="text" onKeyUp="ganged()" value='<c:out value="${param.serverAddr }" />'/></td>
        <td class="form-label">数据库名称：<span style="color: red;">*</span></td>
        <td class="form-value"><input id="dbname" req="1" type="text" onKeyUp="ganged()" value='<c:out value="${param.dbName }" />'/></td>
    </tr>
       <tr>
       	<td class="form-label">用户名：<span style="color: red;">*</span></td>
        <td class="form-value"><input id="username" req="1" type="text" onKeyUp="changesavebtn('true')" value='<c:out value="${param.userName }" />' /></td>
       	<td class="form-label">密码：<span style="color: red;">*</span></td>
        <td class="form-value"><input id="password" req="1" type="password" onKeyUp="changesavebtn('true')" style="width:147px" /></td>
       </tr>
       <tr>
       	<td class="form-label">驱动URL：<span style="color: red;">*</span></td>
       	<td class="form-value" colspan="3" style="padding:8px 0 8px 10px;">
       		<textarea id="driverURL" class="inputarea" name="driverURL" req="1" onKeyUp="changesavebtn('true')"><c:out value="${param.driveURL }" /></textarea>
       	</td>
       </tr>
       <tr>
       	<td class="form-label">测试语句：<span style="color: red;">*</span></td>
       	<td class="from-value" colspan="3" style="padding:8px 0 8px 10px;">
       		<textarea id="testSQL" name="testSQL" class="inputarea"  req="1" onKeyUp="changesavebtn('true')"><c:out value="${param.testSQL }" /></textarea>
       	</td>
       </tr>
       <tr>
       	<td class="form-label">使用前测试：</td>
       	<td class="form-value">
       		<input id="yes_before_use" name="beforeUse" type="radio" value="true" <c:if test="${param.testBeforeUse=='true' }">checked="checked"</c:if> disabled/>是&nbsp;&nbsp;
       		<input id="on_before_use" name="beforeUse" type="radio" value="false" <c:if test="${param.testBeforeUse=='false' }">checked="checked"</c:if> disabled/>否
       	</td>
       	<td class="form-label">使用后测试：</td>
       	<td class="form-value">
       		<input id="yes_after_use" name="afterUse" type="radio" value="true" <c:if test="${param.testAfterUse=='true' }">checked="checked"</c:if> disabled/>是&nbsp;&nbsp;
       		<input id="on_after_use" name="afterUse" type="radio" value="false" <c:if test="${param.testAfterUse=='false' }">checked="checked"</c:if> disabled/>否
       	</td>
       </tr>
       <tr>
       	<td class="form-label">详细信息设置：</td>
       	<td class="form-value">
       		<input id="yes_verbose" name="verbose" type="radio" value="true" <c:if test="${param.verbose=='true' }">checked="checked"</c:if> disabled/>是&nbsp;&nbsp;
       		<input id="on_verbose" name="verbose" type="radio" value="false" <c:if test="${param.verbose=='false' }">checked="checked"</c:if> disabled/>否
       	</td>
       	<td class="form-label">SQL语句是否被log记录：</td>
       	<td class="form-value">
       		<input id="yes_trace" name="trace" type="radio" value="true" <c:if test="${param.trace=='true' }">checked="checked"</c:if> disabled/>是&nbsp;&nbsp;
       		<input id="on_trace" name="trace" type="radio" value="false" <c:if test="${param.trace=='false' }">checked="checked"</c:if> disabled/>否
       	</td>
       </tr>
       <tr>
       	<td class="form-label">睡眠状态时间：</td>
       	<td class="form-value"><input id="sleep_time" type="text"  value='<c:out value="${param.sleepTime }" />' disabled /></td>
       	<td class="form-label">线程最大寿命：</td>
        <td class="form-value"><input id="max_conn_lifetime" type="text"  value='<c:out value="${param.maxConnLifetime }" />' disabled /></td>
       </tr>
       <tr>
       	<td class="form-label">最大的数据库连接数：</td>
        <td class="form-value"><input id="maxconn" type="text"  value='<c:out value="${param.maxConn }" />' disabled /></td>
       	<td class="form-label">最小的数据库连接数：</td>
       	<td class="form-value"><input id="minconn" type="text" value='<c:out value="${param.minConn }" />' disabled /></td>
       </tr>
       <tr>
       	<td class="form-label">一次建立的最大连接数：</td>
        <td class="form-value"><input id="build_throttle" type="text"  value='<c:out value="${param.buildThrottle }" />' disabled /></td>
       	<td class="form-label">连接池状态：</td>
       	<td class="form-value"><input id="started_threshold" type="text" value='<c:out value="${param.startedThreshold }" />' disabled /></td>
       </tr>
       <tr>
       	<td class="form-label">线程的活动时间：</td>
       	<td class="form-value"><input id="max_active_time" type="text" value='<c:out value="${param.maxActiveTime }" />' disabled /></td>
       	<td class="form-label">空闲连接数量：</td>
        <td class="form-value"><input id="prototype_count" type="text"  value='<c:out value="${param.prototypeCount }" />' disabled /></td>
       </tr>
       <tr>
       	<td colspan="6" class="form-bottom" align="center">
        	<div id="btn"  style="margin:0px;">
        		<input type="button" class="button" id="updatec"  value="修改连接池参数" onclick="updateConnection();" title="修改参数后点击测试"/>
	            <input type="button" class="button" name="testConn"  value="测试连接" onclick="testConnection('test');" title="连接成功后点击保存"/>
	            <input type="button" class="button" name="save"  value="保存" onclick="testConnection('save');" title="保存后,下一步按钮解锁,直接进入子系统初始化按钮解锁"/>
	            <input type="button" class="button" name="next"  value="下一步" onclick="to_sec();"/>
	            <input type="button" class="button" name="initSubsys" value="直接进入子系统初始化" onclick="initsys();"/>
    		</div>
   		</td>
   	</tr>
   	<sc:doPost var="sourceInfo" scope="request" sysName="governor" oprId="initConfig" action="isFirstLogin" ></sc:doPost>
	<c:forEach var="sourceInfo" items="${sourceInfo.rspRcdDataMaps}">
		<input id="isfirst" type="hidden" value='${sourceInfo.firstlogin }' />
		<c:if test="${sourceInfo.firstlogin=='1' }">
			<tr id="tips">
				<td colspan='5' height="100%" valign="top">
					<div class="page-tip" >
				   		<span class="tip-title">温馨提示</span>
				   		<p>第一次使用系统，需配置保存数据库连接信息，然后<span style="color:red;font-weight:bold;">重启服务器</span>，再次登录系统即可</p>
					</div>
				</td>
			</tr>
		</c:if>
	</c:forEach>
</table>
</form>
<script type="text/javascript" defer="defer">
var dbType="<c:out value='${param.dbType}' />";
var options = $('dbType').options;
for(var i=0;i<options.length;i++){
	if(options[i].value==dbType){
		options[i].selected=true;
	}
}

init();
function init(){
//	document.getElementsByName('next')[0].disabled=true;
	changesavebtn(true);
//	$$("input[name='initSubsys']")[0].disabled=true;
	
	var dbtype = document.getElementById("dbType").value;
	addOption(dbtype);
}

var m_Ajax = {    createXHR:function(){
    if(window.XMLHttpRequest){
      var xhr = new XMLHttpRequest();
      return xhr;
    }else if(window.ActiveXObject){
      var xhr = new ActiveXObject("Microsoft.XMLHTTP");
      return xhr;
    }
 },
 sendRequest:function(method,url,data,callback){
    var xhr = this.createXHR();
    xhr.open(method,url);
    if(method=="GET"){
      xhr.send(null);
    }else if(method=="POST"){
      xhr.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
      xhr.send(data);
    }
    xhr.onreadystatechange=function(){
      if(xhr.readyState==4&&xhr.status==200){
          var p = {
                    text:xhr.responseText,
                    xml:xhr.responseXML
                  };
          callback(p);
      }
    };
 }
};
function testConnection(flage){
	if (!checkForm($("datasourseFormId"))) {
		return;
	}
    var dbType=document.getElementById("dbType").value;
    var dbdriver = document.getElementById("dbDriver").value;
    var address = document.getElementById("address").value;
    var dbname = document.getElementById("dbname").value;
    
    var username = document.getElementById("username").value;
    var driverurl = document.getElementById("driverURL").value;
    var testsql = document.getElementById("testSQL").value;
    
    var beforeUse = beforeUses();
	var afterUse = afterUses();
	var verbose = verboses();
	var trace = traces();
    var sleeptime = document.getElementById("sleep_time").value;
    var maxconnlifetime = document.getElementById("max_conn_lifetime").value;
    var minconn = document.getElementById("minconn").value;
    var buildthrottle = document.getElementById("build_throttle").value;
    
    var startedthreshold = document.getElementById("started_threshold").value;
    var maxactivetime = document.getElementById("max_active_time").value;
    var prototypecount = document.getElementById("prototype_count").value;
    var password = document.getElementById("password").value;
    
    if(password.length==0 || password==""){
     alert('请输入密码');
     return;
    }
    var maxconn = document.getElementById("maxconn").value;
    var data = "dbType="+dbType+"&dbDriver="+dbdriver+"&serverAddr="+address+"&dbName="+dbname+
    "&userName="+username+"&driverURL="+driverurl+"&testSQL="+testsql+"&testBeforeUse="+beforeUse+
    "&testAfterUse="+afterUse+"&verbose="+verbose+"&trace="+trace+"&sleepTime="+sleeptime+
    "&maxConnLifetime="+maxconnlifetime+"&maxConn="+maxconn+"&minConn="+minconn+"&buildThrottle="+buildthrottle+
    "&startedThreshold="+startedthreshold+"&maxActiveTime="+maxactivetime+"&password="+password+"&prototypeCount="+prototypecount+"&testconnflag="+flage;
    m_Ajax.sendRequest("POST","/governor",data,func);
}

function func(c){
    var ret = c.text;
    if(ret==0){
      alert("连接成功");
      changesavebtn(false);
    }else if(ret==1){
     	alert("连接失败，请检查配置是否正确");
    }else if(ret==2){
      	alert("保存成功，正在重新读取数据源");
    //    reload();
      	document.getElementsByName('next')[0].disabled=false;
      	$$("input[name='initSubsys']")[0].disabled=false;
    }else if(ret==3){
     	alert("保存失败");
    }
}

function beforeUses(){
  var value="";
  var radio=document.getElementsByName("beforeUse");
  for(var i=0;i<radio.length;i++){
	if(radio[i].checked==true){
	  value=radio[i].value;
	  break;
	}
  }
  return value;
}

function afterUses(){
  var value="";
  var radio=document.getElementsByName("afterUse");
  for(var i=0;i<radio.length;i++){
	if(radio[i].checked==true){
	  value=radio[i].value;
	  break;
	}
  }
  return value;
}

function verboses(){
  var value="";
  var radio=document.getElementsByName("verbose");
  for(var i=0;i<radio.length;i++){
	if(radio[i].checked==true){
	  value=radio[i].value;
	  break;
	}
  }
  return value;
}

function traces(){
  var value="";
  var radio=document.getElementsByName("trace");
  for(var i=0;i<radio.length;i++){
	if(radio[i].checked==true){
	  value=radio[i].value;
	  break;
	}
  }
  return value;
}

function to_sec()
{           
	var reqparams = {
    	url : '/governor',
    	flag: 'dataSourceConfig',
    	subname: 'governor'
    };
	tabs.changeAction(2, reqparams);
	tabs.refresh(2,true);
	dspTab(2);//切换title样式
 }
function initsys(){
	var reqparams = {
    	url:'/governor',
        flag:'palttosubsysinit'
    };
    tabs.changeAction(4, reqparams);
	tabs.refresh(4, false);
	dspTab(4);//切换title样式
}

function updateConnection() {
	var upbtn = document.getElementById("updatec").value;
	if (upbtn == "修改连接池参数") {
		document.getElementById('updatec').value = '禁改连接池参数';
	} else {
		document.getElementById('updatec').value = '修改连接池参数';
	}
	var yes_before_use = document.getElementById("yes_before_use");
	var on_before_use = document.getElementById("on_before_use");
	var yes_after_use = document.getElementById("yes_after_use");
	var on_after_use = document.getElementById("on_after_use");
	var yes_verbose = document.getElementById("yes_verbose");
	var on_verbose = document.getElementById("on_verbose");
	var yes_trace = document.getElementById("yes_trace");
	var on_trace = document.getElementById("on_trace");
	var sleep_time = document.getElementById("sleep_time");
	var max_conn_lifetime = document.getElementById("max_conn_lifetime");
	var maxconn = document.getElementById("maxconn");
	var minconn = document.getElementById("minconn");
	var build_throttle = document.getElementById("build_throttle");
	var started_threshold = document.getElementById("started_threshold");
	var max_active_time = document.getElementById("max_active_time");
	var prototype_count = document.getElementById("prototype_count");

	yes_before_use.disabled = !(yes_before_use.disabled && true);
	on_before_use.disabled = !(on_before_use.disabled && true);
	yes_after_use.disabled = !(yes_after_use.disabled && true);
	on_after_use.disabled = !(on_after_use.disabled && true);
	yes_verbose.disabled = !(yes_verbose.disabled && true);
	on_verbose.disabled = !(on_verbose.disabled && true);
	yes_trace.disabled = !(yes_trace.disabled && true);
	on_trace.disabled = !(on_trace.disabled && true);
	sleep_time.disabled = !(sleep_time.disabled && true);
	max_conn_lifetime.disabled = !(max_conn_lifetime.disabled && true);
	maxconn.disabled = !(maxconn.disabled && true);
	minconn.disabled = !(minconn.disabled && true);
	build_throttle.disabled = !(build_throttle.disabled && true);
	started_threshold.disabled = !(started_threshold.disabled && true);
	max_active_time.disabled = !(max_active_time.disabled && true);
	prototype_count.disabled = !(prototype_count.disabled && true);
}

function ganged() {
	changesavebtn(true);
	var dbtype = document.getElementById("dbType").value;
    var address = document.getElementById("address").value;
    var dbname = document.getElementById("dbname").value;
    commonGanged(dbtype,address,dbname);
}

/**
 * 联动公共方法
 */
function commonGanged(dbtype,address,dbname) {
	if (dbtype=="mysql") {
		addOption(dbtype);
		document.getElementById("driverURL").value="jdbc:mysql://"+address+":3306/"+dbname+"?useUnicode=true&characterEncoding=utf-8";
	} else if (dbtype=="db2") {
		addOption(dbtype);
		document.getElementById("driverURL").value="jdbc:db2://"+address+":5000/"+dbname;
	} else if (dbtype=="mssql") {
		addOption(dbtype);
		document.getElementById("driverURL").value="jdbc:jtds:sqlserver://"+address+":1433;databaseName=" + dbname;
	} else if (dbtype=="hsql") { 
		addOption(dbtype);
		document.getElementById("driverURL").value="jdbc:hsqldb:hsql://" + address + "/" + dbname;
	} else if (dbtype=="access") {
		addOption(dbtype);
		document.getElementById("driverURL").value="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=DataBase/SuperMarketManager.mdb";
	} else if (dbtype=="informix") {
		addOption(dbtype);
		document.getElementById("driverURL").value="jdbc:informix-sqli://"+address+":1533/"+dbname+":INFORMIXSERVER=myserver;";
	} else if (dbtype=="sybase") {
		addOption(dbtype);
		document.getElementById("driverURL").value="jdbc:sybase:Tds:"+address+":5007/"+dbname;
	} else {  //oracle
		addOption(dbtype);
		document.getElementById("driverURL").value="jdbc:oracle:thin:@"+address+":1521:"+dbname;
	}
}

/**
 * 动态添加驱动类下来列表
 */
function addOption(dbtype) {
	var dbDriver = document.getElementById("dbDriver");
	dbDriver.length = 0;  //清楚驱动类下拉列表项
	var addo = document.createElement("option");

	var driver = "";
	if (dbtype=="mysql") {
		driver="com.mysql.jdbc.Driver";
	} else if (dbtype=="db2") {
		driver="com.ibm.db2.jcc.DB2Driver";
	} else if (dbtype=="mssql") {
		driver="com.microsoft.sqlserver.jdbc.SQLServerDriver";
	} else if (dbtype=="hsql") { 
		driver="org.hsqldb.jdbcDriver";
	} else if (dbtype=="access") {
		driver="sun.jdbc.odbc.JdbcOdbcDriver";
	} else if (dbtype=="informix") {
		driver="com.informix.jdbc.IfxDriver";
	} else if (dbtype=="sybase") {
		driver="com.sybase.jdbc.SybDriver";
	} else {  //oracle
		driver="oracle.jdbc.driver.OracleDriver";
	}
	dbDriver.add(new Option(driver,driver));
}

/**
 * 改变保存按钮可用状态
 */
function changesavebtn(value) {
	$$("input[name='save']")[0].disabled=value;
}

/**
 * 重新读取数据库配置（热启动）
 */
function reload(){
	var url="/reloadConfig";
	 var data_DB ="loadDb=2";
	m_Ajax.sendRequest("POST","/reloadConfig",data_DB,funS);
}
function funS(c){
    var ret = c.text;
	if(ret=="0"){
		alert("重启成功");
	    window.location.href="/jui/index_governor.jsp";
	 }else{
		alert("重启失败"); 
	 }
 }
</script>
