<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--规范：每个页面前必需增加注释。1）说明主要功能；2）主要功能修改日志 --%>
<%--
 * title: 法人管理-新增
 * description: 
 *     新增法人
 * author: hzx
 * createtime: 2016-09-28 10:30
 *
 *--%>
<%--规范：form属性顺序：class->onsubmit->method->其他->action --%>
<style type="text/css">
	.preview{width:360px;height:50px;border:1px solid #000;overflow:hidden;}
	.imghead {filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);}
</style>
<form id="corp_basic_form" name="frmcog" method="post" action="/httpprocesserservlet" class="pageForm required-validate" enctype="multipart/form-data" onsubmit="return iframeCallback(this, dialogAjaxDone);">
   <%--  <input type="hidden" name="sysName" value="<sc:fmt value='governor' type='crypto'/>"/>
    <input type="hidden" name="oprID" value="<sc:fmt value='corpActor' type='crypto'/>"/>
    <input type="hidden" name="actions" value="<sc:fmt value='addCorpLogo' type='crypto'/>"/>
    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" /> --%>
    <input type="hidden" name="sysName" value="<sc:fmt value='governor' type='crypto'/>"/>
    <input type="hidden" name="oprID" value="<sc:fmt value='corpActor' type='crypto'/>"/>
    <input type="hidden" name="actions" value="<sc:fmt value='saveOrUpdateCorp' type='crypto'/>"/>
    <input type="hidden" name="forward" value="<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" />
    <div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
           	 	<tr>
                    <td class="form-label"><span class="redmust">*</span>法人编码</td>
                    <td class="form-value">
                        <sc:text id="corpCode" name="corpCode" validate="required alphanumeric" />
                    </td>
                </tr>
                <tr>
                    <td class="form-label"><span class="redmust">*</span>法人名称</td>
                    <td class="form-value">
                        <sc:text name="corpName" validate="required"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">法人简称</td>
                    <td class="form-value">
                        <sc:text name="corpShortname"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">核心法人编码</td>
                    <td class="form-value">
                        <sc:text name="corpFromcore"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">从属法人编码</td>
                    <td class="form-value">
                        <sc:text name="corpParent"/>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">登录页面法人logo</td>
                    <td class="form-value">
						<div id="preview_login" class="preview">
							<img id="imghead_login" class="imghead" width=360px height=50px border=0
								src='<%=request.getContextPath()%>${jrafrpu.rspPkg.rspRcdDataMaps[0].corpLoginlogo}'>
						</div> 
						<input id="corpLoginlogo" name="corpLoginlogo" type="file" onchange="previewImage(this,'imghead_login','preview_login')" />  
                        <!-- <sc:text name="corpLoginlogo" /> -->
                    </td>
                </tr>
               <tr>
                    <td class="form-label">首页法人logo</td>
                    <td class="form-value">
                    	<div id="preview_index" class="preview">
							<img id="imghead_index" class="imghead" width=360px height=50px border=0
								src='<%=request.getContextPath()%>${jrafrpu.rspPkg.rspRcdDataMaps[0].corpIndexlogo}'>
						</div> 
						<input id="corpIndexlogo" name="corpIndexlogo" type="file" onchange="previewImage(this,'imghead_index','preview_index')" />
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="formBar">
        <ul>
            <li><button class="savebtn" type="button" onclick="editCorp()">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>
<script>
function editCorp(){
	var corpCode = $("#corpCode",$.pdialog.getCurrent()).val();
	/* $("#corpCode_bak").val(corpCode); */
	var url = "/xmlprocesserservlet?sysName=<sc:fmt value='governor' type='crypto'/>&oprID=<sc:fmt value='corpActor' type='crypto'/>&actions=<sc:fmt value='checkCorpUnique' type='crypto'/>"
	$.ajax({
		   type: "POST",
		   url: url,
		   data: "corpCode="+corpCode,
		   dataType : "xml",
		   processData: false,
		   async:false,
		   success: function(data){
			   var isUnique = $(data).find("DataPacket Response Data isUnique").text();
			   if(isUnique =="0"){
				   alertMsg.warn('法人编码已存在！');
				   return;
			   }else{
				   if(checkimg($("#corpLoginlogo"))&&checkimg($("#corpIndexlogo"))){
					   $("#corp_basic_form").submit();
				   }
			//	   $("#corp_logo_form").submit();
			   }
		   },
		   error:function(){
			   alertMsg.error('操作错误！');
		   }
	});
	
}
</script>