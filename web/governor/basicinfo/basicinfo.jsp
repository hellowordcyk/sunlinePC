<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <%@ include file="/jui_tag.jsp" %>
</head>
<form class="pageForm required-validate" >
	<sc:doPost var="rspPkg" scope="request" sysName="governor" oprId="initConfig" action="getConfigInfo" ></sc:doPost>
    <table align="center" class="form-table" border="0" width="100%"  cellspacing="0" cellpadding="0" style="table-layout: fixed;">
           <c:forEach var="configInfo" items="${rspPkg.rspRcdDataMaps}" varStatus="menuStatus">
           <tr>
             <td class="form-label" style="width: 180px;">应用系统名称：<span style="color:red;">*</span></td>
             <td class="form-value" style="width: 200px;">
                 <input req="1" id="appname"
                        type="text" value="${configInfo.appname }"></input>
            </td>
             <td class="form-label" style="width: 180px;">站点名称：<span style="color:red;">*</span></td>
             <td class="form-value"><input req="1" id="sitename" type="text" value="${configInfo.sitename }"></input></td>
        </tr>
        <tr>
            <td class="form-label">应用系统Logo：<span style="color:red;">*</span></td>
             <td class="form-value" colspan="3">
                 <input id="h_pics" type="hidden" value="${configInfo.bankpic }" />
                 <!-- <div jraf_pageid="itemcdDivId" jraf_params="" 
                      jraf_callback="initselect();" style="width:500px; float:left; padding-bottom:5px;" 
                      jraf_url="/governor/include/governor_items_logo.jsp"></div> -->
                  <div id="itemcdDivId"/>
                  <div style="padding-top:5px;padding-bottom:5px; float:left;">
                      <input type="button" id="upload" name="upload" 
                             class="button-link" value="上传" style="height:22px;" onclick="uploadLogo();" />
                   </div>
              </td>
        </tr>
        <tr>
            <td class="form-label">应用系统Logo预览：</td>
            <td class="form-value" colspan="3">
                <div style="margin-top:7px;margin-bottom:7px;">                        
                    <img id="bank_logo" alt="应用系统logo" src="" />
                </div>
            </td>
        </tr>
        </c:forEach>
        <tr>
            <td colspan='4' align='center' class="form-bottom">
                <input type="button" name="save"  class="button"  value="保存" onclick="saveOK()" />
                  <input type="reset" value="重置"  class="button" />
            </td>
        </tr>
       </table>
</form>
<script type="text/javascript">
//全局变量
var fullpath = "/common/images/banklogo/";
init();
function init() {
	$("#itemcdDivId").ajaxUrl({
		type:"POST", url:"/governor/include/governor_items_logo.jsp", data: "", callback:"initselect"
	});
}

//上传
function uploadLogo(){
    var url = "/governor/basicinfo/uploaddatafile.jsp";
    var winResults = openModalToIframe(url, null, 500, 230, false);
    //var winResults = openModal(url,500,230);
       if(winResults != null){
    	   init();
       }
}

//保存
function saveOK() {
    var appname = document.getElementById("appname").value;
    var sitename = document.getElementById("sitename").value;
    var bankpic = fullpath + document.getElementById("bankpic").value;
    var url = "/xmlprocesserservlet?sysName=<sc:fmt value='governor' type='crypto'/>"
	    + "&oprID=<sc:fmt value='initConfig' type='crypto'/>"
	    + "&actions=<sc:fmt value='configServlet' type='crypto'/>&appname="+appname+"&sitename="+sitename+"&bankpic="+bankpic;
   	$.ajax({
   		type:'POST',
   		url: url,
   		dataType:'xml',
   		error: DWZ.ajaxError,
   		async:false,
   		success:function(data){
   			var msg = $(data).find('DataPacket Response Data msg').text();
   			if(msg!='0'){
                alert("保存失败！");
            }else{
                alert("保存成功！");
            }
   		}
   	});
      /*  var param = {
           sysName:    '<sc:fmt type="crypto" value="governor"/>',
           oprID:      '<sc:fmt type="crypto" value="initConfig"/>',
           actions:    '<sc:fmt type="crypto" value="configServlet"/>',
           appname:     appname,
           sitename:     sitename,
           bankpic:     fullpath + bankpic
       }
       var ajax = new Jraf.Ajax();
       ajax.sendForXml('/xmlprocesserservlet', param, function(xml){
           try{
               try{
                   var pkg = new Jraf.Pkg(xml);
                   if(pkg.result() != '0'){
                       Jraf.showMessageBox({title: "保存异常", text: "<span class='error'>" + '异常：' + pkg.allMsgs('<br>') + "</span>"});
                       return;
                   }
                   var msg = pkg.rspData("Record/msg");
                   if(msg!='0'){
                       alert("保存失败！");
                   }else{
                       alert("保存成功！");
                   }
               }catch(e){
                   Jraf.showMessageBox({title: "保存异常", text: "<span class='error'>" + e + "</span>"});
               }
           }catch(e){
               Jraf.showMessageBox({title: "保存异常", text: "<span class='error'>" + e + "</span>"});
           }
       }); */
}

function initselect() {
    var h_pics = document.getElementById("h_pics").value;
    var options = $('bankpic').options;
    for(var i=0;i<options.length;i++){
        if(fullpath+options[i].value==h_pics){
            options[i].selected=true;
        }
    }
    logoganged();
}

//下拉框联动图片预览
function logoganged() {
    var bankpic = document.getElementById("bankpic").value;
    document.getElementById("bank_logo").src = fullpath + bankpic;
}

</script>
</html>