<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp" %>
<sc:form name="save_oForm" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="sm_maintenance" actions="grantUserRole">
    <sc:hidden name="userid" value="${record.userid}"/>
    <div class="page-title" style="width: 100%; margin: 0px;">
        <span class="title">角色授权</span>
        <div style="width: 100%; padding: 5px;">
            <table border="0" cellpadding="0" cellspacing="0" class="form-table" style="width: 98%;">
            <tr>
                <sc:select name="subsysid" type="subsys" dspName="所属子系统" req="1" dsp="td" attributesText="onchange='fillRole();'" />
            </tr>
            </table>
            <table width="98%" border="0" cellpadding="0" cellspacing="0" >
            <tr>
            <td width="45%" valign="top">
              <div style="height:300px; margin: 0px;" class="page-title">
                <span class="title">未授权角色</span>
                <select id="rnogrant" name="rnogrant" style="width:100%;height:273px;" ondblclick="rGrantSingle()" multiple>
                </select>
              </div>
            </td>
            <td width="10%">
              <table cellpadding="0" cellspacing="0">
                <tr><td align="center"><input type="button" class="btn_mail" value=" 授权&gt;&gt; " onclick="rGrantSingle()"></td></tr>
                <tr><td>&nbsp;</td></tr>
                <tr><td align="center"><input type="button" class="btn_mail" value="&lt;&lt;取消  " onclick="rUnGrantSingle()"></td></tr>
                <tr><td>&nbsp;</td></tr>
                <tr><td align="center"><input type="button" class="btn_mail" value="全授权&gt;&gt;" onclick="rGrantAll()"></td></tr>
                <tr><td>&nbsp;</td></tr>
                <tr><td align="center"><input type="button" class="btn_mail" value="&lt;&lt;全取消" onclick="rUnGrantAll()"></td></tr>
              </table>
            </td>
            <td width="45%" valign="top">
              <div style="height:300px; margin: 0px;" class="page-title"><span class="title">已授权角色</span>
                <select id="rgranted" name="rgranted" style="width:100%;height:273px;" ondblclick="rUnGrantSingle()" multiple>
                </select>
              </div>
            </td>
            </tr>
            </table>
        </div>
    </div>
</sc:form>
<script type="text/javascript" defer="defer">
init();

/****角色授权******************************/
var roleid,rolena,cnname;

//页面初始化时加载
//window.onload=
function init(){
    var oForm = document.forms["save_oForm"];
    var sysSel=oForm.elements("subsysid").options;
    sysSel[0].selected = true;
    //初始化userid
    oForm.elements("userid").value = document.forms[0].elements("userid").value;
    fillRole();
};

//异步取得机构列表
function fillRole(){
    removeAllSelOpt();
    var oForm = document.forms["save_oForm"];
    var sysSel=oForm.elements("subsysid");
    var subsysid=sysSel.options[sysSel.selectedIndex].value;

    var ajax = new Jraf.Ajax({evalJS:false, evalJSON:false});
    // 定义取得未授权机构的参数
    var ungrantRoleParam={
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:      '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getUnGrantRoleList"/>',
        userid:     oForm.elements("userid").value,
        subsysid:   subsysid
    };
    ajax.sendForXml('/xmlprocesserservlet', ungrantRoleParam, function(lRoleXml){
        try{
            var pkg = new Jraf.Pkg(lRoleXml);
            var ugRoleArr = pkg.rspDatas().Record;
            // 为空则拼装成空数组
            if(!ugRoleArr)
                ugRoleArr = [];
            // 非数组则拼装成数组
            if(!Object.isArray(ugRoleArr)) 
                ugRoleArr = [ugRoleArr];
            if(ugRoleArr!=null && ugRoleArr.length>0){
                for(var i = 0; i < ugRoleArr.length; i++){
                    roleid = ugRoleArr[i].roleid;
                    rolena = ugRoleArr[i].rolename;
                    addGrantSelOpt('rnogrant', roleid , rolena, rolena);
                }
            }
        } catch (e) {
            alert('fillRole:ungrant:ERROR:'+e);
        }
    });
    // 定义取得授权机构的参数
    var grantRoleParam={
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:      '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getGrantRoleList"/>',
        userid:     oForm.elements("userid").value,
        subsysid:   subsysid
    };
    ajax.sendForXml('/xmlprocesserservlet', grantRoleParam, function(rRoleXml){
        try{
            var pkg = new Jraf.Pkg(rRoleXml);
            var gRoleArr = pkg.rspDatas().Record;
            // 为空则拼装成空数组
            if(!gRoleArr)
                gRoleArr = [];
            // 非数组则拼装成数组
            if(!Object.isArray(gRoleArr)) 
                gRoleArr = [gRoleArr];
            if(gRoleArr!=null && gRoleArr.length>0){
                for(var i = 0; i < gRoleArr.length; i++){
                    roleid = gRoleArr[i].roleid;
                    rolena = gRoleArr[i].rolename;
                    addGrantSelOpt('rgranted', roleid , rolena, rolena);
                }
            }
        } catch (e) {
            alert('fillRole:granted:ERROR:'+e);
        }
    });
}

/** 角色单授权按钮事件 */
function rGrantSingle() {
    var oForm = document.forms["save_oForm"];
    oForm.actions.value='<sc:fmt type="crypto" value="grantUserRole"/>';
    ajaxSubmit(oForm,false, 'rnogrant', 'rgranted');
}
/** 角色单取消按钮事件 */
function rUnGrantSingle() {
    // 设置执行取消授权操作的actions
    var oForm = document.forms["save_oForm"];
    oForm.actions.value='<sc:fmt type="crypto" value="delSingleUserRole"/>';
    ajaxSubmit(oForm,false, 'rgranted', 'rnogrant');
}
/** 角色全授权按钮事件 */
function rGrantAll() {
    var oForm = document.forms["save_oForm"];
    oForm.actions.value='<sc:fmt type="crypto" value="grantUserRole"/>';
    var rnograntSel=oForm.rnogrant.options;
    // 将左边未授权的角色全选
    for(var i=0;i<rnograntSel.length;i++){
        rnograntSel[i].selected = true;
    }
    ajaxSubmit(oForm,true, 'rnogrant', 'rgranted');
}
/** 角色全取消按钮事件 */
function rUnGrantAll() {
    var oForm = document.forms["save_oForm"];
    // 设置执行取消授权操作的actions
    oForm.actions.value='<sc:fmt type="crypto" value="delAllUserRoles"/>';
    ajaxSubmit(oForm,true, 'rgranted', 'rnogrant');
}

/** 清空所有选择控件 */
function removeAllSelOpt(){
    removeSelOpt('rnogrant');
    removeSelOpt('rgranted');
}

/** Ajax提交 **/
function ajaxSubmit(formName,isAll,fromSelId, toSelId){
    var ajax = new Jraf.Ajax({evalJS:false, evalJSON:false});
    ajax.submitFormXml(formName, function(xml){
        try {
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() == '0'){
                grantSelOpt(isAll, fromSelId, toSelId);
            }else{
                Jraf.showMessageBox({
                    text:'<span class="error">' + pkg.hintMsg() + '</span>'
                });
            } 
        } catch(e) {
            alert('ERROR:' + e);
        }
    });
}
/********************/
/** 选择控件添加项 */
function addGrantSelOpt(selId, value, text, title) {
    var option = new Option();
    option.value = value;
    option.text = text;
    option.title = title;
    $(selId).options.add(option, $(selId).length);
}
/** 初始化清空选择控件 */
function removeSelOpt(selId) {
    var opts = $(selId).options;
    var length = opts.length;
    for(var i = length - 1; i >= 0; i--){
        opts.remove(i);
    }
}
/** 通用授权工具方法 */
function grantSelOpt(isAll, fromSelId, toSelId) {
    var rNoGropts = $(fromSelId).options;
    var length = rNoGropts.length;
    /* 正序添加 */
    for(var i = 0; i < length; i++){
        if(isAll || rNoGropts[i].selected){
            addGrantSelOpt(toSelId, rNoGropts[i].value, rNoGropts[i].text, rNoGropts[i].title);
        }
    }
    for(var i = length - 1; i >= 0; i--){
        if(isAll || rNoGropts[i].selected){
            rNoGropts.remove(i);
        }
    }
}

function goBack(){
    history.go(-1);
}
</script>
