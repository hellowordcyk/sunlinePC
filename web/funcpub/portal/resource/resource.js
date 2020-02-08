  
//--------------------------------------------1.系统资源维护---------------------------------------------------------------
  function deleteResource(){   //删除资源
	   alert("updateResource");
			 var rescidList='';
			 var seperator='';
			 var count =0;
			  	
			var boxArr=document.getElementsByName("rescidcheckbox");
			for(var i=0;i<boxArr.length;i++){
				var singleBox=boxArr[i];
				if(singleBox.checked){
					rescidList=rescidList+seperator+singleBox.value;
		       		seperator=',';
		       		count++;
				}
			}	
			
			if(rptuidList==""){
				alert("请选择要修改的资源!");
				return ;
			}
			if(count>1){
				alert("一次只能选一项资源!");
				return ;
			}
			
			//window.location.href='/httpprocesserservlet?sysName=<%=Crypto.encode(request,"sunrpt")%>&oprID=<%=Crypto.encode(request,"sunrpt-report")%>&actions=<%=Crypto.encode(request,"expReport")%>&forward=sunrpt/report/export_report.jsp&rptuidList='+rptuidList;  
  }

 
	
	
	
	
	//--------------------------------------------2.系统资源组维护---------------------------------------------------------------
	
	function querySysGroup(rsgpid){  //查询系统资源组
		//添加查询条件
		var subsysid = document.getElementsByName("subsysId")[0].value;
		var rsgpna = document.getElementsByName("rsgpna")[0].value;
		var resctp = document.getElementsByName("resctp")[0].value;
		var divObj = document.getElementById('sys_group_list_id');
		
		if(rsgpid != null && "" != rsgpid){
			divObj.setAttribute("jraf_params", "rsgpna="+rsgpna+"&resctp="+resctp+"&subsys="+subsysid+"&rsgpid="+rsgpid);
		}else{
			divObj.setAttribute("jraf_params", "rsgpna="+rsgpna+"&resctp="+resctp+"&subsys="+subsysid);
		}
		oLoadPageTo.doLoad('sys_group_list_id');
		init_un_resc();
	}
	
	
	function queryGpResc(rsgpid,rsgpna,resctp,subsys){  //查询资源组中资源
		g_rsgpid = rsgpid;
		g_resctp = resctp;
		g_subsys = subsys;
		if(rsgpna != null && "" != rsgpna){
			document.getElementById('resc_span_titile').innerHTML = "<span>资源组资源信息——"+rsgpna+"</span>";
		}
		//var oLoadPageTo = new Jraf.LoadPageTo();
		//var divObj = document.getElementById('sys_group_resc_list_id');
		//divObj.setAttribute("jraf_params", "rsgpid="+rsgpid);
		//oLoadPageTo.doLoad('sys_group_resc_list_id');
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	//--------------------------------------------3.用户资源授权---------------------------------------------------------------
	
	 function initUserGrantData(){  //用户资源授权
			
			alert("用户资源授权");
			/* oShetDivSlct = new Jraf.DivSlct({
			    selector:       "userCodeId", //id
			    queryParams:  {
			        sysName:    "<sc:fmt value='bdss' type='crypto'/>",
			        oprID:      "<sc:fmt value='bdss_resc_grant' type='crypto'/>",
			        actions:    "<sc:fmt value='queryUserListLike' type='crypto'/>",
			        likefq:     "true"
			    },
			    optionKeyName: "usercd",
			    optionLabelName: "userna",
			    optionParamsName: "userid",
			    doOthersAfterSel: function(params){
			    	//alert($H(params).inspect())
			    	document.getElementsByName("userId")[0].value = params.userid;
			    	var userCodeObj = document.getElementById('userCodeId');
			    	userCodeObj.disabled = true;
			    	userCodeObj.value = params.userna;
			    	document.getElementById("user_edit_id").style.display = "";
			    }
			}); */
		}

		
		
		
		
   //--------------------------------------------4.角色资源授权---------------------------------------------------------------
	 function initRoleGrantData(){  //角色资源授权
			alert("角色资源授权");
			  /* oShetDivSlct = new Jraf.DivSlct({
			    selector:       "roleCodeId", //id
			    queryParams:  {
			        sysName:    "<sc:fmt value='bdss' type='crypto'/>",
			        oprID:      "<sc:fmt value='bdss_resc_grant' type='crypto'/>",
			        actions:    "<sc:fmt value='queryRoleListLike' type='crypto'/>",
			        likefq:     "true"
			    },
			    optionKeyName: "roleid",
			    optionLabelName: "rolename",
			    doOthersAfterSel: function(params){
			    	document.getElementsByName("roleId")[0].value = params.roleid;
			    	document.getElementsByName("rolename")[0].value = params.rolename;
			    	var roleCodeObj = document.getElementById('roleCodeId');
			    	roleCodeObj.disabled = true;
			    	roleCodeObj.value = params.rolename;
			    
			    	document.getElementById("role_edit_id").style.display = "";
			    }
			});  */
		}
	 
	 
	 
