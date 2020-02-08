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
        
        
        <div class="searchBar">
            <table class="searchContent" cellpadding="0" cellspacing="0" >
                <tr>
                    <td class="form-label">dict</td>
                    <td class="form-value"><sc:select name="dict" _class=" " type="dict" key="pcmc,pagePrivCode" nullOption ="--dict--" /></td>
                </tr>
                <tr>
                    <td class="form-label">dict</td>
                    <td class="form-value">
                    	<sc:select name="dict1" _class=" " type="dict" key="pcmc,pagePrivCode" nullOption ="--dict--" ></sc:select>
                    	<sc:select name="dict111" _class=" " type="dict" key="pcmc,roletp" nullOption ="--dict--" ></sc:select>
                    </td>
                </tr>
                <tr>
                    <td class="form-label">部门权限</td>
                    <td class="form-value">
                    	<sc:selres name="deptPriv" index="1" size="10" type="dept" key="pcmc"  excludes="1" multiple="true"></sc:selres>
                    </td>
                </tr>
                
                 <tr>
                    <td class="form-label">三级联动</td>
                    <td class="form-value">
                    	<select class="combox" name="type" ref="key"  refUrl="/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dict_test' type='crypto'/>&actions=<sc:fmt value='selectLink' type='crypto'/>&select=type">
                    		<option value="">--请选择--</option>
                    		<option value="knp">knp</option>
                    		<option value="dict">dict</option>
                    	</select>
                    	
                    	<select class="combox" id="key" name="key" ref="dict" refUrl="/jsonprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='dict_test' type='crypto'/>&actions=<sc:fmt value='selectLink' type='crypto'/>&select=key">
                    		<option value="">--请选择--</option>
                    	</select>
                    	
                    	<select class="combox" id="dict" name="dict">
                    		<option value="">--请选择--</option>
                    	</select>
                    </td>
                </tr>
                <tr>
                	<td class="form-label">下拉搜索</td>
                	<td class="form-value">
                		<sc:select name="test" type="knp" key="pcmc,query_test" _class="jraf-select" attributesText="showserch='true' alignright='true'"/>
                	</td>
                	<td class="form-value">
                		<sc:select name="test" type="knp" key="pcmc,query_test" _class="jraf-select" attributesText="multiple='true' maxselect='3'"/>
                	</td>
                	<td class="form-value">
                		<select class="jraf-select" name="post" remoteValue="postCode" remoteLable="postTitle" value=""
                			remoteUrl="/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='postActor' type='crypto'/>&actions=<sc:fmt value='queryNoPage' type='crypto'/>">
                		</select>
                	</td>
                </tr>
                <tr>
                	<td class="form-label">
                		<a rel="test" target="dialog" href="/funcpub/valid_test.jsp" height="700" width="1200">测试</a>
                	</td>
                </tr>
            </table>
        </div>
    </form>
</div>

