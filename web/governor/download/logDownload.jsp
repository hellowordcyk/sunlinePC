<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <%@ include file="/jui_tag.jsp" %>
</head>
<body style="padding: 0 5px 5px;">
	<div>
		<table align="center" class="form-table" border="0" width="100%"  cellspacing="0" cellpadding="0" style="margin: 0; border-bottom: 0;">
			<tr>
				<td colspan="3" style="padding: 0;">
					<div class="page-tip" style="margin: 0;">
						<span class="tip-title">温馨提示</span>
						<p>日志管理，根据配置不同的日志级别实现记录系统日志功能；</p>
						<p>日志级别顺序： DEBUG &lt; INFO &lt; WARN &lt; ERROR；日志是否记录保存，根据日志级别判断；<b>高级别的不会记录低级别的日志；</b>如选Debug模式，系统会记录Debug、Info、Warn、Error级别的日志；如选择Info，则会记录Info、Warn、Error；</p>
						<p>DEBUG模式： 适用于“开发环境”，系统运行中会将记录调试信息；此模式下会记录访问数据库的SQL语句以其它明细数据；可用此更好的排除找到错误；</p>
						<p>INFO模式：正式投产时，为提高性能但又能看到系统的提示信息；</p>
					</div>
				</td>
			</tr>
        	<tr>
              	<td class="form-label" width="8%">文件个数：</td>
             	<td class="form-value" width="18%">
             		<select id="file_count" onchange="showItemsLog()" style="width:152px;" req="1">
			            <option value="10">10</option>
			            <option value="20">20</option>
			            <option value="30">30</option>
			            <option value="40">40</option>
			            <option value="50">50</option>
			            <option value="60">60</option>
			            <option value="70">70</option>
			            <option value="80">80</option>
			            <option value="90">90</option>
			            <option value="100">100</option>
		            </select>
             	</td>
				<td class="form-bottom" width="74%" style="padding-top:5px;padding-bottom:5px;text-align:right;padding-right:10px;">
					<input type="button" name="bug"  class="button" value="DEBUG模式" onclick="debug('doDebug')" />
			  		<input type="button" name="debug"  class="button" value="INFO模式(推荐)" onclick="debug('doInfo')" />
			    	<input type="button" name="openDebug"  class="button" value="WARN模式" onclick="debug('doWarn')" />
			  		<input type="button" name="stopDebug"  class="button" value="ERROR模式" onclick="debug('doError')" />
			    </td>
			</tr>
        </table>
	</div>
	<div id='dataId'>
        
	</div>
</body>
<script type="text/javascript" defer="defer">
$(function(){
	showItemsLog();
});
function showItemsLog(){
	var count = $("#file_count",navTab.getCurrentPanel()).val();
	var params = "count="+count;
	var url="/governor?flag=initConfig&actorName=getLogList"
	$("#dataId").ajaxUrl({
		type:"POST", url:url, data: params, callback:""
	});
}

function debug(type) {
	var url = "/governor?flag=initConfig"
	    + "&actorName=setLogLevel&type="+type;
	$.ajax({
		type:'POST',
		url: url,
		dataType:'json',
		error: DWZ.ajaxError,
		async:false,
		success:function(data){
			console.log(data);
			if(data.msgCode=='1'){
				alertMsg.correct(data.message);
			}else{
				alertMsg.error(data.message);
			}
		}
	});
}
</script>
</html>