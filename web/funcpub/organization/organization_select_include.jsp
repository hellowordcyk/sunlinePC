<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<sc:select name="orgcode" type="xml" sysName="funcpub" oprID="organizationActor"
     actions="queryNoPager" nameField="orgcode" valueField="orgname"
     includeTitle="false" index="1" nullOption="--请选择--" default="${param.orgcode }"/>
<a class="add" title="组织管理" lookupGroup=""  width="500" height="400" close="refreshOrg"  noclear=""
		href="/funcpub/organization/organization_add.jsp"><span>新增组织</span></a>
