<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp" %>
<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet" sort="list">
	<display:column style="width:7%;text-align:center" title="<input type='hidden' name='rownums' id='${record_rowNum}'>" >
		<sc:hidden name="objtid" value="${record.objtid}"/>
		<sc:hidden name="objtna" value="${record.objtna}"/>
		${record_rowNum}
	</display:column>
	<display:column property="objtid" title="配置ID" />
	<display:column property="objtna" title="配置ID名称" />
</display:table>
