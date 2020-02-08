<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
<head>
<%@include file="/common.jsp"%>
<%--
    String xmltree = skinPath + "/scripts/xmltree.js";
--%>
<%-- <script type="text/javascript" src="<%=skinPath %>/scripts/xmltree.js"></script> --%>
<link rel="stylesheet" type="text/css" href="<%=skinPath %>/css/main.css">
<link rel="stylesheet" type="text/css" href="<%=skinPath %>/css/ListView.css">
</head>
<body oncontextmenu="return false;">
    <!-- <xml id="menuXML">
    </xml> -->
    <div id="treeBox"></div>
    <!-- <a href="" id="initmenu11"></a> -->
</body>
<script type="text/javascript">
document.observe("dom:loaded", function () {
	//页面加载后，初始化二级菜单输出位置
	top.frames("topFrame").window.g_JrafMenu.options.subMenuObj = $("treeBox");
	
	<%-- 跨域（frame）ie6下不能添加创建的节点（document.createElement），现将方法outlookMenu里创建的对象方法移到此页面 --%>
	top.frames("topFrame").window.g_JrafMenu.__creatSubMenu= function (menuid) {
		Element.hide(this.options.subMenuObj);
		
		var oSpan = document.createElement("span");//new Element("span");
		Element.update(this.options.subMenuObj, oSpan);
		
		var oMenuTemp = null;
		var oMenu = this.gMenuDatas.get(this.__getKey(menuid));
		for (var i = 0, len=oMenu.datas.length; i < len; i ++) {
			oMenuTemp = oMenu.datas[i];
			this.__creatSubMenuTemp(oSpan, oMenuTemp.menuid);
		}
		
		Element.show(this.options.subMenuObj);
	};
	
	top.frames("topFrame").window.g_JrafMenu.__creatSubMenuTemp = function (oSpan, menuid) {
		var oMenu = this.gMenuDatas.get(this.__getKey(menuid));
		if (oMenu == null) 
			return;
		//循环创建菜单
		var oMenuTemp = null;
		var len = oMenu.datas.length;
		var oPrtSpan = null;//父
		var oSubSpan = null;//叶子节点
		if (len > 0) {
			oPrtSpan = new Element("span", {"isleaf": "false", "childnum": oMenu.datas.length, "menuid": oMenu.self.menuid});
			Element.addClassName(oPrtSpan, "hasItems");
			Element.observe(oPrtSpan, "click", this.__clickNode.bind(this));
			
			var oImg = new Element("img", {"align": "middle"});
			Element.addClassName(oImg, "ec");
			oImg.src=this.options.expandImgSrc;//"./img/expand.gif";
			
			Element.insert(oPrtSpan, oImg);
			Element.insert(oPrtSpan, oMenu.self.menuname);
			
			Element.insert(oSpan, oPrtSpan);
			var oSpanTmp = new Element("span", {name: "cn"});
			Element.setStyle(oSpanTmp, {"display": "none"});
			Element.insert(oSpan, oSpanTmp);
			
			//TODO: 菜单按照sortno排序，现在按照查询顺序创建
			for (var i = 0; i < len; i ++) {
				oMenuTemp = oMenu.datas[i];
				this.__creatSubMenuTemp(oSpanTmp, oMenuTemp.menuid);
			}
		} else {
			oSubSpan = new Element("span", {"isleaf": "true", "childnum": 0, "menuid": oMenu.self.menuid});
			Element.addClassName(oSubSpan, "Items");
			Element.setStyle(oSubSpan, {"padding-left": "10px"});
			Element.observe(oSubSpan, "click", this.__clickNode.bind(this));
			
			var oImg = new Element("img", {"align": "middle"});
			Element.addClassName(oImg, "ec");
			oImg.src=this.options.endNodeImgSrc;//"./img/endnode.gif";
			
			Element.insert(oSubSpan, oImg);
			Element.insert(oSubSpan, oMenu.self.menuname);
			
			Element.insert(oSpan, oSubSpan);
		}
		
	}
});
</script>
<%-- 
<script language="javascript">
function creatTree(){
    //取得生成树的数据
    var leftMenuStr = top.frames("topFrame").leftMenuHtml;
    //alert(leftMenuStr);
    //将取得的数据转化成 DOM
    var xmlDoc = document.getElementById('menuXML').XMLDocument; 
    document.getElementById('treeBox').innerHTML = "";
    xmlDoc.async="false";
    xmlDoc.loadXML(leftMenuStr);
    //根据DOM生成可见的菜单树
    initTree1();
   //var trb=document.getElementById('treeBox');
    //trb.appendChild("<img src="+"/common/skins/outlook/img/expand.gif class=ec>kjkljk");
    
}
/* window.onload = creatTree; */

var HC = "color:#990000";
var SC = "background-color:#ffffff;color:#000000;";
var IO = null;

var firstDefaultNode = "";

function initTree1(){
    var rootn = document.getElementById("menuXML").documentElement;
    var sd = 1;
    document.onselectstart = function(){return false;}
    document.getElementById('treeBox').appendChild(createTree1(rootn,sd));
    //createTree1(rootn,sd);
    
}
        
function createTree1(thisn,sd){
    var nodeObj = document.createElement("span");
    var upobj = document.createElement("span");
    
    with(upobj){
        //style.marginLeft = sd*10;
        //className = thisn.hasChildNodes()?"hasItems":"Items";
        if(sd==1){
            className = thisn.hasChildNodes()?"hasItems":"Items";
        }else if(sd==2){
            style.marginLeft = thisn.hasChildNodes()? 0 : 10;
            className = thisn.hasChildNodes()?"hasItems":"Items";
        }else{
            style.marginLeft = (sd-2)*10;
            className = thisn.hasChildNodes()?"hasItemsNoBackground":"Items";
        }
        
        innerHTML = "<img src="+"<%=skinPath %>/img/expand.gif class=ec>" + thisn.getAttribute("text") +"";
        onmousedown = function(){
            if(event.button != 1) return;
            if(sd==1) return; //------------->>根节点不允许收缩
            if(this.getAttribute("cn")){
                this.setAttribute("open",!this.getAttribute("open"));
                //this.cn.style.display = this.getAttribute("open")?"inline":"none";  //------------->>本一级节点展开后，其他一级节点全部收缩                    
                //this.all.tags("img")[0].src = this.getAttribute("open")?(contextPath+"/common/skins/outlook/img/expand.gif"):(contextPath+"/common/skins/outlook/img/contract.gif");
                var spans = this.parentElement.parentElement.getElementsByTagName("span");//获取同级节点
                for(var i=0;i<spans.length;i++){
                    if(spans[i].getAttribute("cn")){
                        spans[i].getAttribute("cn").style.display = "none";
                        this.all.tags("img")[0].src = ("<%=skinPath %>"+"/img/contract.gif");
                    }
                }
                this.cn.style.display = "inline";                     
                this.all.tags("img")[0].src = ("<%=skinPath %>"+"/img/expand.gif");
            }
            if(IO){
                IO.runtimeStyle.cssText = "";
                IO.setAttribute("selected",false);
            }
            IO = this;
            this.setAttribute("selected",true);
            //this.runtimeStyle.cssText = SC;
        }
        onmouseover = function(){
            if(this.getAttribute("selected"))return;
            this.runtimeStyle.cssText = HC;
        }
        onmouseout = function(){
            if(this.getAttribute("selected"))return;
            this.runtimeStyle.cssText = "";
        }
        oncontextmenu = contextMenuHandle1;
        onclick = clickHandle1;
    }

    if(thisn.getAttribute("treeId") != null){
        upobj.setAttribute("treeId",thisn.getAttribute("treeId"));
    }
    if(thisn.getAttribute("href") != null){
        upobj.setAttribute("href",thisn.getAttribute("href").replace('^','&'));
    }
    if(thisn.getAttribute("target") != null){
        upobj.setAttribute("target",thisn.getAttribute("target"));
    }
    if(thisn.getAttribute("menuPath") != null){
        upobj.setAttribute("menuPath",thisn.getAttribute("menuPath"));
    }

    nodeObj.appendChild(upobj);
    nodeObj.insertAdjacentHTML("beforeEnd","<br>")
    
    var isworkflow = 0;
    if(thisn.hasChildNodes()){
        var i;
        var nodes = thisn.childNodes;
        var cn = document.createElement("span");
        cn.setAttribute("name", "cn");
        upobj.setAttribute("cn",cn);
        upobj.setAttribute("haschild","yes");
        if(thisn.getAttribute("open") != null){
            upobj.setAttribute("open",(thisn.getAttribute("open")=="true"));
            //upobj.getAttribute("cn").style.display = upobj.getAttribute("open")?"inline":"none";
            //if( !upobj.getAttribute("open"))upobj.all.tags("img")[0].src =contextPath+"/common/skins/outlook/img/contract.gif";
            if(sd ==1 || firstDefaultNode == ""){ //
                upobj.getAttribute("cn").style.display = "inline";
            }else{
                upobj.getAttribute("cn").style.display = "none";
                upobj.all.tags("img")[0].src ="<%=skinPath %>/img/contract.gif";
            }
        }
        
        for(i=0; i < nodes.length; cn.appendChild(createTree1(nodes[i++],sd+1)) );
        nodeObj.appendChild(cn);
    } else {
       
        //------------->>
        if( firstDefaultNode == "" ){
            firstDefaultNode = "yes";
            
            if(upobj.getAttribute("cn")){
                upobj.setAttribute("open",!upobj.getAttribute("open"));
                upobj.cn.style.display = upobj.getAttribute("open")?"inline":"none";
                upobj.all.tags("img")[0].src = upobj.getAttribute("open")?("<%=skinPath %>/img/expand.gif"):("<%=skinPath %>/img/contract.gif");
            }
            
            if(IO){
                IO.runtimeStyle.cssText = "";
                IO.setAttribute("selected",false);
            }
            IO = upobj;
            //upobj.setAttribute("selected",true);
            //upobj.runtimeStyle.cssText = SC;
            
            //
            //document.getElementById('initmenu11').target = "bodyFrame";
            document.getElementById('initmenu11').href = upobj.getAttribute("href");
             //document.getElementById('initmenu11').href = padContextpath("/common/skins/outlook/initPanel.jsp");
            //document.getElementById('initmenu11').click();

        }
        if(thisn.getAttribute("treeId")=="wfclient"){
            isworkflow = 1;
        }
        //<<--------------------------------
        upobj.all.tags("img")[0].src ="<%=skinPath %>/img/endnode.gif";

    }

    //
    if(isworkflow==1){
        top.frames("bodyFrame_all").frames("orightFrame").frames("bodyFrame").window.location.href = "initPanel.jsp";
    }
    return nodeObj;
}

function clickHandle1(){
    var rightTopHtml="";
    var curpos = top.frames("bodyFrame_all").frames("rightFrame").frames("topFrame").window.document.getElementById('curpos').value;

    rightTopHtml += "<li><a>"+curpos + "</a></li>";        
    rightTopHtml += replaceLast1(this.getAttribute("menuPath"),'[',' <li><a><span class="current">', ']', "</span></a></li>");//
    rightTopHtml = rightTopHtml.replace(/\]\[/g,' > ').replace(/\[/g,'<li><a>').replace(/\]/g,'</a></li>');
    //rightTopHtml += "</span></a></li>";
    
    if( this.getAttribute("href") != "null" && this.getAttribute("href") != "" && this.getAttribute("haschild") !="yes"){
        viewItem(padContextpath1(this.getAttribute("href")));
    }else{
        top.frames("bodyFrame_all").frames("rightFrame").frames("bodyFrame").window.location.href = "initPanel.jsp";
    }

    top.frames("bodyFrame_all").frames("rightFrame").frames("topFrame").window.document.getElementById("pagetip").innerHTML = "<ul>"+rightTopHtml+"</ul>";
    //"<ul><li><a><span class='current'>测试一下</span></a></li></a></li><li><a><span class='current'>测试一下122</span></a></li></ul>"; //rightTopHtml;
    
}

 //加密URL
function viewItem(linkurl){
    if (!linkurl) return;
    if (linkurl.indexOf("?") != -1) {
        linkurl += '&s_time='+(new Date().getTime());
    } else {
        linkurl += '?s_time='+(new Date().getTime());
    }
    
    if (linkurl.include('sysName')) {
        var ajax = new Jraf.Ajax();
        ajax.request('/pcmc/pm/CryptoUrl.jsp',{linkurl:linkurl},function(x){
            top.frames("bodyFrame_all").frames("rightFrame").frames("bodyFrame").window.location.href = x.responseText;
        });
    } else {
        top.frames("bodyFrame_all").frames("rightFrame").frames("bodyFrame").window.location.href = linkurl; 
    }
}
 
function replaceLast1(contain, str1, str2, str3, str4){
    var index = contain.lastIndexOf(str1);
    var subStr1=contain.substring(0, index);
    var subStr2=contain.substring(index, contain.length);
    subStr2 = subStr2.replace(new RegExp('\\'+str1, "g"), str2);
    subStr2 = subStr2.replace(new RegExp('\\'+str3, "g"), str4);
    contain=subStr1 + subStr2;
    return contain;

}
function padContextpath1(url){
  
  url=url.replace(/\^/g,'&');
  //alert(url);
  return url
}
function contextMenuHandle1(){
    event.returnValue = false;
    var treeId = this.getAttribute("treeId");
    // your code here
}
</script> --%>
</html>
