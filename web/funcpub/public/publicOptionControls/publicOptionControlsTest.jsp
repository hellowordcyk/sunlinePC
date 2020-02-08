<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="org.jdom.*"%>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>公共选择控件</title>
</head>
<body scroll="no">
    <div class="pageFormContent">
    	<table width="100%">
			<tr>
				<td colspan="2">公共选择控件：</td>
			</tr>
			<tr>
				<td align="right">机构：</td>
				<td>
					<input type="text" name="deptCode" class="required" readonly="readonly" /> 
					<input type="text" name="deptName" class="required" readonly="readonly" /> 
					<a class="btnLook publicOptionControls" type="deptTree" multi="true" filter="&agb=a" 
						seletedInput="deptCode" selectedColumn="DEPTCODE" callback="deptTreeCallBack">
					</a>
				</td>
			</tr>
			<tr>
				<td align="right">人员：</td>
				<td>
					<input type="text" name="userCode" class="required" readonly="readonly" /> 
					<input type="text" name="userName" class="required" readonly="readonly" /> 
					<a class="btnLook publicOptionControls" type="userTree" multi="true" filter="&agb=a"  
						seletedInput="userCode" selectedColumn="USERCODE" callback="userTreeCallBack">
					</a>
				</td>
			</tr>
			<tr>
				<td align="right"> </td>
				<td>
					<input type="text" name="userCode" class="required" readonly="readonly" /> 
					<input type="text" name="userName" class="required" readonly="readonly" /> 
					<a class="btnLook publicOptionControls" type="userTable" multi="true" filter="&agb=a"  
						seletedInput="userCode" selectedColumn="USERCODE" callback="userTableCallBack">
					</a>
				</td>
			</tr>
			<tr>
				<td align="right">指标：</td>
				<td>
					<input type="text" name="kpiCode" class="required" readonly="readonly" /> 
					<input type="text" name="kpiName" class="required" readonly="readonly" /> 
					<a class="btnLook publicOptionControls" type="kpi" multi="true" filter="&area=all&kpiType=B,C,I&applyType=1,2"  
						seletedInput="kpiCode" selectedColumn="KPI_CODE" callback="kpiOptionCallBack">
					</a>
				</td>
			</tr>
			
			
			<!-- <tr>
				<td colspan="2">联想查询(自动补全)：</td>
			</tr>
			<tr>
				<td align="right">机构</td>
				<td>
					<input type="text" name="deptCode" class="required"/> 
					<input type="text" name="deptName" class="required autoCompleteDept" /> 
				</td>
			</tr> -->
			
		</table>
    </div>
</body>	
</html>
<script>
<%-- $(function(){
	var autoCompleteUrlForDept = "/jsonprocesserservlet"
		+"?sysName="+'<sc:fmt value='funcpub' type='crypto'/>'
		+"&oprID="+'<sc:fmt value='publicAutoComplete' type='crypto'/>'
		+"&actions="+'<sc:fmt value='getDeptData' type='crypto'/>'
		+"&agb=a";
	$(".autoCompleteDept",navTab.getCurrentPanel()).autocomplete(autoCompleteUrlForDept,{}).result(
		function(event,autocomplete){
			alert(autocomplete.info);
		}
	);
}); --%>
/**
 *机构选择控件 filter
 * 1.agb 
 *		g:管辖机构 ，即当前登录人所管辖的机构  
 *		ba:本区域，即当前登录人所在的区域  
 *		b:所属机构，即当前登录人所在的机构
 *		bg:管辖机构OR所属机构
 * 2.type: 对应机构表中的orgtype,也就是业务字典中的机构类别(pcmc,orgtype)
 *		1:总行
 *		2:支行
 *		3:网点
 *		4:管理机构
 * 3.moresql: 自定义过滤条件,以AND开头的sql语句片断，机构控件只能过滤机构表中的字段，人员控件只能过滤人员表中的字段
 *
 *人员选择控件filter
 * 1.agb 
 *		g:管辖机构下所有人员，即当前登录人所管辖的机构  
 *		ba:本区域，即当前登录人所在的区域  
 *		b:所属机构，即当前登录人所在的机构
 *		bg:管辖机构OR所属机构
 * 		me:当前登录人
 * 		gm:管辖机构OR当前登录人
 * 2.type: 对应机构表中的orgtype,也就是业务字典中的机构类别(pcmc,orgtype)
 *		1:总行
 *		2:支行
 *		3:网点
 *		4:管理机构
 * 3.moresql: 自定义过滤条件,以AND开头的sql语句片断，机构控件只能过滤机构表中的字段，人员控件只能过滤人员表中的字段
 *
 *指标选择控件filter
 * 1.area 
 *		ba:本区域，
 *		g:管辖区域，管辖机构所在的区域
 *		all:所有区域
 * 		也可以是区域号，多区域号以逗号隔开，逗号必须为英文
 * 2.kpiType: 指标类型
 *		B:基础指标
 *		C:派生指标
 *		I:手工指标
 *		多指标类型以逗号隔开，缺省值为：B,C,I
 * 3.applyType: 考核类型
 *		1:机构
 *		2:人员
 *		多考核类型以逗号隔开，缺省值为1,2
 */

function deptTreeCallBack(deptArray,dept){
	$("[name='deptCode']",navTab.getCurrentPanel()).val(dept.deptCode);
	$("[name='deptName']",navTab.getCurrentPanel()).val(dept.deptName);
}
function userTreeCallBack(userArray,user){
	$($("[name='userCode']",navTab.getCurrentPanel())[0]).val(user.userCode);
	$($("[name='userName']",navTab.getCurrentPanel())[0]).val(user.userName);
}
function userTableCallBack(userArray,user){
	$($("[name='userCode']",navTab.getCurrentPanel())[1]).val(user.userCode);
	$($("[name='userName']",navTab.getCurrentPanel())[1]).val(user.userName);
}
function kpiOptionCallBack(kpiArray,kpi){
	$("[name='kpiCode']",navTab.getCurrentPanel()).val(kpi.kpiCode);
	$("[name='kpiName']",navTab.getCurrentPanel()).val(kpi.kpiName);
}
</script>