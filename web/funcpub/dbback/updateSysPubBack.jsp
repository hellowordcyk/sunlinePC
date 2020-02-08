<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 修改库备份配置
 * description: 
 *     1. 修改库备份配置
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysPubBack' type='crypto'/>&actions=<sc:fmt value='updateSysPubBack' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label"><span class="redmust">*</span>功能类型</td>
					<td class="form-value">
						<sc:text name="funcname" readonly="true" index="1"/>
                        <sc:text name="functype" index="1" style="display:none;"></sc:text>
					</td>
					<td class="form-label"><span class="redmust">*</span>数据库类型</td>
					<td class="form-value">
						<sc:optd  name="dbtype"  index="1"  type="dict" key="pcmc,dbType"  />
						<sc:hidden name="dbtype" index="1"/>
					</td>
				</tr>
				<tr>
					<td class="form-label">对应语句</td>
					<td class="form-value">
						<sc:textarea rows="2" cols="30"  index="1" name="exesql" />
					</td>
					<td class="form-label">语句参数名称</td>
					<td class="form-value">
						<sc:textarea rows="2" cols="30"  index="1" name="paraname" />
					</td>
				</tr>
				<tr>
					<td class="form-label">语句参数默认值</td>
					<td class="form-value">
						<sc:textarea rows="2" cols="30"  index="1" name="paravalue" />
					</td>
					<td class="form-label">备注</td>
					<td class="form-value">
						<sc:textarea rows="2" cols="30"  index="1" name="remark" />
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