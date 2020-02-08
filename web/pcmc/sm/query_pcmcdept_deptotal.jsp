<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="/common.jsp" %>
<div id="tab">
    <ul id="menus-tab">
        <li targetid="seldept">本级机构</li>
        <li targetid="subdept">下级机构</li>
        <li targetid="deptuserinfo">部门用户</li>
    </ul>
    <div id="tabContentId" class="content">
        <div id="seldept"></div>
        <div id="subdept"></div>
        <div id="deptuserinfo"></div>
    </div>
</div>
<script type="text/javascript" defer="defer">
 
function initRoot(){
	rootAction();
	setHeightAuto();
}
function setHeightAuto() {
    $("tabContentId").setStyle({height: ($("mainRightId").getHeight() - $("menus-tab").getHeight() -2) + "px"});
}
function rootAction(){
 
 var parserTab = new Jraf.Tabs({
	 tabid:"menus-tab",
	 displayStyle:"div",
	 displayID:{seldept: 'seldept', subdept: 'subdept', deptuserinfo: 'deptuserinfo'},
     globalRefresh:  true
});

			var param1= {
			                sysName:    "<sc:fmt value='pcmc' type='crypto'/>",
			                oprID:      "<sc:fmt value='sm_maintenance' type='crypto'/>",
			                actions:    "<sc:fmt value='getOrgDeptDetail' type='crypto'/>",
			                 url:       "/pcmc/sm/query_pcmcdept_seldept.so",
			                 deptid:    '${param.deptid}'
			            };
			var param2 = {
			                sysName:    "<sc:fmt value='pcmc' type='crypto'/>",
			                oprID:      "<sc:fmt value='sm_query' type='crypto'/>",
			                actions:    "<sc:fmt value='getSubDeptInfo' type='crypto'/>",
			                url:       "/pcmc/sm/query_pcmcdept_subdept.so",
			                deptid:    '${param.deptid}',
			                levelp:    '${param.levelp}'
			            };  
            var param3 = {
			                sysName:    "<sc:fmt value='pcmc' type='crypto'/>",
			                oprID:      "<sc:fmt value='sm_query' type='crypto'/>",
			                actions:    "<sc:fmt value='getUsers' type='crypto'/>",
			                url:       "/pcmc/sm/query_pcmcdept_deptuserinfo.so",
			                deptid:    '${param.deptid}'
            			}; 
	
	
	if('${param.deptid}' == ''){
	param1 ={url:"/pcmc/sm/query_pcmcdept_seldept.jsp"};
	}
	parserTab.addAction(1, param1);
	parserTab.addAction(2, param2);
	parserTab.addAction(3, param3);
	parserTab.init(1);
	
}
initRoot();
</script>	    
