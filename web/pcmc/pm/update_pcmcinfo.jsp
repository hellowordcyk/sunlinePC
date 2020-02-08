<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>更新公告信息</title>
    <%@ include file="/common.jsp"%>
</head>
<body>
<sc:form name="frmcog"  action="/xmlprocesserservlet" 
    sysName="pcmc" oprID="info" actions="updatePcmcInfo" forward="/pcmc/message/query_pcmcinfo.jsp" method="post">
    <sc:hidden name="infoid" />
    <table width="100%" cellpadding="0" cellspacing="0" class="form-table">
        <tr><th colspan="4">更新公告信息</th></tr>
        <tr>
    		<td class='form-label'>所属系统：</td>
    		<td class='form-value' colspan="3">
				<sc:select name="subsys" index="1" req="1" type="subsys" key="" >
				
       			</sc:select></td>
    		</tr>
        <tr>
            <td class="form-label">公告标题：<span style="color: red;">*</span></td>
            <td class="form-value" colspan="3">
                <sc:text name="title" req="1" index="1" attributesText="maxlength='30' style='width: 90%'"/>
            </td>
        </tr>
        <tr>
            <sc:datepicker dsp="td" dspName="生效时间" type="datetime" name="startdt" index="1" req="1" pattern="%Y-%m-%d %H:%M:%S"/>
            <sc:datepicker dsp="td" dspName="终止时间" type="datetime" name="enddt" index="1" req="1" pattern="%Y-%m-%d %H:%M:%S"/>
        </tr>   
        <tr>
            <td class="form-label" style="text-align: center;">公告内容：<span style="color: red;">*</span>
                <div><span class="hint_info">还可输入<span id="numId" style="font-weight: blod; color: red;">1000</span>个字</span></div>
            </td>
            <td class="form-value" colspan="3">
                <sc:textarea name="content" dspName="公告内容" 
                    attributesText="id='contentId' style='width: 90%;' maxlength='1000' onkeyup='countLen(this)'"
                    cols="50" rows="18" req="1" index="1"/>
            </td>
        </tr>
        <tr>    
        <td colspan="4" class="form-bottom">
            <sc:button value="保存" name="saveBtn" onclick="saveOk();"/>
            <sc:button value="重写" type="reset"/>
            <sc:button value="关闭" onclick="window.close();"/>
        </td>
        </tr>
</table>
</sc:form>
</body>
<script language="javascript">
document.observe("dom:loaded", function () {
    countLen($$("textarea[name=content]")[0]);
    //selPushType($("noId"));
});
function saveOk()
{
    var oForm = document.forms["frmcog"];
    if(!checkForm(oForm, event)){//form表单校验
        return;
    }
    if(!compareDate(oForm.elements("startdt"), oForm.elements("enddt"))){
        return;
    }
    var oBtn = oForm.elements("saveBtn");
    oBtn.disabled = true; 
    var ajax = new Jraf.Ajax();
    ajax.submitFormXml(oForm,function(xml){
        try{
            oBtn.disabled = false;
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                Jraf.showMessageBox({
                    text: '<span class="error">保存出错！\n'+pkg.allMsgs() + '</span>',
                    onOk: function(){
                        window.closed();
                    }});
                return;
            }
            window.returnValue = true;
            Jraf.showMessageBox({text: "<span class='success'>" + "保存成功。" + "</span>",
                onOk: function(){
                        window.close();
                }});
            
        } catch(e) {
            alert("[method=saveOk]jserror:" + e.message);
        }
    });
}
function countLen(thisObj) {
    var val = thisObj.value;
    var count = 1000 - val.length;
    if (count <= 0) {
        thisObj.value = val.substr(0, 1000);
        event.returnValue = false;
        Jraf.showMessage({
            text: "可输入内容长度大于1000，将截断内容。",
            type: "warn"
        });
        count=0;
    } 
    $("numId").innerText=count;
}
</Script>
</html>