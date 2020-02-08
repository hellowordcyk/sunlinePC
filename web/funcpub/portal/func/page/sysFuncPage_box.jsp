<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<div class="pageContent" style="padding-bottom:8px;">
   <div class="tabs" currentIndex="0" eventType="click"  >
		<div class="tabsHeader">
			<div class="tabsHeaderContent">
				<ul>
					<li initTab="true">
                    	<a id="page_detail_tab" href="/httpprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='sysFuncPageActor' type='crypto'/>&actions=<sc:fmt value='getSysFuncPage' type='crypto'/>&forward=<sc:fmt value='/funcpub/portal/func/page/sysFuncPage_update.jsp' type='crypto'/>&funcCode=${param.funcCode}" 
                           target="ajax" rel="page_detail_ctt">
                           <span>基本信息</span>
                        </a>
                    </li>
					<li>
                    	<a id="element_list_tab" href="/funcpub/portal/func/pageElement/sysFuncElement_main.jsp?funcPageCode=${param.funcCode}" 
                           target="ajax" rel="element_list_ctt">
                           <span>页面表单元素</span>
                        </a>
                    </li>
					<li>
                    	<a id="page_relationship_tab" href="/funcpub/portal/func/page/sysFuncRelationship_main.jsp?funcSuperCode=${param.funcCode}" 
                           target="ajax" rel="page_relationship_ctt">
                           <span>子页面关联</span>
                        </a>
                    </li>
				</ul>
			</div>
		</div>
		<div class="tabsContent">
			<div id="page_detail_ctt"></div>
			<div id="element_list_ctt"></div>
			<div id="page_relationship_ctt"></div>
		</div>
	</div>
</div>