<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<script src="/governor/corp/corpmanage/corp_imageUpload.js" type="text/javascript"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:将用户密码更新为MD5加密
 * description: 
 *     将用户密码更新为MD5加密
 * author: lihu
 * createtime: 20170822
 * logs:
 *
 *--%>
<sc:doPost sysName="governor" oprId="upgradeActor" action="getUserPwdCount"
	scope="request" var="rspPkg"></sc:doPost>
<form class="pageForm required-validate" action="/httpprocesserservlet"
	onsubmit="return navTabSearch(this)" method="post">
	<input type="hidden" name="sysName" value="<sc:fmt value='governor' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='upgradeActor' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='convertPwd2MD5' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/governor/upgrade/userpwd2md5.jsp'/>"/>
	<div class="pageContent">
		<div class="pageFormContent">
				<h2 class="contentTitle">密码MD5升级</h2>
				<table class="form-table" cellpadding="0" cellspacing="0">
					<tr>
						<td class="form-label" style="width:20%">总数</td>
						<td><sc:write name="desCount" value="${rspPkg.rspRcdDataMaps[0].allCount}"/>
						</td>
					</tr>
					<tr>
						<td class="form-label" style="width:20%">原DES密码数</td>
						<td><sc:write name="desCount" value="${rspPkg.rspRcdDataMaps[0].desCount}"/>
							<span class="info">DES加密</span>
						</td>
					</tr>
					<tr>
						<td class="form-label" style="width:20%">MD5密码数</td>
						<td><sc:write name="md5Count" value="${rspPkg.rspRcdDataMaps[0].md5Count}"/>
							<span class="info">MD5加密</span>
						</td>
					</tr>
				</table>
		</div>
	</div>
	<div class="page-tip" >
	    <span class="tip-title info">温馨提示</span>
	    <p>DES加密是原有系统的加密方式，是一种通过密钥加密算法，可解密</p>
	    <p>MD5加密又称摘要算法、哈希算法，是一种散列函数，不可解密</p>
	    <p>系统升级为MD5加密，如果使用最新的版本，需要升级所有用户密码为MD5加密密码，请点击本页面下方的升级按钮升级</p>
	    <p>只有DES密码数大于0时，页面才显示升级按钮</p>
    </div>
	<div class="formBar">
		<ul>
			<c:if test="${rspPkg.rspRcdDataMaps[0].desCount > 0}">
				<li><button class="savebtn" type="submit" >升级为MD5加密</button></li>
			</c:if>
			<li><button class="close" type="button">取消</button></li>
		</ul>
	</div>
</form>