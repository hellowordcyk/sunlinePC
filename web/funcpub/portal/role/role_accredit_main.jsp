<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 将角色 授权用户
 * description: 
 *     1.将角色 授权用户
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160624 优化布局
 *--%>
<div class="pageHeader">
	<form id="role_accredit_divid_pagerForm" onsubmit="return divSearch(this,'role_accredit_divid');"
		action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" /> 
        	<input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>" /> 
        	<input type="hidden" name="actions" value="<sc:fmt value='queryGrantRoleUser' type='crypto'/>" /> 
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/role/role_accredit_main_list.jsp' />" />
		<sc:hidden name="selected" value="${jrafrpu.rspPkg.rspDataMap.selected}" />
		<div class="searchBar">
			<sc:hidden name="roleid"/>
			<sc:hidden name="jraf_initsubmit" />

			<table class="searchContent" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">用户名称</td>
					<td class="form-value"><sc:text name="username" /></td>
					<td class="form-label">机构名称</td>
					<td class="form-value">
                        <sc:hidden name="deptID" /> 
                        <sc:text name="deptname" readonly="true" /> 
                        <a class="btnLook" title="选择机构"  lookupGroup="" width="900" height="500"
                            href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=deptID&lookupname=deptname"></a>
                    </td>
					<td class="form-btn" >
                        <ul>
                            <li>
                                <button id="role_accredit_main_queryBtn" class="querybtn" jraf_initsubmit type="submit">查询</button>
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
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li>
			<a  class="add" mask="true" rel="post_update" target="dialog" close="reloadGrantDl" 
				href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='queryUngrantRoleUser' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/portal/role/role_accredit.jsp' />&roleid=<c:out value='${param.roleid }'/>" height="550" width="900"  fresh="true" >
				<span>授权</span>
			</a>
			</li>
			<li class="line">line</li>
			<li>
                <a class="delete" group="paramp" targetType="navTab"
    				target="selectedTodo" title="确定要取消授权所选记录吗?"
    				callback="reloadGrantDl"
    				href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='cancleGrantRoleUser' type='crypto'/>&roleid=<c:out value='${param.roleid }'/>&forward=<sc:fmt type='crypto' value='/jui/callMessage.jsp' />">
                    <span>取消</span>
                </a>
            </li>
			<li class="line">line</li>
		</ul>
	</div>
	<div id="role_accredit_divid">
		<table class="table" cellpadding="0" cellspacing="0" >
			<thead>
				<tr>
					<th class="checkbox"><input type="checkbox" class="checkboxCtrl"
						group="paramp" /></th>
					<th>用户编号</th>
					<th>用户名称</th>
					<th>所在机构</th>
				</tr>
			</thead>
			<tbody>
               <tr>
                   <td class="empty" colspan="4">查询无数据。</td>
               </tr>
            </tbody>
       </table>
	</div>
</div>
<script>

function reloadGrantDl() {
	$("#role_accredit_main_queryBtn").click();
	return true;
}

//机构选择控件回显 
function deptTreeCallBack(deptArray,dept){
    $("[name='deptID']",$("body").data("addspecialnessRectify")).val(dept.deptID);
    $("[name='deptname']",$("body").data("addspecialnessRectify")).val(dept.deptName);
}
</script>
