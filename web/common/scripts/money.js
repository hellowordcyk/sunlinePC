function money(n)
{
	var n; if(!n) n = 0;
	var kc = event.keyCode;
	if (kc==9)
	{
		return;
	}
	
	if((kc<48||kc>57)&&(kc<96||kc>105)&&kc!=190&&kc!=110&&kc!=144&&kc!=8&&kc!=13&&kc!=46 &&kc!=37&&kc!=38&&kc!=39&&kc!=40&&kc!=16&&kc!=35&&kc!=36) {
		event.returnValue = false; event.keyCode = 0;
	}
else {
		if((kc>47 && kc<58)||(kc>95&&kc<106))
		{
			var obv = event.srcElement.value;
		
			if((obv.indexOf(".")>=0&&(kc==190||kc==110))
				|| (n>0&&obv.indexOf(".")>0&&(obv.length-obv.indexOf(".")-1)>=n)){
				event.returnValue = false;	event.keyCode = 0;
			}
		}
	}
}