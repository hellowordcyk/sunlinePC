<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 标签权限配置页面
 * description: 
 *     1.修改每一个权限标签的权限值
 * author: daoge
 * createtime: 2016.12.6
 * logs:
 *--%>
<style>
   img{
   	border:none;
   }
   .priv_info{
	   	width:99%;
	   	height:50px;
   }
   .priv_info label{
   		display:block;
   		width:130px;
   		height:50px;
   	   line-height:50px;
   	   margin-left:20px;
   	   float:left;
   }
   .priv_info label img{
   	   margin-top:25px;
   }
   .td_color{
   	   background-color: #f1feff !important;
   }
</style>
<div class="pageHeader">
    <form id="data_priv_ctt_pagerForm" onsubmit="return divSearch(this, 'data_priv_ctt');"  method="post"
        action="/httpprocesserservlet">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
        <input type="hidden" name="oprID" value="<sc:fmt value='privDataActor' type='crypto'/>"/>
        <input type="hidden" name="actions" value="<sc:fmt value='queryPrivInfo' type='crypto'/>"/>
        <input type="hidden" name="forward" value="<sc:fmt value='/funcpub/privilege/sysprivdata/priv_grant.jsp' type='crypto'/>"/>
        <sc:hidden name="roleId" value="${jrafrpu.rspPkg.reqDataMap.roleId}"/>
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0" >
                <tr>
                    <td class="form-label">实体编码</td>
                    <td class="form-value"><sc:text name="entityCode"/></td>
                    <td class="form-label">实体名称 </td>
                    <td class="form-value"><sc:text name="entityName"/></td> 
                    <td class="form-btn">
                        <ul>
                            <li><button class="querybtn"  type="submit">查询</button></li>
                            <li><button class="resetbtn" type="reset">清空</button></li>
                        </ul>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</div>

<form class="pageForm required-validate" onsubmit="return validateCallback(this,navTabAjaxDone)" method="post"
     action="/httpprocesserservlet">
    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
    <input type="hidden" name="oprID" value="<sc:fmt value='privDataActor' type='crypto'/>"/>
    <input type="hidden" name="actions" value="<sc:fmt value='grant' type='crypto'/>"/>
    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" />
	<sc:hidden name="systemCode" index="1"/>
	<sc:hidden name="roleId" value="${jrafrpu.rspPkg.reqDataMap.roleId}"/>
	<div class="pageContent" style="padding-bottom:20px; margin-top:10px;">
		<table class="table" cellpadding="0" layoutH="250" cellspacing="0" style="width:100%;margin:0px auto;line-height:30px;">
			<thead>
				<tr>
				    <th width="13%"  style="text-align:center;" >实体编码</th>
					<th width="13%"  style="text-align:center;" >实体名称</th>
					<th width="8%"></th>
					<th width="8%" style="text-align:center;">新增
						<input type="hidden" name="is_grantValCol" value="0"/>
                    	<input type="hidden" name="old_grantValCol" value="0"/>
                        <input type="hidden" name="currentval" value="0"/>
                    	<br>
                    	<label>
                    		<img id="val_0" onclick="grantValCol(event,0)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
                    	</label>
					</th>
					<th width="8%" style="text-align:center;">查看
						<input type="hidden" name="is_grantValCol" value="0"/>
                    	<input type="hidden" name="old_grantValCol" value="0"/>
                    	 <input type="hidden" name="currentval" value="0"/>
                    	<br>
                    	<label>
                    		<img id="val_0" onclick="grantValCol(event,1)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
                    	</label>
					</th>
					<th width="8%" style="text-align:center;">修改
						<input type="hidden" name="is_grantValCol" value="0"/>
                    	<input type="hidden" name="old_grantValCol" value="0"/>
                    	 <input type="hidden" name="currentval" value="0"/>
                    	<br>
                    	<label>
                    		<img id="val_0" onclick="grantValCol(event,2)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
                    	</label>
					</th>
					<th width="8%" style="text-align:center;">删除
						<input type="hidden" name="is_grantValCol" value="0"/>
                    	<input type="hidden" name="old_grantValCol" value="0"/>
                    	 <input type="hidden" name="currentval" value="0"/>
                    	<br>
                    	<label>
                    		<img id="val_0" onclick="grantValCol(event,3)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
                    	</label>
					</th>
					<th width="8%" style="text-align:center;">分派
						<input type="hidden" name="is_grantValCol" value="0"/>
                    	<input type="hidden" name="old_grantValCol" value="0"/>
                    	 <input type="hidden" name="currentval" value="0"/>
                    	<br>
                    	<label>
                    		<img id="val_0" onclick="grantValCol(event,4)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
                    	</label>
					</th>
					<th width="8%" style="text-align:center;">共享
						<input type="hidden" name="is_grantValCol" value="0"/>
                    	<input type="hidden" name="old_grantValCol" value="0"/>
                    	 <input type="hidden" name="currentval" value="0"/>
                    	<br>
                    	<label>
                    		<img id="val_0" onclick="grantValCol(event,5)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
                    	</label>
					</th>
				</tr>
			</thead>
			<tbody id="priv_table">
				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMaps}" varStatus="status">
					<tr style="height:30px;line-height:30px;">
					   <td class="form-label" style="text-align:center;">
	                    	${item.entityCode}
	                    </td>
	                    <td class="form-label" style="text-align:center;">
	                    	<input type="hidden" name="entity_id" value="${item.entityCode}#${item.systemCode}"/>
	                    	${item.entityName}
	                    </td>
	                    <td class="form-value" style="text-align:center;">
	                    	<input type="hidden" name="is_grantValRow" value="0"/>
	                    	<input type="hidden" name="old_grantValRow" value="0"/>
	                    	<input type="hidden" name="currentval" value="0"/>
	                    	<label>
	                    		<img id="val_0"  onclick="grantValRow(event)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
	                    	</label>
	                    </td>
	                    <td class="form-value" style="text-align:center;">
	                        <input type="hidden" name="isInsert" value="${item.isInsert}"/>
	                        <input type="hidden" name="old_isInsert" value="${item.isInsert}"/>
	                        <input type="hidden" name="currentval" value="${item.isInsert}"/>
	                        <label >
	                        	<c:choose>
	                        		<c:when test="${empty item.isInsert or item.isInsert eq '0'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isInsert eq '1'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_B.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isInsert eq '2'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_L.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isInsert eq '3'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_D.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isInsert eq '4'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_G.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isInsert eq '5'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_O.gif" />
	                        		</c:when>
	                        	</c:choose>
	                        </label>
	                    </td>
	                    <td class="form-value" style="text-align:center;">
	                        <input type="hidden" name="isRead" value="${item.isRead}"/>
	                        <input type="hidden" name="old_isRead" value="${item.isRead}"/>
	                        <input type="hidden" name="currentval" value="${item.isRead}"/>
	                        <label >
	                        	<c:choose>
	                        		<c:when test="${empty item.isRead or item.isRead eq '0'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isRead eq '1'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_B.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isRead eq '2'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_L.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isRead eq '3'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_D.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isRead eq '5'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_O.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isRead eq '4'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_G.gif" />
	                        		</c:when>
	                        	</c:choose>
	                        </label>
	                    </td>
	                    <td class="form-value" style="text-align:center;">
	                        <input type="hidden" name="isUpdate" value="${item.isUpdate}"/>
	                        <input type="hidden" name="old_isUpdate" value="${item.isUpdate}"/>
	                        <input type="hidden" name="currentval" value="${item.isUpdate}"/>
	                        <label >
	                        	<c:choose>
	                        		<c:when test="${empty item.isUpdate or item.isUpdate eq '0'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isUpdate eq '1'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_B.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isUpdate eq '2'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_L.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isUpdate eq '3'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_D.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isUpdate eq '5'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_O.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isUpdate eq '4'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_G.gif" />
	                        		</c:when>
	                        	</c:choose>
	                        </label>
	                    </td>
	                    <td class="form-value" style="text-align:center;">
	                        <input type="hidden" name="isDelete" value="${item.isDelete}"/>
	                        <input type="hidden" name="old_isDelete" value="${item.isDelete}"/>
	                         <input type="hidden" name="currentval" value="${item.isDelete}"/>
	                        <label>
	                        	<c:choose>
	                        		<c:when test="${empty item.isDelete or item.isDelete eq '0'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isDelete eq '1'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_B.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isDelete eq '2'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_L.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isDelete eq '3'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_D.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isDelete eq '5'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_O.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isDelete eq '4'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_G.gif" />
	                        		</c:when>
	                        	</c:choose>
	                        </label>
	                    </td>
	                    <td class="form-value" style="text-align:center;">
	                        <input type="hidden" name="isTransfer" value="${item.isTransfer}"/>
	                        <input type="hidden" name="old_isTransfer" value="${item.isTransfer}"/>
	                         <input type="hidden" name="currentval" value="${item.isTransfer}"/>
	                        <label>
	                        	<c:choose>
	                        		<c:when test="${empty item.isTransfer or item.isTransfer eq '0'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isTransfer eq '1'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_B.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isTransfer eq '2'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_L.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isTransfer eq '3'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_D.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isTransfer eq '5'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_O.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isTransfer eq '4'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_G.gif" />
	                        		</c:when>
	                        	</c:choose>
	                        </label>
	                    </td>
	                    <td class="form-value" style="text-align:center;">
	                        <input type="hidden" name="isShare" value="${item.isShare}"/>
	                        <input type="hidden" name="old_isShare" value="${item.isShare}"/>
	                         <input type="hidden" name="currentval" value="${item.isShare}"/>
	                        <label>
	                        	<c:choose>
	                        		<c:when test="${empty item.isShare or item.isShare eq '0'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_X.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isShare eq '1'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_B.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isShare eq '2'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_L.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isShare eq '3'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_D.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isShare eq '5'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_O.gif" />
	                        		</c:when>
	                        		<c:when test="${item.isShare eq '4'}">
	                        			<img id="val_0"  onclick="grantVal(event)" src="/common/func-images/priv_icon/ico_18_role_G.gif" />
	                        		</c:when>
	                        	</c:choose>
	                        </label>
	                    </td>
	                </tr>
	            </c:forEach>
	        </tbody>
		</table>
		<div class="priv_info">
			<label>
				<img id="show_val_0" src="/common/func-images/priv_icon/ico_18_role_X.gif"/>
				未选择内容
			</label>
			<label>
           		<img id="show_val_1" src="/common/func-images/priv_icon/ico_18_role_B.gif" />
           		用户
           	</label>
           	<label>
           		<img id="show_val_2" src="/common/func-images/priv_icon/ico_18_role_L.gif" />
           		业务部门
           	</label>
           	<label>
           		<img id="show_val_3" src="/common/func-images/priv_icon/ico_18_role_D.gif"/>
           		上/下级部门
           	</label>
           	<label>
           		<img id="show_val_5" src="/common/func-images/priv_icon/ico_18_role_O.gif"/>
           		组织
           	</label>
           	<label>
           		<img id="show_val_4" src="/common/func-images/priv_icon/ico_18_role_G.gif" />
           		机构
           	</label>
		</div>
	</div>
	<div class="formbutton_bg" >
		<ul>		
			<li><button class="savebtn" type="button" onclick="submitData()">保存</button></li>
		</ul>
	</div>
</form>
<div id="privTypeTemplateId" style="display: none">
	<span id="sel_#privtype">
		<input type="hidden" name="#entity" />
		<sc:select name="#privtype" />
		
	</span>
</div>
<script type="text/javascript">
	var pageScope = navTab.getCurrentPanel().find("#data_priv_ctt");
	var privValArr = new Array("isInsert","isRead","isUpdate","isDelete","isTransfer","isShare");
	var srcArr = new Array("/common/func-images/priv_icon/ico_18_role_X.gif","/common/func-images/priv_icon/ico_18_role_B.gif","/common/func-images/priv_icon/ico_18_role_L.gif","/common/func-images/priv_icon/ico_18_role_D.gif","/common/func-images/priv_icon/ico_18_role_O.gif","/common/func-images/priv_icon/ico_18_role_G.gif");
	$(function() {
		/* $("#priv_table tr",pageScope).each(function(i,e) {
			for(var t in privValArr) {
				var currentValElm = $(e).find("input[name='"+privValArr[t]+"']").first();
				var currentVal = currentValElm.val();
				if(currentVal==null||currentVal.length<1) {
					currentVal = 0;
				}else{
					currentVal = parseInt(currentVal);
				}
				var time = new Date().getTime();
				currentValElm.nextAll("label").find("img").first().attr("src",srcArr[currentVal]+"?t="+time);
			}
		}); */
	});
	
	function grantVal(event) {

	    var currentValElm=$(event.target).parent("label").prevAll("input[name^=is]").first();
	    var currentValRel =$(event.target).parent("label").prevAll("input[name=currentval]").first();
	    var currentValStr=currentValRel.val()?currentValRel.val():'0';
	    var currentVal=parseInt(currentValStr);
		var old_val=$(event.target).parent("label").prevAll("input[name^=old_]").first().val();
		var $td = $(event.target).closest("td");
		var chageVal=0;
		
		if(old_val==null||old_val.length<1) {
			old_val = 0;
		}else{
			old_val = parseInt(old_val);
		}
		currentVal++;
		//初始进入，新循环开始，重置值
		if(old_val==5 && currentVal>5){
			currentVal=5;
			chageVal=5;
			$(event.target).parent("label").prevAll("input[name^=old_]").first().val(0);
		}
		if(currentVal>5){
			currentVal=0;
			chageVal=0;
		}else{
			if(currentVal==5){
				chageVal=4;
			}
			if(currentVal==4){
				chageVal=5;
			}
			if(currentVal<=3){
				chageVal=currentVal;
			}
		}
		currentValElm.val(chageVal);
		var t = new Date().getTime();
	 	$(event.target).attr("src",srcArr[currentVal]+"?t="+t);
		if(old_val!=chageVal) {
			addColorToTd($td);
		}else{
			clearColorToTd($td);
		}
		currentValRel.val(currentVal);
	}
	function grantValRow(event){
	    var currentValRel =$(event.target).parent("label").prevAll("input[name=currentval]").first().val();
		$(event.target).closest("tr").find("input[name=currentval]").val(currentValRel);
		$(event.target).closest("tr").find("img").each(function(i,img){
			var e = {};
			e.target = img;
			grantVal(e);
		});
	}
	function grantValCol(event,index){
		 var currentValRel =$(event.target).parent("label").prevAll("input[name=currentval]").first().val();
		$(event.target).closest(".pageContent").find("tr").each(function(i,tr){
			var $td = $($(tr).find("th,td")[index+3]);
			if($td && $td.length>0){
				$td.find("input[name=currentval]").val(currentValRel);
				var e = {};
				e.target = $td.find("img")[0];
				if(e.target){
					grantVal(e);
				}
			}
		});
		
	}
	
	function addColorToTd(tdElm) {
		tdElm.addClass("td_color");
	}
	
	function clearColorToTd(tdElm) {
		tdElm.removeClass("td_color");
	}
	
	function reloadTab() {
		pageScope.closest("div.tabs").find("div.tabsHeader").find("li").find("a#data_priv_tab").click();
	}
	
	function submitData() {
		var roleId = $("input[name='roleId']",pageScope).val();
		var privData = "";
		$("#priv_table tr",pageScope).each(function(i,e) {
			var entity_id = $(e).find("input[name='entity_id']").val();
			var val_str = "";
			for(var t in privValArr) {
				var currentValElm = $(e).find("input[name='"+privValArr[t]+"']").first();
				var currentVal = currentValElm.val();
				if(currentVal==null||currentVal.length<1) {
					currentVal = 0;
				}
				
				var old_val = $(e).find("input[name='old_"+privValArr[t]+"']").first().val();
				if(old_val==null||old_val.length<1) {
					old_val = 0;
				}
				if(currentVal!=old_val) {
					val_str+= privValArr[t]+"#"+currentVal+";";
				}
			}
			if(val_str.length>0) {
				privData += entity_id + "$"+val_str.substring(0,val_str.length-1);
				privData+="@";
			}
		});
		if(privData.length>1) {
			privData = privData.substring(0,privData.length-1);
		}else{
			alertMsg.error("权限值没有改变！");
			return;
		}
		var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
			+"&oprID=<sc:fmt value='privDataActor' type='crypto'/>"
			+"&actions=<sc:fmt value='grant' type='crypto'/>";
		$.ajax({    
	        type:'post',        
	        url:url,
	        data:{'privData':privData,'roleId':roleId},
	        async:false,   
	        dataType:'xml', 
	        success:function(data){   
				var retCode = $(data).find("DataPacket Response Data retCode").text();
				var retMsg = $(data).find("DataPacket Response Data retMessage").text();
				if("200"==retCode) {
					alertMsg.correct(retMsg);
					reloadTab();   // 提交成功，刷新页面
				}else{
					alertMsg.error(retMsg);
				}
	        }
	    });
	}
</script>