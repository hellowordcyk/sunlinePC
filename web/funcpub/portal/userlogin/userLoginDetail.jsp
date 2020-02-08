<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:用户解锁
 * description: 
 *     1.用户解锁
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<div class="pageHeader">
	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
    	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='funcpub'/>"/>
    	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='userLoginDetail'/>"/>
    	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='getUserLockDetail'/>"/>
    	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/userlogin/userLoginDetail.jsp' />"/>
        
        <sc:hidden name="jraf_initsubmit" />
     	<div class="searchBar">
    		<table class="searchContent" cellpadding="0" cellspacing="0" >
    			<tr>
    				<td class="form-label">用户账号</td>
    				<td class="form-value"><sc:text name="userCode" id="userCode"/></td>
    				<td class="form-label">状态</td>
    				<td class="form-value">
    					<input type="checkbox" name="disable" value="1" style="width:30px;min-width: 0;" 
    					<c:if test="${empty jrafrpu.rspPkg.reqDataMap or 1 eq jrafrpu.rspPkg.reqDataMap.disable}">checked="checked"</c:if>/>禁用
    					
    					<input type="checkbox" name="frozen" value="1" style="width:30px;min-width: 0;"
    					<c:if test="${empty jrafrpu.rspPkg.reqDataMap or 1 eq jrafrpu.rspPkg.reqDataMap.frozen}">checked="checked"</c:if>/>冻结
    				</td>
    				<td align="right">
	                     <button class="querybtn" jraf_initsubmit type="submit">查询</button>                      
	                     <button class="resetbtn" type="reset">清空</button>                        
                    </td>
    			</tr>
    		</table>
    	</div>
	</form>
</div>
<div class="pageContent">
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th>用户账号</th>
				<th>用户名</th>
				<th>手机</th>
				<th>是否被禁用</th>
				<th>是否被冻结</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="6">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
    			<c:forEach var="userLockLog" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
    				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
    					<td>${userLockLog.userCode }</td>
    					<td>${userLockLog.userName }</td>
    					<td>${userLockLog.phone }</td>
    					<td><sc:optd name="disable" type="dict" key="pcmc,boolflag" value="${userLockLog.disable }" /></td>
    					<td><sc:optd name="disable" type="dict" key="pcmc,boolflag" value="${userLockLog.frozen }" /></td>
    					<td>
    						<c:if test="${1 eq userLockLog.disable or '1' eq userLockLog.disable}">
    							<a class="btnUnlock" href="#" onclick="enableUser('${userLockLog.userId }')" >解禁</a>
    							<c:if test="${'1' eq jrafrpu.rspPkg.rspDataMap.hasWorkflow}">
    								<a class="btnAgency" rel="flow_todo_taskList" target="dialog" 
	    								href="/workflow/function/flow_todo_task_list.jsp?usercode=${userLockLog.userCode}"
	    								height="500" width="900">
	    								待办任务
	    							</a>
    							</c:if>
    						</c:if>
    						<c:if test="${1 eq userLockLog.frozen or '1' eq userLockLog.frozen}">
    							<a class="btnUnlock" href="#" onclick="lockUser('${userLockLog.userId }')" >解冻</a>
    						</c:if>
    						<a class="btnView" rel="QueryCaCtlDataClear" target="dialog" 
    							href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='userLoginDetail' type='crypto'/>&actions=<sc:fmt value='getUserLoginDetail' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/userlogin/userLoginList.jsp' type='crypto'/>&userId=${userLockLog.userId}"
    							height="400" width="800" >查看日志</a>
    					</td>
    				</tr>
    			</c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="navTab" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div>
<script type="text/javascript">
function lockUser(userId){
	var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='userLoginDetail' type='crypto'/>&actions=<sc:fmt value='lockUser' type='crypto'/>';
	$.ajax({
		type:"POST",
		url:url,
		data:"userId="+userId,
		dateType:"xml",
		success:function(msg){
			var data = $(msg).find("msg").text();
			if("success" == data){
				alertMsg.correct("解冻成功!");
			}else{
				alertMsg.error("解冻失败!");
			}
			$("#pagerForm",navTab.getCurrentPanel()).submit();
		},
		error:function(XMLHttpRequest, textStatus, errorThrown){
			alert("系统异常,请稍后重试或联系管理员!");
			alert(textStatus);
		}
	});
}
function enableUser(userId){
	var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='userLoginDetail' type='crypto'/>&actions=<sc:fmt value='enableUser' type='crypto'/>';
	$.ajax({
		type:"POST",
		url:url,
		data:"userId="+userId,
		dateType:"xml",
		success:function(msg){
			var data = $(msg).find("msg").text();
			if("success" == data){
				alertMsg.correct("解禁成功!");
			}else{
				alertMsg.error("解禁失败!");
			}
			$("#pagerForm",navTab.getCurrentPanel()).submit();
		},
		error:function(XMLHttpRequest, textStatus, errorThrown){
			alert("系统异常,请稍后重试或联系管理员!");
			alert(textStatus);
		}
	});
	
}
</script>
