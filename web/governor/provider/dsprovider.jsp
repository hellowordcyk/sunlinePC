<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
 <%@ include file="/jui_tag.jsp" %>
<form class="pageForm required-validate" method="post" onsubmit="return validateCallback(this,navTabAjaxDone)"
      action="/governor" >
    <div class="pageContent">
        <div class="pageFormContent">
        	<table align="center" class="form-table" border="0" width="100%"  cellspacing="0" cellpadding="0">
            	<tr >
            	    <td class="form-label" style="width: 180px;"><span style="color: red;">*</span>数据源提供者类名
            	    </td>
	     			<td class="form-value">
	     				<input id="dsp" type="hidden" value="${configInfo.dsprovider}" />
	     				<select id="dsprovider" name="dsprovider" style="width: 95%;">
				            <option value="com.sunline.jraf.db.ds.ProxoolDataSource">com.sunline.jraf.db.ds.ProxoolDataSource</option>
				            <option value="com.sunline.jraf.db.ds.JndiDataSource">com.sunline.jraf.db.ds.JndiDataSource</option>
				            <option value="com.sunline.jraf.db.ds.C3p0DataSource">com.sunline.jraf.db.ds.C3p0DataSource</option>
			            </select>
	     			</td>
				</tr>
				<tr>
					<td colspan='2' align='center' class="form-bottom">
				    	<input type="button" class="savebtn" onclick="saveWarn()" value="保存" />
				    </td>
				</tr>
         	</table>
        </div>
     </div>
	<div class="page-tip" style="margin: 0;">
		<span class="tip-title">温馨提示</span>
		<p id="dsprovider_tip_title">目前主要支持ProxoolDataSource的配置功能，结合“数据源管理”菜单功能使用；如需使用其他接口，需要手工配置相关数据源信息;</p>
	</div>
</form>
<script type="text/javascript" defer="defer">
var dsprovider = document.getElementById("dsp").value;
$("select[name=dsprovider] option").each(function(){
	 if($(this).val() == dsprovider){
		 $(this).attr("selected",true);
	}
});
function  saveWarn(){
	var dsprovider=$("select[name=dsprovider]").val();
	var respUrl = "/governor?flag=initConfig&actorName=configServlet&dsprovider="+dsprovider;
	$.ajax({
		type : 'POST',
		url : respUrl,
		dataType:"json",  
		jsonp:"callback",  
		jsonpCallback:"success_jsonp", 
		async : false,
		success : function(data) {
	    	if(data.msg=='0'){
				alertMsg.correct(data.retMessage)
			}else{
				alertMsg.error(data.retMessage);
			}
		},
		error : function(json){
		   DWZ.ajaxError(json);
		}
	 });
		var daprivider=$("select[name=dsprovider]").val();
		var $dsprovider_tip_title=$("#dsprovider_tip_title");
		if(daprivider.endWith("C3p0DataSource")){
			$dsprovider_tip_title.html("不支持C3p0DataSource数据源的界面配置");
		}else if(daprivider.endWith("JndiDataSource")){
			$dsprovider_tip_title.html("在中间件的配置文件中配置");
		}else if(daprivider.endWith("ProxoolDataSource")){
			$dsprovider_tip_title.html("ProxoolDataSource的配置功能，结合“数据源管理”菜单功能使用");
		} 
  }
  
  String.prototype.endWith=function(str){
  if(str==null||str==""||this.length==0||str.length>this.length)
     return false;
  if(this.substring(this.length-str.length)==str)
     return true;
  else
     return false;
  return true;
  }

</script>
