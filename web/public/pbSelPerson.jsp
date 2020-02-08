<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<%
    request.setCharacterEncoding("UTF-8");
    String multi = request.getParameter("multi");
    String receiveuser = request.getParameter("receiveuser");
	receiveuser=new String(receiveuser.getBytes("ISO-8859-1"));
    String[] ary1 = receiveuser.split(",");
    String receiveuserid = request.getParameter("receiveuserid");
    String[] ary2 = receiveuserid.split(",");
    String s_deptid = (String)session.getAttribute("deptid");
    String deptid = "";
    String lab = "选择人员";
    String sysName = Crypto.encode(request,"pcmc");
    String oprID = Crypto.encode(request,"pub");
    String actions = Crypto.encode(request,"getDeptTree");
    String forward = Crypto.encode(request,"/public/pbTreeView.jsp");
    StringBuffer urlBuf = new StringBuffer();
    urlBuf.append("/httpprocesserservlet?sysName=").append(sysName)
        .append("&oprID=").append(oprID)
        .append("&actions=").append(actions)
        .append("&forward=").append(forward);
    StringBuffer urlDetail = new StringBuffer();
    urlDetail.append("/httpprocesserservlet?sysName=").append(Crypto.encode(request,"pcmc"))
        .append("&oprID=").append(Crypto.encode(request,"pub"))
        .append("&actions=").append(Crypto.encode(request,"getPersonByDept"))
        .append("&forward=").append(Crypto.encode(request,"/public/pbPersonList.jsp"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <%@ include file="/common.jsp" %>
    <title><%=lab%></title>
</head>
<body >
<form name="form1">
    <input type="hidden" name="itemnm">
    <input type="hidden" name="lab" value="<%=lab%>">
    <input type="hidden" name="deptid" value="<%=deptid%>">
    <input type="hidden" name="s_deptid" value="<%=s_deptid%>">
    <input type="hidden" name="lastdeptid" value="">
    <input type="hidden" name="lastdeptname" value="">
    <table border="0" align="center" cellpadding="0" cellspacing="5" width="100%" height="100%">
        <tr>
            <td valign="top">
                <div class="page-title">
                    <span class="title"><%=lab %></span>
                    <div id="quotalist" style="width: 100%; height: 400px; padding: 0px;"></div>
                    <script language="javascript">
                    var oTree = new Jraf.Tree({
                        selector:  '#quotalist'
                    });
                    var tree=oTree.treeContext;
                                icons = oTree.options.imagelist;
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
                        try
                        {
                            if(srcNode.first.label.innerText=="loading...")
                            {
                                //动态加载子节点的代码：
                                //srcNode.first.remove();
                                ifrLoad.location='<%=urlBuf.toString()%>&deptid='+srcNode.getKey().replace("n","");
                                try
                                {
                                    if(typeof(srcNode.first)=="undefined")
                                    {
                                        srcNode.expand(false);
                                    }
                                }
                                catch(e){}
                            }
                            srcNode.icon.src=icons.item["hfold_open"].src
                        }catch(e){}
                    }
                </script>
                </div>
                <iframe id="ifrLoad" frameborder="0" marginheight="0" marginwidth="0" 
                    style="width:0;height:0" src='<%=urlBuf.toString()%>&deptid=<%=deptid%>&rootid=1'></iframe>
            </td>
            <td width="28%" valign="top">
                <div class="page-title">
                   <span class="title">待选人员</span>
                   <iframe id="quotadetail" frameborder="0" marginheight="0" marginwidth="0" 
                        style="width: 100%; height: 400px; padding: 0px; overflow:auto" scrolling="no"></iframe>
                </div>
            </td>
            <td width="10%" valign="middle">
                <table width="100%" border="0" cellpadding="0" cellspacing="0" >
                    <tr><td>&nbsp;</td></tr>
                    <tr><td>&nbsp;</td></tr>
                    <%if (multi == null || multi.equals("1")){%>
                    <tr><td align="center"><input type="button" class="btn_mail" value="选择-->" onclick="selone()"></td></tr>
                    <tr><td align="center"><input type="button" class="btn_mail" value="全选->>" onclick="selall()"></td></tr>
                    <%}else{%>
                    <tr><td align="center"><input type="button" class="btn_mail" value="选择-->" onclick="selone_only()"></td></tr>
                    <%}%>
                    <tr><td>&nbsp;</td></tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr><td align="center"><input type="button" class="btn_mail" value="<--删除" onclick="unselone()"></td></tr>
                    <%if (multi == null || multi.equals("1")){%>
                    <tr><td align="center"><input type="button" class="btn_mail" value="<<-全删" onclick="unselall()"></td></tr>
                    <%}%>
                    <tr><td>&nbsp;</td></tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr><td>&nbsp;</td></tr>
                    <tr><td align="center"><input type="button" class="btn_mail" value=" 确定 " onclick="btnsure()"></td></tr>
                </table>
            </td>
            <td width="28%" valign="top">
                 <div class="page-title" >
                    <span class="title">已选人员</span>
                    <select size="20" multiple name="selectedPerson" style="width: 100%; height: 400px;">
                        <option value="-1">-----------------</option>
                      <%if (receiveuser!=null && !receiveuser.equals("")){
                          for (int i=0;i<ary1.length;i++){
                              String str1 = ary1[i];
                              String str2 = ary2[i];
                          %>
                        <option value="<%=str2%>"><%=str1 %></option>
                      <%}}%>
                    </select>
                 </div>
            </td>
        </tr>
    </table>
</form>
</body>
<script language="JavaScript">
function btnsure(){
    var pobj = form1.selectedPerson;
    var userids = "";
    var usernas = "";
    for (var i=1;i<pobj.length;i++){
        userids = userids + "," + pobj.options[i].value;
        usernas = usernas + "," + pobj.options[i].text;
    }
    userids = userids.substring(1,2000);
    usernas = usernas.substring(1,2000);
    var arr = new Array(userids,usernas,form1.lastdeptid.value,form1.lastdeptname.value);
    reValue(arr);
}

function selone(){
   // var obj = document.frames["quotadetail"].document.all("frmList").listPerson;
    var obj = $$("select[name='listPerson']")[0];
    var pobj = form1.selectedPerson;
    var val = "";
    var txt = "";
     for(var i=obj.length-1;i>0;i--){
          if(obj.options[i].selected){
            val = obj.options[i].value;
            txt = obj.options[i].text;
               if (CheckExists(pobj,val,txt)==false){
                AddOnTo(pobj,val,txt);
               }
          }
     }
}

function selone_only(){
    unselall();
    var obj = document.frames["quotadetail"].document.all("frmList").listPerson;
    var pobj = form1.selectedPerson;
    var val = "";
    var txt = "";
     for(var i=obj.length-1;i>0;i--){
          if(obj.options[i].selected){
            val = obj.options[i].value;
            txt = obj.options[i].text;
               if (CheckExists(pobj,val,txt)==false){
                AddOnTo(pobj,val,txt);
               }
            break;
          }
     }
}

function selall(){
    var obj = document.frames["quotadetail"].document.all("frmList").listPerson;
    var pobj = form1.selectedPerson;
    var val = "";
    var txt = "";
     for(var i=0;i<obj.length-1;i++){
        val = obj.options[i].value;
        txt = obj.options[i].text;
        if (CheckExists(pobj,val,txt)==false){
            AddOnTo(pobj,val,txt);
           }
     }
}

function unselone(){
    var pobj = form1.selectedPerson;
     for(var i=pobj.length-1;i>0;i--){
          if(pobj.options[i].selected){
            pobj.remove(i);
          }
     }
}

function unselall(){
    var pobj = form1.selectedPerson;
     for(var i=pobj.length-1;i>0;i--){
        pobj.remove(i);
     }
}

function CheckExists(obj,val,txt){//检查项是否已存在
    if(obj.length<0) return false;
    for(var i=0;i<obj.length;i++){
        if(obj.options[i].value==val && obj.options[i].text==txt) {
            return true;
        }
    }
     return false;
}

function AddOnTo(obj,val,txt){ //增加一项
     var opt=new Option();
     opt.value=val;
     opt.text=txt;
     obj.options.add(opt,obj.length);
}

function expand()
{
    var eNode = tree.getSelectedNode();
    eNode.expand(true);
    viewItem();
}

function viewItem()
{
    var eNode = tree.getSelectedNode();
    var key = eNode.getKey().replace("n","");
    var lab = eNode.label.innerHTML;
    var deptid = key;
    form1.lastdeptid.value = deptid;
    form1.lastdeptname.value = lab;
    quotadetail.location='<%=urlDetail.toString()%>&deptid='+deptid;
}

function viewdata()
{
    var lab = form1.lab.value;
    var deptid = form1.s_deptid.value;
    quotadetail.location='<%=urlDetail.toString()%>&deptid='+deptid;
}

viewdata();

</script>
</html>
