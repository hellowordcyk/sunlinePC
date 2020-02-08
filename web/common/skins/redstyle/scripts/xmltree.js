	var HC = "color:#990000";
	var SC = "background-color:#ffffff;color:#000000;";
	var IO = null;
	
	var firstDefaultNode = "";
	
	function initTree(){
	    alert("initTree");
		var rootn = document.all.menuXML.documentElement;
		var sd = 1;
		document.onselectstart = function(){return false;}
		//document.all.treeBox.appendChild(createTree(rootn,sd));
		document.all.treeBox.appendChild("<img src="+"/img/expand.gif class=ec>");
		
	}
			
	function createTree(thisn,sd){
	    alert("createTree--");
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
			
			innerHTML = "<img src="+"/img/expand.gif class=ec>" + thisn.getAttribute("text") +"";
			alert(innerHTML);
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
							this.all.tags("img")[0].src = ("/img/contract.gif");
						}
					}
					this.cn.style.display = "inline"; 					
				    this.all.tags("img")[0].src = ("/img/expand.gif");
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
			oncontextmenu = contextMenuHandle;
			onclick = clickHandle;
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
			upobj.setAttribute("cn",cn);
			if(thisn.getAttribute("open") != null){
				upobj.setAttribute("open",(thisn.getAttribute("open")=="true"));
				//upobj.getAttribute("cn").style.display = upobj.getAttribute("open")?"inline":"none";
				//if( !upobj.getAttribute("open"))upobj.all.tags("img")[0].src =contextPath+"/common/skins/outlook/img/contract.gif";
				if(sd ==1 || firstDefaultNode == ""){ //默认展开第一个末级节点
					upobj.getAttribute("cn").style.display = "inline";
				}else{
					upobj.getAttribute("cn").style.display = "none";
				    upobj.all.tags("img")[0].src ="/img/contract.gif";
				}
			}
			
			for(i=0;i<nodes.length;cn.appendChild(createTree(nodes[i++],sd+1)));
			nodeObj.appendChild(cn);
		}else{
			//------------->>将缺省打开的节点上色
			if( firstDefaultNode == "" ){
				firstDefaultNode = "yes";
				
				if(upobj.getAttribute("cn")){
					upobj.setAttribute("open",!upobj.getAttribute("open"));
					upobj.cn.style.display = upobj.getAttribute("open")?"inline":"none";
					upobj.all.tags("img")[0].src = upobj.getAttribute("open")?("/img/expand.gif"):("/img/contract.gif");
				}
				if(IO){
					IO.runtimeStyle.cssText = "";
					IO.setAttribute("selected",false);
				}
				IO = upobj;
				//upobj.setAttribute("selected",true);
				//upobj.runtimeStyle.cssText = SC;
				
				//调用第一个叶子节点的行为
			    document.all.initmenu.target = "bodyFrame";
			    //document.all.initmenu.href = padContextpath(upobj.getAttribute("href"));
			 	document.all.initmenu.href = padContextpath("/common/skins/outlook/initPanel.jsp");
			    document.all.initmenu.click();
			}
			if(thisn.getAttribute("treeId")=="wfclient"){
	    		isworkflow = 1;
	   		}
			//<<--------------------------------
			upobj.all.tags("img")[0].src ="/img/endnode.gif";
		}
		//默认显示工作流任务
		if(isworkflow==1){
			top.bodyFrame_all.rightFrame.bodyFrame.window.location.href = "com.sunline.sunfi.sunfi_wf.listWorkItemSelf.flow";
		}
		alert(nodeObj);
		return nodeObj;
			
	}
	
	function clickHandle(){

		var rightTopHtml="";
		var curpos = top.bodyFrame_all.rightFrame.topFrame.window.document.getElementById('curpos').value;
		rightTopHtml += "<ul>";
		rightTopHtml += "<li><a>"+curpos+"</a></li>";		
		rightTopHtml += replaceLast(this.getAttribute("menuPath"),'[','<li><a><span class="current">');// 将最后一个 [ 替换为 <li><a><span class="current">
		rightTopHtml = rightTopHtml.replace(/\[/g,'<li><a><span>').replace(/\]/g,'</span></a></li>');
		rightTopHtml += "</ul>";
		
		if( this.getAttribute("href") != "null" && this.getAttribute("href") != ""){
		    top.bodyFrame_all.rightFrame.bodyFrame.window.location.href = padContextpath(this.getAttribute("href"));
		}else{
			top.bodyFrame_all.rightFrame.bodyFrame.window.location.href = padContextpath("/common/skins/outlook/initPanel.jsp");
		}
		alert(rightTopHtml);
		top.bodyFrame_all.rightFrame.topFrame.window.document.getElementById("pagetip").innerHTML = rightTopHtml;
	}
	
	function contextMenuHandle(){
		event.returnValue = false;
		var treeId = this.getAttribute("treeId");
		// your code here
	}
	
	function padContextpath(url){
	  var headexpr = new RegExp("^/");
	  var tailexpr = new RegExp("\\.jsp(\\?.*){0,1}$");
	  var root = contextPath;
	  if(root=="/") root="";
	  if(tailexpr.test(url)){
	    if(headexpr.test(url)){
	      return root+url;
	    }else{
	      return root+"/"+url;
	    }
	  }else{
	    return url;
	  }
	}
	//替换最后一个匹配的内容，str1 要替换的内容，str2 要替换的目标内容
	function replaceLast(contain,str1,str2){
		var index=contain.lastIndexOf(str1);
		var subStr1=contain.substring(0,index);
		var subStr2=contain.substring(index+1,contain.length);
		contain=subStr1+str2+subStr2;
		return contain;

	}
	