<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Date"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--规范：每个页面前必需增加注释。1）说明主要功能；2）主要功能修改日志 --%>
<%--
 * title: 法人管理-新增
 * description: 
 *     新增法人
 * author: hzx
 * createtime: 2016-09-28 10:30
 *
 *--%>
<%--规范：form属性顺序：class->onsubmit->method->其他->action --%>
<style type="text/css">
	.preview{width:260px;height:190px;border:1px solid #000;overflow:hidden;}
	.imghead {filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);}
</style>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this, dialogAjaxDone);">
    <input type="hidden" name="sysName" value="<sc:fmt value='governor' type='crypto'/>"/>
    <input type="hidden" name="oprID" value="<sc:fmt value='corpInitConfigActor' type='crypto'/>"/>
    <input type="hidden" name="actions" value="<sc:fmt value='editCorpInitConfig' type='crypto'/>"/>
    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" />
    <sc:hidden name="functionId" index="1"/>
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
            	<tr>
                    <td class="form-label"><span class="redmust">*</span>系统编码</td>
                    <td class="form-value">
                    	<sc:select name="systemCode" type="subsyscd" includeTitle="false" index="1"/>
                        <!-- <sc:text name="systemCode" validate="required alphanumeric" index="1"/> -->
                    </td>
                </tr>
            	<tr>
                    <td class="form-label"><span class="redmust">*</span>功能标题</td>
                    <td class="form-value">
                        <sc:text name="functionTitle" validate="required" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>功能表名</td>
                    <td class="form-value">
                        <sc:text name="functionTable" validate="required alphanumeric" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">自增字段</td>
                    <td class="form-value">
                        <sc:text name="sequenceField" validate="alphanumeric" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>排序号</td>
                    <td class="form-value">
                        <sc:text name="functionSortno" validate="required digits" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">法人字段</td>
                    <td class="form-value">
                        <sc:text name="corporationField" validate="alphanumeric" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">是否可选择法人</td>
                    <td>
                        <sc:dradio name="functionSelectable" type="dict" key="pcmc,boolflag" default="0" index="1"></sc:dradio>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">是否必选</td>
                    <td>
                    	<sc:dradio name="functionMandatory" type="dict" key="pcmc,boolflag" default="0" index="1"></sc:dradio>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">依赖字段</td>
                    <td class="form-value">
                        <sc:text name="refColumns"  index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">依赖表名</td>
                    <td class="form-value">
                        <sc:text name="refTables" index="1" />
                        <span class="info">依赖字段和依赖表名必须一一对应，同表依赖也必须填写，多依赖以逗号分隔</span>
                    </td>
                </tr>
                <tr>
                	<td class="form-label">数据修复类路径</td>
                    <td class="form-value">
                        <sc:text name="repairClassName" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">后台子系统编码</td>
                    <td class="form-value">
                        <sc:text name="executionSysname" validate="alphanumeric" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">后台处理类</td>
                    <td class="form-value">
                        <sc:text name="executionOprid" validate="alphanumeric" index="1"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">后台方法</td>
                    <td class="form-value">
                        <sc:text name="executionActions" validate="alphanumeric" index="1"/>
                    </td>
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
