<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<sc:form name="importReportForm"  encType="multipart/form-data" _class="pageForm required-validate" 
	action="/httpprocesserservlet" sysName="funcpub" oprID="info"  actions="addPcmcInfo"  forward="/jui/callMessage.jsp"
		method="post" onsubmit="return iframeCallback(this,dialogAjaxDone)">
	<div class="pageContent">
		<div class="pageFormContent">
		    <table width="100%" cellpadding="0" cellspacing="0" class="form-table" style="margin:0;">
			    <tr>
				    <td class='form-label'>所属系统：</td>
				    <td class='form-value' colspan="3">
						<sc:select name="subsys" default="1" type="subsyscd" key="" validate="required">
				       	</sc:select>
				    </td>
			    </tr>
			    <tr>
			        <td class="form-label">公告标题：<span style="color: red;">*</span></td>
			        <td class="form-value" colspan="3">
			        	<sc:text name="title" validate="required"  _class="inputtext"/>
			            <!-- <input type="text" name="title" class="inputtext" displayName="公告标题" required="required" style='width: 90%' maxlength='30'/> -->
			        	<span class="redmust">*</span>
			        </td>
			    </tr>
			    <tr>
			    	<td class="form-label">
			        	公告生效时间:
			        </td>
			        <td class="form-value">
			        	<sc:date name="startdt" dateFmt="yyyy-MM-dd HH:mm:ss" validate="required" style="width: 50%;"></sc:date>
			        </td>
			        <td class="form-label">
			        	公告终止时间:
			        </td>
			        <td class="form-value">
			        	<sc:date name="enddt" dateFmt="yyyy-MM-dd HH:mm:ss" validate="required" style="width: 50%;"></sc:date>
			        </td>
			    </tr>    
			    <tr>
			        <td class="form-label" style="text-align: center;">公告内容：<span style="color: red;">*</span>
			            <div><span class="hint_info">还可输入<span id="numId" style="font-weight: blod; color: red;">1000</span>个字</span></div>
			        </td>
			        <td class="form-value" colspan="3">
			            <sc:textarea name="content" dspName="公告内容" 
			                attributesText="id='contentId' style='width: 90%;height: 312px;' maxlength='1000' onkeyup='countLen(this)'"
			                cols="50" rows="17" validate="required"/>
			        </td>
			    </tr>    
			    <tr>
			        <td class="form-label">新增附件:</td>
			        <td class="form-value" colspan="3">
			            <input type="file" class="inputfile" name='filename' style="width: 90%;"/>
			        </td>
			    </tr>
			    <tr>
			       <!--  <td class="form-label">通知方式：</td>
			        <td class="form-value" colspan="3">
			            <label for="noId">
			                <input id="noId" type="checkbox" class="inputcheckbox" onclick="selPushType(this)" name='' value="0"/>不提醒
			            </label>
			            <label for="popId">
			                <input id="popId" type="checkbox" class="inputcheckbox" value="POPUP" name='sndmod' checked="checked"/>系统弹出框提醒（默认）
			            </label>
			            <label for="messageId">
			                <input id="messageId" type="checkbox" class="inputcheckbox" value="SMS" name='sndmod'/>短信提醒
			            </label>
			            <label for="mailId">
			                <input id="mailId" type="checkbox" class="inputcheckbox" value="EMAIL" name='sndmod'/>邮件提醒
			            </label>
			        </td> -->
			    </tr>
			    <tr>
			        <th colspan="4">指定接收对象（可选）</th>
			    </tr>
			    <tr>
			        <td class="form-label">接收人员：</td>
			        <td class="form-value" colspan="3">
			            <sc:hidden name="userid" attributesText="id='useridsId' "/>
			            <sc:hidden name="usercd" attributesText="id='usercdsId' "/>
			            <input type="text" class="inputtext" name='username' readonly="readonly"  style="width: 90%;"/>
			            <a class="btnLook" title="单选用户" lookupGroup=""  width="900" height="500"
                            href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupid=userid&lookupcode=usercd&lookupname=username"></a>
			        </td>
			    </tr>
			    <tr>
			        <td class="form-label">接收机构</td>
			        <td class="form-value" colspan="3">
			            <sc:hidden name="brchno" />
			            <sc:hidden name="deptid" />
			            <sc:hidden name="deptcode" />
			            <sc:text name="deptname" dspName="所属机构" validate="require" attributesText="id='deptnameId' readonly='readonly' style='width: 90%'"/>
						
						<!-- <a class="btnLook" title="多选部门"   lookupGroup="" width="900" height="500"
                            href="/funcpub/public/deptuser/deptLookupMulti.jsp?lookupid=deptid&lookupcode=deptcode&lookupname=deptname"></a>
						 -->
						 <a class="btnLook" title="选择接收机构" lookupGroup=""  width="1000" height="500"
                            href="/funcpub/public/deptuser/deptTreeOptionDialog.jsp?lookupid=deptid&lookupcode=deptcode&lookupname=deptname&elmId={deptid}"></a>
			            <div style="padding: 1px 1px;">
			                <label for="isTraversalId">
			                    <input id="isTraversalId" type="checkbox" value="1" name="isTraversal" class="inputcheckbox" style="margin: 0;"/>是否包括下级机构人员
			                </label>
			            </div>
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
<script>
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
	function deptTreeCallBack(deptArray,dept){
		$("[name='deptid']",$("body").data("addRole")).val(dept.deptID);
		$("[name='deptcode']",$("body").data("addRole")).val(dept.deptCode);
		$("[name='deptname']",$("body").data("addRole")).val(dept.deptName);
	}
	
	function userTableCallBack(userArray,user){
		//{userID: "5", userCode: "user", userName: "测试"}
		$("[name='userid']",$("body").data("addRole")).val(user.userID);
		$("[name='username']",$("body").data("addRole")).val(user.userName);
		$("[name='usercd']",$("body").data("addRole")).val(user.userCode);
	}
	
</script>
