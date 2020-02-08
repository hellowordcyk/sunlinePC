<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jui_tag.jsp" %>
<%-- 生成日志列表 --%>
<div class="pageContent">
	<div class="pageFormContent">
		<table class="table" cellpadding="0" cellspacing="0">
			<thead>
				<tr>
					<%-- 规范：设置表格列宽度， 保证一个td列不设置宽度表示自动计算为100%剩余宽度--%>
					<th width="20%">名称</th>
					<th width="20%">日期</th>
					<th width="20%">大小</th>
					<th width="10%">操作</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="record" items="${recordList}"
					varStatus="menuStatus">
					<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if>>
						<td>${record.logName}</td>
						<td>${record.logDate}</td>
						<td>${record.logSize}</td>
						<td>
							<a href="javascript:void(0);" style="cursor: pointer;" onclick="logDownload('${record.logName }')">下载</a>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>
<script>
function logDownload(filename){
	var url = "/governor?flag=initConfig&downLoad=downLoad&filename="+filename;
	location.href= url;
}
</script>