
function publishMenu(jsonArray){    //��ת������ҳ�� 	
    var data = "";
    var operator ="";
    for(var i=0;i<jsonArray.length;i++){
    	data = data+operator+jsonArray[i].name+","+jsonArray[i].url;
    	operator = ";";
    }
    data = data.replace(/&/g,"~");
	url='/sunrpt/report/menu_publish.jsp?data='+encodeURI(encodeURI(data)); 
	//navTab.openTab("2", url, { title:"�˵�����", fresh:false, data:{} });
	$.pdialog.open(url,"publishMenu","发布菜单",{width:600,height:600,mask:true,minable:false,minable:false,drawable:false});
}