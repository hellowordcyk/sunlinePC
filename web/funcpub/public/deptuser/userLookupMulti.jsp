<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 机构人员页面，多选
 * description: 
 *     1.机构人员页面，多选
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160706 优化布局
 *--%>
<div class="pageHeader">
	<form id="publicuserlookupMultiList_divid_pagerForm" onsubmit="return divSearch(this, 'publicuserlookupMultiList_divid');" action="/httpprocesserservlet"
	  method="post">
		<input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
		<input type="hidden" name="oprID" value="<sc:fmt value='funcpub-deptusermanager-public' type='crypto'/>"/>
		<input type="hidden" name="actions" value="<sc:fmt value='getPcmcUserDeptList' type='crypto'/>"/>
		<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/public/deptuser/userLookupMultiList.jsp' />"/>
		<input type="hidden" name="pageNum" value="1" />
		<sc:hidden name="lookupcode" index="1" default="lookupcode"/>
		<sc:hidden name="lookupname" index="1"  default="lookupname"/>
		<sc:hidden name="lookupid" index="1"  default="lookupid"/>
		<sc:hidden name="lookuptype" index="1"  default="${param.lookuptype}"/>
	    <sc:hidden name="jraf_initsubmit" />
	   
		<div class="searchBar">
			<table class="searchContent" width="100%">
				<tr>
					<td class="form-label">机构编码/名称</td>
					<td class="form-value">
					    <sc:text name="deptname" index="1"/>
						<%-- <jsp:include page="/funcpub/public/deptuser/deptlookup_include.jsp">
							<jsp:param name="code" value="deptid"/>
							<jsp:param name="name" value="deptname"/>
							<jsp:param name="isMulti" value="false"/>
							<jsp:param name="isLookup" value="false"/>
						</jsp:include> --%>
					</td>
					<td >
						<input type="radio" name="jurisType" value="0" checked="checked" />本行
						<input type="radio" name="jurisType" value="1" />管辖
					</td>
					<td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <button id="selectChildUserBtn" class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button type="button" class="button" multLookup="checkboxgroup" warn="请选择机构">选择带回</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
				</tr>
				<tr>	
					<td class="form-label">用户编码/名称</td>
					<td class="form-value"><sc:text name="${param.lookupname}" /></td>
					<td></td>
				</tr>
			</table>
		</div>
	</form>
</div>
<div class="pageContent" id="publicuserlookupMultiList_divid" >
</div>