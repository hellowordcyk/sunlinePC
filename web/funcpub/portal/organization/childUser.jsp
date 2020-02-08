<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 机构下人员信息
 * description: 
 *     1.  机构下人员信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<div class="pageHeader">
    <form id="pagerForm" action="/httpprocesserservlet"
        onsubmit="return divSearch(this, 'deptManagerBox3');" method="post">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
        <input type="hidden" name="oprID"
            value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>" />
        <input type="hidden" name="actions" value="<sc:fmt value='getUserByDeptid' type='crypto'/>" />
        <input type="hidden" name="forward"
            value="<sc:fmt type='crypto' value='/funcpub/portal/organization/childUser.jsp' />" />
        <input type="hidden" name="pageNum" value="1" />
        <%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit" />
        <sc:hidden name="deptid" />
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">用户代码/名称</td>
                    <td class="form-value">
                        <sc:text name="looks.usercodeOrName" index="1" />
                    </td>
                    <td class="form-label">机构层级</td>
                    <td class="form-value">
                        <select name="all" class="combox">
                            <c:choose>
                                <c:when test="${param.all eq '0' }">
                                    <option value="1">所有</option>
                                    <option value="0" selected="true">直属</option>
                                </c:when>
                                <c:otherwise>
                                    <option value="1" selected="true">所有</option>
                                    <option value="0">直属</option>
                                </c:otherwise>
                            </c:choose>
                        </select>
                    </td>
                    <td class="form-btn">
                        <ul>
                            <li>
                                <button class="querybtn" id="selectChildUserBtn" jraf_initsubmit
                                    type="submit">查询</button>
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
<div class="pageContent">
    <div class="panelBar">
        <ul class="toolBar">
            <li>
                <a class="add" onclick="showAddUserDialog()">
                    <span>新增</span>
                </a>
            </li>
            <li>
                <a class="edit" onclick="showUpdateUserDialog()">
                    <span>修改</span>
                </a>
            </li>
            <li>
                <a class="delete" onclick="deleteSelectedUser()">
                    <span>删除</span>
                </a>
            </li>
            <li class="line">line</li>
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0">
        <thead>
            <tr>
                <th class="checkbox">
                    <input type="checkbox" class="checkboxCtrl" group="userids" />
                </th>
                <th width="20%">用户编码/名称</th>
                <th>所属机构</th>
                <th width="10%">是否冻结</th>
                <th width="10%">操作</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}">
                    <tr>
                        <td class="empty" colspan="5">查询无数据。</td>
                    </tr>
                </c:when>
                <c:otherwise>
                    <c:forEach var="user" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="index">
                        <tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if>>
                            <td class="checkbox">
                                <input type="checkbox" name="userids" value="${user.userid}" />
                            </td>
                            <td>[${user.usercode}]&nbsp;${user.username}</td>
                            <td>${user.deptname}</td>
                            <td>
                            	<sc:optd name="frozen" value="${user.frozen}" type="dict" key="pcmc,boolflag"/>
                        	</td>
                            <td>
                                <a class="btnRun"
                                    onclick="toViewInTree('${user.userid}','${user.orgseq }','${user.usercode }','user');"
                                    href="#;return false;">
                                    <span>详情</span>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
    <div class="panelBar">
        <div rel="deptManagerBox3" class="pagination" targetType="navTab"
            totalCount="${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}"
            numPerPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
            currentPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}"></div>
    </div>
</div>
<script type="text/javascript">
function deleteSelectedUser(){
	var userids = new Array();
	var boxArr=document.getElementsByName("userids");
	for(var i=0;i<boxArr.length;i++){
		if(boxArr[i].checked){
			userids.push(boxArr[i].value);
		}
	}
	if(userids.length <= 0){
		alertMsg.error('请选择信息!');
	}else{
		var msg= "确定要删除所选记录吗?";
		alertMsg.confirm(msg, {
			okCall: function(){
				var btn = $("#selectChildUserBtn",navTab.getCurrentPanel());
				deleteUser(userids,"current",btn);
			}
		});
	}
}
function showUpdateUserDialog(){
	var userids = new Array();
	var boxArr=document.getElementsByName("userids");
	for(var i=0;i<boxArr.length;i++){
		if(boxArr[i].checked){
			userids.push(boxArr[i].value);
		}
	}
	
	if(userids.length < 1){
		alertMsg.error('请选择信息!');
	}else if(userids.length > 1){
		alertMsg.error('请选择一条信息!');
	}else{
		var url= "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>" 
		        + "&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"
		        + "&actions=<sc:fmt value='getUserById' type='crypto'/>"
		        + "&forward=<sc:fmt type='crypto' value='/funcpub/portal/organization/userInfo.jsp' />"
		        + "&userid="+userids[0]
		        + "&showType=dialog";
		$.pdialog.open(url,"updateUser","修改用户信息", {width:800,height:500,minable:false,maxable:false,mask:true});
	}
}
</script>