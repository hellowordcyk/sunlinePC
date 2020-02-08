<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<form class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone)" method="post"
     action="/httpprocesserservlet">
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
    <input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>"/>
    <input type="hidden" name="actions" value="<sc:fmt value='updateRole' type='crypto'/>"/>
    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" />
    
	<sc:hidden name="roleid" index="1"/>
	<sc:hidden name="gorgtype1" index="1"/>
	<div class="pageContent" layoutH="50">
		<div class="pageFormContent" >
			<table class="form-table" cellpadding="0" cellspacing="0">
				<tr>
                    <td class="form-label"><span class="redmust">*</span>所属系统</td>
                    <td class="form-value">
                        <sc:select name="subsysid" _class="combox" type="subsys" validate="required" default="1" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>角色名称</td>
                    <td class="form-value">
                        <sc:text name="rolename" validate="required" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">所属机构</td>
                    <td class="form-value">
                        <sc:hidden name="deptid" index = "1"/>
                        <sc:hidden name="deptcode" index="1"/>
                        <sc:text name="deptname" index="1" readonly="true"/>
                        <a class="btnLook" title="机构信息-单选" width="800" height="450" lookupGroup=""
                           href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=deptid&lookupcode=deptcode&lookupname=deptname" >
                        </a>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">权限分组</td>
                    <td class="form-value">
                        <!-- 不能增加超级管理员 value=3  超级管理员 权限分组 不能修改-->
                        <c:choose>
                        	<c:when test="${jrafrpu.rspPkg.rspRcdDataMaps[0].roletp eq 3 }">
                        		<sc:select name="roletp" type="dict" key="pcmc,roletp" 
		                            includeTitle="false" _class="disable" default="${jrafrpu.rspPkg.rspRcdDataMaps[0].roletp}" attributesText="disabled='disabled'" nullOption ="---请选择---" index="1"/>
		                        <span class="info">默认数据权限分组。</span>
                        	</c:when>
                        	<c:otherwise>
                        		<sc:select name="roletp" type="dict" key="pcmc,roletp" 
		                            includeTitle="false" excludes="3" nullOption ="---请选择---" index="1"/>
		                        <span class="info">默认数据权限分组。</span>
                        	</c:otherwise>
                        </c:choose>
                        
                    </td>
                </tr>
                <tr>
                    <td class="form-label">角色说明</td>
                    <td class="form-value">
                        <sc:textarea _class="inputText" name="remark" index="1" cols="50" rows="2" />
                    </td>
                </tr>
			</table>
		</div>
	</div>
	<div class="formBar" >
		<ul>
			<c:if test="${jrafrpu.rspPkg.rspRcdDataMaps[0].roletp!=2 and jrafrpu.rspPkg.rspRcdDataMaps[0].roletp!=3}">		
				<li><button class="savebtn" type="submit">保存</button></li>
			</c:if>
			<li><button class="close" type="button" onclick="closeRolePrivTab();">取消</button></li>
		</ul>
	</div>
</form>
