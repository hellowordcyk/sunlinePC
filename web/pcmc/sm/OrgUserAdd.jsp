<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>
                用户信息维护
    </title>
    <%@ include file="/common.jsp"%>
    <% 
    String deptnameStr = request.getParameter("deptname");
    if(deptnameStr != null && deptnameStr.trim().length() > 0){
       deptnameStr = java.net.URLDecoder.decode(request.getParameter("deptname"), "UTF-8");
    }
    %>
</head>
<body>
<sc:form name="frmcog" action="/xmlprocesserservlet" sysName="pcmc" oprID="sm_maintenance" actions="addOrgUser" forward="/pcmc/sm/UserList.jsp" method="post">
<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
  <c:if test="${param['editFlag'] == false}">
    <tr><th colspan="2">新增用户</th></tr>
    <tr>
        <td class="form-label">
            用户编号<span style="color: red;">*</span>
        </td>
        <td class="form-value">
            <sc:text name="usercode" index="1" dspName="用户编号" req="1" attributesText="maxLength='20'" type="userNo"/>
            <span class="hint_info">用户编号是登录使用系统的名称</span>
        </td>
	</tr>
  </c:if>
  <sc:if name="/DataPacket/Request/Data/editFlag" equal="true">
    <tr><th colspan="2">修改用户</th></tr>
    <tr>
        <td class="form-label">
            用户编号<span style="color: red;">*</span>
        </td>
        <td class="form-value">
            <sc:text name="usercode" index="1" dspName="用户编号" req="1" attributesText="maxLength='20' readonly='readonly'"/>
            <span class="hint_info">用户编号是登录使用系统的名称</span>
        </td>
    </tr>
  </sc:if>
  <c:if test="${param['editFlag'] == false}">
    <tr>
        <sc:password dsp="td" name="userpwd" attributesText="id='userpwd'" dspName="登录密码" req="1" />
    </tr>
    <tr>
        <sc:password dsp="td" name="userpwd1" attributesText="id='userpwd1'" dspName="重复登录密码" req="1"/>
    </tr>
  </c:if>
    <tr>
        <sc:text dsp="td" name="username" dspName="用户名" req="1" attributesText="maxLength='20'" index="1"/>
    </tr>
  <c:if test="${param['editFlag'] == false}">
    <tr>
        <td class="form-label">部门：<font color="red">*</font></td>
        <td class="form-value">
                <sc:hidden index="1" name="brchno" />
                <sc:hidden index="1" name="deptid" />
                <sc:text name="deptname" dspName="所属部门" req="1" attributesText="readonly='readonly'" value="<%=deptnameStr%>"/>
                <input type="button" id="#" name="img_search" onclick="getDept();" src="" class="search" />    
        </td>
    </tr>
  </c:if>
  <c:if test="${param['editFlag'] == true}">
    <tr>
        <td class="form-label">部门：<font color="red">*</font></td>
        <td class="form-value">
                <sc:hidden index="1" name="brchno" />
                <sc:hidden index="1" name="deptid" />
                <sc:text name="deptname" dspName="所属部门" req="1" attributesText="readonly='readonly'"  index="1"/>
                <input type="button" id="#" name="img_search" onclick="getDept();" src="" class="search" />    
        </td>
    </tr>
  </c:if>
    <tr>
        <sc:select dspName="菜单类型" dsp="td"  name="menutype" type="dict" key="pcmc,menutype" includeTitle="false" index="1"/>
    </tr>
    <tr>
        <sc:select dspName="皮肤选择" dsp="td"  name="skinname" type="dict" key="pcmc,skintype" includeTitle="false" index="1"/>
    </tr>
    <tr>
        <sc:text dsp="td" name="pagesize" dspName="每页显示记录数" req="1" type="page" index="1"  />
    </tr>
    <tr>
        <sc:text dsp="td" name="phone" dspName="联系电话" type="phone" index="1" attributesText="maxLength='11'" />
    </tr>
    <tr>
        <sc:text dsp="td" name="email" dspName="电子邮箱" type="email" index="1"/>
    </tr>
    <%--
    <tr>
        <sc:text dsp="td" name="faxno" dspName="传真" req="0" index="1"/>
    </tr>
    <tr>
        <sc:text dsp="td" name="mobile" dspName="手机" req="1" index="1" type="phone"/>
    </tr>
    <tr>
        <sc:text dsp="td" name="hmphone" dspName="家庭电话" req="0" index="1"/>
    </tr>
    <tr>
        <sc:select dspName="职位" dsp="td"  name="jobno" type="dict" key="pcmc,headship" includeTitle="false" index="1"/>
    </tr> 
    <tr>
        <sc:text dsp="td" name="homead" dspName="家庭住址" req="0" index="1"/>
    </tr>--%>
    <tr>
        <td class="form-label">是否冻结：</td>
        <td class="form-value">
            <sc:select dspName="是否冻结" name="disable" type="dict" key="pcmc,boolflag" includeTitle="false" index="1"/>
            <span class="hint_info">被冻结将不能使用系统</span>
        </td>
    </tr>
    <tr>
        <sc:textarea dsp="td" name="remark" dspName="备注" cols="30" rows="3" req="0" index="1"/>
    </tr>
    <tr>
        <td colspan="2" class="form-bottom">
            <sc:button value="保存" name="saveBtn" attributesText="id='saveUserBtn' _jraf_sys_usersync" onclick="saveOk();"/>
            <sc:button value="重写" type="reset" name="saveRst" attributesText="_jraf_sys_usersync"/>
            <c:if test="${param['exitButtonShow'] == true}">
            <sc:button value="关闭" onclick="window.close();"/>
            </c:if>
        </td>
    </tr>
</table>
</sc:form>
</body>
<script language="javascript" defer="defer">
//init();
function init(){
<c:if test="${param['editFlag'] == false}">
document.getElementsByName("deptname")[0].value='<%=java.net.URLDecoder.decode(request.getParameter("deptname")==null? "":request.getParameter("deptname"), "UTF-8")%>';
</c:if>
}
//isHasPriv();
function isHasPriv(){
	var deptid = '${param.deptid}';	
	if("undefined" == typeof( dept))
	{return;}	
	if(!exists(deptid,dept)){
		document.getElementsByName('saveBtn')[0].disabled='true';
		document.getElementsByName('saveRst')[0].disabled='true';
	}
}
function saveOk()
{  
    var userid = null;
    var oForm = document.forms["frmcog"];
  <c:if test="${param['editFlag'] == false}">
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
            userid = pkg.reqData("userid")
            if(pkg.result() != '0'){
                Jraf.showMessageBox({
                    text: '<span class="error">保存出错！\n'+pkg.allMsgs() + '</span>'
                });
                return;
            }
            Jraf.showMessageBox({
                text: '<span class="success">保存成功！</span>'
            });
          <c:if test="${param['editFlag'] == false}">
            var results = {
                usercode: oForm.elements("usercode").value,
                username: oForm.elements("username").value,
                nodetype: 'childnode',
                userid: userid
            };
            window.returnValue = results;
            window.close();
          </c:if>
        } catch(e) { alert('ERROR:'+e);}
    });
  </c:if>
  
<c:if test="${param['editFlag'] == true}">
    var oBtn = oForm.elements("saveBtn");
    var oForm = document.forms["frmcog"];
    if(!checkForm(oForm, event)){//form表单校验
        return;
    }
    var ajax = new Jraf.Ajax();
    var reqparams = {
			sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
			oprID: 		'<sc:fmt type="crypto" value="sm_maintenance"/>',
			actions:	'<sc:fmt type="crypto" value="updateUser"/>',
			userid: 	${param.userid},
			deptid:     oForm.elements("deptid").value,
			username:	oForm.elements("username").value,
			menutype:	oForm.elements("menutype").value,
			skinname:	oForm.elements("skinname").value,
			phone:		oForm.elements("phone").value,
			pagesize:	oForm.elements("pagesize").value,
			remark:     oForm.elements("remark").value,
			disable:    oForm.elements("disable").value,
			email:      oForm.elements("email").value
			};
   ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
        try{
            oBtn.disabled = false;
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                Jraf.showMessageBox({
                    text: '<span class="error">修改出错！\n'+pkg.allMsgs() + '</span>'
                });
                return;
            }
            var results = {
                usercode: oForm.elements("usercode").value,
                username: oForm.elements("username").value,
                nodetype: 'childnode',
                userid: ${param.userid}
            };
           if(typeof(jraftreemenu)== 'object'){
             var userid=${param.userid};
             var username = results.username;
             var usercode = results.usercode;
             var key = 'nu'+userid;
             var node= jraftreemenu.treeContext.nodes[key];
            $(node.label).update(username+'['+usercode+']');
	   		Object.extend(node.tag,{deptid:userid,usercode:usercode,username:username});
           }else{
             window.returnValue = results;
          	 window.close();
           }
            Jraf.showMessageBox({
                text: '<span class="success">修改成功！</span>'
            });
        } catch(e) { alert('ERROR:'+e);}
    });
  </c:if>
}

function selfCheckForm()
{
    var userpwd  = document.getElementById("userpwd").value;
    var userpwd1 = document.getElementById("userpwd1").value;
    if (userpwd != userpwd1)
    {
        hint_alert(document.getElementById("userpwd1"),"两次输入的密码必须一致，请修改！");
        return false;
    }
    if(userpwd.length < 3 || userpwd.length > 12){
        hint_alert(document.getElementById("userpwd"),"密码长度必须在3-12个字符之间，请修改！");
        return false;
    }
    return true;
}
function getDept(){
    var oForm = document.forms["frmcog"];
    var receiveDept = oForm.elements("deptname").value;
    var receiveDeptid = oForm.elements("deptid").value;
    //var urlStr = '/public/deptPicker.jsp?receiveDept='+receiveDept+'&receiveDeptid='+receiveDeptid+'&multi=0';;
    var urlStr = '/pcmc/picker/deptPicker.jsp?multi=0&receivedeptid='+receiveDeptid;
    var w = openModal(urlStr,650,450);
    if(w !=null)
    {
        oForm.elements("deptid").value = w[0].deptid;//部门id
        oForm.elements("brchno").value = w[0].deptcode;//部门编号
        oForm.elements("deptname").value = w[0].deptname;//部门名称
    }
}
</script>
<%@include file="/common_priv_usersync.jsp" %>
</html>
  