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
<sc:fieldset name="子菜单修改/删除">
	<form method="post" action="/httpprocesserservlet">
		<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
		<input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
		<input type="hidden" name="actions" value="<sc:fmt value='updateMenu' type='crypto'/>">
		<% if (request.getParameter("pmenuid")==null) { %>
		<input type="hidden" name="forward" value="/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMenuListBySubSysID' type='crypto'/>&level=<%=request.getParameter("level")%>&subsysid=<%=request.getParameter("subsysid")%>&forward=<sc:fmt value='/pcmc/sm/updateMenuList.jsp' type='crypto'/>">
		<% } else { %>
		<input type="hidden" name="forward" value="/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMenuListBySubSysID' type='crypto'/>&level=<%=request.getParameter("level")%>&subsysid=<%=request.getParameter("subsysid")%>&pmenuid=<%=request.getParameter("pmenuid")%>&forward=<sc:fmt value='/pcmc/sm/updateMenuList.jsp' type='crypto'/>">
		<% } %>
	
		<!-- 子菜单列表面板 -->
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<tr><th colspan="10">子菜单列表</th></tr>
			<tr>
			<%
			    if (dataList != null){
			        for (int i=0;i<dataList.size();i++){
			            Element recordElement = (Element)dataList.get(i);
			            String menuid =recordElement.getChildTextTrim("menuid");
			            String subsysid = recordElement.getChildTextTrim("subsysid");
			            String pmenuid = recordElement.getChildTextTrim("pmenuid");
			            String levelp = recordElement.getChildTextTrim("level");
			            String menuname = recordElement.getChildTextTrim("menuname");
			            String imgurl = recordElement.getChildTextTrim("imgurl");
			            String linkurl = recordElement.getChildTextTrim("linkurl");
			            String isinternet = recordElement.getChildTextTrim("isinternet");
			            String remark = recordElement.getChildTextTrim("remark");
			            String sortno= recordElement.getChildText("sortno");
			            if(imgurl==null || imgurl.length()==0){
			               imgurl="/images/noimage.gif";
			            }
			            if ((i!=0)&&(i%6==0)){
			%>
			</tr><tr>
			<%
			            }
			%>
			
				<td align=center><div onclick="sel(<%=i%>,'<%=menuid%>','<%=subsysid%>','<%=pmenuid%>','<%=levelp%>','<%=menuname%>','<%=imgurl%>','<%=linkurl%>','<%=isinternet%>','<%=remark%>','<%=sortno%>');" ondblclick="document.location.href = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getMenuListBySubSysID' type='crypto'/>&subsysid=<%=subsysid%>&pmenuid=<%=menuid%>&level=<%=level%>&forward=<sc:fmt value='/pcmc/sm/updateMenuList.jsp' type='crypto'/>';"  class=coolButton style='cursor:hand;height:34px;width:34px;margin:2px;'><img src='<%=imgurl%>'></div>
				<font id=link1><%=menuname+" 菜单ID:"+menuid%></font></td>
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
		
		<!-- 修改/删除子菜单面板 -->
		<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
			<sc:hidden name="menuid" />
			<sc:hidden name="subsysid" />
			<sc:hidden name="level" />
			<tr><th colspan="10">修改/删除子菜单</th></tr>
			<tr>
			    <td class='form-label'><font color="red">*</font>菜单名称：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="menuname" req="1" displayname="菜单名称"></td>
			</tr>
			<tr>
			    <td class='form-label'>超链接地址：</td>
			    <td class=''><input type="text" class="inputtext" name="linkurl" req="0" displayname="超链接地址"></td>
			</tr>
			<tr>
			    <td class='form-label'>是否公网发布：</td>
			    <td class='form-value'><input type="radio" name="isinternet" value="1">是&nbsp;&nbsp;<input type="radio" name="isinternet" value="0" checked>否</td>
			</tr>
			<tr>
			    <td class='form-label'>备注：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="remark" req="0" displayname="备注" width="100%"></td>
			</tr>
			<tr>
			    <td class='form-label'><font color="red">*</font>显示序号：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="sortno" req="1" displayname="显示序号" width="100%" customtype="int">(Exp:1,2,3...99)</td>
			</tr>
			<tr>
			    <td class='form-label'>上级菜单ID：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="pmenuid" req="1" displayname="上级菜单ID" width="100%" customtype="int" onchange="update();"></td>
			</tr>
			<tr>
			    <td class='form-label'><font color="red">*</font>图片地址：</td>
			    <td class='form-value'><input type="text" class="inputtext" name="imgurl" req="1" displayname="图片地址"></td>
			</tr>
			<tr>
		        <td colspan="4" class="form-bottom">
		            <sc:button value="保存"  onclick="save();" />
		            <sc:button value="删除" _class="delete" onclick="doDelete();" />
		            <sc:button value="返回" onclick="history.go(-1);"/>
		        </td>
		    </tr>
		</table>
	</form>
</sc:fieldset>
</body>
<Script language="JavaScript">
function save(){
	document.forms[0].actions.value='<sc:fmt value='updateMenu' type='crypto'/>';
	if (checkForm(document.forms[0])){
		document.forms[0].submit();
	}
}

function doDelete(){
	document.forms[0].actions.value='<sc:fmt value='deleteMenu' type='crypto'/>';
	if (confirm('你确定要删除此菜单？')) document.forms[0].submit();
}

function sel(x,menuid,subsysid,pmenuid,level,menuname,imgurl,linkurl,isinternet,remark,sortno){
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
   document.forms[0].menuid.value = menuid;
   document.forms[0].subsysid.value = subsysid;
   document.forms[0].pmenuid.value = pmenuid;
   document.forms[0].level.value = level;
   document.forms[0].menuname.value = menuname;
   document.forms[0].imgurl.value = imgurl;
   document.forms[0].linkurl.value = linkurl;
   document.forms[0].isinternet.value = isinternet;
   document.forms[0].remark.value = remark;
   document.forms[0].sortno.value = sortno;
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