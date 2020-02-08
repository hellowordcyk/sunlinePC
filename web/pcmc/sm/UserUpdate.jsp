<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp" %>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%
com.sunline.jraf.web.RequestParamUtil rpu=null;
if(session.getAttribute("encoding")==null
||((String)session.getAttribute("encoding")).length()==0){
    rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, "UTF-8");
}else{
    rpu = com.sunline.jraf.web.RequestParamUtil.getInstance(request, (String)session.getAttribute("encoding"));
}
%>
<%  String sysName = Crypto.encode(request, "pcmc");
    String oprID = Crypto.encode(request, "sm_maintenance");
    String actions = Crypto.encode(request, "updateUser");
    String act = rpu.getString("act", "");
    String userid = rpu.getString("userid", "");
    if (rpu.getXmlDoc() == null && act.equals("")) {
        if (!userid.equals("")) {
            StringBuffer forwardbuf = rpu.buildReqUrl("pcmc",
                    "sm_query", "getUserDetail","/pcmc/sm/UserUpdate.so").append("&act=list")
                    .append("&userid=").append(userid);
            response.sendRedirect(forwardbuf.toString());
            return;
        }
        //add
    }
%>
<html>
<head>

</head>

<BODY>
<sc:form name="frmcog" action="/xmlprocesserservlet" method="post"
    sysName="pcmc" oprID="sm_maintenance" actions="updateUser">
    <sc:hidden name="userid" /> 
<sc:fieldset name="修改操作员信息">
<sc:showrsmsg />    
<table class="form-table" style="margin: 0px;">
    <tr><th colspan="4">修改操作员信息</th></tr>
    <tr>
        <sc:text name="usercode" size="20" req="1" dspName="用户编号" dsp="td" type="userNo" attributesText="readonly='readonly' style='width: 70%'"/>
    </tr>
    <tr>
        <td class="form-label">用户密码：</td>
        <td class="form-value">
            <sc:password name="userpwd" size="20" dspName="用户密码" attributesText="style='width: 70%'" />
            <span class="hint_info">要修改密码必须输入旧密码</span>
        </td>
    </tr>
    <tr>
        <sc:password name="userpwd1" size="20" dspName="新密码" dsp="td" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <sc:password name="userpwd2" size="20" dspName="确认新密码" dsp="td" attributesText="style='width: 70%'" />
    </tr>
    <tr>
        <sc:text name="username" size="20" req="1" dspName="用户名" dsp="td" attributesText="style='width: 70%'" />
    </tr>
    <tr>
        <td class="form-label">部门：<font color="red">*</font></td>
        <td class="form-value">
            <sc:text name="deptcode" size="20" req="1" dspName="部门" attributesText="readonly='readonly' style='width: 60%'"/>
            <input type="button" id="#" name="img_search" onclick="getDept();" src="" class="search" style="cursor: pointer;" /> 
            <span id="deptname"><sc:fmt name="deptname"/></span><sc:hidden name="deptid" />
        </td>
    </tr>
    <tr>
        <sc:select dspName="菜单类型" dsp="td" req="1"  name="menutype" type="dict" key="pcmc,menutype" includeTitle="false" attributesText="style='width: 70%'" />
    </tr>
    <tr>
        <sc:text name="phone" size="20" dspName="联系电话" dsp="td" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <sc:text name="pagesize" default="15" size="20" req="1" dspName="每页显示记录数" type="num" dsp="td" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <td class="form-label">是否冻结：</td>
        <td class="form-value">
            <sc:select dspName="是否冻结" name="disable" type="dict" req="1" key="pcmc,boolflag" includeTitle="false"  attributesText="style='width: 70%'"/>
            <span class="hint_info">被冻结将不能使用系统</span>
        </td>
    </tr>
    <tr>
        <sc:textarea name="remark" dspName="备注" rows="3" cols="65" dsp="td" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <td colspan="4" class="form-bottom">
            <sc:button value="保存" name="saveBtn" onclick="saveOk();"/>
            <sc:button type="reset" value="重写"/>
            <sc:button value="关闭" onclick="window.close();"/>
        </td>
    </tr>
</table>

<br>
</sc:fieldset>
</sc:form>
</body>
<script type="text/javascript">
function goBack()
{
    /*var url = "/pcmc/sm/UserDetail.jsp?userid="+document.forms[0].elements("userid").value;
    url += "&s_time="+(new Date().getTime());
    document.location.href = url;*/
    window.history.go(-1);
}
function saveOk()
{
    var oForm = document.forms[0];
    if (!checkForm(oForm))
    {
        return false;
    }
    if (!selfCheckForm())
    {
        return false;
    }
    var oBtn = oForm.elements("saveBtn");
    oBtn.disabled = true; 
    var ajax = new Jraf.Ajax();
    ajax.submitFormXml(oForm,function(xml){
        try{
            oBtn.disabled = false;
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                Jraf.showMessageBox({
                    text: '<span class="error">保存出错, 请联系管理员！</span>'
                });
                return;
            }
            var reValue = {};
            reValue["username"] = oForm.elements("username").value;
            window.returnValue=true;
            Jraf.showMessageBox({
                text: '<span class="success">保存成功, 是否退出本页面？</span>',
                onYes: function () {window.close();},
                onNo: function () {},
                onOk: null
            });
        } catch(e) { alert('ERROR:'+e); }
    });
}
function selfCheckForm()
{
    var userpwd  = document.forms[0].elements("userpwd").value;
    var userpwd1 = document.forms[0].elements("userpwd1").value;
    var userpwd2 = document.forms[0].elements("userpwd2").value;
    if (userpwd.trim()!="")
    {
        if (userpwd1.trim()==""){
            hint_alert(document.forms[0].elements("userpwd1"),"两次输入的新密码必须一致而且密码不能为空！");
            return false;
        } else if (userpwd2.trim()==""){
            hint_alert(document.forms[0].elements("userpwd2"),"两次输入的新密码必须一致而且密码不能为空！");
            return false;
        } else if (userpwd1 != userpwd2)
        {
            hint_alert(document.forms[0].elements("userpwd2"),"两次输入的新密码不一致！");
            return false;
        }
    } else if (userpwd.trim() =="" && (userpwd1 != "" || userpwd2 != "")) {
        hint_alert(document.forms[0].elements("userpwd"), "用户密码不能为空！");
        return false;
    }
    return true;
}

function getDept(){
    //var receiveDept = document.frmcog.deptname.value;
    var receiveDeptid = document.forms[0].elements('deptid').value;

    var urlStr = '/pcmc/picker/deptPicker.jsp?multi=0&receivedeptid='+receiveDeptid;
    var w = openModal(urlStr,650,450);
    //var w = openNewWindow(urlStr);
    if(w !=null)
    {
        document.forms["frmcog"].elements("deptid").value = w[0].deptid;//部门id
        document.forms["frmcog"].elements("deptcode").value= w[0].deptcode;
        $('deptname').innerHTML = w[0].deptname;//部门名称
    }
}    

</script>
</html>