<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/jui_tag.jsp" %>
<div class="pageContent">
    <div class="panelBar">
        <ul class="toolBar">
            <li>
                <a class="btnNormal" target="selectedTodo" rel="amendinfo" title="确定要修正所选记录吗?" 
                   href="/httpprocesserservlet?forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>&sysName=<sc:fmt value='governor' type='crypto'/>&oprID=<sc:fmt value='initConfig' type='crypto'/>&actions=<sc:fmt value='updateSeqblock' type='crypto'/>" >
                   <span>修正</span>
                </a>
            </li>
         </ul>
    </div>   
	<sc:doPost sysName="governor" oprId="initConfig" action="getSeqBlockList" scope="request" var="rspPkg" ></sc:doPost>
    <form class="pageForm required-validate">
    <table class="table" cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <%-- 规范：设置表格列宽度， 保证一个td列不设置宽度表示自动计算为100%剩余宽度--%>
                    <th class="checkbox"><input class="checkboxCtrl" type="checkbox" group="amendinfo" /></th>
                    <th width="20%">表名</th>
                    <th width="20%">自增字段</th>
                    <th width="20%">自增主键索引(n+1)</th>
                    <th width="10%">最大值</th>
                </tr>
            </thead>
            <tbody>
            	 <c:forEach var="record" items="${rspPkg.rspRcdDataMaps}"  varStatus="menuStatus">
	                 <tr <c:if test="${menuStatus.index%2 != 0}"> class="evenrow"</c:if> >
                		<td class="checkbox">
                			<c:if test="${record.cresult=='0'}"><input type="checkbox" name="amendinfo" value='${record.name }:${record.maxvalue }' checked="checked" /><span style="color:red;font-weight:bold;"></span></c:if>
                		</td>
                		<td>
                			${record.name}
                		</td>
                		<td>
                			${record.colname}
                		</td>
                		<td>
                			<c:if test="${record.colname == 'null'}"><input id="${menuStatus.index}" onchange="changeMaxIndex(this,'${record.name}')" class="required digits" value="${record.idx}"/></c:if>
                			<c:if test="${record.colname != 'null'}">${record.idx}</c:if>
                			
                		</td>
                		<td>
                			 <c:if test="${record.cresult=='-1'}"><span style="color:red;font-weight:bold;">${record.maxvalue}</span></c:if>
           					 <c:if test="${record.cresult=='0' || record.cresult=='1'}">${record.maxvalue}</c:if>
                		</td>
                	 </tr>
               	 </c:forEach>
            </tbody>
	</table>
	</form>
    <%-- <table>
       
        <display:column style="width:5%;text-align:center" title="序号"><sc:fmt value="${record_rowNum}"/></display:column>
        <display:column style="width:45%;" property="name" title="表名"/>
        <display:column style="width:20%;" property="colname" title="自增字段"  />
        <display:column style="width:20%;" title="自增主键索引(n+1)" >
            <c:if test="${record.cresult=='-1' || record.cresult=='1'}">${record.idx}</c:if>
            <c:if test="${record.cresult=='0'}"><input type="checkbox" name="amendinfo" value='${record.name }:${record.maxvalue }' style="display: none;" checked="checked" /><span style="color:red;font-weight:bold;">${record.idx}</span></c:if>
        </display:column>
        <display:column style="width:20%;" title="最大值">
            <c:if test="${record.cresult=='-1'}"><span style="color:red;font-weight:bold;">${record.maxvalue}</span></c:if>
            <c:if test="${record.cresult=='0' || record.cresult=='1'}">${record.maxvalue}</c:if>
        </display:column>
        <display:footer>
            <tr>
                <td colspan='7' align='center' class="form-bottom" style="padding-top:5px;padding-bottom:5px;">
                    <input type="button" class="button" id="amend" name='amend'  value="修正" onclick="amendError()" />
                </td>
            </tr>
        </display:footer>
    </display:table> --%>
	<div class="page-tip" style="margin: 0; ">
		<span class="tip-title">温馨提示</span>
		<p>Hibernate持久化实体且此实体有自增主键时，当插入（insert）数据时，自增主键的当前值从此表（seq_block）获取;</p>
		<p>自增主键索引(n+1): 此字段值为当前配置表中自增主键的最大值加1；后面用“idx”表示；</p>
		<p>最大值：当前配置表自增主键真实最大值；后面用“maxvalue”表示</p>
		<p>"idx"一定是大于"maxvalue"的值；如果不是，列表中将用红色标识数值；<b>列表中无任何红色标识则表示一切正常；</b></p>
	</div>
</div>

<script>
function changeMaxIndex(obj,tableName){
	var value= $(obj).val();
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='governor' type='crypto'/>"
	    + "&oprID=<sc:fmt value='initConfig' type='crypto'/>"
	    + "&actions=<sc:fmt value='manualUpdateSeqblock' type='crypto'/>"
	    + "&idx="+value
	    + "&tableName="+tableName;
	$.ajax({
		global:false,
		type:'POST',
		url: url,
		dataType:'text',
		error: DWZ.ajaxError,
		success:function(data){
			var xmlDoc = parseXmlStr(data);
			var flag = $('flag',xmlDoc).text();
			if(flag == 'yes'){
				alertMsg.correct("修改成功");
			}else{
				alertMsg.error("修改失败");
			}
		}
	});
}
</script>
