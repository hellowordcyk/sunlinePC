<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增角色首页配置
 * description: 
 *     1.新增角色首页配置
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
 <style type="text/css">
     .tip_table{
        table-layout: fixed;
        width:120px;
        border-left:#000 1px solid;
        border-top:#000 1px solid;
     }
     .tip_table tr{
        height:11px;
     }
     .tip_table tr td{
        height:10px;
        border-bottom:#000 1px solid;
        border-right:#000 1px solid;
        font-size:9px;
        color:red;
        overflow: hidden;
        line-height:9px;
     }
 </style>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
	<input type="hidden" name="oprID" value="<sc:fmt value='aphmp-roleFunc' type='crypto'/>" />
	<input type="hidden" name="actions" value="<sc:fmt value='addRoleFunc' type='crypto'/>" />
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />" />
	
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label"><span class="redmust">*</span>角色名称</td>
					<td class="form-value">
						<input name="roleName" class="required"/>
						<sc:hidden name="roleID"/>
						<a rel="queryCust" class="btnLook" width="800" height="600"  lookupGroup="" title="选择角色"
									href="/funcpub/portal/role/role_searchTab.jsp?lookupCodeField=roleID&lookupNameField=roleName"></a>
						
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>功能</td>
					<td class="form-value">
						<select name="functionId" class="select required">
							<option value="">--请选择--</option>
							<c:forEach var="function" items="${jrafrpu.rspPkg.rspRcdDataMapsResults3}" varStatus="index1">
								<option value="${function.functionID}">${function.functionName}</option>	
							</c:forEach>
						</select>
					</td>
				</tr>
				
				<tr>
					<td class="form-label"><span class="redmust">*</span>配置类型</td>
					<td class="form-value">
						<sc:select id="registertype" _class="select"  name="registertype" type="dict" key="pcmc,registerType" index="1" includeTitle="false" validate="required"/>
					</td>
				</tr>
				
				<tr class="tab">
					<td class="form-label"><span class="redmust">*</span>菜单顺序</td>
					<td class="tab form-value">
						<input name="sortNum" class="required">
					</td>
				</tr>
				
				<tr class="config">
					<td class="form-label"><span class="redmust">*</span>窗体位置</td>
					<td class="form-value">
					 <span class="redmust">行</span>
						<sc:select name="cellCoordinateRow"  validate="required">
						     <c:forEach var= "temp"   begin= "1"   step= "1"   end="9">
						         <option value="${temp}">${temp}</option>
						     </c:forEach>
                        </sc:select>
                        <span class="redmust">列</span>
						<sc:select name="cellCoordinateCol"  validate="required">
						     <c:forEach var= "temp"   begin= "1"   step= "1"   end="9">
						         <option value="${temp}">${temp}</option>
						     </c:forEach>
                        </sc:select>
					</td>
				</tr>
				<tr class="config">
					<td class="form-label"><span class="redmust">*</span>窗体高度</td>
					<td class="form-value">
						<input name="height" id="windows_height" class="required" min=100   max="900"/>px
					</td>
				</tr>
				<tr class="config">
					<td class="form-label"><span class="redmust">*</span>窗体宽度</td>
					<td class="form-value">
						<input name="widthRate"  id="windows_widthRate" class="required"  min='10'  max="98"/>%
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
<script>
	$(function(){
		registerTypeFunc();
	});

	$("select#registertype").change(function(){
		registerTypeFunc();
	});
	
	function registerTypeFunc(){
		var registertype = $("select#registertype option:selected").val();  
        if(registertype == "tab"){
        	$("tr.tab").show();
        	$("tr.config").hide();
        	$("tr.tab td input").addClass("required");
        	$("tr.config td input").removeClass("required");
        } else if(registertype == "config"){
        	$("tr.tab").hide();
        	$("tr.config").show();
        	$("tr.tab td input").removeClass("required");
        	$("tr.config td input").addClass("required");
        }
	}
</script>

<style type="text/css">
	.select{
		width: 66%;
	}
	td.form-value input {
	    width: 65%;
	}
	td.form-value  #windows_widthRate, #windows_height{
	    width: 36%;
	}
</style>
