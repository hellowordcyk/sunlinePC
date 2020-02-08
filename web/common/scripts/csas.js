function ShowSeletedOption(strName,strValue)
{
	try{
		var tmpValue1=strValue
		var tmpCTL=eval(strName)
		for (i=0; i< tmpCTL.options.length; i++){
			tmpValue2=tmpCTL.options[i].value
			if(tmpValue2==tmpValue1){
				tmpCTL.options[i].selected=true
				return true
			}
		}
	}
	catch(e){
		return false
	}
}
function OpenWin(sURL,iWidth,iHeight)
{
   window.open(sURL,dfGetRandomString(),"toolbar=no,location=no,status=no,menubar=yes,scrollbars=yes,resizable=yes,top=0,left=0,width="+iWidth+",height="+iHeight)
}
function dfGetRandomString()
{
	var ret=Math.random().toString()	
	return("A_"+ret.substr(ret.indexOf(".")+1))
}

function Replace(Expression, Find, Replace)
{
	var temp = Expression;
	var a = 0;

	for (var i = 0; i < Expression.length; i++) 
	{
		a = temp.indexOf(Find);
		if (a == -1)
			break
		else
			temp = temp.substring(0, a) + Replace + temp.substring((a + Find.length));
	}

	return temp;
}
function AddZero(val)
{
	if(val.length == 1)
		return '0'+val;
	return val;
}
function dfVntToInt(val)
{
	var integer;
	integer = parseInt(val);
	if (isNaN(integer))
	{
		return 0; 
	}
	return integer;
}