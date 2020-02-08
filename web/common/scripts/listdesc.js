function mOvr(src,clrOver){
	if (!src.contains(event.fromElement)) {
		src.style.cursor = 'hand';
		src.bgColor = clrOver;
	}
}
function mOut(src,clrIn)  {
	if (!src.contains(event.toElement)) {
		src.style.cursor = 'default';
		src.bgColor = clrIn;
	}
}

function send2print()
{
	var tabs = document.getElementsByTagName("table");
	var datatab;
	for(var k=0; k<tabs.length; k++) {
		var tab = tabs[k]
		if(tab.rows[0] && tab.rows[0].cells[0] && tab.rows[0].cells[0].innerHTML.indexOf("选择") >=0) {
			datatab = tab;
			break;
		}
	}
	if(datatab) {
		for(var k=0; k<datatab.rows.length; k++) {
			datatab.rows[k].cells[0].className = "noprint";
		}
	}
	window.print();
}

