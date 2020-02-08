<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<h2 class="contentTitle">新增用户信息</h2>

	
<div class="pageContent">
	<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dataconf-jui-user' type='crypto'/>&actions=<sc:fmt value='addFuncMenu' type='crypto'/>&forward=<sc:fmt value='/jui/del.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
		<div class="pageFormContent nowrap" layoutH="97">
			<dl>
				<dt>功能id：</dt>
				<dd>
					<sc:text id="funcid" name="funcid" attributesText='maxlength="20" ' validate="required digits" min="1" />
				</dd>
			</dl>
			<dl>
				<dt>功能编号：</dt>
				<dd>
					<sc:text id="funccode" name="funccode" attributesText='maxlength="20" ' validate="required digits" min="1" />
				</dd>
			</dl>
			<dl>
				<dt>功能名称：</dt>
				<dd>
					<sc:text id="funcname" name="funcname" attributesText='maxlength="20" ' validate="required digits" min="1" />
				</dd>
			</dl>
			<dl>
				<dt>功能脚本JAVA路径：</dt>
				<dd>
					<sc:text id="funcaddres" name="funcaddres" attributesText='maxlength="20" ' validate="required digits" min="1" />
				</dd>
			</dl>
			<dl>
				<dt>数据源编码：</dt>
				<dd>
					<sc:text id="func_datasrc" name="func_datasrc" attributesText='maxlength="20" ' validate="required digits" min="1" />
				</dd>
			</dl>
			<dl>
				<dt>备注：</dt> 
				<dd>
					<sc:text id="remark" name="remark" attributesText='maxlength="20" ' validate="required digits" min="1" />
				</dd>
			</dl>
			
		</div>
		<div class="formBar">
			<ul>
				<li><div class="buttonActive"><div class="buttonContent"><button type="submit">提交</button></div></div></li>
				<li><div class="button"><div class="buttonContent"><button type="button" class="close">取消</button></div></div></li>
			</ul>
		</div>
</form>
	
</div>


<script type="text/javascript">
function customvalidXxx(element){
	if ($(element).val() == "xxx") 
		 return false;
	return true;
}
</script>
