<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<div class="pageHeader">
    <form id="pagerForm" onsubmit="return dialogSearch(this);" method="post"
        action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdssParameter' type='crypto'/>&actions=<sc:fmt value='querySysParam1' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/para/dict/param_update.jsp' type='crypto'/>">
        <sc:hidden name="subscd" value="${jrafrpu.rspPkg.rspDataMap.subscd1}"/>
		<sc:hidden name="paratp" value="${jrafrpu.rspPkg.rspDataMap.paratp1}"/>
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0" >
                <tr>
                    <td class="form-label">参数代码</td>
                    <td class="form-value"> <sc:text name="paracd" /></td>
                    <td class="form-label">参数名称</td>
                    <td class="form-value"><sc:text name="parana" /></td>
                    <td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <button class="querybtn" type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</div>

<form id="pagerForm" name="paramGroupFrom" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)" action="/httpprocesserservlet" method="post">
    <!-- <input type="hidden" id="onsubmit_id" name="onsubmit" value="return dialogSearch(this);" /> -->
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
	<input type="hidden" name="oprID" value="<sc:fmt value='bdssParameter' type='crypto'/>" />
	<input type="hidden" id="actions_id" name="actions" value="<sc:fmt value='querySysParam1' type='crypto'/>" />
	<input type="hidden" id="forward_id" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/para/dict/param_update.jsp' />" />
	<sc:hidden name="subscd" value="${jrafrpu.rspPkg.rspDataMap.subscd1}"/>
	<sc:hidden name="paratp" value="${jrafrpu.rspPkg.rspDataMap.paratp1}"/>
	<input type="hidden" id="delstr" name="delstr" value=""/>
	<sc:hidden name="pageNum" value="1" />
	<div class="pageContent">
		<div class="panelBar">
			<ul class="toolBar">
				<li><a class="add" onclick="addRow()"><span>增加条目</span></a></li>
			</ul>
		</div>	
		<table class="table" layoutH="200">
			<thead>
				<tr>
					<th width="100">参数代码</th>
					<th width="100">参数名称</th>
					<th width="80">金额参数</th>
					<th width="80">参数日期</th>
					<th width="100">参数字符A</th>
					<th width="100">参数字符B</th>
					<th width="100">参数字符C</th>
					<th width="100">参数字符D</th>
					<th width="100">参数字符E</th>
					<th width="80">排序</th>
					<th width="180">操作</th>
				</tr>
			</thead>
			<tbody id="tbody">
				<c:forEach var="para" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
					<tr >
						<td><sc:text name="paracd" value="${para.paracd}" style="width:75px;"/></td>
						<td><sc:text name="parana" value="${para.parana}" style="width:75px;"/></td>
						<td><sc:text name="paraam" value="${para.paraam}" style="width:55px;" _class="number"/></td>
						<td><sc:date name="paradt" value="${para.paradt}" style="width:55px;" dateFmt="yyyy-MM-dd" showIcon="false"/></td>
						<td><sc:text name="parach" value="${para.parach}" style="width:75px;"/></td>
						<td><sc:text name="parbch" value="${para.parbch}" style="width:75px;"/></td>
						<td><sc:text name="parcch" value="${para.parcch}" style="width:75px;"/></td>
						<td><sc:text name="pardch" value="${para.pardch}" style="width:75px;"/></td>
						<td><sc:text name="parech" value="${para.parech}" style="width:75px;" /></td> 
						<td><sc:text name="sortno" value="${para.sortno}" style="width:55px;"/></td>
						<td>
							<span>
								<input type="hidden" name="disable" value="${para.disable }"/>
								<input type="checkbox" name="disableBtn" value="1" <c:if test="${para.disable eq '1' }">checked="true"</c:if> onclick="changeDisable(event)"/> 禁用
							</span>
							<a href="javascript:void(0)" onclick="deleteRow(this)" class="btnDel">删除</a>
						</td> 
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<div class="panelBar">
			<div rel="" class="pagination" targetType="dialog"
				totalCount="${jrafrpu.rspPkg.rspRecordCount}"
				numPerPage="${jrafrpu.rspPkg.rspPageSize }"
				currentPage="${jrafrpu.rspPkg.rspPageNo}"></div>
		</div>
	</div>

 	<div class="formBar" >
		<ul>
			<li><button class="savebtn" type="button" onclick="addSysParam1();" >保存</button></li>
			<!-- 由于表单提交时触发validateCallback函数必须要求点击类型submit的按钮，因此在点击保存时实际调用此按钮 -->
			<li><input class="button" name="addSub_btn" style="display:none;" type="submit" /></li>
		    <li><button class="close" type="button">取消</button></li>
        </ul>
	</div>	 
</form>

<script type="text/javascript">
$(function() {
	var delStr = "";
	$("#tbody",$.pdialog.getCurrent()).find("[name='paracd']").each(function(i,e){
		delStr= delStr+$(e).val() + ",";
	});
	if(delStr.length > 1) {
		delStr = delStr.substring(0,delStr.length-1);
	}
	$("#delstr").val(delStr);
});
function deleteRow(obj){
	$(obj).closest("tr").remove();
}
function addRow(){
	var html = "<tr>"
		+"<td><div><input type='text' name='paracd' style='width: 75px;'/></div></td>"
		+"<td><div><input type='text' name='parana' style='width: 75px;'/></div></td>"
		+"<td><div><input type='text' name='paraam' style='width: 55px;' class='number'/></div></td>"
		+"<td><div><input type='text' name='paradt' style='width: 55px;' class='date textInput'/></div></td>"
		+"<td><div><input type='text' name='parach' style='width: 75px;'/></div></td>"
		+"<td><div><input type='text' name='parbch' style='width: 75px;'/></div></td>"
		+"<td><div><input type='text' name='parcch' style='width: 75px;'/></div></td>"
		+"<td><div><input type='text' name='pardch' style='width: 75px;'/></div></td>"
		+"<td><div><input type='text' name='parech' style='width: 75px;'/></div></td>"
		+"<td><div><input type='text' name='sortno' style='width: 55px;'/></div></td>"
		+"<td><div>"
		+"<span>"
		+"	<input type='hidden' name='disable' value='0'/>"
		+"		<input type='checkbox' name='disableBtn' value='1'  onclick='changeDisable(event)'/> 禁用"
		+"	</span>"	
		+"	<a href='javascript:void(0)' onclick='deleteRow(this)' class='btnDel'>删除</a></div>"
		+"</td>" 
		+ "</tr>";
	var tbody = $("#tbody",$.pdialog.getCurrent());
	$(tbody).append(html);
	initUI(tbody);
}

//保存参数
function addSysParam1(){
	//$("#onsubmit_id").val("return validateCallback(this,dialogAjaxDone);");
	var paracds="";
	$("#tbody",$.pdialog.getCurrent()).find("[name='paracd']").each(function(i,e){
		paracds= paracds +$(e).val() + ",";
	});
	if(paracds.length > 1) {
		paracds = paracds.substring(0,paracds.length-1);
	}
	var array = paracds.split(",");
	array = array.sort();
	for(var i=0;i<array.length;i++){
		if(array[i]==array[i+1]){
			alertMsg.error("新增参数代码"+array[i]+"重复");
			return;
		}
	}
	$("#actions_id").val("<sc:fmt value='addSysParam1' type='crypto'/>");
	$("#forward_id").val("<sc:fmt type='crypto' value='/jui/callMessage.jsp' />");
	paramGroupFrom.addSub_btn.click();
}

function changeDisable(event) {
	var elm = $(event.target);
	console.info(elm.prop("checked")?"1":"0");
	elm.prev("input[name='disable']").val(elm.prop("checked")?"1":"0");
}
</script>
