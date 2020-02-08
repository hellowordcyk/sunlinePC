<%--[id1:name1];[id2:name2];[id3:name3]--%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<%@ include file="/common.jsp"%>
</head>
<body>

  <table id="tab" width="100%" height="100%" cellpadding="0" cellspacing="5" >
    <tr id="tr">
	  <td width="36%" valign="top">
	  	  <!-- 权限功能树显示部分 -->
	  	 <div class="page-title">
	  	 	<span class="title" style="position: relative;">功能树
	  	 		<span class="titlebar">
	  	        	<sc:button value="刷新"  _class="refresh"  
	  	        		attributesText="title='刷新功能配置信息' style='padding-top: 0px; margin: 0; *margin-top: -8px;'"  onclick="doRefreshAct();" />
	  	 		</span>
	  	 	</span>
	  	    <div id="prvtree" style="height:430px;overflow:auto;"></div>
	     </div>
      </td>
	  <td width="64%" valign="top">
		<div id="dataCellContainerChild" > 
			<sc:form name="act_form" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="functionActor" 
		               actions="saveToPcmcAct" forward="" attributesText="onSubmit='return checkForm(this);'">
		        <sc:hidden name="act_subsys" value=""/>
		        <sc:hidden name="act_actgroupname" value=""/>
		        <sc:hidden name="act_actgroupbean" value=""/>
		        <sc:hidden name="act_actgroupdesc" value=""/>
		        <sc:hidden name="act_acttype" value=""/>
		        <table align="center" class="form-table" border="0" width="100%"  cellspacing="0" cellpadding="0">
			          <tr>
			              <th colspan="4">功能子节点配置</th>
			          </tr>
			          <tr>
			           <sc:text dsp="td" name="actdesc" dspName="功能描述" req="0" index="1" attributesText="readonly='readonly'"/>
						
			              <sc:text dsp="td" name="actname" dspName="功能名称" req="0" index="1" attributesText="readonly='readonly'"/>
			          </tr>
			          <tr>
			              <sc:select name="acttype" dsp="td" dspName="功能类别"
							type="bdss" key="bdss,acttype"  includeTitle="false"
							index="1" req="0"  attributesText="disabled='true'" />
						<sc:select name="islog" dsp="td" dspName="日志记录"
							type="bdss" key="bdss,isnot" includeTitle="false"
							index="1"  req="0" /> 
			          </tr>
			          <tr>
			     		  <sc:text dsp="td" name="restim" dspName="功能正常响应时间(毫秒)" req="0" index="1" type="int" />
        				  <sc:select name="iswritexml" dsp="td" dspName="记录日志xml"type="bdss" key="bdss,isnot" index="1" includeTitle="false"  req="0" />
			          </tr>
			          <tr>
			              <td class="form-bottom" colspan="4">
			                  <sc:button value="保存功能配置信息"  onclick="doSubmitAct();" />
			              </td>
		             </tr>
		        </table>  
		     </sc:form>  
		   
	</div>
	<div id="dataCellContainerParent">
			<sc:form name="parentUpform" action="/xmlprocesserservlet" method="post" sysName="pcmc" oprID="functionActor" actions="saveToPcmcActgroup" >
		        <sc:hidden  name="ag_actgroupName" value=""/>
		        <sc:hidden  name="ag_subsysName" value=""/>
		        <table align="center" class="form-table" border="0" width="100%"  cellspacing="0" cellpadding="0">
			          <tr>
			              <th colspan="4">功能组配置</th>
			          </tr>
			          <tr>
				          <td colspan='2'>
				           <label id="cbislog"> 
								需要记录日志的类型:	
										<input type="checkbox"  name="ag_acttype" value="1" /> 查询类
										<input type="checkbox"  name="ag_acttype" value="2" /> 新增类
										<input type="checkbox"  name="ag_acttype" value="3" /> 修改类
										<input type="checkbox"  name="ag_acttype" value="4" /> 删除类
										<input type="checkbox"  name="ag_acttype" value="5" /> 处理类
						  </label>
						 </td>
			             
			         </tr>
			         <tr>
				         <td colspan='2'>
						       <span>业务bean: </span><input type="text" id="beanname" name="beanname" readonly="readonly">
						 </td>
			         </tr>
			         <tr>
			         	<td colspan='2'>
			         		   <span>业务描述: </span> <input type="text" id ="operdesc" name="operdesc"  readonly="readonly">
			         	</td>
			         </tr>
			         <tr>
			              <td class="form-bottom" colspan="4">
			                  <sc:button value="保存功能组配置信息" onclick="doSubmitActGroup();" />
			              </td>
		             </tr>
		        </table>
		        
		    </sc:form>
	</div>
</td>

</tr>
</table>
</body>
<script type="text/javascript" defer="defer">
var selTag;
var ajax = new Jraf.Ajax();		//Ajax 抽象类
var curActgroupid,curActid,curkey,curactkey;		//上次选择的结点值
var groupFlag,actFlag;
//setHeightAuto("log_config_frame");
/* function setHeightAuto(name) {
    parent.$(name).setStyle({height: (document.documentElement.clientHeight-2) + "px"});
} */
/** 树控件 */
var prvTree = new Jraf.Tree({
	selector:  '#prvtree',
	onexpand:  function(srcNode){expandNode(prvTree, srcNode);}
});
init();
/* 初始化界面 */
function init() {
	
		loadPrvTree(prvTree);		//加载树结点
	//style="visibility:hidden;display:none"
	
        document.getElementById("dataCellContainerParent").style.display="none";//
	
};

/* 树相关方法 */
/** 展开树结点的加载 */
function expandNode(prvTree, srcNode){
	srcNode.icon.src = srcNode.treeContext.imageList.item["hfold_open"].src;
	
	if (srcNode.first && srcNode.first.tag == 'asyncloading') {
		var srcTag = srcNode.tag;
		
		loadPrvTree(prvTree,srcTag.subsys,srcTag.operall,srcTag.actionall);
	}
}
/** 加载树结点 */
function loadPrvTree (prvTree,subsys,operall,actionall) {
	/* 初始化参数变量 */
	var params = {
		sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
		oprID:		'<sc:fmt type="crypto" value="functionActor"/>',
		actions:	'<sc:fmt type="crypto" value="getTreeDataFromMap"/>',
		subsys:     '',
		operall:    '',
		actionall:  ''
	};
	
	if(subsys) {Object.extend(params, {subsys:subsys});}
	if(operall) {Object.extend(params, {operall:operall});}
	if(actionall) {Object.extend(params, {actionall:actionall});
	
	}
	
	/* 查询初始化树结点 */
	ajax.sendForXml('/xmlprocesserservlet', params, function(xml){initPrvTree(xml, prvTree,subsys,operall,actionall);});
}
/** 树结点赋值 */
function initPrvTree (xml, prvTree,subsys,operall,actionall) {
	try{
		var pkg = new Jraf.Pkg(xml);
		if (pkg.result() != '0') {
			alert('获取权限功能树异常！\n' + pkg.allMsgs());		//查询失败处理
		}
		var rcds = pkg.rspDatas().Record;
		
		if(!rcds) {rcds = [];}
		if(!Object.isArray(rcds)) {rcds = [rcds];}
		rcds.each( function(rcd){addPrvNode(prvTree, rcd);}, this);		//循环添加结点
		
	} catch(ex) {
		alert('initPrvTree ERROR:' + ex);
	}
}

/** 树结点添加结点 */
function addPrvNode(prvTree, rcd){
var item = {
		name:		rcd.nodename,
		key:		rcd.key,
		pkey:	    rcd.pkey,
		onClick:	viewPrvType,	//点击结点响 应事件//
		tag:		rcd
	};
	
	var prvNode = prvTree.addNode(item);
	
	if(rcd.childnum != '0'){
		prvTree.addNode({
			name:	'Loading...',
			key:	'load',
			pkey:	item.key, 
			tag:	'asyncloading'
		});
		prvNode.expand(false, true);
	}
	/** 消除父结点 Loading 结点 */
	 var pNode = prvTree.treeContext.nodes[rcd.pkey];
	
	if (pNode && pNode.first && pNode.first.tag == 'asyncloading') {
		pNode.first.remove();//消除是否含子结点的标志行
		if(!pNode.first) { 
			pNode.icon.src = pNode.treeContext.imageList.item["default"].src; 
			}
	}
	return prvNode;
	
}

function viewPrvType(){
  var selTag = prvTree.treeContext.getSelectedNode().tag;
  var parentselTag = prvTree.treeContext.getSelectedNode().parent.tag;
  var selType = selTag.nodetype;
    if(selType == 'nochild'){
      actFlag = true;
   	  document.all.dataCellContainerParent.style.display="none";
      document.all.dataCellContainerChild.style.display="";
      document.getElementsByName("act_subsys")[0].value = selTag.subsys;
      document.getElementsByName("act_actgroupname")[0].value = parentselTag.operid;
      document.getElementsByName("act_actgroupbean")[0].value = parentselTag.operbean;
      document.getElementsByName("act_actgroupdesc")[0].value = parentselTag.operdesc;
      if(selTag.acttype==null || selTag.acttype=="")
    	  document.getElementsByName("act_acttype")[0].value = "1";
      document.getElementsByName("act_acttype")[0].value = selTag.acttype;
      
      initChildNode(selTag);
  
    }else if(selType=='func'){
   		groupFlag = true;
        document.all.dataCellContainerChild.style.display="none";
        document.all.dataCellContainerParent.style.display="";
		document.getElementsByName("ag_actgroupName")[0].value = selTag.operid;
		document.getElementsByName("ag_subsysName")[0].value = selTag.subsys;	
        curActgroupid=selTag.actgroupid;//组id设置为全局变量
        curkey=selTag.key; //当前的key
        initFuncNode(selTag);
      
    }
}
/*初始化功能组节点*/
function initFuncNode(selTag){

		var cbplog = document.getElementById("cbislog").getElementsByTagName("input"); 
		for(var k = 0; k < cbplog.length; k++)    {        
				cbplog[k].checked=false;
		}
		var reqparams = {
				sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
				oprID: 		'<sc:fmt type="crypto" value="functionActor"/>',
				actions:	'<sc:fmt type="crypto" value="queryActGroupByName"/>', 
				actGroupName:  selTag.operall,
				subsysName:  selTag.subsys
				};
			var ajax = new Jraf.Ajax();
			ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
					try{
			   		    var pkg = new Jraf.Pkg(xml);
						if(pkg.result() != '0'){
							alert('查询功能详细信息出错：\n'+pkg.allMsgs());
							return;
						}
						var rcds = pkg.rspDatas().Record;
						if(!rcds) rcds=[];
						if(!Object.isArray(rcds)) rcds = [rcds];
						if(rcds.length == 1){
							var rcd = rcds[0];
							showActGroupMessage(rcd.operid,rcd.subsys,rcd.acttypeList,rcd.operbean,rcd.operdesc);
						}
						else{
							
							showActGroupMessage(selTag.operid,selTag.subsys,"",selTag.operbean,selTag.operdesc);
						}
						
					}catch(e){alert('sendForXml,ERROR:'+e);}
						
		});
		
		
		
}
function showActGroupMessage(actgroupName,subsysName,acttype,operbean,operdesc){	
		var cbplog = document.getElementById("cbislog").getElementsByTagName("input"); 
		var typeAry = new Array();
		typeAry =  acttype.split(",");
		for(var i=0;i<typeAry.length;i++){
			var index = typeAry[i];
			if( index != null && index.trim().length>0){
				cbplog[index-1].checked=true;
			}
		}
		document.getElementById("beanname").value= operbean;
		document.getElementById("operdesc").value = operdesc;
}
/*初始化功能组子节点*/
function initChildNode(selTag){
	
	var reqparams = {
			sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
			oprID: 		'<sc:fmt type="crypto" value="functionActor"/>',
			actions:	'<sc:fmt type="crypto" value="getActData"/>',
			actName:  selTag.actionall,
			actGroupName:  selTag.operall,
			subsysName:  selTag.subsys	
			};
		var ajax = new Jraf.Ajax();
		ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
				try{
		   		    var pkg = new Jraf.Pkg(xml);
					if(pkg.result() != '0'){
						 Jraf.showMessageBox({
			                  text: '<span class="error">查询功能信息出错！\n'+pkg.allMsgs() + '</span>'
			           		});
			           	return;
					}
					var rcds = pkg.rspDatas().Record;
					if(!rcds) rcds=[];
					if(!Object.isArray(rcds)) rcds = [rcds];
					if(rcds.length == 1){
						var act = rcds[0];
						shwoActData(act.isLog,act.acttype,act.iswriteXml,act.actdesc,act.restim,act.actname);
					}else{
					
						shwoActData(selTag.isLog,selTag.acttype,selTag.iswriteXml,selTag.actdesc,selTag.restim,selTag.actname);
					}
					
				}catch(e){alert('sendForXml,ERROR:'+e);}
					
	});		
}

//显示act详细信息
function shwoActData(isLog,acttype,iswritexml,actdesc,restim,actname){
	var logEle = document.getElementsByName("islog")[0];
	setIsNotSelect(isLog,logEle);		
	var typeEle = document.getElementsByName("acttype")[0];
	setIsNotSelect(acttype,typeEle);
	var writexmlEle = document.getElementsByName("iswritexml")[0];
	setIsNotSelect(iswritexml,writexmlEle);
	var act_desc = document.getElementsByName("actdesc")[0];
	act_desc.value = actdesc;
	var act_restim = document.getElementsByName("restim")[0];
	act_restim.value = restim;
	var act_name = document.getElementsByName("actname")[0];
	act_name.value = actname;
	var act_acttype = document.getElementsByName("act_acttype")[0];
	act_acttype.value = acttype;
}
function setIsNotSelect(flag,sel){
	if(flag==null || flag == "")
		flag ="1";
	for(var i=0;i <sel.options.length;i++)   { 
		if(sel.options[i].value == flag){
			sel.options[i].selected= true; 
		}
	} 	
}



/*保存功能修改信息*/
function doSubmitAct(){
   var query_form = document.forms['act_form'];
   if(!checkForm(query_form, event)){//form表单校验
        return;
    }
   if(actFlag==true){ 
    ajax.submitFormXml(query_form, function (xml) {
        try{
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                Jraf.showMessageBox({
                    text: '<span class="error">保存功能子节点信息出错！\n'+pkg.allMsgs() + '</span>'
                });
                return;
            }
            var selTag = prvTree.treeContext.getSelectedNode().tag; 
            var selType = selTag.nodetype;
             if(selType == 'nochild'){
             	selTag.actname = document.getElementsByName("actname")[0].value;
             	selTag.restim = document.getElementsByName("restim")[0].value;
             	selTag.actdesc = document.getElementsByName("actdesc")[0].value;
             	selTag.isLog = document.getElementsByName("islog")[0].value;
             	selTag.acttype = document.getElementsByName("acttype")[0].value;
             	selTag.iswriteXml = document.getElementsByName("iswritexml")[0].value;
            }
            Jraf.showMessageBox({
                text: '<span class="success">保存功能子节点信息成功！</span>' 
            });
        }catch(e){alert('doSubmitAct ERROR:'+e.message);}
    });
    }else{
    	Jraf.showMessageBox({
            text: '<span class="info">请选择自功能节点！\n </span>'
        });
    }
   
}


/*保存功能模块修改信息*/
function doSubmitActGroup(){
   var query_form = document.forms['parentUpform'];
   if(!checkForm(query_form, event)){//form表单校验
        return;
    }
   if(groupFlag==true){ 
    ajax.submitFormXml(query_form, function (xml) {
        try{
            var pkg = new Jraf.Pkg(xml);
            if(pkg.result() != '0'){
                Jraf.showMessageBox({
                    text: '<span class="error">保存功能子节点信息出错！\n'+pkg.allMsgs() + '</span>'
                });
                return;
            }
            Jraf.showMessageBox({
                text: '<span class="success">保存功能子节点信息成功！</span>' 
            });
        }catch(e){alert('doSubmitActGroup ERROR:'+e.message);}
    });
    }else{
    alert("请选择功能 组节点");
    }
   
}
function doRefreshAct(){
	var reqparams = {
			sysName:	'<sc:fmt type="crypto" value="pcmc"/>',
			oprID: 		'<sc:fmt type="crypto" value="functionActor"/>',
			actions:	'<sc:fmt type="crypto" value="doRefreshAct"/>'
			};
		var ajax = new Jraf.Ajax();
		ajax.sendForXml('/xmlprocesserservlet',reqparams,function(xml){
				try{
		   		var pkg = new Jraf.Pkg(xml);
					if(pkg.result() != '0'){
						Jraf.showMessageBox({
			                  text: '<span class="error">刷新配置信息出错！\n'+pkg.allMsgs() + '</span>'
			           		});
						return;
					}
					Jraf.showMessageBox({
		                text: '<span class="success">刷新信息成功！</span>' 
		            });
				}catch(e){alert('sendForXml,ERROR:'+e);}
					
	});
   
}
</script>
</html>