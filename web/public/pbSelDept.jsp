<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.sunline.jraf.util.Crypto" %>
<% request.setCharacterEncoding("UTF-8"); %>
<%
	String multi = request.getParameter("multi");
	String receiveDept = request.getParameter("receiveDept");
	String[] ary1 = receiveDept.split(",");
	String receiveDeptid = request.getParameter("receiveDeptid");
	String[] ary2 = receiveDeptid.split(",");
    String s_deptid = (String)session.getAttribute("deptid");
	String deptid = "";
	String lab = "选择部门";
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

<html>
<head>
<%@include file="/common.jsp" %>
</head>
<body background="/common/images/background.gif"
style="border-right: medium none; border-top: medium none; margin: 0px; 
border-left: medium none; border-bottom: medium none"
oncopy="return false;" bgcolor=#FFFFFF>

<form name="form1">
	<input type="hidden" name="itemnm">
	<input type="hidden" name="lab" value="<%=lab%>">
	<input type="hidden" name="deptid" value="<%=deptid%>">
	<input type="hidden" name="s_deptid" value="<%=s_deptid%>">
	
<table cellSpacing=0 cellPadding=0 width="98%" align=center border=0>
	<tr>
		<td vAlign=top width="100%">
			<sc:fieldset name="选择部门">
				<table width="100%" border=0 align="center" cellpadding=4 cellspacing=0>
				<tr>
				    <td valign="top">
				        <table width="100%" border=0 cellpadding=0 cellspacing=0 bgcolor="#EFF0F1">
				            <tr>
								<td width="100%" background="/common/images/navigation_ico_2.gif" class="navigation">
				                	<table width="100%" border=0 cellpadding="2" cellspacing=0>
				                		<tr><td width="100%">&nbsp;<font color="#FFFFFF">待选部门</font></td></tr>
				                	</table>
				            	</td>
							</tr>
				            <tr>
				            	<td><div id="quotalist"></div></td>
								<script language="JavaScript">
								var icons=new alai_imagelist()
								icons.path="/common/images/tree/"
								icons.add("hfile.gif","default")
								icons.add("plus.gif","expand")
								icons.add("minus.gif","collapse")
								icons.add("folderopen.gif","hfold_open")
								icons.add("folder.gif","hfold_close")
								var tree=new alai_tree(icons,18,quotalist)
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
							</tr>
					            <iframe id="ifrLoad" style="width:0;height:0" src='<%=urlBuf.toString()%>&deptid=<%=deptid%>&rootid=1'></iframe>
					        </table>
					    </td>

					    <td width="10%" valign="top">
					    	<table width="100%" border=0 cellpadding="2" cellspacing=0 >
								<br>
								<br>
					    		<tr><td>&nbsp;</td></tr>
					    		<tr><td>&nbsp;</td></tr>
								<br>
					
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
					    <td width="25%" valign="top">
					    	<table width="100%" border=0 cellpadding=0 cellspacing=0 bgcolor="#EFF0F1">
					    	<tr width="100%">
								<td width="100%" background="/images/navigation_ico_2.gif" class="navigation">
					        		<table width="100%" border=0 cellpadding=4 cellspacing=0>
					        			<tr><td width="100%">&nbsp;<font color="#FFFFFF">已选部门</font></td></tr>
					        		</table>
								</td>
							</tr>
							<tr width="100%">
								<td width="100%">
					  				<select size="20" multiple name="selectedDept">
					  					<option value="-1">------已选择的部门-----</option>
									<%if (receiveDept!=null && !receiveDept.equals("")){
										for (int i=0;i<ary1.length;i++){
										String str1 = ary1[i];
										String str2 = ary2[i];
									%>
					  					<option value="<%=str2%>"><%=str1%></option>
									<%}}%>
								  	</select>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</sc:fieldset>
	</td>
</tr>
</table>
</form>
</body>
<script language="javascript" src="/js/openW.js"></script>
<script language="javascript">
	function btnsure(){
		var pobj = form1.selectedDept;
		var deptids = "";
		var deptnas = "";
		var deptcodes = "";
		for (var i=1;i<pobj.length;i++){
			deptids = deptids + "," + pobj.options[i].value;
			deptnas = deptnas + "," + pobj.options[i].text;
			var tmp = pobj.options[i].text;
			tmp = tmp.replace("]","");
			tmp = tmp.substring(tmp.indexOf("[")+1,tmp.length);
			deptcodes = deptcodes + "," +tmp;
		}
		deptids = deptids.substring(1,2000);
		deptcodes = deptcodes.substring(1,2000);
		deptnas = deptnas.substring(1,2000);
	    var arr = new Array(deptids,deptcodes,deptnas);
	    reValue(arr);
	}
	
	function selone(){
		var eNode = tree.getSelectedNode();
		var val = eNode.getKey().replace("n","");
		var txt = eNode.label.innerHTML;
	
		var pobj = form1.selectedDept;
	    if (CheckExists(pobj,val,txt)==false){
	    	AddOnTo(pobj,val,txt);
	    }
	}
	
	function selall(){
		var obj = document.frames("quotadetail").document.all("frmList").listPerson;
		var pobj = form1.selectedDept;
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
		var pobj = form1.selectedDept;
	 	for(var i=pobj.length-1;i>0;i--){
	  		if(pobj.options[i].selected){
				pobj.remove(i);
	  		}
	 	}
	}
	
	function unselall(){
		var pobj = form1.selectedDept;
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
	}
	
	function viewItem()
	{
		var eNode = tree.getSelectedNode();
		var key = eNode.getKey().replace("n","");
		var lab = eNode.label.innerHTML;
	}
	
	function selone_only()
	{ 
		unselall();
		var eNode = tree.getSelectedNode();
		if(eNode==null){
		 alert("请先选择节点");
		}else{
		var val = eNode.getKey().replace("n","");
		var txt = eNode.label.innerHTML;
		var pobj = form1.selectedDept;
	    if (CheckExists(pobj,val,txt)==false){
	    	AddOnTo(pobj,val,txt);
	    }
		}
		
 	}

</script>
</html>
