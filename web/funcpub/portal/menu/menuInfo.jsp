<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 修改菜单信息
 * description: 
 *     1.修改菜单信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160624 
 *--%>
<div class="pageContent">
	<h2 class="contentTitle">菜单信息</h2>
	<form method="post" action="/httpprocesserservlet" class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone)">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-menumanager' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='updateMenuInfo' type='crypto'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/jui/callMessage.jsp' />"/>
		<input type="hidden" name="subsysid" value="${param.subsysid}"/>
		<input  type="hidden" name="oldpmenuid" index="1" value="${jrafrpu.rspPkg.rspRcdDataMaps[0].pmenuid}"   />
		<div class="pageFormContent">
			<table class="form-table" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">菜单编号<sc:hidden name="menuid" /></td>
					<td class="form-value"><sc:write name="menuid" /></td>
					<td class="form-label">所属子系统</td>
					<td class="form-value"><sc:optd name="subsysid" type="subsys" index = "1"/></td>
				</tr>
				<tr>
					<td class="form-label">上级菜单编号</td>
					<td class="form-value"><sc:text name="pmenuid" index="1" /></td>
					<td class="form-label"><span class="redmust">*</span>菜单名称</td>
					<td class="form-value"><sc:text name="menuname" validate="required" index="1"/></td>
				</tr>
				<tr>
					<td class="form-label">是否叶子节点</td>
					<td><sc:dradio name="isleaf" type="dict" key="pcmc,boolflag" index="1"/></td>
					<td class="form-label">是否公网发布</td>
					<td><sc:dradio name="isinternet" type="dict" key="pcmc,boolflag" index="1"/></td>
				</tr>
				<tr>
					<td class="form-label">显示序号</td>
					<td  class="form-value"><sc:text name="sortno" index="1"/></td>
					<td class="form-label">打开方式</td>
					<td  class="form-value"><sc:select name="displaytype" type="dict" key="pcmc,menu_displaytype" index="1" includeTitle="false" default="01"/></td>
				</tr>
				<tr>
					<td class="form-label">图片地址</td>
					<td  class="form-value" colspan="3"><sc:text name="imgurl" index="1" /></td>
				</tr>
				<tr>
					<td class="form-label">超链接地址</td>
					<td  class="form-value" colspan="3"><sc:text name="linkurl" index="1" /></td>
				</tr>
				<tr>
					<td class="form-label">备注</td>
					<td  class="form-value" colspan="3"><sc:textarea name="remark" rows="1" cols="76" style="resize:none;" index="1"/></td>
				</tr>
			</table>
		</div>
		<div class="formbutton_bg">
			<ul>
				<li><button class="savebtn" type="button" onclick="updateMenu()">保存</button></li>
			</ul>
		</div>
	</form>
</div>
<script>

function updateMenu(){
	var oldPmenuid = $("input[name='oldpmenuid']",navTab.getCurrentPanel()).val();
	var newPmenuid = $("input[name=pmenuid]",navTab.getCurrentPanel()).val();
	var form = $("form",navTab.getCurrentPanel());
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
		    + "&oprID=<sc:fmt value='funcpub-menumanager' type='crypto'/>"
		    + "&actions=<sc:fmt value='updateMenuInfo' type='crypto'/>";
	$.ajax({
    	type:'POST',
    	url: url,
    	dataType:'xml',
    	data:form.serialize(),
    	success:function(data){
    		var msg = $(data).find('DataPacket Response Data msg').text();
    		if("success" == msg){
    			alertMsg.correct('修改成功');
    			reflush(oldPmenuid,newPmenuid);
    		}else{
    			alertMsg.error(msg);
    		}
    	}
	}); 	    
}
function reflush(oldPmenuid,newPmenuid){
	var treeObj = $.fn.zTree.getZTreeObj("menuTree");
	var subsysid = $("input[name='subsysid']",navTab.getCurrentPanel()).val();
	
	var node = treeObj.getNodeByParam("id","sys"+subsysid, null);
	var oldNode = (oldPmenuid != null && oldPmenuid != "")?treeObj.getNodeByParam("id",oldPmenuid, null):null;
	var newNode = (newPmenuid != null && newPmenuid != "")?treeObj.getNodeByParam("id",newPmenuid, null):null;
	if(oldNode == null || newNode == null){
		treeObj.reAsyncChildNodes(node, "refresh");
		treeObj.expandNode(node, true, false, false);
	}else{
		treeObj.reAsyncChildNodes(oldNode, "refresh");
		//treeObj.reAsyncChildNodes(newNode, "refresh");
	}

	$("input[name='oldpmenuid']",navTab.getCurrentPanel()).val(newPmenuid);
}
</script>