<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增岗位
 * description: 
 *    修改岗位信息；
 * author: 
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='PostMain' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updatePost' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label"><span class="redmust">*</span>岗位编号</td>
					<td class="form-value">
						<sc:text id="paracd" name="paracd" readonly="true" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>岗位名称</td>
					<td class="form-value">
						<sc:text id="parana" name="parana" validate="required" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">排序</td>
					<td class="form-value">
						<sc:text name="sortno" validate="digits" index="1"/>
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
            <li>
                <button class="close" type="button">取消</button>
            </li>
        </ul>
    </div>
</form>
