<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<%
		    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
            Element pageInfo = null;
            String recordCount = "0";
            String pageCount = "0";
            String pageSize = "0";
            String pageNo = "1";
            if (xmlDoc != null) {
                pageInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("PageInfo");
                recordCount = pageInfo.getChildTextTrim("RecordCount");
                pageCount = pageInfo.getChildTextTrim("PageCount");
                pageSize = pageInfo.getChildTextTrim("PageSize");
                pageNo = pageInfo.getChildTextTrim("PageNo");
            }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- 
*logs:
*      edited by beidao 20160707 优化界面
-->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
<title>角色资源授权</title>
<script type="text/javascript">	

//弹出页面回调函数
function rolegrantAjaxDone()
{
	$.pdialog.closeCurrent();
	$("#res_role_grant").trigger("click");
}

function deleteRolegrant(rsprid){	
    var rsgpidList='';
    var seperator='';
   if(rsprid==null){
	   var boxArr=document.getElementsByName("rsprid");
		for(var i=0;i<boxArr.length;i++){
			var singleBox=boxArr[i];
			if(singleBox.checked){
				rsgpidList=rsgpidList+seperator+singleBox.value;
	       		seperator=',';
			}
		}
   }else{
	   rsgpidList = rsprid;
   }
	 var param = {
			 rsprid:rsgpidList
  			 };
	 var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'+
 	 '&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>'+
 	 '&actions=<sc:fmt value='deleteUserGrantResource' type='crypto'/>';
 	 $.ajax({
	    	type:'POST',
	    	url: url,
	    	dataType:'xml',
	    	data:$.param(param,true),	   		        
	    	success:function(data){
	    	     //解析后台返回的xmlr数据
	    		$("#res_role_grant").trigger("click");
	    	}
 	 }); 
  }

function findUserCodeId(){  //查找用户列表
	 var userCode = document.getElementById("userCodeId").value;
	 var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='queryRoleListLike' type='crypto'/>';
		$.ajax({
			   type: "POST",
			   url: url,
			   data: "userCode="+userCode,
			   dataType : "xml",
			   processData: false,
			   success: function(data){
				   
			   }
		});
}

function queryRoleGrantResc(){    //查询用户已授权资源
 	//var userIdObj = document.getElementsByName("userId")[0];
 	//var userCodeObj = document.getElementById("userCodeId").value;
 /*	if(userIdObj.value == null || userIdObj.value == "" ){
 		alert("请从下拉框中选择一个，下拉框能根据您的输入模糊查询数据！");
 		return ;
 	}*/
 	 document.searchForm.submit();
 	
 	/*var oLoadPageTo = new Jraf.LoadPageTo();
 	oLoadPageTo.doLoad("user_resc_list_id");*/
 }
  
function addRolePrivResc(){  //角色授权资源 
	//var userId =document.getElementById('userId').value;  //用户id
	var roleId =document.getElementById('roleId2').value;  //用户code
	if(roleId.trim()==""){
		alert("请输入角色id");
		return;
	}
	
	var resctp =document.getElementById('resctp').value; //资源类型
	var subsys =document.getElementById('subsys').value;  //子系统
	  
	url='/funcpub/portal/resource/query_role_ungrant_resc.jsp?flag=1&roleId='+roleId+'&scgptp='+1+"&subsys="+subsys+"&resctp="+resctp; 
	$.pdialog.open(url, "addRolePrivRes", "未授权资源查询",{width:800,height:600}); 
}

function addRolePrivGroup(){  //角色授权资源组  
	//var userId =document.getElementById('userId').value;      //用户id
	var roleId =document.getElementById('roleId2').value;  //用户code 
	
	var resctp =document.getElementById('resctp').value;       //资源类型
	var subsys =document.getElementById('subsys').value;       //子系统

    url='/funcpub/portal/resource/query_role_ungrant_resc.jsp?flag=1&roleId='+roleId+'&scgptp='+2+"&subsys="+subsys+"&resctp="+resctp;
    $.pdialog.open(url, "addRolePrivRes", "未授权资源查询",{width:750,height:600}); 
}
</script>
</head>
    <body>
      <div class="pageHeader">
		     <form  id="pagerForm" name="searchForm" onsubmit="return divSearch(this, 'jbsxBox4');" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='queryRoleRescList' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/resource/manager_role_grant_resc.jsp' type='crypto'/>" method="post"> 
                <input type="hidden" name="pageNum" value="1" />
                <input type="hidden"  id="userId" name="userId"/>
                <input type="hidden"  id="rolename" name="rolename"/>
                <div class="searchBar">
					<table class="searchContent" border="0" width="100%" cellspacing="0" cellpadding="0">
					    <tr>
					    	<td class="form-label">角色ID</td>
					    	<td class="form-value">
				    	      <sc:text id="roleId2" name="looks.roleId" validate="required digits"/>
				    	      <span style="color: red;">*</span>
					    	</td>
					    	<td class="form-label">资源代码/名称</td>
						    <td class="form-value"><sc:text id="resccd" name="looks.resccd" /></td>
						    <%-- <td align="right">授权途径</td>
						    <td><sc:select  id ="grantTp" name="looks.grantTp"  type="dict" key="pcmc,rlgrtp"  nullOption ="---请选择----" /></td>  --%>
                            <td class="form-btn">
                                <ul>
                                    <li>
                                        <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                                        <button class="querybtn" id="res_role_grant" jraf_initsubmit type="submit">查询</button>
                                    </li>
                                    <li>
                                        <button class="resetbtn" type="reset">清空</button>
                                    </li>
                                </ul>
                            </td>
                    </tr>
					    <tr>
							  <td class="form-label">资源类型</td>
						      <td class="form-value">
						          <sc:select  id ="resctp" name="looks.resctp"  type="knp" key="pcmc,resctp"  nullOption ="---请选择----" />
						      </td>
						      <td class="form-label">子系统</td>
					          <td class="form-value">
					              <sc:select  id ="subsys" name="looks.subsys"  type="subsys"  nullOption ="---请选择----" />
					          </td> 
						</tr>
				  </table>
		   	  </div>
			</form>
	   </div>
 <div class="pageContent" >
	 <div class="panelBar">
		<ul class="toolBar">
		    <li><a class="add" href="javascript:void(0)" onclick="addRolePrivResc();"><span>资源授权</span></a></li> 
		    <li class="line">line</li> 
		    <!-- <li><a class="add" href="javascript:void(0)" onclick="addRolePrivGroup();"><span>资源组授权</span></a></li> -->
			<!-- <li class="line">line</li>  -->
			<%-- <li><a class="delete" rel="rsprid" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='deleteUserGrantResource' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li> --%>
			 <li><a class="delete" onclick="deleteRolegrant()"><span>删除</span></a></li>
			<li class="line">line</li> 
        </ul>
	</div>	 
	<div id="addRolePrivGroup">
	<table class="table" width="100%">
		<thead>
			<tr>				
				 <th width="25px"><input type="checkbox" class="checkboxCtrl" group="rsprid" /></th>
	             <th>资源代码</th>
	             <th>资源名称</th>
	             <th>资源类型</th>
	             <th>子系统</th>
	             <!-- <th>资源组</th> -->
	             <th>角色</th>
	             <th>来源</th>
	             <th>删除</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="rolegrantresc" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
			<tr >
			    <td><input type="checkbox"  name="rsprid" value="${rolegrantresc.rsprid}"/></td>
			    <td>${rolegrantresc.resccd}--${rolegrantresc.rsprid}</td>
				<td>${rolegrantresc.rescna}</td>
				<td><sc:optd  name="resctp"  type="knp" key="pcmc,resctp"/></td>		
				<td><sc:optd  name="subsys"  type="subsys"/></td>
				<%-- <td>${rolegrantresc.rsgpna}</td> --%>
				<td>${rolegrantresc.rolename}</td>
				<td><sc:optd  name="granttp"  type="bdss" key="bdss,usgrtp" /></td>
				<%-- <td><div class="deletetemp"><button onclick="deleteRolegrant(${rolegrantresc.rsprid});">删除</button></div> --%>
				<td><a class="btnDel" onclick="deleteRolegrant(${rolegrantresc.rsprid});">删除</a>
					<%-- <a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"  
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
						&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='deleteUserGrantResource' type='crypto'/>
						&rsprid=${rolegrantresc.rsprid}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a> --%>
				</td>
			</tr>
		 </c:forEach>
	  </tbody>
	</table>
	</div>
	<div class="panelBar">
		<div rel="jbsxBox4" class="pagination" targetType="navTab" totalCount="<%=recordCount %>" numPerPage="<%=pageSize %>" currentPage="<%=pageNo %>"></div>
	</div>
</div>   
</body>
</html>