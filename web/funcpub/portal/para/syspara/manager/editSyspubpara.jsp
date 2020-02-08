<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:修改系统参数
 * description: 
 *     1.修改系统参数
 * author:
 * createtime:
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-sysparamanage' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updateSyspara' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
	
	<sc:hidden name="paracode" index="1"/>
	<sc:hidden name="valuetype" index="1"/>
	<div class="pageContent" width="100%">
		<div class="pageFormContent">
		<table class="form-table" cellpadding="0" cellspacing="0" >
			<tr>
				<td class="form-label">参数编码</td>
				<td class="form-value"><sc:write name="paracode" /></td>
			</tr>
			<tr>
				<td class="form-label">参数名称</td>
				<td class="form-value"><sc:write name="paraname" /></td>
			</tr>
			<tr>
				<td class="form-label">参数值</td>
				<td class="form-value">
					<c:choose>
						<c:when test="${jrafrpu.rspPkg.rspRcdDataMaps[0].valuetype == 'D'}">
							<sc:date name="paravalue" index="1"/>
						</c:when>
						<c:otherwise>
						<c:choose>
						   <c:when test="${jrafrpu.rspPkg.rspDataMap.warn==1}">
						     <sc:text name="paravalue" value="" />
						     <input type="hidden"  id="warnning" value="1" />
						   </c:when>
						    <c:otherwise>
							  <sc:text name="paravalue" index="1" />
							</c:otherwise>
						</c:choose>
					    </c:otherwise>
					</c:choose>
				</td>
			</tr>
			<tr>
				<td class="form-label">备注</td>
				<td class="form-value">
					<sc:textarea name="remark" rows="2" index="1" cols="66" style="resize:none;"/>
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
	  var warnning=$("#warnning").val();
	  if(warnning==1){
		  alertMsg.error("解密错误请重置密码");
	  }
  });
</script>
