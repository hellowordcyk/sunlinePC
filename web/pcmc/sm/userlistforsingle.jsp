<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/common.jsp" %>
</head>
<body >
    <sc:fieldset name="操作员维护">
        <sc:showrsmsg />
        <sc:form name="query_form" action="/pcmc/sm/userlistforsingle.so" method="post" sysName="pcmc" oprID="sm_query" actions="getUserList" attributesText="onSubmit='return checkForm(this);'">
        
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
                     <sc:button type="reset" value="重置"/>
                     <input type="button" class="add" value="同步用户" onclick="syncUser(this);">
                 </td>
            </tr>
        </table>
        </sc:form>
        <sc:form name="page_form" method="post" action="/pcmc/sm/userlistforsingle.so" sysName="pcmc" oprID="sm_query" actions="getUserList" attributesText="onSubmit='return checkForm(this);'">
            <sc:hidden name="usercode" />
            <sc:hidden name="username" />
            <sc:hidden name="deptname" />
            <sc:hidden name="disable" />
            <display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet"
                          sort="list">
                <display:column style="text-align: center" title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
                    <input type="checkbox" name="userid" onclick="outlineMyRow(this)" value='${record.userid }'/>
                </display:column>
                <display:column property="usercode" title="用户编号" />
                <display:column property="username" title="用户名" />
                <display:column property="deptname" title="所在部门" />
                <display:column property="phone" title="联系电话" />
                <display:column title="是否冻结" >
                    <sc:optd name="disable" value="${record.disable}" type="dict" key="pcmc,boolflag" />
                </display:column>
                <display:column title="操作" >
                    <sc:button value="详情|授权" _class="edit" onclick="doDetial('${record.userid}')"/>
                </display:column>
                <display:footer>
                   <tr>
                       <td colspan="7">
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

function doDetial(userid){
    var url = '/pcmc/sm/userdetailforsingle.jsp?userid='+userid;
    var w = openModal(url,800,450);
    if (w!=null && w==true) {
        document.forms("page_form").submit();
    }
    //document.location.href = url;
}

/*同步所有用户*/
function syncUser(thisObj) {
    thisObj.disabled = true;
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:      '<sc:fmt type="crypto" value="UserSync"/>',
        actions:    '<sc:fmt type="crypto" value="syncAllUser"/>'
    };
    var ajax = new Jraf.Ajax();
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
        try{
            thisObj.disabled = false;
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                Jraf.showMessageBox({
                    text: '<span class="error">同步用户信息出错，请联系系统管理员！</span>'
                });
                return;
            }
            var rcd = pkg.rspDatas().Record;
            var oprName = rcd.oprName;
            var status = rcd.status;
            var errorMessage = rcd.errorMessage;
            if (status == '0') {
                Jraf.showMessageBox({
                    text: '<span class="error">同步用户信息出错:  '+errorMessage+'</span>'
                });
                return;
            }
            Jraf.showMessageBox({
                text: '<span class="success">同步用户信息成功.</span>',
                onClose: function () {
                    doSearch();//刷新用户列表
                }
            });
            
        }catch(e){alert('[method=syncUser]ERROR:'+e.message);}
        
    });
    
}
</script>
</html>
