<%--[saveBrchbtn:保存机构;]--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%@ page import="java.util.*"%>
<%@ page import="org.jdom.*" %>
<%@ include file="/common.jsp" %>
<%
    String deptname = null;
    String pdeptname = null;
    String linkman = null;
    String levelp = null;
    Element record = null;
    Document xmlDoc = (Document) request.getAttribute("xmlDoc");
    if(xmlDoc != null){
    	record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
        deptname = record.getChildText("deptname");
        pdeptname = record.getChildText("pdeptname");
        linkman = record.getChildText("linkman");
        levelp = record.getChildText("levelp");
    }
    deptname = (deptname == null ? "" : deptname);
    linkman  = (linkman == null ? "" : linkman);
    levelp   = (levelp == null ? "" : levelp);
%>
<html>
 <sc:form name="saveForm" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="sm_maintenance" actions="updateOrgDept">
 <sc:hidden name="deptid" value='${param.deptid}'/>
                <table id="headerId" align="center" class="form-table" border="0" width="100%"  cellspacing="0" cellpadding="0" style="margin: 0px;">
                      <tr><th colspan="4">本级机构信息</th></tr>
                      <tr>
                          <sc:text dsp="td" name="deptcode" dspName="部门编号" req="1" index="1" attributesText="readonly='readonly'" />
                          <sc:text dsp="td" name="deptname" dspName="部门名称" req="1" index="1"/>
                      </tr>
                      <tr>
                           <td align="right" class="form-label">联系人：<font color="red">*</font></td>
                            <td class="form-value" >
                                <input type="hidden" name="linkman" value="<%=linkman%>" maxlength=20 class="inputtext"  customtype="num"  displayname="联系人" readonly/>
                                <input type="text" name="linkm" value="<%=linkman%>" readonly maxlength=40 class="inputtext" displayname="联系人" req="1"/>
                                <img src="/common/images/pic01/sel_person.gif" border=0 align="absmiddle" style="CURSOR: hand" onClick="javascript:getPerson_linkman();"/>
                            </td>
				   			<sc:select dsp="td" req="1" dspName="机构类型" name="orgtype" type="knp" key="pcmc,orgtype" includeTitle="false" nullOption="---请选择---" dspValue="true" index="1"/>
                      </tr>
				   			
                      <tr>
                          <sc:text dsp="td" name="phone" dspName="联系电话" req="0" index="1" type="phone" attributesText="maxLength='12'"/>
                          <sc:text dsp="td" name="levelp" dspName="机构层次" req="0" index="1" />
                          <input name="mlevelp" type="hidden" value="<%=levelp %>"/>
                      </tr>
                      <tr>
                            <sc:text dsp="td" name="brsmna" dspName="机构简称" req="0" index="1" />
                            <sc:text dsp="td" name="remark" dspName="备注" req="0" index="1" />
                      </tr>
                      <tr>
	                      <td align="right" class="form-label">上级部门名称：</td>
                           <td class="form-value">
                                   <sc:hidden index="1" name="brchno" />
                                   <sc:hidden index="1" name="pdeptid" />
                                   <sc:text name="pdeptname" dspName="所属部门" req="1" attributesText="readonly='readonly'"  index="1"/>
                                   <input type="button" id="#" name="img_search" onclick="getDept();" src="" class="search" />    
                           </td>
	                 </tr>
                      <tr>
                        <td colspan="4" class="form-bottom">
                            <sc:button value="保存" name="saveBtn" attributesText="id='saveBrchbtn' _jraf_sys_usersync" onclick="doSave()"/>
                        </td>
                     </tr>
                </table>
</sc:form>
<script language="JavaScript" type="text/javascript" defer="defer">
         /** 保存 */
    //判断当前用户有无权限修改信息
    isHasPriv();
    init();
    var g_levelp = '';
    function isHasPriv(){
        var deptid = '${param.deptid}';     
        if(!exists(deptid,dept)){
            document.getElementsByName('saveBtn')[0].disabled='true';
        }
    }
    function init(){
      $$("input[name='levelp']")[0].disabled=true;
    }
    function doSave() {
        var saveForm = document.forms["saveForm"];
        if (checkForm(saveForm)){
             var deptcode = document.getElementsByName("deptcode")[0].value;
             var deptname = document.getElementsByName("deptname")[0].value;
             var key = 'n'+'${param.deptid}';
             var node= jraftreemenu.treeContext.nodes[key];
             $(node.label).update(deptname+'['+deptcode+']');
             Object.extend(node.tag,{deptname:deptname,deptcode:deptcode}); 
             ajaxSubmit(saveForm, "保存本级机构信息成功！", "保存本级机构信息异常：");
            }
}
/** Ajax 提交方法 */
function ajaxSubmit(form, successMsg, failMsg) {
    var ajax = new Jraf.Ajax({ evalJS:false, evalJSON:false });
    ajax.submitFormXml(form, function(xml){
        try {
            var pkg = new Jraf.Pkg(xml); 
            if(pkg.result() != '0'){
                Jraf.showMessageBox({title: "提示信息", text: "<span class='error'>" + failMsg + pkg.allMsgs('<br>') + "</span>"});
            } else {
                Jraf.showMessageBox({title: "提示信息", text: "<span class='success'>" + successMsg + "</span>"});
                //initItlgList();    // 刷新修改记录列表
            }
        } catch(e) {
            alert('ERROR:' + e);
        }
    });
}
function getPerson_linkman()
    {
        var tmp1 = document.saveForm.linkman.value;
        var tmp= document.saveForm.linkm.value;
        var deptid = '${param.deptid}';
        var urlStr = '/public/pbSelPerson.jsp?deptid=&receiveuser='+encodeURI(encodeURI(tmp))+'&receiveuserid='+tmp1+'&multi=0';
        var w = openModal(urlStr,800,480);
        if(w !=null||w !=undefined)
        {
            document.saveForm.linkman.value = w[0];
            document.saveForm.linkm.value = w[1];
        }
    }
function getDept(){
    var oForm = document.forms["saveForm"];
    var receiveDept = oForm.elements("deptname").value;
    var receiveDeptid = oForm.elements("deptid").value;
    var urlStr = '/pcmc/picker/deptPicker.jsp?receiveDept='+receiveDept+'&receiveDeptid='+receiveDeptid+'&multi=0';;
    var w = openModal(urlStr,650,450);
    if(w !=null)
    {
        oForm.elements("pdeptid").value = w[0].deptid;//部门id
        oForm.elements("brchno").value = w[0].deptcode;//部门编号
        oForm.elements("pdeptname").value = w[0].deptname;//部门名称
    }
}
</script>
<%@include file="/common_priv_usersync.jsp" %>
</html>
