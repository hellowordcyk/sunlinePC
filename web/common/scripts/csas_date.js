String.prototype.trim = function()
{
    return this.replace(/(^\s*)|(\s*$)/g,"");
}
function SetD2()
{
	for(var i=document.Form1.D2.options.length-1;i>0;i--)
		document.Form1.D2.options[i] = null;
	for(i=1;i<=4;i++)
		document.Form1.D2.options[i] = new Option(i, i, 0, 0)
	for(var i=document.Form1.D3.options.length-1;i>0;i--)
		document.Form1.D3.options[i] = null;
	for(i=1;i<=12;i++)
		document.Form1.D3.options[i] = new Option(i, i, 0, 0)
	SetD3()	
}  
function SetD3()
{
	var Season = document.Form1.D2.value;
	
	if(Season == "*")
	{
		for(var i=document.Form1.D3.options.length-1;i>0;i--)
			document.Form1.D3.options[i] = null;
		for(i=1;i<=12;i++)
			document.Form1.D3.options[i] = new Option(i, i, 0, 0)
	}
	else{
	   Season=parseInt(Season)
	   for(var i=document.Form1.D3.options.length-1;i>0;i--)
			document.Form1.D3.options[i] = null;
	   for(i=(Season*3-2);i<=Season*3;i++)
			document.Form1.D3.options[i-3*(Season-1)] = new Option(i, i, 0, 0)
	}
	
	SetD4()
}	

function SetD6()
{
	for(var i=document.Form1.D6.options.length-1;i>0;i--)
		document.Form1.D6.options[i] = null;
	for(i=1;i<=4;i++)
		document.Form1.D6.options[i] = new Option(i, i, 0, 0)
	for(var i=document.Form1.D7.options.length-1;i>0;i--)
		document.Form1.D7.options[i] = null;
	for(i=1;i<=12;i++)
		document.Form1.D7.options[i] = new Option(i, i, 0, 0)
	SetD7()	
}  
function SetD7()
{
	var Season = document.Form1.D6.value;
	
	if(Season == "*")
	{
		for(var i=document.Form1.D7.options.length-1;i>0;i--)
			document.Form1.D7.options[i] = null;
		for(i=1;i<=12;i++)
			document.Form1.D7.options[i] = new Option(i, i, 0, 0)
	}
	else{
	   Season=parseInt(Season)
	   for(var i=document.Form1.D7.options.length-1;i>0;i--)
			document.Form1.D7.options[i] = null;
	   for(i=(Season*3-2);i<=Season*3;i++)
			document.Form1.D7.options[i-3*(Season-1)] = new Option(i, i, 0, 0)
	}
	
	SetD8()
}	
function SetD8()
{
	var Month = document.Form1.D7.value;
	for(var i=document.Form1.D8.options.length-1;i>0;i--)
		document.Form1.D8.options[i] = null;
	var tmpDate=document.Form1.D5.value.trim()+"/"+document.Form1.D7.value.trim()+"/01"
	try{
		var Days=GetDaysofMonth(tmpDate);
	
		for(i=1;i<=Days;i++){
		    document.Form1.D8.options[i] = new Option(i, i, 0, 0)
		}
	}
	catch(e){
	
	}
}	
function GetDaysofMonth(tmpDate)
{
	var tDateStr = tmpDate + ' 8:0:0';
	var tDate = new Date(tDateStr);
	tDate.setMonth(tDate.getMonth()+1);
	tDate.setDate(0);
	return tDate.getDate();
}