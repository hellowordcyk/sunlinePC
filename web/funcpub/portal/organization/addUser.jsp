<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增用户
 * description: 
 *     1.新增用户
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<form method="post" id="addUserForm" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='addUser' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<sc:hidden name="deptid" index="1"/>
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label"><span class="redmust">*</span>用户编号</td>
					<td class="form-value" colspan="3"><input type="text" name="usercode" class="required alphanumeric"  value=""/></td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>用户名</td>
					<td class="form-value"><input type="text" name="username" class="required username"/></td>
				    <td class="form-label">岗位</td>
                    <td class="form-value"><sc:select name="postcode" type="xml" sysName="funcpub" oprID="postActor" actions="queryNoPage" nameField="postCode" valueField="postTitle" includeTitle="false" nullOption="--请选择--"/></td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>登陆密码</td>
					<td class="form-value"><input type="password" id="userpwd"  name="jraf_password" maxLength="12" minLength="3" class="required alphanumeric"/></td>
					<td class="form-label"><span class="redmust">*</span>重复登陆密码</td>
					<td class="form-value"><input type="password" name="jraf_password_re" maxLength="12" minLength="3" class="required alphanumeric"/></td>
				</tr>
				<tr>
					<td class="form-label">所属机构</td>
					<td class="form-value" colspan="3"><sc:write name="deptname" /></td>
				</tr>
				<tr>
					<td class="form-label">皮肤选择</td>
					<td class="form-value"><sc:select name="skinname" type="dict" key="pcmc,skintype"  includeTitle="false" /></td>
					<td class="form-label"><span class="redmust">*</span>每页显示记录数</td>
					<td class="form-value">
					   <sc:select name="pagesize" type="dict" key="pcmc,pagesize"
                            validate="required" includeTitle="false" index="1" nullOption ="--请选择--"
                            />
					 </td>
				</tr>
				<tr>
				    <td class="form-label">是否机构管理人员</td>
                    <td>
                        <sc:dradio name="manager" type ="dict" key="pcmc,boolflag" default="0"></sc:dradio>
                        <span class="info">管理本级机构</span>
                    </td>
					<td class="form-label">是否禁用</td>
					<td>
						<sc:dradio name="disable" type ="dict" key="pcmc,boolflag" default="0"></sc:dradio>
					</td>
				</tr>
				<tr>
                    <td class="form-label">联系电话</td>
                    <td class="form-value"><input type="text"  name="phone" class="phone" /></td>
                    <td class="form-label">电子邮箱</td>
                    <td class="form-value"><input type="text" name="email" class="email"/></td>
                </tr>
				<tr>
					<td class="form-label">备注</td>
					<td class="form-value" colspan="3"><textarea name="remark" rows="2" cols="75" style="resize:none;"></textarea></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
        <ul>
            <li><button class="savebtn" type="button" onclick="submitForm()">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>
<script type="text/javascript">
function submitForm(){
	var currentDialog = $("body").data("addUser");
    var $addUserForm = $("#addUserForm",currentDialog);
    var pwd1 = $("input[name='jraf_password']",currentDialog).val();
    var pwd2 = $("input[name='jraf_password_re']",currentDialog).val();
    var uName = $("input[name='username']",currentDialog).val();
    if(!$addUserForm.valid()) {
        return;
    }
    var reg = new RegExp("^[a-zA-Z0-9\u4e00-\u9fa5]+$");
    if(!reg.test(uName)) {
    	alertMsg.warn("用户名只能输入中文，数字、字母！");
    	return;
    }
    
    if(pwd1!=null&&pwd1.length>0&&pwd2.length>0 && pwd2!=null) {
    	if(pwd1.length >=3 && pwd1.length<=12 && pwd2.length>=3&&pwd2.length<=12) {
    		if(pwd1!=pwd2) {
    			alertMsg.warn("密码不一致！");
    			return;
    		}
    	}else{
    		alertMsg.warn("密码长度为3-12位！");
            return;
    	}
    }else{
    	alertMsg.warn("密码不能为空！");
        return;
    }
    $addUserForm.submit();
}
</script>