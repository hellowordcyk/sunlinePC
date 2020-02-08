<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.net.URLEncoder"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<style type="text/css">
	#selectedManagerTree li span.button.switch.level0 {visibility:hidden; width:1px;}
	#selectedManagerTree li ul.level0 {padding:0; background:none;}
</style>
<%
    String filter = request.getParameter("filter");
%>
<div class="pageHeader">
	<form id="pagerForm" action="/httpprocesserservlet?<%=filter %>" method="post" onsubmit="return dialogSearch(this);">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='publicOptionControls' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='getUserTableOptionData' type='crypto'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/public/publicOptionControls/userTableOptionDialog.jsp' />"/>
		<input type="hidden" name="pageNum" value="1" />
		<input type="hidden" name="filter" value="<c:out value='${param.filter }' escapeXml='false'/>" />	
		<input type="hidden" name="multi" value="<c:out value='${param.multi }' />"/>	
		<input type="hidden" name="callback" value="<c:out value='${param.callback }' />"/>	
		<input type="hidden" name="selectedColumn" value="<c:out value='${param.selectedColumn }' />"/>
		<input type="hidden" name="selected" value="<c:out value='${param.selected }' />"/>	
        <%-- 规范： 初始化查询必加隐藏表单 --%>
           <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
			    	<td class="form-label">人员编号</td>
			    	<td class="form-value"><sc:text name="userCode"/></td>
			    	<td class="form-label">人员名称</td>
				    <td class="form-value"><sc:text name="userName"/></td>
			        <td class="form-btn">
                        <ul>
                            <li>
                                <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                                <button id="selectUserBtn" class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div class="pageContent" style="padding-bottom:0px;">
	<div id="userTable" style="width:500px;float:left;margin-top:5px;margin-left:5px; height:340px;">
		<table class="list options" width="100%">
			<thead>
				<tr>				
					<th align="center">人员编号</th>
					<th align="center">人员名称</th>
					<th align="center">机构名称</th>
				</tr>
			</thead>
			<tbody>
			    <c:choose>
				    <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
				        <tr>
				            <td class="empty" colspan="4">查询无数据。</td>
				        </tr>
				    </c:when>
				    <c:otherwise>
						<c:forEach var="user" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
							<tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if> >
								<sc:hidden name="userID" value="${user.userID}" />
								<sc:hidden name="userCode" value="${user.userCode}" />
								<sc:hidden name="userName" value="${user.userName}" />
							    <td>${user.userCode}</td>
							    <td>${user.userName}</td>
							    <td>[${user.deptCode}]${user.deptName}</td>
							</tr>
						</c:forEach>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		<div class="panelBar" >
			<div rel="" class="pagination" targetType="dialog" 
				totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
				numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
				currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
			</div>
		</div>
	</div>
	
	<div class="window-center-button">
		<button class="add" onclick="choseSelected();" type="button">选择--></button><br><br>
		<c:if test="${param.multi == 'true' }">
			<button class="add" onclick="choseAll();" type="button">选择本页</button><br><br>
		</c:if>
		
		<button class="delete" onclick="deleteSelected()" type="button"><--删除</button><br><br>
		<button class="delete" onclick="deleteAll()" type="button"><--全删</button><br><br>
		<button class="close" onclick="submit()" type="button">确定</button>
	</div>
	
	<div class="window-right-box" style="width:280px;">
		<ul id="selectedUserTree" class="ztree"></ul>
	</div>
	
</div>
<script>
var multi = "<c:out value='${param.multi}' />";
if("true" == multi){
	multi = true;
}else{
	multi = false;
}
var userSelectedSetting = {
	view:{
		dblClickExpand:function(treeId,treeNode){return treeNode.level > 0;},
		showLine:false,// 是否显示连接线
		selectedMulti:multi,// 是否多选
		showIcon:true// 是否显示图标
	},
	data:{simpleData: {enable:true}},
	callback:{
		onDblClick:function(){
			deleteSelected();
		}
	}
};
$(function(){
	//edit by longjian 20160615 去掉了 isforward 参数， 暂时设置为false。不然一直加载
	/*
	var isforward = "false";
	if(isforward != "false"){
		$("#selectUserBtn",$.pdialog.getCurrent()).trigger("click");
	}
	*/
	$.fn.zTree.init($("#selectedUserTree",$.pdialog.getCurrent()),userSelectedSetting,null);//id 对象 数据
	initselectedUserTree();
});
function initselectedUserTree(){
	var selected = "<c:out value='${param.selected}'/>";
	var selectedColumn = "<c:out value='${param.selectedColumn}' />";
	var sysName = '<sc:fmt value='funcpub' type='crypto'/>';
	var oprID = '<sc:fmt value='publicOptionControls' type='crypto'/>';
	var actions = '<sc:fmt value='getSelectedUserForUserTableOption' type='crypto'/>';
	var url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions+"&selected="+selected+"&selectedColumn="+selectedColumn;
	$.ajax({    
        type:'post',        
        url:url,
        async:false,   
        dataType:'XML', 
        success:function(data){   
        	var selectedUser = $(data).find('DataPacket Response Data selectedUser').text();
        	selectedUser = $.parseJSON(selectedUser);
        	if( null != selectedUser && selectedUser.length>0){
        		var treeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
        		if(multi){//多选
            		$(selectedUser).each(function(){
            			var user = $.parseJSON(this.info);
            			addSelectedNode(user.userID,user.userCode,user.userName);
                	});
        		}else{//单选
        			var user = $.parseJSON(selectedUser[0].info);
        			addSelectedNode(user.userID,user.userCode,user.userName);
        		}
        		
        	}
        }
    });    
}
function choseAll(){
	var treeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
	var tr = $("#userTable",$.pdialog.getCurrent()).find("tbody tr");
	treeObj.cancelSelectedNode();
	$(tr).each(function(){
		var userID = $(this).find("[name='userID']").val();
		var userCode = $(this).find("[name='userCode']").val();
		var userName = $(this).find("[name='userName']").val();
		addSelectedNode(userID,userCode,userName);
	});
	setForward();
}
function choseSelected(){
	var treeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
	var tr = $("#userTable",$.pdialog.getCurrent()).find("tbody tr.selected");
	if(null != tr && tr.length>0){
		treeObj.cancelSelectedNode();
		$(tr).each(function(){
			var userID = $(this).find("[name='userID']").val();
			var userCode = $(this).find("[name='userCode']").val();
			var userName = $(this).find("[name='userName']").val();
			if(multi){
				addSelectedNode(userID,userCode,userName);
			}else{
				deleteAll();
				addSelectedNode(userID,userCode,userName);
			}
		});
		setForward();
	}
}
function addSelectedNode(userID,userCode,userName){
	var treeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
	var node = treeObj.getNodeByParam("id",userID,null);
	if(node == null){
		treeObj.addNodes(null,{id:userID,name:"["+userCode+"]"+userName,isParent:false,info:{userID:userID,userCode:userCode,userName:userName}});
		node = treeObj.getNodeByParam("id",userID,null);
	}
	treeObj.selectNode(node,true);
}
function deleteSelected(){
	var treeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
	var nodes = treeObj.getSelectedNodes();
	$(nodes).each(function(){
		treeObj.removeNode(this);
	});
	setForward();
}
function deleteAll(){
	var treeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
	var nodes = treeObj.transformToArray(treeObj.getNodes());
	$(nodes).each(function(){
		treeObj.removeNode(this);
	});
	setForward();
}
function setForward(){
	var selected = new Array();
	var selectedColumn = "<c:out value='${param.selectedColumn}' />";
	var treeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
	var nodes = treeObj.transformToArray(treeObj.getNodes());
	$(nodes).each(function(){
		var user = this.info;
		if(selectedColumn.toLowerCase() == "userid"){
			selected.push(user.userID);
		}else{
			selected.push(user.userCode);
		}
	});
	/*
	var forward = "/funcpub/public/publicOptionControls/userTableOptionDialog.jsp"
				+ ""
				+ "&filter=<%=URLEncoder.encode(filter)%>"
				+ "&multi=<c:out value='${param.multi}' />"
				+ "&callback=<c:out value='${param.callback}' />"
				+ "&selectedColumn=<c:out value='${param.selectedColumn}' />"
				+ "&selected="+selected;
				*/
	$("[name='selected']",$.pdialog.getCurrent()).val(selected);
	//$("[name='forward']",$.pdialog.getCurrent()).val(forward);
}
function submit(){
	var callback="<c:out value='${param.callback}' />";
	var userID = "";
	var userCode = "";
	var userName = "";
	var resultArray = new Array();
	var selectedTreeObj = $.fn.zTree.getZTreeObj("selectedUserTree");
	var nodes = selectedTreeObj.transformToArray(selectedTreeObj.getNodes());
	$(nodes).each(function(){
		var user = this.info;
		userID += user.userID+",";
		userCode += user.userCode+",";
		userName += user.userName+",";
		resultArray.push(user);
	});
	userID = userID.substring(0,userID.length-1);
	userCode = userCode.substring(0,userCode.length-1);
	userName = userName.substring(0,userName.length-1);
	var resultObj = {userID:userID,userCode:userCode,userName:userName};
	eval(callback+"(resultArray,resultObj)");
}
</script>
