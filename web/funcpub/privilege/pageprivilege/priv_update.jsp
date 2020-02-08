<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 标签权限配置页面
 * description: 
 *     1.修改每一个权限标签的权限值
 * author: daoge
 * createtime: 2016.12.6
 * logs:
 *--%>
<form class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone)" method="post"
     action="/httpprocesserservlet">
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
    <input type="hidden" name="oprID" value="<sc:fmt value='page-privilege' type='crypto'/>"/>
    <input type="hidden" name="actions" value="<sc:fmt value='savePagePriv' type='crypto'/>"/>
    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" />
	<sc:hidden name="systemCode" index="1"/>
	<sc:hidden name="roleId" value="${param.roleId}"/>
	<sc:hidden name="pageName" index="1"/>
	<sc:hidden name="pageNamespace" index="1"/>
	<input type="hidden" name="privData" value="" index="1"/>
	<div class="pageContent">
		<div >
			<h2 class="contentTitle" style="text-align:left; margin: 0;">页面名称：${jrafrpu.rspPkg.rspRcdDataMaps[0].pageTitle}&nbsp;&nbsp; 命名空间：${jrafrpu.rspPkg.rspRcdDataMaps[0].pageNamespace}</h2>
		</div>
		<table class="list" cellpadding="0" cellspacing="0" style="width:100%;margin:0px auto;line-height:30px;">
			<thead>
				<tr>
					<th>标签名称</th>
					<th>标签类型</th>
					<th>权限信息</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
					<tr style="height:30px;line-height:30px;">
	                    <td class="form-label" style="text-align: left;">
	                    	<input type="hidden" name="privId" value="${item.privId }"/>
	                    ${item.privDesc}[${item.privId }]</td>
	                    <td class="form-value">
	                        ${item.nodeType }
	                    </td>
	                    <td>
	                    	<c:set var="exclude_vals" value="" />
	                    	<%--
	                    	<c:choose>
	                    		<c:when test="${fn:contains(item.nodeType,'checkbox') or fn:contains(item.nodeType,'radio') or fn:contains(item.nodeType,'date') or item.nodeType eq 'select' or item.nodeType eq 'selres' }">
	                    			<c:set var="exclude_vals" value="2" />
	                    		</c:when> --%>
	                    		<c:if test="${item.nodeType eq 'hide' or item.nodeType eq 'button'}">
	                    			<c:set var="exclude_vals" value="2,3,4" />
	                    		</c:if>
	                    	<%--</c:choose> --%>
	                    	<sc:dradio name="${item.privId }" type="dict" key="pcmc,pagePrivCode" default="${item.privValue }" excludes="${exclude_vals}" ></sc:dradio>
	                    </td>
	                </tr>
	            </c:forEach>
	        </tbody>
		</table>
	</div>
	<div class="formbutton_bg" >
		<ul>		
			<li><button class="savebtn" type="button" onclick="submitForm(event)">保存</button></li>
		</ul>
	</div>
</form>
<script type="text/javascript">
	var pageScope = navTab.getCurrentPanel().data("#grantBox2");
	function submitForm(event) {
		var privData = "";
		$(".list tbody",pageScope).find("tr").each(function(i,e) {
			var privId = $(this).find("input[name='privId']").first().val();
			var privValue = $(this).find("input[name='"+privId+"']:checked").first().val();
			privData+=privId+":"+privValue+";";
		});
		if(privData.indexOf(";")>-1) {
			privData = privData.substring(0,privData.length-1);
		}
		$("input[name='privData']",pageScope).first().val(privData);
		$(event.target).closest("form").submit();
	}
</script>