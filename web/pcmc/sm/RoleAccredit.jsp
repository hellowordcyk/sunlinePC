<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.bimis.pcmc.util.MenuUtil"%>
<%@ page import="com.sunline.jraf.util.Crypto"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/common.jsp"%>
</head>
<body>
    <form action="/httpprocesserservlet" method="post">
        <input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
        <input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
        <input type="hidden" name="actions" value="<sc:fmt value='savePermissions' type='crypto'/>">
        <input type="hidden" name="forward" value="/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getRoleList' type='crypto'/>&PageNo=1&forward=<sc:fmt value='/pcmc/sm/RoleList.jsp' type='crypto'/>">
        <input type="hidden" name="roleid" value="<%=request.getParameter("roleid")%>" id="roleid">
        
        <table width="100%" height="100%" cellpadding="0" cellspacing="5">
            <tr>
                <td width="35%" valign="top">
                    <table width="100%" cellpadding="0" cellspacing="0" class="form-table">
                        <tr><th colspan="4">角色详细信息</th></tr>
                        <tr>
                            <td class="form-label" width="23%">角色名称：</td>
                            <td id="rolenameid" class="form-value"></td>
                        </tr>
                        <tr>
                            <td class="form-label">所属子系统：</td>
                            <td id="cnnameid" class="form-value"></td>
                        </tr>
                    </table>
                </td>
                <td width="65%" valign="top">
                    <table width="100%" cellpadding="0" cellspacing="0" class="form-table" style="margin: 0px;">
                    <tr><th colspan="4">菜单授权信息</th></tr>
                    <tr>
                        <td style="padding: 0px;">
                            <div id="roleAccreditTree" style="width: 100%; overflow: auto;">
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td class="form-bottom">
                            <sc:button value="保存" onclick="saveOk();"/>
                            <sc:button value="重置" type="reset"/>
                            <sc:button value="返回" onclick="goBack();"/>
                        </td>
                    </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>
<script type="text/javascript">
new Jraf.DimensionsAuto(window, '#roleAccreditTree', 'height', -80);

var cnname = unescape('${param.cnname}');
var rolename = unescape('${param.rolename}');
$("cnnameid").update(cnname);
$("rolenameid").update(rolename);
var cTime = new Date();
var ajax = new Jraf.Ajax();
var roleid = '${param.roleid}';

var menuTreeArr = new Array();
menuTreeArr.clear;
/* 初始化界面 */
var ajax = new Jraf.Ajax();         //Ajax 抽象类

/** 树控件 */
var menuTree = new Jraf.Tree({
    selector : '#roleAccreditTree',
    onexpand:  function(srcNode){expandNode(menuTree, srcNode, true);}
});

/** 展开树结点的加载 */
function expandNode(menuTree, srcNode, isAllExpand){
    srcNode.icon.src = srcNode.treeContext.imageList.item["hfold_open"].src;
}
loadMenuTree(menuTree);
/** 加载树结点 */
function loadMenuTree (menuTree, pmenuid, isAllExpand) {
    /* 初始化参数变量 */
    var params = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:      '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getPermissions"/>',
        roleid:     $("roleid").value,
        pmenuid:    ''
    };
    if(pmenuid) {Object.extend(params, {pmenuid:pmenuid});}
    /* 查询初始化树结点 */
    ajax.sendForXml('/xmlprocesserservlet', params, function(xml){initMenuTree(xml, menuTree, pmenuid, isAllExpand);});
}

/** 树结点赋值 */
function initMenuTree (xml, menuTree, pmenuid, isAllExpand) {
    try{
        var pkg = new Jraf.Pkg(xml);
        if (pkg.result() != '0') {
            alert('获取菜单树异常！\n' + pkg.allMsgs());        //查询失败处理
        }
        var rcds = pkg.rspDatas().Record;
        if(!rcds) {rcds = [];}
        if(!Object.isArray(rcds)) {rcds = [rcds];}
        /* 决定下级扩展结点的勾选状态 */
        var pkey = pmenuid;
        var pNode = menuTree.treeContext.nodes[pkey];
        var checked;
        rcds.each( function(rcd){
            addMenuNode(menuTree, rcd, checked, isAllExpand);
        }, this);       //循环添加结点
    } catch(ex) {
        alert('[method=initMenuTree]ERROR:' + ex);
    }
}

/** 树结点添加结点 */
function addMenuNode(MenuTree, rcd, checked, isAllExpand){
	
    var menu = {
        name:       rcd.menuname,
        key:        'n'+rcd.menuid,
        pkey:       'n'+rcd.pmenuid,
        onClick:    viewMenuInfo,   //点击结点响应事件
        tag:        rcd,
        checkName: "menuid",
        checkValue: rcd.menuid
    };
    
     /* 判别勾选条件 */
    
    if(rcd.selected == "checked"){
        //menuNode.checkBox.checked = true;
        checked= true;
    }
    
    var menuNode = menuTree.addChkNode(menu, checked);
    if(isAllExpand && isAllExpand == true){
        menuNode.expand(true, false);
    }else{
        menuNode.expand(false, true);
    }
    $(menuNode.checkBox).observe("click", function () {selectNodes(this);});//IE7兼容
    $(menuNode.checkBox).writeAttribute("onclick", "javascript:selectNodes(this)");//增加checkBox的onclick属性
    menuTreeArr.push(menuNode);//把所有节点保存到一个数组中，用于onclick函数中遍历数组。
    
    
    return menuNode;
}

/** 结点选择事件 */
function viewMenuInfo(){
    
}

/* onclick 函数*/
function selectNodes(checkBox){
    if(checkBox.checked == true){//某节点被选择，则递归出其先辈节点并选择
        $A(menuTreeArr).each(function(e){
            if(e.tag.menuid.toString() == checkBox.value.toString()){
                 updateTreeNodes(e,true);
                 throw $break;
            }
        });
    }else{//某节点被取消，则递归出其后辈节点并取消
        $A(menuTreeArr).each(function(e){
            if(e.tag.menuid.toString() == checkBox.value.toString()){
                 updateTreeNodes(e,false);
                 throw $break;
            }
        });
    }
}

/* 找出树的父节点或者子节点 为checkBox赋值*/
function updateTreeNodes(menuNode,isParent){
    if(isParent){
        menuNode.checkBox.checked = true;
        if(menuNode.tag.pmenuid){
            updateTreeNodes(menuNode.parent,true);
        }
    }else{
        menuNode.checkBox.checked = false;
        var childrens = menuNode.children;
        if(childrens != null && childrens.length > 0){
            childrens.each(function(children){
                updateTreeNodes(children,false);
            });
        }
    }
    
}

/** 获取所有勾选的值集 */
function getCheckedMenu(){
    var checkedMenus = new Array();
    checkedMenus.push(roleid);
    var treeNodes = menuTree.treeContext.nodes;
    treeNodes.each(function(node){
        if(node.tag.checkBox.checked == true){
            checkedMenus.push(node.tag.menuid);
        }
    });
    return checkedItems;
}




function  OnItemClick( ){
    var dtNow = new Date();
    dd = dtNow.getTime() - cTime.getTime();
    if( dd < 500 ){
        return;
    }
    cTime = dtNow;
    var c = window.event.srcElement.id.substring(window.event.srcElement.id.length-1,window.event.srcElement.id.length);
    if (c==""){
        return;
    }
    if( window.event.srcElement.className == "clsItemsShow1" ){
        window.event.srcElement.className = "clsItemsShow1";
        return;
    }
    if( window.event.srcElement.className == "clsItemShow" ){
        window.event.srcElement.className = "clsItemHide";
        document.all( window.event.srcElement.id + 'u').className = "clsItemsHide";
    }else{
        window.event.srcElement.className = "clsItemShow";
        document.all( window.event.srcElement.id + 'u' ).className = "clsItemsShow";
    }
}
    
function saveOk(){
    
    document.forms[0].submit();
}

function selectMenu(){
    var idstr, flag;
    idstr = event.srcElement.parentNode.id;
    parentul = event.srcElement.parentNode.parentNode;
    ulstr = parentul.id;
    if (event.srcElement.checked){
        while (ulstr){
            var chkps = document.getElementById(ulstr.substring(0,ulstr.length-1)).getElementsByTagName("input");
            chkps[0].checked = event.srcElement.checked;
            parentul = parentul.parentNode.parentNode;
            ulstr = parentul.id;
        }
    }
    if (document.getElementById(idstr +'u')!=null){
        var chks = document.getElementById(idstr +'u').getElementsByTagName("input");
        for(var k=0; k<chks.length; k++) {
            if(chks[k].type && chks[k].type=="checkbox") {
                chks[k].checked = event.srcElement.checked;
            }
        }
    }
}
function goBack() {
    var url = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_query' type='crypto'/>&actions=<sc:fmt value='getRoleList' type='crypto'/>&PageNo=1&forward=<sc:fmt value='/pcmc/sm/RoleList.jsp' type='crypto'/>'
    document.location.href = url;
}
</script>
</html>