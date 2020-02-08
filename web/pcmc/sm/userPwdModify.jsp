<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>修改用户密码</title>
</head>
<body style="padding: 5px;">
<sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="sm_maintenance" actions="updateUserPwd">
	<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
		<tr><th colspan="2">密码修改</th></tr>
		<tr>
			<sc:password name="userpwd" dspName="新密码" dsp="td" req="1" attributesText="id='userpwd' minLenght='6' maxLength='20'" />
		</tr>
		<tr>
			<sc:password name="userpwd2" dspName="重复新密码" dsp="td" req="1" attributesText="id='userpwd2' minLenght='6' maxLength='20'" />
		</tr>
        <tr>
            <td class="form-bottom" colspan="2">
                <sc:button value="保存" onclick="saveUserPwd()"/>
                <sc:button value="关闭" onclick="quit()"/>
            </td>
        </tr>
	</table>
</sc:form>    
</body>
<script type="text/javascript">
 
/** 保存用户新密码 */
function saveUserPwd() {
	if (!checkForm(document.form)){
		return;
	}
	if($$("input[name='userpwd2']")[0].value != $$("input[name='userpwd']")[0].value){
		Jraf.showMessageBox({
            text: '<span class="warn">两次输入的密码必须一致，请修改！</span>'
        });
        return false;
	}
	var param = {
	    sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
	    oprID:      '<sc:fmt type="crypto" value="sm_maintenance"/>',
	    actions:    '<sc:fmt type="crypto" value="updateUserPwd"/>',
	    userpwd:     $$("input[name='userpwd']")[0].value
	};
	var htmlstr = '<select name="brchno" class="inputselect" >';
	var ajax = new Jraf.Ajax();
	ajax.sendForXml('/xmlprocesserservlet', param, function(xml){
	        try{
	            var pkg = new Jraf.Pkg(xml);
	            if(pkg.result() != '0'){
		            Jraf.showMessageBox({title: "修改密码出现异常", text: "<span class='error'>" + '异常：' + pkg.allMsgs('<br>') + "</span>"});
	                return;
	            }
	            else{
	            	Jraf.showMessageBox({title: "提示成功", text: "<span class='info'>" + '修改密码成功！' + "</span>", onOk: function(){window.close();}});	
	            }
	        }catch(e){
			Jraf.showMessageBox({title: "修改密码出现异常", text: "<span class='error'>" + e + "</span>"});
		}
	});
}
/** 退出 */
function quit() {
	window.close();
}

 

</script>
</html>