<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/common.jsp" %>
</head>
<BODY style="padding: 5px;">    
<sc:form name="query_form" action="/pcmc/pm/query_pcmcinfo_manager.so" method="post" sysName="pcmc" oprID="info" actions="queryPcmcInfoByManager" attributesText="onSubmit='return checkForm(this);'">
<sc:hidden name="ispriv"/>
<table class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0">
    <tr><th colspan="4">公告管理</th></tr>
    <tr>    
    <td class='form-label'>所属系统：</td>
    <td class='form-value' colspan="3">
		<sc:select name="subsys" default="all" type="subsys" key="" >
			<sc:option value="all">--所有子系统--</sc:option>
       	</sc:select></td>
    </tr>
    	<tr>
        <sc:text dsp="td" name="title" dspName="公告标题" req="0"/> 
        
        <sc:text dsp="td" name="username" dspName="发布公告用户" req="0"/> 
    </tr>
   <tr>
        <td class="form-label">
            公告生效时间:
        </td>
        <td class="form-value">
            <sc:datepicker  name="startdt" type="datetime" pattern="%Y-%m-%d %H:%M:%S"/>
        </td>
        <td class="form-label">
            公告终止时间:
        </td>
        <td class="form-value">
            <sc:datepicker name="enddt" type="datetime" pattern="%Y-%m-%d %H:%M:%S"/> 
        </td>
    </tr>
    <tr>
         <td colspan="6" class="form-bottom" align="center">
             <sc:button value="查询" onclick="doSearch();" name="dosubmit"/>
             <sc:button type="reset" value="重写"/>
         </td>
    </tr>
</table>
</sc:form>
<sc:form name="page_form" method="post" action="/pcmc/pm/query_pcmcinfo_manager.so" sysName="pcmc" oprID="info" actions="queryPcmcInfoByManager" attributesText="onSubmit='return checkForm(this);'">
<sc:hidden name="ispriv"/>
<sc:hidden name="subsys"/>  
<sc:hidden name="createtime"/>
<sc:hidden name="enddt" />
<sc:hidden name="startdt" />
<sc:hidden name="title" /> 
<sc:hidden name="username" />  
    <display:table uid="record" name="jrafrpu.rspPkg.rspRcdDataMaps" class="list-table" requestURI="/httpprocesserservlet"
              sort="list">     
              
    <display:column  title="<input type='checkbox' name='allbox' onclick='checkAll(this)'>">
        <input type="checkbox" name="info" onclick="outlineMyRow(this)" value='${record.infoid}'/>
    </display:column>           
    <display:column property="title" title="公告标题 " />
    <display:column title="所属系统 " property="cnname"/>
    <display:column property="createuser" title="发布公告用户" />
    <display:column title="发布时间" >
        <sc:fmt type="date" value="${record.createtime}" pattern="yyyy-MM-dd HH:mm:ss"/>
    </display:column>
    <display:column title="生效时间">
        <sc:fmt type="date" value="${record.startdt}" pattern="yyyy-MM-dd HH:mm:ss"/>
    </display:column>
    <display:column title="终止时间">
        <sc:fmt type="date" value="${record.enddt}" pattern="yyyy-MM-dd HH:mm:ss"/>
    </display:column>
    <display:column  title="操作" style="width:10%">
         <sc:button _class="button-link" value="查看内容" onclick="dosubmitInfoContent(${record.infoid });"/>
    </display:column>
    <display:footer>
       <tr>
           <td colspan="12">
               <c:if test="${empty param.ispriv}">
               <div class="operator" >
                   <input type="button" class="add" value="新增" onclick="toAdd();"/>
                   <input type="button" class="edit" value="修改" onclick="toEdit();"/>
                   <input type="button" class="delete" value="删除" onclick="doDelete();"/>
               </div>
               </c:if>
               <c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMaps}">
                  <%@ include file="/include/pager.jsp" %>
               </c:if>
           </td>
       </tr>
    </display:footer>  
    </display:table>
</sc:form>
</body>
<script language="JavaScript" type="text/javascript">
function doSearch(){
    var formObj = document.forms["query_form"];
    if(!checkForm(formObj)){
        return false;
    }
    formObj.oprID.value='<sc:fmt type="crypto" value="info"/>';
    formObj.actions.value='<sc:fmt type="crypto" value="queryPcmcInfoByManager"/>';
    formObj.elements("dosubmit").disabled=true;
    Jraf.ProgressStart();
    formObj.submit();
}

function dosubmitInfoContent(infoid)
{
    var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>'+
              '&oprID=<sc:fmt type="crypto" value="info"/>'+
              '&actions=<sc:fmt type="crypto" value="getPcmcInfoById"/>'+
              '&forward=<sc:fmt value='/pcmc/pm/show_pcmcinfo.jsp' type='crypto'/>&infoid='+infoid+"&s_time="+(new Date().getTime());
    openModalToIframe(url,{title: "公告信息"}, 660,500);
}
function toAdd()
{
    var url = "/pcmc/pm/add_pcmcinfo.jsp?s_time="+(new Date().getTime());
    var va = openModalToIframe(url, {title: "新增公告信息"}, 800, 600);
    if (va != null) {
        doSearch();
    }
}
//更新
function toEdit()
{
    var obj = $$("input[name='info']");
    var infoid;
    var count = 0;
    for(var i = 0 ; i < obj.length; i ++ ){
        if(obj[i].checked == true){
            count ++;
            infoid  = $$("input[name='info']")[i].value;
        }
    }
    if(count != 1){
        Jraf.showMessageBox({text: "请选择一条数据。",type: "warn"});
    }else{
        var url = '/httpprocesserservlet?sysName=<sc:fmt type="crypto" value="pcmc"/>&oprID=<sc:fmt type="crypto" value="info"/>&actions=<sc:fmt type="crypto" value="getPcmcInfoById"/>&forward=<sc:fmt value='/pcmc/pm/update_pcmcinfo.jsp' type='crypto'/>&infoid='+infoid;
        url = url +"&ts_date=" + new Date();
        var va = openModal(url,800,450);
        if (va != null && va === true) {
            doSearch();
        }
    }
}

//删除
function doDelete()
{
    var obj = $$("input[name='info']");
    var count=0;
    var infos = new Array();
    for(var i=0;i<obj.length;i++){
        if(obj[i].checked == true){
            infos.push(obj[i].value);
            count++;
        }
    }
    if(count<1){
        Jraf.showMessageBox({text: "请选择一条数据", type: "info"});
        return;
    }
    Jraf.showMessageBox({
        text: '是否删除所选数据',
        type: 'choose',
        onYes: function (){
            setTimeout(function(){
                var params = {
                    sysName: '<sc:fmt type="crypto" value="pcmc"/>',
                    oprID: '<sc:fmt type="crypto" value="info"/>',
                    actions: '<sc:fmt type="crypto" value="deletePcmcInfo"/>',
                    info: infos
                };
                
                Jraf.ProgressStart();
                var ajax = new Jraf.Ajax();
                ajax.sendForXml("/xmlprocesserservlet", params, function (xml) {
                    Jraf.ProgressEnd();
                    try {
                        var pkg = new Jraf.Pkg(xml);
                        if (pkg.result() != '0') {
                            Jraf.showMessageBox({
                                text: "删除失败！",
                                type: "error"
                            });
                            return;
                        }
                        Jraf.showMessageBox({
                            text: "删除成功。",
                            type: "success",
                            onOk: function () {
                                setTimeout(goPage, 0);//刷新当前页
                            }
                        });
                    } catch (e) {
                        alert("[method=doDelete]jserror:"+ e.message);
                    }
                });
            }, 0);
        },
        onNo: function(){}
    });
}
</script>
</html>
