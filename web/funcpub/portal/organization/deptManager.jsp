<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<title>机构管理</title>
</head>
<script type="text/javascript">
	<%-- var deptid = <%=request.getParameter("id")%>;
	if(deptid != null ){
		$("#deptManagerBox1").loadUrl("/funcpub/portal/organization/deptInfo.jsp?deptid="+deptid,{},function(){});	//进来自动加载第一个tab
	} --%>
</script>
<body>
<div class="pageContent" >
   <div class="tabs" currentIndex="0" eventType="click"  >
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li initTab="true">
                        <a href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>&actions=<sc:fmt value='getDeptById' type='crypto'/>&forward=<sc:fmt  type='crypto' value='/funcpub/portal/organization/deptInfo.jsp'/>&deptid=<c:out value='${param.id }' />&isRoot=${param.isRoot}&t=${param.t}" 
                           target="ajax" rel="deptManagerBox1">
                           <span>机构信息</span>
                        </a>
                    </li>
					<li>
                        <a href="/funcpub/portal/organization/childDept.jsp?pdeptid=<c:out value='${param.id }' />&isRoot=${param.isRoot}"  
                            target="ajax" rel="deptManagerBox2">
                            <span>下级机构</span>
                        </a>
                    </li>
					<li><a href="/funcpub/portal/organization/childUser.jsp?deptid=<c:out value='${param.id }' />&isRoot=${param.isRoot}"   target="ajax" rel="deptManagerBox3"><span>机构人员</span></a></li>
				</ul>
			</div>
		</div>
		
		<div class="tabsContent">
			<div id="deptManagerBox1"></div>
			<div id="deptManagerBox2"></div>
			<div id="deptManagerBox3"></div>
		</div>
			
	</div>
</div>
</body>

</html>