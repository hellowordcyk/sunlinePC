<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<sc:hidden name="${param.code }" index = "1"/>
<input name="${param.name}" type="text" alt="请选择机构" 
       postField="${param.name}" suggestFields="${param.code },${param.name}"
	   suggestUrl="/jsonprocesserservlet?sysName=<sc:fmt type='crypto' value='funcpub'/>&oprID=<sc:fmt type='crypto' value='funcpub-deptusermanager-public'/>&actions=<sc:fmt type='crypto' value='getJsonPcmcDeptLike'/>&suggestcode=${param.code }&suggestname=${param.name}&pdeptid={${param.pTagId}}"/>
<c:if test="${param.isLookup != 'false' }">
	<c:if test="${param.isMulti == 'true'}">
	    <a class="btnLook" title="多选机构" lookupGroup=""  width="1000" height="500"
              href="/funcpub/public/deptuser/deptTreeOptionDialog.jsp?lookupcode=${param.code }&lookupname=${param.name}&elmId={${param.code }}"></a>
		<%-- <a class="btnLook" href="/funcpub/public/deptuser/deptLookupMulti.jsp?lookupcode=${param.code }&lookupname=${param.name}&pdeptid={${param.pTagId}}" width="800" height="450" title="机构信息-多选" lookupGroup=""></a> --%>
	</c:if>
	<c:if test="${param.isMulti != 'true'}">
		<a class="btnLook" href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupcode=${param.code }&lookupname=${param.name}&pdeptid={${param.pTagId}}" width="800" height="450" title="机构信息-单选" lookupGroup=""></a>
	</c:if>
</c:if>

