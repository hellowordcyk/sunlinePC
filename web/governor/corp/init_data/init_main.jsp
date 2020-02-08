<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:法人查询列表
 * description: 
 *     显示所有法人信息
 * author: daoge
 * createtime: 20160907
 * logs:
 *
 *--%>
 <style>
 	.tip{
 		display: block;
 		width:140px;
 		height:30px;
 		line-height:30px;
 		text-align:center;
 		color:black;
 	}
 	.initFaild{
 		background-color: red;
 		color:white;
 	}
 	.initSucc{
 		background-color: green;
 		color:white;
 	}
 </style>
 <form id="pagerForm" class="pageForm" action="" target="_self">
	<div class="pageContent">
		<div class="pageFormContent">
			<c:set var="tempSystemCode" value=""/>
			<c:forEach var="corpConfig" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
				<c:choose>
					<c:when test="${tempSystemCode eq corpConfig.systemCode }">
						<tr>
							<td style="width:30%;text-align: left;">
								<input type="hidden" name="functionId" value="${corpConfig.functionId }"/>
								<c:choose>
									<c:when test="${corpConfig.functionMandatory eq '1'}">
										<input name="functionMandatory" type="checkbox" checked="checked"  disabled="disabled" value="${corpConfig.functionMandatory}"/>
									</c:when>
									<c:otherwise>
										<input name="functionMandatory" type="checkbox" value="${corpConfig.functionMandatory}"/>
									</c:otherwise>
								</c:choose>
								<span id="modelTitle">${corpConfig.functionTitle }</span>
							</td>
							<td class="form-value" style="width:20%">
								<c:choose>
									<c:when test="${corpConfig.functionSelectable eq '1'}">
										<sc:select name="copyCorpcode"  type="xml" sysName="governor" oprID="corpActor" actions="selectCorpList" nameField="corpCode" valueField="corpName" includeTitle="false" excludes="${param.corpcode }"  nullOption="默认法人" />
									</c:when>
									<c:otherwise>
										&nbsp;
									</c:otherwise>
								</c:choose>
							</td>
							<td class="form-label" style="text-indent: 20px;">
								<c:choose>
									<c:when test="${corpConfig.executionStatus eq '1'}">
										<input type="hidden" name="executeStatus" value="${corpConfig.executionStatus }"/>
										<span name="tip" class="tip initSucc">初始化成功</span>
									</c:when>
									<c:when test="${corpConfig.executionStatus eq '2'}">
										<input type="hidden" name="executeStatus" value="${corpConfig.executionStatus }"/>
										<span name="tip" class="tip initFaild">初始化失败</span>
									</c:when>
									<c:otherwise>
										<input type="hidden" name="executeStatus" value="${corpConfig.executionStatus }"/>
										<span name="tip" class="tip ">未初始化</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<c:if test="${status.index eq fn:length(jrafrpu.rspPkg.rspRcdDataMaps)-1}">
									</tbody>
									</table>
								</div>
								<div class="panelFooter">
									<div class="panelFooterContent">
									</div>
								</div>
							</div>
						</c:if>
					</c:when>
					<c:otherwise>
						<c:set var="tempSystemCode" value="${corpConfig.systemCode}"/>
						<c:if test="${status.index gt 0 or status.index eq fn:length(jrafrpu.rspPkg.rspRcdDataMaps)}">
									</tbody>
									</table>
								</div>
								<div class="panelFooter">
									<div class="panelFooterContent">
									</div>
								</div>
							</div>
						</c:if>
						
						<c:if test="${status.index lt fn:length(jrafrpu.rspPkg.rspRcdDataMaps)}">
							<div class="panel" style="display: block;">
								<div class="panelHeader">
									<div class="panelHeaderContent">
										<h1 style="cursor: move;">${corpConfig.systemName}</h1>
									</div>
								</div>
								<div class="panelContent" >
									<table class="form-table" cellpadding="0" cellspacing="0">
										<tbody>
						</c:if>
						<tr>
							<td style="width:30%;text-align: left;">
								<input type="hidden" name="functionId" value="${corpConfig.functionId }"/>
								<c:choose>
									<c:when test="${corpConfig.functionMandatory eq '1'}">
										<input name="functionMandatory" type="checkbox" checked="checked"  disabled="disabled" value="${corpConfig.functionMandatory}"/>
									</c:when>
									<c:otherwise>
										<input name="functionMandatory" type="checkbox" value="${corpConfig.functionMandatory}"/>
									</c:otherwise>
								</c:choose>
								<span id="modelTitle">${corpConfig.functionTitle }</span>
							</td>
							<td class="form-value" style="width:20%;">
								<c:choose>
									<c:when test="${corpConfig.functionSelectable eq 1}">
										<sc:select name="copyCorpcode" type="xml" sysName="governor" oprID="corpActor" actions="selectCorpList" nameField="corpCode" valueField="corpName" includeTitle="false" excludes="${param.corpcode }" nullOption="默认法人" />
									</c:when>
									<c:otherwise>
										&nbsp;
									</c:otherwise>
								</c:choose>
							</td>
							<td class="form-label" style="text-indent: 20px;">
								<c:choose>
									<c:when test="${corpConfig.executionStatus eq '1'}">
										<input type="hidden" name="executeStatus" value="${corpConfig.executionStatus }"/>
										<span name="tip" class="tip initSucc">初始化成功</span>
									</c:when>
									<c:when test="${corpConfig.executionStatus eq '2'}">
										<input type="hidden" name="executeStatus" value="${corpConfig.executionStatus }"/>
										<span name="tip" class="tip initFaild">初始化失败</span>
									</c:when>
									<c:otherwise>
										<input type="hidden" name="executeStatus" value="${corpConfig.executionStatus }"/>
										<span name="tip" class="tip">未初始化</span>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<c:if test="${status.index eq fn:length(jrafrpu.rspPkg.rspRcdDataMaps)-1}">
									</tbody>
									</table>
								</div>
								<div class="panelFooter">
									<div class="panelFooterContent">
									</div>
								</div>
							</div>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:forEach>
			<div class="formbutton_bg" style="height:80px;">
		        <ul>
		            <li>
		                <button class="button" type="button" onclick="execute()">执行初始化</button>
		            </li>
		            <li>
		                <button class="button" type="button" onclick="resetInit()">重置初始化</button>
		            </li>
		        </ul>
		    </div>
		</div>
	</div>
</form>
<script type="text/javascript">
	function resetInit() {
		alertMsg.confirm("确定重置吗？", {
			okCall : function() {
				var functionIds = "";
				$("input[name='functionId']",navTab.getCurrentPanel()).each(function(i,e){
					functionIds = functionIds + $(e).val()+",";
				});
				if(functionIds.length>1) {
					functionIds = functionIds.substring(0,functionIds.length-1);
				}else{
					return;
				}
				var url = "/xmlprocesserservlet?sysName=<sc:fmt type='crypto' value='governor'/>"+
				"&oprID=<sc:fmt type='crypto' value='corpInitActor'/>"+
				"&actions=<sc:fmt type='crypto' value='resetCorpInit'/>";
				var data = {"functionIds":functionIds,"corpcode":"<c:out value='${param.corpcode}'/>"};
				$.ajax({
					type:'POST',
					url:url,
					data: data,
					dataType:"xml",
					cache: false,
					async:false,
					success: function(data) {
						var status = $(data).find("DataPacket Response Data").first().text();
						if(status=="succ") {
							alertMsg.correct("重置成功！");
							$("table.form-table tbody tr input[name='executeStatus']",navTab.getCurrentPanel()).val("0");
							$("table.form-table tbody tr span[name='tip']",navTab.getCurrentPanel()).html("未执行").removeClass("initFaild").removeClass("initSucc");
							$("form .formbutton_bg button",navTab.getCurrentPanel()).removeAttr("disabled");
							
						}else{
							alertMsg.error("重置失败！");
						}
					},
					error:function(msg) {
						alertMsg.error(msg);
					}
				});
				
			}
		});
	}
	
	function repairDeptData(corpcode) {
		var url = "/xmlprocesserservlet?sysName=<sc:fmt type='crypto' value='governor'/>"+
		"&oprID=<sc:fmt type='crypto' value='corpInitActor'/>"+
		"&actions=<sc:fmt type='crypto' value='repairData'/>";
		var data = {"corpcode":"<c:out value='${param.corpcode}'/>"};
		$.ajax({
			type:'POST',
			url:url,
			data: data,
			dataType:"text",
			cache: false,
			async:false,
			success: function(data) {
				
			},
			error:function(msg) {
				alertMsg.error(msg);
			}
		});
	}
	
	function isAllSucc() {
		var isAllSucc = true;
		var $checkedElm1 = $("table.form-table tbody tr input[name='functionMandatory']:checked",navTab.getCurrentPanel());
		$checkedElm1.each(function(i,e) {
			var $statuaElm = $(e).closest("tr").find("input[name='executeStatus']");
			if($statuaElm.val()==1) {
			}else{
				isAllSucc = false;
				return false;
			}
		});
		return isAllSucc;
	}
	function execute() {
		if(isAllSucc()) {
			alertMsg.info("所有选择的功能模块数据已经初始化完毕!");
			return;
		}
		alertMsg.confirm("执行初始化，将初始化法人的数据。如果多次执行，会清掉已有数据再执行初始化，请谨慎操作！", {
			okCall : function() {
				var url = "/xmlprocesserservlet?sysName=<sc:fmt type='crypto' value='governor'/>"+
				"&oprID=<sc:fmt type='crypto' value='corpInitActor'/>"+
				"&actions=<sc:fmt type='crypto' value='initFunction'/>";
				var $checkedElm = $("table.form-table tbody tr input[name='functionMandatory']:checked",navTab.getCurrentPanel());
				$("form .formbutton_bg button",navTab.getCurrentPanel()).attr("disabled","disabled");
				$("#alertMsgBox").hide();
				$checkedElm.each(function(i,e) {
					var $statuaElm = $(e).closest("tr").find("input[name='executeStatus']");
					var copyCorpcode = $(e).closest("tr").find("select[name='copyCorpcode']");
					var corpcode = "<c:out value='${param.corpcode}'/>";
					var cpCorpcode = "";
					var currentStatus = true;
					if($statuaElm.val()!='1') {
						
						if(copyCorpcode.length>0&&copyCorpcode.val()!=null&&copyCorpcode.val().length>0) {
							cpCorpcode = copyCorpcode.val();
						}
						var data = {"functionId":$(e).closest("tr").find(":input[name='functionId']").first().val(),"corpcode":corpcode,"copyCorpCode":cpCorpcode};
						$statuaElm.siblings("span").html("正在初始化...");
						$.ajax({
							global:false,
							type:'POST',
							url:url,
							data: data,
							dataType:"xml",
							cache: false,
							async:false,
							success: function(data) {
								var status = $(data).find("DataPacket Response Data").first().text();
								if(status=='1') {
									$statuaElm.val("1");
									$statuaElm.siblings("span").html("初始化成功").removeClass("initFaild").addClass("initSucc");
									currentStatus = true;
								}else{
									$statuaElm.val("2");
									$statuaElm.siblings("span").html("初始化失败").removeClass("initSucc").addClass("initFaild");
									currentStatus = false;
								}
							},
							error:function(msg) {
								alertMsg.error(msg);
							}
						});
						
					}
					if(!currentStatus){
						return false;
					}
				});
				clearTempRef();
				$("form .formbutton_bg button",navTab.getCurrentPanel()).removeAttr("disabled");
			}
		});
	}
	
	function clearTempRef() {
		var url = "/xmlprocesserservlet?sysName=<sc:fmt type='crypto' value='governor'/>"+
		"&oprID=<sc:fmt type='crypto' value='corpInitActor'/>"+
		"&actions=<sc:fmt type='crypto' value='clearTempRef'/>";
		$.ajax({
			global:false,
			type:'POST',
			url:url,
			data: {},
			dataType:"xml",
			cache: false,
			async:false,
			success: function(data) {
				
			},
			error:function(msg) {
				alertMsg.error(msg);
			}
		});
	}
</script>