function isDate(DateString , Dilimeter)
{
    if (DateString==null) return false;
    if (Dilimeter=='' || Dilimeter==null)
        Dilimeter = '-';
    var tempy='';
    var tempm='';
    var tempd='';
    var tempArray;
    if (DateString.length<8 && DateString.length>19)
        return false;
    tempArray = DateString.split(Dilimeter);
    if (tempArray.length!=3)
        return false;
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
    var tDateString = tempy + '/'+tempm + '/'+tempd+' 8:0:0';
    var tempDate = new Date(tDateString);
    if (isNaN(tempDate))
        return false;
    if (((tempDate.getUTCFullYear()).toString()==tempy) && (tempDate.getMonth()==parseInt(tempm)-1) && (tempDate.getDate()==parseInt(tempd)))
    {
        return true;
    }
    else
    {
        return false;
    }
}

function isDateEight(DateString)
{
    if (DateString==null) return false;
    var tempy='';
    var tempm='';
    var tempd='';
    if (DateString.length<8 && DateString.length>10)
        return false;
	tempy = DateString.substring(0,4);
    tempm = DateString.substring(4,6);
    tempd = DateString.substring(6,8);
	if (tempm.substring(0,1)==0){
		tempm = tempm.substring(1,2);
	}
	if (tempd.substring(0,1)==0){
		tempd = tempd.substring(1,2);
	}
    var tDateString = tempy + '/'+tempm + '/'+tempd+' 8:0:0';

    var tempDate = new Date(tDateString);
    if (isNaN(tempDate))
        return false;
    if (((tempDate.getUTCFullYear()).toString()==tempy) && (tempDate.getMonth()==parseInt(tempm)-1) && (tempDate.getDate()==parseInt(tempd)))
    {
        return true;
    }
    else
    {
        return false;
    }
}


function isNumber(string,sign)
{
	var number;
	if (string==null || "" == string) return false;
	if ((sign!=null && sign!='') && (sign!='-') && (sign!='+'))
	{
		return false;
	}
	
	number = new Number(string);
	if (isNaN(number))
	{
		return false;
	}
	else if ((sign==null) || (sign=='') || (sign=='-' && number<0) || (sign=='+' && number>=0))
	{
		return true;
	}
	else
		return false;
}

function isNumScale(string,intlen,scale,sign)
{
	ilen = parseInt(intlen);
	iscale = parseInt(scale); 
	if(isNaN(ilen) || ilen <1)
	{
	    return false;
	}
	if(isNaN(iscale) || scale<0)
	{
		scale = 0;
	}
	if(null == sign)
	{
		sign='';
	}
	if(isNumber(string,sign))
	{
		var tmparray;
		tmparray = string.split('.');
		if(tmparray.length==2)
		{
			if(tmparray[1].length>scale)
			{
				return false;
			}
		}
		num = new Number(string);
		var max=1;
		for(i=0;i<intlen;i++)max=max*10;
		if((num>=0 && (sign==''||sign==null||sign=='+') && num<max)||
		   (num<0 && (sign==''||sign==null||sign=='-') && -num<max))
			return true;
	}
	return false;
}

function isInteger(string ,sign)
{ 
	var integer;
	if ((sign!=null) && (sign!='-') && (sign!='+'))
	{
		return false;
	}
	integer = parseInt(string);
	if (isNaN(integer))
	{
		return false; 
	}
	else if (integer.toString().length==string.length)
	{ 
		if ((sign==null) || (sign=='-' && integer<0) || (sign=='+' && integer>=0))
		{
			return true;
		}
		else
			return false; 
	}
	else
		return false;
}