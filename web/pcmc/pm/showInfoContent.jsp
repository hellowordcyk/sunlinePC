<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%--@ page import="com.sunline.bimis.pcmc.util.ITEMS" --%>
<%--@ page import="com.sunline.bimis.pcmc.util.DeptUtil" --%>
<html>
<head>
    <title>
             日志xmlDoc
    </title>
    <%@ include file="/common.jsp"%>
</head>
<body>
<%--
<sc:form name="frmcog" action="/xmlprocesserservlet" sysName="eccs" oprID="dcsm_atch_query" actions="addAtch" forward="/datacenter/dcsm/query_dcsmatch.jsp" method="post">
 --%>
<table width="100%" cellpadding="0" cellspacing="0" class="form-table">

    <tr><th colspan="4"> 日志xmlDoc</th></tr>
	<tr>
		<td colspan="4">
		
			<sc:textarea name="content" xmlpath="/Response/Data" cols="90" rows="30"  req="0" index="1"/>
		</td>
		
	</tr>
	<tr>	
        <td colspan="4" class="form-bottom">
            <sc:button value="关闭" onclick="window.close();"/>
        </td>
    </tr>
</table>
</sc:form>
</body>
<script language="javascript">

</Script>
</html>
