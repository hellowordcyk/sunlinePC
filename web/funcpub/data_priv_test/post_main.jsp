<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 岗位管理
 * description: 
 *     1.维护（新增、修改、删除）岗位信息；
 * author:
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return navTabSearch(this)" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='postActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='query' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/post/post_main.jsp' />" />
			<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
				    <td class="form-label">岗位名称</td>
				    <td class="form-value"><sc:text name="qName" index="1"/></td>
                    <td align="right">
	                    <button class="querybtn" jraf_initsubmit type="submit">查询</button>                           
	                    <button class="resetbtn" type="reset">清空</button>                        
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
                <a class="add" href="/funcpub/portal/post/post_add.jsp" height="300" width="500"
                    target="dialog" rel="post_add">
                    <span>新增</span>
                </a>
                <!-- <a class="add" href="/funcpub/portal/post/post_add.jsp" height="300" width="500"
                    target="dialog" rel="post_add">
                    <span>新增</span>
                </a> -->
            </li>
            <li>
                <a class="delete" group="postId" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='postActor' type='crypto'/>&actions=<sc:fmt value='delete' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li>
                <a class="run" rel="to_share" target="dialog" group="postId" width="800" height="550"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='privShareActor' type='crypto'/>&actions=<sc:fmt value='toShare' type='crypto'/>&forward=<sc:fmt value='/funcpub/privilege/sysprivdata/priv_share.jsp' type='crypto'/>&entity=sys_pub_post1">
                    <span>分享</span>
                </a>
            </li>
            <li>
                <a class="btnNormal" rel="to_share" target="navTab" title="分享管理"
                    href="/funcpub/privilege/sysprivdata/priv_share_main.jsp?entity=sys_pub_post1">
                    <span>取消分享</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
				<th class="checkbox">
					<input type="checkbox" class="checkboxCtrl" group="postId" />
				</th>
				<th width="20%">岗位编码</th>
				<th width="30%">岗位名称</th>
				<th >岗位描述</th>
				<th width="10%">排序</th>
				<th width="10%">操作</th>
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
                <c:forEach var="post" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                    <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                        <td class="checkbox">
                        	<!-- 通过权限控制，不显示复选框，禁止删除 -->
	                        <%-- <sc:datapriv entity="sys_pub_post1" acttype="delete" pkval="${post.postId }" pkvala="${post.postTitle }"> --%>
	                            <input type="checkbox" name="postId" pkval="${post.postId }" pkvala="${post.postTitle }" pkvalb="${post.postCode }" 
	                                value="${post.postId}" />
	                        <%-- </sc:datapriv> --%>
                        </td>
                        <td>${post.postCode }</td>
                        <td>${post.postTitle}</td>
                        <td>${post.postDescription}</td>
                        <td>${post.sortNo}</td>
                        <td>
                        	<!-- 通过权限控制，是否显示 修改按钮 -->
                        	<sc:datapriv entity="sys_pub_post1" acttype="update" pkval="${post.postId }" pkvala="${post.postTitle }" pkvalb="${post.postCode }">
	                            <a class="btnEdit" rel="post_update" target="dialog"
	                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='postActor' type='crypto'/>&actions=<sc:fmt value='query' type='crypto'/>&postId=${post.postId}&forward=<sc:fmt value='/funcpub/portal/post/post_update.jsp' type='crypto'/>"
	                                height="300" width="500">修改 </a>
	                        </sc:datapriv>
                           <%--  <a class="btnEdit" rel="post_update" target="dialog"
                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='postActor' type='crypto'/>&actions=<sc:fmt value='query' type='crypto'/>&postId=${post.postId}&forward=<sc:fmt value='/funcpub/portal/post/post_update.jsp' type='crypto'/>"
                                height="300" width="500">修改 </a> --%>
	                        <%-- <sc:datapriv entity="sys_pub_post1" acttype="share" pkval="${post.postId }" pkvala="${post.postTitle }">
	                            <a class="btnEdit" rel="post_update" target="dialog"
	                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='postActor' type='crypto'/>&actions=<sc:fmt value='query' type='crypto'/>&postId=${post.postId}&forward=<sc:fmt value='/funcpub/portal/post/post_update.jsp' type='crypto'/>"
	                                height="300" width="500">分享 </a>
	                        </sc:datapriv> --%>
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
