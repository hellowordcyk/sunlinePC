var MAX_Z_INDEX=30;
var col_menu=[]; //menu collection
var bkcolor = new Array();
bkcolor[0] = "";//"#4A7DA4";//mouse out
bkcolor[1] = "";//"#568CB4";//mouse over
var bkimage = "/common/skins/default/images/nav-bg.gif";
var ftcolor = "#FFFFFF";//"#ffffff";//font color
var ftsize = "9pt";//font-size;
var fwight = "bold";
var boutimg = "/common/skins/default/images/navbg_li.gif";
function alai_menu(width)
{
	var menu=this
	this.item=[]
	this.isShow=false
	this.bar=null
	this.body=document.createElement("div")	
	document.body.insertAdjacentElement("beforeEnd",this.body)
	this.body.style.cssText="position:absolute;background-image:url("+bkimage+");display:none;font-weight:bold;font-size:"+ftsize+";color:"+ftcolor+";border:0;height:28;"
	this.body.style.pixelWidth=width==null?120:width
	var run=function(cmd,a0,a1,a2)
	{
		if(typeof(cmd)=="string")
		{	try{return eval(cmd);}
			catch(E){alert("run script string error:\n"+cmd);}
		}
		else if(typeof(cmd)=="function"){return cmd(a0,a1,a2);}
	}
	this.add=function(Text,exeType,exeArg,target)
	{
		var item_table=document.createElement("table");
		//item_table.border=0;
		item_table.style.cssText="border-collapse:collapse;height:28;cursor:hand;background-color:"+bkcolor[0]+";background-image:url("+boutimg+");width:100%;"
		var item=item_table.insertRow();
		menu.body.insertAdjacentElement("beforeEnd",item_table)
		item.style.cssText="padding-left:8;font-size:"+ftsize+";height:28;cursor:hand;background-color:"+bkcolor[0]+";background-image:url("+boutimg+");width:100%;"
		var col1=item.insertCell()
		col1.style.cssText="width:96%;font-weight:normal;";
		col1.innerHTML='&nbsp;'+Text;
		var col2=item.insertCell()
		col2.style.cssText="width:9;";				
		menu.item[menu.item.length]=item
		item.enable=true
		item.execute=new Function()
		item.remove=function(){item.removeNode(true);}
		exeType=exeType==null?"":exeType
		item.style.color=ftcolor;
		switch(exeType.toLowerCase())
		{
			case "hide":
				item.execute=function(){menu.hide();}
				break;
			case "url":
				if(typeof(exeArg)!="string")break;
				if(target==null||target=="")target="_blank";
				item.execute=function(){menu.hideAll();open(exeArg,target);}
				break;
			case "js":
				if(typeof(exeArg)!="string")break;
				item.execute=function(){menu.hideAll();eval(exeArg)}
				break;
			case "sub":
				if(typeof(exeArg.body)=="undefined")break;
				item.execute=function(){menu.show(exeArg);}
				col2.innerHTML="<span style='font-family:Webdings;'>4</span>";
				item.subMenu=exeArg;
				exeArg.upmenu=menu;
				break;
		}
		item.onmousemove=function(){
			//item.style.backgroundColor=bkcolor[1];
			item.style.backgroundImage="url(/common/skins/default/images/navbg_hover.gif)";
			for(var i=0;i<menu.item.length;i++){if(menu.item[i].subMenu!=null)menu.item[i].subMenu.hide();}
			if(item.subMenu!=null)menu.show(item.subMenu)
			clearhide(menu);
		}
		item.onmouseout=function(){item.style.backgroundImage="url(/common/skins/default/images/navbg_li.gif)";hidemenu(menu);}
		item.onmousedown=item.onmouseup=function(){event.cancelBubble=true;}
		item.onclick=function(){event.cancelBubble=true;if(this.enable)run(item.execute);}
		return item
	}
	this.addLink=function(url_,text,target)
	{
		if(text==null || text=="")text=url_
		if(target==null || target=="")target="_blank"
		return menu.add(text,"url",url_,target)
	}
	this.seperate=function(){menu.body.insertAdjacentHTML("beforeEnd","<hr style='width:96%;'>");}
	this.show=function()
	{
		var a=arguments;
		var x,y,m=menu.body
		if(a.length==0)
		{
			x=event.clientX+document.body.scrollLeft+document.body.scrollLeft
			y=event.clientY+document.body.scrollTop
		}
		else if(a.length==1 && typeof(a[0])=="object")
		{
			if(typeof(a[0].body)!="undefined")
			{
				m=a[0].body
				m.style.display="block"
				if(m.style.pixelWidth<document.body.offsetWidth-event.x 
				  && menu.body.style.pixelLeft+menu.body.offsetWidth+m.style.pixelWidth<=document.body.offsetWidth
				  )
				{	x=menu.body.style.pixelLeft+menu.body.offsetWidth}
				else
				{	x=menu.body.style.pixelLeft-m.style.pixelWidth}
				if(m.offsetHeight<document.body.offsetHeight-event.y)
				{	
					y=event.y+document.body.scrollTop-event.offsetY
				}
				else
				{	y=event.y-m.offsetHeight+document.body.scrollTop}
			}
			else
			{
				x=event.x+document.body.scrollLeft-event.offsetX-2
				y=event.y+document.body.scrollTop+a[0].offsetHeight-event.offsetY-4
			}
		}
		else if(a.length==2 && typeof(a[0])=="number" && typeof(a[1])=="number")
		{
			x=a[0];y=a[1];
		}
		else{alert("arguments type or number not match!");return;}
		for(var i=0;i<menu.item.length;i++)
		m.style.pixelLeft=x;
		m.style.pixelTop=y;
		m.style.display="block";
		m.style.zIndex=++MAX_Z_INDEX
		event.cancelBubble=true;
		menu.isShow=true
		if(menu.bar!=null)menu.bar.style.backgroundColor=bkcolor[1];
	}
	this.hide=function(){menu.body.style.display="none";menu.isShow=false;
		if(menu.bar!=null)menu.bar.style.backgroundColor=bkcolor[0];
		for(var i=0;i<menu.item.length;i++){if(menu.item[i].subMenu!=null)menu.item[i].subMenu.hide();}
		}
	this.hideAll=function(){for(var i=0;i<col_menu.length;i++)col_menu[i].hide();}
	col_menu[col_menu.length]=this
	document.body.onclick=this.hideAll
	this.body.insertAdjacentHTML("beforeEnd",'<iframe src="javascript:false" style="position:absolute; visibility:inherit; top:0px; left:0px; width:100%; height:100%; z-index:-1; filter=\'progid:DXImageTransform.Microsoft.Alpha(style=0,opacity=0)\';"></iframe>');
}
function menu_bar(top,left,toObject)
{
	var mb=this
	this.item=[]
	this.menu=[]
	this.body=document.createElement("div")
	document.body.insertAdjacentElement("beforeEnd",this.body)
	if(null == toObject)
		this.body.style.cssText="position:absolute;cursor:default;background-color:"+bkcolor[0]+";height:28;z-index:5;font-size:"+ftsize+";color:"+ftcolor+";top:"+top+";left:"+left
	else
		this.body.style.cssText="cursor:default;background-color:"+bkcolor[0]+";height:28;z-index:5;font-size:"+ftsize+";color:"+ftcolor
	var chkShow=function(){for(var i=0;i<mb.menu.length;i++)if(mb.menu[i].isShow)return true;return false;}
	this.add=function(Text,menu)
	{
		var item=document.createElement("span")
		mb.body.insertAdjacentElement("beforeEnd",item)
		item.style.cssText="margin:0 2 0 2;padding:2 2 2 2;text-align:center;height:28;font-weight:bold;background-color:"+bkcolor[0]+";"
		item.innerHTML="<span>"+Text+"</span><span style='font-family:Webdings;'>6</span>";
		item.onmouseover=function()
		{
			this.style.backgroundColor=bkcolor[1];
			for(var i=0;i<col_menu.length;i++)col_menu[i].hide();
			menu.show(item);
			clearhide(menu);
		}
		item.onmouseout=function()
		{
			if(!menu.isShow)this.style.backgroundColor=bkcolor[0];
			hidemenu(menu);
		}
		item.onmousedown=item.onmouseup=function(){event.cancelBubble=true;menu.show(item);}
		item.onclick=function(){event.cancelBubble=true;menu.show(this)}
		mb.item[mb.item.length]=item
		mb.menu[mb.menu.length]=menu
		menu.bar=item
		return item
	}
	this.embed=function(obj,where){if(obj==null)obj=document.body;if(!obj.insertAdjacentElement)obj=document.body;if(where==null)where="afterBegin";var s=where.toLowerCase();if(s!="beforebegin" || s!="afterbegin" || s!="beforeend" || s!="afterend")where="afterBegin";obj.insertAdjacentElement(where,this.body);}
	this.embed(toObject)
}
var hidemenuitem;
function hidemenuit()
{
	try
	{
		hidemenuitem.hide();
	}catch(e){}
}
function hidemenu(menu)
{
	if(null == menu)return;
	if(null != menu.upmenu)
		hidemenu(menu.upmenu);
	else
	{
		hidemenuitem=menu;
		menu.hide_timer=setTimeout('hidemenuit();',1000);
	}
}
function clearhide(menu)
{
	try
	{
		if(null != hidemenuitem)
		{
			clearTimeout(hidemenuitem.hide_timer);
			hidemenuitem=null;
		}
	}catch(e){}
}