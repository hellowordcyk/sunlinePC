<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title: 机构选择，多选
 * description: 
 *     1.机构选择，多选
 * author: 
 * createtime: 
 * logs:
 *     edited by LongJiang on 20160706优化布局
 *--%>
<div class="pageHeader">
	<form id="govCorpLookupMultiList_divid_pagerForm" onsubmit="return divSearch(this, 'govCorpLookupMultiList_divid');" action="/httpprocesserservlet"
	  method="post">
	<input type="hidden" name="sysName" value="<sc:fmt value='governor' type='crypto'/>"/>
	<input type="hidden" name="oprID" value="<sc:fmt value='corpActor' type='crypto'/>"/>
	<input type="hidden" name="actions" value="<sc:fmt value='queryCorpList' type='crypto'/>"/>
	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/governor/corp/corpmanage/govCorpLookupMultiList.jsp' />"/>
	<input type="hidden" name="pageNum" value="1" />
	<sc:hidden name="lookupcode" index="1" default="lookupcode" />
	<sc:hidden name="lookupname" index="1" default="lookupname"  />
	<sc:hidden name="jraf_initsubmit" />
		<div class="searchBar">
			<table class="searchContent" cellpadding="0" cellspacing="0" >
				<tr>
					<td class="form-label">法人编码/名称</td>
					<td class="form-value"><sc:text name="corpcodeOrName" index="1"/></td>
					<td class="form-btn">
                        <ul>
                            <li>
                                <button class="querybtn" jraf_initsubmit type="submit">查询</button>
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
<div class="pageContent" id="govCorpLookupMultiList_divid" >
</div>
<div class="formBar">
    <ul>
    	<button type="button" class="button" multLookup="checkboxgroup" warn="请选择法人">选择</button>
        <li><button class="close" type="button">取消</button></li>
    </ul>
</div>
