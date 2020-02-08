<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/jui_tag.jsp"%>
<title>文件查询页面</title>
</head>
<body>
<div class="pageHeader">
	<form id="fileSearchForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
		<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='funcpub-filemanager'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='queryDocFiles'/>"/>
		<sc:hidden name="subName" default="_subsystem"/>
		<sc:hidden name="dircName" default="_filetype"/>
		<sc:hidden name="path" default=""/>
	 	<div class="searchBar">
			<table class="searchContent" width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td align="right">文件名称</td>
					<td><sc:text name="fileName" req="0" /></td>
					<td align="right">关键字</td>
					<td><sc:text name="keywords" req="0" /></td>
					<td align="right">文件类型</td>
					<td>
						<select name="type" class="inputselect">
							<option value='_type'>--所有类型--</option>
							<option value='.txt'>*.txt</option>
							<option value='.pdf'>*.pdf</option>
							<option value='.ppt_.pptx'>*.ppt(pptx)</option>
							<option value='.doc_.docx'>*.doc(docx)</option>
							<option value='.xls_.xlsx'>*.xls(xlsx)</option>
						</select>
				</tr>
				<tr>
					<td align="right">搜索限制</td>
					<td>
						<select name="number"class="inputselect">
							<option value='10'>10</option>
							<option value='20'>20</option>
							<option value='50'>50</option>
							<option value='100'>100</option>
						</select>
					</td>
					<td colspan="4" align="right">
						<button type="button" class="button" onclick="doSearch()">查询</button>
						<c:if test="${param.priv == 'true' || empty param.priv }">
							<button type="button" class="button" onclick="createIndex()">重建索引</button>
						</c:if>
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div class="pageContent">
<div class="panelBar">
	<ul class="toolBar">
		<li>
			<a class="download" onclick="download();"><span>下载</span> </a>
		</li>
		<c:if test="${param.priv == 'true' || empty param.priv }">
		<li>
			<a class="upload" onclick="uploadFile();"><span>上传</span> </a>
		</li>
		<li>
			<a class="delete" onclick="deleteDirOrFile('true');"><span>删除</span> </a>
		</li>
		</c:if>
		<li class="line">line</li>
	</ul>
</div>	
<div id='dataId'>

</div>
</div>
</body>
<script type="text/javascript" defer="defer">
$(document).ready(function(){
	doSearch();
});
function doSearch(){
	
	$('#dataId').ajaxUrl({
		"url" : "/funcpub/filemanager/search/dataList.so",
		"type" : "post",
		"data" : $("form").serialize()
	});
}

function download() {
	var obj = $("input[name='check']", $('#dataId'));
	var files = '';
	var count = 0;
	for (var i = 0; i < obj.length; i++) {
		if (obj[i].checked == true) {
			count++;
			files = files + obj[i].value + "|";
		}
	}

	if (count < 1) {
		alertMsg.error("请至少选择一条数据!");
		return;
	}
	var url = '/download?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-filemanager' type='crypto'/>&actions=<sc:fmt value='packedFiles' type='crypto'/>';
    url += "&dt="+new Date()+"&check=" +files+"&subName="+$("input[name=subName]", $("#fileSearchForm")).val(),
     location.href= url + "&csrftoken="+g_csrfToken;
    
	
}

//复选框全选功能
function checkAll(ck) {
	var oCheck = $("input[type='checkbox']", $("#dataId"));
	for (var i = 0; i < oCheck.length; i++) {
		var ele = oCheck[i];
		if ((ele.type == "checkbox")) {
			if (ck.checked != ele.checked)
				ele.click();
		}
	}

}

function createIndex() {
	
	
	$.post("/xmlprocesserservlet",
    	{
    		"sysName": '<sc:fmt type="crypto" value="funcpub"/>',
    		"oprID": '<sc:fmt type="crypto" value="funcpub-filemanager"/>',
    		"actions": '<sc:fmt type="crypto" value="createIndex"/>',
    		"subName": $("input[name=subName]", $("#fileSearchForm")).val(),
    		"path": $("input[name=path]", $("#fileSearchForm")).val()
   		},
    	function(data){
    		var msg = $(data).find('DataPacket Response Data msg').text();
    		if("success" == msg){
    			alertMsg.correct('重建索引成功');
    		}else{
    			alertMsg.error("重建索引失败！");
    		}
    	}
	, "xml"); 
}
</script>
</html>