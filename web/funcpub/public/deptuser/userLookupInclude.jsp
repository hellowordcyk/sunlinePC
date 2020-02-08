<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ include file="/jui_tag.jsp" %>

<sc:hidden  name="${param.code }" index = "1" value="${param.linkmanCode }"/>
<input name="${param.name}" validate="${param.required }" postField="${param.name}" index="1" value="${param.linkman }" type="text" suggestFields="${param.code },${param.name}"
	suggestUrl="/jsonprocesserservlet?sysName=<sc:fmt type='crypto' value='funcpub'/>&oprID=<sc:fmt type='crypto' value='funcpub-deptusermanager-public'/>&actions=<sc:fmt type='crypto' value='getJsonPcmcUserLike'/>&suggestcode=${param.code }&suggestname=${param.name}"/>
	<c:if test="${param.isLookup != '0' }">
		<c:if test="${param.type == 'multi'}">
			<%-- <a class="btnLook" href="/funcpub/public/deptuser/userLookupMulti.jsp?lookupcode=${param.code }&lookupname=${param.name}" width="800" height="450" title="用户信息-多选" lookupGroup=""></a>
		     --%>  
		    <a class="btnLook" title="" lookupGroup="用户信息-多选"  width="1000" height="500"
                   href="/funcpub/public/deptuser/userTreeOptionDialog.jsp?lookupcode=${param.code }&lookupname=${param.name}&elmId={${param.code }}"></a>
                    
		</c:if>
		<c:if test="${param.type == 'single'}">
			<a class="btnLook" href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupcode=${param.code }&lookupname=${param.name}" width="800" height="450" title="用户信息-单选" lookupGroup=""></a>
		</c:if>
	</c:if>
	

