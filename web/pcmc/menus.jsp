<%@ page import="com.sunline.bimis.pcmc.util.MenuUtil"%>
<%@ page import="java.util.ArrayList"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<Script language="JavaScript" src="/js/MenuControl.js" type=""></Script>
<Script language="JavaScript" type="">
<%
    String roleid = request.getParameter("roleid");
    String shortname = request.getParameter("shortname");
    ArrayList menuJsArray = MenuUtil.getMenuJsArray(request,shortname,roleid);
    for (int i=0;i<menuJsArray.size();i++)
    {
%>
<%=menuJsArray.get(i)%>
<%
    }
%>
</Script>
<style type="text/css">
<!--
table {
	font-size: 12px;
}
.navigation {
height:              25px;
background-image: url(/unknown.gif);
border-top:          1 solid #ffffff;
border-bottom:       1 solid #8b8b8b;
border-right:        1 solid #8b8b8b;
}
.navigation1 {
background-color:    #D3E7AF;
height:              22px;
border-top:          1 solid #ffffff;
border-bottom:       1 solid #ADB388;
border-right:        1 solid #ADB388;

}
.navigation2 {
border-top:          1 solid #ffffff;
border-bottom:       1 solid #DFE6E8;
border-right:        1 solid #DFE6E8;
height:100%;
}
.navigation3 {
border-top:          1 solid #C6CAAC;
border-left:         1 solid #C6CAAC;
border-bottom:       1 solid #ffffff;
border-right:        1 solid #ffffff;
}
.DropDownMenu {
	BORDER-RIGHT:    #F2F7E6 1px solid;
	BORDER-TOP:      #F2F7E6 1px solid;
	Z-INDEX: 210;
	BORDER-LEFT:     #F2F7E6 1px solid;
	BORDER-BOTTOM:   #F2F7E6 1px solid
}
legend {
background-color:    #FF9900;
border-top:          1 solid #f4f4f4;
border-left:         1 solid #f4f4f4;
border-bottom:       1 solid #aaaaaa;
border-right:        1 solid #aaaaaa;
}
fieldset{
	border-top:      1 solid #92A9C0;
	border-right:    1 solid #92A9C0;
	border-bottom:   1 solid #92A9C0;
	border-left:     1 solid #92A9C0;
}
.cjolbutton{
	border:      1 solid #D3E7AF;
}
a:link {color: #000000;	}
a:visited {color: #000000;}
.m0l0i {
	PADDING-BOTTOM: 6px;
	PADDING-LEFT: 1px;
	PADDING-RIGHT: 2px;
	PADDING-TOP: 1px;
	TEXT-DECORATION: none;
	width:100px;

}
.m0l0o {
	BORDER-BOTTOM: #457598 1px solid;
	BORDER-LEFT: #568CB4 1px solid;
	BORDER-RIGHT:#457598 1px solid;
	BORDER-TOP: #568CB4 1px solid;
	background-image: url(images/navigation_ico_2.gif);
	TEXT-DECORATION: none;
}
.m0l1i {
	FONT-SIZE: 12px;
	PADDING-BOTTOM: 4px;
	PADDING-LEFT: 4px;
	PADDING-RIGHT: 4px;
	PADDING-TOP: 1px;
	TEXT-DECORATION: none;
}
.m0l1o {
	BORDER-BOTTOM: #437396 1px solid;
	BORDER-LEFT: #6999BC 1px solid;
	BORDER-RIGHT: #437396 1px solid;
	BORDER-TOP: #6999BC 1px solid;
	TEXT-DECORATION: none;
}
.m0l2i {
	FONT-SIZE: 12px;
	PADDING-BOTTOM: 4px;
	PADDING-LEFT: 4px;
	PADDING-RIGHT: 4px;
	PADDING-TOP: 1px;
	TEXT-DECORATION: none;
}
.m0l2o {
	BORDER-BOTTOM: #437396 1px solid;
	BORDER-LEFT: #6999BC 1px solid;
	BORDER-RIGHT: #437396 1px solid;
	BORDER-TOP: #6999BC 1px solid;
	TEXT-DECORATION: none;
}-->
</style>
<html>
<body>
<table width="100%" height="20" border="0" cellpadding="2" cellspacing="0">
<tr height="20">
<%
    for (int i=0;i<menuJsArray.size();i++)
    {
%>
<td valign="bottom" width="70" id="menu<%=i%>">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr width="100%"><td style="position:relative" width="100%">
<Script language="JavaScript">
new menu (MENU_ITEMS<%=i%>, MENU_POS<%=i%>, MENU_STYLES1);
document.getElementById("menu<%=i%>").width = MENU_POS<%=i%>['width'][0] - 5;
</Script>
</td></tr>
</table>
</td>
<%
    }
%>
<td>&nbsp;</td>
</tr>
</table>
</body>
</html>
<Script language="JavaScript">
alert("
</Script>
