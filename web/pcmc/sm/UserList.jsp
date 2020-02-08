<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/common.jsp" %>
</head>
<body >
    <sc:fieldset name="操作员维护">
        <sc:showrsmsg />
        <sc:form name="query_form" action="/pcmc/sm/UserList.so" method="post" sysName="pcmc" oprID="sm_query" actions="getUserList" attributesText="onSubmit='return checkForm(this);'">
        
        <table class="form-table" border="0" cellspacing="0" cellpadding="0">
            <tr><th colspan="4">查询条件</th></tr>
            <tr>
                <sc:text dsp="td" name="usercode" dspName="用户编号" req="0"/>
                <sc:text dsp="td" name="username" dspName="用户名"/>
            </tr>
            <tr>
                <sc:text dsp="td" name="deptname" dspName="部门名称"/>
                <sc:select dsp="td" dspName="是否冻结" name="disable" type="dict" key="pcmc,boolflag" includeTitle="false"  nullOption="---请选择---" />
            </tr>
            <tr>
                 <td colspan="4" class="form-bottom" align="center">
                     <sc:button value="查询" onclick="doSearch();" name="dosubmit"/>
                     <sc:button type="reset" value="重写"/>
                     <%-- 
                     <sc:button value="刷新本地用户"  _class='button-link' onclick="refresh();"/>
                     <sc:button value="创建LDAP用户"  _class='button-link' onclick="creatldapusers();"/>
                      --%>
                 </td>
            </tr>
        </table>
        </sc:form>
        <sc:form name="page_form" method="post" action="/pcmc/sm/UserList.so" sysName="pcmc" oprID="sm_query" actions="getUserList" attributesText="onSubmit='return checkForm(this);'">
        <sc:hidden name="usercode" />
        <sc:hidden name="username" />
        <sc:hidden name="deptname" />
        <sc:hidden name="disable" />
           <display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet"
                          sort="list">
                <display:column style="text-align: center" title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
                    <input type="checkbox" name="userid" onclick="outlineMyRow(this)" value='${record.userid }'/>
                </display:column>
                <display:column property="usercode" title="用户编号" sortable="true" />
                <display:column property="username" title="用户名" sortable="true" />
                <display:column property="deptname" title="所在部门" />
                <display:column property="phone" title="联系电话" />
                <display:column title="是否冻结" >
                    <sc:optd name="disable" value="${record.disable}" type="dict" key="pcmc,boolflag" />
                </display:column>
                <display:column title="操作" >
                    <sc:button value="详情/授权" _class="button-link" onclick="doDetial('${record.userid}')"/>
                </display:column>
                <display:footer>
                   <tr>
                       <td colspan="7">
                           <div class="operator" >
                               <input type="button" class="add" value="新增" onclick="toAdd();"/>
                               <!-- <input type="button" class="edit" value="修改" onclick="editSelected('userid');"/> -->
                               <input type="button" class="delete" value="删除" onclick="deleteSelected('userid');"/>
                           </div>
                           <c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMaps}">
                               <%@ include file="/include/pager.jsp" %>
                           </c:if>
                       </td>
                   </tr>
                </display:footer>
            </display:table>
       </sc:form>
   </sc:fieldset>
</body>
<script type="text/javascript">
function doSearch()
{
    var formObj = document.forms["query_form"];
    if(!checkForm(formObj)){
        return false;
    }
    formObj.oprID.value='<sc:fmt type="crypto" value="sm_query"/>';
    formObj.actions.value='<sc:fmt type="crypto" value="getUserList"/>';
    formObj.elements("dosubmit").disabled=true;
    formObj.submit();
}
function toAdd()
{
    var url = "/pcmc/sm/UserAdd.jsp";
    //window.open(url,800,500);
    var winResults = openModal(url,800,500);
    if (winResults != null) {
        var formObj = document.forms["query_form"];
        formObj.elements("usercode").value = winResults["usercode"];
        formObj.elements("username").value = "";
        formObj.elements("deptname").value = "";
        formObj.elements("disable").value = "";
        formObj.submit();
    }
}
function toEdit(obj)
{
    var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="sm_query"/>&actions=<sc:fmt type="crypto" value="getUserList"/>&forward=<sc:fmt value='/pcmc/sm/UserAdd.jsp' type='crypto'/>&editFlag=true&userid='+obj.value;
    openModal(url,800,500);
}
function doDelete()
{
    var formObj = document.forms["page_form"];
    formObj.oprID.value='<sc:fmt type="crypto" value="sm_maintenance"/>';
    formObj.actions.value='<sc:fmt type="crypto" value="deleteUser"/>';
    formObj.submit();
}

/*function refresh(){
    if (confirm("你确定要根据LDAP服务器上所有的用户来创建本地用户吗？"))
    {
        var formObj = document.forms["query_form"];
        formObj.oprID.value='<sc:fmt type="crypto" value="LdapMaintenance"/>';
        formObj.actions.value='<sc:fmt type="crypto" value="flushLdapUsers"/>';
        formObj.submit();
    }
}

function creatldapusers(){
    if (confirm("你确定要在LDAP服务器上创建所有的本地用户吗？"))
    {
        var formObj = document.forms["query_form"];
        formObj.oprID.value='<sc:fmt type="crypto" value="LdapMaintenance"/>';
        formObj.actions.value='<sc:fmt type="crypto" value="createLdapUsers"/>';
        formObj.submit();
    }
}*/

function doDetial(userid){
    var url = '/pcmc/sm/UserDetail.jsp?userid='+userid;
    var w = openModal(url,800,450);
    if (w!=null && w==true) {
        document.forms("page_form").submit();
    }
    //document.location.href = url;
}
</script>
</html>
