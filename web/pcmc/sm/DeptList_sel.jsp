<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp" %>
<FIELDSET>
	<sc:hidden name="roleid" value="${request.roleid}"/>
	<table align="center" class="form-table" border="0" width="100%" height="100%" cellspacing=0 cellpadding=0>
		    <tr><th colspan="5">可授权机构查询</th></tr>
		    <tr>
			    <sc:text dsp="td" name="deptcode" dspName="机构编码" req="0"/>
			    <sc:text dsp="td" name="deptname" dspName="机构名称" req="0"/>
			    <td>
			    <sc:button value="查询" attributesText="id='queryBtn'" onclick="queryData()"/>
			    </td>
			</tr>
    <tr><th colspan="5">用户授权信息</th></tr>
    <tr>
		<td>
			<input type="button" class="selectall" value="全选" onclick="javascript:selectAll(false);">&nbsp;
			<input type="button" class="cancelall" value="全消" class=btn onclick="javascript:selectAll(true);">
		</td>
	</tr>
    <tr><td colspan="5">
    <table id="record" class="list-table">
    <tr>
    <th style="width:5%;text-align:center">选择</th>
    <th style="width:20%;text-align:center">机构编码</th>
    <th style="width:25%;text-align:center">机构名称</th>
    <th style="width:30%;text-align:center">联系人</th>
    <th style="width:30%;text-align:center">联系电话</th>
    </tr>
    </table>
</table>

</FIELDSET>
<script language="javascript">

document.observe("dom:loaded", function (){
	queryData();
});

 function queryData() {
	var param = {
	    sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
	    oprID:      '<sc:fmt type="crypto" value="sm_maintenance"/>',
	    actions:    '<sc:fmt type="crypto" value="queryDeptList"/>',
	    deptcode:     $$("input[name='deptcode']")[0].value,
	    deptname:     $$("input[name='deptname']")[0].value,
	    roleid:       $$("input[name='roleid']")[0].value
	};
	var i = 1;
	var ajax = new Jraf.Ajax();
	ajax.sendForXml('/xmlprocesserservlet', param, function(xml){
	        try{
		            var pkg = new Jraf.Pkg(xml);
		            if(pkg.result() != '0'){
			            Jraf.showMessageBox({title: "查询异常", text: "<span class='error'>" + '异常：' + pkg.allMsgs('<br>') + "</span>"});
		                return;
		            }
		            for(var j = 1 ; j < $('record').rows.length; j ++){
		            	$('record').deleteRow(j);
		            	j = j - 1;
		            }
		            var rcds = pkg.rspDatas().Record;
		            if(!rcds) {rcds = [];}
	        		if(!Object.isArray(rcds)) {rcds = [rcds];}
		            if(rcds != null){
		            rcds.each(function(rcd){
			            var oRow = $('record').insertRow();
			            if(i%2 == 0)
			            oRow.className="even";
			            else
			            oRow.className="odd";
			            var oCell = oRow.insertCell();
			            if(rcd.flag == '1'){
				            oCell.innerHTML="<input type='checkbox' name='deptid' value='" + rcd.deptid + "' checked />";
			            }
			            else{
			            	oCell.innerHTML="<input type='checkbox' name='deptid' value='" + rcd.deptid + "' />";
			            }
			            oCell = oRow.insertCell();
			            oCell.innerText = rcd.deptcode;
			            oCell = oRow.insertCell();
			            oCell.innerText = rcd.deptname;
			            oCell = oRow.insertCell();
			            oCell.innerText = rcd.linkman;
			            oCell = oRow.insertCell();
			            oCell.innerText = rcd.phone;
			            i++;
		            });	
		        }
	        }catch(e){
			Jraf.showMessageBox({title: "查询异常", text: "<span class='error'>" + e + "</span>"});
		}
	});
}
<%--
Event.observe(window, 'load', function() { 
	new Jraf.Outlinetor(".list-table tbody tr");
}); --%>

function selectAll(sel){
	var selected = sel;
  	var selObj = $$("input[name='deptid']");
  	if (!selected){
      for (var i=0;i<selObj.length;i++){
       selObj[i].checked = true;
  	  }
  	}else{
      for (var i=0;i<selObj.length;i++){
        selObj[i].checked = false;
  	 }
  }
}
</script>