/****************************************************
 * 
 * @history:
 * yx@2012-02-27: 修改cleanSpan方法
 * yx@2014-03-10: 增加日期比较方法
 * yx@2014-04-09: 增加日期格式化方法
 *****************************************************/
/**       
 * 对Date的扩展，将 Date 转化为指定格式的String       
 * 月(M)、日(d)、12小时(h)、24小时(H)、分(m)、秒(s)、周(E)、季度(q) 可以用 1-2 个占位符       
 * 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字)       
 * eg:       
 * (new Date()).pattern("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423       
 * (new Date()).pattern("yyyy-MM-dd E HH:mm:ss") ==> 2009-03-10 二 20:09:04       
 * (new Date()).pattern("yyyy-MM-dd EE hh:mm:ss") ==> 2009-03-10 周二 08:09:04       
 * (new Date()).pattern("yyyy-MM-dd EEE hh:mm:ss") ==> 2009-03-10 星期二 08:09:04       
 * (new Date()).pattern("yyyy-M-d h:m:s.S") ==> 2006-7-2 8:9:4.18       
 */          
Date.prototype.pattern=function(fmt) {
    var o = {           
        "M+" : this.getMonth()+1, //月份           
        "d+" : this.getDate(), //日           
        "h+" : this.getHours()%12 == 0 ? 12 : this.getHours()%12, //小时           
        "H+" : this.getHours(), //小时           
        "m+" : this.getMinutes(), //分           
        "s+" : this.getSeconds(), //秒           
        "q+" : Math.floor((this.getMonth()+3)/3), //季度           
        "S" : this.getMilliseconds() //毫秒           
    };           
    var week = {           
        "0" : "/u65e5",           
        "1" : "/u4e00",           
        "2" : "/u4e8c",           
        "3" : "/u4e09",           
        "4" : "/u56db",           
        "5" : "/u4e94",           
        "6" : "/u516d"          
    };           
    if(/(y+)/.test(fmt)){           
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    }           
    if(/(E+)/.test(fmt)){ 
        fmt=fmt.replace(RegExp.$1, ((RegExp.$1.length>1) ? (RegExp.$1.length>2 ? "/u661f/u671f" : "/u5468") : "")+week[this.getDay()+""]);
    }           
    for(var k in o){ 
        if(new RegExp("("+ k +")").test(fmt)){ 
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
        }
    }
    return fmt;
};


//激活输入组件的焦点
function focusIt(obj){
  try{
    var ele = mtb;
  }catch(e){
    try{
      obj.focus();
      return;
    }catch(e){
      return;
    }
  }
  for (var i=0;i<ele.length;i++){
    swH(i);
    try{
      obj.focus();
    }catch(e){
      continue;
    }
    break;
  }
  try{
    obj.focus();
  }catch(e){
    return false;
  }return true;
}
var customtypes = new Array(
"req",//必输项
"num",
"plus",
"int",
"email",
"phone",
"page",
"userNo",
"link",
"password",
"name",
"date",
"money",
"date8",
"datetime",
"dateYM"
);

var custommessage = new Array(
"此项为必须项。",
"不是一个有效的数字。",
"不是一个有效的正整数。",
"不是一个有效的整数。",
"不是一个有效的电子邮件地址。",
"不是一个有效的手机号码,请填写11位数字手机号码。",
"不是一个有效的显示记录是，请填写1000以内的数字字符。",
"长度必须是大于等于2且小于等于20的字符",
"不是一个有效的链接，请确认输入了完整的地址，例如http://www.sunline.cn。",
"只能使用字母、下划线与数字。",
"不是一个有效的名称，名称只能使用字母、下划线与数字，不能包含符号与空格。",
"不是一个有效的日期（日期格式yyyy-MM-dd）",
"不是一个有效的金钱格式。",
"不是一个有效的8位日期，如：20050801。",
"不是一个有效的日期时间格式（yyyy-MM-dd HH:mm）",
"不是一个有效的日期时间格式（yyyy-MM）"
);

/**
 * 校验表单元素
 * @param oForm  form对象或form表单中元素对象数组或单个表单元素对象
 * @param event
 * @return
 */
function checkForm(oForm,event){
  if (oForm == null) {
      alert("[checkForm.js][method=checkForm]第一个参数不能为空。");
      return false;
  }
  if(event)
      event.returnValue = false;
  var returnFlag = true;
  var ele = null;
  var idStr = null;
  var ct = null;    //customtype值
  var req = null;    //req属性值
  var dn = null;     //displayname属性值
  var nr = null;     //表单值
  var rtn = null;     //校验方法返回值
  var oFormEles = [];
  oForm = $(oForm);
  if (oForm && oForm.tagName && oForm.tagName.toLowerCase() === "form") {
      oFormEles = oForm.elements;
  } else if (Object.isArray(oForm)) {//判断是数组
      oFormEles = oForm;
  } else {
      oFormEles = [oForm];
  }
  //清除所有 显示错误信息
  for(var t=0, eleLen=oFormEles.length; t < eleLen;t++)
  {
      ele = oFormEles[t];
      cleanSpan(ele);
  }
  for (var i=0, eleLen=oFormEles.length; i < eleLen; i++){
    ele = oFormEles[i];
    if (("disabled" in ele) && ele.disabled == true) {
        continue;//被禁用的表单不做校验
    }
    ct = ele.getAttribute("customtype");
    req = ele.getAttribute("req");
    dn = ele.getAttribute("displayname");
    if (null == dn){
      dn = "此项";//ele.name;
    }
    if ("1" == req || (ct == "req")){
      nr = new String(ele.value);
      if (nr.trim().length < 1){
        hint_alert(ele,dn + "为必输项.");
        focusIt(ele);
        returnFlag = false;
        //alert(dn + "不可以省略，请重新输入。");
        //ele.focus();
        //focusIt(ele);
      }
    }
    if((''==req || '0' ==req || null==req ) &&(ele.value == "")) continue;//不必要且没有输入时，下一个
    if (((!req)||(!ct)) &&(ele.value == "")) continue;
    //检查自定义类型
    //纠正自定义类型在req不等于1时仍要求输入的bug
    if ("1" == req || ct != "") {
        for (var j=0;j<customtypes.length;j++){
          if (ct == customtypes[j]){
              if(ct=="money"){
                  eval("rtn = check_" + customtypes[j] + "(ele);");
              }else{
                  eval("rtn = check_" + customtypes[j] + "(ele.value);");
              }
              if (!rtn){
                  hint_alert(ele,dn + custommessage[j]);
                  //ele.focus();
                  focusIt(ele);
                  returnFlag = false;
              } 
          }
        }
      }//if end
  }//for end
  if(event)
      event.returnValue = true;
  return returnFlag; 
}

function check_money(s) {
    s.value=s.value.replace(/,/g, "")
    var re = /^(\+|-)?\d+(.\d+)?$/i;
    return re.test(s.value);
}

function check_email(s){
  var re = /^\w+@(\w)+((.(\w)+)+)?$/i;
  return re.test(s);
}

function check_num(s){
  var re = /^(\+|-)?\d+(.\d+)?$/i;
  return re.test(s);
}

function check_int(s){
  var re = /^(\+|-)?\d+$/i;
  return re.test(s);
}

function check_plus(s) {
  var re = /^[1-9]\d*$/i
  return re.test(s);
}

function check_link(s){
  var re = /^(http|mailto|ftp|https|telnet):\/{2}/i;
  return re.test(s);
}

function check_password(s){
  var re = /^\w+$/i;
  return re.test(s);
}

function check_req(s){
    return (s.trim().length > 0);
}

function check_name(s){
  return check_password(s);
}

function check_date8(DateString){
   return isDateEight(DateString);
}

function check_datetime(DateString){
	//modify by Tony 添加对yyyy-MM-dd HH:mm:ss格式的匹配
    var reg = new RegExp("^(?!0000)[0-9]{4}-((0[1-9]|1[0-2])-(0[1-9]|1[0-9]|2[0-9])|(0[13-9]|1[0-2])-(29|30)|(0[13578]|1[02])-31) ([01][0-9]|2[0-3])(:([0-5][0-9])){1,2}$");
    var  str   =   Trim(DateString); 
    if   (str=="")
    {
        return  false; 
    }  
    if (!reg.test(str))
    {  
        return  false;  
    }
    return true;
}
function check_date(DateString)
{
	var reg = new RegExp("^(?!0000)[0-9]{4}-((0[1-9]|1[0-2])-(0[1-9]|1[0-9]|2[0-9])|(0[13-9]|1[0-2])-(29|30)|(0[13578]|1[02])-31)$");
    var  str   =   Trim(DateString); 
    if   (str=="")
    {
        return  false; 
    }  
    if (!reg.test(str))
    {  
        return  false;  
    }
    return true;
}
/**
 * 校验日期：yyyy-MM格式
 * @param DateString
 * @return
 */
function check_dateYM(DateString)
{
    var reg = new RegExp("^(?!0000)[0-9]{4}-(0[1-9]|1[0-2])$");
    var  str   =   Trim(DateString); 
    if (str=="")
    {
        return  false; 
    }  
    if (!reg.test(str))
    {  
        return  false;  
    }
    return true;
}
function  Trim(m){   
	  while((m.length>0)&&(m.charAt(0)==' '))   
	  m = m.substring(1, m.length);   
	  while((m.length>0)&&(m.charAt(m.length-1)==' '))   
	  m = m.substring(0, m.length-1);   
	  return m;   
} 
function check_date1(DateString){
    if (DateString==null) return false;
    if (Dilimeter=='' || Dilimeter==null)
    var Dilimeter = '-';
    if (Dilimeter.indexOf("/")>0)
    {
        Dilimeter="/";
    }
    var tempy='';
    var tempm='';
    var tempd='';
    var tempH="";
    var tempM="";
    var tempS="";
    var tempymd="";
    var temphms="";
    var tempArray;
    if (DateString.length<8 && DateString.length>19) {
        return false;
    }
    if (DateString.indexOf(" ")>0)
    {
        temp=DateString.split(" ");
        tempymd=temp[0];
        temphms=temp[1];
    }
    else
    {
        tempymd=DateString;
        temphms="00:00:00";
    }
    tempArray = tempymd.split(Dilimeter);
    if (tempArray.length!=3) {
        return false;
    }
    if (tempArray[0].length==4)
    {
        tempy = tempArray[0];
        tempd = tempArray[2];
        tempm = tempArray[1];
    }
    else
    {
        tempy = tempArray[2];
        tempd = tempArray[1];
        tempm = tempArray[0];
    }
    tempArray = temphms.split(":");
    if (tempArray.length>3  || tempArray.length<2) {
        return false;
    }
    switch (tempArray.length) {
        case 2:
            tempH=tempArray[0];
            tempM=tempArray[1];
            tempS="00";
            break;
        case 3:
            tempH=tempArray[0];
            tempM=tempArray[1];
            tempS=tempArray[2];
            break;
    }
    var tDateString = tempy + '/'+tempm + '/'+tempd+' '+tempH+":"+tempM+":"+tempS;
    var tempDate = new Date(tDateString);
    if (isNaN(tempDate)) {
        return false;
    }
    if ((tempDate.getYear().toString()==tempy || tempDate.getYear()==parseInt(tempy,10)-1900) 
        && (tempDate.getMonth()==parseInt(tempm,10)-1) 
        && (tempDate.getDate()==parseInt(tempd,10)) 
        && (tempDate.getHours().toString()==parseInt(tempH,10)) 
        && (tempDate.getMinutes().toString()==parseInt(tempM,10)) 
        && (tempDate.getSeconds().toString()==parseInt(tempS,10)))
    {
        return true;
    }
    else
    {
        //alert('tDateString='+tDateString);
        return false;
  }
}

function check_phone(s){
    var phoneNmu = s;
    if(check_num(phoneNmu)&&(phoneNmu.length == 11 || phoneNmu.length == 12)){//如深圳的电话号码长度为12
        return true;
    }else{
        return false;
    }    
}

function check_page(s){
    var pageNum =  s;
    if(check_num(pageNum)){
        if(s.length > 3){
            return false;
        }else{
            return true;
        }
    }else{
        return false;
    }
} 

function check_userNo(s){
    var userNo = s;
        if(userNo.length>=2&&userNo.length<=20)
            return true;
        else
            return false;
}

function numericInput(n)
{
    var n; if(!n) n = 0;
    var kc = event.keyCode;
    //alert(event.srcElement.onselectstart)
    if((kc<48||kc>57)&&(kc<96||kc>105)&&kc!=190&&kc!=110&&kc!=144&&kc!=8&&kc!=13&&kc!=46 &&kc!=37&&kc!=38&&kc!=39&&kc!=40&&kc!=16&&kc!=35&&kc!=36) {
        event.returnValue = false; event.keyCode = 0;
    }
else {
        if((kc>47 && kc<58)||(kc>95&&kc<106))
        {
            var obv = event.srcElement.value;

            if((obv.indexOf(".")>=0&&(kc==190||kc==110))
                || (n>0&&obv.indexOf(".")>0&&(obv.length-obv.indexOf(".")-1)>=n)){
                event.returnValue = false;    event.keyCode = 0;
            }
        }
    }
}
//数字输入限制
//i 整数位个数，不限为0
//d 小数位个数，无小数位为0，不限-1
//s 正负号+|-，缺省为''
function numinput(i,d,s)
{
    var d; if(!d) d = 0;
    var i; if(!i) i = 0;
    var s; if(!s) s = "";
    
    var kc = event.keyCode;
    if((kc == 0)||(kc == 8)||(kc == 9)||(kc == 13)||(kc == 27)) {
        return;
    }    
    
    var tes = '/^';
    if(""==s)        tes = tes+'(\\+|-)?';
    else if("+"==s)    tes = tes+"\\+?";
    else if("-"==s)    tes = tes+"\\-";
    
    tes=tes+"(";
    if(i>0)
    {
        for(j=0;j<i;j++)
        {
            tes = tes+"\\d?";
        }
    }
    else
    {
        tes = tes+"\\d+";
    }
    if(d>0)
    {
        tes = tes+"(\\.";
        for(j=0;j<d;j++)
        {
            tes=tes+"\\d?";
        }
        tes=tes+")?";
    }
    else if(d<0)
    {
        tes=tes+"(\\.(\\d+)?)?";
    }
    tes=tes+")?$/i";
        
    var obv = event.srcElement.value;
    var oRange = document.selection.createRange();
    var oldtxt = oRange.text;
    oRange.text = String.fromCharCode(event.keyCode);
    
    if("false"==""+eval(tes+".test(\""+event.srcElement.value+"\")"))
    {
        if('' != oldtxt)
        {
            document.selection.clear();
            oRange.text=oldtxt;
        }
        else
        {
            event.srcElement.value = obv;                
        }        
    }
    else
    {
        if('' != oldtxt)
        {
            oRange.collapse(true);
            document.selection.clear();
            oRange.text = String.fromCharCode(event.keyCode);
        }
    }    
    event.returnValue = false;    event.keyCode = 0;
}
/*
function highlightFormElements() {
    // add input box highlighting 
    addFocusHandlers(document.getElementsByTagName("input"));
    addFocusHandlers(document.getElementsByTagName("textarea"));
}

function addFocusHandlers(elements) {
    for (i=0; i < elements.length; i++) {
        if (elements[i].type != "button" && elements[i].type != "submit" &&
            elements[i].type != "reset" && elements[i].type != "checkbox" && elements[i].type != "radio") {
            if (elements[i].getAttribute('readonly') != "readonly" && elements[i].getAttribute('readonly') != "disabled") {
                elements[i].onfocus=function() {this.className='focus';this.select()};
                elements[i].onblur=function() {this.className='inputtext'};
            }
        }
    }
}
window.onload = function() {
    highlightFormElements();
    if ($('successMessages')) {
        new Effect.Highlight('successMessages');
        // causes webtest exception on OS X : http://lists.canoo.com/pipermail/webtest/2006q1/005214.html
        // window.setTimeout("Effect.DropOut('successMessages')", 3000);
    }
    if ($('errorMessages')) {
        new Effect.Highlight('errorMessages');
    }
}
*/
// Show the document's title on the status bar
window.defaultStatus=document.title;
/**
 * @author windyfly
 * @param nextField String, indicate to which form field will obtain the focus
 * @param index number,indicate to the record order
 * description : if user indicate the next and/or index param,
 * when press an enter key, the focus will shift to the next form field.
 * to call this function, you need use your jsptaglib like:
 * <sc:tagName next="nextField" index="index" /> or just <sc:tagName next="nextField" />
 */
function nextInput(nextField, indexNum) {
  var focusObj = document.getElementsByName(nextField);
  for (var i=0; i<focusObj.length; i++) {
    if ((focusObj[i].type != "hidden") && (!focusObj[i].disabled)) {
    if ((indexNum != null) && (indexNum != "") && (parseInt(indexNum) < focusObj.length)) {
        focusObj[indexNum].focus();
        //focusIt(focusObj[indexNum]);
      }
    else {
        focusObj[i].focus();
        //focusIt(focusObj[i]);
      }
    }
  }
}
/**
 * @author windyfly
 * @param current field object.
 * description : format the money field by : #*.##,
 * when the money filed onblur then do this function and format.
 */
function fmtMoney(field) {
  var fmtValue = field.value;
  var len = 2;
  if ((fmtValue.length > 0) && check_money(field)) {
    if ((fmtValue.indexOf(".") > 0)) {
      var valueArray = fmtValue.split(".");
      var intV = valueArray[0];
      var fltV = valueArray[1];
      for (var i = fltV.length ; i < len; i++) {
        fltV = fltV + "0";
      }
      if (fltV.length > len) {
        fltV = fltV.substring(0,len);
      }
      field.value = intV + "." + fltV;
      //alert("1::"+addComma(field.value));
      field.value =addComma(field.value);
    }
    else {
      field.value = fmtValue + ".00";
      //alert("1::"+addComma(field.value));
      field.value =addComma(field.value);
    }
  }
}

/**
 * @author dailh
 * @param current field object.
 * description : format the money field by : ###,#*.##,
 * when the money filed onblur then do this function and format.
 */

function addComma(oldNum)
{
   var initNum= oldNum.split(",");
   var str="";
   for(var x=0;x<initNum.length;x++){
      str+=initNum[x];
   }
   oldNum = str;
	var dotOffset = oldNum.indexOf('.');
		if(dotOffset == -1)
			{
				dotOffset = oldNum.length;
				newNum = '';
			}
		else
		{
			newNum = '.';
			for(var i = dotOffset + 1, maxIndex = oldNum.length - 3; i < maxIndex; i += 3)
			{
				newNum = newNum.concat(oldNum.substr(i, 3), ',');
			}
				newNum = newNum.concat(oldNum.substr(i));
		}
		for(var i = dotOffset - 3; i > 0; i -= 3)
		{
			newNum = ','.concat(oldNum.substr(i, 3), newNum);
		}
			newNum = oldNum.substr(0, i + 3) + newNum;
			return newNum;
}

/**
 * 在元素旁边弹出浮动提示框
 * 注意： 元素的名称（name）值要唯一
 * @param obj        html元素对象
 * @param message   要显示的提示信息
 * @return
 */
function hint_alert(obj, message){
    if(obj == null) {
        alert("[filena=checkForm.js][method=hint_alert]ERROR: 第一个参数不能为空！");
        return;
    }
    if(message == null) {
        alert("[filena=checkForm.js][method=hint_alert]ERROR: 第二个参数不能为空！");
        return;
    }
    var idStr = (obj.id || obj.name) + "_hint_span";
    if(document.getElementById(idStr)){
        $(idStr).remove();
    }
    var spanEle = new Element('span',{
        id:  idStr
    }).addClassName("hintspan");
    
    obj.setAttribute("__Jraf_Check_borerStyle", obj.style.borderStyle); 
    obj.setAttribute("__Jraf_Check_borerColor", obj.style.borderColor); 
    
    //设置位置
    $(obj).up(0).style.position = "relative";
    spanEle.onclick= function (){
       event.cancelBubble=true;
       //$(idStr).remove();
       cleanSpan(obj);
    };
    spanEle.update(message);
    obj.insert({after: spanEle});
    //限制宽度
    var spanW = spanEle.getWidth()-2;
    if (spanW < 50) {
        spanEle.setStyle({width: (50)+"px"});
    } else if (spanW > 400) {
        spanEle.setStyle({width: (400)+"px"});
    }
    //输入框样式
    obj.style.borderStyle="dotted";
    obj.style.borderColor="#ff3300";
}

/**
 * 清除提示框
 * @param inputObj
 * @return
 */
function cleanSpan(inputObj)
{
    if(inputObj == null) {
        alert("[filena=checkForm.js][method=cleanSpan]ERROR: 参数不能为空！");
        return;
    }

    var borderStyle = inputObj.getAttribute("__Jraf_Check_borerStyle") || "";
    var borderColor = inputObj.getAttribute("__Jraf_Check_borerColor") || "";
    inputObj.style.borderStyle = (borderStyle=="dotted"?"":borderStyle);
    inputObj.style.borderColor = (borderColor=="#ff3300"||borderColor=="rgb(255, 51, 0)"?"":borderColor);
    
    var hintSpanObj = $((inputObj.id || inputObj.name) + "_hint_span");
    if (!!hintSpanObj)
        hintSpanObj.remove();
}

/**
 * 校验日期输入 
 * @param begndt 开始日期｛yyyy-MM-dd HH:mm:ss｝
 * @param overdt 结束日期｛yyyy-MM-dd HH:mm:ss｝
 * @return true 开始日期小于等于结束日期；否则false 
 */
function compareDate(begndtInput, overdtInput){
    try {
        if (begndtInput == null 
                || overdtInput == null 
                    || begndtInput.value.trim() == "" 
                        || overdtInput.value.trim() == "") {
            alert("[checkForm.js][method=compareDate]日期参数不能为空！");
            return false;
        }
        
        // 校验结束日期不早于开始日期
        var begnDate = new Date(begndtInput.value.replace(/-/g, "/"));
        var overDate = new Date(overdtInput.value.replace(/-/g, "/"));
        if(Date.parse(overDate) - Date.parse(begnDate) < 0){
            hint_alert(overdtInput, "“结束日期”不能早于开始日期，请重新输入！");
            return false;
        }
    } catch (e) {
        alert("[checkForm.js][method=compareDate]JSERROR:"+e.message);
        return false;
    }
    return true;
}

/**
 * 
 * 时间比较  先将 [年-月-日 时:分:秒] 转换成 [月-日-年 时:分:秒] 然后比较
 * 
 * ***/
function checkTime(beginTime,endTime){
   try{	
		if(beginTime == null || beginTime.trim() == "" || endTime == null || endTime.trim() == ""){
			return true;
		}
		var beginTimes = beginTime.substring(0, 10).split('-');
		var endTimes = endTime.substring(0, 10).split('-');
	    beginTime = beginTimes[1] + '-' + beginTimes[2] + '-' + beginTimes[0] + ' ' + beginTime.substring(10, 19);
	    endTime = endTimes[1] + '-' + endTimes[2] + '-' + endTimes[0] + ' ' + endTime.substring(10, 19);
	    if((Date.parse(endTime)-Date.parse(beginTime))<0){
	    	hint_alert($$("input[name='endtime']")[0], " “日志终止时间”不能早于日志开始时间，请重新输入！");
	    	return false;
	    }else{
	    	return true;	
	    }
   }catch(e){
	   alert("[checkForm.js][method=checkTime]JSERROR:"+e.message);
       return false;
   }
}