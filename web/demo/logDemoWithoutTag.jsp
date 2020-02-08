<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>机构新增</title>
</head>

<body scroll="no">
<h2 class="contentTitle">新增机构信息</h2>
<div class="pageContent">
	<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return $validateCallback(this,dialogAjaxDone)">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-jui' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='insertPcmcDept' type='crypto'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
		<div class="pageFormContent nowrap" layoutH="90">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>机构ID：</td>
					<td><input type="text" name="deptid" maxlength="20" class="required" /></td>
					<td>机构编码：</td>
					<td><input type="text" name="deptcode" maxlength="20" class="required" /></td>
				</tr>
				<tr>
					<td>机构名称：</td>
					<td><input type="text" name="deptname" maxlength="20" class="required" /></td>
					<td>机构级别：</td>
					<td><input type="text" name="levelp" maxlength="20" class="digits" /></td>
				</tr>
				<tr>
					<td>父机构ID</td>
					<td colspan="3">
						<input type="text" name="pdeptid" maxlength="20" class="required" />
						<span class="remarks">基于普通标签，在页面加载时调用<strong>$(function(){ CommonUtils.initOldValue($('.pageForm')); });</strong><br>
				提交form时请使用$validateCallback方法取代原先DWZ提供的validateCallback方法；</span>
					</td>
				</tr>
			</table>
			<div class="formbutton_bg">
				<span>
					<button type="submit" class="formbutton">提交</button>
					<button type="button" class="formbutton">取消</button>
				</span>
			</div>
		</div>
	</form>
</div>


<script type="text/javascript">
$(function(){
	CommonUtils.initOldValue($('.pageForm'));	
});
</script>

</body>
</html>