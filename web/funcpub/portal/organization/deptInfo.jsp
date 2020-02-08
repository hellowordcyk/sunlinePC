<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 机构详细信息
 * description: 
 *     1. 机构详细信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<sc:doPost sysName="funcpub" oprId="funcpub-deptusermanager" action="getDeptExtUrl" scope="request"
    var="deptExtUrl_rspPkg" all="true"></sc:doPost>

<form id="updateDeptForm" method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return divSearch(this,'deptManagerBox1');">
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
    <input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>" />
    <input type="hidden" name="actions" value="<sc:fmt value='updateDept' type='crypto'/>" />
    <sc:hidden id="oldpdeptid" name="oldpdeptid" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].pdeptid}" />
    <div class="pageContent">
        <div class="pageFormContent">
            <sc:hidden name="deptid" validate="required" />
            <table class="form-table" cellpadding="0" cellspacing="0">
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
                        	<c:if test="${area.areano eq jrafrpu.rspPkg.rspRcdDataMaps[0].areano}">${area.areaname} </c:if>
                    	</c:forEach>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">上级机构名称</td>
                    <td class="form-value" colspan="3">
                        <sc:hidden id="pdeptid"  name="pdeptid" index="1"/>
                        <c:if test="${jrafrpu.rspPkg.rspRcdDataMaps[0].pdeptid ne '-1'}">
	                        <sc:text id="pdeptname"  name="pdeptname" index="1" readonly="true" />
	                        <sc:hidden name="pdeptcode" index="1"/>
	                        <a class="btnLook" title="机构信息-单选" width="800" height="450" lookupGroup=""
	                           href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=pdeptid&lookupcode=pdeptcode&lookupname=pdeptname" >
	                        </a>
                        </c:if>
                        <c:if test="${jrafrpu.rspPkg.rspRcdDataMaps[0].pdeptid eq '-1'}">
	                        <span>${jrafrpu.rspPkg.rspRcdDataMaps[0].pdeptname}</span>
                        </c:if>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>机构编码
                    </td>
                    <td class="form-value" colspan="3">
                        <sc:text name="deptcode" validate="required" index="1" readonly="true" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span> 机构名称 </td>
                    <td class="form-value" colspan="3">
                        <sc:text name="deptname" validate="required" index="1" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">机构简称</td>
                    <td class="form-value" colspan="3">
                        <sc:text name="brsmna" index="1" />
                    </td>
                 </tr>
                 <tr>
                    <td class="form-label">机构管理人员</td>
                    <td class="form-value" colspan="3">
                        <sc:hidden id="manager_usercode" name="manager_usercode" index="1" />
                        <sc:text id="manger_username" name="manager_username" index="1" />
                        <a class="btnLook" title="选择管理人员" lookupGroup=""  width="900" height="500"
                         	href="/funcpub/public/deptuser/userTreeOptionDialog.jsp?lookupcode=manager_usercode&lookupname=manager_username&elmId={manager_usercode}">
                         </a>
                    </td>
                </tr>
                <tr>
                	<td class="form-label">机构性质</td>
                    <td class="form-value">
                        <sc:select name="orgnaturetype" type="knp" key="pcmc,orgNatureType" index="1" includeTitle="false" nullOption="--请选择--" />
                    </td>
                    <td class="form-label"> 机构类型</td>
                    <td class="form-value">
                        <sc:select name="orgtype" type="knp" key="pcmc,orgtype" index="1" includeTitle="false" nullOption="--请选择--"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">联系人</td>
                    <td class="form-value">
	                    <sc:hidden name="linkman" index="1"/>
	                    <sc:text name="username" index="1"/>
	                    <a class="btnLook" title="选择联系人" lookupGroup=""  width="900" height="500"
	                     	href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupid=single_user_id&lookupcode=linkman&lookupname=username">
	                     </a>
                    </td>
                    <td class="form-label">联系电话</td>
                    <td class="form-value">
                        <sc:text name="phone" index="1" _class="phone" attributesText="maxLength='11'" />
                    </td>
                </tr>
                <c:if test="${not empty deptExtUrl_rspPkg.rspRcdDataMaps[0].dept_ext_url }">
	                <tr>
	                	<td id="deptExtBox" style="pading: 0; height: 5px;"colspan="4">
	                		
	                	</td>
	                </tr>
                </c:if>
                <tr>
                    <td class="form-label">备注</td>
                    <td colspan="3" class="form-value">
                        <sc:textarea name="remark" index="1" style="resize:none" rows="3" cols="75" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="formbutton_bg">
        <ul>
            <li>
                <button class="savebtn" type="button" onclick="submitForm();">保存</button>
            </li>
        </ul>
    </div>
</form>
<script type="text/javascript">
var pageScope = navTab.getCurrentPanel();
var dept_ext_url = '${deptExtUrl_rspPkg.rspRcdDataMaps[0].dept_ext_url}';
var showType = '${param.showType}';
$(function() {
	loadDeptExtUrl();
	refreshOrg();
});
function refreshOrg() {
	var defVal = $("#orgcode").val();
	$("#orgSelects").loadUrl("/funcpub/organization/organization_select_include.jsp"+"?orgcode="+defVal);
	return true;
}

function loadDeptExtUrl() {
	if(showType=="dialog") {
		pageScope = $.pdialog.getCurrent();
	}else{
		pageScope = navTab.getCurrentPanel().find("#deptManagerBox1");
	}
	if(dept_ext_url && dept_ext_url.length>0) {
		var userid = $("input[name='userid']",pageScope).val() || "";
		var deptid = $("input[name='deptid']",pageScope).val() || "";
		
		var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"
				+ "&actions=<sc:fmt value='queryDeptExt' type='crypto'/>"
				+ "&forward=<sc:fmt value='${deptExtUrl_rspPkg.rspRcdDataMaps[0].dept_ext_url}' type='crypto'/>&deptid="+deptid;
		$("#deptExtBox",pageScope).loadUrl(url);
	}
}

function submitForm(){
	var pagerForm_opcla = $("#updateDeptForm");
	var oldpdeptid = $("#oldpdeptid",navTab.getCurrentPanel()).val();
	var pdeptid = $("#pdeptid",navTab.getCurrentPanel()).val();
	
	if (!pagerForm_opcla.valid()) {
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
        data:$(pagerForm_opcla).serialize(),
        success:function(data){   
        	var msg = $(data).find('DataPacket Response Data msg').text();
        	if("success" == msg){
        		alertMsg.correct('保存成功');
        		reflush(oldpdeptid,pdeptid);
        	}else{
        		alertMsg.error(msg);
        	}
        }    
    });    
}

function deptTreeCallBack(deptArray,dept){
	$("[name='pdeptid']",navTab.getCurrentPanel()).val(dept.deptID);
	$("[name='pdeptname']",navTab.getCurrentPanel()).val(dept.deptName);
}
function userTableCallBack(userArray,user){
	$($("[name='linkman']",navTab.getCurrentPanel())).val(user.userCode);
	$($("[name='username']",navTab.getCurrentPanel())).val(user.userName);
}
/**
 * 机构管理人员返回
 */
function managerUserTableCallBack(userArray,user){
	$($("[name='manager_usercode']",navTab.getCurrentPanel())).val(user.userCode);
	$($("[name='manager_username']",navTab.getCurrentPanel())).val(user.userName);
}
</script>