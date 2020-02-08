<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jui_tag.jsp"%>
<form  class="pageForm required-validate" id="sysParamInfo"
	onsubmit="return validateCallback(this,navTabAjaxDone)" method="post" >
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0">
					<tr>
						<td class="form-label"><span style="color: red;">*</span>系统路径</td>
						<td class="form-value"><input req="1" id="systempath" class="required"
							name='systempath' type='text' value="${configInfo.systempath }" /></td>
						<td class="form-label"><span style="color: red;">*</span>开发调试模式</td>
						<td><input type="radio" id="no_log" name="debug" value="true"
							<c:if test="${configInfo.debug=='true' }">checked="checked"</c:if> />开启
							<input type="radio" id="yes_log" name="debug" value="false"
							<c:if test="${configInfo.debug=='false' }">checked="checked"</c:if> />关闭<span
							style="color: red;">[推荐]</span></td>
					</tr>
					<tr>
						<td class="form-label"><span style="color: red;">*</span>上传文件临时目录</td>
						<td class="form-value"><input req="1" id="temppath" class="required"
							name="temppath" type="text" value="${configInfo.temppath }" /></td>
						<td class="form-label"><span style="color: red;">*</span>日志存放路径</td>
						<td class="form-value"><input req="1" id="applogpath" class="required"
							name="applogpath" type="text" value="${configInfo.applogpath }" /></td>
					</tr>
				<tr>
					<td colspan='5' align='center' class="form-bottom">
						<input type="button"  onclick="saveSysParamInfo()" id="save" class="button" value="保存"/> 
						<input type="reset" value="重置" class="button" />
					</td>
				</tr>
			</table>
		</div>
		</form>
<div class="page-tip" style="margin: 0;">
	<span class="tip-title">温馨提示</span>
	<p>
		开发调试模式：开启此功能，服务器控制台将打印前后台交易数据； <span
			style="color: red; font-weight: bold;">正式投产时，建议停用;</span>
	</p>
	<p>上传文件临时目录：文件上传时，系统自动产生的临时文件存放路径；</p>
	<p>日志存放路径：系统日志存放的路径；可配置相对路径或绝对路径</p>
</div>
<script>
   function saveSysParamInfo(){
	   var data=$("#sysParamInfo").serialize();
	   console.log(data);
	   var respUrl = "/governor?flag=initConfig&actorName=configServlet";
		$.ajax({
			type : 'POST',
			url : respUrl,
			dataType:"json",  
			data:data,
			async : false,
			success : function(data) {
		    	if(data.msg=='0'){
					alertMsg.correct(data.retMessage)
				}else{
					alertMsg.error(data.retMessage);
				}
			},
			error : function(json){
			   DWZ.ajaxError(json);
			}
		 });
	  }
</script>
