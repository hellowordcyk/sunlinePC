//ajax util base on prototype.js
//your page must include this:
//<Script language="JavaScript" src="/js/prototype.js"/>

var Jraf = {Version: '1.0'};

Jraf.getBrowserVersion = function () {
    var app = navigator.appName.toUpperCase();
    var ver = navigator.appVersion;

    if (app == "MICROSOFT INTERNET EXPLORER"){
        index = ver.indexOf("MSIE",0) + 4;
        ver = ver.substring(index,index + 4);
        //document.write("你使用的浏览器为Internet Explorer" + ver);
    }
    if (app == "NETSCAPE"){
        ver = ver.substring(ver,4); 
        //document.write("你使用的浏览器为Netscape" + ver);
    }
    return ver;
};

//文档加载后执行
document.observe("dom:loaded", function (){
    Jraf.ForbidBackspace();     //除了可输入文本框外，页面禁止使用Backspace键
});

//Bug fix for 1.6.0.2 to 1.6.0.3
/*document.viewport.getDimensions = function() {
    var dimensions = { }, B = Prototype.Browser;
    $w('width height').each(function(d) {
      var D = d.capitalize();
      if (B.WebKit && !document.evaluate) {
        // Safari <3.0 needs self.innerWidth/Height
        dimensions[d] = self['inner' + D];
      } else if ( B.IE || (B.Opera && parseFloat(window.opera.version()) < 9.5)) {
        // Opera <9.5 needs document.body.clientWidth/Height
        dimensions[d] = document.body['client' + D];
      } else {
        dimensions[d] = document.documentElement['client' + D];
      }
    });
    return dimensions;
};*/

/**
 * String类方法扩展
 */
Object.extend(String.prototype,{
    realLength:    function() { 
        return this.replace(/[^\x00-\xff]/g,"**").length; 
    },
    trim: function() {
        return this.replace(/(^\s*)|(\s*$)/g,'');
    },
    replaceHTML: function (){
        var result = this;
        result = result.replace(/&/g,"&amp;");
        result = result.replace(/</g,"&lt;");
        result = result.replace(/>/g,"&gt;");
        result = result.replace(/\s/g,"&nbsp;");
        if(result == "")
            result = "";//"&nbsp;";
        return result;
    },
    endWith: function(str){
    	if(str==null||str==""||this.length==0||str.length>this.length)
    		return false;
		if(this.substring(this.length-str.length)==str)
    		return true;
		else
    		return false;
		return true;
	}
});

Jraf.BlockAttribute = {
    createParams: function (obj) {
        if (obj == null) 
            return "";
        var sysParams = {};
        //构造系统参数
        var jraf_sysName = obj.readAttribute("jraf_sysName");
        if (jraf_sysName != null) {
            sysParams["sysName"] = jraf_sysName;
        }
        var jraf_oprID = obj.readAttribute("jraf_oprID");
        if (jraf_oprID != null) {
            sysParams["oprID"] = jraf_oprID;
        }
        var jraf_actions = obj.readAttribute("jraf_actions");
        if (jraf_actions != null) {
            sysParams["actions"] = jraf_actions;
        }
        sysParams = $H(sysParams).toQueryString();
        
        var params = obj.readAttribute("jraf_params") || "";
        params = this.getParams(params);//this.getParams(params);
    
        if (params.trim() == "" || params.charAt(params.length - 1) == "&") {
            params = params + sysParams;
        } else {
            params = params + "&" + sysParams;
        }
        return params;
    },
    /**
     * 解析jraf_params值：可以是传函数，也可以传一个模板
     * 
     * 模板如： 
     *     test=#{id1 }&test=#{id2}&...
     *     ----------------------------
     *     以上的id1，id2,...,idn，为表单元素的id属性值或name属性值；
     *     系统会自动转换成表单元素对应的value值。
     *     如有多个name值一样的元素，则取所有的值，值用逗号“,”分隔（此种情况，主要是取复选框的值）
     */
    getParams: function (template, scope) {
        if (template == null || template == "")
            return "";
        //调用过程
        if (/\(\w*\)\s*[;]?\s*$/g.test(template)) {
            var obj = eval(template);
            if (obj == null) {
                return "";
            }
            
            if (Object.isString(obj)) {
                return obj;//类型a=1&b=2&c=3
            } 
            //{a: '1', b: '2', c: '3'}对象转换成a=1&b=2&c=3
            return Object.toQueryString(obj);
        }
        
        //对象
        if (!Object.isString(template) && Object.isHash($H(template))) {
            return Object.toQueryString(template);
        }
        
        var undefinedVal = "undefined";
        //按照模板解析参数值
        var str = "";
        str = template.gsub(/#{([^#{}]+)}/, function (match) {
            try {
                var idStr = match[1].trim();
                var formObj = null;
                if ($(scope)) {
                    formObj = $(scope).$(idStr) || $A($(scope).getElementsByName(idStr));
                    alert("[getParams]scope: "+scope +", obj:"+ formObj);
                } else {
                    formObj = $(idStr) || $A(document.getElementsByName(idStr));
                }
                if (formObj == null) 
                    return undefinedVal;
                
                if (!(Object.isArray(formObj))) {
                    //select多选项值，以逗号分隔
                    if (formObj.tagName.toLowerCase() == "select" 
                            && formObj.multiple === true) {
                        var options = formObj.options;
                        var combine = "";
                        $A(options).each(function (obj) {
                            if (obj.selected === true) {
                                combine += obj.value + ",";
                            }
                        });
                        if (combine != "" && combine.charAt(combine.length - 1) == ",") {
                            combine = combine.substring(0, combine.length - 1);
                        }
                        return combine;
                    }
                    return formObj.value;
                } else { //含多个name值一样的表样元素
                    if ((formObj[0].type.toLowerCase() !== "radio"
                            && formObj[0].type.toLowerCase() !== "checkbox")) {
                        return formObj[0].value;
                    }
                    //单选框和复选框，取checked=true的value值，如有多个值用逗号“,”分隔
                    var combine = "";
                    $A(formObj).each(function (obj) {
                        if (obj.checked === true) {
                            combine += obj.value + ",";
                            if (obj.type.toLowerCase() === "radio") 
                                throw $break;
                        }
                    });
                    if (combine != "" && combine.charAt(combine.length - 1) == ",") {
                        combine = combine.substring(0, combine.length - 1);
                    }
                    return combine;
                } 
            } catch(e) {
                alert("[Jraf.BlockAttribute][method=getParams]"+e.message);
            }
            return undefinedVal;
        });
        return str;
    }, 
    loading: function (obj){
        try {
            $(obj).update("<span class='loading'>加载中...</span>");
        } catch(e) {}
    }
};
/**
 * 操作表单的常用方法
 * @author yangx
 * @createdate 2013-08-07
 */
Jraf.FormUtil = {
    /**
     * 禁用指标范围的所有表单控件，不指定scope则禁用全部
     * 注意： 禁用时，会添加标识；下次启用时，只启用标识过的
     * @param scope         类型String   指定要禁用的范围（容器block id）
     * @param excludeValues 类型Array    排除的表单元素名称数组
     */
    disabledFormElement: function (scope, excludeValues) {
        this.__changeFormElementState(excludeValues, scope, true);
    },
    /**
     * 启用指标范围的所有表单控件，不指定scope则启用全部
     * 注意： 启用时，只启用被disabledFormElement方法标识过的
     * @param scope         类型String   指定要禁用的范围（容器block id）
     * @param excludeValues 类型Array    排除的表单元素名称数组
     */
    enabledFormElement: function (scope, excludeValues) {
        this.__changeFormElementState(excludeValues, scope, false);
    },
    /**
     * 开启所有的禁用表单控件
     * @param scope         类型String   指定要禁用的范围（容器block id）
     * @param excludeValues 类型Array    排除的表单元素名称数组
     */
    enabledFormElementAll: function (scope, excludeValues) {
        this.__changeFormElementState(excludeValues, scope, false, true);
    },
    /**
     * 禁用表单元素控件
     * @param excludeValues 类型Array    排除的表单元素名称数组
     * @param scope         类型String   指定要禁用的范围（容器block id）
     * @param status        类型boolean  控制控件的状态(true禁用|false解禁)
     * @param flag          类型boolean  是否全部启用(不)
     * @author yangx
     * @createdata 2013-08-07
     */
    __changeFormElementState: function (excludeValues, scope, status, flag) {
        var message = "[Jraf.FormUtil][method=__changeFormElementState]";
        if(status == null){
            alert(message + "参数status不能不空。");
            return;
        }
        if (excludeValues == null || !Object.isArray(excludeValues)) {
            excludeValues = [];
        }
        var elements = [];
        var inputs = [];
        var selects = [];
        var areaTexts = [];
        var oScope = $(scope);
        if (oScope != null) {
            inputs = oScope.select("input");
            selects = oScope.select("select");
            areaTexts = oScope.select("textarea");
        }else{
            inputs = $$("input");
            selects = $$("select");
            areaTexts = $$("textarea");
        }
        /*
         * Form表单中主要有三类标记语言定义的控件： input、select、textarea
         */
        elements = elements.concat(inputs, selects, areaTexts);
        
        var flagValue = "";
        var disableFlagName = "__JrafForm_disabed_status_";
        try {
            outer1:for (var i = 0, len = elements.length; i < len; i ++) {
                tempInput = elements[i];
                if (excludeValues.length > 0){
                    for (var j = 0; j < excludeValues.length; j ++){
                        if (excludeValues[j] == tempInput.name){
                            continue outer1;//不禁用，继续循环
                        }
                    }
                }
                
                if (status === true) {
                    if (tempInput.disabled) 
                        continue;
                    tempInput.disabled = true;
                    Element.writeAttribute(tempInput, disableFlagName, "true");
                } else {
                    flagValue = Element.readAttribute(tempInput, disableFlagName);
                    if (flag === true) {//全部启用
                        tempInput.disabled = false;
                    } else {//仅启用有标识的
                        if (!tempInput.disabled)
                            continue;
                        if (flagValue != null) {
                            tempInput.disabled = false;
                        }
                    }
                    if (flagValue != null) {
                        tempInput.removeAttribute(disableFlagName);
                    }
                }
            }
        } catch (e) {
            alert(message + "jsError: " + e.message);
        }
    },
    /**
     * 全选或全取消复选框
     * @param toggleObj 触发全选或全取消的复选框对象
     * @inputName       复选框表单名称
     */
    toggleCheckBoxAll: function (toggleObj, inputName) {
        var message = "[Jraf.FormUtil][method=toggleCheckBoxAll]";
        toggleObj = $(toggleObj);
        if(toggleObj == null 
                || (toggleObj.type != null
                        && toggleObj.type.toLowerCase() != "checkbox")){
            alert(message + "参数toggleObj不能不空且必须是CheckBox对象。");
            return;
        }
        try {
            scope = $(toggleObj.form);
            var oCheckBoxs = null;
            if (scope) {
                if (inputName != null) {
                    oCheckBoxs = scope.select("input[name='"+inputName+"']");
                } else {
                    oCheckBoxs = scope.select("input[type='checkbox']");
                }
            } else {
                if (inputName != null) {
                    oCheckBoxs = $$("input[name='"+inputName+"']");
                } else {
                    oCheckBoxs = $$("input[type='checkbox']");
                }
            }
            if (oCheckBoxs != null && oCheckBoxs.length > 0) {
                var oCheckBox = null;
                for (var i = 0, len = oCheckBoxs.length; i < len; i ++) {
                    oCheckBox = oCheckBoxs[i];
                    if (oCheckBox.checked != toggleObj.checked) {
                        oCheckBox.click();
                    }
                }
            }
        } catch(e){
            alert(message + "jsError: " + e.message);
        }
    },
    /**
     * 保存成功数据后，保存表单值到各自对象上
     * @param oBlock 范围区域id或对象，只检查其中的表单元素是否修改
     */
    addInputValue: function (oBlock){
        if($(oBlock) == null ) {
            alert("[Jraf.FormUtil][method=addInputValue]ERROR: 传入的不是有效参数！");
            return;
        }
        var inputs = [];
        if ($(oBlock).tagName.toLowerCase()=="form") {
        	try {
        		inputs = $A($(oBlock).elements);
        	} catch (e) {
        		inputs = $(oBlock).select("input", "select", "textarea");
        	}
        } else {
            inputs = $(oBlock).select("input", "select", "textarea");
        }
        $A(inputs).each(function (obj){
            //排除隐藏表单控件
            if (obj.type.toLowerCase() == "hidden"
                || obj.type.toLowerCase() == "image" 
                    || obj.type.toLowerCase() == "button") 
                return;
            if(obj.type.toLowerCase() != "checkbox" 
                && obj.type.toLowerCase() != "radio" ){
                obj.setAttribute("__JrafForm_oldInputValue", obj.value); 
            }else{
                obj.setAttribute("__JrafForm_oldInputValue", obj.checked);
            }
        });
    },
    /**
     * 判断表单数据是否变动与addInputValue方法结合使用
     * @param oBlock 范围区域id或对象，只检查其中的表单元素是否修改
     * @return true 变动； false 未变动
     * @remark 
     */
    isInputChange:function (oBlock){
        if($(oBlock) == null ) {
            alert("[Jraf.FormUtil][method=isInputChange]ERROR: 传入的不是有效参数！");
            return;
        }
        var flag = false;
        var inputs = [];
        if ($(oBlock).tagName.toLowerCase()=="form") {
            inputs = $A(oBlock.elements);
        } else {
            inputs = $(oBlock).select("input", "select", "textarea");
        }
        var tmpValue = null;
        var tmpObjValue = null;
        $A(inputs).each(function (obj){
            if(obj.getAttribute("__JrafForm_oldInputValue") == null) 
                return;
            /*if (obj.type.toLowerCase() == "hidden"
                || obj.type.toLowerCase() == "image" 
                    || obj.type.toLowerCase() == "button")
                return;*/
            
            if(obj.type.toLowerCase() != "checkbox" 
                && obj.type.toLowerCase() != "radio" ){
                tmpValue = ""+obj.getAttribute("__JrafForm_oldInputValue");
                tmpObjValue = ""+obj.value;
                //对sc:money标签值的特殊处理
                if (""+obj.getAttribute("customtype") == "money") {
                    tmpValue = tmpValue.replace(/,/g, "");
                    tmpObjValue = tmpObjValue.replace(/,/g, "");
                }
                if((tmpValue) !== (tmpObjValue)){
                    flag = true;
                    throw $break;
                }
            }else{
                if( ( ""+obj.getAttribute("__JrafForm_oldInputValue") ) !== (""+obj.checked)){
                    flag = true;
                    throw $break;
                }
            }
            
        });
        return flag;
    },
    /**
     * 判断单个表单控件数据是否变动（与addInputValue方法结合使用）
     * @param inputObj 表单元素对象
     * @return true 变动； false 未变动
     */
    isOneInputChange: function (inputObj){
        if(inputObj == null ) {
            alert("[Jraf.FormUtil][method=isValueChange]ERROR: 参数不能为空！");
            return;
        }
        var flag = false;
        if(inputObj.getAttribute("__JrafForm_oldInputValue") == null) 
            return;
        var tmpValue = null;
        var tmpObjValue = null;
        if(inputObj.type.toLowerCase() != "checkbox" 
            && inputObj.type.toLowerCase() != "radio" ){
            tmpValue = ""+inputObj.getAttribute("__JrafForm_oldInputValue");
            tmpObjValue = ""+inputObj.value;
            //对sc:money标签值的特殊处理
            if (""+inputObj.getAttribute("customtype") == "money") {
                tmpValue = tmpValue.replace(/,/g, "");
                tmpObjValue = tmpObjValue.replace(/,/g, "");
            }
            if((tmpValue) !== (tmpObjValue)){
                flag = true;
            }
        }else{
            if( ( ""+inputObj.getAttribute("__JrafForm_oldInputValue") ) !== (""+inputObj.checked)){
                flag = true;
            }
        }
        return flag;
    }
};

/**
 * 修改记录：
 * MOD{yangx on 2013-04-02}:
 *     loadPageTo方法增加回调函数，用于页面加载后执行
 */
Jraf.Ajax = Class.create({
    initialize: function(options) {
    this.options = {
            method:    'POST',
            encoding: 'utf-8'
        };
     Object.extend(this.options, options || { });
  },
  request: function(url, postBody , callbackOnComplete) {
        var newoptions =  Object.clone(this.options);
        if(!postBody){
            postBody='';
        }
        if(!Object.isString(postBody)){
            postBody = Object.toQueryString(postBody);
        }
        if(newoptions.parameters){
            postBody += postBody.length>0?'&':'' + Object.toQueryString(newoptions.parameters);
        }
        Object.extend(newoptions, {postBody:      postBody});
        if (Object.isFunction(callbackOnComplete)){
            Object.extend(newoptions, {onComplete: callbackOnComplete});
        }
        return new Ajax.Request(url, newoptions);
  },
  loadPageTo: function(url ,postBody ,htmlElementId, callbackOnComplete){
      var el = $(htmlElementId);
      return this.request(url ,postBody ,function(x){
              el.innerHTML = "";//浏览器问题
              el.innerHTML = x.responseText; 
              if (typeof callbackOnComplete == "function")
                  callbackOnComplete();
          });
  },
  submitForm: function(formObj ,callbackOnComplete){
        var newoptions =  Object.clone(this.options);
        if (Object.isFunction(callbackOnComplete)){
            Object.extend(newoptions, {onComplete: callbackOnComplete});
        }
        return Form.request(formObj ,newoptions);
  },
  submitFormTo: function(formObj, htmlElementId){
        var el = $(htmlElementId);
        return this.submitForm(formObj ,function(x)   {
                el.innerHTML = x.responseText;
            });
  },
  submitFormXml: function(formObj ,processXml){
      if(Object.isFunction(processXml))
        return this.submitForm(formObj ,function(x){
                        processXml(x.responseXML);
        });
      else{
        return this.submitForm(formObj);
      }
    },
    submitDiv: function(uri,htmlElementId , callbackonComplete, params){
        if (typeof params != 'object') params = {};
        if($(htmlElementId))
            this.parambody = Form.serializeElements(Form.getElements($(htmlElementId)),false);
        if(this.params = Object.toQueryString(params))
            this.parambody = this.params + (this.parambody == undefined?'':('&' + this.parambody));
        if(this.parambody == undefined)
            this.parambody = '';
        return this.request(uri, this.parambody ,callbackonComplete);
    },
    submitDivTo: function(uri,htmlElementId ,toId, params){    
        return this.submitDiv(uri ,htmlElementId ,function(x){
            $(toId).innerHTML = x.responseText;
        } ,params
        );
    },
    submitDivXml: function(uri,htmlElementId ,processXml, params){
        if(Object.isFunction(processXml))
            return this.submitDiv(uri ,htmlElementId ,function(x){
                processXml(x.responseXML);
            } ,params
            );
      else{
            return this.submitDiv(uri ,htmlElementId ,null ,params);
      }
    },
    sendForXml: function(uri ,postBody ,processXml){
        if(Object.isFunction(processXml))
            return this.request(uri ,postBody ,function(x){
                processXml(x.responseXML);
            }
            );
        else{
            return this.request(uri ,params);
        }
    }
}
);

/**
 * 对Jraf.Ajax进行修改或进一步封装：
 *     1.方法参数，采用JSON格式传入
 *     2.提供默认的消息提示
 * @author: Sean
 * @createdate 2015-03-05 15:17
 */
Jraf.NewAjax = Class.create({
    initialize: function(options) {
        this.options = {
            method:    'POST',
            encoding: 'utf-8'
        };
        Object.extend(this.options, options || { });
    },
    request: function(url, postBody , callbackOnComplete) {
        var newoptions =  Object.clone(this.options);
        if(!postBody){
            postBody='';
        }
        if(!Object.isString(postBody)){
            postBody = Object.toQueryString(postBody);
        }
        if(newoptions.parameters){
            postBody += postBody.length>0?'&':'' + Object.toQueryString(newoptions.parameters);
        }
        Object.extend(newoptions, {postBody:      postBody});
        if (Object.isFunction(callbackOnComplete)){
            Object.extend(newoptions, {onComplete: callbackOnComplete});
        }
        return new Ajax.Request(url, newoptions);
    },
    /**
     * {
     *  "atrribute": "atrribute value",
     *  ......
     * }
     */
    __isNull: function (argArr, checkedArgs ,errormsg) {
        if (checkedArgs === null) {
            alert(errormsg + "系统错误：未传入任何必要参数！");
            return true;
        }
        $A(argArr).each(function (key) {
            if (checkedArgs[key] === null ) {
                alert(errormsg + "系统错误：未传入必要参数"+key+"!");
                throw $break;
            } 
            
            if (key === "form" && !document.forms(checkedArgs[key])) {
                alert(errormsg + "系统错误：必要参数"+key+"=" + checkedArgs[key] + "，找不到对象!");
                throw $break;
            }
            
            if (!$(checkedArgs[key])) {
                alert(errormsg + "系统错误：必要参数"+key+"=" + checkedArgs[key] + "，找不到对象!");
                throw $break;
            }
        });
    },
    __getFormObj: function (form) {
        var formObj = form;
        if (Object.isString(form)) {
            formObj = document.forms(form);
            if (Object.isArray(formObj)) {
                formObj = formObj[0];//如有重名form,取第一个form
            }
        } 
        return formObj;
    },
    __callBackXmlSimple: function(x, error, success, afterSuccess) {
        var pkg = new Jraf.Pkg(x.responseXML);
        var result = pkg.result();
        if (result != '0') {
            Jraf.showMessageBox({
                text: error + pkg.allMsgs(),
                type: "error"
            });
            return;
        }
        Jraf.showMessageBox({
            text: success,
            type: "success",
            onClose: afterSuccess
        });
    },
    __callBackXmlNormal: function (x, callback) {
        var pkgObj = new Jraf.Pkg(x.responseXML);
        var errorNo = -1;
        try{
            errorNo =  parseInt(pkgObj.result(), 10);
        } catch(e) {
            errorNo = -1;
        }
        //默认系统异常提示：errrono范围 （-10000， 0），自定义错误可以用-10000以后的
        if (errorNo < 0 && errorNo > -10000) {//系统异常
            Jraf.showMessageBox({
                text : '系统异常['+errorNo+']：' + pkgObj.allMsgs("<br/>"),
                type : "error"
            });
            return;
        } 
        var rspDatas = pkgObj.rspDatas();
        var recordArray = rspDatas["Record"];
        if (!recordArray)
            recordArray = [];
        if (!Object.isArray(recordArray))
            recordArray = [ recordArray ];

        callback(pkgObj, recordArray, errorNo);
    },
    /**
     * {
     *  "url": ,
     *  "options"：查询参数，
     *  "toElement": 加载到的元素对象或ID,
     *  "callback": 加载完成后的回调函数
     * }
     */
    loadPageTo: function(args){
        return this.request(args.url ,args.options ,function(x){
            var el = $(args.toElement);
            el.innerHTML = "";//浏览器问题
            el.innerHTML = x.responseText; 
            if (typeof args.callback == "function")
                args.callback();
        });
    },
    /**
     * {
     *  "form": 表单元素对象或ID或Name,
     *  "callback": 加载完成后的回调函数，
     * }
     */
    submitForm: function(args){
        var errmsg = "[Jraf.NewAjax][method=submitForm]";
        if (this.__isNull(["form"], args, errmsg)) {
            return;
        }
        var formObj = this.__getFormObj(args.form);
        
        var newoptions =  Object.clone(this.options);
        if (Object.isFunction(args.callback)){
            Object.extend(newoptions, {onComplete: args.callback});
        }
        return Form.request(formObj ,newoptions);
    },
    /**
     * {
     *  "form": 表单元素对象或ID或Name,
     *  "toElement": 加载到的元素对象或ID,
     *  "callback": 加载完成后的回调函数(函数无参数传入)，
     * }
     */
    submitFormTo: function(args){
        var errmsg = "[Jraf.NewAjax][method=submitFormTo]";
        if (this.__isNull(["form", "toElement"], args, errmsg)) {
            return;
        }
        
        var el = $(args.toElement);
        var formObj = this.__getFormObj(args.form);
        if ((formObj.action +"").trim() === "/xmlprocesserservlet") {
            alert(errmsg + "表单action不能配置成/xmlprocessersevlet！");
            return;
        }
        
        var callback = args.callback;
        return this.submitForm({"form": formObj , "callback": function(x) {
                el.innerHTML = "";
                el.innerHTML = x.responseText;
                if(Object.isFunction(callback)) {
                    callback();
                }
            }
        });
    },
    /**
     * {
     *  "form": 表单元素对象或ID或Name,
     *  "callback": 加载完成后的回调函数，
     *  "error": 系统异常时提示信息，默认“系统异常：+ 后台异常信息”，
     *  "success": 操作成功提示信息，默认“操作成功。”，
     *  
     * }
     */
    submitFormXml: function(args){
        var errmsg = "[Jraf.NewAjax][method=submitFormXml]";
        if (this.__isNull(["form", "toElement"], args, errmsg)) {
            return;
        }
        var formObj = this.__getFormObj(args.form);
        var action = (formObj.action +"").trim();
        if (action != "" && action !== "/xmlprocesserservlet") {
            alert(errmsg + "表单action只能配置成‘/xmlprocessersevlet’方式或不配置action");
            return;
        } else {
            formObj.action = "/xmlprocesserservlet";
        }
        
        var callback = args.callback;
        if(Object.isFunction(callback)) {
            return this.submitForm({
                "form" : formObj,
                "callback" : function(x) {
                    // callback(x.responseXML);
                    this.__callBackXmlNormal(x, callback);
                }.bind(this)
            });
        } 
        
        var error = args.error || "系统异常：";
        var success = args.success || "操作成功。";
        var afterSuccess = args.afterSuccess || (function () {});
        return this.submitForm({
            "form" : formObj,
            "callback" : function(x) {
                this.__callBackXmlSimple(x, error, success, afterSuccess);
            }.bind(this)
        });
    },
    submitDiv: function(uri,htmlElementId , callbackonComplete, params){
        if (typeof params != 'object') params = {};
        if($(htmlElementId))
            this.parambody = Form.serializeElements(Form.getElements($(htmlElementId)),false);
        if(this.params = Object.toQueryString(params))
            this.parambody = this.params + (this.parambody == undefined?'':('&' + this.parambody));
        if(this.parambody == undefined)
            this.parambody = '';
        return this.request(uri, this.parambody ,callbackonComplete);
    },
    submitDivTo: function(uri,htmlElementId ,toId, params){    
        return this.submitDiv(uri ,htmlElementId ,function(x){
            $(toId).innerHTML = x.responseText;
        } ,params
        );
    },
    submitDivXml: function(uri,htmlElementId ,processXml, params){
        if(Object.isFunction(processXml))
            return this.submitDiv(uri ,htmlElementId ,function(x){
                processXml(x.responseXML);
            } ,params
            );
        else{
            return this.submitDiv(uri ,htmlElementId ,null ,params);
        }
    },
    /**
     * 方法参数对象：
     * {
     *  "url": 提交地址,可为空，默认为"/xmlprocesserservlet",
     *  "options"：{
     *      sysName : "<sc:fmt value='xxx' type='crypto'/>",
     *      oprID : "<sc:fmt value='xxx' type='crypto'/>",
     *      actions : "<sc:fmt value='xxx' type='crypto'/>",
     *      params : null
     *  }, //查询参数
     *  "callback": function (pkgObj, recordArray, errorNo) {
     *      //pkgObj => Jraf.Pkg对象（xml操作对象）
     *      //recordArray => xml: /DataPacket/Response/Data/Record数组（结果数据集）
     *      //errorNo => xml: /DataPacket/Response/@result错误编号，可根据此提示具体错误信息
     *      
     *  }, //加载完成后的回调函数，如果有此项，不会有成功提示框弹出，
     * 
     *  //以下为弹出提示框选项
     *  "error": 系统异常时提示信息，默认“系统异常：+ 后台异常信息”，
     *  "success": 操作成功提示信息，默认“操作成功。”，
     *  "afterSuccess": 成功后的回调函数(关闭窗口时调用)，
     * }
     */
    sendForXml: function(args){
        var errmsg = "[Jraf.NewAjax][method=sendForXml]";
        var url = args.url || "/xmlprocesserservlet";
        
        var callback = args.callback;
        if(Object.isFunction(callback)) {
            return this.request(url , args.options || {} ,function(x){
                this.__callBackXmlNormal(x, callback);
            }.bind(this));
        } 
        
        var error = args.error || "系统异常：";
        var success = args.success || "操作成功。";
        var afterSuccess = args.afterSuccess || (function () {});
        return this.request(url , args.options || {} ,function(x){
            var pkg = new Jraf.Pkg(x.responseXML);
            var result = '' + pkg.result();
            if (result != '0') {
                Jraf.showMessageBox({
                    text: ''+error + pkg.allMsgs("<br/>"),
                    type: "error"
                });
                return;
            }
            Jraf.showMessageBox({
                text: '' + success,
                type: "success",
                onClose: afterSuccess
            });
        });
    }
});

Jraf.Xml = Class.create({
    initialize : function(xmlDoc) {
        this.xmlDoc = xmlDoc;
    },
    singleNode : function(xpath) {
        try {
            return this.xmlDoc.selectSingleNode(xpath);
        } catch (e) {
            return null;
        }
    },
    text : function(xpath, defautVal) {
        try {
            if (Object.isString(xpath)) {
                return this.text(this.singleNode(xpath), defautVal);
            } else {
                return xpath.text;
            }
        } catch (e) {
            return defautVal || null;
        }
    },
    value : function(xpath, defautVal) {
        try {
            if (Object.isString(xpath)) {
                return this.value(this.singleNode(xpath), defautVal);
            } else {
                return xpath.value;
            }
        } catch (e) {
            return defautVal || null;
        }
    }
});

Jraf.Pkg = Class.create(Jraf.Xml ,{
    initialize: function($super, xmlDoc, options) {
        $super(xmlDoc);
        this.options = {
          rootName:         'DataPacket',
          requestPath:         '/DataPacket/Request',
          reqDataPath:        '/DataPacket/Request/Data',
          responsePath:     '/DataPacket/Response',
          rspDataPath:        '/DataPacket/Response/Data',
          resultPath:       '/DataPacket/Response/@result',
          sysNamePath:        '/DataPacket/SysName',
          oprIDPath:        '/DataPacket/OprID',
          actionPath:        '/DataPacket/Action',
          hintMsgPath:        '/DataPacket/Response/Hint/Msg',
          errorMsgPath:        '/DataPacket/Response/Error/Msg',
          recordName:       'Record'
        };
        Object.extend(this.options, options || { });
    },
    option: function(optionName){
        return this.options[optionName];
    },
    result: function(){
        return this.value(this.options.resultPath,'-1');
    },
    hintMsg: function(index){
        var xpath;
        if(!index)
            index=0;
        xpath=this.options.hintMsgPath+"["+index+"]";
        return this.text(xpath);
    },
    errorMsg: function(index){
        var xpath;
        if(!index)
            index=0;
        xpath=this.options.errorMsgPath+"["+index+"]";
        return this.text(xpath);
    },
    allMsgs : function(delimiter) {
        var msg = "";
        if (!Object.isString(delimiter))
            delimiter = '\n';
        try {
            var nodes = $A(this.xmlDoc.selectNodes(this.options.errorMsgPath));
            if (nodes !== null) {
                nodes.each(function(node, index) {
                    var msg1 = this.text(node);
                    if (msg1 != null && msg1.trim() != "") {
                        msg += "错误:" + msg1 + delimiter;
                    }
                }, this);
            }
        } catch (e) {
        }

        try {
            nodes = $A(this.xmlDoc.selectNodes(this.options.hintMsgPath));
            if (nodes !== null) {
                nodes.each(function(node, index) {
                    var msg1 = this.text(node);
                    msg += msg1 + delimiter;
                }, this);
            }
        } catch (e) {
        }
        return msg;
    },
    /**
     * 获取指定路径下子节点的集合，多条相同名称子节点合并为数组
     * @param 路径
     * @return 对象（如果空，返回空对象{}）
     */
    childDatas: function(xpath){
        var ret = {};
        var pnode = xpath;
        if(Object.isString(xpath)){
            pnode=this.singleNode(xpath);
        }
        if(!pnode){
             return ret;
        }
        var nodes = $A(pnode.childNodes);
        nodes.each(function(node){
            var name = node.nodeName;
            var value;
            if(node.firstChild && node.firstChild.nodeType == 1){
                //alert(name+" has child Element");
                value = this.childDatas(node);
            }else{
                value = this.text(node);
            }
            if(ret[name]){//duplicate name,change to array
                if(!Object.isArray(ret[name])){
                    var pval = ret[name];
                    ret[name]=new Array(0);
                    ret[name].push(pval);
                }
                ret[name].push(value);
            }else{
                ret[name] = value;
            }
        } ,this);
        return ret;
    },
    rspData: function(fieldname){
      var xpath=this.options.rspDataPath+"/"+fieldname;
        return this.text(xpath);
    },
    reqData: function(fieldname){
      var xpath=this.options.reqDataPath+"/"+fieldname;
        return this.text(xpath);
    },
    rspDatas: function(subXPath){
        var xpath = this.options.rspDataPath;
        if(subXPath) xpath += "/"+subXPath;
        return this.childDatas(xpath);
    },
    reqDatas: function(subXPath){
        var xpath = this.options.reqDataPath;
        if(subXPath) xpath += "/"+subXPath;
        return this.childDatas(xpath);
    },
    rspPageNo: function(){
        var xpath = this.options.rspDataPath+'/PageInfo/PageNo';
        return this.text(xpath);
    },
    rspRecordCount: function(){
        var xpath = this.options.rspDataPath+'/PageInfo/RecordCount';
        return this.text(xpath);
    },
    rspPageCount: function(){
        var xpath = this.options.rspDataPath+'/PageInfo/PageCount';
        return this.text(xpath);
    },
    rspPageSize: function(){
        var xpath = this.options.rspDataPath+'/PageInfo/PageSize';
        return this.text(xpath);
    }
}
);
/**
 * 遮罩
 * 参数：
 *     zIndex: 数字，层次
 * 方法：
 *     show: 显示（为第几层）
 *     hide: 隐藏（第几层的）
 * @author yangx
 * @createdate 2013-06-25
 */
Jraf.Mask = Class.create({
    initialize: function(options) {
        if (Object.isString(options)) {
            options = {zIndex: options};
        }
        var e = Prototype.emptyFunction;
        this.ie = Prototype.Browser.IE;
        this.options = Object.extend({
            zIndex:        98,
            placeObject: null,
            maskType: 'iframe',
            __positionStyleCache: null
        }, options || { });
    },
    __getId: function (zIndex) {
        return "__JrafMask_" + (zIndex || this.options.zIndex) + "_id";
    },
    __init: function() {
        if (!$(document.body)) 
            return;
        if ($(this.__getId())) 
            return;
        this.maskObj = new Element('iframe', {
            id: this.__getId(),
            src: '#',
            width: '100%',
            height: '100%',
            frameborder: 0
        }).setOpacity(0.2).setStyle({
            left: '0', 
            top: '0', 
            position: 'absolute', 
            backgroundColor: '#000',
            display: 'none',
            zIndex: this.options.zIndex
        });
        //if (this.ie) { 
        //create mask
        var placeObj = this.options.placeObject || document.body;
        $(placeObj).insert(this.maskObj);

        //fixed: iframe访问地址时，被中断，一直显示加载中
        this.maskObj.src = "/public/blank.jsp";
        window.setTimeout(function () {
            this.maskObj.contentWindow.document.write("<html><body></body></html>");
            this.maskObj.contentWindow.document.body.style.cssText="background-color: #000";
        }.bind(this), 1);
        //}
    },
    __setOffset: function (zIndex) {
        var obj = $(this.__getId(zIndex));
        if (!obj) { 
            this.options.zIndex = zIndex || this.options.zIndex;
            this.__init();
            obj = $(this.__getId(zIndex));
        }
        //滚动条与窗口上边框的距离
        var vpOff = document.viewport.getScrollOffsets();
        var oDim = document.viewport.getDimensions();
        if (oDim.width == 0) {
            oDim.width = document.body.clientWidth;
        }
        if (oDim.height == 0) {
            oDim.height = document.body.clientHeight;
        }
        obj.setStyle({
            top: (vpOff.top) + 'px', 
            width: oDim.width + "px", 
            height: oDim.height + "px"
        });
        return obj;
    },
    show: function (zIndex) {
        var placeObj = $(this.options.placeObject);
        if (placeObj) {
            this.options.__positionStyleCache = placeObj.getStyle("position");
            placeObj.setStyle({position: "relative"});
        }
        (this.options.placeObject || document.documentElement || document.body).style.overflow = "hidden";
        var obj = this.__setOffset(zIndex);
        obj.show();
    },
    hide: function (zIndex) {
        var placeObj = $(this.options.placeObject);
        if (placeObj) {
            this.options.__positionStyleCache = placeObj.getStyle("position");
            placeObj.setStyle({position: this.options.__positionStyleCache || ""});
        }
        (this.options.placeObject || document.documentElement || document.body).style.overflow = "auto";
        var obj = this.__setOffset(zIndex);
        obj.hide();
    }
});
/**
 * avalible Options:
 *     text:        the message to be show
 *  title:    MessageBox's Title,
 *  type:     info,warn,choose,error(show different icon)
 *  onClose:  
 *  onOk:
 *  onCancel:
 *  onYes:
 *  onNo:
*/
Jraf.ShowMessageBox= Jraf.showMessageBox = function(options){
        if(!Jraf.MessageBoxInstance){
            Jraf.MessageBoxInstance = new Jraf.MessageBox(options);
        }
        options = Object.extend({onOk:function(){}},options||{});
        window.setTimeout(function (){//弹出窗口，套弹出窗口
            Jraf.MessageBoxInstance.show(options);
        }, 1);
        return Jraf.MessageBoxInstance;
};
/**
 * 
 * ==HISTROY BEGIN==
 * ADD{yangx on 2013-03-30}:
 *    1.增加this.options.doAfterLoad属性，配合this.options.url属性使用
 *    2.增加对“确定”、“取消”、“是”、“否”等按钮的点击后禁用操作
 */
Jraf.MessageBox = Class.create({
    initialize: function(options) {
        var e = Prototype.emptyFunction;
        this.ie = Prototype.Browser.IE;
        this.options = {
            zIndex:        99,
            icon:        '/common/images/info.gif',
            className:    'mesgBox desktop',
            title:        '消息',
            url:        null,
            urlParam:   null,
            width:      null,
            height:     null,
            type:       null,/*info,warn,choose,error*/
            doAfterLoad: null //使用url属性后有效，在加载url页面后执行的方法
    };
    Object.extend(this.options, options || { });
    //create mask
    this.maskObj = new Jraf.Mask(""+(this.options.zIndex - 1));
    
    this.boxEL = new Element('div',{
            style: 'display:none;'
        }
    ).addClassName(this.options.className);
    var titleEL = new Element('div').addClassName('boxtitle');
    titleEL.insert(
        new Element('span').update(this.options.title).addClassName('titleText')
    );
    titleEL.insert(
        new Element('span',{
            title:         '关闭'
        }).addClassName('btnClose').update("&nbsp;").observe("click",this.onClose.bind(this))
    );
    this.boxEL.insert(titleEL);
    this.boxEL.insert(new Element('div').addClassName('boxbody'));
    var btndivEL = new Element('div').addClassName('btndiv');
    btndivEL.insert( new Element('input',{
        type:'button',
        value:' 确定 '
        }).addClassName('btnOk').observe("click",this.onOk.bind(this))
    );
    btndivEL.insert('&nbsp;');
    btndivEL.insert( new Element('input',{
        type:'button',
        value:' 取消 '
        }).addClassName('btnCancel').observe("click",this.onCancel.bind(this))
    );
    btndivEL.insert('&nbsp;');
    btndivEL.insert( new Element('input',{
        type:'button',
        value:'  是  '
        }).addClassName('btnYes').observe("click",this.onYes.bind(this))
    );
    btndivEL.insert('&nbsp;');
    btndivEL.insert( new Element('input',{
        type:'button',
        value:'  否  '
        }).addClassName('btnNo').observe("click",this.onNo.bind(this))
    );
    this.boxEL.insert(btndivEL);
    $(document.body).insert(this.boxEL);
  },
  show: function(options){
        if(!options)
            options = {};
        if(Object.isString(options)){
            options = {text:options};
        }
        if(options.text){
            var oBody = this.boxEL.down('div.boxbody');
            if (!options.type || options.type.trim() == "") {
                if(!/class=(['"]?)(success|error|info|warn|choose)\1/gi.test(options.text)) {
                    oBody.setStyle({padding: "0"});//历史兼容问题处理
                } else {
                    oBody.setStyle({padding: ""});//历史兼容问题处理
                }
                oBody.innerHTML = options.text;
            } else {
                oBody.setStyle({padding: ""});//历史兼容问题处理
                oBody.innerHTML="<span class=\""
                    + (options.type) + "\">" 
                    + options.text + "</span>";
            }
        }
        if(options.url){
            var oBody = this.boxEL.down('div.boxbody');
            oBody.setStyle({padding: "0"});
            
            var ajax = new Jraf.Ajax({asynchronous: false});
            ajax.request(options.url, options.urlParams || {}, function(x){
                this.boxEL.down('div.boxbody').innerHTML = x.responseText;
                try {
                    if (typeof (this.options.doAfterLoad) == "function") {
                        this.options.doAfterLoad();//加载后调用的方法
                    }
                } catch(e){}
                ajax = null;
            }.bind(this));
        }
        if(options.title){
            this.boxEL.down('div.boxtitle span.titleText').innerHTML = options.title;
        } else {
            this.boxEL.down('div.boxtitle span.titleText').innerHTML = this.options.title;
        }
        //hide all buttons
        this.boxEL.select('div.btndiv input[type="button"]').each(Element.hide);
        //show buttons
        delete this.options.onClose;
        delete this.options.onOk;
        delete this.options.onCancel;
        delete this.options.onYes;
        delete this.options.onNo;
        var buttons = [];
        if(Object.isFunction(options.onClose)) {
            this.options.onClose = options.onClose;
        }
        if(Object.isFunction(options.onCancel)) {
            var btnCancel = this.boxEL.down('div.btndiv .btnCancel');
            this.options.onCancel = options.onCancel;
            if ("disabled" in btnCancel) btnCancel.disabled = false;
            btnCancel.show();
            buttons.push("btnCancel");
        }
        if(Object.isFunction(options.onYes)) {
            var btnYes = this.boxEL.down('div.btndiv .btnYes');
            this.options.onYes = options.onYes;
            if ("disabled" in btnYes) btnYes.disabled = false;
            btnYes.show();
            buttons.push("btnYes");
        }
        if(Object.isFunction(options.onNo)){
            var btnNo = this.boxEL.down('div.btndiv .btnNo');
            this.options.onNo = options.onNo;
            if ("disabled" in btnNo) btnNo.disabled = false;
            btnNo.show();
            buttons.push("btnNo");
        }
        if(!options.onYes && !options.onNo //排除存在“是”和“否”按钮的情况
                && Object.isFunction(options.onOk)) {
            var btnOk = this.boxEL.down('div.btndiv .btnOk');
            this.options.onOk = options.onOk;
            if ("disabled" in btnOk) btnOk.disabled = false;
            btnOk.show();
            buttons.push("btnOk");
        }
        //set width and height
        if(options.width != null && options.width != "") {
            this.boxEL.setStyle({width: options.width + "px"});
        } 
        if(options.height != null && options.height != "") {
            this.boxEL.setStyle({height: options.height + "px"});
        } 
        if (!options.width && !options.height ) {
            this.boxEL.style.cssText = "";//clean the width and the height
        }
        //set the height of body div
        this.boxEL.show();
        var titleHeigth = this.boxEL.down('div.boxtitle').getHeight();
        var btnDivHeigth = this.boxEL.down('div.btndiv').getHeight() + 1;
        
        var bodyHeight = this.boxEL.getHeight()-(titleHeigth+btnDivHeigth);
        var oBoxBody = this.boxEL.down('div.boxbody');
        oBoxBody.setStyle({height: bodyHeight + "px"});
        //兼容再次计算(border),去除padding的占位
        var bodyOffsetH = oBoxBody.getHeight();
        bodyHeight = (bodyOffsetH > bodyHeight? (bodyHeight - (bodyOffsetH - bodyHeight)): bodyHeight);
        oBoxBody.setStyle({height: bodyHeight + "px"});
        
        var elDim = this.boxEL.getDimensions();
        var vpDim = document.viewport.getDimensions();
        //兼容
        if (vpDim.width == 0) {
            vpDim.width = document.body.clientWidth; 
        }
        if (vpDim.height == 0) {
            vpDim.height = document.body.clientHeight; 
        }
        var vpOff = document.viewport.getScrollOffsets();//滚动条与窗口上边框的距离
        var elOff = {
            left: (vpDim.width>elDim.width?(vpDim.width-elDim.width)/2:elDim.width) + 'px',
            top: (vpDim.height>elDim.height?vpOff.top+(vpDim.height - elDim.height)/2:elDim.height) + 'px'
        };
        this.boxEL.setStyle(elOff).setStyle({zIndex: this.options.zIndex});
        
        //遮罩
        this.maskObj.show();
        this.boxEL.show();
        //设置按钮焦点后，可按回车操作（需在可见情况下才可获得焦点）
        var oDefaultBtn = this.boxEL.down("div.btndiv ."+buttons[0]);
        if (oDefaultBtn) {
            oDefaultBtn.focus();
        }
  },
  onClose: function(){
      try{
          if(Object.isFunction(this.options.onClose)){
              this.options.onClose();
          }
          
          //this.shim.hide(); 
          this.maskObj.hide();
          
          this.boxEL.hide();
      }catch(e){
          /*不处理alert("onClose: "+e.message);*/
          //弹出窗口页面中调用此方法报：Object“未定义”
      }
  },
  /**
   * this.options.onOk()返回false不关闭窗口
   */
  onOk: function(){
      var btnOk = this.boxEL.down('div.btndiv .btnOk');
      if ("disabled" in btnOk) 
          btnOk.disabled = true;
      var flag = true;
      if(Object.isFunction(this.options.onOk)){
          flag = this.options.onOk();
      }
      if (flag == false) {//排除为返回true或返回空null的情况
          if ("disabled" in btnOk)
              btnOk.disabled = false;
          return;
      }
      this.onClose();
  },
  onCancel: function(){
      var btnCancel = this.boxEL.down('div.btndiv .btnCancel');
      if ("disabled" in btnCancel) 
          btnCancel.disabled = true;
      var flag = true;
      if(Object.isFunction(this.options.onCancel)){
          flag = this.options.onCancel();
      }
      if (flag == false) {
          if ("disabled" in btnCancel)
              btnCancel.disabled = false;
          return;
      }
      this.onClose();
  },
  onYes: function(){
      var btnYes = this.boxEL.down('div.btndiv .btnYes');
      if ("disabled" in btnYes)
          btnYes.disabled = true;
      var flag = true;
      if(Object.isFunction(this.options.onYes)){
          flag = this.options.onYes();
      }
      if (flag == false) {
          if ("disabled" in btnYes)
              btnYes.disabled = false;
          return;
      }
      this.onClose();
  },
  onNo: function(){
      var btnNo = this.boxEL.down('div.btndiv .btnNo');
      if ("disabled" in btnNo) 
          btnNo.disabled = true;
      var flag = true;
      if(Object.isFunction(this.options.onNo)){
          flag = this.options.onNo();
      }
      if (flag == false) {
          if ("disabled" in btnNo) 
              btnNo.disabled = false;
          return;
      }
      this.onClose();
  }
});

/**
 * Context Menu
 * options:
 *  menuItems -> The Array witch contain the Menu Datas
 *     selector -> CSS selector
 *  eventName -> the event name of witch bringup menu 
 *  pageOffset ->
 *  fade -> 
 *  zIndex ->
 *  beforeShow ->
 *  beforeHide ->
 *  beforeSelect ->
 *
 * menuItems Array Struct:
 *  name -> displayed name
 *  className -> CSS class name
 *  callback -> the callback function
 *  separator -> Is this a separator,true or false
 *  disabled -> true or false
 *  title -> Tip Info of this menuItem
 *  submenu -> The Array witch contain the Sub Menu Datas
 */
Jraf.ContextMenu = Class.create({
    //arguments:options
    initialize: function(options) {
        var e = Prototype.emptyFunction;
        this.ie = Prototype.Browser.IE;
        if(Object.isString(options)){
            options = {selector: options};
        }
        this.options = Object.extend({
            selector: '.contextmenu',
            eventName:    (Prototype.Browser.Opera ? 'click' : 'contextmenu'),
            className: 'ctxmenu desktop',
            pageOffset: 25,
            fade: false,
            zIndex: 100,
            beforeShow: e,
            beforeHide: e,
            beforeSelect: e
        }, options || { });
        
        this.shim = new Element('iframe', {
            style: 'position:absolute;filter:progid:DXImageTransform.Microsoft.Alpha(opacity=0);display:none',
            src: 'javascript:false;',
            frameborder: 0
        });
        
        this.options.fade = this.options.fade && !Object.isUndefined(Effect);
        this.container = new Element('div', { style: 'display:none'}).addClassName(this.options.className);
        
        this.maxwidth=14;
        var list = new Element('ul');        
        this.options.menuItems.each(function(item) {
            var namelen = item.name?item.name.realLength():0;
            this.maxwidth=this.maxwidth>namelen?this.maxwidth:namelen;
            var classname = item.separator ? 'separator' : '';
            if(Object.isArray(item.subMenu))
                classname= 'subMenu' + (item.disabled ? ' disabled' : ' enabled');
            else
                classname = (item.className || '') + (item.disabled ? ' disabled' : ' enabled');
            var menuEL = item.separator 
                        ? '' 
                        : Object.extend(new Element('a', {
                            href: '#',
                            title: (item.title?item.title:item.name)
                        }).addClassName(classname), { _callback: item.callback })
                        .observe('click', this.onClick.bind(this))
                        .observe('contextmenu', Event.stop)
                        .update(item.name);
            list.insert(
                new Element('li').addClassName(item.separator ? 'separator' : '').insert(menuEL)
            );
        }.bind(this));
        this.container.style.width = this.maxwidth*6+50;
        $(document.body).insert(this.container.insert(list).observe('contextmenu', Event.stop));
        if (this.ie) { $(document.body).insert(this.shim); }
        
        document.observe('click', function(e) {
            if (this.container.visible() && !e.isRightClick()) {
                this.options.beforeHide(e);
                if (this.ie) this.shim.hide();
                this.container.hide();
            }
        }.bind(this));

        //register show menu event
        $$(this.options.selector).invoke('observe', this.options.eventName, function(e){
            if (Prototype.Browser.Opera && !e.ctrlKey) {
                return;
            }
            this.show(e);
        }.bind(this));
    },
    show: function(e) {
        e.stop();
        this.options.beforeShow(e);
        var x = Event.pointer(e).x,
            y = Event.pointer(e).y,
            vpDim = document.viewport.getDimensions(),
            vpOff = document.viewport.getScrollOffsets(),
            elDim = this.container.getDimensions(),
            elOff = {
                left: ((x + elDim.width + this.options.pageOffset) > vpDim.width 
                    ? (vpDim.width - elDim.width - this.options.pageOffset) : x) + 'px',
                top: ((y - vpOff.top + elDim.height) > vpDim.height && (y - vpOff.top) > elDim.height 
                    ? (y - elDim.height) : y) + 'px'
            };
        this.container.setStyle(elOff).setStyle({zIndex: this.options.zIndex});
        if (this.ie) { 
            this.shim.setStyle(Object.extend(Object.extend(elDim, elOff), {zIndex: this.options.zIndex - 1})).show();
        }
        this.options.fade ? Effect.Appear(this.container, {duration: 0.25}) : this.container.show();
        this.event = e;
    },
    onClick: function(e) {
        e.stop();
        if (e.target._callback && !e.target.hasClassName('disabled')) {
            this.options.beforeSelect(e);
            if (this.ie) this.shim.hide();
            this.container.hide();
            e.target._callback(this.event);
        }
    }
});

/**
 * 为指标的定义了title属性值的元素增加显示样式
 * 使用方法： new Jraf.ToolTip({selector: 'input[title][type="text"]'})
 */
Jraf.ToolTip = Class.create({
    initialize: function(options) {
        var e = Prototype.emptyFunction;
        this.ie = Prototype.Browser.IE;
        if(Object.isString(options)){
            options = {selector: options};
        }
        this.options = Object.extend({
            selector:     'a[title]',
            tipName:        'tip',
            eventName:    'mousemove',
            className:     'toolTip desktop',
            pageOffset: 25,
            hOffset: 5,
            fade: false,
            zIndex: 100,
            onInit:    e,
            beforeShow: e,
            beforeHide: e,
            beforeSelect: e
        }, options || { });
        this.titletext;
        this.shim = new Element('iframe', {
            style: 'position:absolute;filter:progid:DXImageTransform.Microsoft.Alpha(opacity=0);display:none',
            src: 'javascript:false;',
            frameborder: 0
        });
        
        this.options.fade = this.options.fade && !Object.isUndefined(Effect);
        this.container = new Element('div', { style: 'display:none;'}).addClassName(this.options.className);
        
        //var dvHdr=new Element('div').addClassName('tipLeft');    
        var dvBdy=new Element('div').addClassName('tipBody');
        var dvBt = new Element('div').addClassName('tipBottom');
        //this.container.insert(dvHdr);//.observe('mousemove', Event.stop);
        this.container.insert(dvBdy);//.observe('mousemove', Event.stop);
        this.container.insert(dvBt);//.observe('mousemove', Event.stop);
        $(document.body).insert(this.container);
        if (this.ie) { $(document.body).insert(this.shim); }        

        //register show toolTip event
        $$(this.options.selector).each(function(o){
                this.options.onInit(o);
                if(!o.tip){
                    o.tip = o.title;
                    o.title='';
                }
                o.observe(this.options.eventName, function(e){
                    this.show(e);
                    }.bind(this));
                o.observe('mouseout', function(e){
                        this.options.beforeHide(e);
                        if (this.ie) this.shim.hide();
                        this.container.hide(); 
                    }.bind(this));
            }
            ,this);
    },
    show: function(e) {
        e.stop();
        this.options.beforeShow(e);
        //var headertext='';
        var bodytext='';
        if(!e.target || !e.target[this.options.tipName])
            return;
        var tipString = e.target[this.options.tipName];
        if(tipString.isJSON()){
            var json=tipString.evalJSON();
            headertext = json.header?json.header:'';
            bodytext = json.body?json.body:'';
        }else{
            bodytext=tipString;
        }
        //headertext = '<img src="/common/images/info.gif" style="vertical-align:middle"/>' + headertext;
        //this.container.down('.tipLeft').update(headertext);
        this.container.down('.tipBody').update(bodytext);
        //this.container.innerHTML=e.target.title;
        var x = Event.pointer(e).x;
        var y = Event.pointer(e).y;
        var vpDim = document.viewport.getDimensions();
        var vpOff = document.viewport.getScrollOffsets();//有滚动条时
        var elDim = this.container.getDimensions();
        
        var viewY = y - vpOff.top;//可视区域y轴距离
        var top = y+this.options.hOffset;
        //大于显示框高度时，可以正常放置显示框在光标上方，否则显示框显示到光标下方
        if (viewY > elDim.height) {
            top = (y - elDim.height- this.options.hOffset);
        }
        
        var elOff = {
                left: ((x + elDim.width + this.options.pageOffset) > vpDim.width 
                    ? (vpDim.width - elDim.width - this.options.pageOffset) : x) + 'px',
                top: (top) + 'px'
            };
        //alert(vpOff.top + ":" + y + ":" +elDim.height+"::::"+(y - vpOff.top + elDim.height  + this.options.hOffset)+":"+vpDim.height)
        this.container.setStyle(elOff).setStyle({zIndex: this.options.zIndex});
        if (this.ie) { 
            this.shim.setStyle(Object.extend(Object.extend(elDim, elOff), {zIndex: this.options.zIndex - 1})).show();
        }
        this.options.fade ? Effect.Appear(this.container, {duration: 0.25}) : this.container.show();
        this.event = e;
    }
});

/**
 * OutLinetor
 * 使鼠标进入表格行时，改变表格行的背景色
 */
Jraf.Outlinetor = Class.create({
    initialize: function(options){
        if(Object.isString(options)){
            options = {selector: options};
        }
        this.options = Object.extend({
            selector:     '#roww tr',
            tagName:        'tr',
            outlineEventName:    'mouseover',
            unlineEventName:    'mouseout',
            className:     'select',    //鼠标进入时效果
            selectClassName: 'selected' //选中时的效果
        }, options || { });

        $$(this.options.selector).invoke('observe',this.options.outlineEventName,
            function(e){
                var oEL = $(Event.findElement(e,this.options.tagName));
                if (oEL.readAttribute("className") != this.options.selectClassName) {
                    oEL.toggleClassName(this.options.className);
                }
            }.bind(this)
        );
        
        $$(this.options.selector).invoke('observe',this.options.unlineEventName,
            function(e){
                var oEL = $(Event.findElement(e,this.options.tagName));
                if (oEL.readAttribute("className") != this.options.selectClassName) {
                    oEL.toggleClassName(this.options.className);
                }
            }.bind(this)
        );
        /* 避免和表格行单击事件冲突，暂时去掉，以后可以考虑功能合并
        $$(this.options.selector).invoke('observe', "click",
            function(e){
                var element = $(Event.element(event)); 
                //排除当前点击的元素为表单元素的情况
                if ('input' == element.tagName.toLowerCase()
                        || 'select' == element.tagName.toLowerCase()
                            || 'textarea' == element.tagName.toLowerCase()
                                || 'a' == element.tagName.toLowerCase()
                                    || 'img' == element.tagName.toLowerCase()) {
                    event.cancelBubble = true;
                    return;
                }
                
                var oEL = $(Event.findElement(e,this.options.tagName));
                oEL.toggleClassName(this.options.selectClassName);
            }.bind(this)
        );*/
  }
});

/**
 * DropDownMenu,alai_menu implemented
*/
Jraf.DropDownMenu = Class.create({
    //arguments:options
    initialize: function(options) {
        var e = Prototype.emptyFunction;
        this.ie = Prototype.Browser.IE;
        if(Object.isString(options)){
            options = {selector: options};
        }
        this.options = Object.extend({
            menuItems: [{
                menuname:'menuname',
                linkurl:'',
                childs:[]
                }],
            onSelect: e,
            selector: '#tomenu',
            className: 'dropdownMenu desktop',
            pageOffset: 25,
            fade: false,
            zIndex: 100,
            beforeShow: e,
            beforeHide: e,
            beforeSelect: e
        }, options || { });
        this.menuContext=new menu_bar(10,20,$$(this.options.selector)[0]);
        this.addMenus(this.options.menuItems);
    },
    addMenus: function(items){
        if(!Object.isArray(items)) return;
        items.each(function(item){
            this.addMenu(item);
        },this);
    },
    addMenu: function(item){
        this.addMenuTo(item, this.menuContext);
    },
    addMenuTo: function(item, menuvar) {
        try{
        var submenu=null;
        if(item.childs){
            submenu = new alai_menu();
            if(menuvar instanceof menu_bar){
                    menuvar.add(item.menuname,submenu);
            }else{
                    menuvar.add(item.menuname,'sub',submenu);
            }
            var rcds = item.childs;
            for(var i=0;rcds && i<rcds.length ;i++){
                this.addMenuTo(rcds[i],submenu);
            }
        }else{
            submenu=menuvar.add(item.menuname,'js','viewItem("'+item.linkurl+'")');
        }
        if(menuvar instanceof alai_menu){
            var len = item.menuname.length;
            var mlen = menuvar.body.style.pixelWidth;
            menuvar.body.style.pixelWidth= (len* 12 + 25)>mlen?(len* 12 + 25):mlen;
        }
        return submenu;
        }catch(e){alert('addmenuto,ERROR:'+e.message);}
    }
});

/**
 * Tree,alai_tree implemented
            treeItem: {
                name:'display name',
                key:'mykey',
                pkey:'parentkey',
                icon:'imageurl',
                exeCategory:'js/expaned/url',
                exeArg:'viewItem()',
                onClick:function(srcNode){},
                tag:'mydata'
                }
*/
Jraf.Tree = Class.create({
    //arguments:options
    initialize: function(options) {
        var e = Prototype.emptyFunction;
        this.ie = Prototype.Browser.IE;
        if(Object.isString(options)){
            options = {selector: options};
        }
        var defimagelist = new alai_imagelist();
        defimagelist.path="/common/images/tree/";
        defimagelist.add("default","default");
        defimagelist.add("hfold_open","hfold_open");
        defimagelist.add("hfold_close","hfold_close");
        defimagelist.add("folder_open","open");
        defimagelist.add("folder_close","close");
        defimagelist.add("plus_m","expand");
        defimagelist.add("plus_top","expand_top");
        defimagelist.add("plus_end","expand_end");
        defimagelist.add("minus_m","collapse");
        defimagelist.add("minus_top","collapse_top");
        defimagelist.add("minus_end","collapse_end");
        defimagelist.add("branch","leaf");
        defimagelist.add("branch_end","twig");
        defimagelist.add("vline","line");
        defimagelist.add("blank","blank");
        this.options = Object.extend({
            imagelist:    defimagelist,
            treeItems: [],
            indent:    0,
            onexpand: function(srcNode){
                srcNode.icon.src=srcNode.treeContext.imageList.item["hfold_open"].src;
            },
            oncheck:function(srcNode){
                var ischecked = srcNode.checkBox.checked;
                //if(ischecked == true && srcNode.first && srcNode.first.tag == 'asyncloading'){
                //    srcNode.expand(true, false);
                //}
                setBelowCheck(srcNode, ischecked);    // 设置底下所有展开结点的状态
            },
            oncollapse:function(srcNode){
                srcNode.icon.src=srcNode.treeContext.imageList.item["hfold_close"].src;
            },
            afteradd: function(srcNode){
                if(srcNode.parent.icon){
                    srcNode.parent.icon.src=this.options.imagelist.item["hfold_open"].src;
                }
            }.bind(this),
            selector: '#tomenu'
        }, options || { });
        this.treeContext=new alai_tree(this.options.imagelist,this.options.indent,$$(this.options.selector)[0]);
        this.treeContext.afteradd=this.options.afteradd;
        this.treeContext.oncollapse=this.options.oncollapse;
        this.treeContext.onexpand=this.options.onexpand;
        this.treeContext.oncheck=this.options.oncheck;
        //this.addNodes(this.options.treeItems);
    },
    /*addNodes: function(items){
        if(!Object.isArray(items)) return;
        var addedNodes=[];
        items.each(function(item){
            addedNodes.push(this.addNode(item));
        },this);
        return addedNodes;
    },*/
    addNode: function(item){
        var pNode=this.treeContext.nodes[item.pkey]||this.treeContext.root;
        var nNode=this.treeContext.add(pNode,"last",item.name,item.key,item.icon,item.exeCategory,item.exeArg);
        nNode.tag=item.tag;
        nNode.treeContext=this.treeContext;
        if(Object.isFunction(item.onClick)) 
            nNode.execute=function(){item.onClick(nNode);};
        if(Object.isFunction(item.onRightClick))
        	nNode.rightexecute=function(){item.onRightClick(nNode);};
        return nNode;
    },
    /**
     * @param item特殊属性{checkName: 表单名称, checkValue：表单值 }
     */
    addChkNode: function(item, checked){
        var pNode=this.treeContext.nodes[item.pkey]||this.treeContext.root;
        var nNode=this.treeContext.addChkNode(pNode,"last",item.name,item.key,item.icon,item.exeCategory,item.exeArg, checked, item.checkName,item.checkValue);
        nNode.tag=item.tag;
        nNode.treeContext=this.treeContext;
        if(Object.isFunction(item.onClick)) 
            nNode.execute=function(){item.onClick(nNode);};
        return nNode;
    },
    collapseAll: function(){
        this.treeContext.root.children.each(function(e){
            e.expand(false,true);
        });
    },
    //重写alai_tree方法
    testPath: function (path){
        if(path==null||path=="")return false;
        if(path=="/")return true;
        if(path.lastIndexOf("/")!=path.length-1)path+="/";
        for(var i=count-1;i>=0;i--){
            alert(this.treeContext.nodes[i].getPath()+"/" +" : "+path);
            if((this.treeContext.nodes[i].getPath()+"/").indexOf(path)==0)
                return true;
        }
        return false;
    },
    reload: function (oNode){
        try{
            var selectedNode = this.treeContext.getSelectedNode();
            var path = null;
            if(selectedNode == null){
                if(oNode == null){ 
                    var root = this.treeContext.root;
                    if(root.first != null){
                        if(root.first == root.last){
                            selectedNode = this.treeContext.root.first;
                        }else{
                            this.treeContext.expandToTier(root.first.getTier());
                            return;
                        }
                    }else{
                        return;
                    }
                }else{
                    oNode.expand(true);
                }
            }
            path = selectedNode.getPath();;
            selectedNode.click();
          //  alert("path: "+ path);
            oNode = oNode == null ?this.treeContext.root.first:oNode;
            //oNode.expand(false,true);
            this.removeChildren(oNode);
            var nNode = this.treeContext.add(oNode,"first",'loading...', 'load');
            nNode.tag = 'asyncloading';
            oNode.expand(true);
            selectedNode = this.treeContext.getNodeByPath(path);
         //   alert("selectedNode: "+ selectedNode);
            if(selectedNode != null){
                selectedNode.select();
            }
        }catch(e){alert('[Jraf.Tree][method=reload]ERROR:'+e.message);}
    },
    removeChildren: function (oNode){
        if(oNode == null)return;
        var srcNode = oNode;
        if(!srcNode.hasChild)
             this.treeContext.remove(srcNode);
        else{
            for(var i=0;i<srcNode.children.length;i++){
                 this.treeContext.removeNode(srcNode.children[i]);
            } 
        }
    }
});
/** 递归选择树结点 */
function setBelowCheck(srcNode, ischecked){
    var node = srcNode.first;
    while (node != null && node.tag != 'asyncloading'){
        node.checkBox.checked = ischecked;
        if(node.first && node.first.tag != 'asyncloading')  { setBelowCheck(node, ischecked); }
        node = node.next;
        
    }
}

/**
 * 按照接口传数据后，自动构造动态树
 * 后台返回结果，名称要求：  
 *     key（必需）:      节点代码
 *     nodename（必需）: 节点显示名称
 *     nodetype: 节点类型，前台默认root
 *     childnum: 子节点数量
 *     （以上关键字可自定义）
 *  说明：1.nodetype用于按层区分节点，方便实现不同的onexpand方法，
 *       即每层的onexpand查询方法可以配置成不同的。如果后台结果集中不含nodetype
 *       的值，则默认使用root类型的参数作为执行onexpand方法的查询参数。
 *       2.构造树对象时，必需设置一个root节点类型
 * ------------------------------------------------------------
 * 例1
 *     //1.构造树
 *     var simpleTree = new Jraf.Tree({
 *         selector:'#quotalist'
 *         rootType: {
 *            sysName: '<sc:fmt type="crypto" value="pcmc"/>',
 *            oprID:   '<sc:fmt type="crypto" value="sm_menu"/>',
 *            actions: '<sc:fmt type="crypto" value="listAll"/>',
 *            extraParams: null,
 *            onClick: viewNode,
 *            //以上为常用
 *            onRightClick: null, 
 *            icon: null, 
 *            exeCategory: null, 
 *            exeArg: null,
 *            key: "key",//自定义
 *            nodename: "nodename",//自定义
 *            nodetype: "nodetype",//自定义
 *            childnum: "childnum",//自定义
 *            showKey:  true //节点名称是否展示key值
 *         }
 *     });
 *     //2.向树添加节点
 *     simpleTree.addRoot("根节点"); //自定义根点
 *     或 simpleTree.addNodes();     
 *     
 * 例2：//1.构造树
 *     var simpleTree = new Jraf.Tree({selector:'#quotalist'});
 *     //2.增加节点类型（节点类型，用于设置点击事件等），【必需有root类型】
 *     simpleTree.addNodeType("root",{
 *            sysName: '<sc:fmt type="crypto" value="pcmc"/>',
 *            oprID:   '<sc:fmt type="crypto" value="sm_menu"/>',
 *            actions: '<sc:fmt type="crypto" value="listAll"/>',
 *            extraParams: null,
 *            onClick: viewNode
 *     });
 *     //3.向树添加节点
 *     simpleTree.addRoot("根节点"); //自定义根点
 *     或 simpleTree.addNodes("root");   //
 *     
 * @author yangx
 * @createDate 2013-05-08
 */
Jraf.SimpleTree = Class.create(Jraf.Tree,
{
  initialize: function($super, options)
  {
      $super(options);
      var subOptions = {
           ajaxObj: new Jraf.Ajax(),
           onexpand: function (srcNode) { 
                         this.addNodes(srcNode.tag.nodetype, srcNode);
                     }.bind(this),
           oncollapse: null,
           rootType: {//定义root节点类型的参数, 向nodeTypes中增加根节点类型参数
                         sysName: null,
                         oprID:   null,
                         actions: null,
                         extraParams: null,
                         onClick: null, 
                         onRightClick: null, 
                         icon: null, 
                         exeCategory: null, 
                         exeArg: null,
                         key: "key",
                         nodename: "nodename",
                         nodetype: "nodetype",
                         childnum: "childnum",
                         showKey:  true //节点名称是否展示key值
                     },
           nodeTypes: {//定义一类节点的点击事件查询参数等
                          root:  {
                              sysName: null,
                              oprID:   null,
                              actions: null,
                              extraParams: null,
                              onClick: null, 
                              onRightClick: null, 
                              icon: null, 
                              exeCategory: null, 
                              exeArg: null,
                              key: "key",
                              nodename: "nodename",
                              nodetype: "nodetype",
                              childnum: "childnum",
                              showKey:  true //节点名称是否展示key值
                          }, 
                          node1: {}
                       }
      };
      Object.extend(subOptions, options || { });
      Object.extend(this.options, subOptions || { });
      //alert($H(this.options.rootType).inspect())
      this.options.nodeTypes.root = this.options.rootType || { };

      //this.treeContext.afteradd = this.options.afteradd;
      this.treeContext.oncollapse = this.createCollapse.bind(this);
      this.treeContext.onexpand = this.createExpend.bind(this);
      //this.treeContext.oncheck = this.options.oncheck;
      
  },
  createExpend: function (srcNode) {
      srcNode.icon.src = srcNode.treeContext.imageList.item["hfold_open"].src;
      if (srcNode.first && srcNode.first.tag == 'asyncloading') {
          if (Object.isFunction(this.options.onexpand)) {
              this.options.onexpand(srcNode);
          }
      }
  },
  createCollapse: function (srcNode) {
      srcNode.icon.src = srcNode.treeContext.imageList.item["hfold_close"].src;
      if (Object.isFunction(this.options.oncollapse)) {
          this.options.oncollapse(srcNode);
      }
  },
  /**
   * 添加节点类型
   * @param type节点类型
   * @param nodeTypeObj参数列表对象
   */
  addNodeType: function (type, nodeTypeObj) {
      var params = {};
      type = Object.isString(type) ? type: "undefined";
      params[type] = nodeTypeObj;
      Object.extend(this.options.nodeTypes, params || { });
  },
  /**
   * 向树中添加根节点
   * @param name根节点的显示名称
   */
  addRoot: function (name) {
      var item = this.options.nodeTypes.root;
      if (item == null) {
          alert("[Jraf.SimpleTree][method=addRoot]不存在为root的nodetype.");
          return;
      }
      var tag = {};
      tag.nodetype = 'root';
      var key = 'n';
      tag.key = key;
      var oNode = this.addNode({
          name:     name, 
          key:      key, 
          pkey:     null,
          onClick:  item.onClick,
          tag:      tag
      });  
      this.addNodes(tag.nodetype, oNode);
  },
  /**
   * 添加子节点
   * @param nodetype节点类型，可使用addNodeType方法添加， 默认为root类型
   * @param pNode父节点对象，为空是，表示添加根节点
   */
  addNodes: function (nodetype, pNode) {
      nodetype = !!nodetype?nodetype:"root";
      var nodeParams = this.options.nodeTypes[nodetype];
      nodeParams.key = nodeParams.key || "key";
      nodeParams.nodename = nodeParams.nodename || "nodename";
      nodeParams.nodetype = nodeParams.nodetype || "nodetype";
      nodeParams.childnum = nodeParams.childnum || "childnum";
      nodeParams.showKey =  nodeParams.showKey || true; //节点名称是否展示key值
      //alert($H(nodeParams).inspect())
      var params = {
          sysName:  nodeParams.sysName,
          oprID:    nodeParams.oprID,
          actions:  nodeParams.actions
      };
      
      Object.extend(params, nodeParams.extraParams || {});
      if (pNode != null) {
          Object.extend(params, pNode.tag || {});
          //alert($H(pNode.tag).inspect())
      }
      //alert($H(params).inspect())
      
      this.options.ajaxObj.sendForXml('/xmlprocesserservlet', params, function(xml){
          try{
              var pkg = new Jraf.Pkg(xml);
              if (pkg.result() != '0') {
                  alert('获取树异常！\n' + pkg.allMsgs());        //查询失败处理
                  Jraf.showMessageBox({
                      title: "查询失败", 
                      text: '获取节点数据出错：' + pkg.allMsgs('<br>'),
                      type: "error"
                  });
                  return;
              }
              var rcds = pkg.rspDatas().Record;
              if(!rcds) {
                  rcds = [];
              }
              if(!Object.isArray(rcds)) {
                  rcds = [rcds];
              }
              var key = "";
              var pkey = "n";
              var item = {};
              var tag = {};
              var oNode = null;
              for (var i=0, len=rcds.length; i < len; i++) {
              //rcds.each( function(rcd){//循环添加结点
                  rcd = rcds[i];
                  var keyCode = rcd[nodeParams.key];
                  tag = rcd;
                  if (pNode == null) {
                      key = "n,"+rcd[nodeParams.key];
                      pkey = "n";
                      if (!rcd[nodeParams.nodetype]) {
                          tag.nodetype = "root";
                      }
                  } else {
                      key = pNode.tag.key + "," + rcd[nodeParams.key];
                      pkey = pNode.tag.key;
                      if (!rcd[nodeParams.nodetype]) {
                          tag.nodetype = pNode.tag.nodetype;
                      }
                  }
                  Object.extend(tag, {key: key});
                  item = {
                      name:       ((nodeParams.showKey == true)?"["+keyCode+"]":"") + rcd[nodeParams.nodename],
                      key:        key,
                      pkey:       pkey,//"n" + rcd.pkey,
                      onClick:    nodeParams.onClick,   //点击结点响应事件
                      onRightClick: nodeParams.onRightClick,
                      tag:        tag
                  };
                  oNode = this.addNode(item);
                  if (rcd[nodeParams.childnum] != '0'){
                      this.addNode({name:'loading...',key:'load', pkey: item.key, tag:'asyncloading'});
                      oNode.expand(false,true); //存在子节点
                  } else {
                      oNode.expand(false, false);
                  }
                  
              //}, this);
              }
              
              /* 消除父结点 Loading 结点 */
              if (pNode && pNode.first && pNode.first.tag == 'asyncloading') {
                  pNode.first.remove();       //消除是否含子结点的标志行
                  if(!pNode.first) { 
                      var icons = pNode.treeContext.imageList.item;
                      var srcNode = pNode;
                      srcNode.icon.src = icons["default"].src; 
                      //pNode.icon.style.marginLeft = icons["expand"].width;
                      if(icons["leaf"]!=null && icons["twig"]!=null){
                          srcNode.exIcon=new Image(); 
                          srcNode.icon.insertAdjacentElement("beforeBegin", srcNode.exIcon);
                          srcNode.exIcon.src=srcNode.next==null?icons["twig"].src:icons["leaf"].src;
                      }
                  }
              }
          } catch(ex) {
              alert('[Jraf.SimpleTree][methode=addNodes]ERROR:' + ex.message);
          }
      }.bind(this));
  },
  addSubNode: function () {
      
  },
  /**
   * 获取指标编码的树形节点的路径字符串
   * @param sysName   系统名称
   * @param oprID     处理ID
   * @param actions   方法名称
   * @return 字符串
   */
  getPath: function (reqparams) {
      var path = null;
      var ajax = new Jraf.Ajax({asynchronous: false});//同步
      ajax.sendForXml('/xmlprocesserservlet', reqparams, function(xml){
          try{
              var pkg = new Jraf.Pkg(xml);
              if(pkg.result() != '0'){
                  Jraf.showMessageBox({
                      text: '获取节点路径字符串”出错！\n'+pkg.allMsgs('<br/>'),
                      type: "error"
                  });
                  return;
              }
              path = pkg.rspDatas().Record.nodePath;
          }catch(e){
              alert('[Jraf.SimpleTree][method=getPath]ERROR:'+e.message);
          }
      });
      return path;
  },
  /**
   * 根据节点代码,定位到树上的位置
   * @param nodeValue  节点编码（key code）,如： n1,T101,T1010001
   * @return
   */
  findNode: function (nodeValue) {
      if (nodeValue == null) {
          alert("[Jraf.SimpleTree][method=findNode]ERROR: 参数为空, 无法定位。");
          return;
      }
      var oTree = this;
      var index = nodeValue.indexOf(",") == -1 ? nodeValue.length: nodeValue.indexOf(",");
      var subNodeCode = nodeValue.substring(0, index);
      var oNode = oTree.treeContext.nodes[subNodeCode];
      var remainStr = nodeValue.substr(index);
      while(remainStr != null && remainStr != "") {//循环展开树节点
          if (oNode || !oNode.expanded) 
              oNode.expand(true, false);
          
          index = remainStr.indexOf(",", 1) == -1 ? remainStr.length: remainStr.indexOf(",", 1);
          subNodeCode += remainStr.substring(0, index);
          oNode = oTree.treeContext.nodes[subNodeCode];
          remainStr = remainStr.substr(index);
      }
      oNode = oTree.treeContext.nodes[nodeValue];
      if (oNode == null) {
          alert("[Jraf.SimpleTree][method=findNode]ERROR: 查找树节点出错，找不到对应节点！");
          return;
      }
      oNode.select();
      oNode.click();
      oNode.body.focus();
  }
});
/**
 * Not implemented
*/
Jraf.CombBox = Class.create({
    initialize: function() {
  }
});

/**
 * 进度条
 * @param hintMsg 自定义提示信息
 * @param placeObj 对象，表示显示的地方
 * 
 * 例：
 * Jraf.ProgressStart();//显示进度条
 * Jraf.ProgressEnd();//隐藏进度条
 */
Jraf.ProgressStart = function(hintMsg, placeObj){
    try {
        if(!Jraf.ProgressInstance){
            Jraf.ProgressInstance = new Jraf.Progress(placeObj, hintMsg);
        }
        if (hintMsg) {
            Jraf.ProgressInstance.setHintMsg(hintMsg);
        }
        Jraf.ProgressInstance.start();
    } catch (e) {
        alert("[Jraf.ProgressStart]进度条js异常" + e.message);
        Jraf.ProgressInstance = null;
    }
    return Jraf.ProgressInstance;
};

/**
 * 进度条
 * @param placeObj 对象，表示显示的地方
 */
Jraf.ProgressEnd = function(placeObj){
    try {
        Jraf.ProgressInstance.end();
    } catch (e) {
        Jraf.ProgressInstance = null;
    }
    return Jraf.ProgressInstance;
};
/**
 * Not implemented
*/
Jraf.Progress = Class.create({
    initialize: function(htmlElementId, msg) {
        this.placeObj = null;
        if(Object.isString(htmlElementId) && htmlElementId.trim() != ""){
            this.placeObj = $(htmlElementId);
        }
        this.hintMsg = msg || "数据处理中，请稍候......";
        this.maskObj = new Jraf.Mask({placeObject: this.placeObj});
        this.__zIndex = this.maskObj.options.zIndex;
        this.mainObj = this.__createBlock();
        this.msgDivObj = null;
    },
    setHintMsg: function (hintMsg) {
        this.hintMsg = hintMsg || "数据处理中，请稍候......";
        this.mainObj.down(".progress-msg").innerHTML = this.hintMsg;
    },
    __getMainId: function () {
        return "__JrafProgress_MainId_";
    },
    __createBlock: function () {
        var mainDivObj = new Element("div", {
            id: this.__getMainId()
        }).addClassName("progress-main");
        var loadingDivObj = new Element("div").addClassName("progress-loading");
        var msgDivObj = new Element("div").addClassName("progress-msg");
        msgDivObj.innerHTML = this.hintMsg;
        
        mainDivObj.insert(loadingDivObj);
        mainDivObj.insert(msgDivObj);
        
        var oPlace = null;
        if (this.placeObj) {
            oPlace = this.placeObj;
            this.placeObj.insert(mainDivObj);
        } else {
            $(document.body).insert({before: mainDivObj});
            oPlace = $(document.documentElement || document.body);
        }
        var height = oPlace.getHeight();
        var width = oPlace.getWidth();
        mainDivObj.setStyle({
            left: (width - mainDivObj.getWidth())/2 + "px",
            top: (height - mainDivObj.getHeight())/2 + "px",
            zIndex: this.__zIndex + 1
        });
        //隐藏
        mainDivObj.hide();
        return mainDivObj;
    },
    start: function () {
        this.maskObj.show();
        this.mainObj.show();
    },
    end: function () {
        this.maskObj.hide();
        this.mainObj.hide();
    }
});

/**
 * 容器(table | div | iframe | ...)高、宽长度根据窗口内容自动适应
 * 使用方法： new Jraf.DimensionsAuto(...);
 * 参数说明：
 * 1.winObj：     窗口对象（window | parent | top）
 * 2.selector:     css选择器
 * 3.type:         自适应的类型（width | height | null）
 * 4.balance:     差额，宽度或高度要减去或增加的部分
 */
Jraf.DimensionsAuto = Class.create({
    initialize: function(winObj,selector, type, balance) {
        Number.prototype.NaN0 = function()
        {
            return isNaN(this)?0:this;
        };
        var oWindow = winObj==null? window: winObj;
        if(!selector)selector = "iframe";
        if(!balance)balance = 0;
        if(oWindow.$$(selector) == null) return ;
        oWindow.$$(selector).each(function(obj){
            obj = $(obj);
            try{
                var bHeight = 0;
                var bWidth = 0;
                var wHeight = 0;
                var wWidth = 0;
                if(document.documentElement || document.body){
                    if(obj.tagName.toLowerCase() == "iframe"){//根据iframe的内容设置其高度、宽度
                        bHeight = obj.contentWindow.document.documentElement.scrollHeight;
                        bWidth = obj.contentWindow.document.documentElement.scrollWidth;
                        
                        bHeight = Math.max(bHeight, obj.contentWindow.document.body.scrollHeight);
                        bWidth = Math.max(bWidth, obj.contentWindow.document.body.scrollWidth);
                    }else{
                        /*var borderHeight = 0;
                        var borderWidth = 0;
                        if ("currentStyle" in obj) {
                            //上边框值
                            var borderTopWidth = obj.currentStyle.borderTopWidth;
                            borderTopWidth = borderTopWidth.replace("px", "");
                            borderTopWidth = isNaN(borderTopWidth)? 0 : borderTopWidth;
                            //下边框值
                            var borderBottomWidth = obj.currentStyle.borderBottomWidth;
                            borderBottomWidth = borderBottomWidth.replace("px", "");
                            borderBottomWidth = isNaN(borderBottomWidth)? 0 : borderBottomWidth;
                            borderHeight = borderTopWidth + borderBottomWidth;
                            //左边框值
                            var borderLeftWidth = obj.currentStyle.borderLeftWidth;
                            borderLeftWidth = borderLeftWidth.replace("px", "");
                            borderLeftWidth = isNaN(borderLeftWidth)? 0 : borderLeftWidth;
                            //右边框值
                            var borderRightWidth = obj.currentStyle.borderRightWidth;
                            borderRightWidth = borderRightWidth.replace("px", "");
                            borderRightWidth = isNaN(borderRightWidth)? 0 : borderRightWidth;
                            borderWidth = borderLeftWidth + borderRightWidth;
                        }
                        alert("borderHeight = " + borderHeight +"："+"borderWidth = "+borderWidth);*/
                        var objDimensions = obj.getDimensions();
                        bHeight = objDimensions.height;
                        bWidth = objDimensions.width;
                    }
                    //alert("oWindow.document.documentElement.clientHeight: "+oWindow.document.documentElement.clientHeight);
                    //alert("oWindow.document.body.clientHeight: "+oWindow.document.body.clientHeight);
                    //wHeight = Math.max(oWindow.document.documentElement.clientHeight, oWindow.document.body.clientHeight);
                    //wWidth = Math.max(oWindow.document.documentElement.clientWidth, oWindow.document.body.clientWidth);
                    wHeight = Math.max(oWindow.document.documentElement.offsetHeight, oWindow.document.body.offsetHeight);
                    wWidth = Math.max(oWindow.document.documentElement.offsetWidth, oWindow.document.body.offsetWidth);
                    /*var dimensions = oWindow.document.viewport.getDimensions();
                    wHeight = dimensions["height"];
                    wWidth = dimensions["width"];*/
                    //alert("height = "+bHeight+": wHeight="+wHeight+" , width = "+ bWidth+":wWidth="+wWidth);
                }
                var height = Math.max(bHeight, wHeight);
                var width = Math.max(bWidth, wWidth);
                if(type == "width"){
                    obj.setStyle({"width": (width + balance)+"px"});
                }else if(type == "height"){
                    obj.setStyle({"height": (height + balance)+"px"});
                }else{
                    obj.setStyle({"height": (height + balance)+"px", "width": (width + balance)+"px"});
                }
                //alert(obj.tagName +" 's width: "+obj.style.width +" , height: "+obj.style.height);
            }catch (ex){
                alert("[method=Jraf.DimensionsAuto]ERROR:"+ex.message);
            }
        });
    }
});

/**
 * 获取窗口的高度和宽度
 * @param winObj 窗口对象，默认当前窗口
 * 使用：
 *     var oWin = new Jraf.Dimensions();
 *     var width = oWin.getWidth(); 获取宽度
 *     var height = oWin.getHeight(); 获取高度
 *     var oDim = oWin.getDimensions(); 获取宽度和高度
 * 方法：
 *     getDimensions(): 返回{width: number, heigth: number}
 *     getWidth(): 返回width
 *     getHeight(): 返回heigth
 * @author Sean
 * @creatdata 2013-12-20
 */
Jraf.Dimensions = Class.create({
    initialize: function(winObj) {
        var oWindow = winObj==null? window: winObj;
        var pageWidth = window.innerWidth;
        var pageHeight = window.innerHeight;
        if (typeof pageWidth != 'number') {
            if (document.compatMode == 'CSS1Compat') {
                pageWidth = document.documentElement.clientWidth;
                pageHeight = document.documentElement.clientHeight;
            } else {
                pageWidth = document.body.clientWidth;
                pageHeight = document.body.clientHeight;
            }
        }
        this.pageWidth = pageWidth;
        this.pageHeight = pageHeight;
    },
    /**
     * 获取窗口的高、宽度
     */
    getDimensions: function () {
        return {width: this.pageWidth, heigth: this.pageHeight};
    },
    /**
     * 获取窗口的宽度
     */
    getWidth: function () {
        return this.pageWidth;
    },
    /**
     * 获取窗口的高度
     */
    getHeight: function () {
        return this.pageHeight;
    },
    /**
     * 设置指定对象的宽度
     * @param oBlock    指定对象
     * @param balance   差额，宽度或高度要减去或增加的部分
     */
    setWidth: function (oBlock, balance) {
        if (!$(oBlock)) 
            return;
        
        if (!balance) balance = 0;
        var oBlock = $(oBlock);
        oBlock.setStyle({width: (this.pageWidth + balance)+"px"});
    },
    /**
     * 设置指定对象的高度
     * @param oBlock    指定对象
     * @param balance   差额，宽度或高度要减去或增加的部分
     */
    setHeight: function (oBlock, balance) {
        if (!$(oBlock)) 
            return;
        
        if (!balance) balance = 0;
        var oBlock = $(oBlock);
        oBlock.setStyle({height: (this.pageHeight + balance)+"px"});
    },
    /**
     * 设置指定对象的高度、宽度
     * @param oBlock    指定对象
     * @param balance   差额，宽度或高度要减去或增加的部分
     */
    setDimensions: function (oBlock, balance) {
        if (!$(oBlock)) 
            return;
        //先隐藏
        oBlock.hide();
        this.setHeight();
        this.setWidth();
        oBlock.show();
    }
});

/**
 * 表格操作类。可编辑表格内容
 * 参数：
 *  options: {
 *      tableId: 表格的id,
 *      submitForm: 包含表格的表单名称
 *      addId: 对象Id,添加“增加表格行”的点击事件。默认值为“doPlus”
 *      delId: 对象Id,添加“删除表格行”的点击事件。默认值为“doMinus”
 *      saveId: 对象Id,添加“保存”的点击事件。默认值为“doSave”
 *      submitActions： 提交数据逻辑配置 {sysName: "",oprID: "", actions: "", forward: ""}
 *      queryActions：查询数据逻辑配置 {sysName: "",oprID: "", actions: "", forward: ""}
 *      ......
 *  }
 */
Jraf.Table = Class.create({
    initialize: function(options) {
        this.options = Object.extend({
            tableId: "record",
            mainTab: null,
            submitForm: "page_form",
            addId: "doPlus",
            delId: "doMinus",
            saveId: "doSave",
            submitActions: {sysName: "",oprID: "", actions: "", forward: ""},
            queryActions: {sysName: "",oprID: "", actions: "", forward: ""},
            evenClassNm: "even",
            oddClassNm: "odd",
            //选中行所有单元格默认样式
            tdClassNm: "datacell_td_select",
            //选中单元格默认样式
            currentTdClassNm: "datacell_td_selected",
            //当前选中行
            currentRowIndex: null,
            //当前编辑cell
            currentCell: null,
            //编辑前保存值，待比较
            //oldCellValue: "",
            //原始表格
            orgContent: "",
            //原始表格初始值,判断是否修改数据,删除时重新算
            orgTableValue: [[]],
            //原始表格总行数,删除时重新算
            orgTableRows: null,
            //保存修改过后单元格数据
            tableEditRows: [[]],
            //标记是否能编辑
            editbleFlag: true,
            //选中行字体颜色
            //currentFontColor: "black",
            //用来保存下拉菜单中的option项
            optionText: "",
            //图片列号
            imagePos: 0,
            //保存每一列的编辑状态
            editable: [],
            //保存每一列的编辑类型
            colStyle: [],
            //表单名称
            sName: [],
            //保存下拉框中的text和value
            sText: [],
            sValue: [],
            //校验类型
            customType: [],
            //增加时用的各个单元格的默认数据
            cellData: [],
            //是否清理表格
            hasClean: false,
            //保存是否成功
            isSuccess: false,
            //支持的表单控件
            inputs: {"txt":0,"sel": 1}
        }, options || { });
        this.options.mainTab = $(this.options.tableId);
        this.options.orgTableRows = this.options.mainTab.rows.length;
        /******************************/
        this.onInitCheckData();
        //获取已定义的颜色
        this.readDefColor();
        Event.observe(this.options.mainTab,"click",this.clickIt.bind(this));
        Event.observe(this.options.addId,"click",this.add_row.bind(this));
        Event.observe(this.options.delId,"click",this.del_row.bind(this));
        Event.observe(this.options.saveId,"click",this.doSave.bind(this));
        Event.observe(document,"click",this.cleanTable.bind(this));
        
        //初始化增加表格的数据 
        for(var i=0; i < this.options.mainTab.rows[0].cells.length; i++){
            this.options.cellData[i] = "";
        }
        //原始表格，可以支持reset
        this.options.orgContent = this.options.mainTab.outerHTML;
    },
    onInitCheckData: function () {
        if(this.options.mainTab == null){
            alert("[Jraf.Table][method=onInitCheckData]警告: 请检查配置的表格ID[tableId]参数是否正确。");
            return false;
        }
        if(this.options.submitForm == null ){
            alert("[Jraf.Table][method=onInitCheckData]警告: 请检查配置的表单名称[formId]参数是否正确。");
            return false;
        }
        if(this.options.addId == null ){
            alert("[Jraf.Table][method=onInitCheckData]警告: 请检查配置的新增按钮ID[addId]参数是否正确。");
            return false;
        }
        if(this.options.delId == null ){
            alert("[Jraf.Table][method=onInitCheckData]警告: 请检查配置的删除按钮ID[delId]参数是否正确。");
            return false;
        }
        if(this.options.saveId == null ){
            alert("[Jraf.Table][method=onInitCheckData]警告: 请检查配置的保存按钮ID[saveId]参数是否正确。");
            return false;
        }
        if(this.options.submitActions.sysName == "" 
            || this.options.submitActions.oprID == ""
                || this.options.submitActions.actions == ""){
            alert("[Jraf.Table][method=doSave]警告:表格提交逻辑[sysName, oprID, actions]的参数未配置或配置不完整。");
            return false;
        }
        return true;
    },
    /*
     * 初始化状态下保存表格各行各列的数据
     */
    /*initTableData: function (){
        var rowObj = null;
        var tempArr = null;
        var rowLen = this.options.mainTab.rows.length;
        
        var colLen = null;
        var colNum = 0;
         for(var j = 1; j < rowLen; j++){
             rowObj = this.options.mainTab.rows[j];
             colLen = rowObj.cells.length;
             for ( colNum = 0; colNum < colLen; colNum ++){
                 if(this.options.orgTableValue[j] == null ){
                     tempArr = new Array();
                 }else{
                     tempArr = this.options.orgTableValue[j];
                 }
                 tempArr[colNum] = rowObj.cells(colNum) == null ? null : rowObj.cells(colNum).innerText;
                 this.options.orgTableValue[j] = tempArr;
             }
         }
         alert(this.options.orgTableValue);
    },*/
    /**
     * 设置编辑方式
     * @param 1: colNum 为列编号
     * @param 2: colSty为编辑类型，分为：txt－文本框编辑； sel－下拉框 编辑
     * @param 3: editable是否可编辑，false表示不能修改此单元格值
     * @param 4: inputNm表单名称，用于提交数据
     * @param 5: customType检查值的类型
     * @param 6: sTxt数组 和sVal组合用，表示（下拉框选项值）标签名
     * @param 7: sVal数组 和sTxt组合用，表示（下拉框选项值）值
     */
     setColStyle: function(colNum,colSty,editable,inputNm,customType,sTxt,sVal){
        if(colNum == null){
            alert("[Jraf.Table][method=setColStyle]警告:设置的colNum（列数）值应该是不为空的整数类型值！");
            return false;
        }
        if(this.options.mainTab.rows(0).cells(0).length <= colNum || colNum < 0){
            alert("[Jraf.Table][method=setColStyle]警告:设置的colNum（列数）值应该在[0, "+(this.options.mainTab.rows.length-1)+"]区间");
            return false;
        }
         if(typeof(inputNm) != "string" || inputNm == null || inputNm == ""){
             alert("[Jraf.Table][method=setColStyle]警告:参数inputNm（表单名称）为空，不能提交数据到服务器！");
             return false;
         }
         if(colSty == null || this.options.inputs[colSty] == null){
             var str = "[Jraf.Table][method=setColStyle]警告：系统不支持["+colSty+"]类型。\n";
             str += "支持类型有：1.txt(文本框);2.sel(下拉框)" ;
             alert(str);
             return false;
         }
         this.options.colStyle[parseInt(colNum)] = colSty;
         editable = typeof(editable)!="boolean" ?true:editable;
         this.options.editable[parseInt(colNum)] = editable;
         this.options.sName[parseInt(colNum)] = inputNm;
         if(sTxt != null){
             this.options.sText[parseInt(colNum)] = sTxt;
         }
         if(sVal != null){
             this.options.sValue[parseInt(colNum)] = sVal;
         }
         if(customType != null){
             this.options.customType[parseInt(colNum)] = customType;
         }
         
         var rowLen = this.options.mainTab.rows.length;
         var cellValue = "";
         var tempArr = null;
         for(var j = 1; j < rowLen; j++){
            rowObj = this.options.mainTab.rows[j];
            if(rowObj.cells(colNum) != null){
                cellValue = rowObj.cells(colNum).innerText;
            }
            //初始创建可编辑项隐藏表单控制，用于提交“修改数据”
             this.hiddenInput(j, colNum, cellValue, "_edit");
             //初始化状态下保存表格可编辑行列的数据
             if(this.options.orgTableValue[j] == null ){
                 tempArr = new Array();
             }else{
                 tempArr = this.options.orgTableValue[j];
             }
            tempArr[colNum] = rowObj.cells(colNum) == null ? null : rowObj.cells(colNum).innerText;
             this.options.orgTableValue[j] = tempArr;
             //保存第一列的隐藏表单
             this.options.orgTableValue[j][0] = rowObj.cells(0) == null ? null : rowObj.cells(0).innerHTML;
         }
     },
     readDefColor: function(){
         this.ReadOrgColor();
     },
     //读取表格现有颜色
     ReadOrgColor: function ()
     {
         var oTable = this.options.mainTab;
         for(var i=0;i<oTable.rows.length;i++)
         {
             for(var j=0;j<oTable.rows[i].cells.length;j++)
             {
                 with(oTable.rows[i])
                 {
                     cells[j].oBgc = "";
                     cells[j].oFc = "";
                 }
             }
         }
     },
    /**
     * 恢复默认状态
     * 1.校验表格中的"未清的文本框"的数据
     * 2.清楚表格中可编辑的文本框，改写成文字
     * 3.设置清除变量值
     */
    cleanTable: function (){
        //此判断为了防止多余的点击
        if(this.options.hasClean){
            return true;
        }
        if (!document.forms[this.options.submitForm]
            || !checkForm(document.forms[this.options.submitForm])){
            return false;
        }
        this.clearColor();
        this.editableStyle();
        //最后清除变更值
        this.defValTable();
        //
        this.options.hasClean = true;
        return true;
    },
    defValTable: function (){
        this.options.currentRowIndex = null;
        this.options.currentCell = null;
        //this.options.oldCellValue = "";
    },
    /**
     * 清除可编辑表格，并判断是否变动表格数据，
     * 如果变动则保存变动值为隐藏表单
     */
    editableStyle: function () {
        var nCurRowIndex = this.options.currentRowIndex;
        var oCurCell = this.options.currentCell;
        var tempArry = null;
        //清除可编辑表格
        if(oCurCell!=null)
        {
            if (oCurCell.children.length>0 )
            {
                if(oCurCell.children[0].tagName.toLowerCase() != "img"
                    &&oCurCell.children[0].tagName.toLowerCase() != "a")
                {
                    if(oCurCell.children[0].tagName.toLowerCase() == "input"
                        && oCurCell.children[0].type == "text"){
                        oCurCell.innerText=oCurCell.children[0].value;//.replaceHTML();
                    }else if(oCurCell.children[0].tagName.toLowerCase() == "select"){
                        oCurCell.innerText=oCurCell.children[0].options[oCurCell.children[0].selectedIndex].text;
                    }
                }
            }
            //判断单元格的值是否被改变
            if(this.isModify(oCurCell.innerText) == 1){//有修改数据
                //alert("isModify: "+oCurCell.innerText);
                this.hiddenInput(nCurRowIndex,oCurCell.cellIndex, oCurCell.innerText);
                tempArry = {};
                tempArry[oCurCell.cellIndex] = oCurCell.innerText;
                this.options.tableEditRows[nCurRowIndex] = tempArry;
            }else if(this.isModify(oCurCell.innerText) == -1){//新增或删除时
                this.hiddenInput(nCurRowIndex,oCurCell.cellIndex, oCurCell.innerText);
            }else{//无修改
                this.cleanHiddenInput(nCurRowIndex,oCurCell.cellIndex);
                this.options.tableEditRows[nCurRowIndex] = null;
            }
        }
    },
    isModify: function(curValue){
        //新增或删除时
        if(this.options.orgTableValue[this.options.currentRowIndex] == null 
                || typeof(this.options.orgTableValue[this.options.currentRowIndex]) == "undefined"){
            return -1;
        }
        var orgValue = this.options.orgTableValue[this.options.currentRowIndex][this.options.currentCell.cellIndex];
        if(orgValue != null && orgValue.trim() != curValue){
            return 1;
        }
        return 0;
    },
    /**
     * 在第一列单元格中创建同行的其他定义了编辑样式的单元格表单隐藏控件
     */
    hiddenInput: function (rowIndex_num, cellIndex_num, inputValue, suffix){
        var ofirstTd = $(this.options.mainTab.rows(rowIndex_num).cells(0));
        if(this.options.sName[cellIndex_num] == undefined 
                || this.options.sName[cellIndex_num] == ""){
            return false;
        }
        var id = this.options.sName[cellIndex_num]+"_"+ rowIndex_num;
        var inputObj = null;
        $(ofirstTd).childElements().each(function(obj){
            if(obj.tagName.toLowerCase() == "input" 
                && obj.id == id){
                inputObj = obj;
                return;
            }
        });
        if(inputObj == null){
            var name = this.options.sName[cellIndex_num];
            var inputTxt = new Element("input", {
                id: id,
                type: "hidden"
            });
            inputTxt.name = name + "" + (suffix == null? "": suffix);
            inputTxt.value = inputValue;
            $(ofirstTd).insert(inputTxt);
        }else{//已存在
            inputObj.value = inputValue;
        }
    },
    //当修改值改变为初始值时
    cleanHiddenInput: function (rowIndex_num, cellIndex_num){
        var ofirstTd = $(this.options.mainTab.rows(rowIndex_num).cells(0));
        if(this.options.sName[cellIndex_num] == undefined 
                || this.options.sName[cellIndex_num] == ""){
            return false;
        }
        var id = this.options.sName[cellIndex_num]+"_"+ rowIndex_num;
        var inputObj = null;
        $(ofirstTd).childElements().each(function(obj){
            if(obj.tagName.toLowerCase() == "input" 
                && obj.id == id){
                inputObj = obj;
                //$(inputObj).remove();
                return;
            }
        });
        if(inputObj != null){
            //$(inputObj).remove();
            $(inputObj).value = this.options.orgTableValue[rowIndex_num][cellIndex_num];
        }
    },
    selectChangeAction: function(){//为select的onchange事件指定动作
        //var cellNum = this.options.currentCell.cellIndex;
        //var valueOfSel = $('powerTableSel').value;
        //给单元格的data赋值
        event.srcElement.parentNode.data = event.srcElement.value;
        //动作代理
        //this.selectProxy(cellNum,valueOfSel);
    },
    selectProxy: function(cellNum, valueOfSel){
        
    },
    setColor: function () {
        //设置选中的行的样式
        var currentTr   = this.options.currentCell.parentElement;
        for(var i=0; i < currentTr.cells.length; i++){
            currentTr.cells[i].className = this.options.tdClassNm;
        }
        this.options.currentCell.className = this.options.currentTdClassNm;
    },
    /**
     * 清除选中行上的所有单元格选中状态时的样式
     */
    clearColor: function (){
        var objTable=this.options.mainTab;
        var nCurRowIndex = this.options.currentRowIndex;
        var oCurCell = this.options.currentCell;
        if (oCurCell != null){
            //清除选中单元格样式
            if(nCurRowIndex != null && nCurRowIndex != -1)
            {
                for(var i=0;i<objTable.rows[nCurRowIndex].cells.length;i++)
                {
                    with(objTable.rows[nCurRowIndex].cells[i])
                    {
                        className=oBgc;
                        //style.color=oFc;
                    }
                }
                //oTable.rows[nCurRowIndex].className = "";
                //alert(oTable.rows[nCurRowIndex].className);
            }
            //清除选中单元格样式
            oCurCell.className = "";
        }//if end
    },
    /**
     * 在表格上的点击事件。
     * 1.获取当前点击到的元素
     * 2.如果当前元素为不可编辑，清除表格可编辑项；
     * 3.设置当前行的选中状态设置是否单元格内容可编辑，如可编辑则生成相应的可编辑表单
     * 4.设置“hasClean清理状态”为false;
     */
    clickIt: function (event){
        event.cancelBubble=true;
        var currentObject = Event.element(event);//event.srcElement;

        if (!checkForm(document.forms[this.options.submitForm])){
            return false;
        }
        //原编辑项变为表格 
        if(this.options.currentCell !=null && this.options.currentRowIndex != 0
            && currentObject.type != "select-one"
                && currentObject.type != "text"){
            this.cleanTable();
        }
        /*if(currentObject.tagName.toLowerCase() != "table"
            && currentObject.tagName.toLowerCase() != "tbody"
               && currentObject.tagName.toLowerCase() != "tr")
        {*/
            var currentTd = null;
            if(currentObject.tagName.toLowerCase() != "td"){
                currentTd = this.getEle("td");
            }else{
                currentTd = currentObject;
            }
            if(currentTd == null)return;
            var currentTr   = currentTd.parentElement;
            this.options.currentRowIndex = currentTr.rowIndex;
            this.options.currentCell= currentTd;
            //var objTable = this.getEle("table");
            //this.clearColor();
            //设置选中的行的样式
            if(this.options.currentRowIndex != 0)
            {
                this.setColor();
            }
            //根据标记设置是否可编辑
            if(this.options.editbleFlag)
            {
                //this.options.oldCellValue = this.options.currentCell.innerText;
                /*根据不同的设置进行编辑选择*/
                if(this.options.currentCell.children.length!=1 && this.options.currentCell.parentNode.rowIndex != 0) 
                {
                    var cellN = this.options.currentCell.cellIndex;
                    var flag = false;
                    if(this.options.colStyle[parseInt(cellN)] == 'txt' 
                          && (this.options.editable[parseInt(cellN)] != false
                              || this.options.orgTableRows <= this.options.currentRowIndex)){
                        this.editCell(this.options.mainTab,this.options.currentCell,'txt',true); 
                        flag = true;
                    }
                    else if(this.options.colStyle[parseInt(cellN)] == 'sel' 
                                && (this.options.editable[parseInt(cellN)] != false
                                    || this.options.orgTableRows <= this.options.currentRowIndex)){
                        this.editCell(this.options.mainTab,this.options.currentCell,'sel',true,this.options.sText[parseInt(cellN)],this.options.sValue[parseInt(cellN)]);
                        flag = true;
                    }
                    if(this.options.currentCell.children.length > 0 && flag == true)
                    {
                        if(this.options.currentCell.children[0].type == "select-one"){
                            this.options.currentCell.children[0].focus();
                        }else{
                            this.options.currentCell.children[0].select();
                        }
                    }
                }
            }
        //}//if end
        this.options.hasClean = false;
        //this.selectRowProxy(this.options.currentRowIndex);
    },
  //增加点击一行时的代理动作，参数是选中当前行号
    selectRowProxy: function (currentRowIndex){
        
    },
   /**
    * 如果定义表格单元格为可编辑，则当点击表格单元格时按定义样式显示成可编辑状态。
    * 目前支持文本和下拉框
    */
    editCell: function (oTable,oCell,editType,bEditable,sText,sValue){
        if (bEditable)
        { 
            switch(editType)
            {
                case 'txt':
                    var inputTxt = new Element("input",{
                        id: "dyText",
                        name: this.options.sName[oCell.cellIndex],
                        type: "text",
                        size: 8,
                        title: oCell.innerText.replaceHTML(),
                        value: oCell.innerText.replaceHTML(),
                        customtype: this.options.customType[oCell.cellIndex]
                    }).setStyle({width: "98%"});
                    inputTxt.onkeydown=this.judgeKeyToDo.bind(this);
                    oCell.innerHTML = "";
                    $(oCell).insert(inputTxt);
                    break;
                case 'sel':
                   // var preValue = oCell.data;//获取当前表格的内容，在下拉框中选中
                    var preValue = oCell.innerHTML;//modify in 2012-12-27 by xw
                   // oCell.innerHTML="<select id=powerTableSel onKeyDown = judgeKeyToDo()>"+this.options.optionText+"</select>";
                    var inputSel = new Element("select",{
                        id: "powerTableSel",
                        name: this.options.sName[oCell.cellIndex],
                        width: oCell.width,
                        onchange: this.selectChangeAction.bind(this)//为select的onchange指定事件
                    }).setStyle({width: "98%"});
                    inputSel.onkeydown=this.judgeKeyToDo.bind(this);
                    var inputOpt = null;
                    for(var i=0; i<sValue.length; i++)
                    {
                        //如果是原有表格的内容，则默认选中
                        /*if(sValue[i] == preValue)
                            this.options.optionText += "<option value='"+sValue[i]+"' selected>"+sText[i];
                        else                   
                            this.options.optionText += "<option value='"+sValue[i]+"'>"+sText[i];*/
                        inputOpt = new Element("option",{
                            value: sValue[i],
                            selected: (sValue[i] == preValue ? "selected": ""),
                            title: sText[i]
                        }).update(sText[i]);
                        this.options.optionText += inputOpt.innerHTML;
                        $(inputSel).insert(inputOpt);//modify in 2012-12-27 by xw
                    }
                    oCell.innerHTML = "";
                    $(oCell).insert(inputSel);
                    //alert(oCell.innerHTML);
                    //清空缓冲区
                    this.options.optionText = "";
                    break;
            }//switch end
        }//if end
    },
    /**
     * 在表格最后新增一行
     * 要点： 
     * 1.新增时要根据用户定义的表单名称加后缀“_add”创建可编辑单元格的隐藏表单控制
     * 2.如果有选中表格的一行，则取消其的选中状态
     * 3.按照表格奇偶样式设置表格行样式
     * @auth: yangxiong 
     * modify in 2012-02-12
     * remark: 
     */
    add_row: function (){
        event.cancelBubble=true;
        var objTable = this.options.mainTab;
        //begin modify  2013-09-27 sunshiwu
    	var colums = objTable.rows[1].cells.length;
        if(colums==1)
        {
        	objTable.deleteRow(1);
        }
        //end modify  2013-09-27 sunshiwu
        var cellNow = this.options.cellData;
        //如果没选中行，则在表格的最下方插入
        //var pos = this.options.currentRowIndex==null?objTable.rows.length:(this.options.currentRowIndex+1);
        var pos = objTable.rows.length;//最后一行增加 modify by yangxiong on 2011-12-28
        this.addRow(objTable,pos,cellNow);

        this.cleanTable();
        this.readDefColor(objTable);
        this.setEvenOddColor();
        //清除设置的数据
        for(var i=0; i < this.options.mainTab.rows[0].cells.length; i++){
            this.options.cellData[i] = "";
        }
        //初始化新增行表单隐藏域
        for(var i = 0 ; i < this.options.sName.length; i++){
            if(this.options.colStyle[i] == 'txt' || this.options.colStyle[i] == "sel"){
                this.hiddenInput(pos, i, "","_add");
            }
        }
    },
    //
    /**
     * 
     * 删除行，并处理当前选择项为不选择
     * 要点：
     * 1.删除分为两种情况，一是删除原表格初始时行，二是删除新增行
     * 2.删除原表格行时，表格行总数（不包括新增行）减1
     * 3.删除原表格行时，将行的主要信息保存为隐藏表单，用于提交到后台做为删除数据库表数据的唯一标识
     * 4.删除新增行不用保存数据
     * 5.删除后，需要初始表格样式和移除选中状态（清空当前状态）
     * @auth: yangxiong 
     * modify in 2012-02-12
     * remark: 
     */
    del_row: function (){
        event.cancelBubble=true;
        var objTable = this.options.mainTab;
        if(this.options.currentRowIndex == null){
            alert("请点击选中要删除的行！");
            return;
        }
        if(confirm("确实要删除第"+this.options.currentRowIndex+"行吗?"))
        {
            //1.将后缀为“_key”的表单变成要删除的数据的主键并移到标题行第一单元格2.删除行
            this.delRow(objTable,this.options.currentRowIndex);
            //删除原表格行时，表格总行数减1
            if( this.options.orgTableRows > this.options.currentRowIndex){
                this.options.orgTableRows = parseInt(this.options.orgTableRows) - 1;
                this.options.orgTableValue[this.options.currentRowIndex] = null;
            }
            //初始数据值
            this.defValTable();
            //调整样式
            this.setEvenOddColor();
        }
    },
    res_tab: function (){
        var objTable = this.options.mainTab;
        objTable.outerHTML=orgContent;
        this.initialize(this.options);
    },
    //在表格中指定位置,插入元素
    addRow: function (oTable,rowIndex2Add,c)
    {
        if (rowIndex2Add<0 || rowIndex2Add>oTable.rows.length)
            return;
        var currentCell;
        var newRow=oTable.insertRow(rowIndex2Add);
        for (var i=0;i<c.length;i++)
        {
            //modified by liu_xc 2004.6.28
            //增加一条数据时，如果时select形式的编辑方式，则搜索sValue和sText
            //找到与输入值相符的value赋给td的data
            if(this.options.colStyle[i] == "sel")
            {
                //如果没有设置数据而直接添加，会在编辑方式为
                //select的td中添加选择框数据的第一项
                if(c[i] == "&nbsp;" || c[i] == "")
                    c[i] = this.options.sText[i][0];
                currentCell=newRow.insertCell(i);
                currentCell.innerHTML= c[i];
                //保存选择项值
                for(var j=0; j<this.options.sText[i].length; j++)
                {
                    if(c[i] == this.options.sText[i][j])
                    {
                        currentCell.data= this.options.sValue[i][j]; 
                    }
                }
            }
            else
            {
                currentCell=newRow.insertCell(i);
                currentCell.innerHTML= c[i];
            }
            //modified by liu_xc 2004.6.28
            //增加一条数据时，如果时select形式的编辑方式，则搜索sValue和sText
            //找到与输入值相符的value赋给td的data
        }
    },
    //删除指定行
    delRow: function (oTable,nRowIndex2Del){
        //不删除标题行；指定行不在表格中也不执行删除；
        if (oTable.rows.length==1
              ||nRowIndex2Del==null
                ||nRowIndex2Del==0
                  || nRowIndex2Del>=oTable.rows.length)
            return;
        else{
            /*for(var i = 0 ; i < this.options.sName.length; i++){
                if(this.options.colStyle[i] == 'txt' || this.options.colStyle[i] == "sel"){
                    this.hiddenInput(nRowIndex2Del, i, "","_del");
                }
            }*/
            //删除非新增的行(原始行)时
            if( this.options.orgTableRows > this.options.currentRowIndex){
                var keyObjs = $(oTable.rows(nRowIndex2Del).cells(0)).select('input[type="hidden"][name$="_key"]');
                var newName = "";
                keyObjs.each(function (obj){
                    //obj.name = obj.name.replace(/_key$/gi,"_del");
                	/*IE6、IE7兼容写法*/
                	newName = obj.getAttribute("name").replace(/_key$/gi,"_del");
                	obj.removeAttribute("name");
                	obj.setAttribute("NAME", newName);
                });
                $(oTable.rows(nRowIndex2Del).cells(0))
                    .select('input[type="hidden"][name$="_edit"]')     //获取“修改”的表单隐藏域
                    .each(function (obj) {
                        obj.remove();                                //移除
                    });
                oTable.rows(0).cells(0).insertAdjacentHTML("beforeEnd", oTable.rows(nRowIndex2Del).cells(0).innerHTML);
            }
            oTable.deleteRow(nRowIndex2Del);
        }
    },
  //获取指定tag的元素 [逐级查找]
    getEle: function (sTag)
    {
        var oElement = Event.findElement(event,sTag);
        if (oElement != document) 
            return oElement;
        /*sTag = sTag.toLowerCase();
        if(oElement.tagName.toLowerCase()==sTag)
            return oElement;
        while(oElement=oElement.offsetParent)
        {
            if(oElement.tagName.toLowerCase()==sTag)
                return oElement;
        }
        return(null);*/
    },
    setEvenOddColor: function (){
        //增加奇偶行的css控制 奇行：tdOdd，偶行：tdEven
        for(var i=1; i<this.options.mainTab.rows.length; i++)
        {
            if(i%2 == 0)
                this.options.mainTab.rows[i].className = this.options.evenClassNm;
            else
                this.options.mainTab.rows[i].className = this.options.oddClassNm;
        }
    },
    //根据在编辑框按键的不同而采取不同的动作
    judgeKeyToDo: function (){
        //按键是tab
        if(event.keyCode == 9)
        {
            if (!checkForm(document.forms[this.options.submitForm]))
            {
                return false;
            }
            var cellN;
            if(this.options.currentCell.cellIndex == this.options.mainTab.rows[this.options.currentRowIndex].cells.length-1)
                cellN = -1;
            else{
                cellN = this.options.currentCell.cellIndex;
            }
            var nextCell = this.options.mainTab.rows[this.options.currentRowIndex].cells[cellN+1];       
            //如果下一个表格未指定编辑方式，跳过
            while(this.options.colStyle[parseInt(cellN+1)] == null )
            {
                cellN = cellN + 1;
                nextCell = this.options.mainTab.rows[this.options.currentRowIndex].cells[cellN];
                if(nextCell == null){
                    return;
                }
            }
            //如果编辑方式为txt
            if(this.options.colStyle[parseInt(cellN+1)] == 'txt' 
                  && (this.options.editable[parseInt(cellN+1)] != false
                      || this.options.orgTableRows <= this.options.currentRowIndex))
            {
                if(this.options.currentCell.children.length>0)
                {
                    if(this.options.currentCell.children[0].tagName.toLowerCase() == "input")
                        this.options.currentCell.innerHTML=this.options.currentCell.children[0].value.replaceHTML();
                    else if(this.options.currentCell.children[0].tagName.toLowerCase() == "select")
                        this.options.currentCell.innerHTML=this.options.currentCell.children[0].options[this.options.currentCell.children[0].selectedIndex].text;
                    this.clearColor();
                }
                this.editCell(this.options.mainTab,nextCell,'txt',true);
            }
            //如果编辑方式为select
            else if(this.options.colStyle[parseInt(cellN+1)] == 'sel' 
                       && (this.options.editable[parseInt(cellN+1)] != false
                           || this.options.orgTableRows <= this.options.currentRowIndex))
            {
                if(this.options.currentCell.children.length>0)
                {
                    if(this.options.currentCell.children[0].tagName.toLowerCase() == "input")
                        this.options.currentCell.innerHTML=this.options.currentCell.children[0].value.replaceHTML();
                    else if(this.options.currentCell.children[0].tagName.toLowerCase() == "select")
                        this.options.currentCell.innerHTML=this.options.currentCell.children[0].options[this.options.currentCell.children[0].selectedIndex].text;
                    this.clearColor();
                }
                this.editCell(this.options.mainTab,nextCell,'sel',true,this.options.sText[parseInt(cellN+1)],this.options.sValue[parseInt(cellN+1)]);
            }
            this.editableStyle();
            //设置当前表格为下一个单元格
            this.options.currentCell = nextCell;
            this.setColor();
            if(this.options.currentCell.children.length > 0)
            {
                if(this.options.currentCell.children[0].type == "select-one")
                    window.setTimeout(function (){this.options.currentCell.children[0].focus();}.bind(this),10);
                else
                    window.setTimeout(function (){this.options.currentCell.children[0].select();}.bind(this),10);
            }
        }
        //如果按键是enter
        if(event.keyCode == 13)
        {
            if (!checkForm(document.forms[this.options.submitForm]))
            {
                return false;
            }
            if(this.options.currentCell.children[0].tagName.toLowerCase() == "input")
                this.options.currentCell.innerHTML=this.options.currentCell.children[0].value.replaceHTML();
            else if(this.options.currentCell.children[0].tagName.toLowerCase() == "select")
                this.options.currentCell.innerHTML=this.options.currentCell.children[0].options[this.options.currentCell.children[0].selectedIndex].text;
        }
    },
    //获取指定列的所有数据，以数组形式返回，如果是文本编辑方式，就返回文本内容，
    //如果是下拉框编辑方式，则返回其value值，即td中的data值
    //colIndex为列号，isImg为是否为图片
    getColData: function(colIndex,isImg){
        if(colIndex == "")
            return null;
        var colNum = colIndex == null ? 0 : colIndex;
        //如果为指定此参数，则默认为false，即不是图片格式数据
        var isImgCol = isImg == null ? false : isImg;
        var arrCelData = new Array();
        if(/\D/g.test(colNum)
            || colNum >= this.options.mainTab.rows[0].cells.length
             || colNum < 0)
            return null;
        if(isImgCol)
        {
            for(var i=1; i<this.options.mainTab.rows.length; i++)
            {
                if(this.options.mainTab.rows[i].cells[0].children[0]
                    && this.options.mainTab.rows[i].cells[0].children[0].tagName.toLowerCase() == "img")
                    arrCelData[i-1] = this.options.mainTab.rows[i].cells[0].data;
                else
                    arrCelData[i-1] = null;
            }
        } 
        else
        {
            if(this.options.colStyle[parseInt(colNum)] == "txt")
            {
                for(var i=1; i<this.options.mainTab.rows.length; i++)
                {
                    if(this.options.mainTab.rows[i].cells[colNum].children.length>0)
                        arrCelData[i-1] = this.options.mainTab.rows[i].cells[colNum].children[0].value;
                    else
                        arrCelData[i-1] = this.options.mainTab.rows[i].cells[colNum].innerText;
                }              
            }
            else if(this.options.colStyle[parseInt(colNum)] == "sel")
            {
                for(var i=1; i<this.options.mainTab.rows.length; i++)
                    arrCelData[i-1] = this.options.mainTab.rows[i].cells[colNum].data;
            }
            else
            {
                    for(var i=1; i<this.options.mainTab.rows.length; i++)
                    arrCelData[i-1] = this.options.mainTab.rows[i].cells[colNum].innerText;             
            }
        }
        return arrCelData;     
    },
  //获取指定行的所有数据，以数组形式返回，如果是文本编辑方式，就返回文本内容，
  //如果是下拉框编辑方式，则返回其value值，即td中的data值
  //rowIndex为列号，isImg为是否为图片，如果是图片，则返回图片的id
    getRowData: function(rowIndex){
        var arrRowData = new Array();
        var rowNum = rowIndex == null ? 1 : rowIndex;
        if(/\D/g.test(rowNum)
            || rowNum >= this.options.mainTab.rows.length
             || rowNum <= 0)
            return null;
        for(var i=0; i<this.options.mainTab.rows[rowIndex].cells.length; i++)
        {
            with(this.options.mainTab.rows[rowIndex].cells[i])
            {
                if(children.length > 0)
                {
                    if(children[0].tagName.toLowerCase() == "img")
                        arrRowData[i] = data;
                    else if(children[0].tagName.toLowerCase() == "select")
                        arrRowData[i] = data;
                    else if(children[0].tagName.toLowerCase() == "input")
                        arrRowData[i] = children[0].value;
                    else
                        arrRowData[i] = innerText;
                }
                else
                {
                    if(this.options.colStyle[i] == "sel")
                        arrRowData[i] = data;
                    else
                        arrRowData[i] = innerText;
                }
            }
        }
        return arrRowData;
    },
  //在表格的指定位置插入标记图标，其中，
  //oImg是用来插入的图标对象，
  //rIndex，是没个图标的id，如果一列中要采用不同的标志，该值不可相同
  //nCell,为设置的图标的列，默认为第一列
    insertImg: function(oImg,rIndex,nCell){
        if(nCell == null)
            nCell = 0;
        else
            this.options.imagePos = nCell;

        var sHtml = "<img id=imgIndex_"+rIndex+" src='"+oImg.src+"' width=16 height=16/>";
       
        if(!this.options.currentRowIndex)
        {
            alert("请选中要设置图片的行！");
            return;
        }
       
        //检测所选行已经存在标志时的情况
        if(this.options.mainTab.rows[this.options.currentRowIndex].cells[nCell].children[0])
        {
            if(this.options.mainTab.rows[this.options.currentRowIndex].cells[nCell].children[0].id != "imgIndex_"+rIndex)
                alert("此位置已经存在其它的标志！");
            else
                return;
        }      
        else
        {
            //遍历整个表格，把原始标志还原
            for(var i=0; i<this.options.mainTab.rows.length; i++)
            {
                with(this.options.mainTab.rows[i].cells[nCell])
                {
                    if(children[0] && children[0].id == 'imgIndex_'+rIndex && i!= this.options.currentRowIndex)
                    {
                        innerHTML = "&nbsp;";
                        data = null;
                    }
                }
            }
            //置新标志
            this.options.mainTab.rows[this.options.currentRowIndex].cells[nCell].innerHTML = sHtml;
            this.options.mainTab.rows[this.options.currentRowIndex].cells[nCell].data = rIndex;
        }
    },
    /**
     * 1.移除未修改的隐藏表单控件，不提交到后台
     * 2.提交表单
     * 3.提交成功重新计算存储表格数据（原表格不包含新增的）
     * 4.恢复保存前被清理掉的“隐藏表单控件”
     * 5.提交成功后清理掉"删除行"的主键（删除行的主键放在第一行第一列中）
     * 
     */
    doSave: function () {
        event.cancelBubble=true;
        if(this.options.submitActions.sysName == "" 
            || this.options.submitActions.oprID == ""
                || this.options.submitActions.actions == ""){
            alert("[Jraf.Table][method=doSave]警告:表格提交逻辑[sysName, oprID, actions]的参数未配置或配置不完整。");
            return false;
        }
        this.options.isSuccess = false;
        var oldAction = "";
        var oldActions = "";
        var oldSysName = "";
        var oldOprID = "";
        var oldForward = "";
        if(!this.cleanTable()) return false;
        var formObj = document.forms[this.options.submitForm];
        var retVal = this.cleanData();
        if(retVal == "1"){
            alert("保存失败，存在校验不通过项！");
            this.options.hasClean = false;
        }else if(retVal == "-1"){
            alert("未变动过数据.\n注意：空行将在保存时清除.");
            this.options.hasClean = false;
        }else{//成功
            if(formObj.elements["actions"]==null)$(formObj).insert(new Element("input",{type: "hidden",name: "actions"}));
            if(formObj.elements["sysName"]==null)$(formObj).insert(new Element("input",{type: "hidden",name: "sysName"}));
            if(formObj.elements["oprID"]==null)$(formObj).insert(new Element("input",{type: "hidden",name: "oprID"})); 
            if(formObj.elements["forward"]==null)$(formObj).insert(new Element("input",{type: "hidden",name: "forward"})); 
            oldAction = formObj.action;
            oldSysName = formObj.elements["sysName"].value;
            oldOprID = formObj.elements["oprID"].value;
            oldActions = formObj.elements["actions"].value;
            oldForward = formObj.elements["forward"].value;
            var ajax = new Jraf.Ajax();
            formObj.action = "/xmlprocesserservlet";
            formObj.elements["actions"].value = this.options.submitActions.actions;
            formObj.elements["sysName"].value = this.options.submitActions.sysName;
            formObj.elements["oprID"].value = this.options.submitActions.oprID;
            formObj.elements["forward"].value = this.options.submitActions.forward;
            ajax.submitFormXml(formObj, function(xml){
               try{
                   var pkg = new Jraf.Pkg(xml);
                   //alert(pkg.result());
                   if(pkg.result() != '0'){
                       Jraf.showMessageBox({
                               title:  '提交失败!',
                               text:   '<p class="error">'+pkg.allMsgs('<br>')+'</p>'
                       });
                       return;
                   }
                   this.options.isSuccess = true;
                   Jraf.showMessageBox({
                       title:  '提交成功!',
                       text:       '<p class="success">'+pkg.allMsgs('<br>')+'</p>',
                       onOk: function () {
                                   if(this.options.queryActions.sysName != "" 
                                       || this.options.queryActions.oprID != ""
                                           || this.options.queryActions.actions != ""){
                                       formObj.elements["actions"].value = this.options.queryActions.actions;
                                       formObj.elements["sysName"].value = this.options.queryActions.sysName;
                                       formObj.elements["oprID"].value = this.options.queryActions.oprID;
                                       formObj.elements["forward"].value = this.options.queryActions.forward;
                                   }
                                   formObj.submit();
                               }.bind(this)
                   });
               }catch(e){alert('[Jraf.Table][method=doSave]ERROR:'+e.message);}
            }.bind(this)); 
            formObj.action = oldAction;
            formObj.elements["sysName"].value = oldSysName;
            formObj.elements["oprID"].value = oldOprID;
            formObj.elements["actions"].value = oldActions;
            formObj.elements["forward"].value = oldForward;
            
        }
        //恢复清除过的可编辑项隐藏表单控制，用于提交“修改数据”
        $A(this.options.mainTab.rows).each(function (obj){
            if(obj.rowIndex > 0){
                if(this.options.orgTableValue[obj.rowIndex] == null){
                    //新增和删除了的数据在数组中不存在
                    return;
                }
                obj.cells[0].innerHTML = this.options.orgTableValue[obj.rowIndex][0];
            }
        }.bind(this));
    },
    /**
     * 
     */
    cleanData: function () {
        var oRows = this.options.mainTab.rows;
        var tempObj = null;
        var keyObjs = null;
        var editObjs = null;
        var addObjs = null;
        var isBlank = null;                //判断新增行的数据是否全为空，为空则清除
        var unCheck = false;            //新增行的校验是否通过
        var returnVal = 0;                //0成功，1存在校验不通过项，-1未变动过表格数据
        var unEditRowData = true;        //判断初始的表格数据是否有被修改（不包含新增和删除的变动）
        for (var i = oRows.length - 1 ; i > 0; i-- ){
            tempObj = oRows[i];
            isBlank = true;
            /*
             * 删除未修改行的隐藏表单
             */
            //判断当前行是否有修改的数据，无则继续
            if(this.options.tableEditRows[i] != null){
                unEditRowData = false;
                continue;
            }
            //查找后缀为“_key”的元素
            keyObjs = $(tempObj).select('input[type="hidden"][name$="_key"]');
            //查找后缀为“_edit”的元素
            editObjs =  $(tempObj).select('input[type="hidden"][name$="_edit"]');
            if( (keyObjs != null && keyObjs.length > 0) || (editObjs != null && editObjs.length > 0)){
                keyObjs.each(function (obj){
                    $(obj).remove();
                });
                editObjs.each(function (obj){
                    $(obj).remove();
                });
                continue;
            }//if 
            /*
             * 删除新增的全无数据的行的隐藏表单
             */
            addObjs = $(tempObj).select('input[type="hidden"][name$="_add"]');
            if(addObjs != null && addObjs.length > 0){
                addObjs.each(function (obj){
                    if(obj.value.trim() != ""){
                        isBlank = false;
                        throw $break;
                    }
                });
                if(isBlank){
                    addObjs.each(function (obj){
                        $(obj).remove();
                    });
                    this.options.mainTab.deleteRow(i);
                }else{
                    $A(tempObj.cells).each(function (obj) {
                        if(this.options.colStyle[parseInt(obj.cellIndex)] == 'txt' ){
                            this.editCell(this.options.mainTab, obj, 'txt',true); 
                            if (!checkForm(document.forms[this.options.submitForm]))
                            {
                                this.options.currentRowIndex = obj.parentNode.rowIndex;
                                this.options.currentCell= obj;
                                unCheck = true;
                                throw $break;
                            }
                            var oCurCell = obj;
                            //清除可编辑表格
                            if(oCurCell!=null)
                            {
                                if (oCurCell.children.length>0 )
                                {
                                    if(oCurCell.children[0].tagName.toLowerCase() == "input"
                                        && oCurCell.children[0].type == "text"){
                                        oCurCell.innerText=oCurCell.children[0].value;//.replaceHTML();
                                    }else if(oCurCell.children[0].tagName.toLowerCase() == "select"){
                                        oCurCell.innerText=oCurCell.children[0].options[oCurCell.children[0].selectedIndex].text;
                                    }
                                }
                            }
                        }
                    }.bind(this));
                    if(unCheck){
                        returnVal = 1;
                        break;
                    }
                }
            }//if
        }//end for
        var temp = $(this.options.mainTab).select('input[type="hidden"][name$="_add"]'
                                                      ,'input[type="hidden"][name$="_del"]');
        if(temp.size() == 0 && unEditRowData){
            returnVal = -1;
        }
        return returnVal;
    }
});
/**
 * 
 * Logs:
 * MOD{yangx@2013-03-06}: clickTab方法， 修改Event.element(event) -> Event.findElement(event, "li");
 * MOD{yangx@2013-03-18}: 增加根据li上targetid属性值，自动初始化displayID的值 
 * MOD{yangx@2013-04-16}: 增加li属性callback，用于回调函数
 */
//create by dailihui
Jraf.Tabs = Class.create
(
    {
        initialize: function(options)
        {
            if(Object.isString(options)){
                options = {tabid: options};
            }
            this.options =
            {
                tabid: "tabs",
                displayStyle: "div",        //分div 或 iframe
                displayID: null,            //tab对应内容显示的位置id, 默认为空
                ajaxObj: new Jraf.Ajax(),   //Ajax 抽象类
                tabsObj: null,              //选项卡对象 是个数组      initTabs方法初始化
                tabsNum: null,              //选项卡的数量                 initTabs方法初始化
                currTabNo: 0,               //当前显示的选择卡的编号
                doActionData: [],           //每个选项卡的事件内容    addAction方法初始化
                currActionData: null,       //当点击TAB时候的事件
                currTabRefresh: true,       //当点击TAB时候是否刷新页面（调用doActionData 方法）。默认是刷新
                globalRefresh: true,        //全局TAB页面的DIV是否刷新(默认清除其他tab内容)。
                                            //可以解决多个DIV具有相同的ID或function问题。
                callBacks: {}               //第个选择卡的回调函数集合
            };
            Object.extend(this.options, options || { });
            this.initTabs();
        },
        initTabs : function()
        {
            //判断ID的合法性以及初始化tabsObj、tabsNum数据
            if(! $(this.options.tabid))
            {
                alert("未找到ID为 " + this.options.tabid + "的UL对象");
                return false;
            }
            this.options.tabsObj = $(this.options.tabid).getElementsByTagName("li");
            if(! this.options.tabsObj )
            {
                alert("未找到配置了targetid属性的 LI对象。");
                return false;
            }
            //初始化thid.options.displayID
            if (this.options.displayID == null) {
                this.options.displayID = { };
                var targetId = null;
                $A(this.options.tabsObj).each(function (obj) {
                    targetId = $(obj).readAttribute("targetid");
                    this.options.displayID[targetId] =  targetId;
                    this.options.callBacks[targetId] = $(obj).readAttribute("callback");
                }.bind(this));
            }
            if(this.options.displayStyle.toLowerCase() == "div")
            {
                if(Object.isString(this.options.displayID))
                {
                    if( (!$(this.options.displayID)) || $(this.options.displayID).tagName != "DIV" )
                    {
                        alert("未找到targetid属性配置的ID为："+this.options.displayID + " 的DIV对象");
                    }
                }
                else
                {
                    Object.values(this.options.displayID).each(
                    function(e){
                        if( (!$(e)) || $(e).tagName != "DIV" )
                        {
                            alert("未找到targetid属性配置的ID为："+ e + " 的DIV对象");
                        }
                    }        
                    );
                }
                
            }
            else
            {
                if( (!$(this.options.displayID)) || $(this.options.displayID).tagName != "IFRAME" )
                {
                    alert("未找到targetid属性配置的ID为："+this.options.displayID + " IFRAME的对象");
                }
            }
            this.options.tabsNum = this.options.tabsObj.length;
            //绑定每个TAB的click事件
            for(var i=0;i<this.options.tabsNum;i++)
            {
                Event.observe(this.options.tabsObj[i],"click",this.clickTab.bind(this));
            }
            
        },
        clickTab : function(event)
        {
            //var currentObject = Event.element(event);
            var currentObject = Event.findElement(event, "li");
            var firstObject = null;
            for(var i=0;i<this.options.tabsNum;i++)
            {
                if(i == 0) {
                    this.options.tabsObj[i].removeClassName("first");
                    firstObject = this.options.tabsObj[0];
                } else 
                    this.options.tabsObj[i].removeClassName("on");
                
                if(this.options.tabsObj[i].readAttribute("targetid") == currentObject.readAttribute("targetid"))
                {
                    this.options.currActionData = this.options.doActionData[i];
                    this.options.currTabNo = i;
                }
                
            }
            if (firstObject.readAttribute("targetid") == currentObject.readAttribute("targetid")) {
                currentObject.addClassName("first");
            } else {
                currentObject.addClassName("on");
            }
            if(this.options.currActionData == null)
            {
                alert("未设置TAB事件");
                if(Object.isString(this.options.displayID))
                {
                    if(this.options.displayStyle.toLowerCase() == "div")
                    {
                        $(this.options.displayID).innerHTML = "";
                    }
                    else
                    {
                        $(this.options.displayID).src = "";
                    }
                }
                else
                {
                    Object.values(this.options.displayID).each
                    (
                        function(e)
                        {
                            $(e).innerHTML = "";
                        }
                    );
                }
                return;
            }
            if(this.options.globalRefresh == true)
            {
                //刷新所有DIV的内容为空
                if(Object.isString(this.options.displayID))
                {
                    if(this.options.displayStyle.toLowerCase() == "div")
                    {
                        $(this.options.displayID).innerHTML = "";
                    }
                    else
                    {
                        $(this.options.displayID).src = "";
                    }
                }
                else
                {
                    Object.values(this.options.displayID).each
                    (
                        function(e)
                        {
                            $(e).innerHTML = "";
                        }
                    );
                }
            }
            //获取当前TAB的事件的结果
            var funcdata = null;
            var currDIV = null;
            if(this.options.displayStyle.toLowerCase() == "div")
            {
                if(Object.isString(this.options.displayID))
                {
                    currDIV = this.options.displayID;
                }
                else
                {
                    //注意加单引号
                    eval("currDIV = this.options.displayID['"+currentObject.readAttribute("targetid")+"']");
                }
                //如果是多DIV的情况需要先把所有的DIV都隐藏起来。
                if(!Object.isString(this.options.displayID))
                {
                    Object.values(this.options.displayID).each
                    (
                        function(e)
                        {
                            $(e).hide();
                        }
                    );
                }
                //显示DIV
                $(currDIV).show();
                if( (this.options.currTabRefresh == false) && (this.options.globalRefresh == false) )
                {
                    $(currDIV).show();
                    return;
                }
                $(currDIV).innerHTML = "<span class='loading'>正在加载...</span>";
                if(Object.isFunction(this.options.currActionData))
                {
                    funcdata = this.options.currActionData.apply(this,arguments);
                    if (funcdata != null) {//存在返回值
                        $(currDIV).innerHTML = funcdata;
                        //增加回调函数
                        var oCall = this.options.callBacks[currentObject.readAttribute("targetid")];
                        if (oCall != null) {
                            try {
                                eval(oCall); 
                            } catch (e) {
                                alert("[Jraf.Tabs][method=clickTab]警告：调用回调函数出错：" + e.message);
                            }
                        }
                    }
                }
                else
                {
                    var actionurl = this.options.currActionData.url;
                    if(!actionurl)
                    {
                        actionurl = "/httpprocesserservlet";
                    }
                    this.options.ajaxObj.loadPageTo(
                        actionurl, 
                        this.options.currActionData, 
                        currDIV, 
                        //增加回调函数
                        function (){eval(this.options.callBacks[currentObject.readAttribute("targetid")]);}.bind(this)
                    );
                }

            }
            else
            {
                funcdata = this.options.currActionData;
                $(this.options.displayID).src = funcdata;
                //增加回调函数
                var oCall = this.options.callBacks[currentObject.readAttribute("targetid")];
                if (oCall != null) {
                    $(this.options.displayID).observe("load", function (){
                        try {
                            eval(oCall); 
                        } catch (e) {
                            alert("[Jraf.Tabs][method=clickTab]警告：调用回调函数出错：" + e.message);
                        }
                    });
                }
            }

        },
        addAction : function(indexNum,callObject)
        {
            if(!Object.isNumber(indexNum))
            {
                alert("第一个参数必须是数字");
            }
            if(indexNum > this.options.tabsNum)
            {
                alert("添加失败，因为最多只有" + this.options.tabsNum +"个选项卡");
                return;
            }
            if(Object.isFunction(callObject))
            {
                this.options.doActionData[indexNum-1] = callObject;
            }
            else
            {
                this.options.doActionData[indexNum-1] = Object.clone(callObject);
            }
            
        },             //addAction 结束
        init : function(indexNum)
        {
            if(indexNum > this.options.tabsNum)
            {
                alert("添加失败，因为最多只有" + this.options.tabsNum +"个选项卡");
                return;
            }
            this.options.tabsObj[indexNum-1].click();
        },               //init 结束
        refresh : function(indexNum,currTabRefresh)
        {
            this.options.currTabRefresh = currTabRefresh;
            if(indexNum > this.options.tabsNum)
            {
                alert("添加失败，因为最多只有" + this.options.tabsNum +"个选项卡");
                return;
            }
            var refreshTab = this.options.tabsObj[indexNum-1];
            refreshTab.click();
        },  //refresh 结束
        refreshCurrentTab : function()
        {
            var refresh = this.options.currTabRefresh;
            this.options.currTabRefresh = true;
            var refreshTab = this.options.tabsObj[this.options.currTabNo];
            refreshTab.click();
            this.options.currTabRefresh = refresh;
        },  //refresh 结束
        changeAction : function(indexNum,callObject)
        {
            if(!Object.isNumber(indexNum))
            {
                alert("第一个参数必须是数字");
            }
            if(indexNum > this.options.tabsNum)
            {
                alert("添加失败，因为最多只有" + this.options.tabsNum +"个选项卡");
                return;
            }
            if(Object.isFunction(callObject))
            {
                this.options.doActionData[indexNum-1] = callObject;
            }
            else
            {
                var changeObj =  Object.clone(callObject);
                Object.extend(this.options.doActionData[indexNum-1], changeObj);
            }
        }
        
    }
);

/**
 * 选项卡
 * 
 * <div id="tab">
 *  <ul id="menus-tab">
 *    <li jraf_tabid=""          <!-- 主要的识别id
 *        jraf_init="true|false" <!--是否初始化显示的选项卡-->
 *        jraf_url=""            <!-- 加载页面的地址-->
 *        jraf_sysName=""        <!-- jraf系统的sysName-->
 *        jraf_oprID=""          <!-- jraf系统的oprID-->
 *        jraf_actions=""        <!-- jraf系统的actions-->
 *        jraf_params=""         <!-- 查询参数，可使用模板如 a=#{reptdt}&b=3 -->
 *        jraf_type="div(默认)|iframe" <!-- 页面显示到指定类型的容器中 -->
 *        
 *        jraf_callback="FUN"   <!-- 加载页面后执行的回调函数-->
 *        jraf_onBeforeClick="FUN"<!-- 调用点击选项卡事件之前执行的函数 -->
 *        jraf_onAfterClick="FUN"<!-- 调用点击选项卡事件之后执行的函数 -->
 *        jraf_refresh="true（默认）|false" >选项卡1</li>
 *    <li ...>选项卡2</li>
 *  </ul>
 * </div>
 * var oTab = new Jraf.NewTabs("menus-tab");
 * 
 * li属性特别说明：
 *     jraf_init: 初始化最后一个li配置为true的选项卡。如果都未配置此属性则初始化第一个
 *     jraf_refresh: 表示点击选项卡时，是否重新加载页面。 
 *     jraf_type： 选项卡显示内容的地方，如显示到一个div中。
 * 常用方法：
 *     getCurrentTabId(): 获取当前激活的tabid
 *     getTabContentObj(tabid): 获取选项卡显示内容div/iframe对象
 *     changeParam(tabid, attrs): 说明见方法注解
 *     refresh(tabid): 临时刷新页面。tabid值为空时，刷新当前tab页面，否则刷新指定的
 *     toggleTabById(tabid): 切换显示指定的选项卡
 *     getFormElementById(formId): 根据表单控件名称，获取表单对象
 *     getFormElementByName(formName): 根据表单控件名称，获取表单对象集合
 *     getCurrentTabForms(tabid): 获取指定(或当前)选项卡内容容器中的表单元素值
 *     setHeightAuto(): 根据tab选项卡的上级节点高度自动适应显示内容高度
 * @author Sean
 * @createdate 2013-05-21
 * @histroy:
 *     2015-03-13: 修复自动设置内容高度的bug
 */
Jraf.NewTabs = Class.create(
{
    initialize: function(options)
    {
        if(Object.isString(options)){
            options = {tabMainId: options};
        }
        this.options =
        {
            tabMainId: "tabs",
            ajaxObj: new Jraf.Ajax(),   //Ajax 抽象类
            tabsObj: null/*{'tabid1': {
                jraf_tabid: '',
                jraf_init: null,
                jraf_url: null,
                jraf_sysName: null,
                jraf_oprID: null,
                jraf_actions: null,
                jraf_params: null,
                jraf_type: null,
                jraf_callback: null,
                jraf_onBeforeClick: null,
                jraf_onAfterClick: null,
                jraf_refresh: null
            }, "tabid2":{}}*/,          //选项卡对象 是个数组      initTabs方法初始化
            tabsNum: null,              //选项卡的数量                 initTabs方法初始化
            currTabId: null,            //当前显示的选择卡的jraf_tabid
            firstTabId: null,           //第一个li的选项卡jraf_tabid
            setHeightAuto: true         //是否根据上级元素高度，自适应tab显示内容块高度
        };
        this.errmsg = "[Jraf.NewTabs]";
        Object.extend(this.options, options || { });
        this.initTabs();
    },
    initTabs : function()
    {
        var methodmsg="[method=initTabs]";
        //判断ID的合法性以及初始化tabsObj、tabsNum数据
        if(!$(this.options.tabMainId))
        {
            alert(this.errmsg + methodmsg + "未找到ID为 " + this.options.tabMainId + "的UL对象");
            return false;
        }
        //创建main content div
        var upObj = $(this.options.tabMainId).up(0);
        var visible = true;
        if (!upObj.visible()) {//如果隐藏，为获得正确高度，先显示
            visible = false;
            upObj.show();
        }
        
        var displayDivObj = upObj.down(".content");
        if (!displayDivObj) {
            displayDivObj = new Element("div").addClassName("content");
        } else {
            //清除内容
            displayDivObj.innerHTML="";
        }
        if (upObj.style.pixelHeight !== 0 
                && this.options.setHeightAuto === true) {
            var height = upObj.getHeight() - $(this.options.tabMainId).getHeight();
            displayDivObj.setStyle({height: (height -4)+"px"});
        }
        
        if (!visible) {//恢复隐藏状态
            upObj.hide();
        }
        
        upObj.insert(displayDivObj);
        
        //初始化每个tab的参数
        this.options.tabsObj = {};
        var liArr = $(this.options.tabMainId).select("li[jraf_tabid]");
        liArr.each(function (obj) {
            //保存参数
            this.__setAttribute(obj);
            
            //增加事件
            Event.observe(obj, "click", this.clickTab.bind(this));
            
            //根据jraf_type值，创建显示块
            var tabid = Element.readAttribute(obj, "jraf_tabid");
            var tabContentId = "__JRAF_NewTab_"+tabid+"_content";
            var type = Element.readAttribute(obj, "jraf_type") || "";
            type = type.trim() || "div";
            if (type.toUpperCase() === "IFRAME") {
                displayDivObj.insert(new Element("iframe", {
                    id: tabContentId,
                    src: "",
                    frameborder: 0,
                    marginheight: 0,
                    marginwidth: 0,
                    height: 100,
                    width: "100%"
                }).hide());
            } else {
                displayDivObj.insert(new Element("div", {
                    id: tabContentId
                }).hide());
            }
        }, this);
        if(liArr.size() === 0 )
        {
            alert(this.errmsg + methodmsg + "未找到配置了jraf_tabid属性的 LI对象。");
            return false;
        }
        //初始化最后一个设置了jraf_init=true的li，否则初始化第一个
        if (this.options.currTabId == null) {
            this.options.currTabId = Element.readAttribute(liArr[0], "jraf_tabid");
        }
        this.options.tabsNum=liArr.size();
        this.options.firstTabId = Element.readAttribute(liArr[0], "jraf_tabid");
        //alert("this.options.firstTabId="+this.options.firstTabId)
        
        //初始化tab
        $(this.options.tabsObj[this.options.currTabId].__id).click();
    },
    /**
     * 私有方法
     * 保存参数值
     */
    __setAttribute: function (obj) {
        var tabid = Element.readAttribute(obj, "jraf_tabid");
        if (tabid === null || tabid === "") {
            return;//continue;
        }
        var attrs = {};
        attrs["jraf_tabid"]=tabid;
        if (obj.id == ""){
            obj.id = "__JrafNewTab_li_" + tabid + "_id";
        }
        attrs["__id"]=obj.id;
        
        var initTab = Element.readAttribute(obj, "jraf_init");
        if (initTab === "true") {
            this.options.currTabId = tabid;
        }
        
        attrs["jraf_url"] = Element.readAttribute(obj, "jraf_url");
        attrs["jraf_sysName"] = Element.readAttribute(obj, "jraf_sysName");
        attrs["jraf_oprID"] = Element.readAttribute(obj, "jraf_oprID");
        attrs["jraf_actions"] = Element.readAttribute(obj, "jraf_actions");
        //attrs["jraf_params"] = Jraf.BlockAttribute.getParams(Element.readAttribute(obj, "jraf_params"));
        attrs["jraf_params"] = Element.readAttribute(obj, "jraf_params");
        
        var type = Element.readAttribute(obj, "jraf_type") || "";
        type = type.trim() || "div";
        attrs["jraf_type"] = type;
        
        attrs["jraf_callback"]=Element.readAttribute(obj, "jraf_callback");
        attrs["jraf_onBeforeClick"]=Element.readAttribute(obj, "jraf_onBeforeClick");
        attrs["jraf_onAfterClick"]=Element.readAttribute(obj, "jraf_onAfterClick");
        
        var refresh = Element.readAttribute(obj, "jraf_refresh") || "";
        attrs["jraf_refresh"]= refresh.trim() || "true";
        
        this.options.tabsObj[tabid] = attrs;
        //alert("this.options.tabsObj[tabid]"+$H(this.options.tabsObj[tabid]).inspect())
    },
    /**
     * 清理已激活的选项卡样式
     */
    __cleanActiveTabStyle: function () {
        var firstTabId = this.options.firstTabId;
        var firstObject = $(this.options.tabsObj[firstTabId].__id);
        //清理样式
        $(this.options.tabMainId).select("li[jraf_tabid]").each(function (obj) {
            var tabId = Element.readAttribute(obj, "jraf_tabid");
            if(tabId === firstTabId) {
                firstObject.removeClassName("first");
            } else {
                $(this.options.tabsObj[tabId].__id).removeClassName("on");
            }
        }, this);
    },
    /**
     * 1.清理除当前选项卡外的jraf_refresh=true的选项卡内容容器
     * 2.当jraf_refresh=false时，启用当前的表单控件，禁用其他的
     */
    __cleanOthersTabContent: function () {
        var arrs = $H(this.options.tabsObj).keys();
        var tabObjKey = null;
        var tabObj = null;
        for (var i = 0, len = arrs.length; i < len; i ++) {
            tabObjKey = arrs[i];
            tabObj = this.options.tabsObj[tabObjKey];
            if (tabObjKey === this.options.currTabId) {
                if (tabObj["jraf_refresh"] === "false") {
                    this.__enabledFormElement( this.getTabContentObj(tabObjKey));
                }
                continue;
            }
            if (tabObj["jraf_refresh"] === "true") {
                $(tabObj["__id"]).writeAttribute("__JrafNewTabs_loaded", "false");
                
                var type = tabObj["jraf_type"];
                type = type.trim() || "div";
                if (type.toUpperCase() === "IFRAME") {
                    this.getTabContentObj(tabObjKey).src="";
                } else {
                    this.getTabContentObj(tabObjKey).innerHTML="";
                }
            } else {
                this.__disabledFormElement( this.getTabContentObj(tabObjKey));
            }
        }
    },
    __setIframeHeight: function (obj) {
        try {
            //设置iframe的内容高度
            var bHeight = obj.contentWindow.document.documentElement.scrollHeight;
            var bWidth = obj.contentWindow.document.documentElement.scrollWidth;
            
            bHeight = Math.max(bHeight, obj.contentWindow.document.body.scrollHeight);
            bWidth = Math.max(bWidth, obj.contentWindow.document.body.scrollWidth);
            obj.setStyle({width: bWidth + "px", height: bHeight + "px"});
        } catch(e){}
    },
    __disabledFormElement: function (scope) { 
        Jraf.FormUtil.disabledFormElement(scope);
    },
    __enabledFormElement: function (scope) { 
        Jraf.FormUtil.enabledFormElement(scope);
    },
    /**
     * 获取当前激活的选项卡tabid
     */
    getCurrentTabId: function () {
        return this.options.currTabId;
    },
    /**
     * 获取选项卡显示内容div对象
     */
    getTabContentObj: function (tabid) {
        return $("__JRAF_NewTab_"+tabid+"_content");
    },
    clickTab : function(event)
    {
        var methodmsg="[method=clickTab]";
        //var currentObject = Event.element(event);
        var currentObject = Event.findElement(event, "li");
        var cuurTabId = currentObject.readAttribute("jraf_tabid");
        var currTabAttrs = this.options.tabsObj[cuurTabId];
        var currTabContentObj = this.getTabContentObj(cuurTabId);
        
        //清理样式
        this.__cleanActiveTabStyle();
        
        //增加点击激活后的样式
        if (this.options.firstTabId == cuurTabId) {
            currentObject.addClassName("first");
        } else {
            currentObject.addClassName("on");
        }
        
        //切换显示内容为当前激活的
        this.getTabContentObj(this.options.currTabId).hide();
        currTabContentObj.show();
        this.options.currTabId = cuurTabId;
        
        //清除选项卡内容
        this.__cleanOthersTabContent();
        
            
        //执行点击事件之前事件
        try {
            var __beforResult = eval(currTabAttrs["jraf_onBeforeClick"]);
            if(__beforResult!=null && __beforResult==false)
                return;
        } catch(e) {
            alert(this.errmsg + methodmsg 
                    + "[jraf_tabid=" + cuurTabId +"]JSERROR: 执行jraf_onBeforeClick时报错： " + e.message);
        }
        
        //判断是否刷新，重新加载
        if (currTabContentObj.readAttribute("__JrafNewTabs_loaded") === "true" 
                && currTabAttrs["jraf_refresh"] !== "true") {
            //执行点击事件之后事件
            try {
                eval(currTabAttrs["jraf_onAfterClick"]);
            } catch(e) {
                alert(this.errmsg + methodmsg 
                        + "[jraf_tabid=" + cuurTabId +"]JSERROR: 执行jraf_onAfterClick时报错： " + e.message);
            }
            return;
        }
        currTabContentObj.writeAttribute("__JrafNewTabs_loaded", "true");
        //显示加载中
        Jraf.BlockAttribute.loading(currTabContentObj);
        
        //执行点击事件加载页面
        var sysParams = {submitDivId: currTabContentObj.id };//自动构造列表分页的必须参数
        //构造系统参数
        sysParams["sysName"] = currTabAttrs["jraf_sysName"];
        sysParams["oprID"] = currTabAttrs["jraf_oprID"];
        sysParams["actions"] = currTabAttrs["jraf_actions"];
        sysParams = $H(sysParams).toQueryString();
        
        var params = sysParams;
        var jrafParams = "";
        if (currTabAttrs["jraf_params"]) {
            jrafParams = Jraf.BlockAttribute.getParams(currTabAttrs["jraf_params"]);
            params += "&" + jrafParams;
        }
        //alert("[click]params： " + params)
        //iframe
        if (currTabAttrs["jraf_type"].toUpperCase() === "IFRAME") {
            var url = currTabAttrs["jraf_url"];
            if (url.lastIndexOf("?") != -1) {
                if (url.charAt(url.length -1) == "&") {
                    url += jrafParams;
                } else {
                    url += "&" + jrafParams;
                }
            } else {
                url += "?" + jrafParams;
            }
            currTabContentObj.observe("load", function () {
                //增加回调函数
                try {
                    eval(currTabAttrs["jraf_callback"]);//执行回调
                } catch (e) {
                    alert("[Jraf.NewTab][method=clickTab][callback=" 
                            + currTabAttrs["jraf_callback"] + "]调用回调函数出错：" + e.message);
                }
                //执行点击事件之后事件
                try {
                    eval(currTabAttrs["jraf_onAfterClick"]);
                } catch(e) {
                    alert(this.errmsg + methodmsg 
                            + "[jraf_tabid=" + cuurTabId +"]JSERROR: 执行jraf_onAfterClick时报错： " + e.message);
                }
                //设置高度
                this.__setIframeHeight(currTabContentObj);
            }.bind(this));
            currTabContentObj.src = url+"&s_time="+(new Date().getTime());
            return;
        }
        //显示内容容器为DIV时
        this.options.ajaxObj.loadPageTo(
            currTabAttrs["jraf_url"] || "/httpprocesserservlet", 
            params, 
            currTabContentObj.id, 
            function () {
                try {
                    eval(currTabAttrs["jraf_callback"]);//执行回调
                } catch (e) {
                    alert("[Jraf.NewTab][method=clickTab][callback=" 
                            + currTabAttrs["jraf_callback"] + "]调用回调函数出错：" + e.message);
                }
                //执行点击事件之后事件
                try {
                    eval(currTabAttrs["jraf_onAfterClick"]);
                } catch(e) {
                    alert(this.errmsg + methodmsg 
                            + "[jraf_tabid=" + cuurTabId +"]JSERROR: 执行jraf_onAfterClick时报错： " + e.message);
                }
            }.bind(this)
        );
    },
    /**
     * @param tabId li的jraf_tabid
     * @param attrs key:value键值对。如：{jraf_url: "/a.jsp"}
     *              属性名，可修改的参数有jraf_url、jraf_sysName、
     *              jraf_oprID、jraf_actions、jraf_params、jraf_refresh
     *              jraf_callback、jraf_onBeforeClick、jraf_onAfterClick
     */
    changeParam: function (tabId, attrs) {
        var methodmsg="[method=changeParam]";
        if (!Object.isHash($H(attrs)) 
                || null === attrs["__id"]
                    || null === attrs["jraf_tabid"]
                        || null === attrs["jraf_type"]
                            || null === attrs["__jraf_url"]
                                || null === attrs["__jraf_params"]
                                    || null === attrs["jraf_init"]) {
            alert(this.errmsg + methodmsg + "ERROR: 可以修改的参数有jraf_url、"
                    + "jraf_sysName、jraf_oprID、jraf_actions、jraf_params、" 
                    + "jraf_refresh、jraf_callback、jraf_onBeforeClick、"
                    + "jraf_onAfterClick。");
            return;
        }
        if (this.options.tabsObj[tabId] == null) {
            alert(this.errmsg + methodmsg + "ERROR: 请确认tabId参数的正确性。");
            return;
        }
        //查询参数的特殊处理
        if (!!attrs["jraf_params"]) {
            attrs["jraf_params"] = Jraf.BlockAttribute.getParams(attrs["jraf_params"]);
        }
        Object.extend(this.options.tabsObj[tabId], attrs || { });
        //alert("change: this.options.tabsObj[tabid]"+$H(this.options.tabsObj[tabid]).inspect())
    },
    /**
     * 临时刷新
     * @param tabid 值为空时，刷新当前tab页面，否则刷新指定的
     */
    refresh: function (tabid) {
        if (tabid != null
                && this.options.tabsObj[tabid] == null) {
            alert(this.errmsg + "[method=refresh]传入的参数有误，未被初始化： jraf_tabid="+tabid);
            return;
        }
        var currTabId = tabid || this.options.currTabId;
        this.options.currTabId = currTabId;
        var currTabContentObj = this.getTabContentObj(currTabId);
        currTabContentObj.writeAttribute("__JrafNewTabs_loaded", "false");
        $(this.options.tabsObj[currTabId].__id).click();
    },
    /**
     * 切换显示指定的选项卡
     * （根据jraf_refresh参数判断是否重新加载页面内容）
     * @param tabid 选项卡id
     */
    toggleTabById: function (tabid) {
        if (tabid == null
                || this.options.tabsObj[tabid] == null) {
            alert(this.errmsg + "[method=refresh]传入的参数有误，未被初始化： jraf_tabid="+tabid);
            return;
        }
        $(this.options.tabsObj[tabid].__id).click();
    },
    /**
     * 根据表单控件名称，获取表单对象
     * @param  formId 表单Id
     * @param  tabId 指定tabId
     * @return 对象或null
     */
    getFormElementById: function (formId, tabId) {
        if (!formId) 
            return null;
        var currTabId = tabId || this.options.currTabId;
        var currTabContentObj = this.getTabContentObj(currTabId);
        var formElement = currTabContentObj.down("[id="+formId+"]");
            
        return formElement;
    },
    /**
     * 根据表单控件名称，获取表单对象集合
     * @param  formName 表单名称
     * @param  tabId 指定tabId
     * @return 数组或null
     */
    getFormElementByName: function (formName, tabId) {
        if (!formName) 
            return null;
        var currTabId = tabId || this.options.currTabId;
        var currTabContentObj = this.getTabContentObj(currTabId);
        var formElements = currTabContentObj.select("[name="+formName+"]");
        
        return formElements;
    },
    /**
     * 获取指定(或当前)选项卡内容容器中的表单元素值
     * @param tabid 选项卡标签id， 为空时，取当前
     * @return JSON对象
     */
    getCurrentTabForms: function (tabid) {
        if (tabid != null
                && this.options.tabsObj[tabid] == null) {
            alert(this.errmsg + "[method=refresh]传入的参数有误，未被初始化： jraf_tabid="+tabid);
            return;
        }
        var currTabId = tabid || this.options.currTabId;
        var currTabContentObj = this.getTabContentObj(currTabId);
        var formElements = currTabContentObj.select("input", "select", "textarea");
        var ele = null;
        var formsJSON = {};
        for (var i = 0, len = formElements.length; i < len; i ++) {
            ele = formElements[i];
            
            //下拉框多选情况
            if (ele.tagName.toLowerCase() == "select" 
                && ele.multiple === true) {
                var options = ele.options;
                var combine = "";
                $A(options).each(function (obj) {
                    if (obj.selected === true) {
                        combine += obj.value + ",";
                    }
                });
                if (combine != "" && combine.charAt(combine.length - 1) == ",") {
                    combine = combine.substring(0, combine.length - 1);
                }
                if (formsJSON[ele.name] == null) {
                    formsJSON[ele.name] = combine;
                } else {
                    formsJSON[ele.name] += "," + combine;
                }
                continue;
            }
            
            //单选框和复选框，取checked=true的value值，如有多个值用逗号“,”分隔
            if (ele.type.toLowerCase() == "radio"
                    && ele.type.toLowerCase() == "checkbox") {
                if (ele.checked === true) {
                    if (formsJSON[ele.name] == null) {
                        formsJSON[ele.name] = ele.value;
                    } else {
                        formsJSON[ele.name] += "," + ele.value;
                    }
                }
                continue;
            }
            
            //其他情况
            if (formsJSON[ele.name] == null) {
                formsJSON[ele.name] = ele.value;
            } else {
                formsJSON[ele.name] += "," + ele.value;
            }
        }// end for
        return formsJSON;
    },
    /**
     * 根据tab选项卡的上级节点高度自动适应显示内容高度
     * @createtime 2014-11-04
     */
    setHeightAuto: function () {
        var upObj = $(this.options.tabMainId).up(0);
        var visible = true;
        if (!upObj.visible()) {//如果隐藏，为获得正确高度，先显示
            visible = false;
            upObj.show();
        }
        var displayDivObj = upObj.down(".content");
        if (!displayDivObj)
            return;
        if (upObj.style.pixelHeight !== 0 
                && this.options.setHeightAuto === true) {
            var height = upObj.getHeight() - $(this.options.tabMainId).getHeight();
            displayDivObj.setStyle({height: height+"px"});
        }
        
        if (!visible) {//恢复隐藏状态
            upObj.hide();
        }
    }
});

/**
 * 文本框输入字符时，下拉框提示输入数据
 */
//create by dailihui
Jraf.DivSelector = Class.create
(
  {
      initialize:function(options)
      {
        if(Object.isString(options))
        {
            options = {selector: options};
        }
        this.options = 
        {
            selector: null,                 //文本框对象或对象Id
            dspNameId: null,                //显示中文解释的对象ID
            pageSize : 10,                  //显示记录数。默认10条
            objouter : null,                //显示的DIV对象
            selectobj : null,               //输入文本框对象
            selectedIndex : -1,             //DIV框的坐标
            divkey : "value",               //取下拉框选择值的key
            divlabel : "name",              //取下拉框选择名称的key
            divparams : "params",           //取下拉框附带其他条件的key(多个参数可以以&分隔)
            cursorIndex: 0                  //文本框和文本域光标的位置
        };
        Object.extend(this.options, options || { });
        this.initDivselector();
      },//initialize结束
      
      /**
       * 初始化
       */
      initDivselector :  function()   //初始化Jraf.divselector 函数
      {
          if(this.options.selector == null || $(this.options.selector) == null)
          {
              alert("初始化divselector失败，没有找到 " +this.options.selector +" 的文本框");
              return;
          }
          //初始化对象内容
          this.options.objouter = '__' + this.options.selector;
          this.options.selectobj = $(this.options.selector);
          //绑定文本框事件
          this.options.selectobj.observe("blur",  //文本框失去焦点
                  function(e)
                  {
                      event.cancelBubble = true;
                      if (!$(this.options.objouter).visible()) {
                          var ele = $(Event.element(e)).up("#"+this.options.objouter);
                          if (!ele) {
                              if($(this.options.dspNameId)) {
                                  var nameTxt = this.getSelectDataName();
                                  if ($(this.options.dspNameId).value) {
                                      $(this.options.dspNameId).value = (nameTxt == 'false')?"":nameTxt;
                                  } else {
                                      $(this.options.dspNameId).innerText = (nameTxt == 'false')?"":nameTxt;
                                  }
                              }
                              this.toggleDiv(false);      //隐藏
                              this.showElement("SELECT");
                              this.showElement("OBJECT");
                          }
                      }
                  }.bind(this)
          );
          //绑定文本框事件
          this.options.selectobj.observe("keydown",  //文本框按键按下
                  function (e) 
                  {
                      event.cancelBubble = true;
                      if (!$(this.options.objouter).visible()) {
                          return;//下拉框显示时，可以往下执行
                      }
                      var ie = (document.all)? true:false;
                      if(ie)
                      {
                          var userkey = e.keyCode;
                          //按↑和↓选择下拉框div选项值
                          if(userkey == 40 || userkey == 38) //下上
                          {
                              if(userkey == 40)
                              {
                                  this.chageSelection(true);
                              }
                              else
                              {
                                  this.chageSelection(false);
                              }
                          }
                          
                      }
                      //this.divPosition();
                  }.bind(this)
          );
          this.options.selectobj.observe("keyup",  //文本框按键抬起
                  function(e)
                  {
                      //$("divtest").insert("=============keyup=============<br/>");
                      event.cancelBubble = true;
                      var ie = (document.all)? true:false;
                      if(ie)
                      {
                          var userkey = e.keyCode;
                          if(userkey == 13) //回车
                          {
                              this.selectedValue();//输出值到文本框（域）
                          }
                          else
                          {
                              this.checkAndShow();//查询显示下拉框值
                          }
                      }
                      else
                      {
                          this.checkAndShow();
                      }
                      //this.divPosition();
                  }.bind(this)
          );
          //绑定文本框事件
          /*this.options.selectobj.observe("focus",  //文本框得到焦点
                  function(e)
                  {
                      //$("divtest").insert("===========focus============<br/>");
                      this.checkAndShow();
                  }.bind(this)
          );*/
          //绑定文本框事件
          this.options.selectobj.observe("click",  //文本框得到焦点
                  function(e)
                  {
                      //取消document的点击事件
                      e.cancelBubble = true;
                  }
          );
          //绑定文本框鼠标左键按下事件
          this.options.selectobj.observe("mouseup",
                  function (e) {
                      e.cancelBubble = true;
                      //改变光标的位置后，需改变“提示”内容
                      this.checkAndShow();
                      //this.divPosition();
                  }.bind(this)
          );
          //初始化DIV对象内容
          var objouterDiv = new Element("div", {
              id: this.options.objouter
          }).addClassName('selectDiv').setStyle({position: "absolute",top: "0px", left: "0px", zIndex: "1"});
          $(this.options.selectobj).insert({after: objouterDiv});
          objouterDiv.hide();
          
          //绑定下拉框事件
          $(this.options.objouter).observe("click",  //点击事件
              function(e)
              { 
                  event.cancelBubble = true;
              }
          );
          Event.observe(document, "click", function (e) {
              if($(this.options.objouter) && $(this.options.objouter).visible()) {
                  var ele = $(Event.element(e));
                  var inputObj = $(this.options.selectobj);
                  if (ele.tagName != null 
                          && ele.tagName != inputObj.tagName 
                              && ele.getAttribute("name")!= null  
                                  && ele.getAttribute("name").toLowerCase() != inputObj.getAttribute("name").toLowerCase()) {
                      if($(this.options.dspNameId)) {
                          var nameTxt = this.getSelectDataName();
                          if ($(this.options.dspNameId).value) {
                              $(this.options.dspNameId).value = (nameTxt == false)?"":nameTxt;
                          } else {
                              $(this.options.dspNameId).innerText = (nameTxt == false)?"":nameTxt;
                          }
                      }
                  } else {
                      try{
                          inputObj.focus();
                      }catch(e) {
                          //捕获当“对象”被隐藏后，无法焦点的异常
                      }
                  }
                  this.toggleDiv(false);  //隐藏下拉框
              }
          }.bind(this));
      },//initDivselector结束
      
      /**
       * 判断光标位置是否改变
       * @return {true改变 | false未改变}，未改变时，下拉框不重新初始化 
       */
      isCursorChange: function () {
          var currentCursorIndex = this.getCursorPosition(this.options.selectobj);
          if ( this.options.cursorIndex === parseInt(currentCursorIndex)) {
              return false;   //鼠标点击时还在原位置时，不重新初始下拉框数据
          }
          //保存下拉框Div层显示时，文本框（域）光标的位置
          this.options.cursorIndex = this.getCursorPosition(this.options.selectobj);
          return true;
      },
      
      /**
       * 获取值，生成下拉框选项值
       */
      checkAndShow :function()
      {
    	  if (("readonly" in this.options.selectobj && this.options.selectobj.readonly) 
    			  || ("disabled" in this.options.selectobj && this.options.selectobj.disabled)) {
    		  return;//输入框禁用时或只读时，不允许选择值
    	  }
          if (!this.isCursorChange()) {  //光标位置未改变不初始化下拉框值
              if ($(this.options.objouter).visible()) {
                  return;//下拉框隐藏，可以往下执行
              }
          }
          this.options.selectedIndex=-1;
          //具体实现在Jraf.DivSlctItem等子类中实现
          var datas = this.getSelectData(this.options.selectobj);
          if (datas == null || datas == -1 || (Object.isArray(datas) && datas.length <= 0)) {//“-1”表示不显示提示下拉框
              this.toggleDiv(false);  //隐藏下拉框
              return;
          }
          var divhtml = "";
          var option = null;
          var value = this.options.divkey;
          var name = this.options.divlabel;
          var params = this.options.divparams;
          var objouter = $(this.options.objouter);
          objouter.update("");//清空
          var thisObj = this; //类对象
          datas.each(
                function(data, index){
                    option = new Element("div", {
                        value: (data[value]==null?"":data[value]),
                        params:(data[params]==null?"":data[params]),
                        title: (data[name]==null?"":data[name]),
                        selectedIndex: index
                    }).update(data[name]);
                    option.setAttribute("class", "selectOption");
                    option.observe("mouseover", function (e){
                        thisObj.options.selectedIndex = this.getAttribute("selectedIndex");
                        //设置选项选中时的样式
                        thisObj.setSelectedColor();
                    });
                    option.observe("click", function (e){
                        e.cancelBubble = true;
                        thisObj.toggleDiv(false);
                        thisObj.selectedValue();
                    });
                    objouter.insert(option);
                }
          );
          //选中第一项
          this.options.selectedIndex = 0;
          //设置选项选中时的样式
          this.setSelectedColor();
          
          this.toggleDiv(true);     //显示div并记录光标位置
          this.divDimension(datas.length);      //自适应高宽度
          this.divPosition();       //设置位置
          this.hideElement("SELECT");//隐藏下拉框
          this.hideElement("OBJECT");//隐藏下拉框
          
      },//checkAndShow结束
      
      /**
       * 根据光标位置，获取div的位置
       */
      divPosition : function()
      {
        Number.prototype.NaN0 = function()
        {
            return isNaN(this)?0:this;
        };
        //修正的偏移量
        var e = this.options.selectobj;
        var fixLeft = 0;
        var fixTop  = 0;                
        var objParent = e.offsetParent;
        if ( objParent
                && objParent.tagName.toUpperCase() != "BODY" 
                    && objParent.tagName.toUpperCase() != "HTML"
                        && ((objParent.currentStyle || objParent.style).position.toLowerCase() == "relative"
                            || (objParent.currentStyle || objParent.style).position.toLowerCase() == "absolute"))
        {
            fixLeft += objParent.offsetLeft + (objParent.currentStyle?(parseInt(objParent.currentStyle.borderLeftWidth)).NaN0():0);
            fixTop  += objParent.offsetTop  + (objParent.currentStyle?(parseInt(objParent.currentStyle.borderTopWidth)).NaN0():0);
        }        

        //位置处理
        var outerDiv = $(this.options.objouter);
        var ele = this.options.selectobj;
        var position = this.getInputPositon(ele);   //获取当前光标位置
        
        var oDom = (document.documentElement || document.body);
        var domH = Math.max(oDom.clientHeight, oDom.scrollHeight);
        var bottom = (domH - position.top);
        bottom = bottom < (outerDiv.clientHeight + 10) ? outerDiv.clientHeight + 4 : 0;
        
        var outerDivTop = 0;
        if (ele.tagName.toUpperCase() == "TEXTAREA") {
            outerDivTop  = (position.top - (bottom == 0? -14: bottom));
        } else {
            outerDivTop  = (position.top - (bottom == 0? -ele.clientHeight: bottom));
        }
        outerDiv.style.top = (outerDivTop - fixTop) + 'px';

        var domW = Math.max(oDom.clientWidth, oDom.scrollWidth);
        var right = (domW - position.left);
        right = right < (outerDiv.clientWidth + 10) ? outerDiv.clientWidth: 0;
        outerDiv.style.left = ((position.left - right) - fixLeft) + 'px' ; 
      },//divPosition 结束 
      /**
       * 设置下拉框Div的高度、宽度
       */
      divDimension: function (optionNum) {
          var outerDiv = $(this.options.objouter);
          var optionObj = outerDiv.down(".selectOption");
          var optionsHeight = 0;
          optionNum = isNaN(optionNum)? 5: optionNum;

          var optHeight = optionObj && optionObj.offsetHeight != 0? (optionObj.offsetHeight-2) :19;
          if (optionNum > 10) {
              optionsHeight = optHeight * 10;
          } else {
              optionsHeight = optHeight * optionNum;
          }

          var offsetWidthDiv = outerDiv.scrollWidth ;//- (outerDiv.currentStyle?(parseInt(outerDiv.currentStyle.borderLeftWidth)).NaN0():0) - (outerDiv.currentStyle?(parseInt(outerDiv.currentStyle.borderRightWidth)).NaN0():0);
          var offsetHeightDiv =  optionsHeight;
          var outerDivWidth = (offsetWidthDiv < 180) ? 180 : (offsetWidthDiv > 250 ? 250 : offsetWidthDiv);
          var outerDivHeight = (offsetHeightDiv <= optHeight*5) ? optHeight*5 : offsetHeightDiv;
          outerDiv.style.width = (outerDivWidth ) + "px";
          outerDiv.style.height = (outerDivHeight) + "px";
      },
      
      /**
       * 控制触发↑和↓键时的选项值样式
       * @param isup true表示向上移动，false向下移动
       */
      chageSelection : function(isup)
      {
          if($(this.options.objouter).visible())//判断div是否正显示
          {
              if(isup)//按下键
              {
                  this.options.selectedIndex++;
              }
              else
              {
                  this.options.selectedIndex--;
              }
              /*
               * 上下循环移动选择
               */
              var maxIndex = $(this.options.objouter).children.length-1;
              if (this.options.selectedIndex < 0) {
                  this.options.selectedIndex = 0;
              }
              if (this.options.selectedIndex > maxIndex)
              {
                  this.options.selectedIndex = maxIndex;
              }
              //设置选项选中时的样式
              this.setSelectedColor();
              //设置下拉框div滚动条位置
              this.setScrollingPos();
          }
      },//chageSelection结束
      
      /**
       * 设置选项选中时的样式
       */
      setSelectedColor: function () {
          var maxIndex = $(this.options.objouter).children.length-1;
          var objouter = $(this.options.objouter);
          var offsetTop = 0;
          for(var i=0; i<=maxIndex; i++)
          {
              if(i == this.options.selectedIndex)
              {
                  if (typeof objouter.children[i].className != "undefined") {
                      //IE6兼容
                      objouter.children[i].className = "optionSelected";
                  } else {
                      objouter.children[i].setAttribute("class", "optionSelected");
                      
                  }
              }
              else
              {
                  if (typeof objouter.children[i].className != "undefined") {
                      //IE6兼容
                      objouter.children[i].className = "selectOption";
                  } else {
                      objouter.children[i].setAttribute("class", "selectOption");
                  }
              }
          }   
      },//setSelectedColor end
      /**
       * 设置下拉框div滚动条位置
       */
      setScrollingPos: function (){
          var maxIndex = $(this.options.objouter).children.length-1;
          var objouter = $(this.options.objouter);
          var offsetTop = 0;
          //设置滚动条的位置
          offsetTop = objouter.children[this.options.selectedIndex].offsetTop;
          //alert("objouter.clientHeight="+objouter.clientHeight+ ", objouter.scrollTop="+objouter.scrollTop+", offsetTop="+offsetTop);
          if ((objouter.clientHeight+objouter.scrollTop) <= offsetTop) {
              objouter.scrollTop = offsetTop - objouter.clientHeight + objouter.children[this.options.selectedIndex].clientHeight;
          } else if (offsetTop < objouter.scrollTop ) {
              objouter.scrollTop = objouter.scrollTop - objouter.children[this.options.selectedIndex].clientHeight;
          } else {
              //alert("other");
          }
      },//setScrollingPos end
      /**
       * 选中并输出值
       */
      selectedValue: function () {
          var selectedObj = $(this.options.objouter).children[this.options.selectedIndex];
          if (!selectedObj || selectedObj.getAttribute("value") == null ) {
              return;
          }
          //具体实现在Jraf.divslctcalc中实现
          this.outSelection(this.options.selectobj, selectedObj);
          this.toggleDiv(false);  //隐藏下拉框  
          //聚集文本框（域），并回到开始光标位置
          this.setCursorIndex(this.options.cursorIndex);
      },
      
      /**
       * 隐藏或显示下拉框Div层
       * @param isShow{true显示|false隐藏}
       */
      toggleDiv: function (isShow) {
          if(isShow === true) {
              $(this.options.objouter).show();
              this.hideElement("SELECT");
              this.hideElement("OBJECT");
          } else {
              $(this.options.objouter).hide();
              this.showElement("SELECT");
              this.showElement("OBJECT");
          }
      },
      /**
       * 显示下拉框的值
       * ps: IE6的下拉框会浮在div层之前
       */
      showElement : function(tag)
      {
        $$(tag).each(
        function(oneTag){
            if(oneTag && oneTag.offsetParent)
            {
                oneTag.show();
            }
        }        
        );
      },//showElement结束
      /**
       * 隐藏下拉框的值
       * ps: IE6的下拉框会浮在div层之前
       */
      hideElement : function(tag)
      {
        var overDiv = $(this.options.objouter);
        $$(tag).each(
            function(oneTag){
                if(oneTag && oneTag.offsetParent)
                {
                    var objLeft   = oneTag.offsetLeft;
                    var objTop    = oneTag.offsetTop;
                    var objParent = oneTag.offsetParent;
                    var tmp = objParent;
                    while( objParent != null 
                            && objParent.tagName.toUpperCase() != "BODY" 
                                && objParent.tagName.toUpperCase() != "HTML")
                    {
                        objLeft  += objParent.offsetLeft;
                        objTop   += objParent.offsetTop;
                        objParent = objParent.offsetParent;
                    }
                    var objHeight = oneTag.offsetHeight;
                    var objWidth =  oneTag.offsetWidth;
                    if(( overDiv.offsetLeft + overDiv.offsetWidth ) <= objLeft );
                    else if(( overDiv.offsetTop + overDiv.offsetHeight ) <= objTop );
                    else if( overDiv.offsetTop >= ( objTop + objHeight ));
                    else if( overDiv.offsetLeft >= ( objLeft + objWidth ));
                    else
                    {
                        oneTag.hide();
                    }
                }
            }        
            );
      },//hideElement结束
      /**
       * 设置文本框（域）中光标位置
       * @param index 光标索引位置
       */
      setCursorIndex: function (index) {
    	  try {
	          //设置光标位置
	          var focu = this.options.selectobj.createTextRange();
	          focu.move("character", index);
	          focu.select();   
	          //保存下拉框Div层显示时，文本框（域）光标的位置
	          this.options.cursorIndex = this.getCursorPosition(this.options.selectobj);
    	  } catch (e) {
    		  //当控件禁用时，不能焦距
    	  }
      },
      
      /**
       * 获取文本框和文本域的光标位置
       * @param     elem    文本框或文本域对象
       * @return    index   当前光标位置牵引（从0开始）
       */
      getCursorPosition: function (elem) {
          var index = 0;
          if (document.selection) {// IE Support
              elem.focus();
              var Sel = document.selection.createRange();
              if (elem.nodeName === 'TEXTAREA') {//textarea
                  var Sel2 = Sel.duplicate();
                  Sel2.moveToElementText(elem);
                  index = -1;
                  while (Sel2.inRange(Sel)) {
                      Sel2.moveStart('character');
                      index++;
                  };
              }
              else if (elem.nodeName === 'INPUT') {// input
                  Sel.moveStart('character', -elem.value.length);
                  index = Sel.text.length;
              }
          }
          else if (elem.selectionStart || elem.selectionStart == '0') { // Firefox support
              index = elem.selectionStart;
          }
          return (index);
      },
      /**
       * 获取输入光标在页面中的坐标
       * @param        {HTMLElement}   输入框元素        
       * @return       {Object}        返回left和top,bottom
       */
       getInputPositon: function (elem) {
           var version = Jraf.getBrowserVersion();
           if (document.selection && (Prototype.Browser.IE && version < 8.0)) {   //IE Support（IE8.0之前的版本）
               elem.focus();
               var Sel = document.selection.createRange();
               //滚动条问题
               var scrollTopTmp = $(this.options.selectobj).cumulativeScrollOffset();
               return {
                   left: Sel.boundingLeft,
                   top: Sel.boundingTop + (scrollTopTmp.top || 0),
                   bottom: Sel.boundingTop + Sel.boundingHeight
               };
           } else {
               var that = this;
               var cloneDiv = '{$clone_div}', cloneLeft = '{$cloneLeft}', cloneFocus = '{$cloneFocus}', cloneRight = '{$cloneRight}';
               var none = '<span style="white-space:pre-wrap;"> </span>';
               var div = elem[cloneDiv] || document.createElement('div'), focus = elem[cloneFocus] || document.createElement('span');
               var text = elem[cloneLeft] || document.createElement('span');
               var offset = that._offset(elem), index = this._getFocus(elem), focusOffset = { left: 0, top: 0 };
               if (!elem[cloneDiv]) {
                   elem[cloneDiv] = div, elem[cloneFocus] = focus;
                   elem[cloneLeft] = text;
                   div.appendChild(text);
                   div.appendChild(focus);
                   //document.body.appendChild(div);
                   focus.innerHTML = '|';
                   focus.style.cssText = 'display:inline-block;width:0px;overflow:hidden;z-index:-100;word-wrap:break-word;word-break:break-all;';
                   if (typeof div.className == "undefined") {//IE9
                       div.className = this._cloneStyle(elem);
                   } else {
                       div.setAttribute("class", this._cloneStyle(elem));
                   }
                   div.style.cssText = 'visibility:hidden;display:inline-block;position:absolute;z-index:-100;word-wrap:break-word;word-break:break-all;overflow:hidden;';
                   document.body.appendChild(div);
               };
               div.style.display = "inline-block";
               div.style.left = this._offset(elem).left + "px";
               div.style.top = this._offset(elem).top + "px";

               var strTmp = elem.value.substring(0, index).replace(/</g, '<').replace(/>/g, '>').replace(/\n/g, '<br/>').replace(/\s/g, none);
               text.innerHTML = strTmp;

               focus.style.display = 'inline-block';
               try { focusOffset = this._offset(focus); } catch (e) { };
               focus.style.display = 'none';
               div.style.display = "none";
               return {
                   left: focusOffset.left,
                   top: focusOffset.top,
                   bottom: focusOffset.bottom
               };
           }
       },
       // 克隆元素样式并返回类
       _cloneStyle: function (elem, cache) {
           if (!cache && elem['${cloneName}']) return elem['${cloneName}'];
           var className, name, rstyle = /^(number|string)$/;
           var rname = /^(content|outline|outlineWidth)$/; //Opera: content; IE8:outline && outlineWidth
           var cssText = [], sStyle = elem.currentStyle;

           for (name in sStyle) {
               if (!rname.test(name)) {
                   val = this._getStyle(elem, name);
                   if (val !== '' && rstyle.test(typeof val)) { // Firefox 4
                       name = name.replace(/([A-Z])/g, "-$1").toLowerCase();
                       cssText.push(name);
                       cssText.push(':');
                       cssText.push(val);
                       cssText.push(';');
                   };
               };
           };
           cssText = cssText.join('');
           elem['${cloneName}'] = className = 'clone' + (new Date).getTime();
           this._addHeadStyle('.' + className + '{' + cssText + '}');
           return className;
       },

       // 向页头插入样式
       _addHeadStyle: function (content) {
           var style = this._style[document];
           if (!style) {
               style = this._style[document] = document.createElement('style');
               document.getElementsByTagName('head')[0].appendChild(style);
           };
           style.styleSheet && (style.styleSheet.cssText += content) || style.appendChild(document.createTextNode(content));
       },
       _style: {},

       // 获取最终样式
       _getStyle: 'getComputedStyle' in window ? function (elem, name) {
           return getComputedStyle(elem, null)[name];
       } : function (elem, name) {
           return elem.currentStyle[name];
       },

       // 获取光标在文本框的位置
       _getFocus: function (elem) {
           var index = 0;
           if (document.selection) {// IE Support
               elem.focus();
               var Sel = document.selection.createRange();
               if (elem.nodeName === 'TEXTAREA') {//textarea
                   var Sel2 = Sel.duplicate();
                   Sel2.moveToElementText(elem);
                   var index = -1;
                   while (Sel2.inRange(Sel)) {
                       Sel2.moveStart('character');
                       index++;
                   };
               }
               else if (elem.nodeName === 'INPUT') {// input
                   Sel.moveStart('character', -elem.value.length);
                   index = Sel.text.length;
               }
           }
           else if (elem.selectionStart || elem.selectionStart == '0') { // Firefox support
               index = elem.selectionStart;
           }
           return (index);
       },

       // 获取元素在页面中位置
       _offset: function (elem) {
           var box = elem.getBoundingClientRect(), doc = elem.ownerDocument, body = doc.body, docElem = doc.documentElement;
           var clientTop = docElem.clientTop || body.clientTop || 0, clientLeft = docElem.clientLeft || body.clientLeft || 0;
           var top = box.top + (self.pageYOffset || docElem.scrollTop) - clientTop, left = box.left + (self.pageXOffset || docElem.scrollLeft) - clientLeft;
           return {
               left: left,
               top: top,
               right: left + box.width,
               bottom: top + box.height
           };
       }
  }    
);


/**
 * 除了可输入文本框外，页面禁止使用Backspace键
 * 作用： 防止用户按“Backspace”键使页面跳转到历史页面，因为页面中大量使用Ajax技术。
 * @author yangx
 * @date 2012-04-16
 */
Jraf.ForbidBackspace = function () {
    Event.observe(document, "keydown", function (event) {
        if (event.keyCode == 8){
            var currentEle = Event.element(event);
            //可输入的表单且不为只读的，可用
            if((currentEle.tagName.toLowerCase() === "input" 
                || currentEle.tagName.toLowerCase() === "textarea" )
                    && currentEle.readOnly == false){
                event.returnValue = true;
                return;
            }
            event.returnValue = false;//禁用
        }
    });
};

/**
 * 显示或隐藏DIV/SPAN的内容
 * @用法： 
 *     在标题栏加上属性toggleblock， 其值为要控制的div/span隐藏和显示的id
 *     例：<div toggleblock='blockId'></div>
 *         <div id='blockId'>...</div>
 * @备注： 系统会自动在标题栏最前方加上图标和事件
 * @author yangx
 * @createdate 2012-11-20
 */
Jraf.BlockToggle = Class.create({
    initialize: function(options){
        if(Object.isString(options)){
            options = {selector: options};
        }
        this.options = Object.extend({
            dspIconPath:    '/common/skins/default/images/button/arrow_up.gif',
            hideIconPath:    '/common/skins/default/images/button/arrow_down.gif'
        }, options || { });
        //dsptoggle: true | false
        var oImg = null;
        var oToggleId = "";
        //初始化添加功能图标和事件
        $$("div[toggleblock]", "span[toggleblock]").each(function (obj) {
            var toggleBlock = obj.readAttribute("toggleblock");
            if (toggleBlock.trim() == '' || !$(toggleBlock)) {
                alert("[method=Jraf.BlockToggle][init]隐/显功能，参数配置出错： toggleblock=" + toggleBlock + ", 不是有效的ID值");
                return;
            }
            oToggleId = $(toggleBlock);
            if ($(obj.down("img")) && (obj.down("img").src.include(this.options.dspIconPath) ||
                    obj.down("img").src.include(this.options.hideIconPath))) {
                return; //存在图标则不初始化
            }
            //添加功能图标和事件
            if (oToggleId.visible()) {
                //alert("dsp");
                //oToggleId.style.display = "block";
                oImg = new Element("img", {alt: "点击隐藏", title: "点击隐藏", align: "middle", src: this.options.hideIconPath});
                obj.insertAdjacentElement("afterBegin", oImg);
            } else {
                oImg = new Element("img", {alt: "点击显示", title: "点击显示", align: "middle", src: this.options.dspIconPath});
                obj.insertAdjacentElement("afterBegin", oImg);
            }
            oImg.observe("click", function () {this._toggleBlock(obj); }.bind(this));
        }, this);
        
    }, 
    //隐藏和显示事件
    _toggleBlock: function (obj) {
      var obj = $(obj);
      var oImg = obj.down("img");
      var toggleBlock = obj.readAttribute("toggleblock");
      this._addImg(toggleBlock, oImg);
      $(toggleBlock).toggle();
      /*var oBlock = $(toggleBlock);
      if (oBlock.visible()) {
          this._scaleDown(oBlock, 0, 5);
      } else {
          this._scaleUp(oBlock, 0, 5);
      }*/
    }, 
    _addImg: function (obj, oImg) {
        var obj = $(obj);
        if(obj.visible()){
            oImg.alt = "点击显示";
            oImg.title = "点击显示";
            oImg.src = this.options.dspIconPath;
        } else {
            oImg.alt = "点击隐藏";
            oImg.title = "点击隐藏";
            oImg.src = this.options.hideIconPath;
        }
    },
    /**
     * 按给定长宽，缩小
     */
    _scaleDown: function (oBlock, width, height) {
        if (oBlock == null 
                || typeof width != "number" 
                    || typeof height != "number") {
            alert("[Jraf.BlockToggle][method=_scaleDown]方法参数传递出错。");
            return false;
        }
        var oldWidth = $(oBlock).getWidth();
        var oldHeight = $(oBlock).getHeight();
        var oScale = $("_Jraf_Block_Scale");
        if (!oScale) {
            oScale = new Element("div", {
                id: "_Jraf_Block_Scale"
            }).setStyle({position: "absolute", zIndex: "99", width: "0px", height: "0px"});
            $(oBlock).insert(oScale);
        }
        oScale.setStyle({width: oldWidth + "px", height: oldHeight + "px"});
        oScale.show();
        oBlock.setStyle({overflow: "hidden"});
        
        this._changeScale(oBlock, oldWidth, oldHeight, width, height);
        oBlock.setStyle({height: oldHeight + "px", overflow: ""});
        oScale.hide();
    },
    /**
     * 按给定长宽，扩大
     */
    _scaleUp: function (oBlock, width, height, width) {
        /*if (oBlock == null 
                || typeof width != "number" 
                    || typeof height != "number") {
            alert("[Jraf.BlockToggle][method=_scaleUp]方法参数传递出错。");
            return false;
        }
        var oldWidth = $(oBlock).getWidth();
        var oldHeight = $(oBlock).getHeight();
        var oScale = $("_Jraf_Block_Scale");
        if (!oScale) {
            oScale = new Element("div", {position: "absolute", zIndex: "99", width: "0px", height: "0px"});
            $(oBlock).insert({before: oScale});
        }
        oScale.setStyle({width: oldWidth + "px", height: oldHeight + "px"});*/
        oBlock.show();
        /*while(oldWidth == 0 || oldHeight == 0) {
            oldWidth = oldWidth - width;
            oldHeight = oldHeight - height;
            oScale.setStyle({width: oldWidth + "px", height: oldHeight + "px"});
        }*/
    },
    _changeScale: function (oBlock, width, height, wNum, hNum) {
        var tmpW = width;
        var tmpH = height;
        if (tmpH > 10) {
            tmpW = tmpW - wNum;
            tmpH = tmpH - hNum;
            oBlock.setStyle({width: (tmpW<0?0:tmpW) + "px", height: (tmpH<0?0:tmpH) + "px"});
            window.setTimeout(function () {
                this._changeScale(oBlock, tmpW, tmpH, wNum, hNum);
            }.bind(this), 10);
        } else {
            oBlock.hide();
        }
    }
});
/**
 * 容器（div, span(block), table的td）中具有必要属性： 
 *     jraf_pageid:  唯一标识与id属性分离开,如果没有id属性，则自动用此属性值赋值
 *     jraf_url: 地址
 * 可选属性： 
 *     jraf_sysName: 
 *     jraf_oprID:  
 *     jraf_actions:    
 *     jraf_params: 参数：
 *                  （1）传入的参数为“&”符分隔的key/value键值对；值可用“#{inputId/inputName}”
 *                       表示，如此，系统自动取inputId或inputName对应的表单元素的value值；
 *                  （2）带有返回结果的函数
 *     jraf_callback 回调函数，
 *     jraf_init 是否初始化执行，true页面加载时执行，false调用doLoad方法执行，默认为false 
 *     jraf_link:  下一个加载的（配置id）
 *     jraf_loadchild: 是否加载子页面里（true|false）
 * 系统属性：
 *     _jrafsys_loaded: 判断是否已经加载过了，加载过的，以后不再加载
 *     
 * 注意： 
 *     属性jraf_init， jraf_link， jraf_loadchild， _jrafsys_loaded，只用于页面
 *     加载时初始化执行loadPageTo
 * =============================================================================
 * <div jraf_pageid="page1" 
 *     jraf_url="/ctrk/checkManage/showErrorInfosList.jsp"
 *     jraf_sysName=""
 *     jraf_oprID=""
 *     jraf_actions="" 
 *     jraf_params="test=jjj&jjjj"
 *     jraf_callback="callback1()"
 *     
 *     jraf_init="true"
 *     jraf_link=""
 *     jraf_loadchild="true"><!--表示加载已加载页面中容器-->
 * </div>
 * <div jraf_pageid="page2" 
 *     jraf_url="/ctrk/checkManage/ctrk_errorCust_list.jsp"
 *     jraf_sysName=""
 *     jraf_oprID=""
 *     jraf_actions="" 
 *     jraf_params="test=jjj&jjjj"
 *     jraf_callback="callback2()"
 *     
 *     jraf_init="true"
 *     jraf_link="page1"
 *     jraf_loadchild="">
 * </div>
 * 
 * 例一： new Jraf.LoadPageTo();//初始化整个页面的page,先加载"page2"再加载“page1” 
 * 例二： new Jraf.LoadPageTo({scope: "mainId"});//初始化id为“mainId”的容器下的页面
 * 例三：var g_oLoadPageTo = new Jraf.LoadPageTo();
 *       g_oLoadPageTo.doLoad("page2"); //单独解析属性jraf_pageid="page2"的div加载相应页面
 * --------------------------------------------------------------------------------------
 * 特别说明： 解析jraf_params值：可以是传函数，也可以传一个模板
 * 模板如： 
 *     test=#{id1 }&test=#{id2}&...
 *     ----------------------------
 *     以上的id1，id2,...,idn，为表单元素的id属性值或name属性值；
 *     系统会自动转换成表单元素对应的value值。
 *     如有多个name值一样的元素，则取所有的值，值用逗号“,”分隔（此种情况，主要是取复选框的值）
 *
 * @auth yangxiong
 * @createdate 2013-04-16
 */
Jraf.LoadPageTo = Class.create({
    initialize: function(options){
        if(Object.isString(options)){
            options = {selector: options};
        }
        this.options = Object.extend({
            scope:  null,       //加载的范围，只初始化范围内的容器；如果不配置则全页面搜索
            pageBlocks: {},     //“容器”对象集合（key: jraf_pageId, value: {attrs}）
            noWaitArray: new Array(),
            waitArray: new Array(),  //保存执行顺序
            ajaxObj: new Jraf.Ajax()
        }, options || { });
        
        //初始化参数, 并执行初始化加载页面（只执行jraf_init="true"的）
        this.initData();
    },
    initData: function () {
        var scope = $(this.options.scope);
        //保存容器的属性值
        if (scope) {//限制范围
            scope.select("[jraf_pageid]").each(function (obj) {
                this._saveAttr(obj);
            }, this);
        } else {//全局搜索
            $$("[jraf_pageid]").each(function (obj) {
                this._saveAttr(obj);
            }, this);
        }
        
        //所有注册的容器都已经初始化或不用初始化，则跳出
        var blockHash = $H(this.options.pageBlocks);
        if (blockHash.size() == 0 ) {
            return; 
        }
        
        //统计被引用次数
        var id = null;
        var num = 0;
        var link = null;
        var linkTmp = "";
        var idTmp = "";
        var errorflag = false;
        var attrs = {};
        //var nullCount = 0;
        blockHash.each(function (pair) {
            id = pair.key;
            attrs = pair.value;
            link = attrs["jraf_link"];
            /*if (link && link.trim() != "")
                nullCount ++;*/
            idTmp = id;
            while(link != null && link != "") {
                //判断link是否配置正确
                if (this.options.pageBlocks[link] == null) {
                    alert("[Jraf.LoadPageTo][method=initData][jraf_pageid=" + idTmp + "]"
                            + "[jraf_link=" +link+ "]参数配置错误，link配置找不到或未设置jraf_init属性为true。");
                    errorflag = true;
                    throw $break; //跳出循环
                }
                //检查，直接或间接引用自已的情况（会造成死循环）
                if (id == link) {
                    alert("[Jraf.LoadPageTo][method=initData][jraf_pageid=" + idTmp + "]"
                            + "[jraf_link=" +link+ "]参数配置错误，不能出现直接或间接引用自已的情况。");
                    errorflag = true;
                    throw $break; //跳出循环
                }
                idTmp = link;
                linkTmp = this.options.pageBlocks[link];
                num = linkTmp._jrafsys_num;
                linkTmp._jrafsys_num = parseInt(num) + 1;
                
                link = linkTmp["jraf_link"];
            }
            
        }, this);
        //保存引用次数
        $H(blockHash).each(function (obj,index){
            id = obj.key;
            value = obj.value;
            this.options.waitArray.push({id: id, num: value._jrafsys_num});
        }, this);
        
        if (errorflag == true) { //异常跳出程序
            return;
        }
        /*if (nullCount == 0) {
            alert("[Jraf.LoadPageTo][method=initData]参数配置错误，至少保证一容器的jraf_link属性为空。");
            return;
        }*/
        
        //排序
        var temp = null;
        var temp2 = null;
        for (var i = 0, len = this.options.waitArray.length; i < len; i ++ ) {
            temp = this.options.waitArray[i];
            for (var j = i + 1; j < len; j ++) {
                temp2 = this.options.waitArray[j];
                if (parseInt(temp.num) < parseInt(temp2.num)) {
                    this.options.waitArray[j] = this.options.waitArray[i];
                    this.options.waitArray[i] = temp2;
                }
            }
        }
        //重构回调函数
        var callback = null;
        var link = null;
        var loadedFlag = false;
        var len = this.options.waitArray.length;
        for (var i = 0 ; i < len; i ++ ) {
            temp = this.options.waitArray[i];
            id = temp.id;

            //设置loaded标志
            $(id).writeAttribute("_jrafsys_loaded", "true");
            
            //不用等待的情况，优先处理，是执行加载的入口
            if (temp.num == 0) {
                this.options.noWaitArray.push(temp);
            }
            link = this.options.pageBlocks[id]["jraf_link"];
            //最后未链接其他的回调处理
            if (!link || link.trim() == "") { 
                var callback = this.options.pageBlocks[id]["jraf_callback"];
                this.options.pageBlocks[id]["jraf_callback"] = {
                    id:             id,
                    nextObj:        null,
                    oldcallback:    callback,
                    isRetrieve:     this.options.pageBlocks[id]["jraf_loadchild"],
                    ajaxObj:        this.options.ajaxObj,
                    newcallback:    function (id, nextObj, oldcallback, isRetrieve, ajaxObj) {
                                        try {
                                            eval(oldcallback);//执行回调
                                        } catch (e) {
                                            alert("[Jraf.LoadPageTo][method=initData][id=" + id 
                                                    + "][callback=" + oldcallback + "]调用回调函数出错：" + e.message);
                                        }
                                        //alert("nolink:"+id)
                                        //循环遍历加载
                                        if ((isRetrieve + '') == 'true') {
                                            setTimeout(function (){new Jraf.LoadPageTo({scope: $(id)});}, 0);
                                        }
                                        
                                    }
                };
                continue;
            } //end if
            
            //有链接其他的回调处理
            var callback = this.options.pageBlocks[id]["jraf_callback"];
            this.options.pageBlocks[id]["jraf_callback"] = {
                    id:             id,
                    nextObj:        this.options.pageBlocks[link],
                    oldcallback: callback,
                    isRetrieve:  this.options.pageBlocks[id]["jraf_loadchild"],
                    ajaxObj:     this.options.ajaxObj,
                    newcallback: function (id, nextObj, oldcallback, isRetrieve, ajaxObj) {
                                    try {
                                        eval(oldcallback);//执行回调
                                    } catch (e) {
                                        alert("[Jraf.LoadPageTo][method=initData][id=" + id 
                                                + "][callback=" + oldcallback + "]调用回调函数出错：" + e.message);
                                    }
                                    //alert("link: "+id)
                                    //顺序执行其他load方法
                                    var oblock = nextObj;
                                    if (oblock == null)
                                        return;
                                    $(oblock["id"]).update("<span class='loading'>加载中...</span>");
                                    if (!ajaxObj) {
                                        ajaxObj = new Jraf.Ajax();
                                    }
                                    var oCallBack = oblock["jraf_callback"];
                                    ajaxObj.loadPageTo(
                                        oblock["jraf_url"], 
                                        oblock["jraf_params"], 
                                        oblock["id"], 
                                        function () {
                                            oCallBack.newcallback(oCallBack.id,
                                                                    oCallBack.nextObj, 
                                                                        oCallBack.oldcallback, 
                                                                            oCallBack.isRetrieve, 
                                                                                oCallBack.ajaxObj);
                                        }
                                    );
                                    //循环遍历加载
                                    if ((isRetrieve + '') == "true") {
                                        setTimeout(function (){new Jraf.LoadPageTo({scope: $(id)});}, 0);
                                    }
                                }
            };
        }// end for
        
        //执行loadPageTo加载数据
        len = this.options.noWaitArray.length;
        var oblock2 = null;
        var oCallBack = null;
        var ajaxObj = new Jraf.Ajax({asynchronous: false});
        for (var i = 0 ; i < len; i ++ ) {
            temp = this.options.noWaitArray[i];
            oblock2 = this.options.pageBlocks[temp.id];
            //alert("loaded: "+ temp.id)
            if (!$(oblock2["id"])) {
                alert("[Jraf.LoadPageTo][method=initData]对象不存在：id: " + oblock2["id"]);
                continue;
            }
            this._loading(oblock2["id"]);
            var oCallBack = oblock2["jraf_callback"];
            ajaxObj.loadPageTo(
                    oblock2["jraf_url"], 
                    oblock2["jraf_params"], 
                    oblock2["id"], 
                    function () {
                        oCallBack.newcallback(oCallBack.id,
                                oCallBack.nextObj, 
                                    oCallBack.oldcallback, 
                                        oCallBack.isRetrieve, 
                                            oCallBack.ajaxObj);
                    }
                );
        }
    },
    _loading: function (id) {
        $(id).update("<span class='loading'>加载中...</span>");
    },
    checkParam: function (obj) {
        if (!obj.readAttribute("jraf_url") || obj.readAttribute("jraf_url").trim() == "") {
            alert("[Jraf.LoadPageTo][method=checkParam][jraf_pageid="+obj.readAttribute("jraf_pageid")+"]必须参数jraf_url值不能为空。");  
            return false;
        }
        return true;
    },
    _saveAttr: function (obj) {
        var obj = $(obj);
        var id = obj.readAttribute("jraf_pageid");
        
        var attrs = {};
        //初始化id
        if (obj.id == "") {
            attrs["id"] = id;
            obj.id = id;
        } else {
            attrs["id"] = obj.readAttribute("id");
        }
        
        //校验
        if ( id.trim() == "" 
            || !"innerHTML" in obj
                || obj.readAttribute("_jrafsys_loaded") == "true"
                    || obj.readAttribute("jraf_init") != "true") {
            return;//continue;
        }
        if (!this.checkParam(obj)) {
            return;//校验不能过
        }
       
        attrs["jraf_pageid"] = id;
        attrs["jraf_url"] = obj.readAttribute("jraf_url") || "/httpprocesserservlet";
        
        attrs["jraf_params"] = Jraf.BlockAttribute.createParams(obj) + "&submitDivId=" + attrs["id"];
        attrs["jraf_callback"] = obj.readAttribute("jraf_callback") || "";
        attrs["jraf_init"] = obj.readAttribute("jraf_init") || false;
        attrs["jraf_link"] = obj.readAttribute("jraf_link");
        attrs["jraf_loadchild"] = obj.readAttribute("jraf_loadchild") || false;
        attrs["_jrafsys_loaded"] = false;
        attrs["_jrafsys_num"] = 0; //引用次数
        this.options.pageBlocks[id] = attrs;
    },
    /**
     * 单个执行loadPageTo
     */
    doLoad: function (pageid) {
        if (pageid == null || pageid.trim() == "") {
            alert("[Jraf.LoadPageTo][method=doLoad]参数不能不空,请传入pageid.");
            return;
        }
        var oPageid = $$("[jraf_pageid='"+pageid+"']");
        if (oPageid == null || oPageid.size() == 0) {
            alert("[Jraf.LoadPageTo][method=doLoad]未找到配有jraf_pageid属性的元素.");
            return;
        }
        var obj = oPageid[0];
        if (obj.id == null || obj.id == "") {
            obj.id = pageid;
        } 
        
        if (!$(obj.id)) {
            alert("[Jraf.LoadPageTo][method=doLoad]对象不存在：id: " + obj.id);
            return;
        }
        var blockId = $(obj.id);
        
        this._loading(blockId);
        
        var oCallBack = obj.readAttribute("jraf_callback") || "";
        
        var params = Jraf.BlockAttribute.createParams(obj) + "&submitDivId=" + obj.id;

        this.options.ajaxObj.loadPageTo(
                obj.readAttribute("jraf_url") || "/httpprocesserservlet", 
                params, 
                blockId, 
                function () {
                    try {
                        eval(oCallBack);//执行回调
                    } catch (e) {
                        alert("[Jraf.LoadPageTo][method=doLoad][id=" + obj.id 
                                + "][callback=" + oCallBack + "]调用回调函数出错：" + e.message);
                    }
                }
            );
    }
});

/**
 * 对文本输入框产生日历控件
 * 文本框必要属性：
 *     jraf_datepiker: 标识符，表示要产生日历控件，其值无意义，可设置成true
 * 系统属性：
 *     __jraf_created: true
 * 例一： 
 *     <input id="testId" name="test" type="text" jraf_datepicker='true'>
 *     ......
 *     使用运行：new Jraf.DatePicker(); //运行后，在文本框后新增button，供选择日历
 * @author Sean
 * @createdate: 2013-04-27
 */
Jraf.DatePicker = Class.create({
    initialize: function(options){
        if(Object.isString(options)){
            options = {selector: options};
        }
        this.options = Object.extend({
            daFormat:   "%Y年%m月%d日", //the date format that will be used to display the date in displayArea
            showsTime:  "true",  //default: false; if true the calendar will include a time selector
            inputField: null,   //the ID of an input field to store the date
            ifFormat: "%Y-%m-%d",    //date format that will be stored in the input field
            button: null,
            btnClass: "calendar-button-img"
        }, options || { });
        
        //初始化参数
        var oButton = null;
        var buttonId = "";
        var inputId = "";
        $$("input[type=text][jraf_datepicker]").each(function (obj) {
            if (obj.readAttribute("__jraf_created") === "true") {
                return;//已初始化的，跳过
            } else {
                obj.writeAttribute("__jraf_created", "true");
            }
            inputId = obj.id || obj.name || ("__jraf_datepiker_" + new Date().getTime() + "_ID");
            if (inputId == "") {
                alert("[Jraf.DatePicker][method=initialize]" + (obj.tagName) + "属性ID值或name值不能为空。");
                return;
            }
            obj.id = inputId;
            this.options.inputField = inputId;
            
            buttonId = inputId + "_c";
            this.options.button = inputId + "_c";
            
            oButton = new Element("input", {
                type: "button",
                align: "middle",
                id: buttonId,
                title: "选择日期"
            }).addClassName(this.options.btnClass);
            oButton.observe("mouseover",  function () {this.className='calendar-img-over';});
            oButton.observe("mouseout",  function () {this.className='calendar-img-out';});
            
            if (!$(buttonId)) {
                $(obj.id).insert({after: oButton});
            }
            //添加事件
            this.createCalendar();
        }, this);
    },
    createCalendar: function () {
        return Calendar.setup({
            daFormat:    this.options.daFormat,     // Format of the date displayed 
            showsTime:   this.options.showsTime,    // allow time selection
            inputField:  this.options.inputField,   // id of the input field
            ifFormat:    this.options.ifFormat,     // format of the input field
            button:      this.options.button        // trigger for the calendar (button ID)
         });
    }
});

/**
 * 重构table列表，实现“固定表格头和分页信息”功能
 * 
 * 使用说明：
 * 例1： new Jraf.ReTable();//重构class='list-table'的所有表格
 * 例2： new Jraf.ReTable("#tableId");//重构id="tableId"的表格
 * 例3： new Jraf.ReTable({
 *           selector: "#tableId", 
 *           titleTabObj: null, //标题行对象（存放标题的表格对象）
 *           width: 100, //最大宽度
 *           height: 100 //最大高度
 *       });//重构id="tableId"的表格,并限制高宽度（单位默认为px）
 * 注意： 标题栏有多行的情况，可以使用自己指定的标题栏表格对象
 * @author Sean
 * @createdate 2013-06-16
 */
Jraf.ReTable = Class.create({
    initialize: function(options) {
        if(Object.isString(options)) {
            options = {selector: options};
        }
        this.options = {
            selector: ".list-table",
            titleTabObj: null, //标题行对象（存放标题的表格对象）
            width: null, //最大宽度
            height: null,//最大高度
            defaultWidth: "100%",
            defaultHeight: 98,
            tableOffsetH: 19,
            tableOffsetW: 19
        };
        Object.extend(this.options, options || { });
        this.init();
    },
    init: function () {
        var tableArr = $$(this.options.selector);
        for (var i=0, len=tableArr.length; i < len; i ++) {
            var obj = $(tableArr[i]);
            if (obj.id == "") {
                obj.id = "__JrafReTable_"+ new Date().getTime() +"_id";
            }
            this.createMain(obj);
        }
    },
    //创建表格显示主区域
    createMain: function (tableObj) {
        tableObj = $(tableObj);
        var preObj = tableObj.previous();
        var upObj = tableObj.up(0);
        var tempDivObj = new Element("div").setStyle({
            width: "100%"
        });
        upObj.insert(tempDivObj);
        var blockHeight = tempDivObj.getDimensions();
        tempDivObj.remove();
        
        //var tabDims = tableObj.getDimensions();
        var offsetH =  (this.options.tableOffsetH || 0);
        var tabTempDims = tableObj.getDimensions();
        var tempWidth = tabTempDims.width;
        var tempHeight = tabTempDims.height;
        if (!!Object.isNumber(this.options.width)) {
            if ((tabTempDims.width) > this.options.width)
                tabTempDims.width = this.options.width + "px";
        } else {
            tabTempDims.width = this.options.defaultWidth;
        }
        if (!!Object.isNumber(this.options.height)) {
            if ((tabTempDims.height) > this.options.height)
                tabTempDims.height = offsetH + this.options.height + "px";
            else 
                if (tabTempDims.height < this.options.defaultHeight) {
                    tabTempDims.height = this.options.defaultHeight + "px";
                } else {
                    tabTempDims.height += offsetH;
                }
        } else {
            if (tabTempDims.height < this.options.defaultHeight) {
                tabTempDims.height = this.options.defaultHeight + "px";
            } else {
                tabTempDims.height += offsetH;
            } 
        }
        var mainDivObj = new Element("div", {id: this.__getMainId(tableObj)});
        mainDivObj.setStyle({
            width: tabTempDims.width,
            height: tabTempDims.height,
            position: "relative",
            overflow: "hidden"
        });
        var headerObj = this.__createTableHeader(tableObj);
        mainDivObj.insert(headerObj);

        var bodyObj = this.__createTabBody(tableObj);
        mainDivObj.insert(bodyObj);
        
        var pagerObj = this.__createTablePager(tableObj);
        mainDivObj.insert(pagerObj);
        if (!!preObj)
            preObj.insertAdjacentElement("afterEnd", mainDivObj);
        else 
            upObj.insert(mainDivObj);

        //适配ie7、8多滚动条宽度问题  
        if (bodyObj.scrollWidth > tempWidth 
            && tempHeight <= this.options.defaultHeight) {
            mainDivObj.setStyle({height: (this.options.defaultHeight + 17) + "px"});
        }
        
        var bodyHeight = mainDivObj.getHeight()-headerObj.getHeight()-pagerObj.getHeight();
        bodyObj.setStyle({height: (bodyHeight)+"px"});
        
        if (bodyObj.scrollHeight > 0 
                && (bodyObj.scrollWidth - tempWidth) < this.options.tableOffsetW) {
            bodyObj.setStyle({overflowX: "hidden"});
        }
    },
    //设置表格头的宽度
    __setHeaderWidthAndHeight: function (tableObj) {
        var cellArr = tableObj.rows(0).cells;
        var len=cellArr.length;
        var obj = null;
        for (var i=0; i < len; i ++) {
            obj = $(cellArr[i]);
            var cellDims = {width: obj.getWidth()};
            obj.setStyle({width: cellDims.width + "px"});
            var cellDims2 = {width: obj.getWidth()};
            cellDims2.width = cellDims.width-(cellDims2.width-cellDims.width);
            //获取真正高度、宽度
            obj.setStyle({width: cellDims2.width + "px"});
        }
    },
    //创建表格头的固定区域
    __createTableHeader: function (tableObj) {
        this.__setHeaderWidthAndHeight(tableObj);
        tableObj.setStyle({tableLayout: "fixed"});
        
        var headerTab = null;
        var anotherTab = $(this.options.titleTabObj);
        if (anotherTab == null) {
            var rowObj = tableObj.rows(0);
            
            headerTab = new Element("table");
            this.__copyAttributes(tableObj, headerTab);
            
            headerTab.setStyle({
                height: $(rowObj).getHeight() + "px",
                tableLayout: "fixed"
            });
            headerTab.insert(new Element("thead").insert(tableObj.rows(0).outerHTML));
        } else {
            headerTab = anotherTab;
            this.__copyAttributes(tableObj, headerTab);
            //表格宽度复制
            var cellArr = headerTab.rows(0).cells;//表格头
            var cellArr2 = tableObj.rows(0).cells;//内容表格
            var obj = null;
            for (var i=0, len=cellArr.length; i < len; i ++) {
                obj = $(cellArr[i]);
                var oTd = $(cellArr2[i]);
                if (oTd == null) break;
                var cellDims = {width: oTd.getWidth()};
                var cellContentDims = {width: obj.getWidth()};
                /*if (cellContentDims.width > cellDims.width) {
                	oTd.setStyle({width: (cellContentDims.width) + "px"});
                	var widthTmp = oTd.getWidth();
                	oTd.setStyle({width: (widthTmp) + "px"});
                	var widthTmp2 = oTd.getWidth();
                	//获取真正宽度
                	oTd.setStyle({width: (widthTmp - (widthTmp2 - widthTmp)) + "px"});
                	
                	alert(i+":"+cellDims.width + ":"+(widthTmp - (widthTmp2 - widthTmp)))
                	continue;
                }*/
                obj.setStyle({width: cellDims.width + "px"});
                try {
                	cellDims.width = obj.getWidth();
                	obj.setStyle({width: cellDims.width + "px"});
	                var cellDims2 = {width: obj.getWidth()};
	                cellDims2.width = cellDims.width-(cellDims2.width-cellDims.width);
	                //获取真正高度、宽度
	                obj.setStyle({width: cellDims2.width + "px"});
                } catch(e){}//错误不做处理
            }
        }
        var tableDivObj = new Element("div");
        tableDivObj.insert(headerTab);
        
        var headerDivObj = new Element("div", {id: this.__getHearderId(tableObj)});
        headerDivObj.setStyle({
            position: "relative",
            top: "0px"
        });
        
        headerDivObj.insert(tableDivObj);
        return headerDivObj;
    },
    //创建body区域
    __createTabBody: function (tableObj) {
        var tableDivObj = new Element("div");
        tableDivObj.insert(tableObj);
        
        var bodyTab = new Element("div").setStyle({
            width: "100%",
            overflow: "auto",
            position: "relative"
        });
        bodyTab.observe("scroll", function (e) {
            var divObj = Event.element(e || event); 
            var left = divObj.scrollLeft;
            var headerDivObj = $("__JrafReTable_" + (tableObj.id || tableObj.name) + "_HeaderId");
            headerDivObj.setStyle({left: -left + "px"});
        });
        bodyTab.insert(tableDivObj);
        this.__hideHeaderAndPager(tableObj);
        return bodyTab;
    },
    //创建分页信息的固定区域
    __createTablePager: function (tableObj) {
        var rowObj = tableObj.rows(tableObj.rows.length - 1);
        
        var pagerTab = new Element("table");
        this.__copyAttributes(tableObj, pagerTab);
        
        pagerTab.setStyle({
            height: $(rowObj).getHeight() + "px",
            width: '100%',
            tableLayout: "fixed"
        });
        pagerTab.insert(new Element("tfoot").insert(rowObj.outerHTML));
        $(rowObj).remove();

        var tableDivObj = new Element("div");
        tableDivObj.insert(pagerTab);
        
        var pagerDivObj = new Element("div", {id: this.__getPagerId(tableObj)});
        pagerDivObj.setStyle({
            width: "100%",
            position: "relative",
            overflow: "hidden"
        });
        
        pagerDivObj.insert(tableDivObj);
        return pagerDivObj;
    },
    //隐藏原始表格头和分页信息
    __hideHeaderAndPager: function (tableObj) {
        var cellArr = tableObj.rows(0).cells;
        var cellObj = null;
        for (var i = 0, len = cellArr.length; i < len; i ++) {
            cellObj = cellArr[i];
            cellObj.style.height = "0px";
            cellObj.style.borderTop = "0px";
            cellObj.style.borderBottom = "0px";
            cellObj.style.overflow = "hidden";
            cellObj.innerHTML = "";
        }
    },
    __getMainId: function (tableObj) {
        return "__JrafReTable_" + (tableObj.id || tableObj.name) + "_MainId";
    },
    __getHearderId: function (tableObj) {
        return "__JrafReTable_" + (tableObj.id || tableObj.name) + "_HeaderId";
    },
    __getPagerId: function (tableObj) {
        return "__JrafReTable_" + (tableObj.id || tableObj.name) + "_PagerId";
    },
    __copyAttributes: function (srcObj, desObj) {
            var attrs = srcObj.attributes;
            var attrObj = null;
            for (var i=0, len=attrs.length; i < len; i ++) {
                try{
                    attrObj = attrs[i];
                    if(attrObj.nodeName == "id" && desObj.id == "") {
                        var id = attrObj.nodeValue + "_" + (new Date().getTime());
                        desObj.setAttribute("id", id);
                        desObj.id = id;
                    } else if (attrObj.nodeName.toLowerCase() == "class") {
                        if ("className" in srcObj) {
                            desObj.setAttribute("class", srcObj.className);
                            desObj.setAttribute("className", srcObj.className);
                        } else {
                            desObj.setAttribute("class", attrObj.nodeValue);
                            desObj.setAttribute("className", attrObj.nodeValue);
                        }
                    } else if (attrObj.nodeName.toLowerCase() == "style") {
                        desObj.style.cssText = srcObj.style.cssText;
                    } else if (attrObj.nodeName.toLowerCase() == "border") {
                        desObj.border = srcObj.border || "0";
                    } else {
                        if (attrObj.nodeName in desObj ) {
                            desObj[attrObj.nodeName] = srcObj[attrObj.nodeName];
                        } else {
                            desObj.setAttribute(attrObj.nodeName, srcObj.getAttribute(attrObj.nodeName));
                        }
                    }
                }catch(e){
                    //alert("[Jraf.ReTable][method=__copyAttributes]["+attrObj.nodeName+"="+attrObj.nodeValue+"]复制属性错误："+e.message);
                }
            }
    }
});
/**
 * 常用表单控件，数据查询、显示控制
 * @author yangx
 * @createdate 2013-07-22
 */
Jraf.Form = Class.create({
    initialize: function(options) {
        if(Object.isString(options)) {
            options = {selector: options};
        }
        this.options = {
            selector: "form",
            isCheck: "true"
        };
        Object.extend(this.options, options || { });
        this.options.ajaxObj = new Jraf.Ajax();
        
        this.init();
    },
    init: function () {
        var formArr = $$(this.options.selector);
        for (var i=0, len=formArr.length; i < len; i ++) {
            var obj = $(formArr[i]);
            /*if (obj.id == "") {
                obj.id = "__JrafForm_"+ new Date().getTime() +"_id";
            }*/
            this.doSpecialInput(obj);
        }
    },
    /**
     * 处理jraf平台的表单元素控件
     * 
     * @param oForm 表单对象
     */
    doSpecialInput: function (oForm) {
        var arr = oForm.selecte("select");
        for (var obj in arr ) {
            this.doSelectTag(obj);
        }
    },
    /**
     * <select name="" id=""
     *         jraf_form="true" 
     *         jraf_selecttype="normal|divselect|..."
     *         jraf_url=""
     *         jraf_sysName=""
     *         jraf_oprID=""
     *         jraf_actions=""
     *         jraf_params=""
     *         
     *         onmouseover=""
     *         onmouseout=""
     *         onmousedown
     *         onmouseup=""
     *         onkeydown=""
     *         onkeyup=""
     *         onkeypress=""
     *         onchange=""
     *         onclick=""
     *         ondblclick=""
     *         title=""
     *         >
     * </select>
     */
    doSelectTag: function (selObj) {
        selObj = $(selObj);
        var selType = selObj.readAttribute("jraf_selecttype");
        var params = Jraf.BlockAttribute.createParams(selObj);
        
        if (selType == "divselect") { 
            
            this.options.ajaxObj.loadPageTo(
                    selObj.readAttribute("jraf_url") || "/httpprocesserservlet", 
                    params, 
                    blockId, 
                    function () {
                        try {
                            eval(oCallBack);//执行回调
                        } catch (e) {
                            alert("[Jraf.LoadPageTo][method=doLoad][id=" + id 
                                    + "][callback=" + oCallBack + "]调用回调函数出错：" + e.message);
                        }
                    }
                );
        }
    }
});

/**
 * 文本框边输入字符边提示功能
 * (继承Jraf.DivSelector方法)
 * 参数：
 *     queryParams: JSON对象； 查询参数sysName/oprID/Actions/qryStr
 *     optionKeyName： 响应xml中record的节点的名称(默认为“value”)
 *     optionLabelName： 响应xml中record的节点的名称(默认为“name”)
 *     optionParamsName： 响应xml中record的节点的名称(默认为“params”)
 *     
 * 修改历史：
 *     2013-10-29 增加指定分隔符，一个文本框内可以查询多个值
 * @author yangx
 * @date 2013-07-23
 */
Jraf.DivSlct = Class.create(Jraf.DivSelector,
{
    initialize: function($super, options)
    {
        $super(options);
        var subOptions = {
                queryParams: options.queryParams, 
                optionKeyName: options.optionKeyName || "value",
                optionLabelName: options.optionLabelName || options.optionlabelName || "name",
                optionParamsName: options.optionParamsName || "params",//响应xml中record的节点的名称
                splitChar: ","
        };
        Object.extend(this.options, subOptions || { });
        
        //将说明，作为其他操作
        this.options.dspNameId = $(this.options.selectobj);
        
        //选择值后触发的方法
        if (typeof options.doOthersAfterSel == "function") {
            this.doOthersAfterSel = options.doOthersAfterSel;
        }
    
    },//initialize 结束
    /**
     * 选择值后，把选择值输入到光标处并隐藏下拉框
     * @param inputObj          文本框对象或对象ID
     * @param divselectedObj    下拉框对象或对象ID
     */
    outSelection : function(inputObj,divselectedObj)
    {
        var cursorIndex = this.options.cursorIndex;
        //选择后赋值
        var selValue = divselectedObj.getAttribute(this.options.divkey);//选项值
        var inputStr = inputObj.value;
        /*
         * 1.解析光标之前的字符串
         */
        var beforeStr = inputStr.substring(0, cursorIndex);
        //清除前面最后一个逗号到光标处的字符
        var lastCommaIndex = beforeStr.lastIndexOf(this.options.splitChar);
        if (lastCommaIndex != -1) {
            beforeStr = beforeStr.substring(0, lastCommaIndex+1);//包含逗号
        } else {//不存逗号在则直接清空
            beforeStr = "";
        }
        /*
         * 2.光标位置后的字符串值
         */
        var afterStr = inputStr.substr(cursorIndex);
        //清除到第一个逗号之间的内容
        var commaIndex = afterStr.indexOf(this.options.splitChar);
        if (commaIndex != -1) {
            afterStr = afterStr.substr(commaIndex);
        } else {//不存逗号在则直接清空
            afterStr = "";
        }
        //最终值赋值
        var inputValue = beforeStr + selValue +afterStr;
        inputObj.value = inputValue;
        
        var selLabel = divselectedObj.innerText;//选项标签值
        //inputObj.title = selLabel;
        /*
         * 返回结果，以"this.options.divparams"命名的值，做为选择后处理方法参数一部分
         * 形式： {params: "param1=value1&param2=value2&..."}
         */
        var params = divselectedObj.getAttribute(this.options.divparams);
        if (params != null && params.indexOf("=") != -1) {
        	params = "&" + params;
        } else {//返回结果没有以"this.options.divparams"命名的值, 默认将选择值做为参数
        	params = (params == null ? "" : "&" + this.options.optionParamsName + "=" + params );
        }
        
        //设置光标位置
        this.setCursorIndex((beforeStr + selValue).length);
        
        params = this.options.optionKeyName + "=" + selValue + "&" + this.options.optionLabelName
                    + "=" + selLabel + params;
        params = params.toQueryParams();//转化成JSON对象
        //后续处理
        this.doOthersAfterSel(params);
    },//outSelection 结束
    /**
     * 失去焦点时处理
     */
    getSelectDataName: function ($super, options) {
        var inputObj = $(this.options.selectobj);
        if (inputObj == null) 
            return;
        var inputValue = inputObj.value;
        inputValue = inputValue.replace(/(^[,\s]*,)|(,[,\s]*$)/g, "");
        inputValue = inputValue.replace(/(,[,\s]*,)/g, ",");
        return inputValue.trim();
    },
    /**
     * 根据文本框的值，查询下拉框选择值
     * @param   inputObj 文本框对象或对象ID
     * @return  JSON对象  {value: value, name: name}
     */
    getSelectData : function(inputObj)
    {
        var datas = [];
        //当前光标位置
        var cursorIndex = this.getCursorPosition(inputObj);
        var inputStr = inputObj.value;
        var beforeStr = inputStr.substring(0, cursorIndex);
        var lastCommaIndex = beforeStr.lastIndexOf(this.options.splitChar);
        var qryStr = "";
        if (lastCommaIndex != -1) {
            qryStr = beforeStr.substr(lastCommaIndex+1);
        } else {//不存逗号在则直接清空
            qryStr = beforeStr;
        }
        datas = this.query(inputObj, qryStr);
        return datas;
    },//getSelectData  结束
    /**
     * 查询
     * @param   qryStr 条件
     * @return datas[]
     */
    query:function(inputObj, qryStr){
    	/***************** csj 2013-12-4 添加查询数据前，回调方法检查更新外部查询条件的更新（如果回调方法存在的话） *****************/
		if(this.options["changeQueryParamFun"] && (typeof this.options["changeQueryParamFun"]).toUpperCase() === "function".toUpperCase()){
			// 回调方法的参数签名：function(Jraf.DivSlct实例对象,关联的文本域html对象)
			var newParams =this.options["changeQueryParamFun"](this, this.options["selectobj"]);
			if(newParams){
				this.changeParams(newParams);
			}
		}
    	/*********************************************************************/
        var param = this.options.queryParams;
        param.pageSize = this.options.pageSize;

        /**
         * *************** csj 2013-12-21 *************************
         * 添加可自定义将文本域内输入的内容设置为查询条件时的参数名
         */
        var fieldQueryName= this.options["queryName"];
        if(!fieldQueryName){
            fieldQueryName= inputObj.name;
        }
        param[fieldQueryName]= qryStr ? qryStr : '';
        // param[inputObj.name]= qryStr ? qryStr : '';
        /** ****************** csj 2013-12-21 end *********************************** */
        
        var datas = [];
        //实现
        if(param == null || param == '') {
            alert("[Jraf.DivSlct][method=query]参数不能为空。");
            return;
        }
        var ajax = new Jraf.Ajax({asynchronous: false});
        var optionKeyName = this.options.optionKeyName;
        var optionLabelName = this.options.optionLabelName;
        var params = this.options.optionParamsName;
        
        var divkey = this.options.divkey;
        var divlabel = this.options.divlabel;
        var divparams = this.options.divparams;
        ajax.sendForXml("/xmlprocesserservlet", param, function (xml) {
            try{
                var pkg = new Jraf.Pkg(xml);
                if(pkg.result() != '0'){
                    Jraf.showMessageBox({
                        text: "查询出错。",
                        type: "error"
                    });
                    return;
                }
                var rcds = pkg.rspDatas().Record;
                if(!rcds){
                    datas.push({value: "", name: "--无数据--"});
                    return datas;
                }
                if(!Object.isArray(rcds)) rcds = [rcds];
                for (var i=0, len=rcds.length; i < len; i ++) {
                    var rcd = rcds[i];
                    var paramValues = (rcd[params] == null ? "" : (rcd[params]));
                    var json={};
                    json[divkey] = rcd[optionKeyName];
                    json[divlabel] = "["+rcd[optionKeyName]+"]"+rcd[optionLabelName];
                    json[divparams] = paramValues;
                    
                    datas.push(json);
                }
            }catch(e){alert('[Jraf.DivSlct][method=query]ERROR:'+e.message);}
        });
        return datas;
    },//query end
    /**
     * 修改查询参数
     */
    changeParams: function (params) {
        Object.extend(this.options.queryParams, params || { });
    },
    /**
     * 当选择下拉框值后的后续处理
     * @param params 做为条件的字符串
     */
    doOthersAfterSel: function (params) {
        //自定义实现
    }
});

/*String.prototype.endWith=function(str){
	if(str==null||str==""||this.length==0||str.length>this.length)
	  return false;
	if(this.substring(this.length-str.length)==str)
	  return true;
	else
	  return false;
	return true;
	};*/
	