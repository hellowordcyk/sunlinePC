<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<script type="text/javascript"
	src="/jui/encrypt/components/rollups/tripledes.js"></script>
<script type="text/javascript" src="/jui/encrypt/components/mode-ecb.js"></script>
<%--
 * title: 个人信息修改密码
 * description: 
 *     个人信息修改密码
 * author: 
 * createtime: 
 * logs:
 *     edited by longjian on 201600623 优化布局
 *--%>
<form id="password_pageFrom" name="password_pageForm" method="post"
	action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='EditPassword' type='crypto'/>&actions=<sc:fmt value='updatePassword' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>"
	class="pageForm required-validate"
	onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0">
				<tr>
					<td class="form-label">用户编码</td>
					<td class="form-value"><sc:write name="usercode" /></td>
				</tr>
				<tr>
					<td class="form-label">用户名称</td>
					<td class="form-value"><sc:write name="username" /></td>
				</tr>

				<tr>
					<td class="form-label"><span class="redmust">*</span>原密码</td>
					<td class="form-value"><input type="password"
						id="jraf_password_old" class="required" minlength="6" /> <input
						type="hidden" name="jraf_password_old" /></td>

				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>新密码</td>
					<td class="form-value"><input type="password"
						id="jraf_password_new" class="required" minlength="6" /> <input
						type="hidden" name="jraf_password_new" /></td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>确认新密码</td>
					<td class="form-value"><input type="password"
						id="jraf_password_new_sure" class="required" minlength="6"
						equalTo="#jraf_password_new" /> <input type="hidden"
						name="jraf_password_new_sure" /></td>

				</tr>
				<tr>
					<td colspan="2" align="center"
						style="text-align: center; padding: 5px 20px"><c:set
							var="msg" scope="session" value="${param.msg }" /> <c:if
							test="${msg== '1'&& msg!=null}">
							<span class="info">第一次登录或密码过期,请重新修改密码!</span>
						</c:if></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
		<ul>
			<li><button class="savebtn" type="button"
					onclick="updatePassword();">保存</button></li>
			<li><button class="close" type="button"
					onclick="closeCurrentTabDialog()">取消</button></li>
		</ul>
	</div>
</form>
<script type="text/javascript">
function closeCurrentTabDialog(){
    $.pdialog.closeCurrent();
}
function updatePassword(){  //修改密码 提交

	var userpwd_old = $("#jraf_password_old").val();  //输入的原密码
	var userpwd_new = $("#jraf_password_new").val();  //输入的新密码
	var userpwd_new_sure = $("#jraf_password_new_sure").val();//输入的 确认新密码 
	
	var formObj = $("#password_pageFrom", $.pdialog.getCurrent());
	
	if(!formObj.valid()){
		
		return false;
	}
	
	if(userpwd_old==null||userpwd_old==''){  //原密码检验 		
		alertMsg.error("原密码不能为空!");	
		return false;
		
	}
	
	if(userpwd_new==null||userpwd_new==''){ //新密码校验 
		alertMsg.error("新密码不能为空!"); 
		return false;
	}
	
	if(userpwd_new.length<6||userpwd_new.length>32){ //新密码校验 
		alertMsg.error("新密码长度应在6-32位之间!"); 
		return false;
	}
	
	if(userpwd_new_sure==null||userpwd_new_sure==''){  //确认新密码检验
		alertMsg.error("确认新密码不能为空!"); 
		return false;
	}else if(userpwd_new_sure!=userpwd_new){
		alertMsg.error("确认新密码输入不正确!"); 
		return false;
	}
	
	//对密码进行MD5加密，并将密文填到隐藏框，传到后台
	
	  var key = "SUNLINES";
   var keys= CryptoJS.enc.Utf8.parse(key)
   var userpwd_old=  CryptoJS.DES.encrypt(CryptoJS.enc.Utf8.parse(userpwd_old),keys , {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});
   var userpwd_new = CryptoJS.DES.encrypt(CryptoJS.enc.Utf8.parse(userpwd_new), keys, {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});
   var userpwd_new_sure=CryptoJS.DES.encrypt(CryptoJS.enc.Utf8.parse(userpwd_new_sure),keys, {mode:CryptoJS.mode.ECB,padding: CryptoJS.pad.Pkcs7});
	
	
	$("input[name='jraf_password_old'").val(userpwd_old.toString());  
	$("input[name='jraf_password_new'").val(userpwd_new.toString());  
	$("input[name='jraf_password_new_sure'").val(userpwd_new_sure.toString());  
	
	formObj.submit();
	
	//update_date();//修改完密码更新日期    放到后台action里面
}
    
    
function update_date(){
	//修改完密码及时更新数据库里修改密码日期！
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='EditPassword' type='crypto'/>"+
	      "&actions=<sc:fmt value='updateDate' type='crypto'/>&forward=<sc:fmt value='/jui/index.jsp' type='crypto'/>";
    $.ajax({
          type: "POST",
          url: url,
          data: null,//前台发给后台的数据。
          dataType : "xml",
          processData: false,
          success:function(data){
       	   var msg = $(data).find("msg").text();
         },
         error:function(msg){
       	  alert("更新失败！");
         }
	})
}
	

    
</script>