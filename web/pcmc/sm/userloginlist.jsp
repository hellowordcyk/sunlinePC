<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
    <%@ include file="/common.jsp" %>
</head>

<body>
	<sc:form action="/pcmc/sm/userloginlist.so" forward="/pcmc/sm/userloginlist.jsp"
	oprID="smUserLock" actions="getAllUserLoginByUserId" sysName="pcmc" method="post" name="page_form">
			<sc:hidden name="userid" />
		<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/xmlprocesserservlet">
			<display:column title="登录状态">
				<c:if test="${record.loginSt == '0'}">
		       <c:out value="失败" default=""></c:out> 
		       	</c:if>
		       	<c:if test="${record.loginSt == '1'}">
		       <c:out value="成功" default=""></c:out> 
		       	</c:if>
		    </display:column>
			<display:column title="登录时间">
		        <sc:fmt type="date" value="${record.loginDt}" pattern="yyyy-MM-dd HH:mm:ss" />
		    </display:column>
			<display:column title="解锁时间">
		        <sc:fmt type="date" value="${record.ulokTm}" pattern="yyyy-MM-dd HH:mm:ss"/>
		    </display:column>
			<display:footer>
	              <tr>
	                  <td colspan="3">
	                      <div class="operator" >
		                  <c:if test="${not empty record}">
		              	     <%@ include file="/include/pager.jsp" %>
		               	  </c:if>
		             	  </div>
	                  </td>
	              </tr>
	           </display:footer>
		</display:table>
	</sc:form>
</body>


</html>