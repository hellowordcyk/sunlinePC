<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.*" %>
<%
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");

    List dataList = record.getChildren("Data");
    
    //List peopleList = ((Element)dataList.get(0)).getChildren("Record");
    //String viceleader = "";
    //String people = "";
    //for (int i=0;i<peopleList.size();i++) {
    //    Element ele = (Element)peopleList.get(i);
    //    viceleader = viceleader + ele.getChildTextTrim("peopleid")+",";
    //    people = people + ele.getChildTextTrim("empyna") + ",";
    //}
    //
    //if (viceleader.length()>0) viceleader=viceleader.substring(0,viceleader.length()-1);
    //if (people.length()>0) people=people.substring(0,people.length()-1);

%>
<html>
<head>
    <%@ include file="/common.jsp" %>
</head>
<body>
    <form name="frmcog" action="/httpprocesserservlet" method="post">
         <input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
         <input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
         <input type="hidden" name="actions" value="<sc:fmt value='updateDept' type='crypto'/>">
         <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/pcmc/sm/DeptListDetail.jsp' />">
         <input type="hidden" name="deptid" value="<%=record.getChildText("deptid")%>">
         <input type="hidden" name="pdeptid" value="<%=record.getChildText("pdeptid")%>">
         <input type="hidden" name="levelp" value="<%=record.getChildText("levelp")%>">

         <sc:fieldset name="修改部门信息">
         <table width="100%" border="0" cellpadding="0" cellspacing="0" class="form-table">
         <tr><th colspan="4">部门信息</th></tr>                                                                    
         <tr>
             <td align="right" class="form-label">部门编号：<font color="red">*</font></td>
             <td class="form-value">
                 <input value="<%=record.getChildText("deptcode")%>" type="text" style="width: 70%;"
                    name="deptcode" class="inputtext" req="1" displayname="部门编号">
                 <span class="hint_info">部门的唯一编号</span>
             </td>
         </tr>
         <tr>
             <td align="right" class="form-label">部门名称：<font color="red">*</font></td>
             <td class="form-value">
                 <input value="<%=record.getChildText("deptname")%>" type="text"  style="width: 70%;"
                    name="deptname" class="inputtext" req="1" displayname="部门名称">
             </td>
         </tr>
         <%--
         <tr class="sysdisplay">
             <td align="right"><font color="red">*</font>部门长：</td>
             <td class="fieldname">
                 <input type="hidden" name="leader" value="<%=record.getChildText("leader")%>" maxlength=20 class="inputtext"  customtype="num" req="1" displayname="部门长" readonly>
                 <input type="text" name="lead" value="<%=record.getChildText("nleader")%>" maxlength=40 class="inputtext" displayname="部门长" readonly>
                 <img src="/common/images/pic01/sel_person.gif" border=0 align="absmiddle" style="CURSOR: hand" onClick="javascript:getPerson_lead();">
             </td>
             <td class="fieldname" width="20%">部门的最高负责人</td>
         </tr>
         --%>
         <%--
         <tr class="sysdisplay">
             <td align="right">副部门长：</td>
             <td class="fieldname">
                 <input type="hidden" name="viceleader" value="<%=viceleader%>" readonly class="inputtext"  req="0" displayname="副部门长">
                 <input type="text" name="people" value="<%=people%>" readonly  maxlength=80 class="inputtext" displayname="副部门长">
                 <img src="/common/images/pic01/sel_person.gif" border=0 align="absmiddle" style="CURSOR: hand" onClick="javascript:getPerson_people();">
             </td>
             <td class="fieldname" width="20%">&nbsp;</td>
         </tr>
         --%>
         <%--
         <tr class="sysdisplay">
             <td align="right"><font color="red">*</font>文件接收员：</td>
             <td class="fieldname">
                 <input type="hidden" name="filereceiver" value="<%=record.getChildText("filereceiver")%>" maxlength=20 class="inputtext"  customtype="num" req="1" displayname="文件接收人" readonly>
                 <input type="text" name="receiver" value="<%=record.getChildText("nfilereceiver")%>" maxlength=40 class="inputtext" displayname="文件接收人" readonly>
                 <img src="/common/images/pic01/sel_person.gif" border=0 align="absmiddle" style="CURSOR: hand" onClick="javascript:getPerson_filereceiver();">
             </td>
             <td class="fieldname" width="20%">部门的文件接收员。发给部门的文件由其接收</td>
         </tr>
         --%>
         <tr>
             <td align="right" class="form-label">联系人：<font color="red">*</font></td>
             <td class="form-value">
                 <input type="hidden" name="linkman" value="<%=record.getChildText("linkman")%>" 
                    maxlength=20 class="inputtext"  customtype="num" req="1" displayname="联系人" readonly="readonly"  style="width: 70%;">
                 <input type="text" name="linkm"  value="<%=record.getChildText("username")%>" 
                    maxlength=40 class="inputtext" displayname="联系人" readonly="readonly" style="width: 68%;" />
                 <img src="/common/images/pic01/sel_person.gif" border=0 align="absmiddle" style="CURSOR: hand" onClick="javascript:getPerson_linkman();">
                 <span class="hint_info">部门的联系人</span>
             </td>
         </tr>
         <tr>
             <td align="right" class="form-label">联系电话：</td>
             <td class="form-value">
                 <input value="<%=record.getChildText("phone")%>" type="text"  style="width: 70%;"
                    name="phone" class="inputtext" req="0" displayname="联系电话">
             </td>
         </tr>
         <tr>
             <td align=right class="form-label">备注：</td>
             <td class="form-value">
                 <textarea name="remark" class="inputarea" 
                    rows="4" cols="50"  style="width: 70%;"><%=record.getChildText("remark")%></textarea>
             </td>
         </tr>
         <tr>
             <td colspan="4" class="form-bottom" align="center">
                 <input type="button" class="button" name="save" value="保存" onclick="saveOk();">
                 <input type="button" class="button" name="reset" value ="重写" onclick="reset();">
                 <input type="button" class="button" value="返回" onclick="history.go(-1);">
             </td>
         </tr>
         </table>
    </sc:fieldset>
        </form>
    </body>
</html>

<script src="/js/form.js" language="JavaScript"></script>
<script language="JavaScript" src="/js/openW.js"></script>
<script src="/js/VBScript/translate.vbs" language="VBScript"></script>
<script src="/js/checkValid.js" language="JavaScript"></script>
<script src="/js/checkForm.js" language="JavaScript"></script>
<Script language="JavaScript">
    function saveOk()
    {
        if (!checkForm(document.forms[0]))
        {
            return false;
        }
        document.forms[0].submit();
    }

    function getPerson_lead()
    {
        var tmp1 = document.frmcog.leader.value;
        var tmp= document.frmcog.lead.value;
        var urlStr = '/oams/public/pbSelPerson.jsp?deptid=&receiveuser='+tmp+'&receiveuserid='+tmp1+'&multi=0';
        var w = openModal(urlStr,800,540);
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
        var urlStr = '/oams/public/pbSelPerson.jsp?deptid=&receiveuser='+tmp+'&receiveuserid='+tmp1+'&multi=1';
        var w = openModal(urlStr,800,540);
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
        var urlStr = '/oams/public/pbSelPerson.jsp?deptid=&receiveuser='+tmp+'&receiveuserid='+tmp1+'&multi=0';
        var w = openModal(urlStr,800,540);
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
        var urlStr = '/public/pbSelPerson.jsp?deptid=&receiveuser='+tmp+'&receiveuserid='+tmp1+'&multi=0';
        var w = openModal(urlStr,800,540);
        if(w !=null||w !=undefined)
        {
            document.frmcog.linkman.value = w[0];
            document.frmcog.linkm.value = w[1];
        }
    }
</Script>
