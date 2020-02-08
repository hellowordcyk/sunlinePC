<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>
<%@include file="/common.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<sc:form name="queryCustForm" method="post" action="/httpprocesserservlet" 
    sysName="governor" oprID="upgrade" actions="getUpgrHist" forward="/governor/upgrade/dataList.jsp">
    <display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table">
       <display:column title="行号">
            ${record_rowNum }
        </display:column> 
        <display:column  title="升级日期"  style="white-space: normal;" class="">
        	<sc:fmt pattern="yyyy-MM-dd HH:mm:ss" type="date" value="${ record.acctdt}"/>
        </display:column>
        <display:column property="uscode" title="用户代码"  style="white-space: normal; " class=""/>
        <display:column property="usname" title="用户名称"  style="white-space: normal;" class=""/>
        <display:column property="filena" title="升级包名"  style="white-space: normal; " class=""/>
        <display:column property="updesc" title="升级说明"  style="white-space: normal; word-break: break-all;width:40%" class=""/>
                <display:column  title="操作"  class="">
                  <sc:button value="回滚" name="btn" _class='button-link' onclick="rollback('${record.filena }')"/>
                </display:column>
        <display:footer>
            <tr>
                <td colspan="7">
                  <c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMaps}">
                    <%@ include file="/include/pager_ajax_smpl.jsp" %>
                  </c:if>
                </td>
            </tr>
        </display:footer>
    </display:table>
</sc:form>
<script type="text/javascript" defer="defer">
</script>