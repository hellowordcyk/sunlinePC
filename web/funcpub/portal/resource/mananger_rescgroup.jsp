<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" /> 
<style type="text/css">

</style>
<title>系统资源组维护</title>
<style type="text/css">
.deletetemp{
	background: #edeff2 url(../default/images/button/delete.gif) no-repeat 10px 4px;
}

</style>
<script type="text/javascript">	

//弹出页面回调函数
function rescGroupAjaxDone()
{
	$.pdialog.closeCurrent();
	//var form = $("#pagerForm", navTab.getCurrentPanel().find("#jbsxBox2")).get(0);
	//form.submit();
	//dwzPageBreak({targetType:"navTab", rel:"jbsxBox2", data:{pageNum:1}});
	$("#res_group_query").trigger("click");
}

/**
 * 确认提示
 */
function confirmFun(rsgpid) {
	alertMsg.confirm("确定删除吗？", {
        okCall: function(){
        	deleteRescgroup(rsgpid);
        }
	});
}

function deleteRescgroup(rsgpid){	
    var rsgpidList='';
    var seperator='';
    var count =0;
   if(rsgpid==undefined||rsgpid=='undefined'){
	   var boxArr=document.getElementsByName("rsgpid");
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
			 	rsgpid:rsgpidList
  			 };
	 var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'+
 	 '&oprID=<sc:fmt value='sys_res_gp' type='crypto'/>'+
 	 '&actions=<sc:fmt value='deleteRsgp' type='crypto'/>';
 	 $.ajax({
	    	type:'POST',
	    	url: url,
	    	dataType:'xml',
	    	data:$.param(param,true),	   		        
	    	success:function(data){
	    	     //解析后台返回的xmlr数据
	    		$("#res_group_query").trigger("click");
	    	}
 	 }); 
  }
</script>
</head>
<div id ="main_div">
	<table id="leftId" height="100%" cellspacing="0" cellpadding="0" width="100%" border="0">
		<tr>
		    <td width="60%" align="left" valign="top" >
		            <!-- 资源组查询条件 -->
		            <div id="left_search_div">
			            <form  id="pagerForm" onsubmit="return divSearch(this, 'jbsxBox2');"  action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sys_res_gp' type='crypto'/>&actions=<sc:fmt value='queryGroupList' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/resource/mananger_rescgroup.jsp' type='crypto'/>" method="post"> 
			              <input type="hidden" name="pageNum" value="1" />
			              
			              	
	                       <%-- 规范： 初始化查询必加隐藏表单 --%>
                            <sc:hidden name="jraf_initsubmit"/>
	
			              <div class="searchBar"> 
			                <table id="queryTableId" align="center" class="form-table" border="0" width="100%" cellspacing="0" cellpadding="0" style="margin: 0px;">
			                  <tr>
			                      <td align="right">资源类型</td>
			                      <td>
			                          <sc:select id ="resctp" name="looks.resctp"  type="knp" key="pcmc,resctp"  nullOption ="---请选择----" includeTitle="false" index="1"/>
			                      </td>
			                      <td align="right">子系统</td>
		      					  <td>
		      					     <sc:select  id ="subsysId" name="looks.subsys"  type="subsys"  nullOption ="---请选择----" includeTitle="false" index="1"/>
		      					  </td>
			                      <td align="right">资源组名称 </td>
			                      <td><sc:text id="rsgpna" name="looks.rsgpna"/></td>
			                      <td align="right"><button class="button" type="submit"    jraf_initsubmit id="res_group_query">查询</button></td>
			                  </tr>
			                </table>
		   				   </div>
		             </form>
		            </div>
    <div class="pageContent" >
		 <div class="panelBar">
			<ul class="toolBar">
			    <li><a class="add" href="/funcpub/portal/resource/add_resc_group.jsp" height="300" width="500" target="dialog" ><span>新增</span></a></li> 
			   <%--  <li><a class="delete" rel="rsgpid" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sys_res_gp' type='crypto'/>&actions=<sc:fmt value='deleteRsgp' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage_rescgroup.jsp' type='crypto'/>" ><span>删除</span></a></li> --%>
			   <li><a class="delete" onclick="confirmFun()"><span>删除</span></a></li>
				<li class="line">line</li> 
	        </ul>
		</div>	 
		<table class="table" width="100%">
			<thead>
				<tr>
					<th width="25px"><input type="checkbox" class="checkboxCtrl" group="rsgpid" /></th>
					<th>资源组代码</th>
					<th>资源组名称</th>
					<th>资源类型</th>
					<th>所属子系统</th>
					<th>操作</th>
				</tr>
			</thead>
			<tbody>
			<c:forEach var="sysBaseRsgp" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
				<tr >
				    <td><input type="checkbox"  name="rsgpid" value="${sysBaseRsgp.rsgpid}"/></td>
				    <td>${sysBaseRsgp.rsgpid}</td>
				    <td>${sysBaseRsgp.rsgpna}</td>
					<td><sc:optd  name="resctp"  type="knp" key="pcmc,resctp" index="${index.count}"/></td>		
					<td><sc:optd  name="subsys"  type="subsys" index="${index.count}"/></td>
					<td>
						<a class="btnEdit"  target="dialog" 
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
						&oprID=<sc:fmt value='sys_res_gp' type='crypto'/>
						&actions=<sc:fmt value='queryRescGroupById' type='crypto'/>
						&rsgpid=${sysBaseRsgp.rsgpid}&forward=<sc:fmt value='funcpub/portal/resource/update_resc_group.jsp' type='crypto'/>" height="300" width="800" >修改</a>
					
						<a class="btnDel" onclick="confirmFun(${sysBaseRsgp.rsgpid});">删除</a>
							
						<a class="btnKey"  target="dialog" 
						href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>
						&oprID=<sc:fmt value='sys_res_gr' type='crypto'/>
						&actions=<sc:fmt value='querySysResourseGr' type='crypto'/>
						&rescid=${sysBaseRsgp.rsgpid}&resctp=${sysResourse.resctp}&flag=2&forward=<sc:fmt value='/funcpub/portal/resource/grant_sysresourse.jsp' type='crypto'/>" height="650" width="900" >授权</a>
					</td>
				</tr>
			 </c:forEach>
		  </tbody>
		</table>
		<div class="panelBar">
		<div class="pagination" targetType="navTab" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
	</div>  
  </td>        
		</div>	
		            </div>
		        </td>           
		    </tr>
	</table>
 </div>    
</html>
