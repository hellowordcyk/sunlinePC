<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 修改角色首页配置
 * description: 
 *     1.修改角色首页配置
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
     #tr_cellCoordinate{
       display:none;
     }
 </style>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
	<input type="hidden" name="oprID" value="<sc:fmt value='aphmp-roleFunc' type='crypto'/>" />
	<input type="hidden" name="actions" value="<sc:fmt value='updateRoleFunc' type='crypto'/>" />
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />" />
	
	<div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<sc:hidden name="id" index="1"/>
				<tr>
					<td class="form-label"><span class="redmust">*</span>角色名称</td>
					<td class="form-value">
						<sc:text name="rolename" validate="required" index="1"></sc:text>
						<sc:hidden name="roleid" index="1"/>
						<a rel="queryCust" class="btnLook" width="600" title="选择角色" height="400"  lookupGroup=""
									href="/funcpub/portal/role/role_searchTab.jsp?lookupCodeField=roleid&lookupNameField=rolename"></a>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>功能</td>
					<td class="form-value">
						<sc:select name="functionid" validate="select required" index="1">
							<c:forEach var="function" items="${jrafrpu.rspPkg.rspRcdDataMapsResults3}" varStatus="index1">
							<c:choose>
							  <c:when test="${jrafrpu.rspPkg.rspRcdDataMaps[0].functionid eq function.functionID}">
							    <option selected="true" value="${function.functionID}">${function.functionName}</option>	
							  </c:when>
							  <c:otherwise>
							     <option value="${function.functionID}">${function.functionName}</option>	
							  </c:otherwise>
							</c:choose>
		                   </c:forEach>
						</sc:select>
					</td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>配置类型</td>
					<td class="form-value">
						<sc:hidden name="oldRegistertype" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].registertype}" index="1"/>
						<sc:select id="registertype"  name="registertype"   type="dict" key="pcmc,registerType" index="1" includeTitle="false" />
					</td>
				</tr>
				
				
				<tr class="tab">
					<td class="form-label"><span class="redmust">*</span>菜单顺序</td>
					<td class="tab form-value">
						<sc:text name="sortnum"  index="1"></sc:text>
					</td>
				</tr>
				<tr class="config">
                    <td class="form-label"><span class="redmust">*</span>窗体位置</td>
                    <div  id="tr_cellCoordinate">
                        <sc:text id="cellCoordinate_text" name="cellcoordinate" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].cellcoordinate}" ></sc:text>
                    </div>
						<td class="form-value">
					  <span class="redmust">行</span>
						<sc:select name="cellCoordinateRow"  >
						     <c:forEach var= "temp"   begin= "1"   step= "1"   end="9">
						         <option value="${temp}">${temp}</option>
						     </c:forEach>
                        </sc:select>
                        <span class="redmust">列</span>
						<sc:select name="cellCoordinateCol"   >
						     <c:forEach var= "temp"   begin= "1"   step= "1"   end="9">
						         <option value="${temp}">${temp}</option>
						     </c:forEach>
                        </sc:select>
					</td>
					</td>
				</tr>
				<tr class="config">
					<td class="form-label"><span class="redmust">*</span>窗体高度</td>
					<td class="form-value">
						<sc:text name="height"  id="windows_height"   index="1"   attributesText="min='100'  max='900'" ></sc:text>px
					</td>
				</tr>
				<tr class="config">
					<td class="form-label"><span class="redmust">*</span>窗体宽度</td>
					<td class="form-value">
						<sc:text name="widthrate"   id="windows_widthRate"    index="1" attributesText="min='10'  max='98'"></sc:text>%
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
		parseCellCoordinate();
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
	function parseCellCoordinate(){
		var cellCoordinate=$("#cellCoordinate_text").val();
		console.log(cellCoordinate);
		var cellCoordinateRow=cellCoordinate.substring(0,1);
		var cellCoordinateCol=cellCoordinate.substring(1); 
		$("select[name='cellCoordinateRow']").val(cellCoordinateRow);
		$("select[name='cellCoordinateCol']").val(cellCoordinateCol);
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
