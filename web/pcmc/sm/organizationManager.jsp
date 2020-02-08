<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/common.jsp" %>
</head>
<body>
<%-- 用户同步权限控制 --%>
<sc:doPost var="userSyncData" scope="request" sysName="pcmc" 
           oprId="UserSync" action="hasStartSync" ></sc:doPost>
    <div id="itemPMenu" style="display:none;">
    <table width="100%"  border="0" align="center" cellpadding="5" cellspacing="0">
    <tr><td style="font-size:10pt;cursor:default;border:outset 0.7;background-image:url(/common/skins/default/images/form_bottom.gif)" align="center" onclick="parent.addSubDept()">增加下级机构</td></tr>
    <tr><td style="font-size:10pt;cursor:default;border:outset 0.7;background-image:url(/common/skins/default/images/form_bottom.gif)" align="center" onclick="parent.addDeptUser();">增加机构人员</td></tr>  
    <tr><td style="font-size:10pt;cursor:default;border:outset 0.7;background-image:url(/common/skins/default/images/form_bottom.gif)" align="center" onclick="parent.delselfDept()">删除本级机构</td></tr>
    <tr><td style="font-size:10pt;cursor:default;border:outset 0.7;background-image:url(/common/skins/default/images/form_bottom.gif)" align="center" onclick="parent.refresh()">刷新</td></tr>
    </table>  
    </div> 
    <div id="itemCMenu" style="display:none">  
    <table width="100%"  border="0" align="center" cellpadding="5" cellspacing="0">
    <tr><td style="font-size:10pt;cursor:default;border:outset 0.7;background-image:url(/common/skins/default/images/form_bottom.gif)" align="center" onclick="parent.updateUser();">维护人员权限</td></tr>  
    <tr><td style="font-size:10pt;cursor:default;border:outset 0.7;background-image:url(/common/skins/default/images/form_bottom.gif)" align="center" onclick="parent.delUser()">删除人员</td></tr>
    </table>  
    </div> 
    <table width="100%"  border="0" align="center" cellpadding="0" cellspacing="0">
    <tr>
        <td style="width:20%; vertical-align:top; " valign="top">
            <div id="mainleftId" class="page-title" style="margin-bottom: 0;">
                <span class="title">部门列表
                  <c:if test="${userSyncData.rspRcdDataMaps[0].hasStart == 0}">
                    <span class="titlebar" >
                        <input type="button" class="refresh" style="margin: 0;"
                            name="userSync" onclick="syncUser(this)" value="用户同步" title="同步统一展现分配给本系统的所有用户"/>
                    </span>
                  </c:if>
                </span>
                <div id="quotalist" style="width:100%; height: 480px; overflow:auto">
                </div>
            </div>
        </td>
        <td valign="top">
            <!-- 派生指标信息显示部分 -->
            <div id="mainRightId" style="width: 100%;height: 480px;"></div>
       </td>
    </tr>
    </table>
<script language="JavaScript" defer="defer">
var g_deptname=null;
/*定义当前用户拥有权限的机构的数组*/
var dept = new Array();
var isHasStartPriv = "false";
var ajax = new Jraf.Ajax();
var jraftreemenu = null;

document.observe("dom:loaded", function () {
    setHeightAuto();
    
    /*初始化当前用户拥有权限的机构的数组*/
    getCurUserPrivForDept();

    jraftreemenu = new Jraf.Tree({selector:'#quotalist',
        onexpand:function(srcNode){
                srcNode.icon.src=srcNode.treeContext.imageList.item["hfold_open"].src;
                if(srcNode.first && srcNode.first.tag=='asyncloading'){
                    addSubDepts(jraftreemenu, srcNode.tag.deptid);
                }
            }
        });
         var itemRoot = jraftreemenu.addNode({name: '机构树', key: 'root', pkey: 'n',onRightClick: addRightMenu,tag: {nodetype: 'parentnode',deptid:'0',levelp:'0'}});
         addSubDepts(jraftreemenu);

     //   ajax.loadPageTo('/pcmc/sm/query_pcmcdept_deptotal.jsp?deptid='+1,{},'mainRightId');
	    ajax.loadPageTo('/pcmc/sm/query_pcmcdept_deptotal.jsp',{},'mainRightId');
});

function setHeightAuto() {
    new Jraf.DimensionsAuto(window, "#mainleftId", "height", -2); 
    var oLeftTd = $("mainleftId");
    var oRight = $("mainRightId"); 
    oRight.setStyle({height: (oLeftTd.getHeight()) + "px"});
    $("quotalist").setStyle({height: (oLeftTd.getHeight() - oLeftTd.down(".title").getHeight() -2) + "px"});
}

//判断str是否存在数组中
function exists(str,ary){
    var b=false;
    if(isHasStartPriv=="false"){
        return true;
    }
    for(var i=0;i<ary.length;i++){
        if(ary[i].objtid==str){
            b=true;
            break;
        }
    }
    return b;
}
//查询当前用户的机构权限
function getCurUserPrivForDept(){
    var reqparams = {
            sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
            oprID:         '<sc:fmt type="crypto" value="privActor"/>',
            actions:    '<sc:fmt type="crypto" value="getRolePriv"/>'
    };
    var ajax = new Jraf.Ajax();
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
            try{
                   var pkg = new Jraf.Pkg(xml);
                if(pkg.result() != '0'){
                    Jraf.showMessageBox({
                        text: '<span class="error">查询当前用户的机构信息出错！\n</span>'
                    });
                    return;
                }    
                var rcds = pkg.rspDatas().Record;
                if(!rcds) rcds=[];
                if(!Object.isArray(rcds)) rcds = [rcds];
                dept = rcds;
                isHasStartPriv = pkg.rspData("hasStart");
            }catch(e){alert('ERROR:'+e);}
        
    });
}

function addRightMenu(){
  <c:if test="${userSyncData.rspRcdDataMaps[0].hasStart == 0}">
    return false;<%-- 接入统一展现时，不能修改新增删除数据 --%>
  </c:if>
    var selTag = jraftreemenu.treeContext.getSelectedNode().tag;
    var nodetype = selTag.nodetype;
    var deptid = selTag.deptid;
    if(deptid==null){
        deptid = selTag.pdeptid;
    }
    if(nodetype == 'childnode' && exists(deptid,dept)){
        showChildMenu();
    }else if(nodetype=='parentnode' && exists(deptid,dept)){ 
         showParentMenu();
    }else{
          event.returnValue=false;
    }
}
function showChildMenu(){  
    popMenu(itemCMenu,100,"1111");  
    event.returnValue=false;  
    event.cancelBubble=true;  
    return false;  
}
function showParentMenu(){  
    popMenu(itemPMenu,100,"1111");  
    event.returnValue=false;  
    event.cancelBubble=true;  
    return false;  
}

/**
 *显示弹出菜单
 *menuDiv:右键菜单的内容
 *width:行显示的宽度
 *rowControlString:行控制字符串，0表示不显示，1表示显示，如“101”，则表示第1、3行显示，第2行不显示
 */
function popMenu(menuDiv,width,rowControlString){  
    //创建弹出菜单  
    var pop=window.createPopup();  
    //设置弹出菜单的内容  
    pop.document.body.innerHTML=menuDiv.innerHTML;  
    var rowObjs=pop.document.body.all[0].rows;
    //获得弹出菜单的行数  
    var rowCount=rowObjs.length;
    //循环设置每行的属性  
    for(var i=0;i<rowObjs.length;i++)
    {  
    //如果设置该行不显示，则行数减一
      var hide=rowControlString.charAt(i)!='1';
      if(hide){
          rowCount--;
     }
     //设置是否显示该行
     rowObjs[i].style.display=(hide)?"none":"";
    
    //设置鼠标滑入该行时的效果  
    rowObjs[i].cells[0].onmouseover=function()
        {  
        this.style.backgroundImage="url(/common/skins/default/images/th-bg.gif)";
        }   
     //设置鼠标滑出该行时
    rowObjs[i].cells[0].onmouseout=function()
        {
        this.style.backgroundImage="url(/common/skins/default/images/form_bottom.gif)";
        }
    } 
    //屏蔽菜单的菜单  
    pop.document.oncontextmenu=function(){  
        return false;  
    }  
    //选择右键菜单的一项后，菜单隐藏  
    pop.document.onclick=function(){ 
      pop.hide(); 
    }
    //显示菜单
    pop.show(event.clientX-1,event.clientY,width,rowCount*25,document.body);  
        return true;  
}  

/*右键增加下级机构*/
function addSubDept()
{
    var selTag = jraftreemenu.treeContext.getSelectedNode().tag;
    var deptid = selTag.deptid;
    var levelp = selTag.levelp;
    var pdeptid = selTag.pdeptid;
    if (null == deptid) {
        if (confirm('您未选择任何部门，要新增一个顶级部门吗？'))
        {
            document.location = "/pcmc/sm/OrgDeptAdd.jsp?pdeptid=-1&levelp=1";
        }
    } else {
        levelp =parseInt(levelp);
        var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>' 
                 + '&oprID=<sc:fmt type="crypto" value="sm_maintenance"/>' 
                 + '&actions=<sc:fmt type="crypto" value="getDeptDetail"/>' 
                 + '&deptid='+deptid+'&levelp='+levelp+'&forward=<sc:fmt value='/pcmc/sm/OrgDeptAdd.jsp' type='crypto'/>&dt='+new Date().getTime();
         var winResults = openModal(url,800,500);
         if(winResults!=null){
             var deptname = winResults["deptname"];
             var deptcode = winResults["deptcode"];
             var pdeptid  = winResults["pdeptid"];
             var deptid  = winResults["deptid"];
             var item = {
                       name:            deptname+'['+deptcode+']',
                       key:            'n'+deptid,
                       pkey:            'n'+pdeptid,
                       onClick:        viewItem,
                       onRightClick:     addRightMenu,
                       tag: {deptcode:deptcode,deptname:deptname,deptid:deptid,pdeptid:pdeptid,nodetype:"parentnode"}
                };
              if(item.pkey=='n0'){
		                   				item.pkey='root'; //添加根节点下的一级子节点 
		               			 }
             var nNode=jraftreemenu.addNode(item);
            // nNode.parent.expand(true);
             nNode.icon.src=jraftreemenu.treeContext.imageList.item["hfold_close"].src;
             var pNode = jraftreemenu.treeContext.nodes[nNode.pdeptid];

             if (pNode && pNode.first && pNode.first.tag == 'asyncloading') {
                    pNode.first.remove();        //消除是否含子结点的标志行
                    if(!pNode.first){
                        pNode.icon.src = pNode.treeContext.imageList.item["hfold_close"].src;
                    }
             }
        }
    }
}

/*右键增加机构人员*/
function addDeptUser()
{
     var node = jraftreemenu.treeContext.getSelectedNode();
     var deptid = node.tag.deptid;
    var deptname = node.tag.deptname;
    var url = "/pcmc/sm/OrgUserAdd.jsp?editFlag=false&deptid="+deptid+"&deptname="+encodeURI(encodeURI(deptname));
    var winResults = openModal(url,800,500);
    if (winResults != null) {
    var usercode = winResults["usercode"];
    var username = winResults["username"];
    var userid     = winResults["userid"];
    var item = {
                name:            username+'['+usercode+']',
                key:            'nu'+userid,
                pkey:            'n'+node.tag.deptid,
                onClick:        viewItem,
                onRightClick:     addRightMenu,
                tag: {usercode:usercode,username:username,nodetype:"childnode",userid:userid,pdeptid:deptid}
                };
            var nNode=jraftreemenu.addNode(item);
            nNode.parent.expand(true);
    }
}
function updateUser(){
    var node = jraftreemenu.treeContext.getSelectedNode();
    var userid = node.tag.userid;
    var url = "/pcmc/sm/UserDetail.jsp?userid="+userid;
       var winResults = openModal(url,800,500);
}

/*刷新当前页面*/
function refresh(){
    document.getElementById("quotalist").innerHTML='';
    var ajax = new Jraf.Ajax({asynchronous:false});
    jraftreemenu = new Jraf.Tree({selector:'#quotalist',
    onexpand:function(srcNode){
            srcNode.icon.src=srcNode.treeContext.imageList.item["hfold_open"].src;
            if(srcNode.first && srcNode.first.tag=='asyncloading'){
                addSubDepts(jraftreemenu, srcNode.tag.deptid);
            }
        }
    });
     var itemRoot = jraftreemenu.addNode({name: '机构树', key: 'root', pkey: 'n',onRightClick: addRightMenu,tag: {nodetype: 'parentnode',deptid:'0',levelp:'0'}});
    addSubDepts(jraftreemenu);
}
/*右键删除本级机构*/
function delselfDept()
{
    var node=jraftreemenu.treeContext.getSelectedNode();
   
    if(!node){
        alert('请选择要删除的机构');
        return;
    }
    if (!confirm("您确认要删除该机构吗？")){
    return;
    }
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:         '<sc:fmt type="crypto" value="sm_maintenance"/>',
        actions:    '<sc:fmt type="crypto" value="deleteOrgDeptandUser"/>',
        deptid:        node.tag.deptid
    };
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
    try{
           var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                alert('删除菜单出错！\n'+pkg.allMsgs());
                return;
            }            
        var pNode = node.parent;
            node.remove();
        if(! pNode.hasChild)
        {
            pNode.icon.src=pNode.treeContext.imageList.item["hfold_close"].src;
        }
        refresh();
        }catch(e){alert('ERROR:'+e);}
    });
}

/*右键删除人员*/
function delUser()
{
    var node=jraftreemenu.treeContext.getSelectedNode();
    if(!node){
        alert('请选择要删除的人员');
        return;
    }
    if (!confirm("您确认要删除该人员吗？")){
    return;
    }
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:         '<sc:fmt type="crypto" value="sm_maintenance"/>',
        actions:    '<sc:fmt type="crypto" value="deleteUser"/>',
        userid:         node.tag.userid
    };

    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
    try{
           var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                alert('删除菜单出错！\n'+pkg.allMsgs());
                return;
            }            
        var pNode = node.parent;
            node.remove();
        if(! pNode.hasChild)
        {
            pNode.icon.src=pNode.treeContext.imageList.item["hfold_close"].src;
        }
        refresh();
        }catch(e){alert('ERROR:'+e);}
    });
}

function setDeptValue(dept)
{   
    if(!dept) return;
    var deptid = dept.deptid;
    var deptcode = dept.deptcode;
    g_deptname= dept.deptname;
    var levelp = dept.levelp;
    ajax.loadPageTo('/pcmc/sm/query_pcmcdept_deptotal.jsp?deptid='+deptid+'&deptcode='+deptcode+'&levelp='+levelp,{},'mainRightId');
}
function setUserValue(dept)
{
    if(!dept) return;
    var pdeptid = dept.pdeptid;
    var usercode = dept.usercode;
    var userid = dept.userid;
    ajax.loadPageTo('/pcmc/sm/query_pcmcdept_userinfo.jsp?deptid='+pdeptid+'&usercode='+usercode+'&userid='+userid,{},'mainRightId');
}
function addSubDepts(jraftree,deptid){
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:         '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getOrgSubDepts"/>',
        recursive:  '0'
        };
    if(deptid){
        Object.extend(reqparams,{deptid:deptid});
    }
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
            try{
               var pkg = new Jraf.Pkg(xml);
                if(pkg.result() != '0'){
                    alert('获取部门列表出错！\n'+pkg.allMsgs());
                    return;
                }
                var rcds = pkg.rspDatas().Record;
                if(!rcds) rcds=[];
                if(!Object.isArray(rcds)) rcds = [rcds];
                rcds.each(function(rcd){
                   var item={
                        name:rcd.deptname+'['+rcd.deptcode+']',
                        key:'n'+rcd.deptid,
                        pkey:'n'+rcd.pdeptid,
                        onClick: viewItem,
                        onRightClick:     addRightMenu,
                        tag: rcd
                        };
                    if(item.key == item.pkey){
                      item.pkey='root';
                    }    
                    if(rcd.nodetype=='childnode'){
                      item.key='nu'+rcd.userid;
                    }
                    
                    var nNode=jraftree.addNode(item);
                    if(rcd.childnum=='0'&&rcd.nodetype=='parentnode'){
                        nNode.icon.src = nNode.treeContext.imageList.item["hfold_close"].src;
                    }
                    if(rcd.childnum!='0') 
                    {
                        jraftree.addNode({name:'loading...',key:'load',pkey:item.key,tag:'asyncloading'});
                        nNode.expand(false,true);
                    }
                    return nNode;
                },this);
                if(deptid){
                    var pNode=jraftree.treeContext.nodes['n'+deptid];
                    if(pNode.first && pNode.first.tag == 'asyncloading'){
                        pNode.first.remove();
                        if(!pNode.first){
                            pNode.icon.src = pNode.treeContext.imageList.item["hfold_close"].src;
                        }
                    }
                }
            }catch(e){alert('ERROR:'+e);}
                
        });
}
function viewItem(node)
{
        
    if(!node) return;
    var dept = node.tag;
    var nodetype = dept.nodetype;
   if(nodetype == 'childnode')
   { 
     setUserValue(dept);
   }else if(nodetype=='parentnode')
   { 
     setDeptValue(dept);
   }
}
</script>
<script type="text/javascript" defer="defer">
/*同步所有用户*/
function syncUser(thisObj) {
    thisObj.disabled = true;
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:      '<sc:fmt type="crypto" value="UserSync"/>',
        actions:    '<sc:fmt type="crypto" value="syncAllUser"/>'
    };
    var ajax = new Jraf.Ajax();
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
        try{
            thisObj.disabled = false;
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                Jraf.showMessageBox({
                    text: '同步用户信息出错，请联系系统管理员！',
                    type: "error"
                });
                return;
            }
            var rcd = pkg.rspDatas().Record;
            var oprName = rcd.oprName;
            var status = rcd.status;
            var errorMessage = rcd.errorMessage;
            if (status == '0') {
                Jraf.showMessageBox({
                    text: '同步用户信息出错:  '+errorMessage+'',
                    type: "error"
                });
                return;
            }
            Jraf.showMessageBox({
                text: '<span class="success">同步用户信息成功.</span>',
                onClose: function () {
                    //doSearch();//刷新用户列表
                }
            });
            
        }catch(e){alert('[method=syncUser]ERROR:'+e.message);}
        
    });
    
}

</script>
</body>
</html>