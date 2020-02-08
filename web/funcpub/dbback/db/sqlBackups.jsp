<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@page import="java.util.Arrays"%>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<%--
 * title: 库备份执行
 * description: 
 *     1.库备份执行
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160622 优化布局
 *--%>

<sc:doPost sysName="funcpub" oprId="sqlBackups" action="sysSql" scope="request" var="rspPkg" all="true"></sc:doPost>

<!-- 方法地址： /funcpub/web/WEB-INF/config/operation/funcpub/bdss-config.xml -->	
<form rel="sqlBackups" method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sqlBackups' type='crypto'/>&actions=<sc:fmt value='InterruptedException' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)">
	<div class="pageContent">
        <div class="pageFormContent">
            <table class="form-table" cellpadding="0" cellspacing="0" >
    			
            		<%
            			PkgUtil pk = (PkgUtil)request.getAttribute("rspPkg");
            			String paraName = pk.getPkg().getRootElement().getChild("Response").getChild("Data").getChildTextTrim("paraName");
            			String paraValue = pk.getPkg().getRootElement().getChild("Response").getChild("Data").getChildTextTrim("paraValue");
            			if(paraName.length()>0) {
            				
            			
            			String[] sysName = paraName.split(",");
            			String[] sysValue = paraValue.split(",");
            			sysValue = Arrays.copyOf(sysValue, sysName.length);
            			for(int i = 0;i<sysName.length;i++){
            		%>
            		        <tr>
            					<td class="form-label"><span class="redmust">*</span><%=sysName[i]%></td>
            					<td class="form-value"><input name="para<%=i%>" id="para<%=i %>" value="<%=sysValue[i]%>" required="required"/></td>
            					
    			             </tr>
    			
            					
            		<%
            			}
            		%>
                
                <tr>
                    <td class="form-label"><span class="redmust">*</span>存放地址</td>
                    <td class="form-value"><input name="savePath" required="required"/></td>
                </tr>
    		</table>
    	</div>
     </div>
     <div class="formBar">
        <ul>
            <li><button class="savebtn" type="submit">执行</button></li>
            <li><button class="close" type="button">取消</button></li>
        </ul>
    </div>
</form>