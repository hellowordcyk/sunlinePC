<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ page import="java.util.List"%>
<%@ page import="org.jdom.*"%>
<%@ page import="com.sunline.jraf.web.*"%>
<%@ include file="/jui_tag.jsp" %>
<html>
<head>
   <script charset="utf-8" language="javascript" type="text/javascript" src="/funcpub/portal/resource/resource.js"></script>
    <title>系统资源授权</title>
    <script type="text/javascript">
    var oldGrantUser = new Array();
    var oldGrantRole = new Array();
    var resflag ='${param.flag}';
    var rescid = '${param.rescid}';
    var resccd = '${param.resccd}';
    var userflag = 0;
    $(function(){
        oldGrantUser = getSelectOptionsValue('grantUser');
 	    oldGrantRole = getSelectOptionsValue('grantRole');
    });
    
    
    function userGrantHasChange(){  // //判断 用户授权信息是否改变
      	 var currentGrantUser = new Array();
      	 currentGrantUser = getSelectOptionsValue('grantUser');
      	 if(oldGrantUser.sort().toString()!=currentGrantUser.sort().toString()){
      		 return true;
      	 }
      	 return false;
       }
    
    function roleGrantHasChange(){    //判断 用户授权信息是否改变
      	 var currentGrantRole = new Array();
      	 currentGrantRole = getSelectOptionsValue('grantRole');
      	 if(oldGrantRole.sort().toString()!=currentGrantRole.sort().toString()){
      		 return true;
      	 }
      	 return false;
       }
    
    function grant(){
    	var GrantUser = new Array();
      	 var GrantRole = new Array();
      	
      	 if(userGrantHasChange()){   //更改了用户的授权信息
      		 userflag =1;
      		 GrantUser = getSelectOptionsValue('grantUser');
      	 }
      	 
      	 if(roleGrantHasChange()){ //更改了角色的授权信息
      		 userflag =2;
      		 GrantRole = getSelectOptionsValue('grantRole');
      	 }
      	
      	 if(userGrantHasChange() && roleGrantHasChange()){   // 更改了用户和角色的授权信息
      		 userflag =3;
      	 }
      	 
      	 var param = {
      			 GrantUser:GrantUser,
      			 GrantRole:GrantRole,
      			 rescid:rescid,
      			 resccd:resccd,
      			 userflag:userflag,
      			 resflag:resflag,
      			 resctp:'${param.resctp}'
      			 };
      	 if(userflag!=0){
      		var url = '/xmlprocesserservlet?sysName=<sc:fmt value='funcpub' type='crypto'/>'+
        	'&oprID=<sc:fmt value='sys_res_gr' type='crypto'/>'+
        	'&actions=<sc:fmt value='grantSysResourse' type='crypto'/>';
        	$.ajax({
    	    	type:'POST',
    	    	url: url,
    	    	dataType:'xml',
    	    	data:$.param(param,true),	   		        
    	    	success:function(data){
    	    	     //解析后台返回的xmlr数据
    	    	     var code = $(data).find("DataPacket Response Data retCode").text();
    	    	     if(code=="200") {
    	    	    	 alertMsg.correct("授权成功！");
    	    	    	 $.pdialog.closeCurrent();
    	    	     }else{
    	    	    	 alertMsg.error("授权失败！");
    	    	     }
    	    	}
        	}); 
      	  }
    	}
    
   
    function getSelectOptionsValue(sel){ //获取select所有option的值 
   	 var data = new Array();
   	 var obj  = document.getElementById(sel);
   	 var opts = obj.options;
   	 for(var i=0;i<opts.length;i++){
   		 data[i] = opts[i].value;
   	 }
   	 return data;
    }

   
    function clearSelet(selid){   //清空select控件
    	var opts = document.getElementById(selid).options;
    	var length = opts.length;
    	if(length>=1){
    		for(var i = length - 1; i >= 0; i--){
    			opts.remove(i);
    		}
    	}	
    }
   
    function createOption(value,text,title){   //创建一个select标签的option对象
   		var option = new Option();
   		option.value = value;
   		option.text = text;
   		option.title = title;
   		return option;
   	}
    
  
   function addSelOptc(selId, option) {   //为select标签添加option
   	var selObj = document.getElementById(selId);
   	selObj.options.add(option, selObj.options.length);
   }
   
    function moveOption(selSrc,selDesc){    //将源selected选中的options移到目的selected
   	 var selObj = document.getElementById(selSrc);
   	 for(var i=selObj.options.length-1;i>=0;i--){
   	 	var objOption = selObj.options[i];
   	 	if (objOption.selected){
   	 		selObj.options.remove(i);
   	 		addSelOptc(selDesc,objOption);
   	        }
   	 }
    }
    
    function moveAllOption(selSrc,selDesc){  //将源selected的options全部移到目的selected
   	 var selObj = document.getElementById(selSrc);
   	 var selOpts = selObj.options;	
   	 for(var i=0;i<selOpts.length;i++){
   	 	var opt = selOpts[i];
   	 	addSelOptc(selDesc,createOption(opt.value,opt.text,opt.title));
   	 }
   	 clearSelet(selSrc);
    }
    
    function addGrantUser(){  //添加授权用户
   	 	moveOption('ungrantUser','grantUser');
    }
    
    function deleteGrantUser(){  //删除授权用户
   	 	moveOption('grantUser','ungrantUser');
    }
    
    function addGrantUserAll(){  //全添加 授权用户
   		moveAllOption('ungrantUser','grantUser');
    }
    
    function deleteGrantUserAll(){ //全删除授权用户
   	 	moveAllOption('grantUser','ungrantUser');
    }
    
    function addGrantRole(){  //添加角色
   	 	moveOption('ungrantRole','grantRole');
    }
    function deleteGrantRole(){  //删除角色
   	 	moveOption('grantRole','ungrantRole');
    }
    
    function addGrantRoleAll(){  //全添加角色
   	 	moveAllOption('ungrantRole','grantRole');
    }
    
    function deleteGrantRoleAll(){  //全删除角色
   	 	moveAllOption('grantRole','ungrantRole');
    }
    
    
    </script>
</head>
<body>
	<div class="page-title" style="margin:0px;">
            <span id="sys_span_user" class="tip-title">资源授权给用户</span>
		    <div>
		       <table width="100%" cellpadding="0" cellspacing="0">
		          <tr>
				     <td width="45%" valign="top">
					 <div style="height:220px;overflow:auto;" class="page-title">
					      <span class="tip-title">未授予的用户</span>					      
					      <select id="ungrantUser" name="ungrant" multiple="multiple" style="width:100%;height:88%">
					      	<c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMaps }">
					      		<c:if test='${"2" eq record.grantflag and "1" eq record.userflag}'>
					      			<option value="${record.userid }" title="${record.usercode }">${record.username}[${record.usercode}]</option>
					      		</c:if>
					      	</c:forEach>
					      </select>
					 </div>
					 </td>
				  	 <td width="10%">
				  	    <table cellpadding="0" cellspacing="0">
				  	        <tr><td align="center"><input type="button" class="savebtn" value=" 添加>>" onclick="addGrantUser();"></td></tr>
				  	        <tr><td>&nbsp;</td></tr>
				  	        <tr><td align="center"><input type="button" class="savebtn" value="<< 取消 " onclick="deleteGrantUser();"></td></tr>
				  	        <tr><td>&nbsp;</td></tr>
				  	        <tr><td align="center"><input type="button" class="savebtn" value="全添加>>" onclick="addGrantUserAll();"></td></tr>
				  	        <tr><td>&nbsp;</td></tr>
				  	        <tr><td align="center"><input type="button" class="savebtn" value="<< 全取消" onclick="deleteGrantUserAll();"></td></tr>
				  	     </table>
				  	  </td>
				  	  <td width="45%" valign="top">
				  	      <div style="height:220px;overflow:auto;" class="page-title"><span class="tip-title">已授予的用户</span>
				  	         <select id="grantUser" name="ugranted" multiple="multiple" style="width:100%;height:88%">
						      	<c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMaps }">
						      		<c:if test='${"1" eq record.grantflag and "1" eq record.userflag}'>
						      			<option value="${record.userid }" title="${record.usercode }">${record.username}[${record.usercode}]</option>
						      		</c:if>
						      	</c:forEach>
					      </select>
				  	      </div>
				  	  </td>
				  </tr>
			  	</table>
			</div>
			<span id="sys_span_role" class="tip-title">资源授权给角色</span>
		    <div >
		       <table width="100%" cellpadding="0" cellspacing="0">
		          <tr>
				     <td width="45%" valign="top">
					 <div style="height:230px;overflow:auto;" class="page-title"><span class="tip-title">未授予的角色</span>
					  	  <select id="ungrantRole" name="unogrant" multiple="multiple" style="width:100%;height:88%">
					      	<c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMaps }">
					      		<c:if test='${"2" eq record.grantflag and "2" eq record.userflag}'>
					      			<option value="${record.userid }" title="${record.usercode }">${record.username}[${record.usercode}]</option>
					      		</c:if>
					      	</c:forEach>
					      </select>
					 </div>
					 </td>
				  	 <td width="10%">
				  	    <table cellpadding="0" cellspacing="0">
				  	        <tr><td align="center"><input type="button" class="savebtn" value=" 添加>>" onclick="addGrantRole();"></td></tr>
				  	        <tr><td>&nbsp;</td></tr>
				  	        <tr><td align="center"><input type="button" class="savebtn" value="<< 取消 " onclick="deleteGrantRole();"></td></tr>
				  	        <tr><td>&nbsp;</td></tr>
				  	        <tr><td align="center"><input type="button" class="savebtn" value="全添加>>" onclick="addGrantRoleAll();"></td></tr>
				  	        <tr><td>&nbsp;</td></tr>
				  	        <tr><td align="center"><input type="button" class="savebtn" value="<< 全取消" onclick="deleteGrantRoleAll();"></td></tr>
				  	     </table>
				  	  </td>
				  	  <td width="45%" valign="top">
				  	      <div style="height:230px;overflow:auto;" class="page-title"><span class="tip-title">已授予的角色</span>
                                <select id="grantRole" name="ugranted"  multiple="multiple" style="width:100%;height:88%">
					      		<c:forEach var="record" items="${jrafrpu.rspPkg.rspRcdDataMaps }">
						      		<c:if test='${"1" eq record.grantflag and "2" eq record.userflag}'>
						      			<option value="${record.userid }" title="${record.usercode }">${record.username}[${record.usercode}]</option>
						      		</c:if>
					      	</c:forEach>
					      </select>
				  	      </div>
				  	  </td>
				  </tr>
				  <tr>
			              <td class="form-bottom" colspan="4">
			                  <input type="button" class="savebtn" value="保存资源信息"  onclick="grant();">
			              </td>
		          </tr>
			  	</table>
			</div>
	 </div> 
		        
  </body>
</html>
