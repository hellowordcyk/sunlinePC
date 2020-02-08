<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp" %>
<%
  response.setHeader("Cache-Control","no-cache");
  response.setHeader("Pragma","no-cache");
  response.setDateHeader ("Expires", 0);
/**
 * parameters:
 *   receivedeptid: 原来选中的部门id列表，以","分隔
*/ 
%>
<c:set var="myparams" value=""/>
<c:forTokens items="${param.receivedeptid}" delims="," var="deptid">
<c:set var="myparams" value="${myparams}&deptid=${deptid}"/>
</c:forTokens>
<sc:doPost var="seldepts" sysName="pcmc" oprId="sm_query" action="getDepts" all="false" params="${myparams}"/>
<html>
<head>
    <title>选择机构</title>
</head>
<body>
<form name="form1">
    <input type="hidden" name="itemnm"> 
    <input type="hidden"name="lastdeptid" value=""> 
    <input type="hidden"name="lastdeptname" value="">
        <table border=0 align="center" cellpadding="0" cellspacing="5"
            width="100%" height="100%">
            <tr>
                <td width="45%" valign="top">
                    <div class="page-title">
                        <span class="title">待选机构</span>
                        <div id="quotalist" style="width:100%;height:360px;overflow:auto"></div>
                    </div>
                </td>
                <td width="10%" valign="middle">
                    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="center">
                            <input type="button" class="btn_mail" value="选择-->" onclick="selone('<c:out value="${param.multi}"/>')">
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="center">
                            <input type="button" class="btn_mail" value="<--删除" onclick="unselone()">
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="center">
                            <input type="button" class="btn_mail" value="<<-全删" onclick="unselall()">
                        </td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td>&nbsp;</td>
                    </tr>
                    <tr>
                        <td align="center">
                            <input type="button" class="button" value=" 确定 " onclick="btnsure()"></td>
                    </tr>
                </table>
                </td>
                <td width="45%" valign="top">
                    <table border=0 cellpadding=0 cellspacing=0 width="100%" class="form-table">
                    <tr>
                        <th colspan="1">已选机构</th>
                    </tr>
                    <tr>
                        <td style="width:100%; height: 360px; padding: 0px;">
                            <select size="20" multiple name="selectedDept"
                                class="inputselect" style="width: 100%; height: 100%; border: 0; margin: 0; padding: 5px 3px;">
                                <c:forEach var="rcd" items="${seldepts.rspRcdDataMaps}">
                                <option value="<c:out value="${rcd.deptid}"/>"
                                    deptname="<c:out value="${rcd.deptname}"/>"
                                    deptcode="<c:out value="${rcd.deptcode}"/>"
                                >[<c:out value="${rcd.deptcode}"/>]<c:out value="${rcd.deptname}"/></option>
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
    var ajax = new Jraf.Ajax();
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
    ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
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
                    var nexeCategory='';//"js";
                    var nexeArg='';//'viewItem("'+nKey+'")';//"expand()";
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
<script language="JavaScript">
function btnsure(){
    var pobj = $$("select[name=selectedDept]")[0];
    var deptids = "";
    var usernas = "";
    var arr = [];
    for (var i=0;i<pobj.length;i++){
        var optObj = pobj.options[i];
        arr.push ({
            deptid:      optObj.value,
            deptname:    optObj.deptname || optObj.readAttribute("deptname"),
            deptcode:    optObj.deptcode || optObj.readAttribute("deptcode")
        });
    }
    window.returnValue=arr;
    window.close();
}

//添加
function selone(multi){
    var eNode = tree.getSelectedNode();
    if(!eNode) return;
    var dept = eNode.tag;
    var pobj = $$("select[name=selectedDept]")[0];
    if(multi == '0'){
        pobj.update();
    }
    if (CheckExists(pobj,dept.deptid,dept.deptname)==false){
        AddOneTo(pobj,dept);
    }    

}

function unselone(){
    var pobj = $$("select[name=selectedDept]")[0];;
     for(var i=pobj.length-1;i>=0;i--){
          if(pobj.options[i].selected){
            pobj.remove(i);
          }
     }
}

function unselall(){
    var pobj = $$("select[name=selectedDept]")[0];;
     for(var i=pobj.length-1;i>=0;i--){
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
function AddOneTo(obj,dept){ //增加一项
     var opt=new Option();
     opt.value=dept.deptid;
     opt['deptname']= dept.deptname;
     opt['deptcode']= dept.deptcode;
     opt.text='['+dept.deptcode + ']'+ dept.deptname;
     obj.options.add(opt,obj.length);
}


function expand()
{
    var eNode = tree.getSelectedNode();
    eNode.expand(true);
        //viewItem();
}

</script>
</html>
