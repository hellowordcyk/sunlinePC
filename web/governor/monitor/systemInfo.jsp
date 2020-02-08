<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <%@ include file="/jui_tag.jsp" %>
</head>
<style>
	.system-status{
		background: #f0f0f0;
	}
	.system-status>div{
		float: left;
		width:32%;
		margin-left:1%;
		background: #fff;
		padding: 6px 20px;
		min-height: 580px;
	}
	.server-title,.cpu-title,.java-title{
		height: 60px;
		line-height:52px;
		text-align:center;
		font-size: 24px;
	}
	.server-title span,
	.cpu-title span,
	.java-title span
	{
		display: inline-block;
		padding: 10px;
		background: #1ECFE6;
		vertical-align: middle;
		font-size:32px;
		color:#fff;
		border-radius:50%;
		margin-right: 24px;
	}
	.server-title span{
		background: #76C2DD;
	}
	.cpu-title span{
		background: #B7A0D8;
	}
	.java-title span{
		background: #84D1A3;
	}
	.double-info{
		border-top: 1px solid #e2e2e2;
	}
	.double-info li{
		height: 32px;
	}
	.double-info .item{
		float: left;
		margin-top: 10px;
	}
	.double-info .infor{
		float: right;
		margin-top: 10px;		
	}
	.triple-info{
		border-top: 1px solid #e2e2e2;
	}
	.triple-info li{
		height: 32px;
		line-height: 32px;
	}
	.triple-info span{
		float: left;
		width: 33.3%;
		text-align: center;
	}
	.border-top{
		border-top: 1px solid #e2e2e2;
	}
	.margin-bottom{
		margin-bottom: 20px;
	}
	
	.blackc{
		color: #000;
		
		font-weight: bold;
	}
</style>
<body>
<%-- <FIELDSET>
<div >
<table style="margin:0 20px;width:95%;" border="0" class="form-table">
  <tbody><tr>
    <td align="center" width="100px;"><img src="../../common/images/governor/servermanager.gif" width="60" height="60"><div style="margin: 10px,font:9pt bold"><b>服务器信息</b></div></td>
    <td align="center">
    <table cellpadding="0" cellspacing="0" border="0" class="form-table" style="width:97%;margin-left:20px;">
      <tbody>
      <tr>
       	 <td width="20%"  nowrap="nowrap" class="form-label">服务器IP地址</td>
   		 <td width="30%">${requestScope.serverInfo.address}</td>
  	     <td width="20%" class="form-label">操作系统名称</td>
     <td width="30%">${requestScope.serverInfo.osVendorName}</td> 
<tr>
      </tr>
         <td class="form-label">操作系统类型</td>
    	<td>${requestScope.serverInfo.osName} </td>
   		 <td class="form-label">操作系统厂商</td>
    	<td>${requestScope.serverInfo.osVendor }</td>
      </tr>
      <tr>
       <td class="form-label">服务器启动时间</td>
   		 <td>${requestScope.serverInfo.startTime }</td>
    	<td class="form-label">持续时间</td>
   		 <td>${requestScope.serverInfo.duration }</td>
      </tr> 
      <tr>
       <td class="form-label" >在线人数：</td><td>${requestScope.serverInfo.usercount }</td>
       <td class="form-label">&nbsp;</td>
   		 <td>&nbsp;</td>
       </tr>
      
        <tr>
       <td class="form-label" colspan="4">文件系统信息：</td>
      </tr>
      <c:forEach var="fileInfo" items="${requestScope.fileInfoList}">
        <tr>
       <td class="form-label">${fileInfo.devName}盘</td>
   		 <td>总量：${fileInfo.total }</td>
    	<td class="form-label">已用：${fileInfo.used }</td>
   		 <td>可用：${fileInfo.avail }</td>
      </tr>
      </c:forEach>
    </tbody></table></td>
  </tr>

</tbody>

</table><br>

<table style="margin:0 20px;width:95%;height:25%" border="0" class="form-table">
  <tbody><tr>
    <td align="center" width="100px;"><img src="../../common/images/governor/os.gif" width="60" height="60"><div style="margin: 10px,font:9pt bold"><b>CPU信息</b></div></td>
    <td align="center">
    <table cellpadding="0" cellspacing="0" border="0" class="form-table" style="width:97%;margin-left:20px;">
      <tbody>
      <tr>
       	  <td width="20%" class="form-label">CPU型号</td>
   		 <td width="30%">${requestScope.cpuInfo.model }</td>
   		 <td width="20%" class="form-label">CPU数目</td>
    	 <td width="30%">${requestScope.cpuInfo.cpuNum }</td>
      </tr>
      <tr>
    	<td class="form-label">CPU厂商</td>
   		 <td>${requestScope.cpuInfo.vendor }</td>
   		 <td class="form-label">CPU等待率</td>
     	 <td>${requestScope.cpuInfo.cpuWait }</td>
      </tr>
      <tr>
        <td class="form-label">CPU用户使用率</td>
      <td>${requestScope.cpuInfo.cpuUser }</td>
      <td class="form-label">CPU系统使用率</td>
     <td width="25%">${requestScope.cpuInfo.cpuSys }</td>
      </tr>
      <tr>
        <td class="form-label">CPU空闲率</td>
      <td>${requestScope.cpuInfo.cpuIdle }</td>
      <td class="form-label">CPU总使用率</td>
     <td width="25%">${requestScope.cpuInfo.cpuCombined }</td>
      </tr>
    </tbody></table></td>
  </tr>
</tbody></table>
<br>

<table style="margin:0 20px;width:95%;height:25%" border="0" class="form-table">
  <tbody><tr>
    <td align="center" width="100px;"><img src="../../common/images/governor/jdk.gif" width="60" height="60"><div style="margin: 10px,font:9pt bold"><b>Java&amp;<br>内存信息</b></div></td>
    <td align="center">
   <table cellpadding="0" cellspacing="0" border="0" class="form-table" style="width:97%;margin-left:20px;">
      <tbody>
      <tr>
       	 <td width="20%" nowrap="nowrap" class="form-label">JVM名称</td>
   		 <td width="30%">${requestScope.serverInfo.vmName }</td>
    	<td width="20%" class="form-label">JVM厂商</td>
    	<td width="30%">${requestScope.serverInfo.vmVendor }</td>
      </tr>
      <tr>
          <td class="form-label">JDK版本号</td>
    	<td>${requestScope.serverInfo.jdkVersion }</td>
   		 <td class="form-label">JVM版本号</td>
    	<td>${requestScope.serverInfo.vmVersion }</td>
      </tr>
      <tr>
         <td class="form-label">JVM内存</td>
    	 <td>最大内存:${requestScope.memInfo.jMax }</td>
   		
    	<td class="form-label">分配内存:${requestScope.memInfo.jTotal }</td>
    	<td>空闲内存：${requestScope.memInfo.jFree }</td>
      </tr>
      <tr>
         <td class="form-label">物理内存</td>
    	 <td>总量:${requestScope.memInfo.total }</td>
   		
    	<td class="form-label">已用:${requestScope.memInfo.used }</td>
    	<td>可用：${requestScope.memInfo.free }</td>
      </tr>
        <tr>
         <td class="form-label">交换内存</td>
    	 <td>总量:${requestScope.memInfo.sTotal }</td>
   		
    	<td class="form-label">已用:${requestScope.memInfo.sUsed }</td>
    	<td>可用：${requestScope.memInfo.sFree }</td>
    </tbody></table></td>
  </tr>
</tbody></table>
</div>
</FIELDSET> --%>
<div class="system-status clearfix">
	<div class="server" id="server_info">
		<div class="server-title"><span><i class="jf-btn-server"></i></span>服务器信息</div>
		<ul class="double-info">
			<li class="clearfix">
				<span class="item">服务器ip地址</span>
				<span class="infor">${requestScope.serverInfo.address}</span>
			</li>
			<li class="clearfix">
				<span class="item">操作系统名称</span>
				<span class="infor">${requestScope.serverInfo.osVendorName}</span>
			</li>
			<li class="clearfix">
				<span class="item">操作系统类型</span>
				<span class="infor">${requestScope.serverInfo.osName}</span>
			</li>
			<li class="clearfix">
				<span class="item">操作系统厂商</span>
				<span class="infor">${requestScope.serverInfo.osVendor }</span>
			</li>
		</ul>
		<ul class="double-info">
			<li class="clearfix">
				<span class="item">服务器启动时间</span>
				<span class="infor blackc">${requestScope.serverInfo.startTime }</span>
			</li>
			<li class="clearfix">
				<span class="item">持续时间</span>
				<span class="infor blackc">${requestScope.serverInfo.duration }</span>
			</li>
			<li class="clearfix">
				<span class="item">在线人数</span>
				<span class="infor blackc">${requestScope.serverInfo.usercount }</span>
			</li>
		</ul>
		<ul class="triple-info">
			<li>文件系统信息</li>			
			<c:forEach var="fileInfo" items="${requestScope.fileInfoList}">
			<li class="border-top">
				${fileInfo.devName}盘		
			</li>
			<li class="clearfix">
				<span class="left">总量</span>
				<span class="center">已用</span>
				<span class="right">可用</span>
			</li>
			<li class="clearfix">
				<span class="left blackc">${fileInfo.total }</span>
				<span class="center blackc">${fileInfo.used }</span>
				<span class="right blackc">${fileInfo.avail }</span>
			</li>
			</c:forEach>
		</ul>
	</div>
	<div class="cpu" id="cpu_info">
		<div class="cpu-title"><span><i class="jf-btn-CPU"></i></span>CPU信息</div>
		<ul class="double-info">
			<li class="clearfix">
				<span class="item">CPU型号</span>
				<span class="infor">${requestScope.cpuInfo.model }</span>
			</li>
			<li class="clearfix">
				<span class="item">CPU厂商</span>
				<span class="infor">${requestScope.cpuInfo.vendor }</span>
			</li>
			<li class="clearfix border-top">
				<span class="item">CPU用户使用率</span>
				<span class="infor blackc">${requestScope.cpuInfo.cpuUser }</span>
			</li>
			<li class="clearfix">
				<span class="item">CPU空闲率</span>
				<span class="infor blackc">${requestScope.cpuInfo.cpuIdle }</span>
			</li>
			<li class="clearfix">
				<span class="item">CPU数目</span>
				<span class="infor blackc">${requestScope.cpuInfo.cpuNum }</span>
			</li>
			<li class="clearfix">
				<span class="item">CPU等待率</span>
				<span class="infor blackc">${requestScope.cpuInfo.cpuWait }</span>
			</li>
			<li class="clearfix">
				<span class="item">CPU系统使用率</span>
				<span class="infor blackc">${requestScope.cpuInfo.cpuSys }</span>
			</li>
			<li class="clearfix">
				<span class="item">CPU总使用率</span>
				<span class="infor blackc">${requestScope.cpuInfo.cpuCombined }</span>
			</li>
		</ul>
	</div>
	<div class="java" id="java_info">
		<div class="java-title"><span><i class="jf-btn-memory"></i></span>Java&内存信息</div>
		<ul class="double-info">
			<li class="clearfix">
				<span class="item">JVM名称</span>
				<span class="infor">${requestScope.serverInfo.vmName }</span>
			</li>
			<li class="clearfix">
				<span class="item">JVM厂商</span>
				<span class="infor">${requestScope.serverInfo.vmVendor }</span>
			</li>
			<li class="clearfix">
				<span class="item">JDK版本号</span>
				<span class="infor">${requestScope.serverInfo.jdkVersion }</span>
			</li>
			<li class="clearfix">
				<span class="item">JVM版本号</span>
				<span class="infor">${requestScope.serverInfo.vmVersion }</span>
			</li>			
		</ul>		
		<ul class="triple-info">
			<li>
				JVM内存			
			</li>
			<li class="clearfix">
				<span class="left">最大内存</span>
				<span class="center">分配内存</span>
				<span class="right">空闲内存</span>
			</li>
			<li class="clearfix">
				<span class="left blackc">${requestScope.memInfo.jMax }</span>
				<span class="center blackc">${requestScope.memInfo.jTotal }</span>
				<span class="right blackc">${requestScope.memInfo.jFree }</span>
			</li>
			<li class="border-top">
				物理内存				
			</li>
			<li class="clearfix">
				<span class="left">总量</span>
				<span class="center">已用</span>
				<span class="right">可用</span>
			</li>
			<li class="clearfix">
				<span class="left blackc">${requestScope.memInfo.total }</span>
				<span class="center blackc">${requestScope.memInfo.used }</span>
				<span class="right blackc">${requestScope.memInfo.free }</span>
			</li>
			<li class="border-top">
				交换内存				
			</li>
			<li class="clearfix">
				<span class="left">总量</span>
				<span class="center">已用</span>
				<span class="right">可用</span>
			</li>
			<li class="clearfix">
				<span class="left blackc">${requestScope.memInfo.sTotal }</span>
				<span class="center blackc">${requestScope.memInfo.sUsed }</span>
				<span class="right blackc">${requestScope.memInfo.sFree }</span>
			</li>
		</ul>
	</div>
</div>
<script>
	$(function(){
		var mHeight = $("#server_info").height()
		if(mHeight>580){
			$("#cpu_info").height(mHeight)
			$("#java_info").height(mHeight)
		}
	})
</script>
</body>
</html>