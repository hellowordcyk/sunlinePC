<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<form method="post" action="/httpprocesserservlet"  onbeforesubmit="beforeResetPwd()" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='resetUserPwd' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<sc:hidden name="userid" value="${param.userid}"/>
	<div class="pageContent">
		<div class="pageFormContent">
    		<table class="form-table" cellpadding="0" cellspacing="0" >
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>密码</td>
    				<td class="form-value" colspan="3">
    				   <input  name="userPwd"  maxLength="32" minLength="6" class="required alphanumeric"/>
    				</td>
    		    </tr>
    		</table>
    	</div>
	</div>
    <div class="formBar">
        <ul>
            <li><button class="savebtn" type="submit">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>
<script>
$(function(){
	var password = "";
	var iteration = 0;
	var randomNumber;
	while(iteration < 6){
		randomNumber = (Math.floor((Math.random() * 100)) % 94) + 33;
		if ((randomNumber >=33) && (randomNumber <=47)) { continue; }
		if ((randomNumber >=58) && (randomNumber <=64)) { continue; }
		if ((randomNumber >=91) && (randomNumber <=96)) { continue; }
		if ((randomNumber >=123) && (randomNumber <=126)) { continue; }
		iteration++;
		password += String.fromCharCode(randomNumber);
	}
	$("[name='userPwd']", $.pdialog.getCurrent()).val(password);
});	
function beforeResetPwd(){
	var userpwd=$("[name='userPwd']", $.pdialog.getCurrent()).val();
	userpwd=$.md5(userpwd);
	$("[name='userPwd']", $.pdialog.getCurrent()).val(userpwd);
	return true;
}
</script>