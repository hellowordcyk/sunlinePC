<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="org.jdom.*" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%
  String pdeptid = null;
  String levelp = null;
  String deptname = null;
  Document xmlDoc = null;
  try{
	  xmlDoc = (Document) request.getAttribute("xmlDoc");
	  Element record = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("Record");
	  pdeptid = record.getChildText("deptid");//Modified by zmz on 2012-06-30,由pdeptid--》deptid
	  levelp = request.getParameter("levelp");
	  deptname = record.getChildText("deptname");
	  deptname = deptname == null ? "" : deptname;
	  System.out.println(pdeptid+levelp+deptname);
	 
  }catch(Exception ex){
	  pdeptid = request.getParameter("pdeptid");
	  levelp = request.getParameter("levelp");
	  deptname = null;
  }
      
%>
<html>
	<head>
	   <%@ include file="/common.jsp" %>
	</head>
	<body>
		<form name="frmcog" action="/httpprocesserservlet" method="post">
			<input type="hidden" name="sysName" value="<sc:fmt value='pcmc' type='crypto'/>">
			<input type="hidden" name="oprID" value="<sc:fmt value='sm_maintenance' type='crypto'/>">
			<input type="hidden" name="actions" value="<sc:fmt value='addDept' type='crypto'/>">
			<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/pcmc/sm/DeptListDetail.jsp' />">
			<input type="hidden" name="pdeptid" value="<%=pdeptid%>">
			<input type="hidden" name="levelp" value="<%=levelp%>">

			<table cellspacing=0 cellpadding=0 width="98%" align=center border=0>
				<tbody>
					<tr>
						<td valign=top width="100%">
							<fieldset>
								<legend>
									<table cellspacing=0 cellpadding=0 width=100 bgcolor=#e0f0f0 border=0>
										<tbody>
											<tr><td style="padding-top: 2px" align=middle background="/common/images/login_title_bg.gif" height=18><font color=#ffffff>新增子部门</font></td></tr>
										</tbody>
									</table>
								</legend>
								<table width="99%" border="0" align="center" cellpadding="4" cellspacing="0">
									<tr><td>
										<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#EFF0F1" class="form-table">
											<tr><th colspan="4">部门信息</th></tr>
											<tr><td>
												<table width="100%" border="0" cellpadding="3" cellspacing="0">
													<tr>
														<td align="right" class="form-label">上级部门名称：</td>
														<td class="form-value" ><%=deptname%></td>
														<td class="form-value" >&nbsp;</td>
													</tr>
													<tr>
														<td align="right" class="form-label"><font color="red">*</font>部门编号：</td>
														<td class="form-value" >
															<input type="text" name="deptcode" class="inputtext" req="1" displayname="部门编号">
														</td>
														<td class="form-value" >&nbsp;</td>
													</tr>
													<tr>
														<td align="right" class="form-label"><font color="red">*</font>部门名称：</td>
														<td class="form-value" >
															<input type="text" name="deptname" class="inputtext" req="1" displayname="部门名称">
														</td>
														<td class="form-value" >&nbsp;</td>
													</tr>
													<tr>
														<td align="right" class="form-label"><font color="red">*</font>联系人：</td>
														<td class="form-value" >
															<input type="hidden" name="linkman" maxlength=20 class="inputtext"  customtype="num" req="1" displayname="联系人" readonly>
															<input type="text" name="linkm" readonly maxlength=40 class="inputtext" displayname="联系人">
															<img src="/common/images/pic01/sel_person.gif" border=0 align="absmiddle" style="CURSOR: hand" onClick="javascript:getPerson_linkman();">
														</td>
														<td class="form-value" >&nbsp;</td>
													</tr>
													<tr>
														<td align="right" class="form-label">联系电话：</td>
														<td class="form-value"  >
															<input type="text" name="phone" class="inputtext" req="0" displayname="联系电话">
														</td>
														<td class="form-value" >&nbsp;</td>
													</tr>
													<tr>
														<td align="right" class="form-label">备注：</td>
														<td class="form-value" >
															<textarea name="remark" class="inputtext" rows="4" cols="50"></textarea>
														</td>
														<td class="form-value" >&nbsp;</td>
													</tr>
													<tr>
												        <td colspan="4" class="form-bottom">
												            <input type="button" class="button" name="save" value="保存" onclick="saveOk();">&nbsp;&nbsp;
															<input type="reset" class="button" name="reset" value ="重写" >&nbsp;&nbsp;
															<input type="button" class="button" value="返回" onclick="history.go(-1);">
												        </td>
											       </tr>
												</table>
											</td></tr>
										</table>
									</td></tr>
								</table>
							</fieldset>
						</td>
					</tr>
				</tbody>
			</TABLE>			
		</form>
	</body>
<script language="javascript">
	function saveOk()
	{
		if (!checkForm(document.forms[0]))
		{
			return false;
		}
		document.forms[0].submit();
	}

	function getPerson_linkman()
	{
		var tmp1 = document.frmcog.linkman.value;
		var tmp= document.frmcog.linkm.value;
		var urlStr = '/public/pbSelPerson.jsp?deptid=&receiveuser='+tmp+'&receiveuserid='+tmp1+'&multi=0';
		var w = openModal(urlStr,800,540);
		if(w !=null||w !=undefined)
		{
			document.frmcog.linkman.value = w[0];
			document.frmcog.linkm.value = w[1];
		}
	}

</Script>
</html>
