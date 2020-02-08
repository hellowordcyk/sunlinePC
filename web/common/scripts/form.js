//组织提交的URL
function buildUrl(submitForm)
{
    var urlString = submitForm.action;
    var data = "";
    for (i=0;i<submitForm.elements.length;i++)
    {
        if (checkExistType(submitForm.elements[i].type))
        {
            var elementValue = buildElement(submitForm.elements[i]);
            if (elementValue.length>0)
            {
                data = data + "&" + elementValue;
            }
        }
    }
    data = data.substring(1,data.length);
    if ((urlString ==null)||(urlString ==""))
    {
        urlString = "/platform/HttpProcesser.jsp";
    }
    urlString = urlString + "?" + data;
    return urlString;
}
//装载磁盘文件
function load(urlString)
{
    var xmldoc;
    try {
        xmldoc = new ActiveXObject("Microsoft.XMLDOM");
        if(!xmldoc) xmldoc = new ActiveXObject("MSXML2.DOMDocument.3.0");
    } catch(e){}
    if(!xmldoc) {
        return null;
    } else {
        xmldoc.async = "false";
        xmldoc.load(urlString);
        if(xmldoc.parseError.errorCode == 0 ) {
            return xmldoc;
        } else {
            return null;
        }
    }
}
//装载字符流
function loadXML(xmlString)
{
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
//获得交易结果
function getResult(form)
{
    var url = buildUrl(form);
    var xmlhttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
    xmlhttp.open("POST", url, false)
    xmlhttp.send();
    var xmlDoc = new ActiveXObject("Msxml2.DOMDocument.3.0");
    xmlDoc = loadXML(bytes2BSTR(xmlhttp.responseBody));
    return xmlDoc;
}
//检查元素的类型，返回true表示此元素需要取数据，返回false表示不用取数据
function checkExistType(typeValue)
{
    if (typeValue == "text")
    {
        return true;
    }
    if (typeValue == "password")
    {
        return true;
    }
    if (typeValue == "textarea")
    {
        return true;
    }
    if (typeValue == "hidden")
    {
        return true;
    }
    if (typeValue == "file")
    {
        return true;
    }
    if (typeValue == "select-one")
    {
        return true;
    }
    if (typeValue == "select-multiple")
    {
        return true;
    }
    if (typeValue == "radio")
    {
        return true;
    }
    if (typeValue == "checkbox")
    {
        return true;
    }
    return false;
}
//根据元素的类型组织相应的url，如 username=xxx
function buildElement(element)
{
    var result = "";
    //文本框,多文本框,隐藏数据
    if ((element.type=="text")||(element.type=="textarea")||(element.type=="hidden")||(element.type=="file")||(element.type=="password"))
    {
        result = element.name+"="+element.value;
    }
    //单选下拉框,多选下拉框
    if ((element.type=="select-one")||(element.type=="select-multiple"))
    {
        for (j=0;j<element.length;j++)
        {
            if (element.options[j].selected)
            {
                result = result + "&" + element.name + "=" + element.options[j].value;
            }
        }
        result = result.substring(1,result.length);
    }
    //单选框,多选框
    if ((element.type=="radio")||(element.type=="checkbox"))
    {
        if (element.checked)
        {
            result = element.name + "=" + element.value;
        }
    }
    return result;
}
//获得检测结果

function getURLResult(URL)
{
    var url = URL;
    var xmlhttp = new ActiveXObject("Msxml2.XMLHTTP.3.0");
    xmlhttp.open("POST", url, false);
    xmlhttp.send();
    var xmlDoc = new ActiveXObject("Msxml2.DOMDocument.3.0");
    	
    //xmlDoc = loadXML(bytes2BSTR(xmlhttp.responseBody));//2008-08-02 modify 去掉vbscript的调用
    var tx=new String(xmlhttp.responseText);
    xmlDoc =loadXML(tx.replace(/(^\s*)|(\s*$)/g, ""));
    
    var NodeLists = xmlDoc.selectNodes("/root/checkresult");
    var result = new Array();
	
   for(var i=0;i<NodeLists.length;i++){
    	result[i] = NodeLists[i].text;
    }
    return result;
}

