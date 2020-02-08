<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="/governor/common/common.jsp"%>
	<%
    	String sysName = Crypto.encode(request,"governor");
    	String oprID = Crypto.encode(request,"initConfig");
    	String actions = Crypto.encode(request,"listMenuAll");
    	StringBuffer urlBuf = new StringBuffer();
    	urlBuf.append("/governor/menu/menus.so?sysName=").append(sysName)
          	  .append("&oprID=").append(oprID)
              .append("&actions=").append(actions);
	%>
</head>
<body>
<sc:doPost var="sourceInfo" scope="request" sysName="governor" oprId="initConfig" action="isFirstLogin" ></sc:doPost>
<c:forEach var="sourceInfo" items="${sourceInfo.rspRcdDataMaps}">
<input id="isfirst" type="hidden" value='${sourceInfo.firstlogin }' />
</c:forEach>
<table id="mainTabId" width="100%" cellpadding="0" cellspacing="0" border="0" style="table-layout: fixed;">
	<tr>
		<td width="100%" valign="top">
			<table width="100%" height="400"  cellpadding="0" cellspacing="0" class="form-table" style="margin: 0; table-layout: fixed; border-style: none;">
				<tr>
					<th id="tabTitleId"><div><span style="float:left;">菜单列表</span><input class="add" style="float: right;margin-bottom:-1px;margin-top:0px;" id="con_guide" onclick="toGuide();" type="button" value="配置向导"/></div></th>
				</tr>
				<tr>
		        	<td valign="top" style="padding: 0px;">
		                <div id="quotalist" style="width: 100%;height: 360px;overflow:auto"></div>
		            </td>
		        </tr>
			</table>
		</td>
	</tr>
</table>
</body>
<script language="JavaScript">
new Jraf.DimensionsAuto(window, '#mainTabId', 'height', 0);
$("quotalist").setStyle({height: ($("mainTabId").getHeight() - $("tabTitleId").getHeight() - 1) + "px"});
	var ajax = new Jraf.Ajax();
	var jraftreemenu = new Jraf.SimpleTree({
        selector:'#quotalist',
        rootType: {//向nodeTypes中增加根节点类型参数
            sysName: '<sc:fmt type="crypto" value="governor"/>',
            oprID:   '<sc:fmt type="crypto" value="initConfig"/>',
            actions: '<sc:fmt type="crypto" value="listMenuAll"/>',
            onClick: viewItem
        }
    }
);
	
jraftreemenu.addNodes();

function viewItem(node){
	if(!node) return;
	var menu = node.tag;
	var subsysid = menu.subsysid;
	var menuname = menu.menuname;
	var rightTopHtml = '<ul><li><a>您当前位置：</a></li><li><a><span class="current">'+menuname+'</span></a></li></ul>';
    top.frames("bodyFrame_all").frames("rightFrame").frames("topFrame").window.document.getElementById("pagetip").innerHTML = rightTopHtml;
    var linkurl = "initPanel.jsp?subsysid="+subsysid;
    if (linkurl.indexOf("?") != -1) {
        linkurl += '&s_time='+(new Date().getTime());
    } else {
        linkurl += '?s_time='+(new Date().getTime());
    }
	top.frames("bodyFrame_all").frames("rightFrame").frames("bodyFrame").window.location.href = linkurl;
}

init();
function init() {
	var flage = document.getElementById("isfirst").value;
	if(flage=='1'){
		toGuide();
	}
}

/**
 * 弹出向导页面
 */
function toGuide() {
	var url = "/governor/initguide/initConfigGuide.jsp";
	openModalToIframe(url);
}
</script>
</html>