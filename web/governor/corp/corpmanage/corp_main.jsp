<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<script src="/governor/corp/corpmanage/corp_imageUpload.js" type="text/javascript"></script>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
 * title:法人查询列表
 * description: 
 *     显示所有法人信息
 * author: hzx
 * createtime: 20160907
 * logs:
 *
 *--%>
<div class="pageHeader">
	<form id="pagerForm" action="/httpprocesserservlet" method="post" onsubmit="return navTabSearch(this);">
    	<input type="hidden" name="sysName" value="<sc:fmt type='crypto' value='governor'/>"/>
    	<input type="hidden" name="oprID" value="<sc:fmt type='crypto' value='corpActor'/>"/>
    	<input type="hidden" name="actions" value="<sc:fmt type='crypto' value='queryCorpList'/>"/>
    	<input type="hidden" name="forward" value="<sc:fmt type='crypto' value='/governor/corp/corpmanage/corp_main.jsp' />"/>
        
        <sc:hidden name="jraf_initsubmit" />
     	<div class="searchBar">
    		<table class="searchContent" cellpadding="0" cellspacing="0" >
    			<tr>
    				<td class="form-label">法人编码</td>
    				<td class="form-value"><sc:text name="corpCode" id="corpCode" /></td>
    				<td class="form-label">法人名称</td>
    				<td class="form-value"><sc:text name="corpName" id="corpName" /></td>
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
<div class="pageContent">
 	<div class="panelBar">
        <ul class="toolBar">
            <li>
                <%-- 规范：a标签属性顺序：class->target->rel->title->width->height->其他->href（地址单独一行） --%>
                <a class="add" target="dialog" rel="addCorp" title="新增法人" width="530" height="450"
                   href="/governor/corp/corpmanage/corp_add.jsp">
                   <span>新增</span>
                </a>
            </li>
            <li>
                <a class="delete" target="selectedTodo" rel="paramp" title="确定要停用所选记录吗?" 
                   href="/httpprocesserservlet?forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>&sysName=<sc:fmt value='governor' type='crypto'/>&oprID=<sc:fmt value='corpActor' type='crypto'/>&actions=<sc:fmt value='delCorp' type='crypto'/>" >
                   <span>停用</span>
                </a>
            </li>
             <li>
                <a class="edit" target="selectedTodo" rel="paramp" title="确定要启用所选记录吗?" 
                   href="/httpprocesserservlet?forward=<sc:fmt value='/jui/callMessage.jsp' type='crypto'/>&sysName=<sc:fmt value='governor' type='crypto'/>&oprID=<sc:fmt value='corpActor' type='crypto'/>&actions=<sc:fmt value='updateCorp' type='crypto'/>" >
                   <span>启用</span>
                </a>
            </li>
            <%-- 按钮组分隔 --%>
            <li class="line">line</li> 
         </ul>
    </div>
	<table class="table" cellpadding="0" cellspacing="0" >
		<thead>
			<tr>
			    <th class="checkbox"><input class="checkboxCtrl" type="checkbox" group="paramp" /></th>
				<th>法人编码</th>
				<th>法人名称</th>
				<th>法人简称</th>
				<th>核心法人编码</th>
				<th>从属法人编码</th>
				<th>停用状态</th>
				<th>创建时间</th>
				<th>操作</th>
			</tr>
		</thead>
		<tbody>
        <c:choose>
            <c:when test="${empty jrafrpu.rspPkg.rspRcdDataMaps}"> 
                <tr>
                    <td class="empty" colspan="9">查询无数据。</td>
                </tr>
            </c:when>
            <c:otherwise>
    			<c:forEach var="corp" items="${jrafrpu.rspPkg.rspRcdDataMaps }" varStatus="status">
    				<tr <c:if test="${status.index%2 != 0}"> class="evenrow"</c:if>>
    					<td class="checkbox">
    						<input type="checkbox" name="paramp" value="${corp.corpCode}"/>
    					</td>
    					<td>${corp.corpCode }</td>
    					<td>${corp.corpName }</td>
    					<td>${corp.corpShortname }</td>
    					<td>${corp.corpFromcore }</td>
    					<td>${corp.corpParent }</td>
    					<td>
    						<sc:optd name="corpDisable" type="dict" key="pcmc,boolflag" value="${corp.corpDisable}"/>
    					</td>
    					<td>
    						<sc:fmt value="${corp.corpCreatetime }" type="date" pattern="yyyy-MM-dd HH:mm:ss"/>
    					</td>
    					<td>
    						<a  class="btnEdit" target="dialog" rel="editCorp" title="修改法人" width="530" height="450"
    							href="/httpprocesserservlet?sysName=<sc:fmt value='governor' type='crypto'/>&oprID=<sc:fmt value='corpActor' type='crypto'/>&actions=<sc:fmt value='getCorp' type='crypto'/>&forward=<sc:fmt value='/governor/corp/corpmanage/corp_edit.jsp' type='crypto'/>&corpCode=${corp.corpCode}">
    							修改
    						</a>
    						<a  class="btnEdit" target="navTab" rel="initCorpData" title="数据初始化" 
    							href="/httpprocesserservlet?sysName=<sc:fmt value='governor' type='crypto'/>&oprID=<sc:fmt value='corpInitActor' type='crypto'/>&actions=<sc:fmt value='queryCorpInitConfig' type='crypto'/>&forward=<sc:fmt value='/governor/corp/init_data/init_main.jsp' type='crypto'/>&corpcode=${corp.corpCode}">
    							数据初始化
    						</a>
    					</td>
    				</tr>
    			</c:forEach>
            </c:otherwise>
        </c:choose>
		</tbody>
	</table>
	<div class="panelBar">
		<div class="pagination" targetType="navTab" 
			totalCount  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.RecordCount}" 
			numPerPage  = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageSize}"
			currentPage = "${jrafrpu.rspPkg.rspDataMap.PageInfo.PageNo}">
			
		</div>
	</div>
</div>
<script>
function checkimg(obj){
	var filename = obj.val();
	if(filename == ""){
		return true;
	}
	var begin=filename.lastIndexOf(".");
	var end=filename.length;
	var str=filename.substring(begin+1,end);
	if(str!='jpg' && str != 'gif'&& str != 'png'){
		alertMsg.error("请选择格式为.jpg ,.gif或者.png的图片格式导入!");
		obj.value = "";
		return false;
	}
	return true;
}
</script>