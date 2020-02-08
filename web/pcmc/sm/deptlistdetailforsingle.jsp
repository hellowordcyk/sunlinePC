<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.*"%>
<html>
    <head>
        <%@ include file="/common.jsp" %>
    </head>
<body>
    <sc:fieldset name="部门维护">
    <sc:showrsmsg/>
    <table width="100%" height="100%" border="0" align="center" cellpadding="0" cellspacing="5">
        <tr>
            <td style="width:25%; vertical-align:top">
                <div class="page-title" style="margin: 0px;">
                    <span class="title">部门列表</span>
                    <div id="quotalist" style="width:100%;height:450px;overflow:auto"></div>
                </div>
            </td>
            <td style="width:25%;vertical-align:top">
                <sc:form name="deptform" action="DeptUpdate.so" method="post"
                    sysName="pcmc" oprID="sm_maintenance" actions="getDeptDetail">
                        <input type="hidden" name="deptid">
                        <input type="hidden" name="pdeptid">
                        <input type="hidden" name="levelp">
                        <table width="100%" border="0" cellpadding="0" cellspacing="0"
                               class="form-table">
                            <tr><th colspan="4">部门信息</th></tr>
                            <tr>
                                <td class="form-label">部门编号：</td>
                                <td class="form-value"><span id="deptcode"></span></td>
                            </tr>
                            <tr>
                                <td class="form-label">部门名称：</td>
                                <td class="form-value"><span id="deptname"></span></td>
                            </tr>
                            <tr>
                                <td class="form-label">联系人：</td>
                                <td class="form-value"><span id="linkman"></span></td>
                            </tr>
                            <tr>
                                <td class="form-label">联系电话：</td>
                                <td class="form-value"><span id="phone"></span></td>
                            </tr>
                            <tr>
                                <td class="form-label">备注：</td>
                                <td class="form-value">
                                    <span id="remark"></span>
                                </td>
                            </tr>
                        </table>
                </sc:form>
        </td>
        <td style="vertical-align:top" >
            <!-- 部门用户清单 -->
            <div class="page-title" style="margin: 0px;">
                <span class="title">本部门用户</span>
                <div id="userlist" style="width:100%;height:450px;overflow:auto"></div>
            </div>
        </td>
    </tr>
    </table>
    </sc:fieldset>
</body>
<script type="text/javascript">
    var ajax = new Jraf.Ajax();
    var jraftreemenu = new Jraf.Tree({selector:'#quotalist',
        onexpand:function(srcNode){
                srcNode.icon.src=srcNode.treeContext.imageList.item["hfold_open"].src;
                if(srcNode.first && srcNode.first.tag=='asyncloading'){
                    addSubDepts(jraftreemenu, srcNode.tag.deptid);
                }
            }
        });
    addSubDepts(jraftreemenu);
function addSubDepts(jraftree,deptid){
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:         '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getSubDepts"/>',
        recursive: '0'
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
                        tag: rcd
                        };
                    var nNode=jraftree.addNode(item);
                    jraftree.addNode({name:'loading...',key:'load',pkey:item.key,tag:'asyncloading'});
                    nNode.expand(false,true);
                },this);
                if(deptid){
                    var pNode=jraftree.treeContext.nodes['n'+deptid];
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
}
function viewItem(node){
    if(!node) return;
    var dept = node.tag;
    setDeptValue(dept);
    viewDeptUsers(dept.deptid);
}
function viewDeptUsers(deptid){
    //alert(111);
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:      '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getUserList"/>',
        deptid:     deptid,
        PageSize:   -1
    };
    ajax.loadPageTo('/pcmc/sm/userlistviewforsingle.so',reqparams, 'userlist');
}

/***************************************************************/

function setDeptValue(dept)
{
    if(!dept) return;
    $('deptid').value=dept.deptid;
    $('deptcode').update(dept.deptcode);
    $('pdeptid').value=dept.pdeptid;
    $('levelp').value=dept.levelp;
    $('deptname').update(dept.deptname);
    $('linkman').update(dept.linkman);
    $('phone').update(dept.phone);
    $('remark').update(dept.remark);
}
function doAdd()
{
    var deptid = document.getElementById("deptid").value;
    var pdeptid=document.getElementById("pdeptid").value;
    if (""==deptid)
    {
        if (confirm('您未选择任何部门，要新增一个顶级部门吗？'))
        {
            document.location = "/pcmc/sm/DeptAdd.jsp?pdeptid=-1&levelp=1";
        }
        
    }
    else{
        var levelp=$F("levelp");
        if(levelp == 1){
            levelp = 2;
        }
        //var deptname = $("deptname").innerHTML;
        //midify by xuyq 2011-12-9 取缔从前台页面直接跳到另一个页面，以为页面跳转中需要携带中文参数，这样做不可取
        //document.location    =    "DeptAdd.jsp?pdeptid="+deptid+"&levelp=2&deptname="+deptname;
        document.location.href = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_maintenance' type='crypto'/>&actions=<sc:fmt value='getDeptDetail' type='crypto'/>&deptid='+deptid+'&levelp='+levelp+'&forward=<sc:fmt value='/pcmc/sm/DeptAdd.jsp' type='crypto'/>';
        // deptform.submit();
    }
}

function doDelete()
{
    var deptid = document.getElementById("deptid").value;
    if ("" == deptid)
    {
        alert('请选择要删除的部门！');
        return;
    }
    else
        {
            if (confirm("你确定要删除此部门？"))
            {
                //modify by xuyq 2011-12-19 屏蔽老代码如下，新添跳转代码，点击删除直接跳转到href中选中后台处理
                //deptform.actions.value = '<sc:fmt value="deleteDept" type="crypto"/>';
                //deptform.action = 'DeptListDetail.so';
                //deptform.submit();
                document.location.href = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_maintenance' type='crypto'/>&actions=<sc:fmt value='deleteDept' type='crypto'/>&deptid='+deptid+'&forward=<sc:fmt value='/pcmc/sm/DeptListDetail.jsp' type='crypto'/>';
        }
    }
}
function doUpdate()
{
    var deptid = document.getElementById("deptid").value;
    if ("" == deptid)
    {
        alert('请选择要修改的部门！');
        return;
    }
    else
        {
            //modify by  xuyq 2011-12-19 屏蔽之前的本页提交，用页面刷新到指定后台处理
            document.location.href = '/httpprocesserservlet?sysName=<sc:fmt value='pcmc' type='crypto'/>&oprID=<sc:fmt value='sm_maintenance' type='crypto'/>&actions=<sc:fmt value='getDeptDetail' type='crypto'/>&deptid='+deptid+'&forward=<sc:fmt value='/pcmc/sm/DeptUpdate.jsp' type='crypto'/>';
            //deptform.submit();
        }
    }
</script>
</html>