<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<div class="pageContent" style="padding-bottom:8px;">
   <div class="tabs" currentIndex="0" eventType="click"  >
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li initTab="true">
                        <a  id="role_info_tab"  href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='queryRole' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/portal/role/role_update.jsp' />&roleid=${param.roleId}"
                        	target="ajax" rel="role_info_ctt"
                        >
                            <span>角色基础信息</span>
                        </a>
					</li>
					<li>
                    	<a id="user_priv_tab" href="/funcpub/portal/role/role_accredit_main.jsp?roleid=${param.roleId}" 
                           target="ajax" rel="user_priv_ctt">
                           <span>角色用户管理</span>
                        </a>
                    </li>
				</ul>
			</div>
		</div>
		<div class="tabsContent">
			<div id="role_info_ctt"></div>
			<div id="user_priv_ctt"></div>
			<div id="menu_priv_ctt"></div>
			<div id="data_priv_ctt"></div>
			<div id="page_priv_ctt"></div>
			<div id="resc_priv_ctt"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
	function closeRolePrivTab() {
		navTab.closeCurrentTab();
	}
</script>