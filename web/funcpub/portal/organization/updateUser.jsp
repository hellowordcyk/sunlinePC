<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 新增用户
 * description: 
 *     1.新增用户
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<form id="updateUserDialogForm" method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='updateUserByDialog' type='crypto'/>"/>
	<input type="hidden" id="olddeptid" name="olddeptid" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].deptid}"/>
	<sc:hidden name="userid" validate="required" index="1"/>
    <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
    
    <div class="pageContent">
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label"><span class="redmust">*</span>用户编号</td>
					<td class="form-value" colspan="3"><sc:text name="usercode" validate="required" index="1" readonly="true"/></td>
				</tr>
				<tr>	
					<td class="form-label"><span class="redmust">*</span>用户名</td>
					<td class="form-value"><sc:text  name="username" validate="required" index="1"/></td>
				    <td class="form-label">岗位</td>
                    <td class="form-value">
                    <sc:select name="postcode" type="xml" sysName="funcpub" oprID="postActor" actions="queryNoPage" nameField="postTitle" valueField="postCode" includeTitle="false" nullOption="--请选择--"/>
                    </td>
				</tr>
				<tr>
					<td class="form-label"><span class="redmust">*</span>所属机构</td>
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
					<td class="form-label">皮肤选择</td>
					<td class="form-value"><sc:select name="skinname" type="dict" key="pcmc,skintype" includeTitle="false" index="1"/></td>
					<td class="form-label"><span class="redmust">*</span>每页显示记录数</td>
					<td class="form-value">
					   <sc:select name="pagesize" type="dict" key="pcmc,pagesize"
                            validate="required" includeTitle="false" index="1" nullOption ="--请选择--"
                            />
					</td>
				</tr>
				<tr>
					<td class="form-label">是否机构管理人员</td>
                    <td>
                        <sc:dradio name="manager" type ="dict" key="pcmc,boolflag" default="0"></sc:dradio>
                        <span class="info">管理本级机构</span>
                    </td>
					<td class="form-label">是否禁用</td>
					<td>
						<sc:dradio name="disable" type ="dict" key="pcmc,boolflag" index="1"></sc:dradio>
					</td>
				</tr>
				<tr>
                    <td class="form-label">联系电话</td>
                    <td class="form-value"><sc:text name="phone" _class="phone" index="1"/></td>
                    <td class="form-label">电子邮箱</td>
                    <td class="form-value"><sc:text name="email" index="1"/></td>
                </tr>
				<tr>
					<td class="form-label">备注</td>
					<td class="form-value" colspan="3"><sc:textarea  name="remark" index="1" style="resize:none" rows="2" cols="75"/></td>
				</tr>
			</table>
		</div>
	</div>
    <div class="formBar">
        <ul>
            <li><button class="savebtn" type="submit" onclick="updateUser()">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>
<script type="text/javascript">
function updateUser(){
	var form = $("#updateUserDialogForm",$.pdialog.getCurrent());
	var olddeptid = $("#olddeptid", $.pdialog.getCurrent()).val();
	var deptid = $("input[name='deptid']", $.pdialog.getCurrent()).val();
	if (!form.valid()) {
		return false;
	}
	
	var  sysName = '<sc:fmt value='funcpub' type='crypto'/>';
	var    oprID = '<sc:fmt value='funcpub-deptusermanager' type='crypto'/>';
	var  actions = '<sc:fmt value='updateUser' type='crypto'/>';
	var      url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions;
	$.ajax({    
        type:'post',        
        url:url,
        async:false,   
        dataType:'XML', 
        data:$(form).serialize(),
        success:function(data){   
        	var msg = $(data).find('DataPacket Response Data msg').text();
        	if("success" == msg){
        		alertMsg.correct('保存成功');
        		//if(olddeptid != deptid){
        			var treeObj = $.fn.zTree.getZTreeObj("deptUserTree");
        			var oldNode = treeObj.getNodeByParam("id",olddeptid, null);
        			var newNode = treeObj.getNodeByParam("id",deptid, null);
        			treeObj.reAsyncChildNodes(oldNode, "refresh");
        			treeObj.reAsyncChildNodes(newNode, "refresh");
        		//}
        		var btn = $("#selectChildUserBtn",navTab.getCurrentPanel());
    			$(btn).trigger("click");
        		$.pdialog.closeCurrent();
        	}else{
        		alertMsg.error(msg);
        	}
        }    
    });    
}

function deptTreeCallBack(deptArray,dept){
	$("#deptnameForUpdateUser").val(dept.name);
	$("#deptidForUpdateUser").val(dept.id);
}
</script>

