<%@ taglib uri="http://www.sunline.cn/jsp/common" prefix="sc"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="http://displaytag.sf.net" prefix="display"%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
					<tr>
                         <td>
                            <sc:hidden name="act" default="list" />
                            <input type="button" class=btn value="新增" onClick="add();">
							<input type="submit" value="刷新" onClick="refresh();">
							<input type="button" class=btn value="返回" onclick="history.back();">
							<input type="button" class=btn value="删除" onClick='deleteSelected("userid");'>
						</td>
						<td width="10%">&nbsp;<font color="#FFFFFF">查询条件</font></td>
						<td valign="top" align=right>
							<sc:text name="usercode" dspName="用户编号" size="10" dsp="sp" />&nbsp;
							<sc:text name="username" size="10" dspName="用户名" dsp="sp" />&nbsp;
							<sc:text name="deptname" size="10" dspName="部门名称" dsp="sp"/> &nbsp;&nbsp;
							<input type="button" class=btn value="查询" onclick="doSearch();">
						</td>					</tr>
				</table>
				
				
				
				
				
				