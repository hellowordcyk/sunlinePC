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
	<input type="hidden" name="actions" value="<sc:fmt value='queryUserpara' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/para/userpara/managerUserpara.jsp' />"/>
	<a class="btnEdit"  title="查看基础指标信息配置" target="navTab" rel="showKpiInfo"
	   href="/httpprocesserservlet?sysName=<sc:fmt value='etl' type='crypto'/>&oprID=<sc:fmt value='etl-kpiQuery-kpiManage' type='crypto'/>&actions=<sc:fmt value='queryBaseKpiInfoToUpdate' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/portal/para/userpara/editUserpara.jsp' />?paracode="+paracode;"  >查看</a>
		
	
	<a class="btnEdit"  title="查看基础指标信息配置" target="navTab" rel="showKpiInfo"
	   href="/httpprocesserservlet?sysName=<sc:fmt value='etl' type='crypto'/>&oprID=<sc:fmt value='etl-kpiQuery-kpiManage' type='crypto'/>&actions=<sc:fmt value='queryBaseKpiInfoToUpdate' type='crypto'/>&forward=/funcpub/portal/para/userpara/editUserpara.jsp?paracode="+paracode;"  >查看</a>
		
	<input type="hidden" name="pageNum" value="1" />
     <%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" width="100%">
				<tr>
					<td align="right">参数名称</td>
					<td><sc:text name="looks.paraname" /></td>
					<td align="right">所属区域</td>
					<td>
						<select id="areaSelect" name="looks.areano">
							<option value="">--请选择--</option>
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
					<td align="right"><button id="queryUserparaBtn" class="button"  jraf_initsubmit  type="submit">查询</button></td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div class="pageContent" >
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" onclick="addUserpara()"><span>新增用户参数</span></a></li>
			<li><a class="delete" onclick="deleteUserpara()"><span>删除</span></a></li>
			<li class="line">line</li>
		</ul>
	</div>	
	<table class="table list" width="100%">
		<thead>
			<tr>
				<th width="25px"><input type="checkbox" class="checkboxCtrl" group="paracodes" /></th>
				<th>参数名称</th>
				<th>所属区域</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="para" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
				<tr>
					<td><input type="checkbox"  name="paracodes" value="${para.paracode}"/></td>
					<td>${para.paraname}</td>
					<td>${para.areaname}</td>
					<td>
						<a href="javascript:void(0)" class="btnDel" onclick='deleteUserpara("${para.paracode}")'>删除</a>
						<a class="btnEdit" rel="post_update" target="dialog" 
						   href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-userpara' type='crypto'/>&actions=<sc:fmt value='initEditUserparaPage' type='crypto'/>&stacid=${stacinfo.stacid}&forward=<sc:fmt type='crypto' value='/funcpub/portal/para/userpara/editUserpara.jsp' />&paracode='+'${para.paracode}';" height="455" width="750" >修改</a>
					</td>
				</tr>
			</c:forEach>
		</tbody>
</table>
<div class="panelBar">
	<div class="pagination" targetType="dialog" 
		totalCount="${ jrafrpu.rspPkg.rspRecordCount}" 
		numPerPage="${ jrafrpu.rspPkg.rspPageSize }" 
		pageNumShown="${ jrafrpu.rspPkg.rspPageCount}" 
		currentPage="${ jrafrpu.rspPkg.rspPageNo}">
	</div>
</div>		
</div>	
</body>
<script type="text/javascript">
function addUserpara(){
	var url = "/funcpub/portal/para/userpara/addUserpara.jsp";
	$.pdialog.open(url,"addUserpara","新增用户参数", {width:900,height:450,minable:false,maxable:false,mask:true});
}
function deleteUserpara(paracode){
	var paracodes = new Array();
	if(paracode != null && paracode != ""){
		paracodes.push(paracode);
	}else{
		var boxArr=document.getElementsByName("paracodes");
		for(var i=0;i<boxArr.length;i++){
			if(boxArr[i].checked){
				paracodes.push(boxArr[i].value);
			}
		}
	}
	if(paracodes.length <= 0){
		alertMsg.error('请选择信息!');
	}else{
		alertMsg.confirm("您确定要删除所选记录吗?", {
			okCall:function(){
				var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
					    + "&oprID=<sc:fmt value='funcpub-userpara' type='crypto'/>"
					    + "&actions=<sc:fmt value='deleteUserPara' type='crypto'/>"
					    + "&paracodes="+paracodes;
				$.ajax({
				    type:'POST',
				    url: url,
				    dataType:'xml',
				    success:function(data){
				    	var msg = $(data).find('DataPacket Response Data msg').text();
				    	if("success" == msg){
				    		alertMsg.correct('删除成功');
							$("#queryUserparaBtn",navTab.getCurrentPanel()).trigger("click");
				    	}else{
				    		alertMsg.error(msg);
				    	}
				    }
				}); 
			}
		});
	}
}
</script>
</html>