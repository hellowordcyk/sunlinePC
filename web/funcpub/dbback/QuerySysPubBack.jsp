<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 库备份配置管理
 * description: 
 *     1.库备份配置管理
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>
<div class="pageHeader">
	<form onsubmit="return navTabSearch(this);" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysPubBack' type='crypto'/>&actions=<sc:fmt value='querySysPubBack' type='crypto'/>&forward=<sc:fmt value='/funcpub/dbback/QuerySysPubBack.jsp' type='crypto'/>" method="post">
	<input type="hidden" name="pageNum" value="1" />
        <%-- 规范： 初始化查询必加隐藏表单 --%>
       <sc:hidden name="jraf_initsubmit"/>
	<div class="searchBar">
		<table class="searchContent" cellpadding="0" cellspacing="0" >
		    <tr>
			    <td class="form-label">功能类型</td>
			    <td class="form-value"><sc:select name="functype1"  type="dict" excludes='%' key="pcmc,funcType" nullOption ="---请选择----"/></td>
			    <td class="form-label">数据库类型</td>
			    <td class="form-value"><sc:select name="dbtype1" type="dict" excludes='%' key="pcmc,dbType" nullOption ="---请选择----"/></td>
			     <td class="form-btn">
                    <ul>
                        <li>
                            <button class="querybtn" jraf_initsubmit type="submit">查询</button>
                        </li>
                        <li>
                            <button class="resetbtn" type="reset">清空</button>
                        </li>
                    </ul>
                </td>
		    </tr>
	    </table>
	    
    </div>
	</form>
</div>
<div class="pageContent">
	<div class="panelBar">
		<ul class="toolBar">
			<li><a class="add" href="/funcpub/dbback/AddSysPubBack.jsp" height="400" width="800" target="dialog"><span>新增</span></a></li>
            <li><a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysPubBack' type='crypto'/>&actions=<sc:fmt value='deleteSysPubBack' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" ><span>删除</span></a></li>
           <%--  <li><a class="edit" rel="QuerySysPubBack" target="dialog" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysPubBack' type='crypto'/>&actions=<sc:fmt value='querySysPubBackupdate' type='crypto'/>&paramp={paramp1}&forward=<sc:fmt value='/funcpub/dbback/updateSysPubBack.jsp' type='crypto'/>" height="300" width="800"  ><span>修改</span></a></li> --%>
			<li class="line">line</li> 
        </ul>
	</div>	
	<table class="table list" width="100%" >
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th width="10%">功能类型</th>
				<th width="10%">数据库类型</th>
				<th>对应语句</th>
				<th>语句参数名称</th>
				<th>语句参数默认值</th>
				<th width="15%">操作</th>
			</tr>
		</thead>
		<tbody>
            <c:choose>
                <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                    <tr>
                        <td class="empty" colspan="7">查询无数据。</td>
                    </tr>
                </c:when>
                <c:otherwise>
        			<c:forEach var="post" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="TableClearindex">
        				<tr <c:if test="${TableClearindex.index%2 != 0}"> class="evenrow"</c:if> >
        					<td class="checkbox"><input type="checkbox"  name="paramp" value="${post.functype}-${post.dbtype}"/></td>
        				    <td><sc:optd type="dict"  key="pcmc,funcType" value="${post.functype}"/></td>
        					<!--<td>${post.funcname}</td>   -->
        					<td>${post.dbname}</td>
        					<td>${post.exesql}</td>
        					<td>${post.paraname}</td>
        					<td>${post.paravalue}</td>
        					<td>
        						<a  class="btnEdit" rel="QuerySysPubBack" target="dialog" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysPubBack' type='crypto'/>&actions=<sc:fmt value='querySysPubBackupdate' type='crypto'/>&paramp=${post.functype}-${post.dbtype}&forward=<sc:fmt value='/funcpub/dbback/updateSysPubBack.jsp' type='crypto'/>" height="400" width="800" >修改</a>
        						
        				        <a title="删除" href="javascript:delspecialnessRectify('${post.functype}-${post.dbtype}');" class="btnDel">删除</a>
        					</td>
        				</tr>
        			</c:forEach>
                </c:otherwise>
            </c:choose>
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
<script type="text/javascript">
/* 	function delRole(){
		var str=document.getElementsByName("paramp");
		for (i=0;i<str.length;i++){ 
			if(str[i].value == '1' && str[i].checked == true){
				alert("系统管理员角色不可删除！");
				return false;
				}
			}
		} */
		
	function delspecialnessRectify(paramp){
		alertMsg.confirm("您确定要删除所选记录吗?", {
	        okCall:function(){
	        	var url = "/xmlprocesserservlet?"
	        		+ "sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
	        		+ "&oprID="+'<sc:fmt value='sysPubBack' type='crypto'/>'
	        		+ "&actions="+'<sc:fmt value='deleteSysPubBack' type='crypto'/>'
	        		+ "&paramp="+paramp;
	        	$.ajax({
	     	       type: "POST",
	     	       url: url,
	     	       dataType : "xml",
	     	       success: function(data){
	     	    	  var code = $(data).find("DataPacket Response Data retCode").text();
	     	    	  var msg = $(data).find("DataPacket Response Data retMessage").text();
	     	    	  if(code=="200"){
	     	    		 alertMsg.correct(msg);
	     	    		 navTab.reload();	
	     	    	  }else{
	     	    		 alertMsg.error(msg);
	     	    	  }
	     	       }
	     		}); 
	        }
		});
	}			
</script>
</html>