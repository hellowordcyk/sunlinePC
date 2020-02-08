<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 修改当前登录人信息
 * description: 
 *     1. 修改当前登录人信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<sc:doPost sysName="funcpub" oprId="funcpub-deptusermanager-public" action="getPersonById" scope="request"
    var="rspPkg" all="true"></sc:doPost>
    
<form id="updateUserForm" method="post" action="/httpprocesserservlet"
    class="pageForm required-validate" onsubmit="return divSearch(this,'userManagerBox1');">
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" /> <input
        type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>" />
    <input type="hidden" name="actions" value="<sc:fmt value='updatePersonInfo' type='crypto'/>" />
    <input type="hidden" id="olddeptid" name="olddeptid" value="${ rspPkg.rspRcdDataMaps[0].deptid}" />
    
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">用户编码</td>
                    <td class="form-value">${ rspPkg.rspRcdDataMaps[0].usercode}
                    </td>
                </tr>
                <tr>
                    <td class="form-label">用户名</td>
                    <td class="form-value">${ rspPkg.rspRcdDataMaps[0].username}
                    </td>
                </tr>
                <tr>
                    <td class="form-label">所属机构</td>
                    <td class="form-value">${ rspPkg.rspRcdDataMaps[0].deptname}
                    </td>
                </tr>
                <tr>
                    <td class="form-label">岗位</td>
                    <td class="form-value">
                    	<c:if test="${not empty  rspPkg.rspRcdDataMaps[0].postcode}">
                    		<sc:optd name="postCode" type="xml" sysName="funcpub" oprID="postActor" actions="queryNoPage" nameField="postTitle"  value="${rspPkg.rspRcdDataMaps[0].postcode}"/>
                    	</c:if>
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>每页显示记录数</td>
                    <td class="form-value">
                        <sc:select name="pagesize" type="dict" key="pcmc,pagesize"
                            validate="required" includeTitle="false" index="1"
                            default="${ rspPkg.rspRcdDataMaps[0].pagesize}" nullOption ="--请选择--"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">联系电话</td>
                    <td class="form-value">
                        <sc:text name="phone" index="1" value="${ rspPkg.rspRcdDataMaps[0].phone}" _class="phone"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">电子邮箱</td>
                    <td class="form-value">
                        <sc:text name="email" index="1" value="${ rspPkg.rspRcdDataMaps[0].email}" _class="email"/>
                    </td>
                </tr>
                <c:if test="${rspPkg.rspRcdDataMapsResults1 eq 'true'}">
	                <tr>
	                    <td class="form-label">语言环境</td>
	                    <td class="form-value">
	                    	<sc:select name="i18nCode" type="dict" key="pcmc,i18nCode"
	                            includeTitle="false" index="1"
	                            default="${rspPkg.rspRcdDataMaps[0].i18nCode}" nullOption ="--请选择--"/>
	                    </td>
	                </tr>
                </c:if>
            </table>
        </div>
    </div>
    <div class="formBar">
        <ul>
            <li>
                <button class="savebtn" type="button" onclick="submitForm();">保存</button>
            </li>
            <li>
                <button class="close" type="button" onclick="closeCurrentTabDialog()">取消</button>
            </li>
        </ul>
    </div>
</form>
<script type="text/javascript">
function closeCurrentTabDialog(){
	$.pdialog.closeCurrent();
}
function submitForm(){
	var pagerForm_opcla = $("#updateUserForm");
	if (!pagerForm_opcla.valid()) {
		return false;
	}
	var olddeptid = $("#olddeptid",navTab.getCurrentPanel()).val();
	var deptid = $("#deptidForUpdateUser",navTab.getCurrentPanel()).val();
	
	var  sysName = '<sc:fmt value='funcpub' type='crypto'/>';
	var    oprID = '<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>';
	var  actions = '<sc:fmt value='updatePersonInfo' type='crypto'/>';
	var      url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions;
	$.ajax({    
        type:'post',        
        url:url,
        async:false,   
        dataType:'XML', 
        data:$(pagerForm_opcla).serialize(),
        success:function(data){   
        	var msg = $(data).find('DataPacket Response Data msg').text();
        	if("success" == msg){
        		alertMsg.correct('保存成功');
        	}else{
        		alertMsg.error(msg);
        	}
        }    
    });    
}
function deptTreeCallBack(deptArray,dept){
	$("[name='deptid']",navTab.getCurrentPanel()).val(dept.deptID);
	$("[name='deptname']",navTab.getCurrentPanel()).val(dept.deptName);
}
</script>