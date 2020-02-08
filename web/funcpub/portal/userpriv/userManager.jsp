<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/jui_tag.jsp"%>
<script charset="utf-8" language="javascript" type="text/javascript"
	src="/funcpub/portal/resource/resource.js"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<div class="pageContent">
	<div class="tabs" currentIndex="0" eventType="click">
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li initTab="true">
                        <a target="ajax" rel="userManagerBox1"
						  href="/funcpub/portal/userpriv/grantResource.jsp?userid=<c:out value='${param.userid}' />&showType=box">
							<span>资源授权页面</span>
					</a></li>
				</ul>
			</div>
		</div>

		<div class="tabsContent" >
			<div id="userManagerBox1" layoutH="45"></div>
		</div>
	</div>
</div>
