<%--[privcontrole:title:daoge测试权限页面;modulecode:daoge_text;]--%>
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
<sc:priv namespace="funcpub.post_update"/>
<sc:doPost sysName="funcpub" oprId="page-privilege" action="test" scope="request"
    var="rspPkg" all="true"
    ></sc:doPost>
    <c:set var="xmlDoc" value="${rspPkg.pkg }" /> 
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='postActor' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='update' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
               	<sc:hide privid="text_priv_tr" privdesc="text_priv_tr权限">
	                <tr>
	                	<td class="form-label">text</td>
	                    <td class="form-value">
	                    	<sc:text name="text_priv" privid="text_priv" privdesc="text权限"  validate="required" index="1"/>
	                    </td>
	                </tr>
                </sc:hide>
                <tr>
                	<td class="form-label">textarea</td>
                    <td class="form-value">
                    	<sc:textarea name="textarea_priv" rows="3" cols="50" index="1" privid="textarea_priv" privdesc="textarea权限"/>
                    </td>
                </tr>
                <tr>
                	<td class="form-label">select</td>
                    <td class="form-value">
                    	<sc:select name="select_priv"  privid="select_priv" privdesc="select权限" includeTitle="false" dspValue="true" default="1" index="1">
                    		<sc:option value="1">开启</sc:option>
                    		<sc:option value="2">停止</sc:option>
                    	</sc:select>
                    	<sc:select name="select_priv" type="dict" key="pcmc,pagePrivCode"  privid="select_priv" privdesc="select权限" includeTitle="false" dspValue="true" default="1" index="1">
                    	</sc:select>
                    </td>
                </tr>
                <tr>
                	<td class="form-label">selres</td>
                    <td class="form-value">
                    	<sc:selres name="selres_priv" type="dept" key="pcmc" privid="selres_priv" privdesc="selres权限" index="1"></sc:selres>
                    </td>
                </tr>
                <tr>
                	<td class="form-label">date</td>
                    <td class="">
                    	<sc:date name="date_priv" dateFmt="yyyy-MM-dd HH:mm:ss" privid="date_priv" privdesc="date权限" index="1"></sc:date>
                    </td>
                </tr>
                <!-- 
                <tr>
                	<td class="form-label">datepicker</td>
                    <td class="">
                    	<sc:datepicker pattern="yyyy-MM-dd HH:mm:ss" name="datepicker_priv" privid="datepicker_priv" privdesc="datepicker权限" index="1"></sc:datepicker>
                    </td>
                </tr>
                 -->
                <tr>
                	<td class="form-label">dradio</td>
                    <td class="">
                    	<sc:dradio name="dradio_priv" privid="dradio_priv" privdesc="dradio权限" index="1" type="dict" key="pcmc,roletp" />
                    </td>
                </tr>
                <tr>
                	<td class="form-label">sradio</td>
                    <td class="">
                    	<sc:sradio name="sradio_priv" privid="sradio_priv" privdesc="sradio权限" index="1" type="dict" key="pcmc,roletp" />
                    </td>
                </tr>
                <tr>
                	<td class="form-label">dcheckbox</td>
                    <td class="">
                    	<sc:dcheckbox name="dcheckbox_priv" privid="dcheckbox_priv" privdesc="dcheckbox权限" index="1" type="dict" key="pcmc,roletp" />
                    </td>
                </tr>
                <tr>
                	<td class="form-label">scheckbox</td>
                    <td class="">
                    	<sc:scheckbox name="scheckbox_priv" dspValue="true" privid="scheckbox_priv" privdesc="scheckbox权限" index="1" type="dict" key="pcmc,roletp" />
                    </td>
                </tr>
			</table>
		</div>
	</div>
	<div class="formBar">
        <ul>
            <li>
            	<sc:button privid="button_priv" privdesc="button权限" type="submit" _class="savebtn" value="保存"/>
            </li>
            <li>
                <button class="close" type="button">取消</button>
            </li>
        </ul>
    </div>
</form>
