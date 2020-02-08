<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--@ page import="com.sunline.bimis.pcmc.util.ITEMS" --%>
<%--@ page import="com.sunline.bimis.pcmc.util.DeptUtil" --%>
<html>
<head>
    <title>
                用户信息维护
    </title>
    <%@ include file="/common.jsp"%>
</head>
<body>
<sc:form name="frmcog" action="/xmlprocesserservlet" sysName="pcmc" oprID="sm_maintenance" actions="addUser" forward="/pcmc/sm/UserList.jsp" method="post">
<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
    <tr><th colspan="2">新增用户</th></tr>
    <tr>
        <td class="form-label">
            <span style="color: red;">*</span>用户编号
        </td>
        <td class="form-value">
            <sc:text name="usercode"  dspName="用户编号" req="1" attributesText="style='width: 70%'"/>
            <span class="hint_info">用户编号是登录使用系统的名称</span>
        </td>
	</tr>
    <tr>
        <sc:password dsp="td" name="userpwd" dspName="登录密码" req="1" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <sc:password dsp="td" name="userpwd1" dspName="重复登录密码" req="1" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <sc:text dsp="td" name="username" dspName="用户名" req="1" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <td class="form-label">部门：<font color="red">*</font></td>
        <td class="form-value">
            <sc:hidden name="brchno" />
            <sc:hidden name="deptid" />
            <sc:text name="deptname" size="20" req="1" dspName="所属部门" attributesText="readonly='readonly' style='width: 60%'"/>
            <input type="button" id="#" name="img_search" onclick="getDept();" src="" class="search" style="cursor: pointer;" /> 
        </td>
    </tr>
    <tr>
        <sc:select dspName="菜单类型" dsp="td"  name="menutype" type="dict" key="pcmc,menutype" includeTitle="false" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <sc:select dspName="皮肤选择" dsp="td"  name="skintype" type="dict" key="pcmc,skintype" includeTitle="false" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <sc:text dsp="td" name="pagesize" dspName="每页显示记录数" req="1" type="page" default="20" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <sc:text dsp="td" name="phone" dspName="联系电话" type="num" attributesText="style='width: 70%'"/>
    </tr>
    <%--
    <tr>
        <sc:text dsp="td" name="faxno" dspName="传真" req="0" />
    </tr>
    <tr>
        <sc:text dsp="td" name="mobile" dspName="手机" req="1"  type="phone"/>
    </tr>
    <tr>
        <sc:text dsp="td" name="hmphone" dspName="家庭电话" req="0" />
    </tr>
    <tr>
        <sc:select dspName="职位" dsp="td"  name="jobno" type="dict" key="pcmc,headship" includeTitle="false" />
    </tr> 
    <tr>
        <sc:text dsp="td" name="homead" dspName="家庭住址" req="0" />
    </tr>--%>
    <tr>
        <td class="form-label">是否冻结：</td>
        <td class="form-value">
            <sc:select dspName="是否冻结" name="disable" type="dict" key="pcmc,boolflag" includeTitle="false" attributesText="style='width: 70%'"/>
            <span class="hint_info">被冻结将不能使用系统</span>
        </td>
    </tr>
    <tr>
        <sc:textarea dsp="td" name="remark" dspName="备注" cols="30" rows="5" req="0" attributesText="style='width: 70%'"/>
    </tr>
    <tr>
        <td colspan="2" class="form-bottom">
            <sc:button value="保存" name="saveBtn" onclick="saveOk();"/>
            <sc:button value="重写" type="reset"/>
            <sc:button value="关闭" onclick="window.close();"/>
        </td>
    </tr>
</table>
</sc:form>
</body>
<script type="text/javascript">
function saveOk()
{
    var oForm = document.forms["frmcog"];
    if(!checkForm(oForm, event)){//form表单校验
        return;
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
                    text: '<span class="error">保存出错！\n'+pkg.allMsgs() + '</span>'
                });
                return;
            }
            var results = {
                usercode: oForm.elements("usercode").value
            };
            window.returnValue = results;
            
            Jraf.showMessageBox({
                text: '<span class="success">保存成功！</span>',
                onClose: function () {window.close();} 
            });
            
        } catch(e) { alert('[method=saveOk]ERROR:'+e.message); }
    });
}
function selfCheckForm()
{
    var oForm = document.forms["frmcog"];
    var userpwd  = oForm.elements("userpwd").value;
    var userpwd1 = oForm.elements("userpwd1").value;
    if (userpwd.trim()!=userpwd1.trim())
    {
        Jraf.showMessageBox({
            text: '<span class="warn">两次输入的密码必须一致且不能为空，请修改！</span>'
        });
        return false;
    }
    return true;
}
function getDept(){
    var oForm = document.forms["frmcog"];
    var receiveDeptid = oForm.elements('deptid').value;

    var urlStr = '/pcmc/picker/deptPicker.jsp?multi=0&receivedeptid='+receiveDeptid;
    var w = openModal(urlStr,650,450);
    if(w !=null)
    {
        oForm.elements("deptid").value = w[0].deptid;//部门id
        oForm.elements("brchno").value = w[0].deptcode;//部门编号
        oForm.elements("deptname").value = w[0].deptname;//部门名称
    }
}    
</Script>
</html>
