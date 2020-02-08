function get(dom,path){
//只取单值
	var el=dom.selectSingleNode(path);
	return el.text;
}

function doPost(param){
	//param:"&oprID=wzfkdmodel&actions=List&fkdxh=8002";// start with "&";

	var dom;
	var http;
	var url="/httpprocesserservlet?forward=/public/validator.jsp"+param;
	//var url=param;

	try{
		http = new ActiveXObject("MSXML2.XMLHTTP.3.0");
        http.open("POST",url,false);
		//http.open("GET",url,false);
        http.send();
		dom= new ActiveXObject("msxml2.DOMDocument.3.0");
		dom.async = "false";
		var tx=new String(http.responseText);
		//alert("http.responseText="+tx);
		dom.loadXML(tx.replace(/(^\s*)|(\s*$)/g, ""));
		var err=dom.parseError;
		if (err.errorCode == 0) {
			return dom;
		}
		if (false){
			alert("You have error reason:" + err.reason
					+"\n src="+err.srcText
					+"\nline="+err.line
					+"\nposition="+err.linepos
					);
		}

            return null;
	    }
	    catch (e){
			alert (e.description) ;
			return null;
	    }
}

	function populateMaster(dom,fieldsTo,fieldsFrom){
		var form=document.forms[0];
		var path;
		var val;
		var name;
		for(var i=0;i< fieldsTo.length;i++){
			path="/DataPacket/Response/Data/Record[0]/"+fieldsFrom[i];
			try{
				val= dom.selectSingleNode(path).text;
				var element=eval("document.forms[0]."+fieldsTo[i]);
				//alert("populateMaster SUCCESS "+i+" :fieldTo="+fieldsTo[i]+";fieldFrom="+fieldsFrom[i]+";value="+val+";element.name="+element.name)
				if(element!=null&&element!=undefined){
					element.value=val;
				}
			} catch(e0){
				alert("字段："+fieldsTo[i]+"有误。请与程序员联系。错误描述：m:"+"fieldFrom["+i+"]="+fieldsFrom[i]+";fieldsTo["+i+"]="+fieldsTo[i]+";"+e0.description);
				continue;
			}
		}
	}


	function populateDetail(dom,fieldsTo,fieldsFrom){
		var path="/DataPacket/Response/Data/Data/Record";
		var val;
		var name;
		var oNodes = dom.selectNodes(path);
    		for (var i=0; i<oNodes.length; i++)
    		{
			var n=0;
			var cell=new Array();
			for(var n=0;n < fieldsFrom.length;n++){
				try{
					path="/DataPacket/Response/Data/Data/Record["+i+"]/"+fieldsFrom[n];
					//alert("path="+path);
					val= dom.selectSingleNode(path).text;
					//alert("val="+val+"\nn="+n);
					if(val!=null) {
						cell[n]=val;
					}else{
						cell[n]="";
					}
                		} catch (e1){
					alert("字段："+fieldsTo[i]+"有误。请与程序员联系。错误描述：d:"+"fieldFrom["+i+"]="+fieldsFrom[i]+";fieldsTo["+i+"]="+fieldsTo[i]+";value="+val+";"+e1.description);
					continue;
				}
			}
			createTR(cell);//页面上必须实现此方法
    		}
	}


function validate_exist(field,params){
	//-返回查找到的数据记录数量。
	//field=input element :<input name="xxx" onchange="validate_exist(this,params)"/>
 	//params="&oprID=XXX&actions=List&id=0005&name=jyhao";其中oprID,actions是必须的
	var parameter;
try{
	if (field==null){
		parameter = params;
	}
	else{
		var name=field.name;
		var value=field.value;
		parameter = "&"+name+"="+value+params;
	}
	//alert("url="+url);
	var dom=doPost(parameter);
	//alert("2-dom.xml="+dom.xml);
	var path="/DataPacket/Response/Data/PageInfo/RecordCount"
	var val= dom.selectSingleNode(path).text;
	//alert("查到"+val+"条记录。");
	return parseInt(val,0)
	}catch(e){
		return 0;
	}
}



function getValuesFrom(action,fieldsTo,fieldsFrom){


	//   var fieldsTo=new Array("entid","entname");  
	//   var fieldsFrom=new Array("entid","entname");
	//   var action = "&oprID=kymodel&actions=ent_List&entcod="+value+"&sbent=A";

	  //try{		
		var dom;
		var path;
		var val;
		try{
			dom=doPost(action);						
			path="/DataPacket/Response/Data/PageInfo/RecordCount";			
			val= dom.selectSingleNode(path).text;
		}catch(e){
			alert("此号码不存在。请重新输入。");			
			resetField(fieldsTo);			
			return false;
		}
		if(parseInt(val)>0){			
			populateMaster(dom,fieldsTo,fieldsFrom);
			
			return true;
    		}else{
			alert("此号码不存在。请重新输入。");
			
			resetField(fieldsTo);
			return false;
		}

	  //} catch(e){
	//	alert(e.description);
	//	return false;
	 // }
	}
	
	
	function resetField(fieldsTo){
		for(var i=0;i< fieldsTo.length;i++){			
			try{				
				var element=eval("document.forms[0]."+fieldsTo[i]);				
				if(element!=null&&element!=undefined){
					element.value="";
				}
			} catch(e0){
				alert("字段："+fieldsTo[i]+"有误。请与程序员联系。错误描述：m:fieldsTo["+i+"]="+fieldsTo[i]+";"+e0.description);
				continue;
			}
		}
	}
