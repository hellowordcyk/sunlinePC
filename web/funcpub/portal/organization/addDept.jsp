<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增机构
 * description: 
 *     1.新增机构
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<sc:doPost sysName="funcpub" oprId="funcpub-deptusermanager" action="getDeptExtUrl" scope="request"
    var="deptExtUrlRspPkg" all="true"></sc:doPost>
    
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='addDept' type='crypto'/>"/>
	<sc:hidden name="pdeptid" index="1"/>
	<sc:hidden name="deptid" index="1"/>
	<sc:hidden name="levelp" index="1"/>
	<sc:hidden name="orgseq" index="1"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent">
		<div class="pageFormContent">
    		<table class="form-table" cellpadding="0" cellspacing="0" >
    			<c:if test="${param.isRoot eq 'root' }">
    				<tr>
	    				<td class="form-label"><span class="redmust">*</span>所属组织</td>
	    				<td class="form-value" colspan="3" >
	    					<div id="orgSelects" style="width:60%;">
		                    </div>
	    				</td>
	    		    </tr>
	    			<tr>
	                    <td style="pading: 0; height: 5px;" colspan="4">
	                        <div class="divider"></div>
	                    </td>
	                </tr>
	                  <!--所属区域  -->
    		       <tr>
                    <td class="form-label">所属区域</td>
                    <td class="form-value"  colspan="3" >
                    <sc:select name="areano" >
                           <c:forEach var="area" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1}" varStatus="index">
                                 <sc:option value="${area.areano}">${area.areaname}</sc:option>
                            </c:forEach>
                    </sc:select>
                    </td>
                   </tr>
                </c:if>
                <c:if test="${param.isRoot ne 'root' }">
                
                <!-- 所属组织 -->
                
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
	                  <!--所属区域  -->
    		       <tr>
                    <td class="form-label">所属区域</td>
                    <td class="form-value"  colspan="3" >
                            <c:forEach var="area" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1}" varStatus="index">
                                <c:if test='${jrafrpu.rspPkg.rspRcdDataMaps[0].areano eq area.areano}'><sc:hidden  name="areano" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].areano}"/>${area.areaname}</c:if>
                            </c:forEach>
                    </td>
                   </tr>
                </c:if>
                 <!--上级机构名称  -->
                <tr>
    			     <td class="form-label">上级机构名称</td>
                    <td class="form-value" colspan="3"><sc:write name="deptname"  /></td>
    			</tr>
                
                 <!--机构编码  -->
    			<tr>
    				<td class="form-label"><span class="redmust">*</span>机构编码</td>
    				<td class="form-value" colspan="3"><input type="text"  name="deptcode" class="required alphanumeric" /></td>
    		    </tr>
    		    
    		     <!--机构名称  -->
    		    <tr>	
    				<td class="form-label"><span class="redmust">*</span>机构名称</td>
    				<td class="form-value" colspan="3"><input type="text"  name="deptname" class="required" /></td>
    			</tr>
    			
                <!--机构简称  -->
                	<tr>
    			    <td class="form-label">机构简称</td>
                    <td class="form-value" colspan="3"><sc:text  name="brsmna" /></td>
    			</tr>
                 <!--机构管理人员  -->
                <tr>
    			    <td class="form-label">机构管理人员</td>
                    <td  class="form-value" colspan="3">
                        <input type="hidden" id="managerUsercodeForAddDept"  name="manager_usercode"/>
                        <input type="text" id="managerUsernameForAddDept"  name="manager_username" />
	                    <a class="btnLook" title="选择管理人员" lookupGroup=""  width="900" height="500"
	                     href="/funcpub/public/deptuser/userTreeOptionDialog.jsp?lookupcode=manager_usercode&lookupname=manager_username&elmId={manager_usercode}"></a>
                    </td>
    			</tr>
                
                
    		<!--机构性质/机构类型-->
    			<tr>
    			   <td class="form-label">机构性质</td>
                    <td  class="form-value"><sc:select name="orgnaturetype" type="knp" key="pcmc,orgNatureType" includeTitle="false" nullOption ="---请选择----"/></td>
                    
                    <td class="form-label">机构类型</td>
    				<td class="form-value"><sc:select name="orgtype"  type="knp" key="pcmc,orgtype" includeTitle="false" nullOption ="---请选择----"/></td>
    			</tr>
    			
    			<!-- 联系人/联系电话-->
    			<tr>
    			<td class="form-label">联系电话</td>
                    <td  class="form-value"><input type="text"  name="phone" class="phone"/><span class="info" title="0XXX－XXXXXXXX｜1XXXXXXXXXX">&nbsp;&nbsp;</span>
                    </td>
    			    <td class="form-label">联系人</td>
                    <td class="form-value">
                        <input type="hidden" id="linkmanForAddDept" name="linkman" />
                        <input type="text" id="usernameForAddDept" name="username" />
                        <a class="btnLook" title="选择联系人" lookupGroup=""  width="900" height="500"
                            href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupcode=linkman&lookupname=username"></a>
                    </td>
    			</tr>
    			
    			<c:if test="${not empty deptExtUrlRspPkg.rspRcdDataMaps[0].dept_ext_url }">
	                <tr>
	                	<td id="deptExtBox1" style="pading: 0; height: 5px;"colspan="4">
	                		
	                	</td>
	                </tr>
                </c:if>
    			<!-- 备注-->
    			<tr>
    				<td class="form-label">备注</td>
    				<td  class="form-value" colspan="3"><textarea name="remark" rows="2" cols="75" style="resize:none;"></textarea></td>
    			</tr>
    		</table>
    	</div>
	</div>
    <div class="formBar">
        <ul>
            <li><button class="savebtn" type="submit">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>
<script>
var dept_ext_url = '${deptExtUrlRspPkg.rspRcdDataMaps[0].dept_ext_url}';

$(function() {
	if(dept_ext_url && dept_ext_url.length>0) {
		$("#deptExtBox1").loadUrl(dept_ext_url);
	}
	refreshOrg();
});
function refreshOrg() {
	var defVal = $("#orgcode").val();
	$("#orgSelects").loadUrl("/funcpub/organization/organization_select_include.jsp"+"?orgcode="+defVal);
	return true;
}

function userTableCallBack(userArray,user){
	$("#linkmanForAddDept").val(user.userCode);
	$("#usernameForAddDept").val(user.userName);
}

/**
 * 机构管理人员返回
 */
function managerUserTableCallBack(userArray,user){
	$("#managerUsercodeForAddDept").val(user.userCode);
	$("#managerUsernameForAddDept").val(user.userName);
}
</script>