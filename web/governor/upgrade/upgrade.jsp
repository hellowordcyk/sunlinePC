<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
	language="java"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%@ include file="/common.jsp"%>
</head>
<body>
		
		<div class="tab-table-contain">
    <div class="tab-table-title" >
        <span class="tab-title-left"></span>
        <span class="tab-title-right" style="width: 200px;" toggleblock="condId">系统升级</span>
    </div>
</div>
		<div style="overflow: auto;" id='condId'>
			<sc:form name="pageform" action="/httpprocesserservlet"
				method="post" sysName="governor" oprID="upgrade" forward="/governor/upgrade/upgrade.jsp"
				encType="multipart/form-data" actions="doUpgrade">
				<sc:hidden name="updesc" />
				<table width="100%" cellpadding="0" cellspacing="0"
					class="form-table">
					<tr>
						<!-- <td class="form-label" style="text-align: right" colspan='2'></td> -->
						<td class="form-value" style="text-align: center;">
						<span style='color:#006b95;font-size: 12'>升级文件：</span>
						<input name='filename' type='file' style="width: 400px; height: 18px"
							value="<c:out value='${param.path }' />"> 
						</td>

					</tr>
				 <tr>
						<td class="form-bottom" align="center">
								<sc:hidden name="path" />
							 <sc:button _class="button" value="点击升级" name="saveBtn" onclick="saveOk();" />
						</td>
					</tr>

				</table>
				
			</sc:form>
			<div class="page-tip" >
    <span class="tip-title">温馨提示</span>
    <p>升级的jar放到文件的根目录下，其他文件放到对应的目录下。升级文件必须是  “*.zip”文件</p>
    <p>必须保证升级的子系统没有人在使用。可查看“系统状态监控”页面的在线人数（最好保证是“1”，即只有自己在线）</p>
    <p>升级牵涉到配置文件（xml等系统启动时加载的文件），请重启服务器</p>
</div>
		</div>
		
		
	</div>
  <div class="tab-table-contain">
    <div class="tab-table-title" >
        <span class="tab-title-left"></span>
        <span class="tab-title-right" style="width: 200px;" toggleblock="baseId">升级历史查询</span>
    </div>
</div>
<div id='baseId' class="tab-table-body">
    <div jraf_pageid="pageId"  
    	jraf_url="dataList.so" 
    	jraf_sysName="<sc:fmt value='governor' type='crypto'/>"
    	jraf_oprID="<sc:fmt value='upgrade' type='crypto'/>"
   		jraf_actions="<sc:fmt value='getUpgrHist' type='crypto'/>" 
        jraf_params=""
        jraf_callback=""
    	jraf_init="true"
     	jraf_loadchild="true">
 </div>
</div>
</body>
<script language="javascript">
document.observe("dom:loaded",function(){
	 new Jraf.BlockToggle();//为模块增加隐藏、显示功能
	 new Jraf.LoadPageTo().doLoad('pageId');
});

function saveOk(){
	$$("input[name='path']")[0].value = $$("input[name='filename']")[0].value;
	var filename = $$("input[name='filename']")[0].value;
	 if(filename!=null&&filename!=""){
		if(filename.indexOf(".zip")==-1){
			 Jraf.showMessageBox({text: "<span class='success'>文件必须是.zip格式</span>"  });
				return;
			}
		
		Jraf.showMessageBox({
			type:"",
			title: "请描述一下你干了些什么！", 
			text: "<textarea rows='8' style='width:330px' id='descId'></textarea>",
			onOk:function(){
				var desc = $("descId").value;
				if(desc==''){
					alert("请输入升级描述");
					return;
				}
				$$("input[name='updesc']")[0].value=desc;
				 document.pageform.submit();
				}
			});

   }else{
   	Jraf.showMessageBox({
   		type:"warn",
   		title: "提示信息",
   		text: "请先上传一个文件"});
   }
	
	
}

function rollback(filena){
	
	Jraf.showMessageBox({
		type:"choose",
		text:"回滚操作会将现有的版本覆盖，且不会备份现有版本，是否继续回滚？",
		onYes:function(){
			doRollBack(filena);
		},
		onNo:function(){
			window.close();
		}
	});
	
	
}

function doRollBack(filena){
	  var param = {
		        sysName:    "<sc:fmt value='governor' type='crypto'/>",
		        oprID:      "<sc:fmt value='upgrade' type='crypto'/>",
		        actions:    "<sc:fmt value='rollBackUpgrade' type='crypto'/>",
		        filena: filena
		    };
		    var ajax = new Jraf.Ajax();
		    ajax.sendForXml("/xmlprocesserservlet", param, function (xml) {
		        try{
		            var pkg = new Jraf.Pkg(xml);
		            if(pkg.result() != '0'){
		                Jraf.showMessageBox({
		                    type: "error",
		                    text: "回滚失败!"
		                });
		                return;
		            }else{
		                Jraf.showMessageBox({
		                    text: "回滚成功！",
		                    type: "success"
		                });
		            }
		        }catch(e){
		            alert('[method=checkDatas]ERROR:'+e.message);
		        }
		    });
}
</Script>
</html>
