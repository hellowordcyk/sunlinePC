<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/jui_tag.jsp" %>
<%-- <%
    String roleid = request.getParameter("roleid");
%> --%>
<div class="pageContent" width="100%" style="overflow-x:hidden;overflow-y:auto;">
    <ul id="menuGrantTree" class="ztree" style="padding-bottom:50px;"></ul>
</div> 
<div class="formBar" >
    <ul>
        <li><button type="button" class="button" onclick="grantMenu()">保存</button></li>
        <li><button type="button" class="close">取消</button></li>
    </ul>
</div>

<script type="text/javascript">
var menuGrantSetting = {
    view: {
        dblClickExpand: true,//是否双击展开树
        showLine: true,// 是否显示连接线
        selectedMulti: false,// 是否多选
        showIcon : true// 是否显示图标
    },
    check: {
        enable: true,
        autoCheckTrigger: true
    },
    data: {
        simpleData: {
            enable:true
        }
    }
};
$(function(){
	var currentRole =  $("#currentRoleid_id").val(); 
    var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>&oprID=<sc:fmt value='deployMenu' type='crypto'/>&actions=<sc:fmt value='getUserMenu' type='crypto'/>";
    $.ajax({    
        type:'post',        
        url:url,
        async:false, 
        data:"currentRole="+currentRole,
        dataType:'XML', 
        success:function(data){   
            var zNodes = $(data).find('DataPacket Response Data menutree').text();
            $.fn.zTree.init($('#menuGrantTree'), menuGrantSetting,$.parseJSON(zNodes));
        }    
    });    
});
function grantMenu(){
    var treeObj = $.fn.zTree.getZTreeObj("menuGrantTree");
    var nodes = treeObj.getChangeCheckedNodes();
    var menuids = new Array();
    $(nodes).each(function(index,node){
        menuids.push(node.id);
    });     
    var url = "/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>"
            + "&oprID=<sc:fmt value='deployMenu' type='crypto'/>"
            + "&actions=<sc:fmt value='setCommonMenu' type='crypto'/>"
            + "&menuids="+menuids;
    $.ajax({    
        type:'post',        
        url:url,
        async:false,   
        dataType:'XML', 
        success:function(data){
            var msg = $(data).find('DataPacket Response Data msg').text();
            if(msg == "success"){
            	//重新加载顶部和左边菜单
            	var userFavorMenuId =$("#userFavorMenu_id").val();
            	if(typeof(Jraf.menuCacheMap[userFavorMenuId]) != "undefined"){
            		Jraf.menuCacheMap[userFavorMenuId]=[];
            	}
            	loadMenu();
                alertMsg.correct("设置成功");
                //将当前节点变化更新
                for (var i=0, l=nodes.length; i<l; i++) {
                	  nodes[i].checkedOld = nodes[i].checked;
                }
            }else{
                alertMsg.error(msg);
            }
        }    
    });    
}
</script>