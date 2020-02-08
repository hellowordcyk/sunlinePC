<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 用户同步权限控制 --%>
<sc:doPost var="userSyncData" scope="request" sysName="pcmc" 
           oprId="UserSync" action="hasStartSync" ></sc:doPost>
<c:if test="${userSyncData.rspRcdDataMaps[0].hasStart == 0}">
<script type="text/javascript" defer="defer">
initPageStyle();
function initPageStyle() {
<%-- 启动了权限管理功能才执行 --%>
    var disabledButtons = $$("input[_jraf_sys_usersync]");
    if (disabledButtons != null ) {
        disabledButtons.each(function (obj) {
            //obj.disabled = true;
            obj.remove();
        });
    }
}
</script>
</c:if>
