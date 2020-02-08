<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增功能页面
 * description: 
 *     1.新增功能页面
 * author: longjian
 *--%>
  <h2 class="contentTitle">功能页面信息</h2>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='func-page' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updateFuncPage' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<sc:hidden name="pType" index="1"/>
	<sc:hidden name="pageIsleaf" index="1" />
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
				    <c:choose>
				        <c:when test="${param.pType=='menu' }">
				            <td class="form-label">上级菜单</td>
		                    <td class="form-value">
		                        <sc:hidden name="pmenuid" index="1"/>
		                        <sc:text name="pmenuname" readonly="true" index="1"/>
		                    </td>
				        </c:when>
				        <c:otherwise>
				            <td class="form-label">上级页面</td>
                            <td class="form-value">
                                <sc:hidden name="pPagecode" index="1"/>
                                <sc:text name="pPagename" readonly="true" index="1"/>
                            </td>
				        </c:otherwise>
				    </c:choose>
				</tr>
				<tr>
				    <td class="form-label"><span class="redmust">*</span>页面编码</td>
                    <td class="form-value">
                        <sc:text name="pageCode" readonly="true" validate="required" index="1"/>
                    </td>
				</tr>
				<tr>
                    <td class="form-label"><span class="redmust">*</span>页面名称</td>
                    <td class="form-value"><sc:text name="pageName" validate="required" index="1"/></td>
                </tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>所属子系统</td>
					<td class="form-value">
						<input type="hidden" name="pageSubsysid" index="1"/>
						<sc:optd name="pageSubsysid" type="subsys"  index="1"/>
					</td>
				</tr>
				<tr>
                    <td class="form-label"><span class="redmust">*</span>页面地址</td>
                    <td class="form-value"><sc:text name="pageLinkUrl" validate="required" index="1"/></td>
                </tr>
				<tr>
					<td class="form-label">页面描述</td>
					<td class="form-value"><sc:textarea name="pageDesc" rows="3" cols="60" style="resize:none;" index="1"/></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formbutton_bg">
        <ul>
            <li><button class="savebtn" type="submit">保存</button></li>
        </ul>
    </div>
</form>
