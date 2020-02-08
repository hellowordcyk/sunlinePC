<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<form name="frmcog" method="post" action="/jui/callMessage.so?csrftoken=${csrftoken}" class="pageForm required-validate" enctype="multipart/form-data" onsubmit="return iframeCallback(this, dialogAjaxDone);">
	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='funcpub-deptusermanager'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='deptUserImport'/>"/>
	<%-- <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" /> --%>
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">请选择Excel文件</td>
					<td class="form-value"><input name='filename' type='file' class="required"></td>
				</tr>
				<tr>
					<td colspan="3" class="form-value"><span class="redmust">提示：文件类型必须为该"导出电子表格"的xls文件的模板,填写数据请勿修改模板</span></td>
				</tr>
			</table>
		</div>
		<div class="formBar">
	        <ul>
	            <li><a class="button" href="javascript:void(0);" style="cursor: pointer;" onclick="exportDeptUserInit()">下载导入模板</a></li>
	            <li><button class="savebtn" type="submit">导入</button></li>
	            <li><button class="close" type="button">取消</button></li>
	        </ul>
	    </div>
	</div>
</form>

<script type="text/javascript">
/**
 * 检测文件名 
 */
function checkFile(obj){
		var filename = obj.value;
		var begin=filename.lastIndexOf(".");
		var end=filename.length;
		var str=filename.substring(begin+1,end);
		if(str!='xls' && str != 'xlsx'){
			alertMsg.error("请选择格式为.xls或者.xlsx的文件导入!");
			obj.value = "";
			return false;
		}
}
function exportDeptUserInit(){
	
	var url = '/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>&actions=<sc:fmt value='deptUserExportInitActor' type='crypto'/>';
	url += "&dt="+new Date()+"&csrftoken="+g_csrfToken,
	 location.href= url;
	
	
}

</script>