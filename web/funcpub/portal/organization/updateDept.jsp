<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 修改机构
 * description: 
 *     1.修改机构
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<form id="updateDeptDialogForm" method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updateDeptByDialog' type='crypto'/>"/>
	<sc:hidden id="oldpdeptid" name="oldpdeptid" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].pdeptid}"/>
	<sc:hidden name="deptid" index="1" validate="required" />
    <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
    
    <div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
			 <tr>
    				<td class="form-label"><span class="redmust">*</span>所属组织</td>
    				<td class="form-value" colspan="3" >
    					<c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMaps[0].orgcode}">
	    					<sc:hidden name="orgcode" index="1"/>
	    					<sc:optd name="orgcode" type="xml" sysName="funcpub" oprID="organizationActor"
	                            actions="queryNoPager" nameField="orgname" 
	                            value="${jrafrpu.rspPkg.rspRcdDataMaps[0].orgcode }" />
                        </c:if>
                        <c:if test="${empty jrafrpu.rspPkg.rspRcdDataMaps[0].orgcode}">
	    					<span class="info">数据错误，请初始化跟机构组织编码！</span>
                        </c:if> 
    				</td>
    		    </tr>
    			<tr>
                    <td style="pading: 0; height: 5px;" colspan="4">
                        <div class="divider"></div>
                    </td>
                </tr>  
                <tr>
					<td class="form-label">所属区域</td>
                    <td class="form-value">
                    <c:forEach var="area" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1}" varStatus="index">
                                <c:if test="${area.areano eq jrafrpu.rspPkg.rspRcdDataMaps[0].areano}">
                                      ${area.areaname}
                                </c:if>
                      </c:forEach>
                    </td>
				</tr>
                
                <tr>
				    <td class="form-label">上级机构名称</td>
                    <td class="form-value" colspan="3">
                        <sc:hidden id="pdeptid" index="1" name="pdeptid" />
                        <sc:text id="pdeptname" index="1" name="pdeptname" readonly="true" />
                        <sc:hidden name="pdeptcode" index="1"/>
                        <a class="btnLook" title="机构信息-单选" width="800" height="450" lookupGroup=""
                           href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=pdeptid&lookupcode=pdeptcode&lookupname=pdeptname" >
                        </a>               
                    </td>
				</tr>
                
				<tr>
					<td class="form-label"><span class="redmust">*</span>机构编码</td>
					<td class="form-value" colspan="3"><sc:text name="deptcode" validate="required" index="1" readonly="true" /></td>
				</tr>
				
				<tr>	
					<td class="form-label"><span class="redmust">*</span>机构名称</td>
                    <td class="form-value" colspan="3"><sc:text  name="deptname" validate="required" index="1" /></td>
				</tr>
				
				
				<tr>
					<td class="form-label">机构简称</td>
                    <td class="form-value"><sc:text  name="brsmna" index="1"/></td>
				</tr>
				
				
				
				
				
				<tr>
				    <td class="form-label">机构管理人员</td>
                    <td class="form-value" colspan="3">
                        <sc:hidden id="manager_usercode"  name="manager_usercode" index="1"/>
                        <sc:text id="manager_username"  name="manager_username" index="1" />
                        <!-- <a class="btnLook" title="选择管理人员" lookupGroup=""  width="900" height="500"
                         href="/funcpub/public/deptuser/userLookupMulti.jsp?lookupcode=manager_usercode&lookupname=manager_username"></a>
                         -->
                        <a class="btnLook" title="选择机构管理人员" lookupGroup=""  width="1000" height="500"
                            href="/funcpub/public/deptuser/userTreeOptionDialog.jsp?lookupcode=manager_usercode&lookupname=manager_username&elmId={manager_usercode}"></a>
                    </td>
				</tr>
				      <td class="form-label">机构性质</td>
                      <td class="form-value"><sc:select name="orgnaturetype" type="knp" key="pcmc,orgNatureType" index="1" includeTitle="false" nullOption ="---请选择----"/></td>
				
				     <td class="form-label">机构类型</td>
					 <td class="form-value"><sc:select name="orgtype" type="knp" key="pcmc,orgtype" index="1" includeTitle="false" nullOption="--请选择--"/></td>
				<tr>
				     
				</tr>
				
				<tr>
                    <td class="form-label">联系人</td>
                    <td class="form-value">
                        <sc:hidden id="linkmanForUpdateDept"  name="linkman" index="1"/>
                        <sc:text id="usernameForUpdateDept"  name="username" index="1" attributesText='onfocus="autoCompleteUser(this)"'/>
                         <a class="btnLook" title="选择联系人" lookupGroup=""  width="900" height="500"
                            href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupcode=linkman&lookupname=username"></a>
                    </td>
                    <td class="form-label">联系电话</td>
                    <td class="form-value"><sc:text  name="phone" index="1" _class="phone" attributesText="maxLength='11'"/></td>
                </tr>
				<tr>
					<td class="form-label">备注</td>
					<td  class="form-value" colspan="3"><sc:textarea  name="remark" index="1" style="resize:none" rows="2" cols="75"/></td>
				</tr>
			</table>
		</div>
	</div>
    <div class="formBar">
        <ul>
            <li><button class="savebtn" type="button" onclick="updateDept()">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>
<script type="text/javascript">
function updateDept(){
	var currentDialog = $("body").data("child_updateDept33");
	var form = $("#updateDeptDialogForm",currentDialog);
	var oldpdeptid = $("#oldpdeptid",currentDialog).val();
	var pdeptid = $("#pdeptid",currentDialog).val();
	if (!form.valid()) {
		return false;
	}
	var  sysName = '<sc:fmt value='funcpub' type='crypto'/>';
	var    oprID = '<sc:fmt value='funcpub-deptusermanager' type='crypto'/>';
	var  actions = '<sc:fmt value='updateDept' type='crypto'/>';
	var      url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions;
	$.ajax({    
        type:'post',        
        url:url,
        async:false,   
        dataType:'XML', 
        data:$(form).serialize(),
        success:function(data){   
        	var msg = $(data).find('DataPacket Response Data msg').text();
        	if("success" == msg){
        		alertMsg.correct('保存成功');
        		//if(oldpdeptid != pdeptid){
        			
        			reflush(oldpdeptid,pdeptid);
        		//}
        		var btn = $("#selectChildDeptBtn",navTab.getCurrentPanel());
    			$(btn).trigger("click");
    			var currentDialog = $("body").data("child_updateDept33");
    			$.pdialog.close(currentDialog);
        	}else{
        		alertMsg.error(msg);
        	}
        }    
    });    
}

function deptTreeCallBack(deptArray,dept){
	$("#pdeptidForUpdateDept").val(dept.deptID);
	$("#pdeptnameForUpdateDept").val(dept.deptName);
}
function userTableCallBack(userArray,user){
	$("#linkmanForUpdateDept").val(user.userCode);
	$("#usernameForUpdateDept").val(user.userName);
}
/**
 * 机构管理人员返回
 */
function managerUserTableCallBack(userArray,user){
	//取当前 dialog 上下文,避免取值范围错误 因为当选择窗口调用 回调函数时，$.pdialog.getCurrent() 还没有关闭
	var currentDialog = $("body").data("child_updateDept33");
	$("[name='manager_usercode']",currentDialog).val(user.userCode);
	$("[name='manager_username']",currentDialog).val(user.userName);
}
</script>
