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
						  href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>&actions=<sc:fmt value='getUserById' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/portal/organization/userInfo.jsp'/>&userid=<c:out value='${param.id }' />&showType=box">
							<span>用户信息</span>
					</a></li>
					<!-- 
				<li><a href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='grantResourceToUserActor' type='crypto'/>&actions=<sc:fmt value='getAllConfigs' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/privilege/user/grantResourseToUserMain.jsp'/>&userid=<c:out value='${param.id }' />"
				    target="ajax" rel="userManagerBox2"><span>用户资源授权</span></a></li>
			     -->
				</ul>
			</div>
		</div>

		<div class="tabsContent" >
			<div id="userManagerBox1" layoutH="45"></div>
			<!-- <div id="userManagerBox2"></div> -->
		</div>
		<div class="tabsFooter">
			<div class="tabsFooterContent"></div>
		</div>
	</div>
</div>
