<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 数据分享管理
 * description: 
 *     1.维护（新增、修改、删除）岗位信息；
 * author:
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<sc:doPost sysName="funcpub" oprId="privShareActor" action="queryCurrentInfo" scope="request"
    var="rspPkg_current" all="true" ></sc:doPost>
<div class="pageHeader">
	<form id="priv_share_main_list_pagerForm" onsubmit="return divSearch(this,'priv_share_main_list')" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='privShareActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='query' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/privilege/sysprivdata/priv_share_main_list.jsp' />" />
			<%-- 规范： 初始化查询必加隐藏表单 --%>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
			    	<td class="form-label"><span class="redmust">*</span>
			    		数据实体
			    	</td>
				     <td class="form-value">
				     	<c:choose>
				     		<c:when test="${not empty rspPkg_current.rspRcdDataMaps[0].entityCode  }">
				     			<sc:hidden id="entityCode" name="entityCode"  value="${rspPkg_current.rspRcdDataMaps[0].entityCode }"/>
		                    	<sc:text name="entityName" readonly="true" value="${rspPkg_current.rspRcdDataMaps[0].entityName }" />
				     		</c:when>
				     		<c:otherwise>
				     			<sc:hidden name="entityCode" id="entityCode" />
		                    	<input 
		                    	name="entityName" type="text" 
		                    	postfield="entityName" suggestFields="entityCode,entityName" 
		                    	validate="alphanumeric required" 
		                    	suggestUrl="/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='privEntityActor' type='crypto'/>&actions=<sc:fmt value='querySysPrivEntityJson' type='crypto'/>" 
		                    	lookupgroup="" 
		                    	autocomplete="on"/>
				     		</c:otherwise>
				     	</c:choose>
                    	
                    </td> 
                    <td class="form-label">标题</td>
				    <td class="form-value">
	                    <sc:text name="qName"  index="1"/>
				    </td>
                    <td class="form-label">分享人</td>
				    <td class="form-value">
				    	<sc:hidden name="sharerCode" value="${rspPkg_current.rspRcdDataMaps[0].currentUserCode }"/>
	                    <sc:text name="sharerName" readonly="true" value="${rspPkg_current.rspRcdDataMaps[0].currentUserName }"/>
	                    <c:if test="${empty rspPkg_current.rspRcdDataMaps[0].entityCode}">
		                    <a class="btnLook" title="选择分享人" lookupGroup=""  width="900" height="500"
		                      href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupcode=sharerCode&lookupname=sharerName"></a>
						</c:if>
				    </td>
				    <td class="form-label">拥有人</td>
				    <td class="form-value">
				    	<sc:hidden name="ownerCode" />
	                    <sc:text name="ownerName" readonly="true"/>
	                    <a class="btnLook" title="选择拥有人" lookupGroup=""  width="900" height="500"
	                      href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupcode=ownerCode&lookupname=ownerName"></a>
				    </td>
                </tr>
                <tr>
				    <td></td>
				    <td class="form-btn" >
                        <ul>
                            <li>
                                <button class="querybtn" type="submit">查询</button>
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
<div class="pageContent" >
    <div class="panelBar">
        <ul class="toolBar">
            <li>
                <a class="delete" group="shareId" target="selectedTodo" title="确定要取消分享所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='privShareActor' type='crypto'/>&actions=<sc:fmt value='deleteShare' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>&entity={entityCode}">
                    <span>取消分享</span>
                </a>
            </li>
        </ul>
    </div>
   <div id="priv_share_main_list">
    	<table class="table" cellpadding="0" cellspacing="0" >
			<thead>
				<tr>
					<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="shareId" /></th>
					<th>标题</th>
					<th width="15%">所属子系统</th>
					<th width="30%">实体名称</th>
					<th width="12%">分享人</th>
					<th width="12%">拥有者</th>
				</tr>
			</thead>
			<tbody>
	            <tr>
	                <td class="empty" colspan="6">查询无数据。</td>
	            </tr>
	        </tbody>
        </table>
    </div>
</div>   
<script type="text/javascript">
	$(function() {
		if($("input[name='entityCode']",navTab.getCurrentPanel()).val()) {
			$("#priv_share_main_list_pagerForm",navTab.getCurrentPanel()).find("button.querybtn").click();
		}
	});
</script>
