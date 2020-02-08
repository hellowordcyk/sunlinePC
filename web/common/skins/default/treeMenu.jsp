<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/common.jsp"%>
<script language="JavaScript">
var jraftreemenu = new Jraf.Tree({
	selector:'#tomenu',
	afteradd: function(srcNode){
		if(srcNode.parent.icon){
			srcNode.parent.icon.src=jraftreemenu.options.imagelist.item["hfold_open"].src;
			if(srcNode.label.innerHTML != 'loading...')
				srcNode.parent.execute=srcNode.parent.expand;
		}
	}
});
addSubSysMenus(jraftreemenu,'<c:out value="${param.subsysid}"/>');
function addSubSysMenus(jraftree,subsysid){
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
				rcds.each(function(rcd){
					var item={
						name:rcd.menuname,
						key:'n'+rcd.menuid,
						pkey:'n'+rcd.pmenuid,
						onClick: viewItem,
						tag: rcd
						};
					jraftree.addNode(item);
				},this);
				addShortCutMenus(jraftree, subsysid);
			}catch(e){alert('ERROR:'+e);}
				
		});
}
function addShortCutMenus(jraftree, subsysid){
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
				var shortcutmenu = [
					{menuname:'快捷菜单',pmenuid:'s',menuid:'shortcut'},
					{menuname:'快捷菜单维护',pmenuid:'shortcut',menuid:'sm',linkurl:'/pcmc/sm/shortCutList.jsp?subsysid='+subsysid}];
	   		var pkg = new Jraf.Pkg(xml);
				if(pkg.result() != '0'){
					alert('取快捷菜单数据出错：\n'+pkg.allMsgs());
					return;
				}
				var rcds = pkg.rspDatas().Record;
				if(!rcds) rcds=[];
				if(!Object.isArray(rcds)) rcds = [rcds];
				shortcutmenu.concat(rcds).each(function(rcd){
					var item={
						name:rcd.menuname,
						key:'sc'+rcd.menuid,
						pkey:'scshortcut',
						onClick: viewItem,
						tag: rcd
						};
					jraftree.addNode(item);
				},this);
				jraftree.collapseAll();
			}catch(e){alert('addShortCutMenus,ERROR:'+e);}	
		});
}
function viewItem(nNode){
	if(!nNode || !nNode.tag || !nNode.tag.linkurl) return;
	var linkurl = nNode.tag.linkurl;
	if(linkurl.include('sysName')){
		var ajax = new Jraf.Ajax();
		ajax.request('/pcmc/pm/CryptoUrl.jsp',{linkurl:linkurl},function(x){
				workframe.location=x.responseText;
			});
	}else{
		workframe.location=linkurl;
	}
}
$('switchPoint').observe('click',function(e){
		var el = e.element();
		var elmenu = $('tomenu').up('TD');
		elmenu.toggle();
		el.update(elmenu.visible()?'7':'8');
	});
</script>