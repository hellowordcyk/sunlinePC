<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/common.jsp" %>
</head>
<body>
<div id="div">
<sc:form name="query_form" action="/pcmc/sm/query_pcmcdept_subdeptproc.so" method="post" sysName="pcmc" oprID="sm_query" actions="getSubDeptInfo" attributesText="onSubmit='return checkForm(this);'">
    <sc:hidden name="deptid" value='${param.deptid}'/>
    <sc:hidden name="levelp" value='${param.levelp}'/>
    <table class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0">
        <tr><th colspan="4">查询条件</th></tr>
        <tr>
            <sc:text dsp="td" name="deptcode" dspName="机构编号" req="0"/>
            <sc:text dsp="td" name="deptname" dspName="机构名称"/>
        </tr>
        <tr>
             <td colspan="4" class="form-bottom" align="center">
                 <sc:button value="查询" onclick="doSearch();" name="dosubmit"/>
             </td>
        </tr>
    </table>
</sc:form>
<div class="page-title" style="margin:0px;">
    <span id="pageTitleId" class="title">查询结果</span>
    <sc:form name="page_form" method="post" action="/pcmc/sm/query_pcmcdept_subdeptproc.so" sysName="pcmc" oprID="sm_query" actions="getSubDeptInfo" attributesText="onSubmit='return checkForm(this);'">
        <sc:hidden name="deptid" value='${param.deptid}'/>
        <display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet" sort="list">
            <display:column  title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
                   <input type="checkbox" name="mydeptid" onclick="outlineMyRow(this)" value='${record.deptid }'/>
            </display:column>
            <display:column property="deptcode" title="机构编号"  />
            <display:column property="deptname" title="机构名称"  />
            <display:column property="phone" title="联系电话" />
            
            <display:footer>
               <tr>
                   <td colspan="6">
                       <div class="operator" >
                           <input type="button" id="addBtnId" _jraf_sys_usersync class="add" value="新增" onclick="toAdd();"/>
                           <input type="button" id="editBtnId" class="edit" value="修改" onclick="doUpdate();"/>
                           <input type="button" id="deleteBtnId" _jraf_sys_usersync class="delete" value="删除" onclick="doDelete();"/>
                       </div>
                       <%@ include file="/include/pager.jsp" %>
                   </td>
               </tr>
            </display:footer>
        </display:table>
    </sc:form>
</div>
</div>
<script type="text/javascript" defer="defer">
        //setHightLight();
        setHeightAuto();
        function doSearch()
        {
            var formObj = document.forms["query_form"];
            if(!checkForm(formObj))
            {
                return false;
            } 
            formObj.oprID.value='<sc:fmt type="crypto" value="sm_query"/>';
            formObj.actions.value='<sc:fmt type="crypto" value="getSubDeptInfo"/>';
            formObj.elements("dosubmit").disabled=true;
            formObj.submit();
            formObj.elements("dosubmit").disabled=false;
        }
        
        function toAdd()
        {    
                var mypdeptid=document.getElementsByName("deptid")[0].value;
                if(mypdeptid == ''){
                  alert("请添加机构节点");
                  return;
                }
                var url = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_maintenance' type='crypto'/>&actions=<sc:fmt value='getDeptDetail' type='crypto'/>&deptid=';
                    url += mypdeptid+'&forward=<sc:fmt value='/pcmc/sm/OrgDeptAdd.jsp' type='crypto'/>&dt='+new Date().getTime();
                var winResults = openModal(url,800,500);
                if(winResults == null){
                    return;
                }else{
                    var deptname = winResults["deptname"];
                    var deptcode = winResults["deptcode"];
                    var pdeptid  = winResults["pdeptid"];
                    var deptid   = winResults["deptid"];
                    var item = {
                                    name:            deptname+'['+deptcode+']',
                                    key:            'n'+deptid,
                                    pkey:            'n'+pdeptid,
                                    onClick:        parent.viewItem,
                                    onRightClick:     parent.addRightMenu,
                                    tag: {deptcode:deptcode,deptname:deptname,deptid:deptid,pdeptid:pdeptid,nodetype:"parentnode"}
                             };
                                    var nNode=parent.jraftreemenu.addNode(item);
                                    nNode.parent.expand(true);
                                    nNode.icon.src=parent.jraftreemenu.treeContext.imageList.item["hfold_close"].src;
                                    var pNode = window.parent.jraftreemenu.treeContext.nodes[nNode.pdeptid];
                    
                                     if (pNode && pNode.first && pNode.first.tag == 'asyncloading') {
                                            pNode.first.remove();        //消除是否含子结点的标志行
                                            if(!pNode.first){
                                                pNode.icon.src = pNode.treeContext.imageList.item["hfold_close"].src;
                                            }
                                    }
                                    doSearch();
                                   
                }
                
    }
        
        
        function doDelete()
        {    var ajax = new Jraf.Ajax();
             var mydeptid=document.getElementsByName("mydeptid");
             var meptid=new Array();
              var count = 0;
            for(var i=0;i<mydeptid.length;i++)
            {
             if(mydeptid[i].checked)
             {
               meptid[meptid.length]=mydeptid[i].value;
             }
            }
            if(meptid.length==0){
             Jraf.showMessageBox({
                    text: '<span class="info">请选择要删除的部门,注意删除部门后,该部门下的用户也被删除！\n' + '</span>'
                });
                return;
            }
                    if (confirm("你确定要删除此部门？"))
                    {  
                       var strptid='';
                       for(var i=0;i<meptid.length ;i++){
                          strptid+=meptid[i]+",";
                       }
                         strptid= strptid.substring(0,strptid.length-1);
                         var reqparams = {
                                        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
                                        oprID:         '<sc:fmt type="crypto" value="sm_maintenance"/>',
                                        actions:    '<sc:fmt type="crypto" value="deleteDeptandUser"/>',
                                        deptid:        strptid
                                        };
                            ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
                                    try{
                                    var pkg = new Jraf.Pkg(xml);
                                       if(pkg.result()!= '0'){
                                        Jraf.showMessageBox({
                                            text: '<span class="error">删除出错！\n'+pkg.allMsgs() + '</span>'
                                        });
                                        return;
                                    }
                                     Jraf.showMessageBox({
                                        text: '<span class="success">删除成功！</span>'
                                    });
                                    
                                    /*删除节点*/
                                     for(var i=0;i<meptid.length;i++){
                                           var key = 'n'+meptid[i];
                                         var node = window.parent.jraftreemenu.treeContext.nodes[key];
                                         node.remove();
                                    }
                                     doSearch();
                                      window.parent.refresh();
                                    }catch(e)
                                    {
                                        alert('ERROR:'+e);
                                    }
                            });                         
                    }
                
        }
    function doUpdate()
{
            var mydeptid = document.getElementsByName("mydeptid");
            var levelp   = document.getElementsByName("levelp")[0].value;
            var count = 0;
            var obj = $$("input[name='mydeptid']");
            for(var i = 0 ; i < obj.length; i ++ )
            {
                if(obj[i].checked == true)
                {
                    count ++;
                }
            }
            var meptid=new Array();
            
            for(var i=0;i<mydeptid.length;i++)
            {
             if(mydeptid[i].checked)
             {
               meptid[meptid.length]=mydeptid[i].value;
             }
            }
            if(count != 1)
            {
                alert('请选择一个要修改的部门！');
                return;
            }
            else 
                {
                    var url = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_maintenance' type='crypto'/>&actions=<sc:fmt value='getDeptDetail' type='crypto'/>&deptid='+meptid[0]+'&levelp='+levelp+'&forward=<sc:fmt value='/pcmc/sm/OrgDeptUpdate.jsp' type='crypto'/>'+'&dt='+new Date();
                    var winResults = openModal(url,800,500);
                    if (winResults != null) 
                    {   
                        doSearch();
                        var deptcode = winResults["deptcode"];
                        var deptname = winResults["deptname"];
                        var deptid     = winResults["deptid"];
                        var pdeptid     = winResults["pdeptid"];
                        var key = 'n'+deptid;
                        var node= window.parent.jraftreemenu.treeContext.nodes[key];
                        if(!node) return;
                        node.label.innerHTML=deptname+'['+deptcode+']';
                        Object.extend(node.tag,{deptid:deptid,deptcode:deptcode,deptname:deptname});
                        
                         
                   }
                }
 }
</script>
<script language="JavaScript">
function setHightLight(){
    if(window.parent.jraftreemenu.treeContext.getSelectedNode() == null){ 
       //     alert("请先选择左侧树节点");
    }else{
        window.parent.jraftreemenu.treeContext.getSelectedNode().label.style.background="highlight";
        window.parent.jraftreemenu.treeContext.getSelectedNode().label.style.color="highlighttext";
    }
}
function setHeightAuto() {
    parent.$("sub_dept").setStyle({height: ($("div").getHeight()) + "px"});
    //parent.$("sub_dept").setStyle({width: ($("div").getWidth()) + "px"});
}
</script>
<%@include file="/common_priv_usersync.jsp" %>
</body>
</html>