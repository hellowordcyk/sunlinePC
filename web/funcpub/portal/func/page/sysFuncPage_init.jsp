<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 初始化系统功能页面
 * description: 
 *     1.初始化系统功能页面
 * author: 
 * createtime: 
 * logs:
 *--%>
<div class="pageHeader">
	<form id="pagerForm" onsubmit="return dialogSearch(this);" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='sysFuncPageActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='initSystemPageFile' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/func/page/sysFuncPage_init.jsp' />" />
	  	<sc:hidden name="selected" value="${jrafrpu.rspPkg.rspDataMap.selected}"/>
		<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
        
		<div class="searchBar">
			<sc:hidden name="pageNum"/>
			
			<table class="searchContent">
			    <tr>
					<td class="form-label"><span class="redmust">*</span>子系统名称</td>
					<td class="form-value">
				    	<sc:select id="subsysId" name="subsys" type="subsyscd" req="1" nullOption ="--请选择子系统--" validate="required"/>
				    </td>
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
<div class="pageContent" >
	<div class="panelBar">
		<ul class="toolBar">
            <li>
                <a class="btnSave" href="javascript:submitPages();" rel="page_save">
                    <span>批量保存</span>
                </a>
            </li>
			<li class="line">line</li>
		</ul>
	</div>
    <table id="page_table" class="table" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th width="5%">序号</th>
				<th width="25%">页面名称</th>
				<th width="60%">页面路径</th>
			</tr>
		</thead>
		<tbody id="page_contents">
           <c:choose>
               <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                   <tr>
                       <td class="empty" colspan="4">查询无数据。</td>
                   </tr>
               </c:when>
               <c:otherwise>
   				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMaps}"  varStatus="index">
   					<tr <c:if test="${index.index%2 != 0}"> class="evenrow"</c:if> >
   						<td class="checkbox">
   							<input type="checkbox" name="paramp" value=""/>
   							<input type="hidden" name="param_name" value="${item.name}"/>
   							<input type="hidden" name="param_path" value="${item.path}"/>
   						</td>
   						<td>${index.index + 1}</td>
   						<td>${item.name}</td>
   						<td>${item.path}</td>
   					</tr>
   				</c:forEach>
               </c:otherwise>
           </c:choose>
		</tbody>
	</table>
	
	<div class="panelBar">
		<div rel="" class="pagination" targetType="dialog" 
			totalCount="${jrafrpu.rspPkg.rspRecordCount}" 
			numPerPage="${jrafrpu.rspPkg.rspPageSize }" 
			currentPage="${jrafrpu.rspPkg.rspPageNo}">
		</div>
	</div>	
</div>

<script>
	function submitPages(){
		var objs = $("#page_contents input[name='paramp']", $.pdialog.getCurrent());
		var names = $("#page_contents input[name='param_name']", $.pdialog.getCurrent());
		var paths = $("#page_contents input[name='param_path']", $.pdialog.getCurrent());
		
		if(objs.length <= 0){
			alertMsg.error("请选择信息！");
			return;
		}
		
		var nameArray = new Array();
		var pathArray = new Array();
		
		$.each(objs, function(i, n){
			if($(this).attr('checked')){
				nameArray.push(names.eq(i).val());
				pathArray.push(paths.eq(i).val());
			}
		});
		
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='sysFuncPageActor' type='crypto'/>"
				+ "&actions=<sc:fmt value='addSysFuncPages' type='crypto'/>"
				+ "&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>";
		$.ajax({
			type: 'POST',
			url: url,
			dataType: 'XML',
			async: false,
			data:{"nameArray": nameArray.join(","), "pathArray": pathArray.join(",")},
			success: function(data) {
				var retCode = $(data).find("DataPacket Response Data retCode").text();
				if("200"==retCode) {
					alertMsg.correct("保存成功！", {
						   okCall: function(){
							   $.pdialog.closeCurrent();
						   }
						});
				}else{
					alertMsg.error("保存失败！");
				}
			},
			error: DWZ.ajaxError
		});
	}
</script>