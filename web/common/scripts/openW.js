
function openModal_win(URL,width,Height,win){
	window.showModalDialog(URL,win,"dialogWidth:"+ width +"px;dialogHeight:" + Height + "px;status:no;help:no",
	"edge:raised");
}
function openModal(URL,width,Height){
	var w = window.showModalDialog(URL,"win32","dialogWidth:"+ width +"px;dialogHeight:" + Height + "px;status:no;help:no");
	//var w = window.open(URL,"win32","width="+width+",height="+Height);
	return w;
}
function openModalByParams(URL,va,width,Height, isResize){
    var cond = "dialogWidth:"+ width +"px;dialogHeight:" + Height + "px;status:no;help:no;scroll:no;";
    if (isResize === true) {
        cond += "resizable: yes;";
    }
	var w = window.showModalDialog(URL, va, cond);
	return w;
}
function openModalToIframe(url, va, width, Height, isResize){
	Height = Height || screen.availHeight - 40;
    width = width || screen.availWidth - 30;
    var cond = "dialogWidth:"+ (width || 800) +"px;dialogHeight:" + (Height || 600) + "px;status:no;help:no;scroll:no;";
    if (isResize === true) {
        cond += "resizable: yes;";
    }
    if (va == null) {
        va = {};
    }
    va["url"] = url;
    var w = window.showModalDialog("/public/showModalDialog.jsp?s_time="+(new Date().getTime()), va, cond);
    return w;
}
function openModal_1(URL,va,width,Height){
    var w = window.showModalDialog(URL,va,"dialogWidth:"+ width +"px;dialogHeight:" + Height + "px;status:no;help:no");
    return w;
}
function reValue_win(value,frm){
	for(var i=0;i<value.length;i++){
			var f = frm + "." + value[i][0];
			var ff=eval("window.dialogArguments."+f);
			ff.value=value[i][1];
	}
	window.close();	
}
function reValue(value){
	window.returnValue=value;
	window.close();	
}

