<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp"%>
<%
  response.setHeader("Cache-Control","no-cache");
  response.setHeader("Pragma","no-cache");
  response.setDateHeader ("Expires", 0);
/**
 * parameters:
 *   receiveuser: 接收的用户名称，以","分隔
 *   receiveuserid: 原来选中的用户id列表，以","分隔
*/ 
%>
<c:set var="myparams" value=""/>
<c:forTokens items="${param.receiveuserid}" delims="," var="userid">
    <c:set var="myparams" value="${myparams}&userid=${userid}"/>
</c:forTokens>
<sc:doPost var="selusers" sysName="pcmc" oprId="sm_query" action="getUsers" 
           all="false" params="${myparams}"/>
<html>
<head>
</head>
<body >
<form name="form1">
    <input type="hidden" name="itemnm"/> 
    <input type="hidden" name="lastdeptid" value=""/> 
    <input type="hidden" name="lastdeptname" value=""/>
    <table border="0" align="center" cellpadding="4" cellspacing="3" width="100%" height="100%" style="table-layout: fixed;">
        <tr>
            <td width="35%" valign="top">
            <table border=0 cellpadding=0 cellspacing=0 class="form-table" width="100%" style="table-layout: fixed;">
                <tr>
                    <th>人员部门</th>
                </tr>
                <tr>
                    <td width="100%">
                        <div id="quotalist" style="width:100%;height:360px;overflow:auto"></div>
                    </td>
                </tr>
            </table>
            </td>
            <td valign="top">
            <table border=0 cellpadding=0 cellspacing=0 width="100%" height="100%" class="form-table">
                <tr>
                    <th>待选人员</th>
                </tr>
                <tr>
                    <td id="quota" style="width:100%; height: 360px; padding: 0px;">
                        <select id="quotadetail" size="20"
                                class="inputselect" multiple="multiple"
                                style="width: 100%; height: 100%; border: 0; margin: 0; padding: 5px 3px;">
                        </select>
                    </td>
                </tr>
            </table>
            </td>
            <td width="13%" valign="middle">
            <table width="100%" border="0" cellpadding="2" cellspacing="0">
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <c:if test="${param.multi=='1' || empty param.multi}">
                <tr>
                    <td align="center"><input type="button" class="btn_mail"
                        value="选择-->" onclick="selone()"></td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td align="center"><input type="button" class="btn_mail"
                        value="全选->>" onclick="selall()"></td>
                </tr>
                </c:if>
                <c:if test="${param.multi=='0'}">
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td align="center"><input type="button" class="btn_mail"
                        value="选择-->" onclick="selone_only()"></td>
                </tr>
                </c:if>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td align="center"><input type="button" class="btn_mail"
                        value="<--删除" onclick="unselone()"></td>
                </tr>
                <c:if test="${param.multi=='1' || empty param.multi}">
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td align="center"><input type="button" class="btn_mail"
                        value="<<-全删" onclick="unselall()"></td>
                </tr>
                </c:if>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td align="center"><input type="button" class="button"
                        value=" 确定 " onclick="btnsure()"></td>
                </tr>
            </table>
            </td>
            <td valign="top">
            <table border=0 cellpadding=0 cellspacing=0 width="100%" class="form-table">
                <tr>
                    <th>已选人员</th>
                </tr>
                <tr>
                    <td style="width:100%; height: 360px; padding: 0px;">
                        <select width="100%"  size="20" multiple="multiple" name="selectedPerson"
                            class="inputselect" style="width: 100%; height: 100%; border: 0; margin: 0; padding: 5px 3px;" >
                        <c:forEach var="rcd" items="${selusers.rspRcdDataMaps}">
                        <option value="<c:out value="${rcd.userid}"/>"
                        username="<c:out value="${rcd.username}"/>"
                        usercode="<c:out value="${rcd.usercode}"/>"
                        >[<c:out value="${rcd.usercode}"/>]<c:out value="${rcd.username}"/></option>
                        </c:forEach>
                    </select>
                    </td>
                </tr>
            </table>
            </td>
        </tr>
    </table>
</form>
<script language="JavaScript">
    var g_ajax = new Jraf.Ajax();
    var oTree = new Jraf.Tree({
        selector:  '#quotalist'
    });
    /*var icons=new alai_imagelist()
    icons.path="/common/images/tree/"
    icons.add("hfile.gif","default")
    icons.add("plus.gif","expand")
    icons.add("minus.gif","collapse")
    icons.add("folderopen.gif","hfold_open")
    icons.add("folder.gif","hfold_close")*/
    //var tree=new alai_tree(icons,18,quotalist)
    var tree=oTree.treeContext;
    icons = oTree.options.imagelist;
    addSubDepts(tree.root);
    tree.afteradd=function(srcNode)
    {
        if(srcNode.parent!=tree.root)srcNode.parent.icon.src=icons.item["hfold_open"].src
    }
    tree.oncollapse=function(srcNode)
    {
        srcNode.icon.src=icons.item["hfold_close"].src
    }
    tree.onexpand=function(srcNode)
    {
        srcNode.icon.src=icons.item["hfold_open"].src
        try
        {
            if(srcNode.first && srcNode.first.label.innerText=="loading...")
            {
                //addSubDepts(srcNode,srcNode.getKey());
                try
                {
                    if(typeof(srcNode.first)=="undefined")
                    {
                        srcNode.expand(false);
                        srcNode.icon.src=icons.item["default"].src
                    }
                }
                catch(e){alert(e.message);}
            }
       
        }catch(e){}
    }
function addSubDepts(oTreeNode,deptid){
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:         '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getSubDepts"/>',
        recursive: '1'
        };
    if(deptid){
        Object.extend(reqparams,{deptid:deptid});
    }
    //Jraf.ProgressStart(null, document.forms("form1"));
    g_ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
            try{
               var pkg = new Jraf.Pkg(xml);
                if(pkg.result() != '0'){
                    alert(pkg.allMsgs());
                    return;
                }
                var rcds = pkg.rspDatas().Record;
                if(!rcds) rcds=[];
                if(!Object.isArray(rcds)) rcds = [rcds];
                rcds.each(function(rcd){
                    var nText = rcd.deptname;
                    var nKey = 'n'+rcd.deptid;
                    var nIcon = "";
                    var nexeCategory="js";
                    var nexeArg='viewItem("'+rcd.deptid+'")';//"expand()";
                    var pNode=tree.nodes['n'+rcd.pdeptid]||oTreeNode;
                    var nNode=tree.add(pNode,"last",nText,nKey,nIcon,nexeCategory,nexeArg);
                    nNode.tag=rcd;
                    //nNode.add("loading...");

                },this);
                tree.root.children.each(function(e){
                        e.expand(false,true);
                    });
            }catch(e){alert('ERROR:'+e.message);}
            //Jraf.ProgressEnd();
        });
}
</script>
</body>
<script type="text/javascript">
document.observe("dom:loaded", function () {
    viewItem('<c:out value="${jraf_auth.user.deptMent}"/>'); 
});

function btnsure(){
    var pobj = $$("select[name=selectedPerson]")[0];
    var userids = "";
    var usernas = "";
    var arr = [];
    for (var i=0;i<pobj.length;i++){
        arr.push ({
            userid:      pobj.options[i].value,
            username:    pobj.options[i].username || pobj.options[i].readAttribute("username"),
            usercode:    pobj.options[i].usercode || pobj.options[i].readAttribute("usercode")
        });
    }
    window.returnValue=arr;
    window.close();
}

//添加多个,多选
function selone(){
    var obj = $("quotadetail");
    var pobj = $$("select[name=selectedPerson]")[0];
    for(var i=obj.length-1; i>=0; i--){
        if(obj.options[i].selected){
            var val = obj.options[i].value;
            var txt = obj.options[i].text;
            var user = {
                userid:obj.options[i].value,
                usercode:obj.options[i].usercode,
                username:obj.options[i].username
            };
            if (CheckExists(pobj,val,txt)==false){
                AddOneTo(pobj, user);
                obj.remove(i);
            }
        }
    }
}
//单选
function selone_only(){
    //unselall();
    var obj = $("quotadetail");
    var pobj = $$("select[name=selectedPerson]")[0];
    pobj.update();
    for(var i=obj.length-1; i>=0; i--){
        if(obj.options[i].selected){
            var val = obj.options[i].value;
            var txt = obj.options[i].text;
            var user = {
                userid:obj.options[i].value,
                usercode:obj.options[i].usercode,
                username:obj.options[i].username
            };
            if (CheckExists(pobj,val,txt)==false){
                AddOneTo(pobj, user);
                obj.remove(i);
                return;
            }
        }
    }
}

function selall(){
    var obj = $("quotadetail");
    var pobj = $$("select[name=selectedPerson]")[0];
    for(var i=obj.length-1; i>=0; i--){
        var val = obj.options[i].value;
        var txt = obj.options[i].text;
        var user = {
            userid: obj.options[i].value,
            usercode: obj.options[i].usercode,
            username: obj.options[i].username
        };
        if (CheckExists(pobj,val,txt)==false){
            AddOneTo(pobj, user);
            obj.remove(i);
        }
    }
}

function unselone(){
    var obj = $("quotadetail");
    var pobj = $$("select[name=selectedPerson]")[0];
    for(var i=pobj.length-1;i>=0;i--){
        if(pobj.options[i].selected){
            if (CheckExists(obj, pobj.options[i].value, pobj.options[i].text)==false){
                var user = {
                    userid: pobj.options[i].value,
                    usercode: pobj.options[i].usercode,
                    username: pobj.options[i].username
                };
                AddOneTo(obj, user);
            }
            pobj.remove(i);
        }
    }
}

function unselall(){
    var obj = $("quotadetail");
    var pobj = $$("select[name=selectedPerson]")[0];
    for(var i=pobj.length-1;i>=0;i--){
        if (CheckExists(obj, pobj.options[i].value, pobj.options[i].text)==false){
            var user = {
                userid: pobj.options[i].value,
                usercode: pobj.options[i].usercode,
                username: pobj.options[i].username
            };
            AddOneTo(obj, user);
        }
        pobj.remove(i);
    }
}

function CheckExists(obj,val,txt){//检查项是否已存在
    for(var i=0;i<obj.length;i++){
        if(obj.options[i].value==val){
            return true;
        }
    }
    return false;
}
function AddOneTo(obj, user){ //增加一项
    var opt=new Option();
    opt.value=user.userid;
    opt['username']= user.username;
    opt['usercode']= user.usercode;
    opt.text='['+user.usercode + ']'+ user.username;
    obj.options.add(opt,obj.length);
}


function expand()
{
    var eNode = tree.getSelectedNode();
    eNode.expand(true);
    //viewItem();
}

function viewItem(deptid)
{
    var selEL = $('quotadetail').update();
    var reqparams = {
        sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
        oprID:         '<sc:fmt type="crypto" value="sm_query"/>',
        actions:    '<sc:fmt type="crypto" value="getUsers"/>',
        deptid:        deptid
    };
    g_ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
        try{
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                alert(pkg.allMsgs());
                return;
            }
            var rcds = pkg.rspDatas().Record;
            if(!rcds) return;
            if(!Object.isArray(rcds)) rcds = [rcds];
            var pobj = $$("select[name=selectedPerson]")[0];
            $A(rcds).each(function(rcd){
                if (CheckExists(pobj, rcd.userid, rcd.username)==false){
                    var opt=new Option();
                    opt.value=rcd.userid;
                    opt['username']= rcd.username;
                    opt['usercode']= rcd.usercode;
                    opt.text='['+rcd.usercode + ']'+ rcd.username;
                    selEL.options.add(opt,selEL.length);
                }
            },this);
        }catch(e){alert('ERROR:'+e);}
    });
}

</script>
</html>