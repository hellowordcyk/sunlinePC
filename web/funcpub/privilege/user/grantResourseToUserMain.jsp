<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 用户资源授权
 * description: 
 *     1.用户资源授权
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<div class="pageHeader">
	<form  onsubmit="return divSearch(this, 'resclist');" id="grantResourseToUserForm"
	method="post" action="/httpprocesserservlet" rel="pagerForm">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='grantResourceToUserActor' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='getUserGrantedPrivilegeListPage' type='crypto'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/privilege/user/resourceTableData.jsp' />"/>
	    
		<input type="hidden" name="userId" value="${param.userid }"/>
		<input type="hidden" name="pageNum" value="1" />
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
			    <tr>
			    	<td class="form-label">子系统</td>
			        <td class="form-value">
			        	<select id="subsysCode" name="subsysCode" class="required" onchange="initPrivTypeSel(this.value)">
			        	</select>
			        </td> 
			        <td class="form-label">资源类型</td>
				    <td class="form-value">
				    	<select id="privType" name="privType" class="required" onchange="changePrivType()">
			        	</select>
				    </td>
                    <td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <button id="getUserResource" class="querybtn" id="selectChildUserBtn"  type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
                </tr>
                <tr>
				    <td class="form-label">资源名称</td>
				    <td class="form-value"><sc:text name="qName" index="1"/></td>
				</tr>
			</table>
  		</div>
	</form>
</div>
<div class="pageContent">
    <div class="panelBar">
        <ul class="toolBar">
            <li>
            <a class="add" width="600" height="300" href="javascript:openDialog();"><span>授权资源</span></a>
            </li>
            <li>
            <a class="delete" rel="cancel_sel" href="#" name="test22" width="1000" height="300" onclick='javascript:confirmFun22("sel");'>
                <span>取消已选中权限</span>
            </a>
            </li> 
            <li>
            <a class="delete" rel="cancel_all" href="#" name="test22" width="1000" height="300" onclick='javascript:confirmFun22("all");'>
                <span>取消本页权限</span>
            </a>
            </li> 
        </ul>
    </div>
    <div id="resclist" name="resclist">
    	<form id="pagerForm" name="pagerForm" action="#rel#" method="post">
            <sc:hidden name="pageNum" value="1" />
            <table class="table" width="100%">
                <thead>
    	           <th>资源编码</th>
    	           <th>资源名称</th>
    	           <th>操作</th>
                </thead>
                <tbody>
    	            <tr>
    	              <td colspan="3">选择条件查询。</td>
    	            </tr>
                </tbody>
            </table>
         </form>
     </div>
</div>   
<script>
var configs = eval('${jrafrpu.rspPkg.rspDataMap.jsonDataStr}');
var status = "-1";
$(function(){
	initSubsysList();
	initPrivTypeSel();
});

/**
 * 确认提示
 */
function confirmFun22(type) {
	alertMsg.confirm("确定取消授权吗？", {
        okCall: function(){
        	revoke(type);
        }
	});
}

/**
 * 取消资源权限
 */
function revoke(type){
	var res = "[";
	if(type=="all") {
		var all1 = $("#resclist tbody").find(":checkbox");
		if(all1.length < 1) {
			alertMsg.warn("没有资源可以选择！");
			return;
		}
		all1.each(function(i,e){
			res += "{";
			res += "\"privCode\":\"" + $(e).nextAll("#privCode").val() + "\",";
			res += "\"privType\":\"" + $(e).nextAll("#privType").val() + "\",";
			res += "\"subsysCode\":\"" + $(e).nextAll("#subsysCode").val() + "\"";
			res += "},";
		});
	}else if(type="sel"){
		var sels = $("#resclist tbody").find("[checked='checked']:checkbox");
		if(sels.length < 1) {
			alertMsg.warn("请在左边选择资源！");
			return;
		}
		sels.each(function(i,e){
			res += "{";
			res += "\"privCode\":\"" + $(e).nextAll("#privCode").val() + "\",";
			res += "\"privType\":\"" + $(e).nextAll("#privType").val() + "\",";
			res += "\"subsysCode\":\"" + $(e).nextAll("#subsysCode").val() + "\"";
			res += "},";
		});
	}
	
	res = res.substring(0, res.length-1) + "]";
	var privType = $("#privType").val();
	var sysName='<sc:fmt value='funcpub' type='crypto'/>';
	var oprID='<sc:fmt value='grantResourceToUserActor' type='crypto'/>';
	var actions='<sc:fmt value='revokeResourceToUser' type='crypto'/>';
	var userId = '${param.userid}';
	var subsysCode = $("#subsysCode").val();
	var params = {"userId":userId,"privType":privType,"resources":res,"subsysCode":subsysCode};
	var url = "/xmlprocesserservlet?sysName="+sysName+"&oprID="+oprID+"&actions="+actions;
	$.ajax({    
        type:'post',        
        url:url,
        async:false,
        data:params,
        dataType:'XML', 
        success:function(data){   
        	var retMessage = $(data).find('Msg').text();
        	alertMsg.info(retMessage);
        	searchBySel();
        }
    });   
	
}
/**
 * 初始化 子系统
 */
function initSubsysList() {
	var html = '';
	if(configs!=null&&configs.length>0){
		for(var i = 0;i < configs.length;i++) {
			var item = configs[i];
			html += '<option value="' + item.subsysCode +'"' + (item.subsysCode=='pcmc'?' selected=\"selected\"':'') + '>'+item.subsysName+'</option>';
		}
	}else{
		html = '<option value="" title="未授权角色，无关联子系统">--请选择--</option>';
	}
	$("#subsysCode").html(html);
}

/**
 * 初始化权限类型列表
 */
function initPrivTypeSel() {
	var html = '';
	var value = $("#subsysCode").val();
	if(!value.isBlank()){
		for(var i = 0; i < configs.length; i++) {
			var item = configs[i];
			if(value==item.subsysCode) {
				var privList = item.privTypeList;
				for(var j = 0; j < privList.length;j++) {
					var priv = privList[j];
					html += '<option value="' + priv.privType + '">' + priv.privDesc + '</option>';
				}
			}	
		}
	}else{
		html = '<option value="">--请选择--</option>';
	}
	$("#privType").html(html);
	changePrivType();
}

/**
 * 判断 选择条件 是否改变
 */
function changePrivType() {
	var newStatus = $("#subsysCode").val() + "#" + $("#privType").val();
	if(status!="-1" && status!=newStatus){
		searchBySel();
	}
	status = newStatus;
}

/**
 * 根据以选择条件查询
 */
function searchBySel() {
	var $form = $('#grantResourseToUserForm');
	if (!$form.valid()) {
		return;
	}
	$("#grantResourseToUserForm").submit();
}

function closeOpener() {
	searchBySel();
	return true;
}


function openDialog() {
	var subsysCode = $("#subsysCode").val();
	var privType = $("#privType").val();
	var uid = '${param.userid}';
	var url = "/funcpub/privilege/user/grantResourseToUser.jsp?userid1=" + uid + "&subsysCode1="+ subsysCode +'&privType1=' + privType;
	var options={width:800,height:520,mask:true,minable:true,drawable:true,fresh:true,close:closeOpener};
	var dialog = $.pdialog.open(url, "grantResourceToUser", "授权资源", options);
}

</script>