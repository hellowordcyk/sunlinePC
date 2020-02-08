<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增组织
 * description: 
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20170505
 *--%>
<form name="frmcog" method="post" action="/jui/callMessage.so?csrftoken=${csrftoken}"  class="pageForm required-validate" enctype="multipart/form-data" onsubmit="return iframeCallback(this, dialogAjaxDone);">
	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='aphmp-roleFunc'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='aphmp_import'/>"/>
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
	            <li><a href="javascript:void(0);" style="cursor: pointer;" onclick="downloadTemplate1()">下载九宫格模板配置模板</a></li>
	            <li><a href="javascript:void(0);" style="cursor: pointer;" onclick="downloadTemplate2()">下载页签配置导入模板</a></li>
	            <li><button class="savebtn" type="submit">导入</button></li>
	            <li><button class="close" type="button">取消</button></li>
	        </ul>
	    </div>
	</div>
</form>
<script type="text/javascript">

function downloadTemplate1(){	
	var url = '/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-roleFunc' type='crypto'/>&actions=<sc:fmt value='downLoadAphmpConfigTemplate' type='crypto'/>';
	url += "&dt="+new Date()+"&csrftoken="+g_csrfToken,
	location.href= url;
}
function downloadTemplate2(){	
	var url = '/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='aphmp-roleFunc' type='crypto'/>&actions=<sc:fmt value='downLoadAphmpTabTemplate' type='crypto'/>';
	url += "&dt="+new Date()+"&csrftoken="+g_csrfToken,
	location.href= url;
}

</script>