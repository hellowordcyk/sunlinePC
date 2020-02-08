<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.governor.bean.*" %>
 <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page import="java.util.ArrayList"%>
<%
  ArrayList<SysBean>  sysBeanList = (ArrayList<SysBean>)request.getAttribute("sysBeanList");
%>
<div id="tab">
	<ul id="menusa-tab">
	<c:forEach items='<%=sysBeanList%>' var='pitem'>
	  <li style="height:26px;" targetid="${pitem.name}">${pitem.cnname }</li>
	</c:forEach>
	</ul>
	<c:forEach items='<%=sysBeanList%>' var='pitem'>
	<div class="content" id="${pitem.name}"></div>
	</c:forEach>
</div>
<script type="text/javascript" defer="defer">
var displayID=new Object();
var displayName=new Object();
var sysBeanListSize =<%=sysBeanList.size()%>;
<c:forEach items='<%=sysBeanList%>' var='pitem'>
	displayID.${pitem.name}='${pitem.name}';
	displayName.${pitem.cnname}='${pitem.cnname}';
</c:forEach>
	
/** 去掉逗号**/
var parserTab = new Jraf.Tabs({
	tabid:			"menusa-tab",
	displayStyle:	"div",
	displayID:       displayID,
	globalRefresh:   false   // 是否清空其他页签面板标志
}); 
var arr = new Array();
var i =1;
for(var p in displayName){/*获取中文名称*/
arr[i]=displayName[p];
i++;
}

var arrname = new Array();
var j =1;
for(var p in displayID){/*获取英文名称*/
arrname[j]=displayID[p];
j++;
}
init();
/* 初始化界面 */
function init() {
    for(var i=0;i<sysBeanListSize;i++){ 
    	parserTab.addAction(i+1, {url: '/governor',subname:arrname[i+1],title:arr[i+1],flag:'tabsystask'});
    }
	parserTab.init(1);
};


</script>