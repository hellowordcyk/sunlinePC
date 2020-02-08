<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jui_tag.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions"  prefix="fn"%>
<form id="pagerForm" action="" method="post">
	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='funcpub-filemanager'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='queryDocFiles'/>"/>
	<sc:hidden name="path" />
	<sc:hidden name="trandt" />
	<sc:hidden name="subName" />
	<sc:hidden name="dircName" />
	<sc:hidden name="fileName" />
	<sc:hidden name="keywords" />
	<sc:hidden name="type" />
	<sc:hidden name="number" />
	<table class="table" width="100%" layoutH="156">
		<thead>
			<tr>
				<th><input type='checkbox' name='allbox' onclick='checkAll(this)'></th>
				<th>文档路径</th>
				<th>文件名称</th>
				<th>文件大小</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMaps }">
			<tr>
				<td><input type="checkbox" name="check" value='${record.filePath}' /></td>
				<td>${record.subName }\ ${record.dircName}${fn:substringBefore(fn:substringAfter(record.filePath, record.dircName), record.fileName)}</td>
				<td>${record.fileName }</td>
				<td>${record.fileSize }</td>
			</tr>
		</c:forEach>
		</tbody>
	</table>
	<div class="panelBar">

	</div>
</form>
