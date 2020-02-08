<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>

<sc:form name="frmcog"  action="/httpprocesserservlet" 
    sysName="funcpub" oprID="info" actions="updatePcmcInfo" forward="/jui/callMessage.jsp" method="post" onsubmit="return validateCallback(this,dialogAjaxDone)">
    <sc:hidden name="infoid" />
    <div class="pageContent">
		<div class="pageFormContent">
		    <table width="100%" cellpadding="0" cellspacing="0" class="form-table">
		        <tr>
		    		<td class='form-label'>所属系统：</td>
		    		<td class='form-value' colspan="3">
						<sc:select name="subsys" index="1" req="1" type="subsys" key="" >
						
		       			</sc:select></td>
		    		</tr>
		        <tr>
		            <td class="form-label">公告标题：<span style="color: red;">*</span></td>
		            <td class="form-value" colspan="3">
		                <sc:text name="title" req="1" index="1" attributesText="maxlength='30' style='width: 90%'"/>
		            </td>
		        </tr>
		        <tr>
			    	<td class="form-label">
			        	公告生效时间:
			        </td>
			        <td class="form-value">
			        	<sc:date name="startdt" dateFmt="yyyy-MM-dd HH:mm:ss" validate="required" style="width: 66%;"></sc:date>
			        </td>
			        <td class="form-label">
			        	公告终止时间
			        </td>
			        <td class="form-value">
			        	<sc:date name="enddt" dateFmt="yyyy-MM-dd HH:mm:ss" validate="required" style="width: 66%;"></sc:date>
			        </td>
			    </tr>
		        <tr>
		            <td class="form-label" style="text-align: center;">公告内容：<span style="color: red;">*</span>
		                <div><span class="hint_info">还可输入<span id="numId" style="font-weight: blod; color: red;">1000</span>个字</span></div>
		            </td>
		            <td class="form-value" colspan="3">
		                <sc:textarea name="content" dspName="公告内容" 
		                    attributesText="id='contentId' style='width: 90%;' maxlength='1000' onkeyup='countLen(this)'"
		                    cols="50" rows="18" req="1" index="1"/>
		            </td>
		        </tr>
			</table>
			</div>
	</div>
	<div class="formBar">
		<ul>
			<li><input type="submit" class="button" value="提交"/></li>
			<li><sc:button value="重写" type="reset"/></li>
	        <!-- <li><button type="button" class="close">取消</button></li> -->
		</ul>
	</div>
</sc:form>
</body>
<script language="javascript">
	$(function(){
		countLen($("textarea[name=content]")[0]);
	});
	function countLen(thisObj) {
	    var val = thisObj.value;
	    var count = 1000 - val.length;
	    if (count <= 0) {
	        thisObj.value = val.substr(0, 1000);
	        event.returnValue = false;
	        alertMsg.error("可输入内容长度大于1000，超出部分将截断。");
	        count=0;
	    }
	    $("#numId").html(count);
	}
</script>