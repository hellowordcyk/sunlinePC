<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ page import="java.util.List"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<% request.setCharacterEncoding("UTF-8"); %>
	<%
	    Document reqXml = HttpProcesser.createRequestPackage("pcmc","sm_query","getSubSysList");
	    Document repXml = SwitchCenter.doPost(reqXml);
	    List dataList = repXml.getRootElement().getChild("Response").getChild("Data").getChildren("Record");
	%>
</head>
<body>
<sc:fieldset name="子系统/菜单新增">
	<form method="post" action="/httpprocesserservlet">
		<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
		<input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
		<input type="hidden" name="actions" value="<sc:fmt value='addSubSys' type='crypto'/>">
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/pcmc/sm/subSysList.jsp' />">
		<!-- 子系统列表面板 -->
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<tr><th colspan="10">子系统列表</th></tr>
			<tr>
				<%
				    if (dataList != null){
				        for (int i=0;i<dataList.size();i++){
				            Element recordElement = (Element)dataList.get(i);
				            if ((i!=0)&&(i%6==0)){
				%>
			</tr>
			<tr>
				<%
				            }
				%>
				<td>
					<div onclick="sel(<%=i%>);" ondblclick="document.location.href = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMenuListBySubSysID' type='crypto'/>&subsysid=<%=recordElement.getChildTextTrim("subsysid")%>&cnname=<%=recordElement.getChildTextTrim("cnname")%>&level=0&forward=<sc:fmt value='/pcmc/sm/menuList.jsp' type='crypto'/>';"  class=coolButton style='cursor:hand;height:34px;width:34px;margin:2px;'><img src='/common/images/pcmc/subsystem.gif'></div>
            		<font id=link1><%=recordElement.getChildTextTrim("cnname")%></font>
				</td>
				<%
				      }
				      int remain = (6 - dataList.size() % 6) % 6;
				      for (int i=0;i<remain;i++){
				%>
				<td></td>
				<%
				      }
				   }
				%>
			</tr>
		</table>
		<!-- 新增子系统面板 -->
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
				<tr><th colspan="10">新增子系统</th></tr>
				<tr>
			        <sc:text dsp="td" name="shortname" dspName="英文简写" req="1"/>
			    </tr>
			    <tr>
			        <sc:text dsp="td" name="enname" dspName="英文名称" req="1"/>
			    </tr>
			    <tr>
			        <sc:text dsp="td" name="cnname" dspName="中文名称" req="1"/>
			    </tr>
			    <tr>
			        <sc:text dsp="td" name="linkurl" dspName="主页地址" req="1"/>
			    </tr>
			    <tr>
			    	<td class='form-label'>公共信息页面：</td>
			    	<td class='form-value'>
						<input type="text" name="pubinfourl"  req="1"  displayname="公共信息页面"  class="inputtext" value="" />
					</td>
			    </tr>
			    <tr>
			    	<td class='form-label'><font color='red'>*</font>显示序号：</td>
			    	<td class='form-value'>
						<input type="text" name="orderidx"  req="1"  displayname="显示序号"  class="inputtext" />(Exp:1,2,3...99)
					</td>
			    </tr>
			    <tr>
			        <sc:text dsp="td" name="imgurl" dspName="图片地址" req="1"/>
			    </tr>
			    <tr>
			        <td colspan="4" class="form-bottom">
			            <sc:button value="保存" onclick="if (checkForm(document.forms[0])) submit();"/>
			            <sc:button value="重置" type="reset"/>
			            <sc:button value="返回" onclick="history.go(-1);"/>
			        </td>
			    </tr>
			</table>
	</form>
</sc:fieldset>
</body>
<Script language="JavaScript">
function sel(x){
   var flashlinks=document.all.link1;
   if(flashlinks.length==null)
      flashlinks[0]=document.all.link1;
   else
      for(i=0;i<flashlinks.length;i++){
		flashlinks[i].style.backgroundColor="";
  		flashlinks[i].style.color="#000000";
      }
  flashlinks[x].style.backgroundColor="blue";
  flashlinks[x].style.color="#ffffff";
  return true;
}
<%
    if (request.getAttribute("ERROR_TEXT")!=null){
%>
        alert("<%=request.getAttribute("ERROR_TEXT")%>");
<%
    }
%>
</Script>
</html>