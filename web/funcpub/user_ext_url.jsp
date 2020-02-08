<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<table class="form-table" cellpadding="0" cellspacing="0" >
    <tr>
        <td class="form-label">是否高管</td>
        <td >
            <sc:dradio name="attr01" type="dict" key="pcmc,boolflag" index="1"  default="0"></sc:dradio>
        </td>
    </tr>
    <tr>
        <td class="form-label">分管领导</td>
        <td class="form-value">
            <sc:hidden name="attr02" index="1"/>
         <sc:text name="leaderName"  index="1"/>
         <a class="btnLook" title="选择分管领导" lookupGroup=""  width="900" height="500"
          href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupid=attr02&lookupname=leaderName"></a>
        </td>
    </tr>
    <tr>
        <td class="form-label">经理</td>
        <td class="form-value">
            <sc:hidden name="attr03" index="1"/>
	         <sc:text name="managerName"   index="1"/>
	         <a class="btnLook" title="选择分管领导" lookupGroup=""  width="900" height="500"
	          href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupid=attr03&lookupname=managerName"></a>
        </td>
    </tr>
    <tr>
        <td class="form-label">部门综合岗</td>
        <td class="form-value">
            <sc:hidden name="attr04" index="1"/>
	         <sc:text name="deptPostName"   index="1"/>
	         <a class="btnLook" title="选择分管领导" lookupGroup=""  width="900" height="500"
	          href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupid=attr04&lookupname=deptPostName"></a>
        </td>
    </tr>
</table>
<script>
$(function(){
	var userCode=$("input[name='usercode']",$.pdialog.getCurrent()).val();
	if(userCode!=undefined && userCode.trim()!=""){
		getUserExtInfo();
	}
});
function getUserExtInfo(){
	var respUrl = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>&actions=<sc:fmt value='getuserInfoext' type='crypto'/>";
	var leaderUserId=$("input[name='attr02']",$.pdialog.getCurrent()).val();
	var managerUserId=$("input[name='attr03']",$.pdialog.getCurrent()).val();
	var deptPostUserId=$("input[name='attr04']",$.pdialog.getCurrent()).val();
	if((leaderUserId ==  undefined  || leaderUserId.trim()=="")&&(managerUserId ==  undefined  || managerUserId.trim()=="") && ( deptPostUserId ==  undefined  || deptPostUserId.trim()=="")){
		return ;
	}
	$.ajax({
		type : 'POST',
		url : respUrl,
		dataType : "json",
		data:{'leader':leaderUserId,'manager':managerUserId,"deptPost":deptPostUserId},
		async : false,
		success : function(data) {
			   var names=$(data).find("DataPacket Response Data names").text();
			     if(data!=undefined){
			     $("input[name='leaderName']",$.pdialog.getCurrent()).val( data.leaderName);
			     $("input[name='managerName']",$.pdialog.getCurrent()).val( data.managerName);
			     $("input[name='deptPostName']",$.pdialog.getCurrent()).val( data.deptPostName);
			     }
		},
		error : function(json){
			DWZ.ajaxError(json);
		}
	});
}

     
</script>
