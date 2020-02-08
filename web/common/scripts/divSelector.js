/**
smanPromptList(数据项id名称,参数类型,参数键,步进长度,最大显示记录数)
*/
function smanPromptList(objInputId,sType,sKey){
	var argv = smanPromptList.arguments;
	var argc = smanPromptList.arguments.length;
	var lvLen = (argc > 3) ? argv[3] : 2;
	var pageSize = (argc > 4) ? argv[4] : 15;
  var objouter=document.getElementById("__smanDisp") //显示的DIV对象
  var objInput = document.getElementById(objInputId); //文本框对象
  var selectedIndex=-1;
  var intTmp; //循环用的:)
  if (objInput==null) {
  	alert('smanPromptList初始化失败:没有找到"'+objInputId+'"文本框');
  	return ;
  }
  //文本框失去焦点
  objInput.onblur=function(){
      objouter.style.display='none';
      showEle('SELECT');
  }
  //文本框按键抬起
  objInput.onkeyup=checkKeyCode;
  //文本框得到焦点
  objInput.onfocus=checkAndShow;
            function checkKeyCode(evt){
            	hideEle('SELECT',document.getElementById("__smanDisp"));
			    evt = evt || window.event;
                var ie = (document.all)? true:false
                if (ie){
                    var keyCode=evt.keyCode
                    if (keyCode==40||keyCode==38){ //下上
                        var isUp=false
                        if(keyCode==40) isUp=true ;
                        chageSelection(isUp)
                    }else if (keyCode==13){//回车
                        outSelection(selectedIndex);
                    }else{
                        checkAndShow(evt)
                    }
                }else{
                    checkAndShow(evt)
                }
                divPosition(evt)
            }

            function checkAndShow(evt){
                        var strInput = objInput.value
                        //if (strInput!=""){
                        if (true){
                            divPosition(evt);
                            selectedIndex=-1;
                            //objouter.innerHTML ="";
												    if (document.getElementById) {
												        var x = (window.ActiveXObject) ? new ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest();
												    }
												    if (x) {
												        x.onreadystatechange = function()   {
												            if (x.readyState == 4 && x.status == 200) {
												                objouter.innerHTML = x.responseText;
												                hideEle('SELECT',document.getElementById("__smanDisp"));
												            }
												            if (x.readyState == 4 && x.status != 200) {
												                objouter.innerHTML="error getting xml data via AJAX";
												            }
												        }
												    }
												    var surl='/public/divSelector.jsp?type='+sType+'&key='+sKey+'&inputerid='+objInputId+'&value='+objInput.value+'&lvlen='+lvLen+'&pagesize='+pageSize;
												    //alert(surl);
												    x.open("GET", surl, true);
												    x.send(null);
                            objouter.style.display='';
                            hideEle('SELECT',document.getElementById("__smanDisp"));
                        }else{
                            objouter.style.display='none';
                    }
            }
            function chageSelection(isUp){
                if (objouter.style.display=='none'){
                    objouter.style.display='';
                }else{
                    if (isUp)
                        selectedIndex++
                    else
                        selectedIndex--
                }
                var maxIndex = objouter.children.length-1;
                if (selectedIndex<0){selectedIndex=0}
                if (selectedIndex>maxIndex) {selectedIndex=maxIndex}
                for (intTmp=0;intTmp<=maxIndex;intTmp++){

                    if (intTmp==selectedIndex){
                        objouter.children[intTmp].className="sman_selectedStyle";
                    }else{
                        objouter.children[intTmp].className="";
                    }
                }
            }
            function outSelection(Index){
                objInput.value = objouter.children[Index].value;
                objouter.style.display='none';
                showEle('SELECT');
            }
		function divPosition(evt){
			var left = 0;
			var top  = 0;				
			var e = objInput;
			while (e.offsetParent){
				left += e.offsetLeft + (e.currentStyle?(parseInt(e.currentStyle.borderLeftWidth)).NaN0():0);
				top  += e.offsetTop  + (e.currentStyle?(parseInt(e.currentStyle.borderTopWidth)).NaN0():0);
				e     = e.offsetParent;
			}
			
			left += e.offsetLeft + (e.currentStyle?(parseInt(e.currentStyle.borderLeftWidth)).NaN0():0);
			top  += e.offsetTop  + (e.currentStyle?(parseInt(e.currentStyle.borderTopWidth)).NaN0():0);
			
			objouter.style.top    = (top  + objInput.clientHeight) + 'px' ;
			objouter.style.left    = left + 'px' ; 
			objouter.style.width= objInput.clientWidth;
		}
		function getAbsoluteHeight(ob){
        return ob.offsetHeight
    }
    function getAbsoluteWidth(ob){
        return ob.offsetWidth
    }
    function getAbsoluteLeft(ob){
        var mendingLeft = ob .offsetLeft;
        while( ob != null && ob.offsetParent != null && ob.offsetParent.tagName != "BODY" ){
            mendingLeft += ob .offsetParent.offsetLeft;
            mendingOb = ob.offsetParent;
        }
        return mendingLeft ;
    }
    function getAbsoluteTop(ob){
        var mendingTop = ob.offsetTop;
        while( ob != null && ob.offsetParent != null && ob.offsetParent.tagName != "BODY" ){
            mendingTop += ob .offsetParent.offsetTop;
            ob = ob .offsetParent;
        }
        return mendingTop ;
    }
Number.prototype.NaN0 = function()
{
    return isNaN(this)?0:this;
}    
}
document.write("<div id='__smanDisp' style='position:absolute;display:none;background:#E8F7EB;border: 1px solid #CCCCCC;font-size:14px;cursor: default;' onbulr> </div>");
document.write("<style>.sman_selectedStyle{background-Color:#102681;color:#FFFFFF}</style>");
//div  id='__smanDisp' 的区域隐藏select框
function hideEle(elmID,overDiv)
{
    for( i = 0; i < document.all.tags( elmID ).length; i++ )
    {
      obj = document.all.tags( elmID )[i];
      if( !obj || !obj.offsetParent ||obj.id=="XCLYear"||obj.id=="XCLMonth" )
      {
        continue;
      }
  
      objLeft   = obj.offsetLeft;
      objTop    = obj.offsetTop;
      objParent = obj.offsetParent;
      
      while( objParent.tagName.toUpperCase() != "BODY" )
      {
        objLeft  += objParent.offsetLeft;
        objTop   += objParent.offsetTop;
        objParent = objParent.offsetParent;
      }
  
      objHeight = obj.offsetHeight;
      objWidth = obj.offsetWidth;
  
      if(( overDiv.offsetLeft + overDiv.offsetWidth ) <= objLeft );
      else if(( overDiv.offsetTop + overDiv.offsetHeight ) <= objTop );
      else if( overDiv.offsetTop >= ( objTop + objHeight ));
      else if( overDiv.offsetLeft >= ( objLeft + objWidth ));
      else
      {
        obj.style.visibility = "hidden";
      }
    }
}
//div  id='__smanDisp' 的区域隐藏select框
function showEle(elmID)
{
    for( i = 0; i < document.all.tags( elmID ).length; i++ )
    {
      obj = document.all.tags( elmID )[i];
      
      if( !obj || !obj.offsetParent )
      {
        continue;
      }
    
      obj.style.visibility = "";
    }
}
