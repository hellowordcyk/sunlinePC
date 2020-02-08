<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp" %>
<c:set var="record" value="${jrafrpu.rspPkg.rspRcdDataMaps[0]}"/>
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="form-table">
    <tr><th colspan="4">操作员详细信息</th></tr>
    <tr>
        <td width="30%" class="form-label">用户编号：<font color="red">*</font></td>
        <td width="70%" class="form-value">${record.usercode }</td>
    </tr>
    <tr>
        <td class="form-label">用户名：<font color="red">*</font></td>
        <td class="form-value">${record.username}</td>
    </tr>
    <tr>
        <td class="form-label">部门编号：<font color="red">*</font></td>
        <td class="form-value">${record.deptcode}</td>
    </tr>
    <tr>
        <td class="form-label">部门名称：<font color="red">*</font></td>
        <td class="form-value">${record.deptname}</td>
    </tr>
    <tr>
        <td class="form-label">联系电话：</td>
        <td class="form-value">${record.phone}</td>
    </tr>
    <tr>
        <td class="form-label">每页显示记录数：<font color="red">*</font></td>
        <td class="form-value">${record.pagesize}</td>
    </tr>
    <tr>
        <td class="form-label">是否冻结：<font color="red">*</font></td>
        <td class="form-value"><sc:optd name="disable" value="${record.disable}" type="dict" key="pcmc,boolflag" /></td>
    </tr>
    <tr>
        <td class="form-label">备注：</td>
        <td class="form-value">
            <textarea name="remark" readonly="readonly" class="inputarea" cols="20" rows="3">${record.remark}</textarea>
        </td>
    </tr>
    <tr>
        <td colspan="4" class="form-bottom" align="center">
            <!--<sc:button value="修改" onclick="doModify();"/> -->
            <sc:button value="重置密码" onclick="isInitPsw();"/>
        </td>
    </tr>
    </table>
<script type="text/javascript" defer="defer">
function doModify()
{
    var userid = document.forms[0].elements("userid").value;
    var url = '/pcmc/sm/UserUpdate.jsp?sysName=<sc:fmt type="crypto" value="pcmc"/>'
        + '&oprID=<sc:fmt type="crypto" value="sm_query"/>&actions=<sc:fmt type="crypto" value="getUserDetail"/>'
        + '&userid='+userid;
    url += "&s_time=" + (new Date().getTime());
    var w = openModal(url,800,500);
    if (w != null && w == true) {
        document.location.href = "/pcmc/sm/UserDetail.jsp?userid=" + userid + "&s_time=" + (new Date().getTime());
        window.returnValue=true;//关闭窗口，刷新
        getUserDetail();//UserDetil.jsp页面方法
    }
}
function isInitPsw(){
    Jraf.showMessageBox({
        text: '重置密码将用户密码初始化为888888，是否继续？',
        type: 'choose',
        onYes: function(){
            init_password();
        } ,
        onNo: function(){}
    });
}
function init_password()
{
    var params = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:      '<sc:fmt type="crypto" value="sm_maintenance"/>',
        actions:    '<sc:fmt type="crypto" value="initPassword"/>',
        userid:     '${param.userid}'
    };
   var ajax = new Jraf.Ajax({asynchronous: false});//同步
   ajax.sendForXml("/xmlprocesserservlet", params, function (xml) {
       try{
           var pkg = new Jraf.Pkg(xml);
           if(pkg.result() != '0'){
               Jraf.showMessageBox({
                   text: '初始化密码失败。',
                   type: 'error'
               });
               return;
           }
           Jraf.showMessageBox({
               text: '初始化密码成功。',
               type: 'success',
               onOk: function(){
               } 
           });
       }catch(e){alert('[method=init_password]ERROR:'+e.message);}
   });
}
</script>
