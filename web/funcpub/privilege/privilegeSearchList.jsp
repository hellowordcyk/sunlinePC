<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 资源权限管理--资源列表
 * description: 
 *     1. 资源权限管理--资源列表
 * author: 
 * createtime: 
 * logs:
 *     edited by longjian on 20160624 优化布局
 *--%>
<sc:doPost sysName="funcpub" oprId="privilegeManager" action="queryPrivGrant" params='&privType=${param.privType}&subsysCode=${param.subsysCode}' var="privGrant"/>
<table class="table" width="100%" layoutH="200" >
    <thead>
        <th style="width: 15%">资源编码</th>
        <th style="width: 70%;">资源名称</th>
        <th style="width: 15%">操作</th>
    </thead>
    <tbody>
    <c:choose>
        <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
            <tr>
                <td class="empty" colspan="3">查询无数据。</td>
            </tr>
        </c:when>
        <c:otherwise>
            <c:forEach var="privmsg" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                <tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if> >
                  <td>${privmsg.privCode}</td>
                  <td>${privmsg.privName}</td>
                  <td>
                     <c:if test="${privGrant.rspDataMap.privGrant eq 'role'}">
                        <a class="btnKey" rel="menugrant" href="#"  onclick='javascript:toAccreditforRole("${privmsg.privType}","${privmsg.subsysCode}","${privmsg.privCode}")'  >授权角色</a>
                     </c:if>
                     <c:if test="${privGrant.rspDataMap.privGrant eq 'user'}">
                        <a class="btnKey" rel="menugrant" href="#"  onclick='javascript:toAccreditforUser("${privmsg.privType}","${privmsg.subsysCode}","${privmsg.privCode}")'  >授权用户</a>
                     </c:if>
                  </td>
                </tr>
             </c:forEach>
          </c:otherwise>
    </c:choose>
    </tbody>
</table>
<div class="panelBar">
   <div class="pagination" totalCount="${jrafrpu.rspPkg.rspRecordCount}" rel="privDiv${param.subsysCode }"
   numPerPage="${jrafrpu.rspPkg.rspPageSize}" currentPage="${jrafrpu.rspPkg.rspPageNo}"></div>
</div>
<script type="text/javascript">
$(function () {
	//初始化分页控件等
    //initUI(navTab.getCurrentPanel());
});
//用户授权
function toAccreditforUser(privType,subsysCode,privCode){
    var url='/funcpub/privilege/userUnAccredit.jsp?';  
    url += "&privType=" + privType + "&privCode=" +privCode+"&subsysCode=${param.subsysCode}";
    $.pdialog.open(url, "unaccredit", "用户授权明细", {width : 830,height: 600,minable:false,maxable:false,mask:true});
}
//角色授权
function toAccreditforRole(privType,subsysCode,privCode){
    var url='/funcpub/privilege/roleUnAccredit.jsp?';  
    url += "&privType=" + privType + "&privCode=" +privCode+"&subsysCode=${param.subsysCode}";
    $.pdialog.open(url, "unaccredit", "授权角色明细", {width : 830,height: 600,minable:false,maxable:false,mask:true});
}

</script>