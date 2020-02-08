<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<%-- <%
	

	String flag = request.getParameter("flag");  //标志位
	String userid = request.getParameter("userid");  //用户id
	String userCode = request.getParameter("looks.userCode2"); //用户编码
	
	String scgptp = request.getParameter("scgptp"); //资源id类型 
	String subsys = request.getParameter("looks.subsys");  //子系统
	String resctp = request.getParameter("looks.resctp"); //资源类型


%> 
<%
	    Document xmlDoc = (Document)request.getAttribute("xmlDoc");
		Element pageInfo = xmlDoc.getRootElement().getChild("Response").getChild("Data").getChild("PageInfo");
	    String recordCount = pageInfo.getChildTextTrim("RecordCount");
	    String pageCount = pageInfo.getChildTextTrim("PageCount");
	    String pageSize = pageInfo.getChildTextTrim("PageSize");
	    String pageNo = pageInfo.getChildTextTrim("PageNo");
%> --%>
<% 
	String userId = request.getParameter("userId"); //用户Id
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<!-- 
*logs:
*       edited by beidao 20160707 优化界面
 -->
<head>
<script type="text/javascript">
   function addUserGrantResource(){  //授权
		 var rspridList='';
		 var seperator='';
		 
		var userCode = $("#userCodeId2").val();
		var boxArr=document.getElementsByName("pcmc");
		for(var i=0;i<boxArr.length;i++){
			var singleBox=boxArr[i];
			if(singleBox.checked){
				rspridList=rspridList+seperator+singleBox.value;
	       		seperator=',';
			}
		}	
		if(rspridList==""){
			alert("请选择信息");
			return ;
		} 
		var param = {
				rspridList:rspridList,
				userid:userCode,
				scgptp:'<c:out value="${param.scgptp}" />'
     		  };
		<%-- window.location.href='/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='addUserGrantResource' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/resource/manager_user_grant_resc.jsp' type='crypto'/>&rspridList='+rspridList+'&userid='+userCode+'&scgptp=<%=scgptp%>';       --%>
		var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'+
    	'&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>'+
    	'&actions=<sc:fmt value='addUserGrantResource' type='crypto'/>';
    	$.ajax({
	    	type:'POST',
	    	url: url,
	    	dataType:'xml',
	    	data:$.param(param,true),	   		        
	    	success:function(data){
	    	     //解析后台返回的xmlr数据
	    		$.pdialog.closeCurrent();
	    		$("#res_user_grant").trigger("click");
	    	}
    	}); 
   }

</script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
<style type="text/css">

</style>
<title>资源授权</title>
<script type="text/javascript">

</script>
</head>
<body>	
<div class="pageHeader">
	<form id="pagerForm"  onsubmit="return dialogSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='queryUserUnGrantResource' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/resource/query_user_ungrant_resc.jsp' type='crypto'/>" method="post">
	<div class="searchBar">
	 <input  type="hidden" id="scgptp" name="scgptp" value="<c:out value='${param.scgptp }' />"/>
	 <input type="hidden" name="pageNum" value="1" />
	 	
	<%-- 规范： 初始化查询必加隐藏表单 --%>
    <sc:hidden name="jraf_initsubmit"/>
	
	<table class="searchContent" border="0" width="100%" cellspacing="0" cellpadding="0">
           <tr>
                    <td class="form-label">用户ID</td>
                    <td class="form-value">
                       <sc:text id="userCodeId2" name="looks.userCode2" readonly="true"  value="<%=userId %>" />
                    </td>
                    <td class="form-label">子系统 </td>
			        <td class="form-value">
			          <sc:select  id ="subsys" name="looks.subsys"  type="subsys"  nullOption ="---请选择----"  default="${param.looks.subsys }" />
			        </td>
                    <td class="form-btn">
                         <ul>
                            <li>
                                <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                                <button class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>  
          </tr>
		  <tr>
               <td class="form-label">资源<!-- (组) -->代码/名称</td>
               <td class="form-value">
                    <sc:text id="resccd" name="looks.resccd" />
               </td>
               <td class="form-label">资源类型</td>
	      		<td class="form-value">
	          		<sc:select  id ="resctp" name="looks.resctp"  type="knp" key="pcmc,resctp"  nullOption ="---请选择----" default="${param.looks.resctp }" />
	      		</td>
		 </tr>
    </table>
    </div>
	</form>
    </div>
    
	<div class="pageContent" >
	 <div class="panelBar">
		<ul class="toolBar">
			<%-- <li><a class="delete" rel="pcmc" target="selectedTodo"  href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='bdss_resc_grant' type='crypto'/>&actions=<sc:fmt value='addUserGrantResource' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li> --%>
			<li><a class="add" href="javascript:void(0)" onclick="addUserGrantResource();"><span>授权</span></a></li>
			<li class="line">line</li> 
        </ul>
	</div>	 
	<table class="table" width="100%">
		<thead>
			<tr>
				<th width="25px"><input type="checkbox" class="checkboxCtrl" group="pcmc"/></th>
				<th>资源代码</th>
				<th>资源<!-- /资源组 -->名称</th>
				<th>资源类型</th>
				<th>子系统</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach var="sysBaseRsgp" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
				<tr >
				    <td><input type="checkbox"  name="pcmc" value="${sysBaseRsgp.rescid}"/></td>
				    <td>${sysBaseRsgp.resccd}</td>
				    <td>${sysBaseRsgp.rescna}</td> 
					<td><sc:optd  name="resctp"  type="knp" key="pcmc,resctp" value="${sysBaseRsgp.resctp}"/></td>		
					<td><sc:optd  name="subsys"  type="subsys" value="${sysBaseRsgp.subsys}"/></td>
				</tr>
		</c:forEach>
	  </tbody>
	</table>
	<div class="panelBar">	
		<div class="pagination" targetType="dialog" 
		totalCount="${jrafrpu.rspPkg.rspRecordCount}" numPerPage="${jrafrpu.rspPkg.rspPageSize}" currentPage="${jrafrpu.rspPkg.rspPageNo}"></div>
	</div>
</div>   
</body>
</html>