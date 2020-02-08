/*******************************************************************************
	阿赖目录树控件COOL模板程序 由赖国欣设计于2003年7月17日，保留所有权利！
*********************************************************************************/
function getScriptPath(js)
{
	js=js.toLowerCase()
	var script=document.getElementsByTagName("SCRIPT");
	for(var i=0;i<script.length;i++)
	{
		var s=script[i].src.toLowerCase()
		if(s.indexOf(js)!=-1)return s.replace(js,"")
	}
	return null
}

function alai_tree_cool(toObject)
{
	var path=getScriptPath("alai_tree.js")
	if(path==null){alert("run alai_tree_cool() fail, please load alai_tree.js first!");return;}
	var icons=new alai_imagelist()
	icons.path="/images/"
	icons.add("ball","leaf")
	icons.add("ball","twig")
	icons.add("ball","ball1")
	icons.add("ball2")
	icons.add("pisa_plus","expand")
	icons.add("icon_fix","collapse")
	var tree=new alai_tree(icons,0,toObject)
	tree.body.style.cssText="background:buttonface;width:180;background-image:url('images/bg1.gif');border:1 solid buttonface"
	//if(typeof(toObject)=="object")toObject.style.cssText="background:buttonface;width:186;text-align:center;border:2 outset;padding:4 1 4 8;"
	var lastNode=null
	tree.afteradd=function(srcNode)
	{
		srcNode.body.style.cssText="text-align:left;width:100%;color:black;cursor:hand;margin:1;font-size:10pt;background-image:url('/images/bg1.gif');"
		if(srcNode.parent!=tree.root)
		{	srcNode.parent.body.style.cssText="text-align:left;width:100%;height:22;border:1 outset;color:black;background:buttonface;background-image:url('/images/btn_bg.gif');cursor:default;padding-top:2;font-size:10pt;"
			srcNode.parent.body.onclick=srcNode.parent.exIcon.onclick=srcNode.parent.label.click
		}
	}
	var exNode=null
	tree.onexpand=function(srcNode)
	{
		if(exNode!=null && srcNode!=exNode)exNode.expand(false);
		exNode=srcNode
	}
	tree.onmouseover=function(srcNode)
	{	if(!srcNode.hasChild)
		{
			srcNode.label.style.color="red"
			srcNode.exIcon.src=icons.item["ball2"].src
			//srcNode.body.style.background="white"
		}
	}
	tree.onmouseout=function(srcNode)
	{	if(!srcNode.hasChild)
		{	srcNode.label.style.color="black"
			//srcNode.body.style.background=""
			srcNode.exIcon.src=icons.item["ball1"].src
		}
	}

	tree.onselect=function(){return false;}
	return tree ;
}
