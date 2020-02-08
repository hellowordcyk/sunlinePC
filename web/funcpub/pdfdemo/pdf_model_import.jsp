<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>pdf模板上传</title>
<script type="text/javascript">

</script>
</head>

<body scroll="no">
    <div class="pageHeader">
        <form name="importReportForm" encType="/jui/callMessage.so?csrftoken=${csrftoken}" method="post" action="/httpprocesserservlet" 
             							class="pageForm required-validate" onsubmit="return iframeCallback(this,dialogAjaxDone)" >
            <input type="hidden" name="sysName" value='<%=Crypto.encode(request,"funcpub")%>'/>
            <input type="hidden" name="oprID" value='<%=Crypto.encode(request,"examplePdf")%>'/>
            <input type="hidden" name="actions" value='<%=Crypto.encode(request,"uploadPdfTemp")%>'/>
           <%--  <input type="hidden" name="forward" value='<%=Crypto.encode(request,"/jui/callMessage.jsp")%>'/> --%>
             <table class="table" width="100%">
             	<tr>
             		<td>
                        <span style="color:red; height: 30px;line-height: 30px;">请选择.pdf文件</span>
                    </td>
             	</tr>
             	<tr>
             		<td><input type="file" name="pdfFile" style="width: 100%;"/></td>
             	</tr>
             	<tr>
             		<td>
                        <input type="button" class="button" onclick="uploadFile();" value="点击上传"  />
                    </td>
             	</tr>
             </table>
        </form>
    </div>
  
</body>

<script type="text/javascript">
    function uploadFile(){
    	var $form = $("form[name='importReportForm']", $.pdialog.getCurrent());
    	var pdfFileVal = $form.find("input[name='pdfFile']").val();
    	if(!pdfFileVal){
    		alertMsg.error("请选择文件！！");
    	}else{
    		pdfFileVal = pdfFileVal.toLowerCase();
    		
    		if(pdfFileVal.lastIndexOf(".pdf") == -1){
    			alertMsg.error("请选择PDF格式文件！！");
    		}else{
    			//提交表单
    			$form.submit();
    		}
    	}
    	
    }
	
</script>
</html>