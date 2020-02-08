<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 资源权限管理--已授权用户列表
 * description: 
 *     1. 资源权限管理--已授权用户列表
 * author: 
 * createtime: 
 * logs:
 *     edited by longjian on 20160624 优化布局
 *--%>
 <div class="pageHeader">
    <form id="pagerForm" onsubmit="return dialogSearch(this);" action="/httpprocesserservlet?=&=&=&=" method="post">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
        <input type="hidden" name="oprID" value="<sc:fmt value='privilegeManager' type='crypto'/>" />
        <input type="hidden" name="actions" value="<sc:fmt value='queryAccreditUser' type='crypto'/>" />
        <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/privilege/userAccredit.jsp' />" />
        <input type="hidden" name="pageNum" value="1" /> 
        	
      	<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
	
        <input type="hidden" name="privType" value="<c:out value='${param.privType}'/>" /> 
        <input type="hidden" name="privCode" value="<c:out value='${param.privCode}'/>" /> 
        <input type="hidden" name="subsysCode" value="<c:out value='${param.subsysCode}'/>" />  
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0" >
               <tr>
                    <td class="form-label">权限状态</td>
                    <td class="form-value">
                       <select name="PrviStatus" id="PrviStatus" onchange="changePatype(this)">
                          <option value="1" >未授权</option>
                          <option value="2"selected="selected"   >已授权</option>
                       </select>
                  </td>
                    <td  class="form-label">机构名称</td>
                    <td class="form-value">
                        <sc:hidden  name="deptID" />
                        <sc:text name="orgName" readonly="true"/>
                        <a class="btnLook" title="选择机构"  lookupGroup="" width="900" height="500"
                            href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=deptID&lookupname=orgName"></a>
                     </td>
                   <td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <button  id="selectUserBtn" class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
               </tr>
               <tr>
                   <td  class="form-label">用户名称/用户编码</td>
                    <td class="form-value"><sc:text name="username" style="width:120px"></sc:text></td>
                </tr>
            </table>
        </div>
    </form>
</div>
<div class="pageContent" >
        <table class="table" cellpadding="0" cellspacing="0" >
            <caption style="display:inline-block;width:99.6%;text-align:center;height:30px;line-height:30px;background-color:#e4e7ec;color:#666;border:solid 1px #D0D0D0;white-space:nowrap;">已授权用户列表</caption>
            <thead>
                <tr> 
                   <th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="userCode" /></th>
                   <th align="center">用户编号</th>
                   <th align="center">用户名称</th>
                   <th align="center">用户归属机构</th>
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
                        <tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if>>
                            <td class="checkbox"><input type="checkbox"  name="userCode" value="${user.assigneeCode}"/></td>
                            <td align="center" id="userCode1">${user.assigneeCode}</td>
                            <td align="center" id="userName1">${user.assigneeName}</td>
                            <td align="left" id="deptInfo1">[${user.deptCode}]${user.deptName}</td>
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
<div class="formBar">
    <ul>
        <li><button class="savebtn"  onclick="unaccredit(this)" type="button">取消授权</button></li>
        <li><button class="close" type="button">取消</button></li>
    </ul>
</div>
    
<script>
//权限类型切换 
function changePatype(even){
    var PrviStatus= $("#PrviStatus",$.pdialog.getCurrent()).val();
    var privType= $("[name='privType']",$.pdialog.getCurrent()).val();
    var privCode= $("[name='privCode']",$.pdialog.getCurrent()).val();
    var subsysCode= $("[name='subsysCode']",$.pdialog.getCurrent()).val();
    if(PrviStatus==2){
    	 var  url='/funcpub/privilege/userAccredit.jsp'; 
         url +="?privType="+privType+"&privCode="+privCode+"&subsysCode="+subsysCode;
         $.pdialog.reload(url,null,"unaccredit");
    }else{
    	 var url ='/funcpub/privilege/userUnAccredit.jsp';
         url +="?privType="+privType+"&privCode="+privCode+"&subsysCode="+subsysCode;
         $.pdialog.reload(url,null,"unaccredit");  
    }
}
//取消授权 
function unaccredit(event){
    var privType= $("[name='privType']",$.pdialog.getCurrent()).val();
    var privCode= $("[name='privCode']",$.pdialog.getCurrent()).val();
    var subsysCode= $("[name='subsysCode']",$.pdialog.getCurrent()).val();
    var userCodeArray = $(event).closest("body").find(".pageContent table").find("input[name='userCode']");
    var userCodes = new Array();
    $(userCodeArray).each(function(){
        if(this.checked){
            userCodes.push($(this).val());
        }
    })
    if(userCodes.length<=0){
        alertMsg.info("请选择至少一条记录!");
        return;
    }
    var url = "/xmlprocesserservlet?"
                + "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
                + "&oprID="+'<sc:fmt value='privilegeManager' type='crypto'/>'
                + "&actions="+'<sc:fmt value='cancelAcredit' type='crypto'/>'
                + "&userCodes="+userCodes
                + "&privType="+ privType
                + "&privCode="+privCode
                + "&subsysCode="+subsysCode;
    $.ajax({
        type: "POST",
        url: url,
        dataType : "xml",
        success: function(data){
           var msg = $(data).find("DataPacket Response Data msg").text();
           if(msg=="success"){
              alertMsg.correct("取消权限成功!");
              $("#selectUserBtn",$.pdialog.getCurrent()).trigger("click");
           }else{
              alertMsg.error(msg);
           }
        }
     });       
}
//机构选择控件回显 
function deptTreeCallBack(deptArray,dept){
    $("[name='deptID']",$("body").data("addspecialnessRectify")).val(dept.deptID);
    $("[name='orgName']",$("body").data("addspecialnessRectify")).val(dept.deptName);
}
</script>
