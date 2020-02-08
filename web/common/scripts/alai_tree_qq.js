/*******************************************************************************
	阿赖目录树控件仿QQ面板模板程序 由赖国欣设计于2003年7月16日，保留所有权利！
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

function alai_tree_qq(toObject)
{
	var path=getScriptPath("alai_tree.js")
	if(path==null){alert("run alai_tree_qq() fail, please load alai_tree.js first!");return;}
	var icons=new alai_imagelist()
	icons.path=path+"qqface/"
	icons.type="bmp"
	icons.add("1-1","test")
	for(var i=1;i<=85;i++)
		icons.add(i+"-1")

	var tree=new alai_tree(icons,18,toObject)
	tree.body.style.cssText="background:#6666cc;border:3 inset;width:100;"
	if(typeof(toObject)=="object")toObject.style.cssText="background:buttonface;width:106;text-align:center;border:1 outset;padding:4 1 4 1;"
	var lastNode=null
	tree.afteradd=function(srcNode)
	{	if(srcNode.parent!=tree.root)
		{	srcNode.label.insertAdjacentHTML("beforeBegin","<BR>");
			srcNode.body.style.cssText="text-align:center;width:100%;color:black;cursor:default;margin:4;font-size:10pt;"
		}
		else
		{	srcNode.body.style.cssText="text-align:center;width:100%;height:22;border:2 outset;color:black;background:buttonface;cursor:hand;padding-top:2;font-size:10pt;"
			srcNode.container.style.overflow="hidden";
			srcNode.body.onclick=srcNode.label.click
		}
		srcNode.body.style.textAlign="center";
	}
	tree.onexpand=function(srcNode)
	{	lastNode=srcNode
		srcNode.container.style.pixelHeight=470;
	}
	tree.onmouseover=function(srcNode)
	{	if(srcNode.parent!=tree.root)
		{
			srcNode.label.style.color="blue"
			srcNode.body.style.marginBottom=0
			srcNode.icon.style.border="2 outset"
		}
	}
	tree.onmouseout=function(srcNode)
	{	if(srcNode.parent!=tree.root)
		{	srcNode.label.style.color="black"
			srcNode.body.style.marginBottom=4
			srcNode.icon.style.border=""
		}
	}
	tree.onclick=function(srcNode)
	{	if(srcNode.parent==tree.root)
		{	if(lastNode!=null){lastNode.container.style.pixelHeight=22;lastNode.expand(false);}
			srcNode.container.style.pixelHeight=470;
			srcNode.expand(true)
			lastNode=srcNode
			return false
		}
		else{return true}
	}
	tree.onselect=function(){return false;}
	return tree ;
}
