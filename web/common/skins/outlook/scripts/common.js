/**
 * 鍔熻兘锛氭鏌ヤ袱涓棩鏈熸帶浠剁敓鎴愮殑鏃ユ湡澶у皬
 * 鍙傛暟锛歛rg1-琚瘮杈冨€?
 *		arg2-姣旇緝鍊?
 *		fmt-鏃ユ湡鏍煎紡
 * 杩斿洖鍊硷細0-涓や釜鏃ユ湡鐩哥瓑
 *		1-绗竴涓棩鏈熷ぇ浜庣浜屼釜鏃ユ湡
 *		2-绗竴涓棩鏈熷皬浜庣浜屼釜鏃ユ湡
 *		-1-鏌愪釜鍙傛暟涓嶆槸涓€涓棩鏈?
 *		-2-鍙戠敓浜嗗叾浠栫殑寮傚父
*/ 
function f_compare_date(arg1,arg2,fmt){
	try{
		if((!isDate(arg1,fmt))||(!isDate(arg2,fmt))){
			return -1;
		}
		var v1 = stringToDate(arg1,fmt);
		var v2 = stringToDate(arg2,fmt);
		if(v1==v2){
			return 0;
		}
		if(v1>v2){
			return 1;
		}
		if(v1<v2){
			return 2;
		}    		
	}catch(e){
		return -2;
	}
}
/*
 *  瀹炵幇鍏ㄩ€夊閫夋
 *  param0: 澶嶉€夋瀵硅薄
 *  param1: 缁勫璞?
 */
function checkSelectAll( checkObj, groupObj ){

    if( $id( checkObj ) != null && $id( groupObj ) != null ) {
		if ($name( checkObj ).checked){
			selectAll(groupObj);
		}else{
			selectNone(groupObj);
		}
	}
}
/*
 *杩斿洖瀵硅薄涓€変腑鐨勫€?
 */
function selectone(name){
if(name==null) return false;
var objs =$names(name);
   var ok = false;
   for(var i=0;i<objs.length;i++){
      if(objs[i].checked){
        ok = true;
        break;
      }
   }
   return ok;
}

function getSelectedValue(name){
if(name==null) return "";
var objs =$names(name);
   for(var i=0;i<objs.length;i++){
      if(objs[i].checked){
        return objs[i].value;
        break;
      }
   }
   return null;
}

/*
 *  鍒濆鍖栭〉闈utton鐨勬牱寮?
 */
function initButtonStyle() {
    var tagnames = ["INPUT","input"];
    for(var i=0;i<tagnames.length;i++){
      var objs = document.getElementsByTagName(tagnames[i]);
      for(var j=0;j<objs.length;j++){
      var obj =objs[j];
      switch(obj.type){
        case 'button':
        case 'submit':
        case 'reset':
           obj.className="button";
         break;
      }   
    }
   }
}
/*
 *鐢ㄤ簬鑾峰彇澶氳鐨勬枃鏈?
 *鐢ㄦ硶锛?
 * var str = function(){\/\*<b:write property="abc" />\*\/}
 */
Function.prototype.getMultiLine = function() {   
	    var lines = new String(this);   
	    lines = lines.substring(lines.indexOf("/*") + 2, lines.lastIndexOf("*/"));   
	    return lines;   
}
/*
 *  鍗曞嚮澶嶉€夋鏃讹紝鑷姩灞忚斀鎴栨墦寮€淇敼鍜屽垹闄ゆ寜閽?
 */
function clickCheck(  groupObj, updateObj, deleteObj ) {

    if( groupObj.getSelectLength() < 1 ) {
        if( updateObj != null )
            updateObj.disabled = true;
        if( deleteObj != null )
            deleteObj.disabled = true;

        return function(){};
    }

    if( groupObj.getSelectLength() == 1 ) {
        if( updateObj != null ) {
            updateObj.disabled = false;
        }
        if( deleteObj != null )
            deleteObj.disabled = false;

        return function(){};
    }

    if( groupObj.getSelectLength() > 1 ) {
        if( updateObj != null )
            updateObj.disabled = true;
        if( deleteObj != null )
            deleteObj.disabled = false;

        return function(){};
    }
}

//鍥哄畾鑷姩璁剧疆iframe澶у皬锛屼互閫傚簲褰撳墠灞忓箷瀹介珮
function iframeAutoFit(){
        try
        {
            if(window!=parent)
            {
                var a = parent.document.getElementsByTagName("IFRAME");
                for(var i=0; i<a.length; i++) //author:meizz
                {
                    if(a[i].contentWindow==window)
                    {
                        var h1=0, h2=0;
                        a[i].parentNode.style.height = a[i].offsetHeight +"px";
                        a[i].style.height = "0px";
                        if(document.documentElement&&document.documentElement.scrollHeight)
                        {
                            h1=document.documentElement.scrollHeight;
                        }
                        if(document.body) h2=document.body.scrollHeight;

                        var h=Math.max(h1, h2);

                        if(document.all) {h += 5;}
                        if(window.opera) {h += 1;}
                        a[i].style.height = a[i].parentNode.style.height = h +"px";
                    }
                }
            }
        }
        catch (ex){}
 }
 function toQueryString(frm){
 /*
    var elements = Form.getElements($(form));   
    var queryComponents = new Array();         
    for (var i = 0; i < elements.length; i++){   
      var queryComponent = Form.Element.serialize(elements[i]);   
      if (queryComponent)   
        queryComponents.push(queryComponent);   
    }   
       
    return queryComponents.join('&');  
    */
 }
 //Given a form name, grab it's object and loop through all of them setting their disabled attribute to true.
function disableForm(formName){
  var obj = document.forms[formName];
  if(!obj) return; //Return if we didn't get a valid form object...to prevent some js errors.
  for(var i = 0; i < obj.length; i++) {
    obj.elements[i].disabled = true;
  }

}
function enableForm(formName){
  var obj = document.forms[formName];
  if(!obj) return; //Return if we didn't get a valid form object...to prevent some js errors.
  for(var i = 0; i < obj.length; i++) {
    obj.elements[i].disabled = false;
  }

}

function nullToBlank(obj){
   if(obj=="null"||obj==null){
      return "";
   }else{
     return obj;
   }
}
