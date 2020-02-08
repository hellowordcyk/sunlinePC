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
<%--
*	logs:
*       edited by beidao 20160707 界面优化
--%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
<style type="text/css">

</style>
<title>用户资源授权</title>
<script type="text/javascript">	

//弹出页面回调函数
function usergrantAjaxDone()
{
	$.pdialog.closeCurrent();
	$("#res_user_grant").trigger("click");
}

function deleteUsergrant(rsgpid){	
	var rsgpidList='';
    var seperator='';
   if(rsgpid==null){
	   var boxArr=document.getElementsByName("rsprid");
		for(var i=0;i<boxArr.length;i++){
			var singleBox=boxArr[i];
			if(singleBox.checked){
				rsgpidList=rsgpidList+seperator+singleBox.value;
	       		seperator=',';
			}
		}
   }else{
	   rsgpidList = rsgpid;
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
	    		$("#res_user_grant").trigger("click");
	    	}
 	 }); 
  }

function findUserCodeId(){  //查找用户列表
	 var userCode = document.getElementById("userCodeId").value;
	 var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='queryUserListLike' type='crypto'/>';
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

function queryUserGrantResc(){    //查询用户已授权资源
 	 document.searchForm.submit();
 	

 }
  
function addUserPrivResc(){  //授权资源
	//var userId =document.getElementById('userId').value;  //用户id
	var userId =document.getElementById('userCodeId').value;  //用户code
	if (userId == '') {
		alert("请输入用户Id");
		return;
	}
	var resctp =document.getElementById('resctp').value; //资源类型
	var subsys =document.getElementById('subsys').value;  //子系统
	  
	url='/funcpub/portal/resource/query_user_ungrant_resc.jsp?flag=1&userId='+userId+'&scgptp='+1+"&looks.subsys="+subsys+"&looks.resctp="+resctp; 
	$.pdialog.open(url, "addUserPrivRes", "未授权资源查询",{width:800,height:600}); 
}

function addUserPrivGroup(){  //授权资源组 
	//var userId =document.getElementById('userId').value;      //用户id
	var userCode =document.getElementById('userCodeId').value;  //用户code 
	
	var resctp =document.getElementById('resctp').value;       //资源类型
	var subsys =document.getElementById('subsys').value;       //子系统

    url='/funcpub/portal/resource/query_user_ungrant_resc.jsp?flag=1&userCode2='+userCode+'&scgptp='+2+"&subsys="+subsys+"&resctp="+resctp;
    $.pdialog.open(url, "addUserPrivRes", "未授权资源查询",{width:750,height:600}); 
	
}

</script>
</head>
   <body>
    <div class="pageHeader">
	   <form  id="pagerForm"  name="searchForm" onsubmit="return divSearch(this, 'jbsxBox3');" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='queryUserRescList' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/resource/manager_user_grant_resc.jsp' type='crypto'/>" method="post">
                <input type="hidden" name="pageNum" value="1" />
                <input type="hidden"  id="userId" name="userId"/>
               <div class="searchBar">
				<table class="searchContent" border="0" width="100%" cellspacing="0" cellpadding="0">
                    <tr>
                        <td class="form-label">用户id</td>
                        <td class="form-value">
                            <sc:text id="userCodeId" name="looks.userCode" validate="required digits" readonly="true"></sc:text>
                            <a class="btnLook" width="800" height="450" title="用户信息-单选"
                                lookupGroup=""
                                href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupid=looks.userCode&lookupcode=usercode&lookupname=username"></a>
                        </td>
                        <%-- <td class="form-value"><sc:text id="userCodeId" name="looks.userCode" validate="required digits"></sc:text><span style="color: red;">*</span></td> --%>
                        <td class="form-label">资源代码/名称</td>
                        <td class="form-value">
                            <sc:text id="looks.resccd" name="resccd" />
                        </td>
                        <%-- <td align="right">授权途径</td>
					    <td><sc:select  id ="grantTp" name="looks.grantTp"  type="dict" key="pcmc,usgrtp"  nullOption ="---请选择----" /></td>  --%>
                         <td class="form-btn">
                                <ul>
                                    <li>
                                        <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                                        <button class="querybtn" id="res_user_grant" jraf_initsubmit type="submit">查询</button>
                                    </li>
                                    <li>
                                        <button class="resetbtn" type="reset">清空</button>
                                    </li>
                                </ul>
                          </td>
                    </tr>
                    <tr>
					  <td class="form-label">资源类型</td>
				      <td class="form-value"><sc:select  id ="resctp" name="looks.resctp"  type="knp" key="pcmc,resctp"  nullOption ="---请选择----" /></td>
				      <td class="form-label">子系统 </td>
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
		    <li><a class="add"  href="javascript:void(0)" onclick="addUserPrivResc();"><span>资源授权</span></a></li> 
		    <li class="line">line</li> 
		    <!-- <li><a class="add" href="javascript:void(0)" onclick="addUserPrivGroup();"><span>资源组授权</span></a></li> -->
			<!-- <li class="line">line</li>  -->
			<%-- <li><a class="delete" rel="rsprid" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='deleteUserGrantResource' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li> --%>
			 <li><a class="delete" onclick="deleteUsergrant()"><span>删除</span></a></li>
			<li class="line">line</li> 
        </ul>
	</div>	 
	<div id="addUserPrivGroup">
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
		<c:forEach var="usergrantresc" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
			<tr >
			    <td><input type="checkbox"  name="rsprid" value="${usergrantresc.rsprid}"/></td>
			    <td>${usergrantresc.resccd}</td>
				<td>${usergrantresc.rescna}</td>
				<td><sc:optd  name="resctp"  type="knp" key="pcmc,resctp" index="${index.count}"/></td>			
				<td><sc:optd  name="subsys"  type="subsys" index="${index.count}"/></td>
				<%-- <td>${usergrantresc.rsgpna}</td> --%>
				<td>${usergrantresc.rolena}</td>
				<td><sc:optd  name="granttp"  type="dict" key="pcmc,usgrtp" index="${index.count}"/></td>
				<%-- <td><div class="deletetemp"><button onclick="deleteUsergrant(${usergrantresc.rsprid});">删除</button></div> --%>
				<td><a class="btnDel" onclick="deleteUsergrant(${usergrantresc.rsprid});">删除</a>
					<%-- <a  class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"  
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
						&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='deleteUserGrantResource' type='crypto'/>
						&rsprid=${usergrantresc.rsprid}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除</a> --%>
				</td>
				
			</tr>
		 </c:forEach>
	  </tbody>
	</table>
	</div>
	<div class="panelBar">
		<div class="pagination" targetType="navTab" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
	</div>
	</div>
</div>   
</body>
</html>