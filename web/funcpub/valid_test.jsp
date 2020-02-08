<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<form id="pagerForm" name="paramGroupFrom" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)" action="/httpprocesserservlet" method="post">
	<div class="pageContent">
		<div class="panelBar">
			<ul class="toolBar">
				<li><a class="add" onclick="addRow()"><span>增加行</span></a></li>
			</ul>
		</div>	
		<table class="list" layoutH="200">
			<thead>
				<tr>
					<th>代码</th>
				</tr>
			</thead>
			<tbody id="tbody">
			</tbody>
		</table>
	</div>
 	<div class="formBar" >
		<ul>
			<li><button class="savebtn" type="submit">保存</button></li>
		    <li><button class="close" type="button">取消</button></li>
        </ul>
	</div>	 
</form>

<script type="text/javascript">
var i=0;
function addRow(){
	i++;
	var html='<tr><td><sc:text id="code_'+i+'" name="code" validate="required number" /></td></tr>';
	$("#tbody",$.pdialog.getCurrent()).append(html);
	initUI($("#tbody",$.pdialog.getCurrent()));
}
</script>
