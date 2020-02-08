<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--生成“银行Logo下拉框” --%>
<sc:doPost sysName="funcpub" oprId="funcpub-basicinfo" action="getBankLogoFilePath" scope="request" var="" all="true"></sc:doPost>
<sc:select id="bankpic" style="width:497px;margin-top:7px;" onchange="logoganged()" req="1">
	<c:forEach var="para" items="${jrafrpu..rspRcdDataMaps}" varStatus="Index">
    	<option value="${para.bankpics }">${para.bankpics }</option>
    </c:forEach>
</sc:select>
