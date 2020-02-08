<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 根节点机构信息
 * description: 
 *     1. 根节点机构信息
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160623 优化布局
 *--%>
<div class="pageHeader">
	<form   onsubmit="return divSearch(this, 'deptlookupMultiList_divid');" action="/httpprocesserservlet"
		id="deptlookupMultiList_divid_pagerForm"  method="post">
	<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='getPcmcDeptList' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/portal/organization/deptManagerRootDeptList.jsp' />"/>
	<input type="hidden" name="pageNum" value="1" />
	<sc:hidden name="lookupcode" value="deptcode" />
	<sc:hidden name="lookupname" value="deptname" />

	<sc:hidden name="pdeptid" value="" />
		<div class="searchBar">
			<table class="searchContent" width="100%">
				<tr>
					<td class="form-label">机构编码/名称</td>
					<td class="form-value"><sc:text name="deptname" /></td>
					<td class="form-btn">
						<button id="selectChildUserBtn" class="querybtn" type="submit">查询</button>
					</td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div class="pageContent">
    <div class="panelBar">
        <ul class="toolBar">
            <li>
                <a class="btnNormal"  href="javascript:freshDeptOrgseq();">
                    <span>修复机构树</span>
                </a>
            </li>
            <%-- 按钮组分隔 --%>
            <li class="line">line</li> 
         </ul>
         <span class="info">如果影响正常操作，尝试修复机构树！</span>
    </div>    
	<div class="" id="deptlookupMultiList_divid" >
	
	</div>
</div>
<script type="text/javascript">
$(function(){			
	//提交表单
	$("#deptlookupMultiList_divid_pagerForm", navTab.getCurrentPanel()).submit();
})

function freshDeptOrgseq(){
	var msg = "是否重构整个机构树层级顺序串，保证机构相关功能正常使用？提示：执行过程可能缓慢，请耐心等待。";
	alertMsg.confirm(msg, {
		okCall : function() {
			var url = "/xmlprocesserservlet?sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
			+ "&oprID="+'<sc:fmt value='funcpub-deptusermanager' type='crypto'/>'
			+ "&actions="+'<sc:fmt value='freshDeptOrgseq' type='crypto'/>';
			$.ajax({
			   type: "POST",
			   url: url,
			   dataType: "XML",
			   success: function(data){
				    var msg = $(data).find('DataPacket Response Data msg').text();
					if(msg=="success"){
						alertMsg.correct("操作成功！");
					}else{
						alertMsg.error(msg);
					}
			   }, error:function(){
		           alertMsg.error("刷新机构层级异常！");
		       }
			});
		}
	});
}
</script>