<%--[saveBrchBtnId:修改机构;]--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.jdom.*" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%
  String pdeptid = null;
  String levelp = null;
  String deptname = null;
  Document xmlDoc = null;
  try{
	  xmlDoc = (Document) request.getAttribute("xmlDoc");//[机构树节点deptid=0 xmlDoc=null]
	  Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
	  pdeptid = record.getChildText("deptid");//Modified by zmz on 2012-06-30,由pdeptid--》deptid 
	  levelp = record.getChildText("levelp");
	  deptname = record.getChildText("deptname");
	  deptname = (deptname == null ? "" : deptname);
  }catch(Exception ex){
	  pdeptid = request.getParameter("deptid");
	  levelp = request.getParameter("levelp");
	  deptname = "顶级部门";
  }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
	   <%@ include file="/common.jsp" %>
	</head>
	<body>
		<sc:form name="frmcog" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="pdeptid" value="<%=pdeptid%>" />
        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="form-table">
    	<tr><th colspan="4">部门信息</th></tr>
			<tr>
				<td  class="form-label">上级部门名称：</td>
				<td class="form-value" ><%=deptname%></td>
			</tr>
			<tr>
				<td  class="form-label">部门编号：<font color="red">*</font></td>
				<td class="form-value" >
					<input type="text" name="deptcode" class="inputtext" req="1" maxLength='10' displayname="部门编号">
				</td>
			</tr>
			<tr>
				<td  class="form-label">部门名称：<font color="red">*</font></td>
				<td class="form-value" >
					<input type="text" name="deptname" class="inputtext" req="1" maxLength='25' displayname="部门名称">
				</td>
			</tr>
			<tr>   	 
	   			<sc:select dsp="td" req="1" dspName="机构类型" name="orgtype" type="knp" key="pcmc,orgtype" includeTitle="false" nullOption="---请选择---" dspValue="true"/>
    		</tr>
			<tr>
			    <sc:text dsp="td" name="levelp" dspName="机构层次"/>
			</tr>
			<tr>
				<td  class="form-label">联系人：<font color="red">*</font></td>
				<td class="form-value" >
					<input type="hidden" name="linkman" maxlength=20 class="inputtext"  customtype="num" req="1" displayname="联系人" readonly>
					<input type="text" name="linkm" readonly maxlength=40 class="inputtext" displayname="联系人">
					<img src="/common/images/pic01/sel_person.gif" border=0 align="absmiddle" style="CURSOR: hand" onClick="javascript:getPerson_linkman();">
				</td>
			</tr>
			<tr>
				<sc:text dsp="td" name="phone"  req="0" dspName="联系电话" type="phone" index="1" attributesText="maxLength='12'"/>
			</tr>
			<tr>
				<td  class="form-label">备注：</td>
				<td class="form-value" >
					<textarea name="remark" class="inputarea" rows="4" cols="50"></textarea>
				</td>
			</tr>
			<tr>
		        <td colspan="4" class="form-bottom">
		            <input type="button" class="button" name="save" value="保存" id="saveBrchBtnId" onclick="saveOk();">&nbsp;&nbsp;
					<input type="reset" class="button" name="reset" value ="重写" >&nbsp;&nbsp;
					<input type="button" class="button" value="关闭" onclick="window.close();">
		        </td>
	       </tr>
		</table>
	</sc:form>
</body>
<script language="javascript">
init();
function init(){
$$("input[name='levelp']")[0].value=parseInt('<%=levelp%>')+1;
$$("input[name='levelp']")[0].disabled=true;
}	
function saveOk()
	{
	  var oForm = document.forms["frmcog"];
	  
		if (!checkForm(document.forms[0]))
		{
			return false;
		}
		 var reqparams = {
			sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
			oprID: 		'<sc:fmt type="crypto" value="sm_maintenance"/>',
			actions:	'<sc:fmt type="crypto" value="addOrgDept"/>',
			pdeptid:	oForm.elements("pdeptid").value,
			levelp:		oForm.elements("levelp").value,
			deptcode:   oForm.elements("deptcode").value,
			deptname:   oForm.elements("deptname").value,
			linkman: 	oForm.elements("linkman").value,
			phone:		oForm.elements("phone").value,
			remark:		oForm.elements("remark").value,
			orgtype:	oForm.elements("orgtype").value
			};
	    var ajax = new Jraf.Ajax();
		ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
			try{
		   			var pkg = new Jraf.Pkg(xml);
		   			if(pkg.result()!='0'){
		   			  Jraf.showMessageBox({
                    		text: '<span class="warn">\n' + pkg.allMsgs()+'</span>'
		                });
		   			}else{
			   			var deptcode = $$("input[name='deptcode']")[0].value;
						var deptid = pkg.reqData("deptid");
						var deptname = $$("input[name='deptname']")[0].value;
						var pdeptid =<%=pdeptid%>;
						var results = {
						                deptcode: deptcode,
						                deptname: deptname,
						                nodetype: "parentnode",
						                deptid: deptid,
						                pdeptid:pdeptid
						            };
			            window.returnValue = results;
					    window.close();
		   			
		   			}
					
		          
				}catch(e){alert('ERROR:'+e);}
		
		});		
	}


	function getPerson_linkman()
	{
		var tmp1 = document.frmcog.linkman.value;
		var tmp= document.frmcog.linkm.value;
		var urlStr = '/public/pbSelPerson.jsp?deptid=&receiveuser='+encodeURI(encodeURI(tmp))+'&receiveuserid='+tmp1+'&multi=0';
		var w = openModal(urlStr,800,450);
		if(w !=null||w !=undefined)
		{
			document.frmcog.linkman.value = w[0];
			document.frmcog.linkm.value = w[1];
		}
	}

</Script>
</html>