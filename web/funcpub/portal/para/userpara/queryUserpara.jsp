<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用户参数</title>
</head>
<body>
<div id="managerUserpara">
<div class="pageHeader">
	<form  id="pagerForm" action="/httpprocesserservlet" onsubmit="return navTabSearch(this);" method="post"> 
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-userpara' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='queryUserparaInfo' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/para/userpara/queryUserpara.jsp' />"/>
   
    <%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
	
   
    <%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
	
	<input type="hidden" name="pageNum" value="1" />
	
		<div class="searchBar">
			<table class="searchContent" width="100%">
				<tr>
					<td align="right">参数名称</td>
					<td><sc:text name="looks.paraname" /></td>
					<td align="right">所属区域</td>
					<td>
						<select id="queryAreaSelect" name="looks.areano">
							<option value="" >--请选择--</option>
							<c:forEach var="ruleArea" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1}"  varStatus="ruleAreaStatus">
								<c:if test="${ruleArea.areano == jrafrpu.rspPkg.rspDataMap.areano}">
									<option value="${ruleArea.areano}" selected="selected">${ruleArea.areaname}</option>
								</c:if>
								<c:if test="${ruleArea.areano != jrafrpu.rspPkg.rspDataMap.areano}">
									<option value="${ruleArea.areano}">${ruleArea.areaname}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<td align="right">状态</td>
					<td><sc:select name="looks.status" type="dict" key="pams,inptst"  includeTitle="false" nullOption="--请选择--"></sc:select></td>
					<td align="right"><button id="showUserparaBtn" class="button"  jraf_initsubmit  type="submit">查询</button></td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div class="pageContent" >
	<table class="table list" width="100%">
		<thead>
			<tr>
				<!-- <th width="25px"><input type="checkbox" class="checkboxCtrl" group="paracodes" /></th> -->
				<th>参数名称</th>
				<th>所属区域</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="para" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
				<tr>
					<%-- <td><input type="checkbox"  name="paracodes" value="${para.paracode}"/></td> --%>
					<td>${para.paraname}</td>
					<td>${para.areaname}</td>
					<td>
						<a href="javascript:void(0)" class="btnEdit" onclick='showUserpara("${para.paracode}")'>查看</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
</table>
<div class="panelBar">
	<div class="pagination" targetType="dialog" totalCount="${ jrafrpu.rspPkg.rspRecordCount}" numPerPage="${ jrafrpu.rspPkg.rspPageSize }" pageNumShown="${ jrafrpu.rspPkg.rspPageCount}" currentPage="${ jrafrpu.rspPkg.rspPageNo}">
	</div>
</div>		
</div>	
</body>
<script type="text/javascript">
function showUserpara(paracode){
	if(paracode != null || paracodeparacode != ""){
		var url = "/funcpub/portal/para/userpara/showUserpara.jsp?paracode="+paracode;
		$.pdialog.open(url,"editUserpara","查看用户参数", {width:900,height:450,minable:false,maxable:false,mask:true});
	}else{
		alertMsg.error('请选择一条记录!');
	}
}
</script>
</html>