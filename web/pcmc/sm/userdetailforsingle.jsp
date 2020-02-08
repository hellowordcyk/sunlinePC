<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- 
 -- modified by yx on 2012-10-17
 -- remark: 此页面用户“部门维护”和“操作员维护”页面
 -->
<html>
<head>
    <%@ include file="/common.jsp" %>
</head>

<body>
    <sc:fieldset name="操作员详细信息">
    <sc:showrsmsg />
    <table width="100%" border="0" align="center" cellpadding="" cellspacing="5">
    <tr>
        <td width="35%" valign="top">
            <form action="/pcmc/sm/UserDetail.so" method="post">
                <input type="hidden" name="sysName" value='<sc:fmt type="crypto" value="pcmc"/>' /> 
                <input type="hidden" name="oprID" value='<sc:fmt type="crypto" value="sm_query"/>' /> 
                <input type="hidden" name="actions" value='<sc:fmt type="crypto" value="getUserDetail"/>' />
                <sc:hidden name="userid" /> 
                <div id="userDivId" style="width: 100%; ">
                    <span class="loading">加载中...</span>
                </div>
            </form>
        </td>
        <td width="65%" valign="top">
            <div id="roleId" style="width: 100%; ">
                <span class="loading">加载中...</span>
            </div>
        </td>
    </tr>
    </table>
</sc:fieldset>
</body>
<script type="text/javascript">
document.observe("dom:loaded", function () {
    getUserDetail();
    getRoleList();
});
var ajax = new Jraf.Ajax();
function getRoleList(){
    ajax.loadPageTo('/pcmc/sm/addUserRole.jsp', null, 'roleId');
}
function getUserDetail(){
    var params = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:      '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getUserList"/>',
        userid:     '${param.userid}'
    };
    ajax.loadPageTo('/pcmc/sm/getuserdetailforsingle.so', params, 'userDivId');
}

</script>
</html>