<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 用户资源授权
 * description: 
 *     1.用户资源授权
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return dialogSearch(this);" id="ungrantResource" method="post" action="/httpprocesserservlet" >
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='grantResourceToUserActor' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='getUserUnGrantedPrivilegeListPage' type='crypto'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/privilege/user/grantResourseToUser.jsp' />"/>
		<input type="hidden" name="userid1" id="userid1" value="${param.userid1}"/>
		<input type="hidden" name="pageNum" value="1" />
			
	    <%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
	
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
			    	<td class="form-label">子系统</td>
			        <td class="form-value">
			        	<select id="subsysCode1" name="subsysCode1" onchange="initPrivTypeSel()">
			        	</select>
			        </td> 
			        <td class="form-label">资源类型</td>
				    <td class="form-value">
				    	<select id="privType1" name="privType1" onchange="changePrivType()">
			        	</select>
				    </td>
                    <td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <button id="getUserResource1" class="querybtn" id="selectChildUserBtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
                </tr>
                <tr>
				    <td class="form-label">资源名称</td>
				    <td class="form-value"><sc:text name="qName1" index="1"/></td>
				</tr>
			</table>
  		</div>
	</form>
</div>

<div class="pageContent" id="contList">
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th>资源编号</th>
				<th>资源名称</th>
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="3">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
    			<c:forEach var="priv" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="Index">
    				<tr <c:if test="${Index.index%2 != 0}"> class="evenrow"</c:if> >
    					<td class="checkbox">
    						<input type="checkbox" name="paramp"/>
    						<input type="hidden" id="subsysCode" name="subSysCode" value="${priv.subsysCode }"/>
    						<input type="hidden" id="privCode" name="privCode" value="${priv.privCode }"/>
    						<input type="hidden" id="privType" name="privType" value="${priv.privType }"/>
    					</td>
    					<td align="center">${priv.privCode}</td>
    					<td align="center">${priv.privName}</td>
    				</tr>
    			</c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="dialog"
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div>  
<div class="formBar">
    <ul>
        <li><button class="savebtn" type="button" onclick="confirmFun('sel');">授权</button></li>
        <li><button class="savebtn" type="button" onclick="confirmFun('all');">授权本页</button></li>
        <li><button class="close" type="button">取消</button></li>
    </ul>
</div>  
<script>
var configs1 = null;  //子系统和权限类型配置信息
var defSubsysCode = '${param.subsysCode1}';
var defPrivType = '${param.privType1}';
var status = "-1";
$(function(){
	getAllConfigs();
	initSubsysList();
});

/**
 * 确认提示
 */
function confirmFun(type) {
	alertMsg.confirm("确定授权吗？", {
        okCall: function(){
        	grantResource(type);
        }
	});
}

/**
 * 授权函数
 */
function grantResource(type){
	var res = "[";
	if(type=="all") {
		var all1 = $("#contList tbody").find(":checkbox");
		if(all1.length < 1) {
			alertMsg.warn("没有资源可以选择！");
			return;
		}
		all1.each(function(i,e){
			res += "{";
			res += "\"privCode\":\"" + $(e).nextAll("#privCode").val() + "\",";
			res += "\"privType\":\"" + $(e).nextAll("#privType").val() + "\",";
			res += "\"subsysCode\":\"" + $(e).nextAll("#subsysCode").val() + "\"";
			res += "},";
		});
	}else if(type="sel"){
		var sels = $("#contList tbody").find("[checked='checked']:checkbox");
		if(sels.length < 1) {
			alertMsg.warn("请选择资源！");
			return;
		}
		sels.each(function(i,e){
			res += "{";
			res += "\"privCode\":\"" + $(e).nextAll("#privCode").val() + "\",";
			res += "\"privType\":\"" + $(e).nextAll("#privType").val() + "\",";
			res += "\"subsysCode\":\"" + $(e).nextAll("#subsysCode").val() + "\"";
			res += "},";
		});
	}
	
	res = res.substring(0, res.length-1) + "]";
	var privType = $("#privType1").val();
	var sysName='<sc:fmt value='funcpub' type='crypto'/>';
	var oprID='<sc:fmt value='grantResourceToUserActor' type='crypto'/>';
	var actions='<sc:fmt value='GrantResourceToUser' type='crypto'/>';
	var userId = '${param.userid1}';
	var subsysCode = $("#subsysCode1").val();
	var params = {"userId":userId,"privType":privType,"resources":res,"subsysCode":subsysCode};
	var url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions;
	$.ajax({    
        type:'post',        
        url:url,
        async:false,
        data:params,
        dataType:'XML', 
        success:function(data){   
        	var retMessage = $(data).find('Msg').text();
        	alertMsg.info(retMessage);
        	searchBySel2();
        }
    });   
}

/**
 * 通过JS获取配置信息
 */
function getAllConfigs() {
	var userId = $("#userid1").val();
	var sysName='<sc:fmt value='funcpub' type='crypto'/>';
	var oprID='<sc:fmt value='grantResourceToUserActor' type='crypto'/>';
	var actions='<sc:fmt value='getAllConfigs' type='crypto'/>';
	var url = "/jsonprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions+"&userId="+${param.userid1};
	$.ajax({    
        type:'post',        
        url:url,
        async:false,   
        dataType:'json', 
        success:function(data){   
        	configs1 = data;
        }
    }); 
}


/**
 * 初始化 子系统
 */
function initSubsysList() {
	var html = '';
	for(var i = 0;i < configs1.length;i++) {
		var item = configs1[i];
		html += '<option value="' + item.subsysCode +'"' + (item.subsysCode==defSubsysCode?' selected=\"selected\"':'') + '>'+item.subsysName+'</option>';
	}
	$("#subsysCode1").html(html);
	initPrivTypeSel();
}

/**
 * 初始化权限类型列表
 */
function initPrivTypeSel() {
	var html = '';
	var value = $("#subsysCode1").val();
	for(var i = 0; i < configs1.length; i++) {
		var item = configs1[i];
		if(value==item.subsysCode) {
			var privList = item.privTypeList;
			for(var j = 0; j < privList.length;j++) {
				var priv = privList[j];
				html += '<option value="' + priv.privType + '" '+ (priv.privType==defPrivType?' selected=\"selected\"':'') +'>' + priv.privDesc + '</option>';
			}
		}	
	}
	$("#privType1").html(html);
	changePrivType();
}

/**
 * 判断 选择条件 是否改变
 */
function changePrivType() {
	var newStatus = $("#subsysCode1").val() + "#" + $("#privType1").val();
	if(status!="-1" && status!=newStatus){
		searchBySel2();
	}
	status = newStatus;
}

/**
 * 根据以选择条件查询
 */
function searchBySel2() {
	$("#getUserResource1").click();
}
</script>