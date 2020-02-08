<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<h2 class="contentTitle">系统资源组修改</h2>
 <form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sys_res_gp' type='crypto'/>&actions=<sc:fmt value='updateRescGroup' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,rescGroupAjaxDone)">
	<div class="pageContent"  style="padding-bottom: 50px;">
		<div class="pageFormContent">
			<table class="searchContent" border="0" width="100%" cellspacing="0" cellpadding="0">
				<tr>
				        <td align="right">资源组编码:</td>
						<td> 
						    <sc:text id="rsgpid" name="rsgpid"  readonly="true" index="1"/>
					   </td>  
				  </tr>
		       	  <tr>
				        <td align="right">资源组名称:</td>
						<td> 
						    <sc:text id="rsgpna" name="rsgpna"  attributesText='maxlength="20"'  validate="required" index="1"/>
					   </td>  
				  </tr>
		           <tr>
		              <td align="right">资源类型  ：</td>
				      <td>
				          	<sc:select  id ="resctp" name="resctp"  type="knp" key="pcmc,resctp"  includeTitle="false" index="1"/>
				      </td>
		          </tr>
				  <tr>  
				   	  <td align="right">子系统 </td>
				      <td>
				          <sc:select  id ="subsys" name="subsys"  type="subsys" includeTitle="false" index="1"/>
				      </td>  		
				   </tr>
	    	</table>
		</div>
		<div class="formBar">
			<ul>
				<li><input type="submit" class="button" value="提交" /></li>
				<li><div class="buttonActive"><button type="button" class="close">取消</button></div></li>
			</ul>
	  </div>
 </div>
</form>
	

<script type="text/javascript">
	function customvalidXxx(element){
		if ($(element).val() == "xxx") 
			 return false;
		return true;
	}
	
</script>
