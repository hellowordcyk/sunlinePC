/**
 * @version 1.0
 * 添加jraf自定义的js
 * 特殊说明： g_csrfToken为jui_common.jsp中定义的全局变量
 */
 var Jraf={
	tokenName: 'csrftoken',//defined by Sean on 20160810
	menuStyle: null,//used for judge menuStyle, '1'-normal ,'2'-folder, defined by hzx on 20160921
	menuCacheMap:{},//used for menuTree js cache,defined by hzx on 20160919 
	controlAjaxBg:false,  //占用 ajax背景 ，设置为true 其他ajax 提交 不再弹出，直到设置为 false
	/**
	 * 初始化入口
	 * @param options
	 * @param $p 父级节点（限制范围）
	 */
	init:function(options, $p){
		this.initJrafMoreSearch($(".btnMore",  $p));
		
		this.initJrafSubmit($p);
	
		$p.find("form[jraf_validateValueChange]").each(function(){
			CommonUtils.initOldValue($(this));  
		});
		
		 this.appendToken($p);
		
		this.addResetBtnEvent();
		this.removeOndblclick();
	},
	/**
	 * ie浏览器checkbox双击选中状态
	 */
	removeOndblclick:function(){
		 $("input[type='checkbox']").attr('ondblclick', 'this.click()');  
	},
	initJrafMoreSearch:function($obj) {
		$obj.each(function(){
			$(this).click(function(event){
				var $btnObj = $(this);
				var $moreSearchDiv = $(".moreSearch", $btnObj.closest("form"));
				if($moreSearchDiv.is(':visible')){
					$btnObj.attr("class", "btnMore btnMore_down");
				}else{
					$btnObj.attr("class", "btnMore btnMore_up");
				}
				$(".moreSearch", this._p).slideToggle();

				event.preventDefault();
			});
		});
	},
	/**
	 * 进入页面自动执行查询操作
	 */
	initJrafSubmit:function($obj){
		var _obj = $("input[type='hidden'][name='jraf_initsubmit']", $obj);
		if(!!_obj && _obj.size() > 0){
			for (var i=0, len= _obj.size(); i<len; i++) {
				var $initsubmitInputObj = $(_obj[i]);
				if(!($initsubmitInputObj.val() == "init")){
					$initsubmitInputObj.val("init");
					
					$("td.empty", $obj).html("<i class=\"fa fa-spinner fa-pulse fa-fw\"></i><span>加载中．．．</span>");
					
					var $form = $initsubmitInputObj.closest("form");
					$form.submit();
					
				}
			}
		}
	},
	/**
	 * 消除初始状态，navTab reload时自动执行查询操作
	 * 1)dwz.navTab中_loadUrlCallback方法中也需要执行此操作
	 * 2)dialogAjaxDone中，刷新navTab时，需求执行此操作
	 */
	cleanInitJrafSubmit: function ($p) {
		var _obj = $("input[type='hidden'][name='jraf_initsubmit']", $($p));
		if(!!_obj && _obj.size() > 0){
			for (var i=0, len= _obj.size(); i<len; i++) {
				$(_obj[i]).val("");
			}
		}
	},
	/**
	 * 查找带回清空按钮
	 */
	lookupClear:function(obj) {
		/**
		 * 新增属性 noclear，用于 不需要显示 清除按钮的，
		 */
		
		if(typeof($(obj).attr("noclear"))!="undefined") {
			$(obj).siblings("input[type=text]").css("padding-right","22px");
			return;
		}
		var lookuptype = $(obj).attr("lookuptype");
		var url = $(obj).prop("href");
		var regLookupid = url.match(/lookupid=(\w+)/);
		var regLookupcode = url.match(/lookupcode=(\w+)/);
		if(regLookupid==null && regLookupcode==null) {
			return;
		}
		var lookupid = null;
		var lookupcode = null;
		var lookupname = null;
		var regLookupname = url.match(/lookupname=(\w+)/);
		var $box = $(obj).parents(".unitBox:first");
		
		if(regLookupid) {
			lookupid = regLookupid[1];
		}
		if(regLookupcode) {
			lookupcode = regLookupcode[1];
		}
		if(regLookupname) {
			lookupname = regLookupname[1];
		}
		//clearfun添加清空自定义方法
		var $deleteBtn , clearfun;
		clearfun = $(obj).attr("clearfun");
		if(clearfun){
			if(clearfun.indexOf("\(")== -1){
				$deleteBtn=$('<a class="btnLook_clean" onclick="'+ clearfun.trim()+'()"><i class="fa fa-close"></i></a>');
			}else{
				if(clearfun.indexOf("\'")!= -1){
					$deleteBtn=$('<a class="btnLook_clean" onclick="'+ clearfun +'"><i class="fa fa-close"></i></a>');
				}else{
					$deleteBtn=$("<a class='btnLook_clean' onclick='"+ clearfun +"'><i class='fa fa-close'></i></a>");
				}
			}
			$(obj).removeAttr("clearfun");
		}else{
			$deleteBtn=$("<a class='btnLook_clean'><i class='fa fa-close'></i></a>");
		}
		$(obj).siblings("input[type=text]").css("padding-right","42px");
		$deleteBtn.bind("click",function() {
			if("id"==lookuptype){
				if(lookupid) {
					$("#"+lookupid,$box).val("");
				}
				if(lookupcode) {
					$("#"+lookupcode,$box).val("");
				}
				if(lookupname) {
					$("#"+lookupname,$box).val("");
				}
			}else{
				if(lookupid) {
					$("input[name='"+lookupid+"']",$box).val("");
				}
				if(lookupcode) {
					$("input[name='"+lookupcode+"']",$box).val("");
				}
				if(lookupname) {
					$("input[name='"+lookupname+"']",$box).val("");
				}
			}
		});
		if( $(obj).next().hasClass("btnLook_clean")) $(obj).next().remove();
		
		$(obj).after($deleteBtn);
	},
	/**
	 * CSRF安全验证
	 */
	appendToken: function ($p){ 
	    this._updateForms($p); 
	    this._updateTags($p); 
	}, 
	_updateForms: function($p) { 
	    // 得到页面中所有的 form 元素
	    $('form', $p).each(function (index, domEle) {
	    	 var url = domEle.action; 
	        // 如果这个 form 的 action 值为空，则不附加 csrftoken 
	        if(url == null || url == "" ) {
	        	return true;//跳至下一循环
	        }
	        //先删除原有的
	        $(domEle).find("input[type='hidden'][name='"+Jraf.tokenName+"']").remove();
	        // 动态生成 input 元素，加入到 form 之后
	        $(domEle).append("<input type='hidden' name='"+Jraf.tokenName+"' />");
	        $(domEle).find("input[type='hidden'][name='"+Jraf.tokenName+"']").val(g_csrfToken);
	    }); 
	},
	_updateTags: function($p) { 
		var thisObj = this;
	    $('a', $p).each(function (index, domEle) {
	    	thisObj._updateTag(domEle, 'href', g_csrfToken); 
	    });
	}, 
	_updateTag: function(element, attr, token) { 
	    var url = $(element).attr(attr); 
	    if(url != null && url != '' ) { 
	        var fragmentIndex = url.trim().indexOf('#'); 
	        var fragment = null; 
	        if (fragmentIndex != -1 && fragmentIndex == 0 || /^javascript.*/gi.test(url)) {
	        	return;//when the first character is '#', return;
	        } else if(fragmentIndex != -1){ 
	            fragment = url.substring(fragmentIndex); 
	            url = url.substring(0,fragmentIndex); 
	        } 
			var tokenIndex = url.trim().indexOf(Jraf.tokenName);
			if(tokenIndex != -1){
				var reg = new RegExp('('+Jraf.tokenName+'=)([0-9a-zA-Z]+)');;
				url = url.replace(reg, function(match){
					return Jraf.tokenName+'='+token;
				});
			}else{
				var index = url.indexOf('?'); 
		        if(index != -1) { 
		            url = url + '&'+Jraf.tokenName+'=' + token; 
		        } else { 
		            url = url + '?'+Jraf.tokenName+'=' + token; 
		        } 
			}
	        if(fragment != null){ 
	        	url += fragment; 
	        } 
	        $(element).attr(attr, url); 
	    } 
	 },
	 /**
	  * 清空按钮事件
	  */
	 addResetBtnEvent: function ($p) {
		 function _cleanInputValue() {
			 var oForm = $(this).parents("form");
			/*
			 * 1.将myform表单中input元素type为button、submit、reset、hidden排除
			 * 2.将input元素的value设为空值
			 * 3.checkbox,select下拉框初始化为未选择
			 */
			$(':input', oForm)
			.not(':button,:submit,:reset,:hidden')
			.val('')  
			.removeAttr('checked')
			.removeAttr('selected'); 
			
			$('.btnLook', oForm).parent().children(":hidden").val('');
			$('select', oForm).children("option").first().attr("selected","selected");
			/*
			 * combox控件清理
			 */
			if($("div.combox", oForm).length) $("div.combox", oForm).jrafComboxClean();
		}
		$("button.resetbtn[type='reset']", $p).unbind("click", _cleanInputValue).replaceWith("<button class='resetbtn' type='button'>清空</button>");
		$("button.resetbtn", $p).bind("click", _cleanInputValue);
	 },
	 /**
	  * 显示ajax背景，并占用
	  */
	 showAjaxBg:function(json,speed) {
		var innerDef = $.Deferred();
		var ajaxbg = $("#background,#progressBar");
		Jraf.controlAjaxBg = true;
		ajaxbg.show(speed?speed:10,function(){
			innerDef.resolve(json);
		});
		return innerDef.promise();
	 },
	 /**
	  * 隐藏ajax背景，并解除占用
	  */
	 hideAjaxBg:function(json,speed) {
		 var innerDef = $.Deferred();
		 var ajaxbg = $("#background,#progressBar");
		 ajaxbg.hide(speed?speed:10,function(){
			 Jraf.controlAjaxBg = false;
			 innerDef.resolve(json);
		 });
		 return innerDef.promise();
	 },
	 parseXmlResponseDataToJson:function(xml){
			return Jraf.parseXmlToJson(xml, "DataPacket Response Data");
		},
		parseXmlToJson:function(xml,rootNodeName){
	    	rootNodeName = rootNodeName || "DataPacket";
	    	var rootNode = $(xml).find(rootNodeName).eq(0);
	    	if(rootNode){
	    		var json = Jraf.parseXmlNode(rootNode);
	    		return json
	    	}
	    	return null;
	    },
	    parseXmlNode:function(node){
			var children = $(node).children();
			if(children.length>0){
				var json = {};
				$(children).each(function(i,child){
					var tagName = child.tagName;
					if(json[tagName]){
						var array = Array();
						array = array.concat(json[tagName]);
						array.push(Jraf.parseXmlNode(child));
						json[tagName] = array;
					}else{
						json[tagName] = Jraf.parseXmlNode(child);
					}
				});
				return json;
			}else{
				return $(node).text() || "";
			}
		},
		 /**
		  * 添加区域禁用功能
		  */
		disableItem :function( scope, excludeValues){
			//此处修改请注意dwz的combox下拉控件相应的修改（dwz.combox.js）
			 
				var $p =  $.pdialog.getCurrent() ? $.pdialog.getCurrent(): navTab.getCurrentPanel();
				var $this = $("#" + scope.trim(), $p);
				if($this.length <= 0) return true;
				
				var exclude = false;
				if(excludeValues) exclude =  excludeValues.split(",");
				
				$this.find("input:not(:hidden), textarea:not(:hidden), select:not(:hidden)").each(function(){
					if(exclude){
						for(var i=0; i<exclude.length ; i++){
							if((exclude[i].trim()) == $(this).attr("id") || (exclude[i].trim()) == $(this).attr("name")){
								return true;
							}
						}
					}
					$(this).attr({
						"disabled":"true",
						"dblclick":" ",
						"onclick":" ",
						"jrafdisable":"jrafdisable"
					}).unbind().off();
				});
				
				$this.find("a").each(function(){
					if($(this).hasClass("btnView") || $(this).hasClass("btnMore") || $(this).hasClass("btnInfo")){
						return true;
					}
					
					if(exclude){
						for(var i=0; i< exclude.length ; i++){
							if((exclude[i].trim()) == $(this).attr("id") || (exclude[i].trim()) == $(this).attr("name")){
								return true;
							}
						}
					}
					if($(this).hasClass("btnLook")){
						$(this).remove();
						return true;
					}
					
					$(this).attr({
						"target":" ",
						"href":"javascript:;",
						"dblclick":" ",
						"onclick":" ",
						"jrafdisable":"jrafdisable"
					}).unbind().off();
						
				});
				
				$this.find("button").each(function(){
					if($(this).hasClass("querybtn") || $(this).hasClass("close")){
						return true;
					}
					if(exclude){
						for(var i=0; i<exclude.length ; i++){
							if((exclude[i].trim()) == $(this).attr("id") || (exclude[i].trim()) == $(this).attr("name")){
								return true;
							}
						}
					}
					$(this).attr({
						"dblclick":" ",
						"onclick":" ",
						"jrafdisable":"jrafdisable"
					}).unbind().off();
			});	
		}
 };
 	
 (function($){  
	 //备份jquery的ajax方法  
	    var _ajax=$.ajax;  
	    //重写jquery的ajax方法  
	    $.ajax=function(opt){  
	    	//var $this = $(this);
	        //备份opt中error和success方法  
	    	var optBeforeSend;
	        var fn = {  
	        	headers: {
	        		"csrftoken": g_csrfToken
	        	},
	    		beforeSend: function (XHR) {
					//add token into header for CSRF by Sean on 20160810
					XHR.setRequestHeader(Jraf.tokenName, g_csrfToken);
				},
				error: DWZ.ajaxError,
				statusCode: {
					503: function(xhr, ajaxOptions, thrownError) {
						alert(DWZ.msg("statusCode_503") || thrownError);
					}
				},
				complete: function(xhr,textStatus){
					var json = DWZ.jsonEval(xhr.responseText);
					if (json[DWZ.keys.statusCode] == DWZ.statusCode.timeout) {
						if(alertMsg) alertMsg.error(json[DWZ.keys.message] || DWZ.msg("sessionTimout"), {okCall:DWZ.loadLogin});
						else DWZ.loadLogin();
					}
				}
	        };
	        
	        if(opt.headers){  
	        	fn.headers=opt.headers;  
	        }  
	        if(opt.error && jQuery.isFunction(opt.error)){  
	            fn.error=opt.error;  
	        }  
	        if(opt.statusCode){  
	        	fn.statusCode=opt.statusCode;  
	        }
	        if(opt.beforeSend){ 
	        	optBeforeSend=opt.beforeSend;  
	        } 
	        if(opt.complete){ 
	        	fn.complete=opt.complete;  
	        } 
	          
	        //扩展增强处理  
	        $.extend(opt,{  
	        	headers: fn.headers,
	        	beforeSend: function(XMLHttpRequest){  
	        		//安全处理  
	        		fn.beforeSend(XMLHttpRequest);
	        		if(optBeforeSend){ 
	        			optBeforeSend(XMLHttpRequest);
	     	        } 
	        	},  
	            error:function(XMLHttpRequest, textStatus, errorThrown){  
	                //错误方法增强处理  
	                fn.error(XMLHttpRequest, textStatus, errorThrown);  
	            },
	            statusCode: fn.statusCode,
	            complete: function(XMLHttpRequest,textStatus){
	            	fn.complete(XMLHttpRequest,textStatus);
	            }
	        });  
	        return _ajax(opt);  
	    };   
})(jQuery);  