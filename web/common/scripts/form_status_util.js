var __sel_index;
function _store(){
	__sel_index=this.selectedIndex;	
}
function _apply(){	
	this.selectedIndex=__sel_index;	
}

function saveConditions(form,target,sourceFields){
	
	
	// 功能：把多个字段放入一个字段中保存，并保证特定字符（如：&,?...）不出现混乱。
	// 保存形式："field1=value1&field2=value2&field3=value3"，
	// 实际数据是加密后的数据："dk,g58df8,7sdf,7df87df9,87df"
	// 可用Decoding 解密。
	
	
	var targetObj = form.all(target);
	if(form == null ||form == undefined ||target == null ||target == undefined ||sourceFields == null ||sourceFields == undefined){
		alert("参数不正确");
		return false;
	} 
	if(targetObj ==null || targetObj == undefined) {
		alert("目标字段"+target+"无效或不正确！");
		return false;
	}
	var conditions="";
	for(var i=0;i< sourceFields.length;i++){
		var field = form.all(sourceFields[i]);
		if(field == null || field == undefined) {
			alert("目标字段"+sourceFields[i]+"无效或不正确！");
			return false;
		}		
		if(conditions != "" && conditions != null && conditions != undefined){
			conditions += "&";
			conditions += sourceFields[i];
			conditions += "=";
			conditions += field.value;
		} else {
			conditions += sourceFields[i];
			conditions += "=";
			conditions += field.value;
		}		
			
	}
	//alert(conditions);
	var str = Encoding(conditions);
	if(str!=null){
		targetObj.value = str;
		return true;
	}
	targetObj.value = "";	
	return true;	
}
function Encoding(str){
	if(str==null||str==undefined){		
		return "";
	}
	if( str == ""){
		return "";
	}
	str = escape(str);
	while(str.indexOf("%")!= -1){
		str = str.replace("%",",");
	}
	
	return str;
}
function Decoding(str){
	if(str==null||str==undefined){
		//alert("Decoding input parameter error:"+str);
		return "";
	}
	if( str==""){
		return "";
	}	
	while(str.indexOf(",")!=-1){
		str = str.replace(",","%");
	}
	str = unescape(str);
	return str;
}


function setReadOnly(fields,form_name){
	//fields = new Array("field1_name","field2_name","field3_name");
	//form_name = "document.form[0]"
	form_name=new String(form_name);
	
	try{
		for(i=0;i<fields.length;i++){
			var item=""+form_name+"."+fields[i];
			//alert(item);
			var el= eval(""+item);
			//alert(el)
            		if(el!=null&&el!=undefined){
				if( el.type=="text"||
					el.type=="textarea"||
					el.type=="password"||
					el.type=="checkbox"||
					el.type=="radio"||
					el.type=="select" ){
					el.readOnly=true
	
				}else if( el.type == "button"||
					el.type == "password"||
					el.type == "submit"||
					el.type == "reset"||
					el.type == "image" ){				
					el.disabled=true;				
				}else if( el.type == "select-one"){					
					el.onchange=_apply;
					el.onfocus=_store;
				}				
				
            		}
		}
	}catch(ee){
		alert("ex="+ee);
		return false;
	}
	return true;
}


function setAllReadOnly(form){
	//form=document.forms[0];
	try{
		for(i=0;i<form.elements.length;i++){				
			if( form.elements[i].type=="text"||
				form.elements[i].type=="textarea"||
				form.elements[i].type=="password"||
				form.elements[i].type=="checkbox"||
				form.elements[i].type=="radio"||
				form.elements[i].type=="select" ){
				form.elements[i].readOnly=true

			}else if( form.elements[i].type == "button"||
				form.elements[i].type == "password"||
				form.elements[i].type == "submit"||
				form.elements[i].type == "reset"||
				form.elements[i].type == "image" ){				
				form.elements[i].disabled=true;
			}else if( form.elements[i].type == "select-one"){					
					form.elements[i].onchange=_apply;
					form.elements[i].onfocus=_store;
			}

		}
	}catch(e){
		return false;
	}
	return true;
}

function setCanWrite(fields,form_name){
	//fields = new Array("field1_name","field2_name","field3_name");
	//form_name = "document.form[0]"
	form_name=new String(form_name);
	try{
		for(i=0;i<fields.length;i++){
			var item=""+form_name+"."+fields[i];
			var el= eval(""+item);
            		if(el!=null&&el!=undefined){
				if( el.type=="text"||
					el.type=="textarea"||
					el.type=="password"||
					el.type=="checkbox"||
					el.type=="radio"||
					el.type=="select" ){
					el.readOnly=false
	
				}else if( el.type == "button"||
					el.type == "password"||
					el.type == "submit"||
					el.type == "reset"||
					el.type == "image" ){				
					el.disabled=false;
				}
            		}
		}
	}catch(ee){
		return false;
	}
	return true;
}

function setAllCanWrite(form){
	//form=document.forms[0];
	try{
		for(i=0;i<form.elements.length;i++){				
			if( form.elements[i].type=="text"||
				form.elements[i].type=="textarea"||
				form.elements[i].type=="password"||
				form.elements[i].type=="checkbox"||
				form.elements[i].type=="radio"||
				form.elements[i].type=="select" ){
				form.elements[i].readOnly=false

			}else if( form.elements[i].type == "button"||
				form.elements[i].type == "password"||
				form.elements[i].type == "submit"||
				form.elements[i].type == "reset"||
				form.elements[i].type == "image" ){				
				form.elements[i].disabled=false;
			}

		}
	}catch(e){
		return false;
	}
	return true;
}



function setDisable(fields,form_name){
	//fields = new Array("field1_name","field2_name","field3_name");
	//form_name = "document.form[0]"
	form_name=new String(form_name);
	
	try{
		for(i=0;i<fields.length;i++){
			var item=""+form_name+"."+fields[i];
			var el= eval(""+item);
            		if(el!=null&&""+el!="undefined"){
				if( el.type=="text"||
					el.type=="textarea"||
					el.type=="password"||
					el.type=="checkbox"||
					el.type=="radio"||
					el.type=="select"||
					el.type == "button"||
					el.type == "password"||
					el.type == "submit"||
					el.type == "reset"||
					el.type == "select-one"||
					el.type == "image" ){				
					el.disabled=true;				
				}				
				
            		}
		}
	}catch(ee){
		return false;
	}
	return true;
}
function setEnable(fields,form_name){
	//fields = new Array("field1_name","field2_name","field3_name");
	//form_name = "document.form[0]"
	form_name=new String(form_name);
	try{
		for(i=0;i<fields.length;i++){
			//alert("starting"+fields[i]);
			var item=""+form_name+"."+fields[i];
			//alert(item);
			var el= eval(""+item);
			//alert(el);
            		if(el!=null&&""+el!="undefined"){
				if( el.type=="text"||
					el.type=="textarea"||
					el.type=="password"||
					el.type=="checkbox"||
					el.type=="radio"||
					el.type=="select" ||
					el.type == "select-one"||
					el.type == "button"||
					el.type == "password"||
					el.type == "submit"||
					el.type == "reset"||
					el.type == "image" ){
						//alert("setting "+el.name);				
					el.disabled=false;
				}
            		}
		}
	}catch(ee){
		alert("ex="+ee);
		return false;
	}
	return true;
}

function setAllEnable(form){
	//form=document.forms[0];
	try{
		for(i=0;i<form.elements.length;i++){				
			if( form.elements[i].type=="text"||
				form.elements[i].type=="textarea"||
				form.elements[i].type=="password"||
				form.elements[i].type=="checkbox"||
				form.elements[i].type=="radio"||
				form.elements[i].type=="select" ||
				form.elements[i].type == "button"||
				form.elements[i].type == "password"||
				form.elements[i].type == "submit"||
				form.elements[i].type == "reset"||
				form.elements[i].type == "select-one"||
				form.elements[i].type == "image" ){				
				form.elements[i].disabled=false;
			}

		}
	}catch(e){
		return false;
	}
	return true;
}

function setAllDisable(form){
	//form=document.forms[0];
	try{
		for(i=0;i<form.elements.length;i++){				
			if( form.elements[i].type=="text"||
				form.elements[i].type=="textarea"||
				form.elements[i].type=="password"||
				form.elements[i].type=="checkbox"||
				form.elements[i].type=="radio"||
				form.elements[i].type=="select"||
				form.elements[i].type == "button"||
				form.elements[i].type == "password"||
				form.elements[i].type == "submit"||
				form.elements[i].type == "reset"||
				form.elements[i].type == "select-one"||
				form.elements[i].type == "image" ){				
				form.elements[i].disabled=true;
			}

		}
	}catch(e){
		return false;
	}
	return true;
}


