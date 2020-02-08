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
	    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
	    List dataList = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChildren("Record");
	    String level = request.getParameter("level");
	    level = Integer.toString(Integer.parseInt(level) + 1);
	%>
</head>
<body>
<sc:fieldset name="子系统/菜单新增">
	<form method="post" action="/httpprocesserservlet">
		<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
		<input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
		<input type="hidden" name="actions" value="<sc:fmt value='addMenu' type='crypto'/>">
		<% if (request.getParameter("pmenuid")==null) { %>
		<input type="hidden" name="forward" value="/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMenuListBySubSysID' type='crypto'/>&level=<%=request.getParameter("level")%>&subsysid=<%=request.getParameter("subsysid")%>&forward=<sc:fmt value='/pcmc/sm/menuList.jsp' type='crypto'/>">
		<% } else { %>
		<input type="hidden" name="forward" value="/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMenuListBySubSysID' type='crypto'/>&level=<%=request.getParameter("level")%>&subsysid=<%=request.getParameter("subsysid")%>&pmenuid=<%=request.getParameter("pmenuid")%>&forward=<sc:fmt value='/pcmc/sm/menuList.jsp' type='crypto'/>">
		<% } %>
		
		<!-- 子菜单列表面板 -->
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<tr><th colspan="10">子菜单列表</th></tr>
			<tr>
			<%
			    if (dataList != null){
			        for (int i=0;i<dataList.size();i++){
			            Element recordElement = (Element)dataList.get(i);
			            if ((i!=0)&&(i%6==0)){
			%>
			</tr><tr>
			<%
			            }
			%>
				<td align=center><DIV onclick="sel(<%=i%>);" ondblclick="document.location.href = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMenuListBySubSysID' type='crypto'/>&subsysid=<%=recordElement.getChildTextTrim("subsysid")%>&pmenuid=<%=recordElement.getChildTextTrim("menuid")%>&level=<%=level%>&forward=<sc:fmt value='/pcmc/sm/menuList.jsp' type='crypto'/>';"  class=coolButton style='cursor:hand;height:34px;width:34px;margin:2px;'><img src='<%=recordElement.getChildTextTrim("imgurl")%>'></div>
				<font id=link1><%=recordElement.getChildTextTrim("menuname")%></font></td>
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
		<!-- 新增子菜单面板 -->
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<input type="hidden" name="subsysid" value="<%=request.getParameter("subsysid")%>">
			<% if (request.getParameter("pmenuid")!=null) { %>
			<input type="hidden" name="pmenuid" value="<%=request.getParameter("pmenuid")%>">
			<% } %>
			<input type="hidden" name="levelp" value="<%=level%>">
			<tr><th colspan="10">新增子菜单</th></tr>
			
			<tr>
			    <td class='form-label'><font color="red">*</font>菜单名称：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="menuname" req="1" displayname="菜单名称" width="100%"></td>
			</tr>
			<% if ("1".equals(level)) { %>
			<input type="hidden" name="imgurl" value="/images/pcmc/module.gif">
			<% } else { %>
			<input type="hidden" name="imgurl" value="/images/pcmc/group.gif">
			<% } %>
			
			<tr>
			    <td class='form-label'>超链接地址：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="linkurl" req="0" displayname="超链接地址" width="100%"></td>
			</tr>
			<tr>
			    <td class='form-label'>是否公网发布：</td>
			    <td class='form-value'><input type="radio" name="isinternet" value="1">是&nbsp;&nbsp;<input type="radio" name="isinternet" value="0" checked>否</td>
			</tr>
			<tr>
			    <td class='form-label'>备注：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="pubinfourl" req="0" displayname="备注" width="100%"></td>
			</tr>
			<tr>
			    <td class='form-label'><font color="red">*</font>显示序号：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="sortno" req="1" displayname="显示序号" width="100%" customtype="int">(Exp:1,2,3...99)</td>
			</tr>
			<tr>
		        <td colspan="4" class="form-bottom">
		            <sc:button value="保存" onclick="if (checkForm(document.forms[0])) submit();" />
		            <sc:button value="重置" type="reset" />
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