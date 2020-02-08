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

 <c:choose>
	 <c:when test="${jrafrpu.rspPkg.rspDataMap.retCode eq '300'}">
	 	<script type="text/javascript">
	 		alertMsg.error('${jrafrpu.rspPkg.rspDataMap.retMessage}');
	 		$.pdialog.close($.pdialog.getCurrent());
	 	</script>
	 </c:when>
	 <c:otherwise>
	 	<form class="pageForm required-validate" onbeforesubmit="checkInfo()" onsubmit="return validateCallback(this,dialogAjaxDone)" method="post"
		     action="/httpprocesserservlet">
		    <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		    <input type="hidden" name="oprID" value="<sc:fmt value='privShareActor' type='crypto'/>"/>
		    <input type="hidden" name="actions" value="<sc:fmt value='share' type='crypto'/>"/>
		    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" />
			<c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMapsResults1  }">
				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMapsResults1}" varStatus="status">
					<input type="hidden" name="pkval" value="${item.pkval }"/>
				</c:forEach>
			</c:if>
			<c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMapsResults2  }">
				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMapsResults2}" varStatus="status">
					<input type="hidden" name="pkvala" value="${item.pkvala }"/>
				</c:forEach>
			</c:if>
			<c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMapsResults3  }">
				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMapsResults3}" varStatus="status">
					<input type="hidden" name="pkvalb" value="${item.pkvalb }"/>
				</c:forEach>
			</c:if>
			<c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMapsResults4  }">
				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMapsResults4}" varStatus="status">
					<input type="hidden" name="pkvalc" value="${item.pkvalc }"/>
				</c:forEach>
			</c:if>
			<c:if test="${not empty jrafrpu.rspPkg.rspRcdDataMapsResults5  }">
				<c:forEach var="item" items="${jrafrpu.rspPkg.rspRcdDataMapsResults5}" varStatus="status">
					<input type="hidden" name="pkvald" value="${item.pkvald }"/>
				</c:forEach>
			</c:if>
			<sc:hidden name="entity" index="1"/>
			<sc:hidden name="privData" value=""/>
			<div class="pageContent" style="padding-bottom:20px; margin-top:10px;">
				<div class="panelBar">
			        <ul class="toolBar">
			            <li>
							<sc:hidden name="selectedCodes" id="selectedCodes"/>
		                    <sc:hidden name="selectedNames"  />
		                    <a class="add" title="选择分享人员" lookupGroup=""  width="900" height="500" close="addPerson" noclear=""
		                     href="/funcpub/public/deptuser/userTreeUnFilterDialog.jsp?lookupcode=selectedCodes&lookupname=selectedNames&elmId={selectedCodes}"><span>选择分享人员</span></a>
						</li>
					</ul>
				</div>
				<table class="list" cellpadding="0" cellspacing="0" style="width:96%;">
					<thead>
						<tr>
							<th>分享人员</th>
							<th><input type="checkbox" class="checkboxCtrl" group="isInsert" />新增</th>
							<th><input type="checkbox" class="checkboxCtrl" group="isRead" />查看</th>
							<th><input type="checkbox" class="checkboxCtrl" group="isUpdate" />修改</th>
							<th><input type="checkbox" class="checkboxCtrl" group="isDelete" />删除</th>
							<th><input type="checkbox" class="checkboxCtrl" group="isTransfer" />分派</th>
							<th><input type="checkbox" class="checkboxCtrl" group="isShare" />共享</th>
							<th>操作</th>
						</tr>
					</thead>
					<tbody id="privList">
						
					</tbody>
		        </table>
			</div>
			<div class="formBar">
		        <ul>
		            <li>
		                <button class="savebtn" type="button" onclick="share(this)">分享</button>
		            </li>
		            <li>
		                <button class="close" type="button">取消</button>
		            </li>
		        </ul>
		    </div>
		</form>
		<div style="display:none;">
		<table id="tr_block_html">
			<tr class="#evenrow#">
				<td>
					<input type="hidden" name="ownerCode" value="#val#"/>	
					<span id="userName">#name#</span>
				</td>
				<td>
					<input type="checkbox" name="isInsert"  
			               value="1" />
				</td>
				<td>
					<input type="checkbox" name="isRead"  checked="checked"
			               value="1" />
				</td>
				<td>
					<input type="checkbox" name="isUpdate"  
			               value="1" />
				</td>
				<td>
					<input type="checkbox" name="isDelete"  
			               value="1" />
				</td>
				<td>
					<input type="checkbox" name="isTransfer"  
			               value="1" />
				</td>
				<td>
					<input type="checkbox" name="isShare"  
			               value="1" />
				</td>
				<td>
					<div>
					<a class="btnDel" href="javascript:;" onclick="deleteUser(event)">
		                 <span>删除</span>
		             </a>
		            </div>
				</td>
			</tr>
		</table>
		</div>
		<script type="text/javascript">
			var pageScope = $.pdialog.getCurrent();
			function addPerson() {
				var selCodes = $("input[name='selectedCodes']",pageScope).val();
				var selCodeArr = selCodes.split(",");
				var selNames = $("input[name='selectedNames']",pageScope).val();
				var selNameArr = selNames.split(",");
				for(var i = 0; i < selCodeArr.length;i++) {
					var userCode = selCodeArr[i];
					if(userCode && userCode.length>0 && !exists(userCode)) {
						addColumn(userCode,selNameArr[i]);
					}
				}
				
				//清空隐藏值
				$("#selectedCodes",pageScope).val("");
				$("#selectedNames",pageScope).val("");
				return true;
			}
			
			function addColumn(userCode,userName){
				var addHtml = $("#tr_block_html tr",pageScope).get(0).outerHTML;
				addHtml = addHtml.replace("#val#",userCode).replace("#name#",userName);
				if($("#privList",pageScope).find("tr").length % 2==1) {
					addHtml = addHtml.replace("#evenrow#","trbg");
				}
				$("#privList",pageScope).first().append(addHtml);
			}
			
			function deleteUser(event) {
				$(event.target).closest("tr").remove();		
			}
			
			function exists(userCode) {
				var status = false;
				$("#privList",pageScope).find("input[name='ownerCode']").each(function(i,e) {
					if(userCode==$(e).val()) {
						status = true;
						return false;
					}
				});
				return status;
			}
			
			function checkInfo() {
				var status = true;
				var privData = "";
				$("#privList",pageScope).find("tr").each(function(i,e){
					if($(e).find("input:checked").length<1){
						alertMsg.warn("请勾选人员（"+$(e).find("#userName").html()+"）的权限！");
						status = false;
						return false;
					}else{
						var userCode = $(e).find("input[name='ownerCode']").val();
						var isInsert = $(e).find("input[name='isInsert']:checked").length>0?$(e).find("input[name='isInsert']").val():"0";
						var isRead = $(e).find("input[name='isRead']:checked").length>0?$(e).find("input[name='isRead']").val():"0";
						var isUpdate = $(e).find("input[name='isUpdate']:checked").length>0?$(e).find("input[name='isUpdate']").val():"0";
						var isDelete = $(e).find("input[name='isDelete']:checked").length>0?$(e).find("input[name='isDelete']").val():"0";
						var isTransfer = $(e).find("input[name='isTransfer']:checked").length>0?$(e).find("input[name='isTransfer']").val():"0";
						var isShare = $(e).find("input[name='isShare']:checked").length>0?$(e).find("input[name='isShare']").val():"0";
						privData += (i==0?"":"@")+userCode+"#" + isInsert+","+isRead+","+isUpdate+","+isDelete+","+isTransfer+","+isShare;
					}
				});
				$("input[name='privData']",pageScope).val(privData);
				return status;
			}
			
			function share($btn){
				if(!checkInfo()) {
					return;
				}
				$.ajax({    
					type:'post',        
					url:"/xmlprocesserservlet",
					async:true,   
					dataType:'XML', 
					data:$($btn).closest("form").serialize(),
					success:function(data){   
						var retCode = $(data).find('DataPacket Response Data retCode').text();
						var retMessage = $(data).find('DataPacket Response Data retMessage').text();
						if("200" == retCode){
							alertMsg.correct(retMessage);
							$.pdialog.closeCurrent();
						}else{
							alertMsg.error(retMessage);
						}
					}    
				});  
			}
		</script>
	 </c:otherwise>
 </c:choose>
