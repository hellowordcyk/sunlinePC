<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div class="pageHeader">
<form onsubmit="return divSearch(this, 'userGrant_divid');" action="/httpprocesserservlet" id="userGrant_divid_pagerForm"  method="post">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='getPcmcUserDeptList' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/userpriv/deptManagerRootUserList.jsp' />"/>
	<input type="hidden" name="pageNum" value="1" />
	<sc:hidden name="lookupcode" value="usercode" />
	<sc:hidden name="lookupname" value="username" />
	<sc:hidden name="lookupdeptname" value="deptname" />
    
     <%-- 规范： 初始化查询必加隐藏表单 --%>
     <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">用户编码/名称</td>
                    <td class="form-value"><sc:text name="username" /></td>
					<td class="form-label">机构编码/名称</td>
					<td class="form-value"><sc:text name="deptname"/></td>
					<td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <button class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
				</tr>
			</table>
		</div>
	</form>
<div class="pageContent" id="userGrant_divid" >
	 

</div>
</div>
<script type="text/javascript">

function resetQuery(btnObj){
	var $searchBar = $(btnObj).parents("form .searchBar");
	//获取searchBar下面的所有文本框，赋值为空
	var $texts = $searchBar.find("input[type='text']");
	$.each($texts, function(){
		$(this).val("");
	});
	
	//获取form下面的所有文本框，赋值为空
	var $hiddens = $searchBar.find("input[type='hidden']");
	$.each($hiddens, function(){
		$(this).val("");
	});
}
</script>