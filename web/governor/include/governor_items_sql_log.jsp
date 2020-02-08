<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@include file="/governor/common/common.jsp" %>
<sc:form name="page_form" action="/httpprocesserservlet" method="post" sysName="governor" oprID="sqlMonitor" 
	actions="getSqlLog" forward="/governor/include/governor_items_sql_log.jsp">
	<display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" cellpadding="0"
      		  cellspacing="0" class="list-table">
		<display:column style="white-space: normal;" title="SQL语句">
			${record.sqlInfo }
		</display:column>
		<display:column style="width: 120px;" title="执行开始时间">
			${record.startTime }
		</display:column>
	    <display:column style="width: 120px;"  title="执行结束时间" >
	    	${record.endTime }
	    </display:column>
	    <display:column style="width: 150px;"  title="执行参数">
	    	${record.sqlPara }
	    </display:column>
	    <display:column style="width: 80px;"  title="用户编号">
	    	${record.userCode }
	    </display:column>
		
	</display:table>
	<div>
	     <%@ include file="/include/pager_ajax_smpl.jsp" %>
	 </div>
</sc:form>