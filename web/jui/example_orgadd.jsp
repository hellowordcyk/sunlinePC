<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>机构新增</title>
</head>

<body scroll="no">
<h2 class="contentTitle">新增机构信息</h2>


<div class="pageContent">
	<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-jui' type='crypto'/>&actions=<sc:fmt value='insertPcmcDept' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
		<div class="pageFormContent nowrap" layoutH="97">
			<dl>
				<dt>机构ID：</dt>
				<dd>
					<input type="text" name="deptid" maxlength="20" class="required" />
					<sc:text name="deptid"/>
					<sc:dcheckbox name="deptid" type="dict" key="pams,acctfg" default="40" rowNum="4"/>
				</dd>
			</dl>
			<dl>
				<dt>机构编码：</dt>
				<dd>
					<input type="text" name="deptcode" maxlength="20" class="required" />
				</dd>
			</dl>
			<dl>
				<dt>机构名称：</dt>
				<dd>
					<input type="text" name="deptname" maxlength="20" class="required" />
				</dd>
			</dl>
			<dl>
				<dt>机构级别：</dt>
				<dd>
					<input type="text" name="levelp" maxlength="20" class="digits" />
				</dd>
			</dl>
			<dl>
				<dt>父机构ID：</dt>
				<dd>
					<input type="text" name="pdeptid" maxlength="20" class="required" />
				</dd>
			</dl>
			
		</div>
		<div class="formBar">
			<ul>
				<li><button type="submit" class="button">提交</button></li>
				<li><button type="button" class="button">取消</li>
			</ul>
		</div>
	</form>
	
</div>


<script type="text/javascript">
function customvalidXxx(element){
	if ($(element).val() == "xxx") return false;
	return true;
}
</script>

</body>
</html>