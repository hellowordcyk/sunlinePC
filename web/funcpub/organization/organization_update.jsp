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
	<input type="hidden" name="oprID" value="<sc:fmt value='organizationActor' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='update' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
                    <td class="form-label">
                        <span class="redmust">*</span>组织编码
                    </td>
                    <td class="form-value">
                        <sc:text name="orgcode" readonly="true" validate="alphanumeric"  attributesText="maxlength='32' minlength='4'"  index="1"/>
                    </td>
                </tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>组织名称</td>
					<td class="form-value">
						<sc:text name="orgname" validate="required" index="1"/>
					</td>
				</tr>
				<tr>
                	<td class="form-label">组织类型</td>
                	<td >
                		<sc:select name="orgType" type="knp" key="pcmc,organizationType" index="1" includeTitle="false" nullOption="--请选择--"></sc:select>
                	</td>
                </tr>
				<tr>
                	<td class="form-label"><span class="redmust">*</span>是否禁用</td>
                	<td >
                		<sc:dradio name="disable" index="1" default="0" type="dict" key="pcmc,boolflag"></sc:dradio>
                	</td>
                </tr>
                <tr>
					<td class="form-label">排序</td>
					<td class="form-value">
						<sc:text name="sortNum" validate="digits" index="1"/>
					</td>
				</tr>
				<tr>
                    <td class="form-label">
                        	描述
                    </td>
                    <td class="form-value">
                        <sc:textarea name="remark" rows="3" cols="50" index="1"/>
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
