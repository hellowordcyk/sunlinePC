<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="com.sunline.jraf.util.PkgUtil" %>
<html>
<head>
    <%@ include file="/common.jsp" %>
    <%
        com.sunline.jraf.web.RequestParamUtil rpu=null;
        if(session.getAttribute("encoding")==null
    		||((String)session.getAttribute("encoding")).length()==0){
   		 rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, "UTF-8");
   		}else{
   		 rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, (String)session.getAttribute("encoding"));
   		}
  	%>
    <%
		//请求参数定义
		String sysName = Crypto.encode(request, "pcmc");
		String oprID = Crypto.encode(request, "smParameter");
		String actions_unload = Crypto.encode(request, "unloadMenus");
		String actions_load = Crypto.encode(request, "loadMenus");
		String unloadUrl=null;
		PkgUtil reqpkg=null;
		if (rpu.getXmlDoc() != null) {
			reqpkg = new PkgUtil(rpu.getXmlDoc());
			String filename = reqpkg.getRspDataStr("filename");
			if(filename!=null){
				unloadUrl="/public/downloaddatafile.jsp?filename="+filename;
			}
		}
	%>
</head>
<body>
<sc:fieldset name="系统菜单导入导出">
	<form action="/pcmc/sm/menuUnload.so" method="post" enctype="multipart/form-data">
		<sc:hidden name="sysName" value="<%=sysName%>" />
	    <sc:hidden name="oprID" value="<%=oprID%>" />
	    <sc:hidden name="actions" value="<%=actions_unload%>" />
		
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<tr>
    			<td class='form-label'>选择子系统：</td>
    			<td class='form-value'>
    				<sc:select name="subsysid" default="all" type="subsys" key="">
        				<sc:option value="">--请选择子系统--</sc:option>
       				</sc:select>
    			</td>
    		</tr>	
    		<tr>
    			<td class='form-label'>导入文件:</td>
    			<td class='form-value'><input class="inputfile" type="file" name="tempdoc" size="50"/></td>
    		</tr>
       		<tr>
			    <td colspan="4" class="form-bottom" align="center">
			   	    <sc:button value="导入" onclick="doload();"/>
				    <sc:button value="导出" onclick="dounload();" />
			     	<sc:button value="返回" onclick="goBack();"/>
			    </td>
			</tr>
			<% if(unloadUrl != null){ %>
          	<tr>
          		<td align="center">导出文件已生成，请<a href="<%=unloadUrl%>" target="_blank"><font color="blue">下载文件</font></a></td>
          	</tr>
           	<% } %>
		</table>
	</form>
</sc:fieldset>
</body>
<script language="javascript">
function goBack() {
    history.go(-1);
}
  
function dounload(){
	if(document.forms[0].subsysid.value == ""){
		alert("请选择需要导出的子系统！");
		return;
	}
	document.forms[0].actions.value='<%=actions_unload%>';
	document.forms[0].submit();
}
  
function doload(){
	if(document.forms[0].subsysid.value == ""){
		alert("请选择需要导入的子系统！");
		return;
	}
	var docValue = document.forms[0].tempdoc.value;
	if(docValue == ""){
		alert("请选择导入的菜单文件！");
		return;
	}
	if(docValue.lastIndexOf(".xml") == -1){
		alert("导入的菜单文件不符合模板要求！");
		return;
	}
  	var ret = confirm("导入时会全量覆盖现有菜单，是否继续？");
  	if(ret){
  		document.forms[0].actions.value='<%=actions_load%>';
		document.forms[0].submit();
  	}
}
</script>
</html>