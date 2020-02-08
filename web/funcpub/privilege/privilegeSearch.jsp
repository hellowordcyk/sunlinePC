<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 资源权限管理模块
 * description: 
 *     1.资源权限管理模块
 * author: 
 * createtime: 
 * logs:
 *     edited by longjian on 20160624 优化布局
 *--%>
 <div class="pageHeader">
    <form name="privilegeSearchForm"  onsubmit="return divSearch(this,'privilegeDataList_${param.subsysCode }');" id="privilegeDataList_${param.subsysCode }_pagerForm"
        action="/httpprocesserservlet" method="post" rel="pagerForm">
        <input type="hidden" name="sysName" value='<sc:fmt type="crypto" value="funcpub"/>' />
        <input type="hidden" name="oprID" value='<sc:fmt type="crypto" value="privilegeManager"/>' />
        <input type="hidden" name="actions" value='<sc:fmt type="crypto" value="queryPrivilegeDataList"/>' />
        <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/privilege/privilegeSearchList.jsp' />" />
        <input type="hidden" name="subsysCode" value="${param.subsysCode }" />
        <input type="hidden" name="pageNum" value="1" /> 
        <div class="searchBar">
        <table class="searchContent"  cellpadding="0" cellspacing="0">
            <tr>
                <td class="form-label">资源权限类型</td>
                <td class="form-value">
                    <select name="privType" onchange="changetype(this)"  id="privType_${param.subsysCode }"></select>
                </td>
                <td class="form-label">资源权限编码/名称</td>    
                <td class="form-value">
                  <input type="text" name="privCode" id="privCode_${param.subsysCode }" />
                </td>    
                <td class="form-btn">
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
<div class="pageContent" id="privilegeDataList_${param.subsysCode }">
    <%-- 进入页面调用jQuery初始化程序报错问题（找不到pageForm） --%>
    <table class="table" width="100%">
        <thead>
        <th style="width: 15%;">资源编码</th>
        <th style="width: 70%;">资源名称</th>
        <th style="width: 15%;">操作</th>
        </thead>
        <tbody>
         <tr>
           <td colspan="3">选择条件查询。</td>
         </tr>
        </tbody>
    </table>
</div>
<script type="text/javascript">
$(function(){
    initPrivType();
});
function initPrivType(){
    var url = '/jsonprocesserservlet?sysName=<sc:fmt type="crypto" value="funcpub"/>'
            + '&oprID=<sc:fmt type="crypto" value="privilegeManager"/>'
            + '&actions=<sc:fmt type="crypto" value="getPrivTypeList"/>';
    $.ajax({
        type: "POST",
        url: url,
        dataType: "json",
        data : "subsysCode=${param.subsysCode}",
        success: function(data){
            var option = '';
            $(data).each(function(i,o){
                option = option + "<option value='"+o.privType+"'>"+o.privDesc+"</option>";
            });
            $("#privType_${param.subsysCode }",navTab.getCurrentPanel()).html(option);
            $("#privilegeDataList_${param.subsysCode }_pagerForm",navTab.getCurrentPanel()).submit();
       }, error:function(){
           alertMsg.error("获取资源权限列表错误！");
       }
    });
}
function changetype(even){
	$("#privilegeDataList_${param.subsysCode }_pagerForm",navTab.getCurrentPanel()).submit();
}
</script>
