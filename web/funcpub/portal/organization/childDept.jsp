<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 机构详细信息
 * description: 
 *     1. 机构详细信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<div class="pageHeader">
    <form id="pagerForm" action="/httpprocesserservlet"
        onsubmit="return divSearch(this, 'deptManagerBox2');" method="post">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
        <input type="hidden" name="oprID"
            value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>" />
        <input type="hidden" name="actions" value="<sc:fmt value='getChildDept' type='crypto'/>" />
        <input type="hidden" name="forward"
            value="<sc:fmt value='/funcpub/portal/organization/childDept.jsp' type='crypto'/>" />
        <input type="hidden" name="pageNum" value="1" />

        <%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit" />

        <input type="hidden" name="pdeptid" value="${param.pdeptid }" />
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">机构编码/名称</td>
                    <td class="form-value">
                        <sc:text name="looks.deptcodeOrName" index="1" />
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
                    <td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <button class="querybtn" id="selectChildDeptBtn" jraf_initsubmit
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
                <a class="add" onclick="showAddDeptDialog()">
                    <span>新增</span>
                </a>
            </li>
            <li>
                <a class="edit" onclick="showUpdateDeptDialog()">
                    <span>修改</span>
                </a>
            </li>
            <li>
                <a class="delete" onclick="deleteSelectedDept(event)">
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
                    <input type="checkbox" class="checkboxCtrl" group="deptcodes" />
                </th>
                <th width="20%">机构编码</th>
                <th>机构名称</th>
                <th width="10%">操作</th>
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
                    <c:forEach var="dept" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="index">
                        <tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if>>
                            <td class="checkbox">
                                <input type="checkbox" name="deptcodes" value="${dept.deptcode}" />
                            </td>
                            <td>${dept.deptcode}</td>
                            <td>${dept.deptname}</td>
                            <td>
                                <a class="btnRun"
                                    onclick="toViewInTree('${dept.deptid}','${dept.orgseq}', '${dept.deptcode }', 'dept');"
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
        <div rel="deptManagerBox2" class="pagination" targetType="navTab"
            totalCount="${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}"
            numPerPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
            currentPage="${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}"></div>
    </div>
</div>
<script type="text/javascript">
function deleteSelectedDept(e){
	var deptcodes = new Array();
	var $btn = $(e.target).closest(".pageContent").siblings(".pageHeader").find("#selectChildDeptBtn");
	var boxArr=document.getElementsByName("deptcodes");
	for(var i=0;i<boxArr.length;i++){
		if(boxArr[i].checked){
			deptcodes.push(boxArr[i].value);
		}
	}
	if(deptcodes.length <= 0){
		alertMsg.error('请选择信息!');
	}else{
		var msg= "确定要删除所选机构及其一下机构吗?";
		alertMsg.confirm(msg, {
			okCall: function(){
				//var btn = $("#selectChildDeptBtn",navTab.getCurrentPanel());
				deleteDept(deptcodes.join(","),"current");
				$btn.trigger("click");
			}
		});
	}
}

function showUpdateDeptDialog(){
	var deptcodes = new Array();
	var boxArr=document.getElementsByName("deptcodes");
	for(var i=0;i<boxArr.length;i++){
		if(boxArr[i].checked){
			deptcodes.push(boxArr[i].value);
		}
	}
	if(deptcodes.length < 1){
		alertMsg.error('请选择信息!');
	}else if(deptcodes.length > 1){
		alertMsg.error('请选择一条信息!');
	}else{
		//var url = "/funcpub/portal/organization/updateDept.jsp?deptcode="+deptcodes[0];
		var url = '/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>&actions=<sc:fmt value='getDeptByCode' type='crypto'/>&forward=<sc:fmt type='crypto' value='/funcpub/portal/organization/updateDept.jsp' />&deptcode='+deptcodes[0];
		$.pdialog.open(url,"child_updateDept33","修改机构信息", {width:800,height:500,minable:false,maxable:false,mask:true});
	}
}
</script>