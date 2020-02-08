<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.sunline.jraf.util.*"%>
<%@ include file="/jui_tag.jsp" %>
<body>
	<div class="pageContent" width="100%">
		<div class="pageFormContent">
			<table cellpadding="0" cellspacing="0" width="100%" style="margin-top: 150px;">
				<tr>
					<td align="right">菜单名称:</td>
					<td align="left"><input id="menuname" name="menuname" style="width: 250px; validate="required"/><span class="redmust">*</span></td>
				</tr>
				<tr>
					<td align="right">超链接地址</td>
					<td align="left"><input id="linkurl" name="linkurl"  style="width: 250px;"/><span class="redmust">*</span></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="formBar" >
		<ul>
			<li><button type="button" class="button" onclick="beforePublishMenu()">菜单发布</button></li>
			<li><button type="button" class="close">取消</button></li>
		</ul>
	</div>
</body>
<script type="text/javascript">
	function beforePublishMenu(){
		 var jsonArray = new Array();  //json对象的数组
		   
		 var menuname = document.getElementById("menuname").value; 
		 var linkurl = document.getElementById("linkurl").value;
	
	   	  var menuJson = {
	   			name:menuname,
	   			url:linkurl
	   	   };
	      	  
		   jsonArray.push(menuJson);	
		   publishMenu(jsonArray);
	}

	/* function publishMenu(jsonArray){    //跳转到发布页面 	
	    var data = "";
        var operator ="";
	    for(var i=0;i<jsonArray.length;i++){
	    	data = data+operator+jsonArray[i].name+","+jsonArray[i].url;
	    	operator = ";";
	    }
	    data = data.replace(/&/g,".-.");
		url='/funcpub/portal/menu/menu_publish.jsp?data='+encodeURI(encodeURI(data)); 
		navTab.openTab("2", url, { title:"菜单发布", fresh:false, data:{} });
	}	 */
</script>