String.prototype.trim = function(){
    return this.replace(/(^\s*)|(\s*$)/g, "");
}

//将1,234,567.00转换为1234567.00
function moneyToNumFiled(obj) {
    var num=obj.value.trim();
    var ss=num.toString();
	if(ss.length==0){
	  return "";
	}	
    num=new Number(ss.replace(/,/g, ""));
	if(!/^(\+|-)?\d+(\.[0-9]{1,2})?$/.test(num)){
	  alert("必须是数字型,切小数位最多保留两位"); 
	  obj.value="";
	  obj.focus();
	  return ;
    }
	obj.value=num;
	   
}

//将1,234,567.00转换为1234567.00
function moneyToNumValue(val) {
    var num=val.trim();
    var ss=num.toString();
	if(ss.length==0){
	  return "0";
	}	
    return ss.replace(/,/g, "");
	
}

//将1234567.00转换为1,234,567.00
function numToMoneyField(obj) {
   
    var ss=obj.value.toString().trim();
	if(ss.length==0){
	  return "";
	}	
    var num=new Number(ss.replace(/,/g, ""));
	if(!/^(\+|-)?\d+(\.[0-9]{1,2})?$/.test(num)){
		
	  alert("必须是数字型,切小数位最多保留两位"); 
	  obj.value="";
	  obj.focus();
	  return;
    }
	
	if(num<0){
		obj.value = '-'+outputDollars(Math.floor(Math.abs(num)-0) + '') + outputCents(Math.abs(num) - 0);
	}else{
	    obj.value = outputDollars(Math.floor(num-0) + '') + outputCents(num - 0);
	}
}

//将1234567.00转换为1,234,567.00
function numToMoneyValue(val) {
   
    var ss=val.toString().trim();
	if(ss.length==0){
	  return "";
	}	
    var num=new Number(ss.replace(/,/g, ""));
	if(!/^(\+|-)?\d+(\.[0-9]{1,2})?$/.test(num)){
	  alert("必须是数字型,切小数位最多保留两位");	  
	  return "";
    }
	
	if(num<0){
		return '-'+outputDollars(Math.floor(Math.abs(num)-0) + '') + outputCents(Math.abs(num) - 0);
	}else{
	    return outputDollars(Math.floor(num-0) + '') + outputCents(num - 0);
	}
}

function Chinese(num){   
    var AA = new Array("零","壹","贰","叁","肆","伍","陆","柒","捌","玖");
    var BB = new Array("","拾","百","千","万","亿","","");
    var CC = new Array("角","分","");
    
    var a = (""+ num).replace(/(^0*)/g, "").split("."), k = 0, re = "";

    for(var i=a[0].length-1; i>=0; i--){
        switch(k){
            case 0 : re = BB[7] + re; break;
            case 4 : if(!new RegExp("0{4}\\d{"+ (a[0].length-i-1) +"}$").test(a[0]))
                     re = BB[4] + re; break;
            case 8 : re = BB[5] + re; BB[7] = BB[5]; k = 0; break;
        }
        if(k%4 == 2 && a[0].charAt(i+2) != 0 && a[0].charAt(i+1) == 0) re = AA[0] + re;
        if(a[0].charAt(i) != 0) re = AA[a[0].charAt(i)] + BB[k%4] + re; k++;
    }
	if(re.trim().length>0){
	  re+="元"; 
	}
    
    if(a.length>1){ //加上小数部分(如果有小数部分)
        re += BB[6];
        for(var i=0; i<a[1].length; i++){
          if(i>1) break;
          re += AA[a[1].charAt(i)] + CC[i];
        }
    }

    return re;
}


function outputDollars(number) {
    if (number.length<= 3)
        return (number == '' ? '0' : number);
    else {
        var mod = number.length%3;
        var output = (mod == 0 ? '' : (number.substring(0,mod)));
        for (i=0 ; i< Math.floor(number.length/3) ; i++) {
           if ((mod ==0) && (i ==0))
              output+= number.substring(mod+3*i,mod+3*i+3);
           else
              output+= ',' + number.substring(mod+3*i,mod+3*i+3);
        }
        return (output);
    }
}

function outputCents(amount) {
   amount = Math.round( ( (amount) - Math.floor(amount) ) *100);
   return (amount<10 ? '.0' + amount : '.' + amount);
}

