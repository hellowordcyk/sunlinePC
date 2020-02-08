<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="/common.jsp"%>
	<%
    	String sysName = Crypto.encode(request,"pcmc");
    	String oprID = Crypto.encode(request,"sm_menu");
    	String actions = Crypto.encode(request,"listAll");
    	String forward = "/pcmc/sm/menu/menus.jsp";
    	StringBuffer urlBuf = new StringBuffer();
    	urlBuf.append("/httpprocesserservlet?sysName=").append(sysName)
          	  .append("&oprID=").append(oprID)
              .append("&actions=").append(actions)
        	  .append("&forward=").append(forward);
	%>
</head>
<body style="padding: 0 5px;">
<table id="mainTabId" width="100%" cellpadding="0" cellspacing="0" border="0" style="table-layout: fixed;">
	<tr><td width="30%" valign="top">
		<table width="100%" height="400"  cellpadding="0" cellspacing="0" class="form-table" style="margin: 0; table-layout: fixed;">
		<tr><th id="tabTitleId">菜单列表</th></tr>
		<tr>
        	<td valign="top" style="padding: 0px;">
                <div id="quotalist" style="width: 100%;height: 360px;overflow:auto"></div>
            </td>
        </tr>
        <tr>
	        <td id="tabBottomId" class="form-bottom">
	            <sc:button name="savebtn" value="保存" _class="save" onclick="saveMenu();" attributesText="id='savebtn';"/>
				<sc:button name="addbtn" value="新增" _class="add" onclick="addMenu();" attributesText="id='addbtn';"/>
				<sc:button name="editbtn" value="修改" _class="edit" onclick="editMenu();" attributesText="id='editbtn';"/>
				<sc:button name="delbtn" value="删除" _class="delete" onclick="deleteMenu();" attributesText="id='delbtn';"/>
	        </td>
	    </tr>
	</table>
	</td>
    <td style="width: 5px;">&nbsp;</td>
	<td valign="top">
		<sc:form name="menuform" method="POST" action="/xmlprocesserservlet" sysName="pcmc" oprID="sm_menu" actions="updateMenu" attributesText="id='menuform';">
       		<div id="quotadetail"></div>
        </sc:form>
	</td></tr>
</table>
</body>
<script language="JavaScript">
new Jraf.DimensionsAuto(window, '#mainTabId', 'height', 0);
$("quotalist").setStyle({height: ($("mainTabId").getHeight() - $("tabTitleId").getHeight() - $("tabBottomId").getHeight() - 10) + "px"});
	var ajax = new Jraf.Ajax();
	/*var jraftreemenu = new Jraf.Tree({selector:'#quotalist', 
			onexpand:function(srcNode){
				srcNode.icon.src=srcNode.treeContext.imageList.item["hfold_open"].src;
				if(srcNode.first && srcNode.first.tag=='asyncloading'){
					addSubMenus(jraftreemenu, srcNode.tag.subsysid, srcNode.tag.menuid);
				}
			}
	});
	addSubMenus(jraftreemenu);*/
	var jraftreemenu = new Jraf.SimpleTree({
        selector:'#quotalist',
        rootType: {//向nodeTypes中增加根节点类型参数
            sysName: '<sc:fmt type="crypto" value="pcmc"/>',
            oprID:   '<sc:fmt type="crypto" value="sm_menu"/>',
            actions: '<sc:fmt type="crypto" value="listAll"/>',
            extraParams: {subsysid: '', menuid: ''},
            onClick: viewItem
        }
    });
	/*jraftreemenu.addNodeType("root", {
            sysName: '<sc:fmt type="crypto" value="pcmc"/>',
            oprID:   '<sc:fmt type="crypto" value="sm_menu"/>',
            actions: '<sc:fmt type="crypto" value="listAll"/>',
            extraParams: {subsysid: '', menuid: ''},
            onClick: viewItem
     });*/
	jraftreemenu.addNodes();
/*function addSubMenus(jraftree,subsysid,menuid){
	var reqparams = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID: 		'<sc:fmt type="crypto" value="sm_menu"/>',
		actions:	'<sc:fmt type="crypto" value="listAll"/>',
		subsysid: '',
		menuid:		''
		};
	if(menuid){
		Object.extend(reqparams,{menuid:menuid});
	}
	if(subsysid){
		Object.extend(reqparams,{subsysid:subsysid});
	}
	ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
			try{
	   		var pkg = new Jraf.Pkg(xml);
				if(pkg.result() != '0'){
					alert('获取菜单列表出错！\n'+pkg.allMsgs());
					return;
				}
				var rcds = pkg.rspDatas().Record;
				if(!rcds) rcds=[];
				if(!Object.isArray(rcds)) rcds = [rcds];
				rcds.each(function(rcd){
					var item={
						name:rcd.menuname+'('+rcd.menuid+')',
						key:'n'+rcd.subsysid+','+rcd.menuid,
						pkey:'n'+rcd.subsysid+','+rcd.pmenuid,
						onClick: viewItem,
						tag: rcd
						};
					var nNode=jraftree.addNode(item);
					if(rcd.childnum!='0'){
						jraftree.addNode({name:'loading...',key:'load',pkey:item.key,tag:'asyncloading'});
						nNode.expand(false,true);
					}
				},this);
				if(subsysid){
					var pNode=jraftree.treeContext.nodes['n'+subsysid+','+menuid];
					if(pNode.first && pNode.first.tag == 'asyncloading'){
						pNode.first.remove();
						if(!pNode.first){
							pNode.icon.src = pNode.treeContext.imageList.item["default"].src;
						}
					}
				}
				//jraftree.collapseAll();
			}catch(e){alert('ERROR:'+e);}
				
		});
}*/
function viewItem(node){
	if(!node) return;
	var menu = node.tag;

	var reqparams = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID: 		'<sc:fmt type="crypto" value="sm_menu"/>',
		actions:	'<sc:fmt type="crypto" value="listmenu"/>',
		subsysid: menu.subsysid,
		menuid:		menu.menuid,
		pmenuid:	menu.pmenuid
	};
	ajax.loadPageTo('/pcmc/sm/menu/quotamenuview.so',reqparams,'quotadetail');
	$('savebtn').disable();
}
$('savebtn').disable();
function addMenu(){
	var node=jraftreemenu.treeContext.getSelectedNode();
	if(!node){
		Jraf.showMessageBox({
			type: "info",
			text: "请选择新增菜单的上级菜单节点!"
		});
		return;
	}
	var menu = node.tag;
	var reqparams = {
		subsysid: 	(menu.menuid == "")?"":menu.subsysid,
		pmenuid:	menu.menuid
		};
	ajax.loadPageTo('/pcmc/sm/menu/quotamenudetail.jsp',reqparams,'quotadetail');
	$$("input[name='actions']")[0].value = '<sc:fmt value="addMenu" type="crypto"/>';
	// document.getElementsByName("actions").value = '<sc:fmt value="addMenu" type="crypto"/>';
	//$('actions').value='<sc:fmt value="addMenu" type="crypto"/>';
	$('savebtn').enable();
}
function editMenu(){
	var node=jraftreemenu.treeContext.getSelectedNode();
	if(!node){
		Jraf.showMessageBox({
			type: "info",
			text: "请选择要修改的菜单!"
		});
		return;
	}
	var menu = node.tag;
	if (menu.menuid == "") {//根节点
		Jraf.showMessageBox({
			type: "warn",
			text: "禁止修改当前菜单节点信息!"
		});
		return;
	}
	
	var reqparams = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID: 		'<sc:fmt type="crypto" value="sm_menu"/>',
		actions:	'<sc:fmt type="crypto" value="listmenu"/>',
		subsysid:	menu.subsysid,
		menuid:		menu.menuid,
		pmenuid:	menu.pmenuid,
		editable: true
	};
	ajax.loadPageTo('/pcmc/sm/menu/quotamenudetail.so',reqparams,'quotadetail');
	$$("input[name='actions']")[0].value  = '<sc:fmt value="updateMenu" type="crypto"/>';
	$('savebtn').enable();
}
function deleteMenu(){
	var node=jraftreemenu.treeContext.getSelectedNode();
	if(!node){
		Jraf.showMessageBox({
			type: "info",
			text: "请选择要删除的菜单!"
		});
		return;
	}
	var menu = node.tag;
	if(!menu.menuid){
		Jraf.showMessageBox({
			type: "warn",
			text: "禁止删除此菜单节点!"
		});
		return;
	}
	if (!confirm("您确认要删除菜单["+menu.menuname+"]及对应的角色权限吗？")){
		return;
	}
	var reqparams = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID: 		'<sc:fmt type="crypto" value="sm_menu"/>',
		actions:	'<sc:fmt type="crypto" value="deleteMenu"/>',
		subsysid:   menu.subsysid,
		menuid:		menu.menuid
		};
	ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
		try{
	   		var pkg = new Jraf.Pkg(xml);
				if(pkg.result() != '0'){
					Jraf.showMessageBox({
						type: "error",
						text: "删除菜单出错！\n"+pkg.allMsgs()
					});
					return;
				}			
		    var pNode = node.parent;
				node.remove();
		    if(! pNode.hasChild)
		    {
		        pNode.icon.src=pNode.treeContext.imageList.item["default"].src;
		    }
				$('savebtn').disable();
				$('quotadetail').update();
			}catch(e){alert('ERROR:'+e);}
		});
}
function saveMenu(){
    var formObj = document.forms["menuform"];
    if (!checkForm(formObj)) {
        return;
    }
	ajax.submitFormXml('menuform',function(xml){
		try{
	   		var pkg = new Jraf.Pkg(xml);
				if(pkg.result() != '0'){
					Jraf.showMessageBox({
						type: "error",
						text: '保存菜单信息出错！\n'+pkg.allMsgs()
					});
					return;
				}			
				Jraf.showMessageBox({
					type: "success",
					text: "保存菜单信息成功。"
				});
				var menuid   = $$("input[name='menuid']")[0].value;//document.getElementsByName("menuid").value;//$F('menuid');
				var oPmenuid = $$("input[name='pmenuid']")[0];
				var pmenuid  = oPmenuid==null?"":oPmenuid.value;//document.getElementsByName("pmenuid").value;//$F('pmenuid');
				var menuname = $$("input[name='menuname']")[0].value;//document.getElementsByName("menuname").value;//$F('menuname');
				var subsysid = $$("input[name='subsysid']")[0].value;//document.getElementsByName("subsysid").value;//$F('subsysid');
                var pNode=jraftreemenu.treeContext.getSelectedNode();
				if(menuid==''){
					menuid = pkg.rspData('Record/menuid');
					var item={
						name:menuname+'('+menuid+')',
						key:  pNode.tag.key+','+menuid,
						pkey: pNode.tag.key,
						onClick: viewItem,
						tag: {subsysid:subsysid,menuid:menuid,pmenuid:pmenuid,menuname:menuname}
						};
					var nNode=jraftreemenu.addNode(item);
					pNode.expand(true);
				}else{
					var key = 'n,'+subsysid+','+menuid;
					var node=jraftreemenu.treeContext.nodes[key];
					if(!node) return;
					$(node.label).update(menuname+'('+menuid+')');
					Object.extend(node.tag,{menuid:menuid,pmenuid:pmenuid,subsysid:subsysid,menuname:menuname});
				}
			}catch(e){alert('[method=saveMenu]jsERROR:'+e.message);}
		});
}
</script>
</html>
