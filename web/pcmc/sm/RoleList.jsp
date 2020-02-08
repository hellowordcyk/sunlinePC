<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.jdom.*"%>
<%@page import="com.sunline.jraf.services.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.sunline.jraf.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="/common.jsp" %>
</head>
<body>
	<!--<sc:showrsmsg />-->
	<!-- 查询面板 -->
	<sc:form action="/pcmc/sm/RoleList.so" forward="/pcmc/sm/RoleList.jsp" oprID="sm_query" sysName="pcmc" name="query_form" actions="getRoleList" method="post">
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
    		<tr><th colspan="4">查询条件</th></tr>
    		<tr>   	 
	   			<td class='form-label'>子系统：</td>
	   			<td class='form-value'>
	   				<sc:select name="subsysid" default="all" type="subsys" key="" >
	       				<sc:option value="all">--所有子系统--</sc:option>
	      				</sc:select>
	   			</td>
    			<sc:text name="rolename" dspName="角色名称" dsp="td" />
    		</tr>
    		<tr>
			     <td colspan="4" class="form-bottom" align="center">
			      	<sc:button value="查询" name="dosubmit" onclick="doSearch();"/>
			     	<sc:button value="重置" onclick="reSet();"/>
			     </td>
			</tr>
		</table>
	</sc:form>
	<sc:form action="/pcmc/sm/RoleList.so" sysName="pcmc" name="page_form" oprID="sm_query" actions="getRoleList" method="post">
		<sc:hidden name="subsysid" />
		<sc:hidden name="rolename" />
	   <display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet">
			<display:column  title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
                <input type="checkbox" name="roleid" onclick="outlineMyRow(this)" value="${record.roleid}"/>
            </display:column>  
			<display:column title="序号" style="width:2%;text-align:center"><sc:fmt value="${record_rowNum}"/></display:column>
			<display:column style="width:25%;text-align:left" property="rolename" title="角色名称" sortable="false" paramId="roleid" paramProperty="roleid" />
			<display:column style="width:20%;text-align:left" property="cnname" title="所属系统" sortable="false" />
			<display:column style="width:40%;text-align:center" property="parana" title="管辖机构类型" />
			<display:column style="width:10%;text-align:center" title="角色明细">
			    <input type="button" name="rolede" onclick="toRoledetail('${record.roleid }');" value="角色明细" class="button"/>
			</display:column>
			<display:footer>
	              <tr>
	           
	                  <td colspan="6">
	                      <div class="operator" >
		                   <sc:button value="新增" _class="add" onclick="add();"/> 
		                   <c:if test="${not empty record}">
			                   <sc:button value="删除" _class="delete" onclick='doDelete();'/>
			             	  </div>
			              	 <%@ include file="/include/pager.jsp" %>
			               </c:if>
	                  </td>
	              </tr>
	           </display:footer>
	</display:table>
	</sc:form>
</body>
<Script language="JavaScript">
function doSearch(){
	var formObj = document.forms["query_form"];
	if(!checkForm(formObj)){
	    return false;
	}
	formObj.elements("dosubmit").disabled=true;
	formObj.submit();
}
/*重置*/
function reSet(){
	document.getElementsByName("rolename")[0].value="";
}
function toRoledetail(obj){
    document.location = "/pcmc/sm/RoleDetail.jsp?roleid="+obj;
}

function add(){
    document.location = "/pcmc/sm/RoleAdd.jsp";
}

function doDelete(){
	var formObj = document.forms("page_form");
	formObj.elements("oprID").value = "<sc:fmt value='sm_maintenance' type='crypto'/>";
	formObj.elements("actions").value = "<sc:fmt value='deleteRole' type='crypto'/>";
	var obj = $$("input[name='roleid']");
	var count=0;
	for(var i=0;i<obj.length;i++){
		if(obj[i].checked == true){	
			count++;		
		}
	}
	if(count<1){
		Jraf.showMessageBox({text: "<span class='info'>" + "请选择一条数据" + "</span>"});
	}
	
	else{
		for(var j = 0; j<obj.length;j++){
			if(obj[j].value == '1' && obj[j].checked == true){
				Jraf.showMessageBox({text: "<span class='info'>" + "系统管理员角色不可删除！" + "</span>"});
				return;
			}
		}
		Jraf.showMessageBox({
        text: '<span class="choose">是否删除所选数据</span>',
        onYes: function(){
         var formObj = document.forms["page_form"];
		 formObj.submit();
        },
        onNo: function(){},
        onOk: null
	});
	}
}
</Script>
</html>