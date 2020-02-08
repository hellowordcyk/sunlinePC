<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.util.ITEMS"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="org.jdom.*"%>
<html>
<head>	
	<%@ include file="/common.jsp"%>
</head>
<body>
<%
   Document xmlDoc = (Document) request.getAttribute("xmlDoc");
   Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
%>
<sc:fieldset name="角色维护">
	<form name="form" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
		<input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
		<!--<input type="hidden" name="actions" value="<sc:fmt value='updateRole' type='crypto'/>">-->
		<input type="hidden" name="actions" value="<sc:fmt value='updateRoleNew' type='crypto'/>">
		
		<input type="hidden" name="forward" value="/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getRoleDetail' type='crypto'/>&roleid<%=record.getChildText("roleid")%>=&forward=<sc:fmt value='/pcmc/sm/RoleDetail.jsp' type='crypto'/>">
		<input type="hidden" name="roleid" value="<%=record.getChildText("roleid")%>">

		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<tr><th colspan="4">修改角色信息</th></tr>
			<tr>
		        <sc:text dsp="td" name="rolename" dspName="角色名称" req="1" xmlpath="/Response/Data/Record" />
		    </tr>
		   <tr>
		    	<td class="form-label">所属系统：<font color="red">*</font></td>
		        <td class="form-value">
		            <sc:select name="subsysid" type="subsys" index="1" attributesText="class='inputselect'"></sc:select>       

		        </td>
		    </tr>
		    <tr> 
		    	<td class="form-label">管辖机构类型：</td>
		        <td class="form-value">
		            <sc:select name="gorgtype" type="knp" key="pcmc,rlorgtp" index="1" includeTitle="false" nullOption="---请选择---" attributesText="class='inputselect'"></sc:select>       
		        </td>
			</tr>
		    <tr>
				<td class="form-label">所属部门：</td>
		        <td class="form-value">
	                <sc:hidden index="1" name="brchno" />
                    <c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMaps[0].deptid}">
	                  <sc:hidden name="deptid" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].deptid}" />
                    </c:if>
                    <c:if test="${empty jrafrpu.rspPkg.rspRcdDataMaps[0].deptid}">
	                  <input type="hidden" name="deptid" value="-1" />
                    </c:if>
	                <sc:text name="deptname" dspName="所属部门" attributesText="readonly='readonly'"  index="1"/>
	                <input type="button" id="#" name="img_search" onclick="getDept();" src="" class="search" />
		        </td>
		    </tr>
		    <tr>
		    	<td class="form-label">备注：</td>
		        <td class="form-value">
		            <textarea name="remark" class="inputarea" rows="4" cols="70%"><%=record.getChildText("remark")%></textarea>       
		        </td>
		    </tr>
		    <tr>
		        <td colspan="4" class="form-bottom">
		            <sc:button value="保存" onclick="saveOk();"/>
		            <sc:button value="重置" type="reset"/>
		            <sc:button value="返回" onclick="history.go(-1);"/>
		        </td>
		    </tr>
		</table>
	</form>
</sc:fieldset> 
</body>
<Script language="JavaScript">
function saveOk(){
    if (!checkForm(document.forms[0])){
        return false;
    }
    document.forms[0].submit();
}
function getDept(){
    var oForm = document.forms["form"];
    var receiveDept = oForm.elements("deptname").value;
    var receiveDeptid = oForm.elements("deptid").value;
    //var urlStr = '/public/pbSelDept.jsp?receiveDept='+receiveDept+'&receiveDeptid='+receiveDeptid+'&multi=0';
    var urlStr = '/pcmc/picker/deptPicker.jsp?multi=0&receivedeptid='+receiveDeptid;
    var w = openModal(urlStr,650,450);
    if(w !=null)
    {
        oForm.elements("deptid").value = w[0].deptid;//部门id
        oForm.elements("brchno").value = w[0].deptid;//部门编号
        oForm.elements("deptname").value = w[0].deptname;//部门名称
    }
}
</Script>
</html>
