<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.util.MenuUtil"%>
<%@ page import="com.sunline.jraf.util.Crypto"%>
<html>
<head>
<%@ include file="/common.jsp" %>
<STYLE>
    BODY,TD{ font-size: 9pt;  }
    .clsNoExpand { list-style-image: url('/images/solid.gif'); }
    .clsItemShow { list-style-image:url('/images/treenode_minus.gif'); cursor: hand; font-family: "Arial", "Helvetica", "sans-serif"; font-size: 12px; font-weight: normal; color: #000080; background-color: #eff0f1; line-height: 5mm }
    .clsItemHide { list-style-image:url('/images/treenode_plus.gif'); cursor: hand; font-family: "Arial", "Helvetica", "sans-serif"; font-size: 12px; font-weight: normal; color: #000080; background-color: #eff0f1; line-height: 5mm }
    .clsItemsShow1 { list-style-image:url('/images/treenode_solid.gif');font-family: "Arial", "Helvetica", "sans-serif"; font-size: 12px; font-weight: normal; color: #000080; background-color: #eff0f1; line-height: 5mm }
    UL.clsItemsShow { list-style-image:url('/images/treenode_solid.gif');font-family: "Arial", "Helvetica", "sans-serif"; font-size: 12px; font-weight: normal; color: #000080; background-color: #eff0f1; line-height: 5mm }
    UL.clsItemsHide { display:none;  }
</STYLE>
</head>
<BODY>
<form action="/xmlprocesserservlet" method="post">
<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
<input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
<input type="hidden" name="actions" value="<sc:fmt value='addShortCuts' type='crypto'/>">
<%--<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/pcmc/sm/shortCutList.jsp' />"> --%>
<input type="hidden" name="subsysid" value="<%=request.getParameter("subsysid")%>">
<input type="hidden" name="roleid" value="<%=request.getParameter("roleid")%>">
<TABLE cellSpacing=0 cellPadding=0 width="98%" align=center border=0>
<TBODY>
<TR>
<TD vAlign=top width="100%">
<FIELDSET>
<LEGEND>
<TABLE cellSpacing=0 cellPadding=0 width=100 bgColor=#E0F0F0 border=0>
<TBODY>
<TR><TD style="PADDING-TOP: 2px" align=middle background="/images/login_title_bg.gif" height=18><FONT color=#ffffff>快捷菜单维护</FONT></TD></TR>
</TBODY>
</TABLE>
</LEGEND>
<table border="0" width="100%" height="4" cellspacing="0">
<% if (request.getAttribute("ERROR_TEXT")!=null) { %>
<tr align="center"><td><font color="red"><%=request.getAttribute("ERROR_TEXT")%></font></td></tr>
<% } %>
</table>
<table width="99%" border="0" align="center" cellpadding="4" cellspacing="0">
<tr>
<td width="100%" valign="top">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#EFF0F1" class="form-table">
	<tr><th colspan="4">菜单信息</th></tr>	
    <tr><td>
        <table border="0" width="100%" height="4" cellspacing="1">
            <tr class="sysdisplay"><td>
            <%
                out.println(MenuUtil.getShortCutMenuHtmlTree(request.getParameter("subsysid"),(String)session.getAttribute("userid"),request.getParameter("roleid")));
            %>
            </td></tr>
        </table>
    </td></tr>
    <tr>
		<td colspan="4" class="form-bottom" align="center">
			<input id="saveBtn" type="button" class="button" value="保存" onclick="saveOk();">&nbsp;&nbsp;
        	<input type="reset" class="button" value="重置">&nbsp;&nbsp;
        	<input type="button" class="button" value="关闭" onclick="javascript:window.close();">
		</td>
	</tr>	
    </table>
</td>
</tr>

</table>
</FIELDSET>
</TD>
</TR>
</TBODY>
</TABLE>
</form>
</body>
</html>
<Script language="JavaScript">
var cTime = new Date();
function  OnItemClick( )
{
    var dtNow = new Date();
    dd = dtNow.getTime() - cTime.getTime();
    if( dd < 500 )
    {
        return;
    }
    cTime = dtNow;
    var c = window.event.srcElement.id.substring(window.event.srcElement.id.length-1,window.event.srcElement.id.length);
    if (c=="")
    {
        return;
    }
    if( window.event.srcElement.className == "clsItemsShow1" )
    {
        window.event.srcElement.className = "clsItemsShow1";
        return;
    }
    if( window.event.srcElement.className == "clsItemShow" )
    {
        window.event.srcElement.className = "clsItemHide";
        document.all( window.event.srcElement.id + 'u').className = "clsItemsHide";
    }
    else
    {
        window.event.srcElement.className = "clsItemShow";
        document.all( window.event.srcElement.id + 'u' ).className = "clsItemsShow";
    }
}
function saveOk()
{
	$("saveBtn").disabled = true;
    var formObj = document.forms[0];
    if (!checkForm(formObj)) {
        return;
    }
    var ajax = new Jraf.Ajax();//初始化ajax
	ajax.submitFormXml(formObj,function(xml){
	try{
		$("saveBtn").disabled = false;
		var pkg = new Jraf.Pkg(xml);
		if(pkg.result() != '0'){
			Jraf.showMessageBox({title: "提示异常", text: "<span class='error'>" + '异常：' + pkg.allMsgs('<br>') + "</span>"});
			return;
		}
		Jraf.showMessageBox({text: "<span class='success'>保存成功！</span>"});
		window.returnValue=true;
	}catch(e){
			Jraf.showMessageBox({title: "保存异常", text: "<span class='error'>" + e + "</span>"});
		}
	});
}
function selectMenu()
{
	var idstr, flag;
	idstr = event.srcElement.parentNode.id;
    parentul = event.srcElement.parentNode.parentNode;
    ulstr = parentul.id;
    if (event.srcElement.checked)
    {
        while (ulstr)
        {
            var chkps = document.getElementById(ulstr.substring(0,ulstr.length-1)).getElementsByTagName("input");
            chkps[0].checked = event.srcElement.checked;
            parentul = parentul.parentNode.parentNode;
            ulstr = parentul.id;
        }
    }
    if (document.getElementById(idstr +'u')!=null)
    {
        var chks = document.getElementById(idstr +'u').getElementsByTagName("input");
        for(var k=0; k<chks.length; k++) {
            if(chks[k].type && chks[k].type=="checkbox") {
                chks[k].checked = event.srcElement.checked;
            }
        }
    }
}
</Script>
