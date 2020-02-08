<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jui_tag.jsp" %>
<%--生成“银行Logo下拉框” --%>
<sc:doPost var="rspPkg" scope="request" sysName="governor" oprId="initConfig" action="getBankLogoFilePath" all="true" />
<select id="bankpic" style="width:497px;margin-top:7px;" onchange="logoganged()" req="1">
	<c:forEach var="logoInfo" items="${rspPkg.rspRcdDataMaps}">
    	<option value="${logoInfo.bankpics }">${logoInfo.bankpics }</option>
    </c:forEach>
</select>
