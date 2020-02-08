/*******************************************************************************
		阿赖网页表格控件程序 由赖国欣设计于2003年3月-6月，保留所有权利！
*********************************************************************************/
function alai_tc(tbl,caption,dataType,tcStyle,tblStyle,rowStyle,colStyle)
{
try{
	var tc=this;
	tc.err="";
	tc.col=[];
	tc.tbl=tbl;
	tc.copywrite="Copywrite by Alai(赖国欣) (c)2003，All right reserved!"
	if(!document.getElementById){throw new Error(999,"Your browser dosen't support Alai_tc function,IE5.0+ is recommended.");}
	tc.ctr=document.createElement("table");
	tc.extConvert=new Function();
	tc.setCaption=function(c)
	{
		var c=c==null?[]:c.split("|");
		for(var i=0;i<tc.col.length;i++){tc.col[i].innerHTML=c[i]==null?"&nbsp;":c[i];}
	}
	tc.setDataType=function(dataType)
	{
		var dt=dataType==null?[]:dataType.split("|");
		for(var i=0;i<tc.col.length;i++)
		{
			dType[i]=dt[i]==null?"char":dt[i];
			if(dType[i].toUpperCase()=="CNPY")load_js("pingying.js");
			else if(dType[i].toUpperCase()=="CNBH")load_js("bihua.js");
		}
		tc.dType=dType;
	}
	tc.setTcStyle=function(style)
	{
		var defCss="border:1 outset;height:21;text-align:center;white-space:nowrap;overflow:hidden;";
		tcStyle=style==null?"":style;
		for(var i=0;i<tc.col.length;i++)tc.col[i].style.cssText=defCss+tcStyle;
	}
	tc.setTblStyle=function(style){if(style!=null){tc.tbl.style.cssText=style;tblStyle=style;}}
	tc.setRowStyle=function(style)
	{
		if(style==null)style=rowStyle
		if(style!=null)
		{
			var s=style.split("|");
			var m=0;
			for(var i=0;i<tr.length;i++)
			{
				var td=tr[i].cells
				for(var j=0;j<td.length;j++)td[j].style.cssText+=";"+s[m];
				m=(m>=s.length-1)?0:++m;
			}
			rowStyle=style;
		}
		setSelStyle()
	}
	tc.setColStyle=function(style)
	{
		if(style==null)style=colStyle
		if(style==null){return;}
		var s=style.split("|");
		for(var i=0;i<tr.length;i++)
		{
			var m=0;
			var td=tr[i].cells
			for(var j=0;j<td.length;j++)
			{
				td[j].style.cssText+=";"+s[m];
				m=(m>=s.length-1)?0:++m;
			}
		}
		colStyle=style;
	}
	var dType=[];
	var sortBy=[];
	var tdLocate
	var selTr=[]
	var selFC,selBC
	var jsPath=""
	var setSelStyle=function()
	{
		for(var i=0;i<selTr.length;i++)
		{	var td=selTr[i].cells
			for(var j=0;j<td.length;j++)
			{
				td[j].style.color=selFC
				td[j].style.backgroundColor=selBC
			}
		}
		if(tdLocate!=null)
		{
			var c=tdLocate.currentStyle.color
			tdLocate.style.color=tdLocate.currentStyle.backgroundColor
			tdLocate.style.backgroundColor=c
		}
	}
	var tblSort=function(tbl,colIndex,By,DataType)
	{
		var convert=function(Data,Type)
		{	var Rst=Data;
			var cn_code=function(idx)
			{	if	(idx<100){return String.fromCharCode(0,idx);}
				else{var s=idx.toString();return String.fromCharCode(parseInt(s.substring(0,s.length-2)),idx%100);}
			}
			switch(Type.toUpperCase())
			{	case "CHAR":	Rst=Data;break;
				case "NUM":		Rst=parseFloat(Data);if(isNaN(Rst))Rst=Data;break;
				case "DATE":	Rst=Date.parse(Data);if(isNaN(Rst))Rst=Data;break;
				case "CNPY":
					if(typeof(strChinesePingYing)=="undefined"){return Data;}
					Rst="";
					for(var i=0;i<Data.length;i++){var idx=strChinesePingYing.indexOf(Data.charAt(i));Rst+=idx!=-1?cn_code(idx):Data.charAt(i);}
					break;
				case "CNBH":
					if(typeof(strChineseBiHua)=="undefined"){return Data;}
					Rst="";
					for(var i=0;i<Data.length;i++){var idx=strChineseBiHua.indexOf(Data.charAt(i));Rst+=idx!=-1?cn_code(idx):Data.charAt(i);}
					break;
				default :	Rst=tc.extConvert(Data,Type);if(Rst==null){Rst=Data};
			}
			return Rst;
		}
		var ByAsc=(By=="ASC")
		var arySort=[]
		for(var i=0;i<tbl.rows.length;i++)
		{
			var Data=(tbl.rows[i].cells[colIndex])?(tbl.rows[i].cells[colIndex].innerText.toLowerCase()):null;
			Data=convert(Data,DataType);
			arySort[i]=new Array(Data,tbl.rows[i]);
		}
		arySort.sort(function(){var a=arguments;return ByAsc?(a[0][0]>a[1][0]?1:(a[0][0]<a[1][0]?-1:0)):(a[0][0]<a[1][0]?1:(a[0][0]>a[1][0]?-1:0));})
		for(i=0;i<arySort.length;i++){tbl.lastChild.appendChild(arySort[i][1]);}
	}
	var load_js=function (src)
	{
		var script=document.getElementsByTagName("SCRIPT");
		for(var i=0;i<script.length;i++)
		{
			var s=script[i].src.toLowerCase()
			if(s==src.toLowerCase())return;
			if(s.indexOf("alai_tc.js")!=-1){jsPath=s.replace("alai_tc.js","")}
		}
		document.write('<script src="'+jsPath+src+'"></script>');
	}
	Array.prototype.remove=function(index){if(index<0 || index>=this.length)return;for(var i=index;i<this.length;i++)this[i]=this[i+1];this.length--;}
	Array.prototype.indexOf=function(elm){for(var i=0;i<this.length;i++)if(elm==this[i])return i;return -1;}

	if(tbl==null){throw new Error(999,"Miss table object.The first argument is required!");}
	else if(!isNaN(parseInt(tbl)))
	{	var i=parseInt(tbl);
		var tbls=document.all.tags("table");
		if(tbls.length>i){tc.tbl=tbls[i];}
		else{throw new Error(999,"Table index value out of range.");}
	}else if(typeof(tbl)!="object" || tbl.tagName!="TABLE"){throw new Error(999,"The first argument isn't a table object.");}
	tbl=tc.tbl
	var tr=tbl.rows
	tc.tbl.insertAdjacentElement("beforeBegin",tc.ctr)
	tc.tbl.style.marginTop=0
	with(tc.ctr)
	{	style.cssText="border:0;font-size:9pt;color:black;margin:0;padding:0;border-collapse:collapse;background-color:buttonface;table-layout:fixed;"
		//style.pixelWidth=tc.tbl.offsetWidth
		setAttribute("width",tc.tbl.currentStyle.width)
		cellPadding=0
		cellSpacing=0
	var row=insertRow()
	}
	for(var i=0;i<tr[0].cells.length;i++)
	{
		tc.col[i]=row.insertCell();
	with(tc.col[i])
	{
		setAttribute("width",tr[0].cells[i].offsetWidth);
		sortBy[i]="DESC";
		onclick=function()
		{	var idx=this.cellIndex
			tblSort(tc.tbl,idx,sortBy[idx],dType[idx]);
			sortBy[idx]=(sortBy[idx]=="ASC")?"DESC":"ASC";
			tc.setRowStyle(rowStyle);
			tr=tc.tbl.rows
		}
		onmousedown=function(){this.style.borderStyle="inset";}
		onmouseup=function(){this.style.borderStyle="outset";}
		onmousemove=function(){this.style.cursor="default"}
	}}

	tc.setCaption(caption);
	tc.setDataType(dataType);
	tc.setTcStyle(tcStyle);
	tc.setTblStyle(tblStyle);
	tc.setColStyle(colStyle);
	tc.setRowStyle(rowStyle);


	tc.selectOne=function(bColor,fColor)
	{
		tc.selRow=null;
		tc.selData=[];
		selFC=fColor==null?"white":fColor
		selBC=bColor==null?"darkblue":bColor
		tc.tbl.onclick=function()
		{
			e=event.srcElement;
			if(e==this){return;}
			while(e.tagName!="TR"){e=e.parentElement;}
			tc.selRow=e;
			var td=e.cells;
			for(var i=0;i<td.length;i++)tc.selData[i]=td[i].innerText;
			selTr[0]=tc.selRow
			tc.setColStyle(colStyle);
			tc.setRowStyle(rowStyle);
		}
	}
	tc.multiSelect=function(bColor,fColor)
	{
		tc.selRow=[];
		tc.selData=[];
		selFC=fColor==null?"white":fColor
		selBC=bColor==null?"darkblue":bColor
		tc.tbl.onclick=function()
		{
			e=event.srcElement;
			if(e==this){return;}
			while(e.tagName!="TR"){e=e.parentElement;}
			var i=tc.selRow.indexOf(e);
			if(i==-1)tc.selRow[tc.selRow.length]=e;
			else tc.selRow.remove(i);
			tc.selData=[];
			for(var i=0;i<tc.selRow.length;i++)
			{
				tc.selData[i]=[];
				for(var j=0;j<tc.selRow[i].cells.length;j++)tc.selData[i][j]=tc.selRow[i].cells[j].innerText;
			}
			selTr=tc.selRow
			tc.setColStyle(colStyle);
			tc.setRowStyle(rowStyle);
		}
	}
	tc.mouseOver=function(bColor,fColor)
	{
		var curRow=null;
		var fc=fColor==null?"darkblue":fColor
		var bc=bColor==null?"FFFF66":bColor
		var rowfc=[],rowbc=[]
		function overRow(tr)
		{
			if(curRow!=null)
			{
				var td=curRow.cells
				for(var i=0;i<td.length;i++)
				{
					td[i].style.color=rowfc[i]
					td[i].style.backgroundColor=rowbc[i]
				}
			}
			var td=tr.cells
			for(var i=0;i<td.length;i++)
			{
				rowfc[i]=td[i].currentStyle.color
				rowbc[i]=td[i].currentStyle.backgroundColor
				td[i].style.color=fc
				td[i].style.backgroundColor=bc
			}
			curRow=tr
		}
		tc.tbl.onmouseover=function()
		{
			var e=event.srcElement;
			if(e==this){return;}
			while(e.tagName!="TR"){e=e.parentElement;}
			overRow(e)
			setSelStyle()
		}
		tc.tbl.onmouseout=function()
		{
			if(curRow==null){return}
			var td=curRow.cells
			for(var i=0;i<td.length;i++)
			{
				td[i].style.color=rowfc[i]
				td[i].style.backgroundColor=rowbc[i]
			}
			curRow=null
			tc.setColStyle(colStyle);
			tc.setRowStyle(rowStyle);
		}
		var idx=-1;
		var colfc=[],colbc=[]
		tc.ctr.onmouseover=function()
		{
			var e=event.srcElement;
			if(e.tagName!="TD"){return;}
			if(idx!=-1)
			{
				for(var i=0;i<tr.length;i++)
				{
					tr[i].cells[idx].style.color=colfc[i];
					tr[i].cells[idx].style.backgroundColor=colbc[i];
				}
			}
			idx=e.cellIndex
			for(var i=0;i<tr.length;i++)
			{
				colfc[i]=tr[i].cells[idx].currentStyle.color;
				colbc[i]=tr[i].cells[idx].currentStyle.backgroundColor;
				tr[i].cells[idx].style.color=fc;
				tr[i].cells[idx].style.backgroundColor=bc;
			}
			setSelStyle()
		}
		tc.ctr.onmouseout=function()
		{
			if(idx!=-1)
			{
				for(var i=0;i<tr.length;i++)
				{
					tr[i].cells[idx].style.color=colfc[i];
					tr[i].cells[idx].style.backgroundColor=colbc[i];
				}
			}
			tc.setColStyle(colStyle);
			tc.setRowStyle(rowStyle);
		}
	}
	tc.contextMenu=function()
	{
		var menu=function ()
		{
			var mnu=this
			mnu.item=[]
			mnu.body=document.createElement("div")
			document.body.insertAdjacentElement("afterBegin",mnu.body)
			mnu.body.style.cssText="position:absolute;z-index:10;width:120;border:2 outset;background-color:buttonface;display:none;"
			mnu.add=function(Text)
			{
				var item=document.createElement("span")
				mnu.body.insertAdjacentElement("beforeEnd",item)
				item.style.cssText="padding-top:2;padding-left:14;font-size:10pt;height:21;cursor:default;color:black;background-color:buttonface;width:100%;"
				item.innerText=Text
				mnu.item[mnu.item.length]=item
				item.onmouseover=function(){item.style.color="white";item.style.backgroundColor="darkblue";}
				item.onmouseout=function(){item.style.color="black";item.style.backgroundColor="buttonface";}
				return item
			}
			mnu.remove=function(idx){mnu.item[idx].removeNode(true);}
			mnu.show=function()
			{
				mnu.body.style.pixelTop=event.y+document.body.scrollTop
				mnu.body.style.pixelLeft=event.x+document.body.scrollLeft
				mnu.body.style.display="block"
			}
			mnu.hide=function(){mnu.body.style.display="none";}
			mnu.body.onclick=mnu.hide
		}
		var tblMenu=new menu()
		var ctrMenu=new menu()
		var ci=-1,ri=-1,curRow
		var word=""
		tdLocate=null
		var find=function()
		{
			tblMenu.hide();ctrMenu.hide();
			var w=prompt("Hi,tell me what are you looking for?",word)
			if(w=="" || w==null){return}
			w=w.toLowerCase()
			var idx=(w!=word || tdLocate==null)?(0):(tdLocate.parentElement.rowIndex)
			if(tdLocate!=null)
			{
				var c=tdLocate.currentStyle.color
				tdLocate.style.color=tdLocate.currentStyle.backgroundColor
				tdLocate.style.backgroundColor=c
			}
			for(var i=++idx;i<tr.length;i++)
			{
				var td=tr[i].cells
				for(var j=0;j<td.length;j++)
				{
					if(td[j].innerText.toLowerCase().indexOf(w)!=-1)
					{
						tdLocate=td[j]
						word=w
						tc.setRowStyle(rowStyle);
						return
					}
				}
			}
			tdLocate=null
			tc.setRowStyle(rowStyle);
		}
		tc.tbl.onmousedown=function()
		{
			tblMenu.hide();ctrMenu.hide();
			if(event.button==2)tblMenu.show();
			else if(event.button==1)tblMenu.hide();
			var e=event.srcElement
			if(e.tagName=="TD"){ci=e.cellIndex;ri=e.parentElement.rowIndex;}
			else{ci=-1;ri=-1;}
			tr=tc.tbl.rows
		}
		tc.ctr.onmousedown=function()
		{
			tblMenu.hide();ctrMenu.hide();
			if(event.button==2)ctrMenu.show();
			else if(event.button==1)ctrMenu.hide();
			var e=event.srcElement
			if(e.tagName=="TD")ci=e.cellIndex;else ci=-1;
			ri=-1
			tr=tc.tbl.rows
		}
		tc.tbl.oncontextmenu=new Function("event.returnValue=false");
		tc.ctr.oncontextmenu=new Function("event.returnValue=false");
		tc.tblMenu=tblMenu
		tc.ctrMenu=ctrMenu
		tblMenu.add("上移一行").onclick=function(){if(ri==-1 || ri==0)return;tr[ri].swapNode(tr[ri-1]);tc.setRowStyle(rowStyle);}
		tblMenu.add("下移一行").onclick=function(){if(ri==-1 || ri==tr.lenght-1)return;tr[ri].swapNode(tr[ri+1]);tc.setRowStyle(rowStyle);}
		tblMenu.add("删除当前行").onclick=function(){if(ri==-1)return;tc.tbl.deleteRow(ri);tc.setRowStyle(rowStyle);}
		ctrMenu.add("升序排序").onclick=function()
		{	if(ci==-1)return;
			tblSort(tc.tbl,ci,"ASC",dType[ci]);
			tc.setRowStyle(rowStyle);
			sortBy[ci]="DESC";
			tr=tc.tbl.rows
		}
		ctrMenu.add("降序排序").onclick=function()
		{	if(ci==-1)return;
			tblSort(tc.tbl,ci,"DESC",dType[ci]);
			tc.setRowStyle(rowStyle);
			sortBy[ci]="ASC";
			tr=tc.tbl.rows
		}
		ctrMenu.add("左移一列").onclick=function()
		{	if(ci==-1 || ci==0)return;
			tc.col[ci].swapNode(tc.col[ci-1]);
			for(var i=0;i<tr.length;i++)tr[i].cells[ci].swapNode(tr[i].cells[ci-1]);
			var tmp=tc.col[ci];tc.col[ci]=tc.col[ci-1];tc.col[ci-1]=tmp;
			var tmp=dType[ci];dType[ci]=dType[ci-1];dType[ci-1]=tmp;
		}
		ctrMenu.add("右移一列").onclick=function()
		{	if(ci==-1 || ci==tc.col.length-1)return;
			tc.col[ci].swapNode(tc.col[ci+1]);
			for(var i=0;i<tr.length;i++)tr[i].cells[ci].swapNode(tr[i].cells[ci+1]);
			var tmp=tc.col[ci];tc.col[ci]=tc.col[ci+1];tc.col[ci+1]=tmp;
			var tmp=dType[ci];dType[ci]=dType[ci+1];dType[ci+1]=tmp;
		}
		ctrMenu.add("删除当前列").onclick=function()
		{	if(ci==-1)return;
			tc.ctr.rows[0].deleteCell(ci);
			for(var i=0;i<tr.length;i++)tr[i].deleteCell(ci);
			tc.ctr.setAttribute("width",tc.tbl.offsetWidth);
			tc.col.remove(ci);dType.remove(ci);
		}
		ctrMenu.add("查找").onclick=find
		tblMenu.add("查找").onclick=find
	}
	
	tc.doResize=function()
	{
		var x,tdW,tblW,ctrCol,isSort,isSize
		tc.tbl.style.tableLayout="fixed"
		for(var i=0;i<tr.length;i++)for(var j=0;j<tr[i].cells.length;j++)tr[i].cells[j].style.overflowX="hidden";
		for(var i=0;i<tc.col.length;i++)
		{
			tc.col[i].onmouseover=function(){if(!isSize)ctrCol=this;}
			//tc.col[i].onmouseout=function()	{if(!(event.toElement==tc.ctr || event.toElement.parentElement==tc.ctr || event.toElement.parentElement.parentElement==tc.ctr))isSize=false;}
			tc.col[i].onclick=function()
			{
				if(isSize){isSize=false;return;}
				var idx=this.cellIndex
				tblSort(tc.tbl,idx,sortBy[idx],dType[idx]);
				sortBy[idx]=(sortBy[idx]=="ASC")?"DESC":"ASC";
				tc.setRowStyle(rowStyle);
				tr=tc.tbl.rows
			}
			tc.col[i].onmousedown=function()
			{
				this.setCapture();
				isSort=this.offsetWidth-event.offsetX>8 && event.offsetX>5;
				if(isSort){	this.style.borderStyle="inset";}
				else{
					var i=this.cellIndex
					ctrCol=(event.offsetX<=5 && i!=0)?tc.col[i-1]:tc.col[i]
					x=event.x;
					tdW=ctrCol.offsetWidth;
					tblW=tc.ctr.offsetWidth;
					isSize=true;
					}
			}
			tc.col[i].onmouseup=function(){this.style.borderStyle="outset";this.releaseCapture();}
			tc.col[i].onmousemove=function()
			{
				if(isSize)
				{
					var idx=ctrCol.cellIndex;
					var iSpan=event.x-x;
					tc.ctr.style.pixelWidth=tblW+iSpan
					ctrCol.setAttribute("width",tdW+iSpan);
					tc.tbl.setAttribute("width",tblW+iSpan);
					for(var i=0;i<tr.length;i++){if(tr[i].cells[idx])tr[i].cells[idx].setAttribute("width",tdW+iSpan);}
					return;
				}
				isSort=this.offsetWidth-event.offsetX>8 && event.offsetX>5;
				this.style.cursor=isSort?"default":"move"
			}
		}
	}
return tc
}
catch(e){
	tc.err="alai_tc cause run time error!\nError number:"+e.number+".\nError description:"+e.description;
	tc.err+="\n    -- \nYou can send the case and error description message to A@lai.com.cn for support or visit http://www.9499.net to get the last release!"
	alert(tc.err);
	return tc;
}
}

