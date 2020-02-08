<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
	<%@ include file="/common.jsp"%>
	<title>用户密码修改页面</title>
</head>
<body>
<sc:form name="form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="sm_maintenance" actions="updateUserPwd">
	<table width="100%" cellpadding="0" cellspacing="0" class="form-table">
		<tr><th colspan="4">密码修改</th></tr>
		<tr>
			<sc:password name="userpwd" dspName="新密码" dsp="td" req="1" attributesText="id='userpwd' minLenght='6' maxLength='20'"/>
		</tr>
		<tr>
			<sc:password name="userpwd2" dspName="重复新密码" dsp="td" req="1" attributesText="id='userpwd2' minLenght='6' maxLength='20'" />
		</tr>
	</table>
	<div style="width:100%" align="center" class="page-bottom">
        <sc:button value="保存" onclick="saveUserPwd()"/>
	    <sc:button value="重置" type="reset"/>
    </div>
</sc:form>    
</body>
<script type="text/javascript">
 
window.onbeforeunload=function (e) {
     return (e || window.event).returnValue='点击<确定>将退出系统，请确定已经修改初始密码？';
};
/** 保存用户新密码 */
function saveUserPwd() {
	if (!checkForm(document.form)){
		return;
	}
	var newPwd = $$("input[name='userpwd']")[0].value;
	var repeatPwd = $$("input[name='userpwd2']")[0].value;	

	//检查两次密码是否一致
	if(newPwd != repeatPwd){
		Jraf.showMessageBox({
            text: '<span class="warn">两次输入的密码必须一致，请修改！</span>'
        });
        return false;
	}
	
	//检查密码复杂度，必须包含有英文、数字、下划线的8位字符/^[\w\d]{8,}$/
	var regex = /[A-Za-z].*[0-9]|[0-9].*[A-Za-z]/;

	if(newPwd.length < 8 || !regex.test(newPwd))
	{
		Jraf.showMessageBox({
            text: '<span class="warn">密码不符合规范，必须为长度大于8的英文字母和数字的组合</span>'
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
	            	Jraf.showMessageBox({title: "提示成功", text: "<span class='info'>" + '修改密码成功！' + "</span>", 
	            		onOk: function(){
	            			//保存按钮事件返回2
	            			reValue('2');
	            			window.close();
	            		}
	            	});	
	            }
	        }catch(e){
			Jraf.showMessageBox({title: "修改密码出现异常", text: "<span class='error'>" + e + "</span>"});
		}
	});
}

//定义关闭按钮事件返回1
reValue('1');
function reValue(value){
	window.returnValue=value;
	//window.close();	
}

</script>
</html>