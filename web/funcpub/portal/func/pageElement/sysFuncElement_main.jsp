<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 页面元素管理
 * description: 
 *     1.维护（新增、修改、删除）页面元素信息；
 * author: ZhaoXuePing
 * create time: 
 * logs:
 *--%>
<div class="pageHeader">
	<form id="element_list_ctt_pagerForm" onsubmit="return divSearch(this, 'element_list_ctt')" action="/httpprocesserservlet" method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
		<input type="hidden" name="oprID" value="<sc:fmt value='sysFuncElementActor' type='crypto'/>" />
		<input type="hidden" name="actions" value="<sc:fmt value='querySysFuncElement' type='crypto'/>" />
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/func/pageElement/sysFuncElement_main.jsp'/>" />
		<sc:hidden name="funcPageCode" index="1"/>
			<%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
		<input type="hidden" name="pageNum" value="1" />
		<div class="searchBar" style="display: none;">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
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
	    <div class="page-tip" style="margin:0;">
			<span class="tip-title">温馨提示</span>
			<p>1、页面元素根据功能页面提供的 URL 自动初始化加载；</p>
			<p>2、页面元素未保存配置信息时，默认显示全部未配置的元素；通过右侧【显示未配置的元素】按钮控制元素的显示/隐藏；</p>
			<p>3、元素 ID 为 input 标签的【id】属性；元素 NAME 为 input 标签的【name】属性；</p>
			<p>4、【数据同步】操作可以根据勾选的第一个元素同步其他元素的【元素类型】、【权限】选项；</p>
		</div>
	</form>
</div>
<div class="pageContent" id="element_list_ctt">
    <div class="panelBar">
        <ul class="toolBar">
            <li>
                <a class="add" href="javascript:void(0)" onclick="initElement();" rel="funcElement_init">
                    <span>新增</span>
                </a>
            </li>
            <li>
                <a class="btnSave" href="javascript:void(0)" onclick="addElement();" rel="funcElement_add">
                    <span>批量保存</span>
                </a>
            </li>
            <li>
                <a class="delete" rel="paramp" target="selectedTodo" title="确定要删除所选记录吗?"
                    href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncElementActor' type='crypto'/>&actions=<sc:fmt value='deleteSysFuncElements' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
                    <span>删除</span>
                </a>
            </li>
            <li>
                <a class="btnNormal" href="javascript:void(0)" onclick="syncElement();" rel="funcElement_sync">
                    <span>数据同步</span>
                </a>
            </li>
            <li class="line">line</li> 
        </ul>
        <ul class="toolBar" style="float: right;">
            <li>
                <input id="setElementView" type="checkbox" class="checkboxCtrl" onclick="setElementView();" style="margin-top: 10px;"/>
                <a href="javascript:void(0);" onclick="setElementView('btn');" style="float: right; padding: 10px 0 0 0;">显示未配置的元素</a>
            </li>
        </ul>
    </div>
    <table class="table" cellpadding="0" cellspacing="0" style="table-layout: fixed;">
		<thead>
			<tr>
				<th class="checkbox"><input type="checkbox" class="checkboxCtrl" group="paramp" /></th>
				<th width="15%">元素 ID</th>
				<th width="15%">元素 NAME</th>
				<th width="15%">元素名称</th>
				<th width="12%">元素类型</th>
				<th width="12%">权限</th>
				<th width="15%">元素描述</th>
				<th width="5%">操作</th>
			</tr>
		</thead>
		<tbody id="elementTable">
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr name="noData">
                    <td class="empty" colspan="8">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach var="fet" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
                    <tr id="temp${status.index}" <c:if test="${status.index%2 != 0}">class="evenrow"</c:if>>
                        <td class="checkbox">
                            <input type="checkbox" name="paramp" value="${fet.funcId}"/>
                        	<sc:hidden name="funcInputIsPriv" value="${fet.isPriv}"/>
                        </td>
                        <td>
                        	${fet.funcInputId}
                        	<sc:hidden name="funcInputId" value="${fet.funcInputId}"/>
                        </td>
                        <td>
                        	${fet.funcInputCode}
                        	<sc:hidden name="funcInputCode" value="${fet.funcInputCode}"/>
                        </td>
                        <td>
                        	<sc:text name="funcInputName" value="${fet.funcInputName}" validate="required"/>
                        </td>
                        <td>
                        	<sc:optd name="func_input_type" value="${fet.funcInputType}" type="dict" key="pcmc,form_lable_type"/>
                        	<sc:hidden name="funcInputType" value="${fet.funcInputType}"/>
                        </td>
                        <td>
                        	<sc:select name="funcInputPriv" _class="select" default="5" index="${status.index + 1}" type="dict" key="pcmc,pagePrivCode" validate="required" includeTitle="false"/>
                        </td>
                        <td>
                        	<sc:text name="funcInputDesc" value="${fet.funcInputDesc}" validate="required"/>
                        </td>
                        <td>
                        	<c:if test="${empty fet.funcId}">
                            <a class="btnDel" title="确定要删除所选记录吗?" href="javascript:deleteTr('temp${status.index}');">删除</a>
                            </c:if>
                            <c:if test="${not empty fet.funcId}">
                            <a class="btnDel" title="确定要删除所选记录吗?" target="ajaxTodo"
                                href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncElementActor' type='crypto'/>&actions=<sc:fmt value='deleteSysFuncElement' type='crypto'/>&funcId=${fet.funcId}&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">删除
                            </a>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="navTab" rel="element_list_ctt" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
		</div>
	</div>
</div>
<div id="init_tr_div" style="display: none;">
	<table class="table" cellpadding="0" cellspacing="0">
		<tr id="#tempid#">
			<td class="checkbox">
				<input type="checkbox" name="paramp" value=""/>
				<input type="hidden" name="funcInputIsPriv" value=""/>
			</td>
			<td><sc:text name="funcInputId" validate="required" /></td>
			<td><sc:text name="funcInputCode" validate="required" /></td>
            <td><sc:text name="funcInputName" validate="required"/></td>
            <td><sc:select name="funcInputType" _class="select" default="1" type="dict" key="pcmc,form_lable_type" validate="required" includeTitle="false"/></td>
            <td><sc:select name="funcInputPriv" _class="select" default="5" type="dict" key="pcmc,pagePrivCode" validate="required" includeTitle="false"/></td>
            <td><sc:text name="funcInputDesc" validate="required"/></td>
            <td><a class="btnDel" title="确定要删除所选记录吗?" href="javascript:deleteTr('#tempid#');">删除</a></td>
		</tr>
	</table>
</div>
<script>

	$(document).ready(function(){
		setElementView();//初始化加载元素
	});
	
	function initElement(){
		var noData = $("#elementTable [name='noData']", navTab.getCurrentPanel()).remove();
		var obj = $("#elementTable", navTab.getCurrentPanel());
		var initTR = $("#init_tr_div tbody", navTab.getCurrentPanel()).html();
		var index = obj.children().length;
		initTR = initTR.replaceAll("#tempid#", "temp" + index);
		obj.append(initTR);
	}
	
	function deleteTr(index){
		if(index != undefined){
			$("#" + index, navTab.getCurrentPanel()).remove();
		}
	}
	
	function addElement(){
		if($("#elementTable input[name='paramp']:checked", navTab.getCurrentPanel()).length <= 0){
			alertMsg.error("请选择信息！");
			return;
		}
		var objs = $("#elementTable input[name='paramp']", navTab.getCurrentPanel());
		var ids = $("#elementTable [name='funcInputId']", navTab.getCurrentPanel());
		var codes = $("#elementTable [name='funcInputCode']", navTab.getCurrentPanel());
		var names = $("#elementTable input[name='funcInputName']", navTab.getCurrentPanel());
		var types = $("#elementTable [name='funcInputType']", navTab.getCurrentPanel());
		var privs = $("#elementTable select[name='funcInputPriv']", navTab.getCurrentPanel());
		var descs = $("#elementTable input[name='funcInputDesc']", navTab.getCurrentPanel());
		var isPrivs = $("#elementTable input[name='funcInputIsPriv']", navTab.getCurrentPanel());
		
		var keyArray = new Array();
		var idArray = new Array();
		var codeArray = new Array();
		var nameArray = new Array();
		var typeArray = new Array();
		var privArray = new Array();
		var descArray = new Array();
		var isPrivArray = new Array();
		
		var flag = false;
		$.each(objs, function(i, n){
			var tempID = ids.eq(i).val();
			var tempNAME = codes.eq(i).val();
			if($(this).is(":checked")){
				if(((tempID == "" || tempID.length <= 0) && (tempNAME == "" || tempNAME.length <= 0)) 
						|| ids.eq(i).hasClass("error")){
					flag = true;
					return false;
				}
				keyArray.push($(this).val());
				idArray.push(ids.eq(i).val());
				codeArray.push(codes.eq(i).val());
				nameArray.push(names.eq(i).val());
				typeArray.push(types.eq(i).val());
				privArray.push(privs.eq(i).val());
				descArray.push(descs.eq(i).val());
				isPrivArray.push(isPrivs.eq(i).val());
			}
		});
		
		if(flag){
			alertMsg.error("提交失败，【元素 ID】或【元素 NAME】有错误，请检查后再提交!");
			return;
		}
		
		var funcPageCode = $("input[name='funcPageCode']", navTab.getCurrentPanel()).val();
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
				+ "&oprID=<sc:fmt value='sysFuncElementActor' type='crypto'/>"
				+ "&actions=<sc:fmt value='addSysFuncElement' type='crypto'/>"
				+ "&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>";
		$.ajax({
			type: 'POST',
			url: url,
			dataType: 'XML',
			async: false,
			data:{
				"keyArray": keyArray.join(","), "idArray": idArray.join(","), 
				"codeArray": codeArray.join(","), "nameArray": nameArray.join(","), 
				"typeArray": typeArray.join(","), "privArray": privArray.join(","), 
				"descArray": descArray.join(","), "isprivArray": isPrivArray.join(","), "funcPageCode": funcPageCode
			},
			success: function(data) {
				var retCode = $(data).find("DataPacket Response Data retCode").text();
				var retMsg = $(data).find("DataPacket Response Data retMessage").text();
				if("200"==retCode) {
					alertMsg.correct(retMsg);
				}else{
					alertMsg.error(retMsg);
				}
				$("#element_list_ctt_pagerForm", navTab.getCurrentPanel()).find(".querybtn").first().click();
			},
			error: DWZ.ajaxError
		});
	}

	function setElementView(param){
		var obj = $("#setElementView", navTab.getCurrentPanel());
		var objs = $("#elementTable input[name='paramp']", navTab.getCurrentPanel());
		
		if("btn" == param){
			obj.attr("checked", obj.attr("checked") ? false : true);
		}
		
		$.each(objs, function(index){
			$(this).removeAttr("disabled");
			//判断已选中或者已配置元素数为0的情况下
			if (obj.attr('checked') || objs.eq(0).val() == "undefined" || objs.eq(0).val() == null || 
					(objs.eq(0).val() != "undefined" && objs.eq(0).val().length <= 0) ) {
				$("#temp" + index, navTab.getCurrentPanel()).show();
				obj.attr("checked", true);
			}else{
				if($(this).val() == null || $(this).val() == "undefined" || $(this).val().length <= 0){
					$("#temp" + index, navTab.getCurrentPanel()).hide();
					$(this).attr("disabled", "disabled");
					obj.attr("checked", false);
				}
			}
		});
	}
	
	function checkExist(numb){
		var ids = $("#elementTable input[name='funcInputId']", navTab.getCurrentPanel());
		var cur = ids.eq(numb);
		if(cur.val().length <= 0) return false;
		ids.splice(numb, 1);
		$.each(ids, function(index){
			if($(this).val() == cur.val()){
				alertMsg.error("元素ID已存在，请重新输入！");
				cur.addClass("error");
				return false;
			}else{
				cur.removeClass("error");
			}
		});
	}
	
	function syncElement(){
		var objs = $("#elementTable input[name='paramp']", navTab.getCurrentPanel());
		var checks = $("#elementTable input[name='paramp']:checked", navTab.getCurrentPanel());
		var inputTypes = $("input[name='funcInputType']", navTab.getCurrentPanel());
		var selectTypes = $("select[name='funcInputType']", navTab.getCurrentPanel());
		var privs = $("#elementTable select[name='funcInputPriv']", navTab.getCurrentPanel());

		var tempObj = null;
		var tempPriv = "";
		
		var tempType = "";
		var tempTypeName = "";
		$.each(objs, function(i){
			if($(this).attr('checked')){
				if(null == tempObj){
					tempObj = $(this);
					tempPriv = privs.eq(i).val();
					tempType = inputTypes.eq(i).val();
					tempTypeName = selectTypes.find("option[value='"+tempType+"']").html();
				}
				privs.eq(i).val(tempPriv);
				//同步节点类型
				inputTypes.eq(i).closest("div").attr("title",tempTypeName);
				var inputTypehtml = tempTypeName+"<input type='hidden' name='funcInputType' value='"+tempType+"' />";
				inputTypes.eq(i).closest("div").html(inputTypehtml);
			}
		});
	}
</script>