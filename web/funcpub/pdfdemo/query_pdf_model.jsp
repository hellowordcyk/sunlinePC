<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--规范：每个页面前必需增加注释。1）说明主要功能；2）主要功能修改日志 --%>
<%--
 * title: PDF操作
 * description: 
 *     上传PDF模板，查看并显示PDF
 * author: lihu
 *--%>
<div class="pageHeader">
    <%-- 规范： 分页form的id,规定为列表id+"_pageForm"，如：role_main_listid_pagerForm --%>
    <form id="pdf_model_divid_pagerForm" onsubmit="return divSearch(this, 'pdf_model_divid');"  method="post"
        action="/httpprocesserservlet">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
        <input type="hidden" name="oprID" value="<sc:fmt value='examplePdf' type='crypto'/>"/>
        <input type="hidden" name="actions" value="<sc:fmt value='queryPdfTempList' type='crypto'/>"/>
        <sc:hidden name="forward" value="<sc:fmt value='/funcpub/pdfdemo/query_pdf_model_list.jsp' type='crypto'/>"/>

        <%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
        
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0" >
                <tr>
                    <td class="form-label">模板名称 </td>
                    <td class="form-value"><sc:text name="tempname"/></td> 
                    <td class="form-btn">
                        <ul>
                            <li>
                                <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                                <button class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            
                        </ul>
                    </td>
                </tr>
            </table>
        </div>
    </form>
</div>
<div class="pageContent">
    <div class="panelBar">
        <ul class="toolBar">
            <li>
                <a class="import" href="/funcpub/pdfdemo/pdf_model_import.jsp" mask="true"
                	height="300" width="800" target="dialog" rel="importReport"><span>上传PDF模板</span></a>
            </li>
            <%-- 按钮组分隔 --%>
            <li class="line">line</li> 
         </ul>
    </div>    
    <%-- 局部刷新加载列表，列表区域id编码方式为“主页面jsp文件名+listid” --%>
    <div id="pdf_model_divid">
        <%--以下列表只用于刚进入页面初始展示用，认真查询的列表在子页面--%>
        <table class="table" cellpadding="0" cellspacing="0" >
            <thead>
                <tr>
                    <%-- 规范：设置表格列宽度， 保证一个td列不设置宽度表示自动计算为100%剩余宽度--%>
                    <th class="checkbox"><input class="checkboxCtrl" type="checkbox" group="paramp" /></th>
                    <th width="80%">模板名称</th>
                    <th>操作</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td colspan="5" class="empty">请选择条件查询。</td>
                </tr>
            </tbody>
        </table>
    </div>
</div>
