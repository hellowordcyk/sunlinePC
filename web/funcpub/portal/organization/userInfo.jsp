<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 修改人员信息
 * description: 
 *     1.   修改人员信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<sc:doPost sysName="funcpub" oprId="funcpub-deptusermanager" action="getUserExtUrl" scope="request"
    var="extUrl_rspPkg" all="true"></sc:doPost>

<form id="updateUserForm" method="post" action="/httpprocesserservlet"
    class="pageForm required-validate" onsubmit="return divSearch(this,'userManagerBox1');">
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
    <input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>" />
    <input type="hidden" name="actions" value="<sc:fmt value='updateUser' type='crypto'/>" />
    <input type="hidden" id="olddeptid" name="olddeptid"value="${jrafrpu.rspPkg.rspRcdDataMaps[0].deptid}" />
    <input type="hidden" id="oldPostcode" name="oldPostcode"value="${jrafrpu.rspPkg.rspRcdDataMaps[0].postcode}" />
    <sc:hidden name="showType" index="1"/>
    <div class="pageContent" >
        <div class="pageFormContent">
            <sc:hidden name="userid" validate="required" index="1" />
            <table class="form-table" cellpadding="0" cellspacing="0" layoutH="60">
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>
                        用户编号
                    </td>
                    <td class="form-value" colspan="3">
                    	<c:choose>
                    		<c:when test="${not empty param.userid }">
	                        	<sc:text name="usercode" validate="required" index="1" readonly="true"  />
	                        </c:when>
	                        <c:otherwise>
	                        	<sc:text name="usercode" validate="required" index="1"  attributesText="maxLength='20'"  />
	                        </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>
                        用户名
                    </td>
                    <td class="form-value" colspan="3">
                        <sc:text name="username" validate="required" index="1" />
                    </td>
                </tr>
                <c:if test="${empty param.userid }">
	                <tr>
						<td class="form-label"><span class="redmust">*</span>登陆密码</td>
						<td class="form-value" colspan="3">
							<input type="password" id="jraf_password" maxLength="32" minLength="6" class="required alphanumeric"/>
							<sc:hidden name="jraf_password" />
						</td>
					</tr>
					<tr>
						<td class="form-label"><span class="redmust">*</span>重复登陆密码</td>
						<td class="form-value" colspan="3">
							<input type="password" id="jraf_password_re" maxLength="32" minLength="6" class="required alphanumeric" equalTo="#jraf_password" />
							<sc:hidden name="jraf_password_re" />
						</td>
					</tr>
				</c:if>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>
                       		所属机构
                    </td>
                    <td class="form-value" colspan="3">
                        <sc:hidden name="deptid" index = "1"/>
                        <sc:hidden name="deptcode" index="1"/>
                        <sc:text name="deptname" validate="required" index="1" readonly="true"/>
                        <a class="btnLook" title="机构信息-单选" width="800" height="450" lookupGroup=""
                           href="/funcpub/public/deptuser/deptLookup_selectone.jsp?lookupid=deptid&lookupcode=deptcode&lookupname=deptname" >
                        </a>
                    </td>
                 </tr>
                 <tr>
                    <td class="form-label">岗位</td>
                    <td class="form-value" colspan="3">
                        <sc:select name="postcode" type="xml" sysName="funcpub" oprID="postActor"
                            actions="queryNoPage" nameField="postCode" valueField="postTitle"
                            includeTitle="false" index="1" nullOption="--请选择--" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label">联系电话</td>
                    <td class="form-value" colspan="3">
                        <sc:text name="phone" index="1" _class="phone"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">电子邮箱</td>
                    <td class="form-value" colspan="3">
                        <sc:text name="email" index="1" _class="email"/>
                    </td>
                </tr>
                <c:if test="${not empty extUrl_rspPkg.rspRcdDataMaps[0].user_ext_url }">
	                <tr>
	                    <td style="pading: 0; height: 5px;" colspan="4">
	                        <div class="divider"></div>
	                    </td>
	                </tr>
	                <tr>
	                	<td id="userExtBox" style="pading: 0; height: 5px;"colspan="4">
	                		
	                	</td>
	                </tr>
                </c:if>
                <tr>
                    <td style="pading: 0; height: 5px;" colspan="4">
                        <div class="divider"></div>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">是否机构管理人员</td>
                    <td colspan="3">
                        <sc:dradio name="manager" type="dict" key="pcmc,boolflag" index="1" default="0"></sc:dradio>
                        <span class="info">管理本级机构</span>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">是否冻结</td>
                    <td>
                        <sc:dradio name="frozen" type="dict" key="pcmc,boolflag" index="1" default="0"></sc:dradio>
                    </td>
                    <td class="form-label">是否禁用</td>
                    <td>
                        <sc:dradio name="disable" type="dict" key="pcmc,boolflag" index="1" default="0"></sc:dradio>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">角色信息</td>
                    <td class="form-value" colspan="3">
                        <c:set var="roleids" value=""/>
                        <c:set var="rolenames" value=""/>
                        <c:forEach var="roleinfo" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1}" varStatus="status">
                            <c:choose>
                                <c:when test="${status.index lt 1}">
                                    <c:set var="roleids" value="${roleinfo.roleid }" />
                                    <c:set var="rolenames" value="${roleinfo.rolename }" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="roleids" value="${roleids },${roleinfo.roleid }" />
                                    <c:set var="rolenames" value="${rolenames },${roleinfo.rolename }" />
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <input type="hidden" name="roleids" value="${roleids }"/>
                        <input type="text" name="rolenames" readonly="true" value="${rolenames }"/>
                        <a class="btnLook" title="选择角色" lookupGroup=""  width="900" height="500"
                           href="/funcpub/portal/role/role_bringback_muitl.jsp?lookupid=roleids&lookupname=rolenames&userid=${jrafrpu.rspPkg.rspRcdDataMaps[0].userid}" >
                        </a>
                    </td>
                </tr>
                <tr>
                    <td style="pading: 0; height: 5px;" colspan="4">
                        <div class="divider"></div>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">
                        <span class="redmust">*</span>
                        菜单类型
                    </td>
                    <td class="form-value" colspan="3">
                       <sc:select name="menutype" type="dict" key="pcmc,menutype" includeTitle="false" index="1"/>
                    </td>
                </tr>
                <c:if test="${rspPkg.rspRcdDataMapsResults2 eq 'true'}">
	                <tr>
	                    <td class="form-label">语言环境</td>
	                    <td class="form-value" colspan="3">
	                    	<sc:select name="i18nCode" type="dict" key="pcmc,i18nCode"
	                            includeTitle="false" index="1"
	                            default="${rspPkg.rspRcdDataMaps[0].i18nCode}" nullOption ="--请选择--"/>
	                    </td>
	                </tr>
                </c:if>
                <tr>
                    <td class="form-label">皮肤选择</td>
                    <td class="form-value">
                        <sc:select name="skinname" type="dict" key="pcmc,skintype"
                            includeTitle="false" index="1" />
                    </td>
                    <td class="form-label">
                        <span class="redmust">*</span>
                        每页显示记录数
                    </td>
                    <td class="form-value">
                        <sc:select name="pagesize" type="dict" key="pcmc,pagesize"
                            validate="required" includeTitle="false" index="1" nullOption="--请选择--" default="10" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <c:choose>
    	<c:when test="${param.showType eq 'box' }">
		    <div class="formBar">
		        <ul>
			         <c:if test="${not empty param.userid }">
			        	<li><button class="savebtn" type="button" onclick="openResetPwdDialog();">重置密码</button></li>
			        </c:if>
		            <li><button class="savebtn" type="button" onclick="submitForm(event);">保存</button></li>
		        </ul>
		    </div>
	    </c:when>
	    <c:otherwise>
		    <div class="formBar">
		        <ul>
		        	<c:if test="${not empty param.userid }">
		        		<li><button class="savebtn" type="button" onclick="openResetPwdDialog();">重置密码</button></li>
		        	</c:if>
		            <li><button class="savebtn" type="button" onclick="submitForm(event)">保存</button></li>
		            <li><button class="close" type="button">取消</button></li>
		        </ul>
		    </div>
	    </c:otherwise>
    </c:choose>
</form>
<script type="text/javascript">
var pageScope = navTab.getCurrentPanel();
var user_ext_url = '${extUrl_rspPkg.rspRcdDataMaps[0].user_ext_url}';
var showType = '${param.showType}';
$(function() {
	if(showType=="dialog") {
		pageScope = $.pdialog.getCurrent();
	}else{
		pageScope = navTab.getCurrentPanel().find("#userManagerBox1");
	}
	if(user_ext_url && user_ext_url.length>0) {
		var userid = $("input[name='userid']",pageScope).val() || "";
		var deptid = $("input[name='deptid']",pageScope).val() || "";
		
		var url = "/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"
				+ "&actions=<sc:fmt value='queryUserExt' type='crypto'/>"
				+ "&forward=<sc:fmt value='${extUrl_rspPkg.rspRcdDataMaps[0].user_ext_url}' type='crypto'/>&userid="+userid+"&deptid="+deptid+"&_st="+(new Date().getTime());
		$("#userExtBox",pageScope).loadUrl(url);
	}
});
function openResetPwdDialog(){
	var userid = $("input[name='userid']",pageScope).val();
	$.pdialog.open("/funcpub/portal/organization/resetPwd.jsp?userid="+userid, "resetPwd", "重置密码", {width:500,height:200});
	/* var deptid = $("input[name='deptid']",pageScope).val();
	var sysName = '<sc:fmt value='funcpub' type='crypto'/>';
	var oprID = '<sc:fmt value='funcpub-deptusermanager' type='crypto'/>';
	var actions = '<sc:fmt value='resetUserPwd' type='crypto'/>';
	var url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions+"&userid="+userid;
	$.ajax({    
        type:'post',        
        url:url,
        async:true,   
        dataType:'XML', 
        success:function(data){   
        	var msg = $(data).find('DataPacket Response Data msg').text();
        	if("success" == msg){
        		alertMsg.correct('密码重置成功');
        	}else{
        		alertMsg.error(msg);
        	}
        }
    }); */
}
function submitForm(event){
	var pagerForm_opcla = $("#updateUserForm",pageScope);
	if (!pagerForm_opcla.valid()) {
		return false;
	}
	var olddeptid = $("#olddeptid",pageScope).val();
	var userid = $("input[name='userid']",pageScope).val();
	var pwd1 = $("#jraf_password",pageScope).val();
    var pwd2 = $("#jraf_password_re",pageScope).val();
    var uName = $("input[name='username']",pageScope).val();
    
    var reg = new RegExp("^[a-zA-Z0-9\u4e00-\u9fa5\w ]+$");
    if(!reg.test(uName)) {
    	alertMsg.warn("用户名只能输入中文，数字、字母、下划线、空格！");
    	return;
    }
    
    <c:if test="${empty param.userid }">
    //对密码进行Js md5加密
    $("input[name='jraf_password']",pageScope).val($.md5(pwd1));
    $("input[name='jraf_password_re']",pageScope).val($.md5(pwd2));
    
    </c:if>
    
	var deptid = $("input[name='deptid']",pageScope).val();
	var skinName=$("select[name='skinname']",pageScope).val();

	var  sysName = '<sc:fmt value='funcpub' type='crypto'/>';
	var    oprID = '<sc:fmt value='funcpub-deptusermanager' type='crypto'/>';
	var  actions = '<sc:fmt value='updateUser' type='crypto'/>';
	var      url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions;
	$.ajax({    
        type:'post',        
        url:url,
        async:true,   
        dataType:'XML', 
        data:$(pagerForm_opcla).serialize(),
        success:function(data){   
        	var msg = $(data).find('DataPacket Response Data msg').text();
        	if("success" == msg){
        		alertMsg.correct('保存成功');
       			var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
       			var oldNode = treeObj.getNodeByParam("id",olddeptid, null);
       			var newNode = treeObj.getNodeByParam("id",deptid, null);
       			treeObj.reAsyncChildNodes(newNode, "refresh");
       			treeObj.reAsyncChildNodes(oldNode, "refresh");
       			if(showType=="dialog") {
       				$.pdialog.closeCurrent();
       			}
       		//保存成功后修改当前用户皮肤
       		//重新设置cookie的值
       			$.cookie('dwz_theme',skinName); 
        	}else{
        		alertMsg.error(msg);
        	}
        }    
    });    
}
</script>