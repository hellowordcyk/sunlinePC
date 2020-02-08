function _createObj() {
	if (window.XMLHttpRequest) {
		var objXMLHttp = new XMLHttpRequest();
	}
	else {
		var MSXML = ['MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0', 'MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP'];
		for(var n = 0; n < MSXML.length; n ++) {
			try {
				var objXMLHttp = new ActiveXObject(MSXML[n]);        
				break;
			} catch(e) {
			}
		}
	 }
	 return objXMLHttp;
}

//@deprecated pls using ajaxSendForXml
function getResultByURL(url,funcname) {
	var result;
	document.getElementById("_loadbox").style.display="block";
	var xmlhttp = this._createObj();
	// anti cache with random
	if (url.indexOf("?") > 0){
		url += "&randnum=" + Math.random();
	} else {
		url += "?randnum=" + Math.random();
	}
	xmlhttp.open("post",url,true);
	xmlhttp.onreadystatechange= function () {
		var prc = processRequest(xmlhttp); 
		if (prc) {
			result = loadXML(bytes2BSTR(xmlhttp.responseBody));
			funcname(result);
		}
	} ;
	xmlhttp.send();
}
function processRequest(xmlhttp) {
	if (xmlhttp.readyState == 4) {
		if(xmlhttp.status == 200) {
			document.getElementById("_loadbox").style.display="none";
			return true;
		}
		else {
			alert("Error loading page\n"+ xmlhttp.status +":"+ xmlhttp.statusText);
			return false;
		}
	}
}

function loadXML(xmlString){
    var xmldoc;
    try {
        xmldoc = new ActiveXObject("Microsoft.XMLDOM");
        if(!xmldoc) xmldoc = new ActiveXObject("MSXML2.DOMDocument.3.0");
    } catch(e){}
    if(!xmldoc) {
        return null;
    } else {
        xmldoc.async = "false";
        xmldoc.loadXML(xmlString);
        if(xmldoc.parseError.errorCode == 0 ) {
            return xmldoc;
        } else {
            return null;
        }
    }
}

function formToRequestString(form_obj){
    var query_string='';
    var and='';
    var element_value = '';
    for (i=0;i<form_obj.length ;i++ ){
        var e = form_obj[i];
        element_value = '' ;
        //alert(e.disabled);
        if (e.name !='' && e.disabled != true &&  e.disabled != 'true' && checkExistType(e.type)){
            if (e.type=='select-one'){
                element_value = e.options[e.selectedIndex].value;
            }
            else if (e.type == 'checkbox' || e.type == 'radio'){
                if (e.checked == false){
                    continue;	
                }
                element_value = e.value;
            }else{
                element_value = e.value;
            }
            if (element_value == 'undefined' || element_value == undefined){
                element_value ='';
            }
            query_string = query_string + e.name + '=' + element_value.replace(/\&/g,"%26") + "&";
        }
    }
    return query_string;
}
function formToRequestParams(formObj){
    var formParams = "";
    for(i=0; i<formObj.elements.length; i++){

        if(formObj.elements[i].type == 'submit' ||
           formObj.elements[i].type == 'button' ||
           formObj.elements[i].type == 'image'){
//                var str="";
//                for(prop in formObj.elements[i] ){
//                    str += prop + " : " + formObj.elements[i][prop]+"          ";
//                }
//                alert(str);
            if(formObj.elements[i].clicked && formObj.elements[i].clicked){
				        if(i > 0){
				            formParams = formParams + "&";
				        }
                formParams = formParams + formObj.elements[i].name;
                formParams = formParams + "=";
                formParams = formParams + encodeURIComponent(formObj.elements[i].value);
                //formParams = formParams + formObj.elements[i].value;
            }
        } else{
		        if(i > 0){
		            formParams = formParams + "&";
		        }
            formParams = formParams + formObj.elements[i].name;
            formParams = formParams + "=";
            formParams = formParams + encodeURIComponent(formObj.elements[i].value);
            //formParams = formParams + formObj.elements[i].value;
        }
    }
    return formParams;
}
// params = (uri ,params ,onStateChange(XMLHttpRequest))
function ajaxSendRequest(uri,param,onStateChange){
	var x = this._createObj();
	
	if (x) {
		x.onreadystatechange = function()   {
            if(onStateChange == "" || onStateChange == null){
							if (x.readyState == 4 && x.status == 200) {
				      	alert(x.responseText);
				      }
				      if (x.readyState == 4 && x.status != 200) {
				        alert("error getting html data via AJAX");
				      }
            }else{
            	onStateChange(x);
            }
        }
  }
	x.open("POST", uri, true);
  x.setRequestHeader("Content-type", "application/x-www-form-urlencoded; charset=utf-8");
  x.setRequestHeader("Content-length", param.length);
  x.setRequestHeader("Connection", "close");
  x.send(param);
  return false;
}

// params = (uri ,params ,htmlElementId)
function ajaxLoadPageTo(){
    var args = ajaxLoadPageTo.arguments;
    var uri=args[0];
    var param=args[1];
    var htmlElementId=args[2];
    var el = document.getElementById(htmlElementId);

		ajaxSendRequest(uri ,param ,function(x){
            if (x.readyState == 4 && x.status == 200) {
                el.innerHTML = x.responseText;
            }
            if (x.readyState == 4 && x.status != 200) {
                alert("error getting html data via AJAX");
            }
        }
		);
		return false;
}

// params  = (formObj ,onStateChange(XMLHttpRequest))
function ajaxSubmitForm(formObj ,onStateChange){
    var formParams = formToRequestParams(formObj);
    return ajaxSendRequest(formObj.action ,formParams ,onStateChange);
}

// params  = (formObj, htmlElementId)
function ajaxSubmitFormTo(){
    var args = ajaxSubmitFormTo.arguments;
    var formObj = args[0];
    var el = document.getElementById(args[1]);
    ajaxSubmitForm(formObj ,function(x)   {
            if (x.readyState == 4 && x.status == 200) {
                el.innerHTML = x.responseText;
            }
            if (x.readyState == 4 && x.status != 200) {
                alert("ERROR in getting html data via AJAX");
            }
        });
    return false;
}

// params  = (formObj ,processXml(xmldoc))
function ajaxSubmitFormXml(formObj ,processXml){
    ajaxSubmitForm(formObj ,function(x){
            if (x.readyState == 4 && x.status == 200) {
               processXml(x.responseXML);
            }
            if (x.readyState == 4 && x.status != 200) {
                alert("ERROR in getting html data via AJAX");
            }
    });
}

// params  = (uri ,params ,processXml(xmldoc))
function ajaxSendForXml(uri ,params ,processXml){
		ajaxSendRequest(uri ,params ,function(x){
            if (x.readyState == 4 && x.status == 200) {
               processXml(x.responseXML);
            }
            if (x.readyState == 4 && x.status != 200) {
                alert("error getting html data via AJAX");
            }
        }
		);
}


function getValueByXml(path,xml){
    
    try{
        return xml.selectSingleNode(path).text.trim();
    }catch(Exception){
        return "";
    }    
}

function getValueByXmlDefault(path,xml,defautVal){
    try{
        return xml.selectSingleNode(path).text.trim();
    }catch(Exception){
        return defautVal;
    }    
}

function getBimisPkgResult(xmldoc){
	  var result;
	  var xpath;
	  var RESPONSEPATH="/DataPacket/Response";
    try{
	    		xpath=RESPONSEPATH+"/@result";
	        result =  xmldoc.selectSingleNode(xpath).value;
    }catch(Exception){result=null}    
    return result;
}

function getBimisPkgHintMsg(xmldoc,index){
	  var msg;
	  var xpath;
	  var RESPONSEPATH="/DataPacket/Response";
    try{
    			if(index==null)
    				index=1;
	    		xpath=RESPONSEPATH+"/Hint/Msg["+index+"]";
	        msg =  xmldoc.selectSingleNode(xpath).text;
    }catch(Exception){}    
    return msg;
}
function getBimisPkgErrorMsg(xmldoc,index){
	  var msg;
	  var xpath;
	  var RESPONSEPATH="/DataPacket/Response";
    try{
    			if(index==null)
    				index=1;
	    		xpath=RESPONSEPATH+"/Error/Msg["+index+"]";
	        msg =  xmldoc.selectSingleNode(xpath).text;
    }catch(Exception ){}    
    return msg;
}

function getBimisPkgMsgs(xmldoc){
	  var msg="";
		for(var i=1;i<10;i++){
      var msg1 =  getBimisPkgErrorMsg(xmldoc,i);
      if(msg1==null) break;
      msg += "ERROR:" +msg1 + "\n";
  	}
		for(var i=1;i<10;i++){
      var msg1 =  getBimisPkgHintMsg(xmldoc,i);
      if(msg1==null) break;
      msg += "HINT:" +msg1 + "\n";
  	}
    return msg;
}

function getBimisPkgRspVal(xmldoc,fieldname){
	  var msg;
	  var xpath;
	  var xpath="/DataPacket/Response/Data/"+fieldname;
    try{
	        msg =  xmldoc.selectSingleNode(xpath).text;
    }catch(Exception ){}    
    return msg;
}