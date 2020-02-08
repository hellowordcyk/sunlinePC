<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 角色选择页面
 * description: 
 *     1.角色选择页面
 * author: 
 * createtime: 
 * logs:
 *--%>
<div class="pageHeader">
    <form id="rolelookupSingleList_divid_pagerForm" onsubmit="return divSearch(this, 'rolelookupSingleList_divid');"
        action="/httpprocesserservlet" method="post">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>" />
        <input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>" />
        <input type="hidden" name="actions" value="<sc:fmt value='queryRole' type='crypto'/>" />
        <input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/funcpub/public/role/roleLookupSingleList.jsp' />" />
        <sc:hidden name="lookupid" index="1" default="lookupid"/>
        <sc:hidden name="lookupcode"  index="1" default="lookupcode"/>
        <sc:hidden name="lookupname"  index="1" default="lookupname"/>
        <sc:hidden name="proleid" />
        
        <sc:hidden name="jraf_initsubmit" />
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0">
                <tr>
                    <td class="form-label">角色代码/名称</td>
                    <td class="form-value">
                        <sc:text name="${param.lookupname}" />
                    </td>
                    <td class="form-btn">
                        <ul>
                            <li>
                                <button id="selectChildUserBtn" class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</div>
<div class="pageContent" id="rolelookupSingleList_divid"></div>