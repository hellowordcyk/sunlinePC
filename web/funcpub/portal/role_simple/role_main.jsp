<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--规范：每个页面前必需增加注释。1）说明主要功能；2）主要功能修改日志 --%>
<%--
 * title: 角色管理
 * description: 
 *     1.维护（新增、修改、删除）角色信息；
 *     2.分配角色菜单权限；
 *     3.分配角色资源权限；
 *     4.设置角色权限分组：根据不同权限组设置，获取相应数据访问权限（目前主要是机构访问权限）
 * author: WengZhiYong
 * createtime: 2015-05-01 10:30
 * logs:
 *     edited by LongJiang on 20160403 按照新资源权限功能，修改资源权限页面
 *     edited by Sean on 20160529 优化布局
 *--%>
<div class="pageHeader">
    <%-- 规范： 分页form的id,规定为列表id+"_pageForm"，如：role_main_listid_pagerForm --%>
    <form id="role_main_listid_pagerForm" onsubmit="return divSearch(this, 'role_main_listid');"  method="post"
        action="/httpprocesserservlet">
        <input type="hidden" name="sysName" value="<sc:fmt value='funcpub' type='crypto'/>"/>
        <input type="hidden" name="oprID" value="<sc:fmt value='PcmcRole' type='crypto'/>"/>
        <input type="hidden" name="actions" value="<sc:fmt value='queryRole' type='crypto'/>"/>
        <input type="hidden" name="forward" value="<sc:fmt value='/funcpub/portal/role_simple/role_main_list.jsp' type='crypto'/>"/>
        <%-- 规范： 初始化查询必加隐藏表单 --%>
        <sc:hidden name="jraf_initsubmit"/>
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0" >
                <tr>
                    <td class="form-label">子系统</td>
                    <td class="form-value"><sc:select name="subsys" type="subsys" nullOption ="--所有子系统--"/></td>
                    <td class="form-label">角色名称 </td>
                    <td class="form-value"><sc:text name="rolename"/></td> 
                    <td class="form-btn" rowspan="2">
                        <ul>
                            <li>
                                <%-- 规范： 进入页面初始化查询必加属性：jraf_initsubmit和hidden inpu的name为jraf_initsubmit的表单 --%>
                                <button class="querybtn" jraf_initsubmit type="submit">查询</button>
                            </li>
                            <li>
                                <button class="resetbtn" type="reset">清空</button>
                            </li>
                        </ul>
                    </td>
                </tr>
                <tr>
                	<td class="form-label">已授权用户 </td>
                    <td class="form-value" colspan="3">
                    	<sc:hidden name="userid" />
	                    <sc:text name="username" readonly="true"/>
	                    <a class="btnLook" title="选择用户" lookupGroup=""  width="900" height="500"
	                     href="/funcpub/public/deptuser/userLookupSingle.jsp?lookupid=userid&lookupname=username"></a>
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
                <%-- 规范：a标签属性顺序：class->target->rel->title->width->height->其他->href（地址单独一行） --%>
                <a class="add" target="dialog" rel="addRole" title="新增角色" width="500" height="330"
                   href="/funcpub/portal/role/role_add.jsp">
                   <span>新增</span>
                </a>
            </li>
            <li>
                <a class="delete" target="selectedTodo" rel="paramp" title="确定要删除所选记录吗?" 
                   href="/httpprocesserservlet?forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>&sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='PcmcRole' type='crypto'/>&actions=<sc:fmt value='delRole' type='crypto'/>" >
                   <span>删除</span>
                </a>
            </li>
            <%-- 按钮组分隔 --%>
            <li class="line">line</li> 
         </ul>
    </div>    
    <%-- 局部刷新加载列表，列表区域id编码方式为“主页面jsp文件名+listid” --%>
    <div id="role_main_listid">
        <%--以下列表只用于刚进入页面初始展示用，认真查询的列表在子页面--%>
	        <table class="table" cellpadding="0" cellspacing="0" >
	            <thead>
	                <tr>
	                    <%-- 规范：设置表格列宽度， 保证一个td列不设置宽度表示自动计算为100%剩余宽度--%>
	                    <th class="checkbox"><input class="checkboxCtrl" type="checkbox" group="paramp" /></th>
	                    <th width="10%">所属系统</th>
	                    <th width="20%">角色名称</th>
	                    <th width="20%">角色说明</th>
	                    <th width="10%">权限分组</th>
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
