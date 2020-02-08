<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%-- 个人信息快速修改 --%>
<script type="text/javascript">
		$("#userInfoManagerBox1").loadUrl(
				"/funcpub/public/userinfo/userInfoPerson.jsp", {},
				function() {
				}); //进来自动加载第一个tab
</script>
<div class="pageContent">
	<div class="tabs" currentIndex="0" eventType="click">
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li><a
						href="/funcpub/public/userinfo/userInfoPerson.jsp"
						target="ajax" rel="userInfoManagerBox1"><span>修改个人信息</span></a></li>
					<li><a onclick="openPassWordDialog('2','userInfoManagerBox2');"
						rel="userInfoManagerBox2"><span>修改密码</span></a></li>
				</ul>
			</div>
		</div>

		<div class="tabsContent">
			<div id="userInfoManagerBox1"></div>
			<div id="userInfoManagerBox2"></div>
		</div>

		<div class="tabsFooter">
			<div class="tabsFooterContent"></div>
		</div>
	</div>
</div>
