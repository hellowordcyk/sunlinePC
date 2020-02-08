function _createObj() {
	if (window.XMLHttpRequest) {
		var objXMLHttp = new XMLHttpRequest();
	}
	else {
		var MSXML = ['Msxml2.XMLHTTP','MSXML2.XMLHTTP.5.0', 'MSXML2.XMLHTTP.4.0', 'MSXML2.XMLHTTP.3.0', 'MSXML2.XMLHTTP', 'Microsoft.XMLHTTP'];
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
// params = (url, htmlElementId)
function com_jenkov_prizetags_ajaxLoadPage(){
    var args = com_jenkov_prizetags_ajaxLoadPage.arguments;
    var el = document.getElementById(args[1]);
    if(el){
    	el.innerHTML="";
    }
    if (document.getElementById) {
        var x = this._createObj();
    }
    if (x) {
        x.onreadystatechange = function()   {
            if (x.readyState == 4 && x.status == 200) {
                el.innerHTML = x.responseText;
            }
            if (x.readyState == 4 && x.status != 200) {
                alert("error getting xml data via AJAX");
            }
        }
    }
    x.open("post", args[0], true);
    x.send();
}


// params  = (url, htmlElementId, formElementId)
function com_jenkov_prizetags_ajaxSubmitForm(){
    var args = com_jenkov_prizetags_ajaxSubmitForm.arguments;
    if (document.getElementById) {
        var x = (window.ActiveXObject) ? new ActiveXObject("Microsoft.XMLHTTP") : new XMLHttpRequest();
    }
    if (x) {
        x.onreadystatechange = function()   {
            if (x.readyState == 4 && x.status == 200) {
                el = document.getElementById(args[1]);
                el.innerHTML = x.responseText;
            }
            if (x.readyState == 4 && x.status != 200) {
                alert("error getting xml data via AJAX");
            }
        }
    }

    formObj = args[0];
    formParams = "";
    for(i=0; i<formObj.elements.length; i++){
        if(i > 0){
            formParams = formParams + "&"
        }

        if(formObj.elements[i].type == 'submit' ||
           formObj.elements[i].type == 'button' ||
           formObj.elements[i].type == 'image'){
//                var str="";
//                for(prop in formObj.elements[i] ){
//                    str += prop + " : " + formObj.elements[i][prop]+"          ";
//                }
//                alert(str);
            if(formObj.elements[i].clicked && formObj.elements[i].clicked){
                formParams = formParams + formObj.elements[i].name;
                formParams = formParams + "=";
                formParams = formParams + formObj.elements[i].value;
            }
        } else{
            formParams = formParams + formObj.elements[i].name;
            formParams = formParams + "=";
            formParams = formParams + formObj.elements[i].value;
        }
    }

    x.open("POST", formObj.action, true);
    x.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    x.setRequestHeader("Content-length", formParams.length);
    x.setRequestHeader("Connection", "close");
    x.send(encodeURI    (formParams));

    return false;
}

function com_jenkov_prizetags_ajaxButtonClicked(button){
    formObj = button.form;

    for(i=0; i<formObj.elements.length; i++){
        if(formObj.elements[i].type == 'submit' ||
           formObj.elements[i].type == 'button' ||
           formObj.elements[i].type == 'image'){
            formObj.elements[i].clicked=false;
        }
    }

    button.clicked = true;
}


function com_jenkov_prizetags_ajaxReloadPage(url, element, time){
    aDate = new Date();
    aDateString =  aDate.getYear() + "_" + aDate.getMonth() + "_" + aDate.getDate() + "_";
    aDateString += aDate.getHours() + "_" + aDate.getMinutes() + "_" + aDate.getSeconds();
    forceRefreshParameter  = "com_jenkov_prizetags_ajax_refresh=" + Math.random() * 1000000;
    forceRefreshParameter += "&com_jenkov_prizetags_ajax_time=" + aDateString;

    com_jenkov_prizetags_ajaxLoadPage(url, element);
    setTimeout("com_jenkov_prizetags_ajaxReloadPage('" + url + "', '" + element + "', " + time + ")", time);
}
