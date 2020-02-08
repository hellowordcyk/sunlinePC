<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<script language="javascript">
//var jrafmenu = new Jraf.DropDownMenu({selector:'#tomenu',menuItems:[]});
//var mc=jrafmenu.menuContext;
addSubSysMenus('<c:out value="${param.subsysid}"/>');

function addSubSysMenus(subsysid){
	var reqparams = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID: 		'<sc:fmt type="crypto" value="sm_query"/>',
		actions:	'<sc:fmt type="crypto" value="getMenuList"/>',
		subsysid:	subsysid,
		recursive: '1'
		};
	var ajax = new Jraf.Ajax();
	ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
			try{
	   		var pkg = new Jraf.Pkg(xml);
				if(pkg.result() != '0'){
					alert('取菜单数据出错：\n'+pkg.allMsgs());
					return;
				}
				var rcds = pkg.rspDatas().Record;
				if(!rcds) rcds=[];
				if(!Object.isArray(rcds)) rcds = [rcds];
				var menus=buildtree(rcds);
				var jrafmenu = new Jraf.DropDownMenu({selector:'#tomenu',menuItems:menus});
				addShortCutMenus(jrafmenu, subsysid);
			}catch(e){alert('sendForXml,ERROR:'+e);}
				
		});
}

function viewItem(linkurl){
	if(!linkurl) return;
	if(linkurl.include('sysName')){
		var ajax = new Jraf.Ajax();
		ajax.request('/pcmc/pm/CryptoUrl.jsp',{linkurl:linkurl},function(x){
				workframe.location=x.responseText;
			});
	}else{
		workframe.location=linkurl;
	}
}
function buildtree(menulist){
	var ret = [],menus={};
	if(!menulist) return;
	if(!Object.isArray(menulist)) menulist=[menulist];
	menulist.each(function(menuitem){
			var key = menuitem.menuid;
			var pkey = menuitem.pmenuid;
			menus[key]= menuitem;
			pmenu=menus[pkey];
			if(!pmenu){
				ret.push(menus[key]);
				return;
			}
			pmenu.childs=pmenu.childs||[];
			pmenu.childs.push(menuitem);
		},this);
	return ret;
}
function addShortCutMenus(jrafmenu, subsysid){
	var reqparams = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID: 		'<sc:fmt type="crypto" value="sm_query"/>',
		actions:	'<sc:fmt type="crypto" value="getMenuShortCuts"/>',
		subsysid:	subsysid,
		recursive: '1'
		};
	var ajax = new Jraf.Ajax();
	ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
			try{
				var shortcutmenu = {menuname:'快捷菜单',childs:[{
					menuname:'快捷菜单维护',
					linkurl:'/pcmc/sm/shortCutList.jsp?subsysid='+subsysid}
					]};
	   		var pkg = new Jraf.Pkg(xml);
				if(pkg.result() != '0'){
					alert('取快捷菜单数据出错：\n'+pkg.allMsgs());
					return;
				}
				var rcds = pkg.rspDatas().Record;
				if(!rcds) rcds=[];
				if(!Object.isArray(rcds)) rcds = [rcds];
				var menus=buildtree(rcds);
				shortcutmenu.childs=shortcutmenu.childs.concat(menus);
				jrafmenu.addMenu(shortcutmenu);		
			}catch(e){alert('addShortCutMenus,ERROR:'+e);}
				
		});
}
</script>