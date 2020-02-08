<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>查看流程配置</title>
</head>
<body>
<sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="flowActor" actions="queryFlowDetl">
	<!-- 流程配置部分 -->
	<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
		<tr><th colspan="4">流程配置</th></tr>
		<tr>
        	<sc:text name="flowna" dspName="流程名称" dsp="td" req="1" index="1" attributesText="readOnly" />
        	<sc:select name="isclos" dspName="是否允许挂靠" type="dict" key="pcmc,boolflag" includeTitle="false" dsp="td" index="1" attributesText="disabled='true'" />
   		</tr>
   		<tr>
   			<sc:text name="begndt" dspName="有效开始时间" dsp="td" req="1" index="1" attributesText="readOnly" />
   			<sc:text name="overdt" dspName="有效结束时间" dsp="td" index="1" attributesText="readOnly" />
   		</tr>
   		<tr>
   			<sc:textarea name="remark" dspName="备注" cols="30%" rows="4" dsp="td" index="1" attributesText="contentEditable='false'" />
   		</tr>
	</table>
	<!-- 流程过程配置部分 -->
	<div style="width:100%" class="page-title"><span class="title">流程过程配置</span>
	<table width="100%" cellpadding="0" cellspacing="0" class="list-table">
		<tr>
		    <td>
		    <div id="recodeDiv" style="height:350px;overflow:auto">
			    <display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet" sort="list">
					<display:column property="detlpo" title="过程位置" />
					<display:column property="detlcd" title="过程代码" />
					<display:column property="detltp" title="过程类型" />
					<display:column property="detlds" title="过程描述" />
				</display:table>
			</div>
			</td>
		</tr>
	</table>
	</div>
	<div style="width:100%" align="center" class="page-bottom">
	    <sc:button value="退出" onclick="quit()"/>
    </div>
</sc:form>
</body>
<script type="text/javascript">
/**
 * ======================================================================================================================
 * 查看流程配置界面方法 		作者：曾慧磊		日期：2011-12-26
 * ======================================================================================================================
 */
/* 按钮事件 */
/** 退出 */
function quit() {
	window.close();
}
</script>
</html>