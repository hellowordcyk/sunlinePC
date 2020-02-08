<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%-- 
*logs:
*	edited by beidao on 20160706 优化布局
--%>
<form class="pageForm required-validate" onsubmit="return validateCallback(this,dialogAjaxDone)" method="post" name="sysrecAddForm"  
	  action="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sys_res' type='crypto'/>&actions=<sc:fmt value='addSysResourse' type='crypto'/>&forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>">
      
      <div class="pageContent" >
       	 <div class="pageFormContent">
	       	<table class="form-table" cellspacing="0" cellpadding="0">
	           <tr>
	              <td class="form-label">资源类型</td>
			      <td class="form-value">
			          	<sc:select  id ="resctp" name="resctp"  type="knp" key="pcmc,resctp" includeTitle="false" index="1"/>
			      </td>
			      <td class="form-label">子系统 </td>
			      <td class="form-value">
			          <sc:select  id ="subsys" name="subsys"  type="subsys"  includeTitle="false" index="1"/>
			      </td>  
	          </tr>
			  <tr>  
			        <td class="form-label">资源代码</td>
				    <td class="form-value">
				         <sc:text id="resccd" name="resccd"  attributesText='maxlength="20"' validate="required"/>
				    </td>
					<td class="form-label">资源名称</td>
					<td class="form-value"> 
					    <sc:text id="rescna" name="rescna"  attributesText='maxlength="20"' validate="required"/>
				   </td>  
			  </tr>
			 <tr>  
			     <td class="form-label">资源启用日期</td>
				 <td class="form-value">
				    <sc:date id="begndt_add"  name="begndt" dateFmt="yyyy-MM-dd" minDate="2000-01-15" maxDate="2020-12-15"
				     readonly="true" validate="required"/>
				 </td> 
				 <td class="form-label">资源终止日期</td>
				 <td class="form-value">
				    <sc:date id="matudt"  name="matudt" dateFmt="yyyy-MM-dd"  
						minDate="2000-01-15" maxDate="2020-12-15" attributesText="compareDate='#begndt_add,>'" readonly="true"/>
				 </td>
		  </tr>
	    </table>
	   </div>
 	</div>
	<div class="formBar">
		<ul>
			<li><button class="savebtn" type="submit">保存</button></li>
            <li><button class="close" type="button">取消</button></li>
		</ul>
	</div>
</form>
