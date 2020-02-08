<%--[updateBrchBtnId:修改机构;]--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp" %>
<%
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");

    List dataList = record.getChildren("Data");
    
%>
<html>
    <head>
        <title>修改部门信息</title>
    </head>
<body>
    <sc:form name="frmcog" action="/httpprocesserservlet" method="post" forward="/pcmc/sm/query_pcmcdept_subdeptproc.jsp">
        <input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
        <input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
        <input type="hidden" name="actions" value="<sc:fmt value='updateDept' type='crypto'/>">
        <input type="hidden" name="deptid" value="<%=record.getChildText("deptid")%>">
        <input type="hidden" name="pdeptid" value="<%=record.getChildText("pdeptid")%>">
        <input type="hidden" name="levelp" value="<%=record.getChildText("levelp")%>">

        <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#EFF0F1" class="form-table">
        <tr><th colspan="4">部门信息</th></tr>                                                                    
            <tr>
                <td width="20%" align="right" class="form-label">部门编号：<font color="red">*</font></td>
                <td class="form-value">
                    <input value="<%=record.getChildText("deptcode")%>" type="text" name="deptcode" class="inputtext"req="1" displayname="部门编号">
                    <span class="hint_info">部门的唯一编号</span>
                </td>
            </tr>
            <tr>
                <td width="20%" align="right" class="form-label">部门名称：<font color="red">*</font></td>
                <td class="form-value">
                    <input value="<%=record.getChildText("deptname")%>" type="text" name="deptname" class="inputtext" req="1" displayname="部门名称">
                </td>
            </tr>
            <tr>
                <td width="20%" align="right" class="form-label">联系人：<font color="red">*</font></td>
                <td class="form-value">
                    <input type="hidden" name="linkman" value="<%=record.getChildText("linkman")%>" maxlength=20 class="inputtext"  customtype="num" req="1" displayname="联系人" readonly>
                    <input type="text" name="linkm"  value="<%=record.getChildText("username")%>" maxlength=40 class="inputtext" displayname="联系人" readonly>
                    <img src="/common/images/pic01/sel_person.gif" border=0 align="absmiddle" style="CURSOR: hand" onClick="javascript:getPerson_linkman();">
                    <span class="hint_info">部门的联系人</span>
                </td>
            </tr>
            <tr>
                <sc:text dsp="td" name="phone" dspName="联系电话" req="1" type="phone" index="1" attributesText="maxLength='11'"/>
            </tr>
            <tr>
                <td width="20%" align=right class="form-label">备注：</td>
                <td class="form-value">
                    <textarea name="remark" class="inputarea" rows="4" cols="50"><%=record.getChildText("remark")%>
                    </textarea>
                </td>
            </tr>
            <tr>
                <td colspan="4" class="form-bottom" align="center">
                    <input type="button" id="saveBrchBtnId" class="button" name="save" value="保存" _jraf_sys_usersync onclick="saveOk();">&nbsp;&nbsp;
                    <input type="reset" class="button" name="reset" value ="重写" _jraf_sys_usersync >&nbsp;&nbsp;
                    <input type="button" class="button" value="关闭" onclick="window.close();">
                </td>
            </tr>    
        </table>
    </sc:form>
</body>
<Script language="JavaScript" defer="defer">
function saveOk()
{   
       var oForm = document.forms["frmcog"];
     if (!checkForm(oForm))
        {
            return false;
        }
    var reqparams = {
            sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
            oprID:         '<sc:fmt type="crypto" value="sm_maintenance"/>',
            actions:    '<sc:fmt type="crypto" value="updateDept"/>',
            pdeptid:    oForm.elements("pdeptid").value,
            deptid:        oForm.elements("deptid").value,
            deptcode:   oForm.elements("deptcode").value,
            deptname:   oForm.elements("deptname").value,
            linkman:     oForm.elements("linkman").value,
            phone:        oForm.elements("phone").value,
            levelp:        oForm.elements("levelp").value,
            remark:        oForm.elements("remark").value
    };
    var ajax = new Jraf.Ajax();
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
        try{    
               var pkg = new Jraf.Pkg(xml);
               if(pkg.result() != '0'){
                alert('修改部门出错！\n'+pkg.allMsgs());
                return;
            }
            Jraf.showMessageBox({
                          text: '<span class="success">修改成功！</span>'
                      });
            var deptcode = oForm.elements("deptcode").value;
            var deptname = oForm.elements("deptname").value;
            var results  = {
                            deptcode: deptcode,
                            deptname: deptname,
                            nodetype: "parentnode",
                            deptid:   oForm.elements("deptid").value,
                            pdeptid:  oForm.elements("pdeptid").value
                        };
            window.returnValue = results;
            window.close();
          
        }catch(e){alert('ERROR:'+e);}
     });    
}

    function getPerson_lead()
    {
        var tmp1 = document.frmcog.leader.value;
        var tmp= document.frmcog.lead.value;
        var urlStr = '/oams/public/pbSelPerson.jsp?deptid=&receiveuser='
                   + tmp+'&receiveuserid='+tmp1+'&multi=0' + "&s_time=" + (new Date().getTime());
        var w = openModal(urlStr,800,450);
        if(w !=null||w !=undefined)
        {
            document.frmcog.leader.value = w[0];
            document.frmcog.lead.value = w[1];
        }
    }

    function getPerson_people()
    {
        var tmp1 = document.frmcog.viceleader.value;
        var tmp= document.frmcog.people.value;
        var urlStr = '/oams/public/pbSelPerson.jsp?deptid=&receiveuser='+encodeURI(encodeURI(tmp))+'&receiveuserid='+tmp1+'&multi=1' + "&s_time=" + (new Date().getTime());
        var w = openModal(urlStr,800,450);
        if(w !=null||w !=undefined)
        {
            document.frmcog.viceleader.value = w[0];
            document.frmcog.people.value = w[1];
        }
    }

    function getPerson_filereceiver()
    {
        var tmp1 = document.frmcog.filereceiver.value;
        var tmp= document.frmcog.receiver.value;
        var urlStr = '/oams/public/pbSelPerson.jsp?deptid=&receiveuser='+encodeURI(encodeURI(tmp))+'&receiveuserid='+tmp1+'&multi=0' + "&s_time=" + (new Date().getTime());
        var w = openModal(urlStr,800,450);
        if(w !=null||w !=undefined)
        {
            document.frmcog.filereceiver.value = w[0];
            document.frmcog.receiver.value = w[1];
        }
    }

    function getPerson_linkman()
    {
        var tmp1 = document.frmcog.linkman.value;
        var tmp= document.frmcog.linkm.value;
        var urlStr = '/public/pbSelPerson.jsp?deptid=&receiveuser='+encodeURI(encodeURI(tmp))+'&receiveuserid='+tmp1+'&multi=0' + "&s_time=" + (new Date().getTime());
        var w = openModal(urlStr,800,450);
        if(w !=null||w !=undefined)
        {
            document.frmcog.linkman.value = w[0];
            document.frmcog.linkm.value = w[1];
        }
    }
</Script>
</html>