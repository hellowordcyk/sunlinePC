$("a.publicOptionControls").live("click",function(){
    var type = $(this).attr("type");
    var filter = $(this).attr("filter");
    var callback = $(this).attr("callback");
    var multi = $(this).attr("multi");
    var selected = $(this).attr("seletedInput");
    var selectedColumn = $(this).attr("selectedColumn");
    if(!filter.startsWith("&")){
        filter = "&"+filter;
    }
    if(type == undefined || callback == undefined || type == "" || callback == ""){
        alertMsg.error("选择控件配置有误,请联系管理员!");
        return;
    }
    
    if(undefined != selectedColumn && selectedColumn != ""){
        if(undefined != selected && selected != "" && $(this).siblings("[name='"+selected+"']").length>0 ){
            selected = $($(this).siblings("[name='"+selected+"']")[0]).val();
        }else{
            selected = "";
        }
    }else{
        selectedColumn = "";
    }
    if( "deptTree" == type ){
        deptTreeOptionDialog(this,filter,multi,selected,selectedColumn,callback);
    }else if( "userTree" == type ){
        userTreeOptionDialog(this,filter,multi,selected,selectedColumn,callback);
    }else if( "userTable" == type ){
        userTableOptionDialog(this,filter,multi,selected,selectedColumn,callback);
    }else if( "kpi" == type ){
        kpiOptionDialog(this,filter,multi,selected,selectedColumn,callback);
    }else{
        alertMsg.error("选择控件配置有误,请联系管理员!");
        return;
    }
});
function deptTreeOptionDialog(event,filter,multi,selected,selectedColumn,callback){
    var url = "/funcpub/public/publicOptionControls/deptTreeOptionDialog.jsp"
            + "?callback="+callback
            + "&multi="+multi
            + "&selected="+selected
            + "&selectedColumn="+selectedColumn
            + "&filter="+escape(filter);
    $.pdialog.open(url,"deptTreeOptionDialog","机构选择",{width:800,height:460,minable:false,maxable:false,mask:true});
}
function userTreeOptionDialog(event,filter,multi,selected,selectedColumn,callback){
    var url = "/funcpub/public/publicOptionControls/userTreeOptionDialog.jsp"
        + "?callback="+callback
        + "&multi="+multi
        + "&selected="+selected
        + "&selectedColumn="+selectedColumn
        + "&filter="+escape(filter);
    $.pdialog.open(url,"deptTreeOptionDialog","人员选择",{width:800,height:400,minable:false,maxable:false,mask:true});
}
function userTableOptionDialog(event,filter,multi,selected,selectedColumn,callback){
    var url = "/funcpub/public/publicOptionControls/userTableOptionDialog.jsp"
        + "?callback="+callback
        + "&multi="+multi
        + "&selected="+selected
        + "&selectedColumn="+selectedColumn
        + "&filter="+escape(filter);
    $.pdialog.open(url,"deptTreeOptionDialog","人员选择",{width:930,height:460,minable:false,maxable:false,mask:true});
}
function kpiOptionDialog(event,filter,multi,selected,selectedColumn,callback){
    var url = "/funcpub/public/publicOptionControls/kpiOptionDialog.jsp"
        + "?callback="+callback
        + "&multi="+multi
        + "&selected="+selected
        + "&selectedColumn="+selectedColumn
        + "&filter="+escape(filter);
    $.pdialog.open(url,"deptTreeOptionDialog","指标选择",{width:930,height:460,minable:false,maxable:false,mask:true});
}