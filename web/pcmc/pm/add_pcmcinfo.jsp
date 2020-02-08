<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>新增公告信息</title>
    <%@ include file="/common.jsp"%>
</head>
<body style="padding: 5px;">
<script language="javascript">
    var hintmsg="<sc:value name='/DataPacket/Response/Hint/Msg'/>";
    var result ="<sc:value name='/DataPacket/Response/@result'/>";
    if(result == '-99'){
        Jraf.showMessageBox({
            text: '<span class="error">保存出错！\n'+hintmsg + '</span>'
        });
    }
    if(result == '0'){
        Jraf.showMessageBox({
            text: "新增公告成功。",
            type: "success",
            onOk: function(){
                window.close();
            }});
    }
    
</script>
<sc:form name="frmcog" encType="multipart/form-data" target="uploadIframe"
    action="/public/upload_success.so?button=saveBtn" sysName="pcmc" oprID="info" actions="addPcmcInfo"  method="post">
<div class="tab-table-contain">
    <div class="tab-table-title">
        <span class="tab-title-left"></span> 
        <span class="tab-title-right">新增公告信息</span>
    </div>
</div>
<div id='baseId' class="tab-table-body" style="margin: 0;">
    <table width="100%" cellpadding="0" cellspacing="0" class="form-table" style="margin:0;">
    <tr>
    <td class='form-label'>所属系统：</td>
    <td class='form-value' colspan="3">
		<sc:select name="subsys" default="1" type="subsys" key="" >
       	</sc:select></td>
    </tr>
    <tr>
        <td class="form-label">公告标题：<span style="color: red;">*</span></td>
        <td class="form-value" colspan="3">
            <input type="text" name="title" class="inputtext" displayName="公告标题" req="1" style='width: 90%' maxlength='30'/>
        </td>
    </tr>
    <tr>
        <sc:datepicker dsp="td" dspName="生效时间" type="datetime" name="startdt" req="1" pattern="%Y-%m-%d %H:%M:%S"/>
        <sc:datepicker dsp="td" dspName="终止时间" type="datetime" name="enddt" req="1" pattern="%Y-%m-%d %H:%M:%S"/>
    </tr>    
    <tr>
        <td class="form-label" style="text-align: center;">公告内容：<span style="color: red;">*</span>
            <div><span class="hint_info">还可输入<span id="numId" style="font-weight: blod; color: red;">1000</span>个字</span></div>
        </td>
        <td class="form-value" colspan="3">
            <sc:textarea name="content" dspName="公告内容" 
                attributesText="id='contentId' style='width: 90%;' maxlength='1000' onkeyup='countLen(this)'"
                cols="50" rows="17" req="1" index="1"/>
        </td>
    </tr>    
    <tr>
        <td class="form-label">添加附件:</td>
        <td class="form-value" colspan="3">
            <input type="file" class="inputfile" name='filename' style="width: 90%;"/>
        </td>
    </tr>
    <tr>
        <td class="form-label">通知方式：</td>
        <td class="form-value" colspan="3">
            <label for="noId">
                <input id="noId" type="checkbox" class="inputcheckbox" onclick="selPushType(this)"
                       name='' value="0"/>不提醒
            </label>
            <label for="popId">
                <input id="popId" type="checkbox" class="inputcheckbox" value="POPUP" name='sndmod' checked="checked"
                       />系统弹出框提醒（默认）
            </label>
            <label for="messageId">
                <input id="messageId" type="checkbox" class="inputcheckbox" value="SMS" name='sndmod'
                       />短信提醒
            </label>
            <label for="mailId">
                <input id="mailId" type="checkbox" class="inputcheckbox" value="EMAIL" name='sndmod'/>邮件提醒
            </label>
        </td>
    </tr>
    <tr>
        <th colspan="4">指定接收对象（可选）</th>
    </tr>
    <tr>
        <td class="form-label">接收人员：</td>
        <td class="form-value" colspan="3">
            <sc:hidden name="userid" attributesText="id='useridsId' "/>
            <sc:hidden name="usercd" />
            <input type="text" class="inputtext" name='username' readonly="readonly"  style="width: 90%;"/>
            <input type="button" name="img_search" onclick="selUser('useridsId');" src="" class="search" style="cursor: pointer;" /> 
        </td>
    </tr>
    <tr>
        <td class="form-label">接收部门：</td>
        <td class="form-value" colspan="3">
            <sc:hidden name="brchno" />
            <sc:hidden name="deptid" />
            <sc:text name="deptname" dspName="所属部门" attributesText="id='deptnameId' readonly='readonly' style='width: 90%'"/>
            <input type="button" name="img_search" onclick="getDept();" src="" class="search" style="cursor: pointer;" />
            <div style="padding: 1px 1px;">
                <label for="isTraversalId">
                    <input id="isTraversalId" type="checkbox" value="1" name="isTraversal" class="inputcheckbox" style="margin: 0;"/>是否包括下级部门人员
                </label>
            </div>
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
</div>
</sc:form>
<%-- 避免重复提交 --%>
<iframe id="uploadIframeId" name="uploadIframe" style="height: 0; width: 0;display: none; font-weight: ">
</iframe>
</body>
<script type="text/javascript">
document.observe("dom:loaded", function () {
    //selPushType($("noId"));
});

function saveOk()
{    
    var formObj = document.forms["frmcog"];
    if(!checkForm(formObj, event)){//form表单校验
        return;
    }
    if(!compareDate(formObj.elements("startdt"), formObj.elements("enddt"))){
        return;
    }
    Jraf.ProgressStart();
    var oBtn = formObj.elements("saveBtn");
    oBtn.disabled = true; 
    formObj.oprID.value='<sc:fmt type="crypto" value="info"/>';
    formObj.actions.value='<sc:fmt type="crypto" value="addPcmcInfo"/>';
    formObj.submit();
}
function uploadCallBack(msg) {
    Jraf.ProgressEnd();
    if (msg.indexOf("成功") != -1) {
        Jraf.showMessageBox({
            text: '保存成功!',
            type: 'success',
            onClose: function () {
                window.returnValue=true;
                window.close();
            }
        });
    } else {
        Jraf.showMessageBox({
            text: msg,
            type: 'error'
        });
    }
}

function countLen(thisObj) {
    var val = thisObj.value;
    var count = 1000 - val.length;
    if (count <= 0) {
        thisObj.value = val.substr(0, 1000);
        event.returnValue = false;
        Jraf.showMessageBox({
            text: "可输入内容长度大于1000，超出部分将截断。",
            type: "warn"
        });
        count=0;
    } 
    $("numId").innerText=count;
}

function selPushType(thisObj) {
    if (thisObj.checked == true) {
        $("popId").disable();
        $("messageId").disable();
        $("mailId").disable();
    } else {
        $("popId").enable();
        $("messageId").enable();
        $("mailId").enable();
    }
}

function selUser(id) {
    var oForm = document.forms["frmcog"];
    var userObj = $(id);
    var url = "/pcmc/picker/userPicker.jsp?receiveuserid="+userObj.value+"&s_time="+(new Date().getTime());
    var w = openModalToIframe(url, {title: "选择人员"}, 700,410);
    if(w !=null)
    {
        var userids = "";
        var usercds = "";
        var username = "";
        for (var i = 0, len = w.length; i < len; i ++) {
            var obj = w[i];
            userids += obj.userid;
            usercds += obj.usercd;
            username += obj.username;
            if ((i+1) != len) {
                userids += ",";
                usercds += ",";
                username += ",";
            }
        }
        oForm.elements("userid").value = userids;//部门id
        oForm.elements("usercd").value = usercds;//部门编号
        oForm.elements("username").value = username;//部门名称
    }
}
function getDept(){
    var oForm = document.forms["frmcog"];
    var receiveDeptid = oForm.elements('deptid').value;

    var urlStr = '/pcmc/picker/deptPicker.jsp?multi=1&receivedeptid='+receiveDeptid;
    var w = openModal(urlStr,700,410);
    if(w !=null)
    {
        var deptids = "";
        var brchnos = "";
        var names = "";
        for (var i = 0, len = w.length; i < len; i ++) {
            var obj = w[i];
            deptids += obj.deptid;
            brchnos += obj.deptcode;
            names += obj.deptname;
            if ((i+1) != len) {
                deptids += ",";
                brchnos += ",";
                names += ",";
            }
        }
        oForm.elements("deptid").value = deptids;//部门id
        oForm.elements("brchno").value = brchnos;//部门编号
        oForm.elements("deptname").value = names;//部门名称
    }
}  
</script>
</html>