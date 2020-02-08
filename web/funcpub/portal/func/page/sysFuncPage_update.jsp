<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 功能页面
 * description: 
 *    修改功能页面信息；
 * author: 
 * createtime:
 * logs:
 *--%>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='sysFuncPageActor' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updateSysFuncPage' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent" layoutH="50">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label"><span class="redmust">*</span>页面编码</td>
					<td class="form-value">
						<sc:text id="funcCode" name="funcCode" readonly="true" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>页面名称</td>
					<td class="form-value">
						<sc:text id="funcName" name="funcName" validate="required" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>页面地址</td>
					<td class="form-value">
						<sc:text id="funcUrl" name="funcUrl" validate="required" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>页面参数</td>
					<td class="form-value">
						<sc:text id="funcParam" name="funcParam" validate="required" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">页面描述</td>
					<td class="form-value">
						<sc:textarea id="funcDesc" name="funcDesc" rows="3" cols="60" style="resize:none;" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">是否菜单</td>
					<td>
						<sc:sradio name="funcIsMenu" index="1" default="0" type="dict" key="pcmc,boolflag"/>
					</td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar">
        <ul>
            <li>
                <button class="savebtn" type="submit">保存</button>
            </li>
<!--             <li> -->
<!--                 <button class="close" type="button">取消</button> -->
<!--             </li> -->
        </ul>
    </div>
</form>
