<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>

<h2 class="contentTitle">新增系统资源组</h2>
<script type="text/javascript">
</script>
	
<div class="pageContent" style="width: 486px;height: 220px;"> 
	<form method="post" action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sys_res_gp' type='crypto'/>&actions=<sc:fmt value='addRescGroup' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>" class="pageForm required-validate" onsubmit="return validateCallback(this,rescGroupAjaxDone)">
       <div>
	       	<table class="searchContent" border="0" width="100%" cellspacing="0" cellpadding="0">
	       	  <tr>
			    <td align="right">资源组名称:</td>
					<td> 
					    <sc:text id="rsgpna" name="rsgpna"  attributesText='maxlength="20"' validate="required"/>
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
	</form>
	
</div>
