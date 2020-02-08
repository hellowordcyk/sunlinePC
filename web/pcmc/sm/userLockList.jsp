<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
    <%@ include file="/common.jsp" %>
</head>

<body>
	<sc:form action="/pcmc/sm/userLockList.so" oprID="smUserLock" actions="getUserLockedList" sysName="pcmc" method="post" name="page_form">
		<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/xmlprocesserservlet">
			<display:column style="width:25%;text-align:left" property="usercode" title="账号" sortable="false"/>
			<display:column style="width:20%;text-align:left" property="username" title="用户名" sortable="false"  />
			<display:column style="width:20%;text-align:left" title="锁定时间">
		        <sc:fmt type="date" value="${record.userLockTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
		    </display:column>
			<display:column style="text-align:left" title="操作">
			    <input type="button" name="unlock" value="解锁" class="button" onclick="toUnlockUser('${record.userid }');"/>
			    <input type="button" name="login" value="登录信息" class="button" onclick="toGetUserLoginList('${record.userid }');"/>
			</display:column>
			<display:footer>
	              <tr>
	                  <td colspan="6">
	                      <div class="operator" >
		                  <c:if test="${not empty record}">
		                 
		             	  </div>
		              	 <%@ include file="/include/pager_ajax.jsp" %>
		               </c:if>
	                  </td>
	              </tr>
	           </display:footer>
		</display:table>
	</sc:form>
</body>


</html>