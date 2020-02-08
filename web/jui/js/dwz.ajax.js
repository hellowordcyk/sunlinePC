/**
 * @author 张慧华 z@j-ui.com
 * 
 */

/**
 * 普通ajax表单提交
 * @param {Object} form
 * @param {Object} callback
 * @param {String} confirmMsg 提示确认信息
 */
function validateCallback(form, callback, confirmMsg) {
	var $form = $(form);
	var beforesubmitStr = $form.attr("onbeforesubmit");   //新增onbeforesubmit属性，拦截表单提交，调用 onbeforesubmit属性里的函数，如果函数返回false 那么停止提交，返回true 继续提交
	if(beforesubmitStr){
		try{
			var hasBrackets = false;
			if(beforesubmitStr.indexOf("(")>-1) {
				hasBrackets = true;
			}
			var status = eval(beforesubmitStr+(hasBrackets?"":"($form)"));
			if(!status) {  //如果函数返回 false 那么停止提交
				return false;
			}
		}catch (err){
			alertMsg.error("beforesubmitStr error"+err.message);
		}
	}
	
	if (!$form.valid()) {
		return false;
	}
	setUnconventionalInputValue($form);
	
	var backFunction = callback||DWZ.ajaxDone;
	if($form.attr("jraf_validateValueChange")!=null) {
		// 遍历表单下的所有控件，判断其value和__oldValue是否一致，
		if (!CommonUtils.isInputChanged(form)) {
			alertMsg.info("未修改任何数据！");
			return false;
		}
		// 取出__oldVaule值并传入后台
		CommonUtils.extractOldValueInAttr(form);
		
		backFunction = function(json) {
			CommonUtils.initOldValue(form);
			if($.isFunction(callback)){
				callback(json);
			}else{
				DWZ.ajaxDone(json);
			}
		};
	}
	
	var onsuccessBackFn = backFunction;
	var onsuccessFn = $form.attr("onsuccess");
	if(onsuccessFn){
		onsuccessBackFn = function(json) {
			try{
				var hasBrackets = false;
				if(onsuccessFn.indexOf("(")>-1) {
					hasBrackets = true;
				}
				var status = eval(onsuccessFn+(hasBrackets?"":"(json)"));
				if(!status) {
					return false;
				}
			}catch(error){
				alertMsg.error("onsuccess error"+err.message);
			}
			if($.isFunction(backFunction)){
				backFunction(json);
			}
			DWZ.ajaxDone(json);
		};
	}
	
	var _submitFn = function(){
		$form.find(':focus').blur();

		$.ajax({
			type: form.method || 'POST',
			url:$form.attr("action"),
			data:$form.serializeArray(),
			dataType:"json",
			cache: false,
			success: onsuccessBackFn,
			error: DWZ.ajaxError
		});
	};
	
	if (confirmMsg) {
		alertMsg.confirm(confirmMsg, {okCall: _submitFn});
	} else {
		_submitFn();
	}
	
	return false;
}

/**
 * 设置非常规input的值 如 千分位格式化数字，开关按钮
 * @param $form
 * @returns
 */
function setUnconventionalInputValue($form){
	//提交表单时，修改 千分位格式化 数字 为 原始数据
	if ($.fn.autoNumeric){
		$form.find("[customtype='money']").each(function(i,e) {
			$(e).val($(e).autoNumeric("get"));
		});
	}
	if ($.fn.bootstrapSwitch){
		$form.find("input.btn-switch").each(function(i,e) {
			$(e).attr("checked","checked");
			$(e).val($(e).bootstrapSwitch("state"));
		});
	}
}

/**
 * 带文件上传的ajax表单提交
 * @param {Object} form
 * @param {Object} callback
 */
function iframeCallback(form, callback){
	var $form = $(form), $iframe = $("#callbackframe");
	
	var beforesubmitStr = $form.attr("onbeforesubmit");   //新增onbeforesubmit属性，拦截表单提交，调用 onbeforesubmit属性里的函数，如果函数返回false 那么停止提交，返回true 继续提交
	if(beforesubmitStr){
		try{
			var hasBrackets = false;
			if(beforesubmitStr.indexOf("(")>-1) {
				hasBrackets = true;
			}
			var status = eval(beforesubmitStr+(hasBrackets?"":"($form)"));
			if(!status) {  //如果函数返回 false 那么停止提交
				return false;
			}
		}catch (err){
			alertMsg.error("beforesubmitStr error"+err.message);
		}
	}
	
	if(!$form.valid()) {return false;}
	setUnconventionalInputValue($form);
	
	//提交表单时，修改 千分位格式化 数字 为 原始数据
	if ($.fn.autoNumeric){
		$form.find("[customtype='money']").each(function(i,e) {
			$(e).val($(e).autoNumeric("get"));
		});
	}
	
	var onsuccessBackFn = callback;
	var onsuccessFn = $form.attr("onsuccess");
	if(onsuccessFn){
		onsuccessBackFn = function(json) {
			try{
				var hasBrackets = false;
				if(onsuccessFn.indexOf("(")>-1) {
					hasBrackets = true;
				}
				var status = eval(onsuccessFn+(hasBrackets?"":"(json)"));
				if(!status) {
					return false;
				}
			}catch(error){
				alertMsg.error("onsuccess error"+err.message);
			}
			if($.isFunction(callback)){
				callback(json);
			}
			DWZ.ajaxDone(json);
		};
	}
	
	if ($iframe.size() == 0) {
		$iframe = $('<iframe id="callbackframe" name="callbackframe" src="about:blank" style="display:none"></iframe>').appendTo('body');
	}
	if(!form.ajax) {
		$form.append('<input type="hidden" name="ajax" value="1" />');
	}
	form.target = 'callbackframe';

	$form.find(':focus').blur();

	_iframeResponse($iframe[0], onsuccessBackFn || DWZ.ajaxDone);
}
function _iframeResponse(iframe, callback, dataType){
	var $iframe = $(iframe), $document = $(document);
	
	$document.trigger("ajaxStart");
	
	$iframe.bind("load", function(event){
		$iframe.unbind("load");
		$document.trigger("ajaxStop");
		
		if (iframe.src == "javascript:'%3Chtml%3E%3C/html%3E';" || // For Safari
			iframe.src == "javascript:'<html></html>';") { // For FF, IE
			return;
		}

		var doc = iframe.contentDocument || iframe.document;

		// fixing Opera 9.26,10.00
		if (doc.readyState && doc.readyState != 'complete') return; 
		// fixing Opera 9.64
		if (doc.body && doc.body.innerHTML == "false") return;
	   
		var response;
		
		if (doc.XMLDocument) {
			// response is a xml document Internet Explorer property
			response = doc.XMLDocument;
		} else if (doc.body){
			try{
				if (dataType == 'html') {
					response = $iframe.contents().find("body").html();
				} else {
					response = $iframe.contents().find("body").text();
					response = jQuery.parseJSON(response);
				}
			} catch (e){ // response is html document or plain text
				//alert the message of response in case that the data type of response is not json edited by beidao 20160816
				alertMsg.error(response);
				response = doc.body.innerHTML;
			}
		} else {
			// response is a xml document
			response = doc;
		}
		
		callback(response);
	});
}

/**
 * navTabAjaxDone是DWZ框架中预定义的表单提交回调函数．
 * 服务器转回navTabId可以把那个navTab标记为reloadFlag=1, 下次切换到那个navTab时会重新载入内容. 
 * callbackType如果是closeCurrent就会关闭当前tab
 * 只有callbackType="forward"时需要forwardUrl值
 * navTabAjaxDone这个回调函数基本可以通用了，如果还有特殊需要也可以自定义回调函数.
 * 如果表单提交只提示操作是否成功, 就可以不指定回调函数. 框架会默认调用DWZ.ajaxDone()
 * <form action="/user.do?method=save" onsubmit="return validateCallback(this, navTabAjaxDone)">
 * 
 * form提交后返回json数据结构statusCode=DWZ.statusCode.ok表示操作成功, 做页面跳转等操作. statusCode=DWZ.statusCode.error表示操作失败, 提示错误原因. 
 * statusCode=DWZ.statusCode.timeout表示session超时，下次点击时跳转到DWZ.loginUrl
 * {"statusCode":"200", "message":"操作成功", "navTabId":"navNewsLi", "forwardUrl":"", "callbackType":"closeCurrent", "rel"."xxxId"}
 * {"statusCode":"300", "message":"操作失败"}
 * {"statusCode":"301", "message":"会话超时"}
 * 
 */
function navTabAjaxDone(json){
	DWZ.ajaxDone(json);
	if (json[DWZ.keys.statusCode] == DWZ.statusCode.ok){
		if ("closeCurrent" == json.callbackType) {
			if (json.navTabId){ 
				navTab.reloadFlag(json.navTabId);
			} 
			setTimeout(function(){navTab.closeCurrentTab(json.navTabId);}, 100);
		} else if ("forward" == json.callbackType) {
			navTab.reload(json.forwardUrl);
		} else if ("forwardConfirm" == json.callbackType) {
			alertMsg.confirm(json.confirmMsg || DWZ.msg("forwardConfirmMsg"), {
				okCall: function(){
					navTab.reload(json.forwardUrl);
				},
				cancelCall: function(){
					navTab.closeCurrentTab(json.navTabId);
				}
			});
		} else {
			if (json.navTabId){ 
				navTab.reloadFlag(json.navTabId);
			} else { //重新载入当前navTab页面
				//modified by SeanYang on 20160630统一获取分页form对象
				var $pagerForm = getPagerFormObjs(navTab.getCurrentPanel());//$("#pagerForm", navTab.getCurrentPanel());
				var args = $pagerForm.size()>0 ? $pagerForm.serializeArray() : {};
				navTabPageBreak(args, json.rel);
			}
			navTab.getCurrentPanel().find(":input[initValue]").each(function(){
				var initVal = $(this).attr("initValue");
				$(this).val(initVal);
			});
		}
	}
}

/**
 * dialog上的表单提交回调函数
 * 当前navTab页面有pagerForm就重新加载
 * 服务器转回navTabId，可以重新载入指定的navTab. statusCode=DWZ.statusCode.ok表示操作成功, 自动关闭当前dialog
 * 
 * form提交后返回json数据结构,json格式和navTabAjaxDone一致
 */
function dialogAjaxDone(json){
	DWZ.ajaxDone(json);
	if (json[DWZ.keys.statusCode] == DWZ.statusCode.ok){
		//added by Sean on 20161226 add success flag
		$.pdialog.addCurrentParams({success: true});
		if ("closeCurrent" == json.callbackType) {
			$.pdialog.closeCurrent();
		}
		if (json.navTabId){
			//added by SeanYang on 20160630清除自动查询状态，再次执行查询
			var $panel =  json.navTabId ? navTab.getPanel(json.navTabId) : navTab.getCurrentPanel();
			Jraf.cleanInitJrafSubmit($panel);
			
			navTab.reload(json.forwardUrl, {navTabId: json.navTabId});
		} else {
			//modified by SeanYang on 20160630统一获取分页form对象
			var $pagerForm = getPagerFormObjs(navTab.getCurrentPanel());//$("#pagerForm", navTab.getCurrentPanel());
			
			var args = $pagerForm.size()>0 ? $pagerForm.serializeArray() : {};
			navTabPageBreak(args, json.rel);
		}
		
		}
}

/**
 * 处理navTab上的查询, 会重新载入当前navTab
 * @param {Object} form
 */
function navTabSearch(form, navTabId){
	var $form = $(form);
	
	//added by Sean on 2016-05-18增加在查询时进行校验功能
	if (!$form.validate({debug: true}).form()) {
		return false;
	}
	setUnconventionalInputValue($form);
	
	//if (form[DWZ.pageInfo.pageNum]) form[DWZ.pageInfo.pageNum].value = 1;
	_setInitPageNum(form);
	
	navTab.reload($form.attr('action'), {data: $form.serializeArray(), navTabId:navTabId});
	return false;
}
/**
 * 处理dialog弹出层上的查询, 会重新载入当前dialog
 * @param {Object} form
 */
function dialogSearch(form){
	var $form = $(form);
	
	//added by Sean on 2016-05-18增加在查询时进行校验功能
	if (!$form.validate({debug: true}).form()) {
		return false;
	}
	setUnconventionalInputValue($form);
	
	//if (form[DWZ.pageInfo.pageNum]) form[DWZ.pageInfo.pageNum].value = 1;
	_setInitPageNum(form);
	
	$.pdialog.reload($form.attr('action'), {data: $form.serializeArray()});
	return false;
}
function dwzSearch(form, targetType){
	if (targetType == "dialog") dialogSearch(form);
	else navTabSearch(form);
	return false;
}
/**
 * 处理div上的局部查询, 会重新载入指定div
 * @param {Object} form
 */
function divSearch(form, rel){
	var $form = $(form);
	
	//added by Sean on 2016-05-18增加在查询时进行校验功能
	if (!$form.validate({debug: true}).form()) {
		return false;
	}
	setUnconventionalInputValue($form);
	
	//if (form[DWZ.pageInfo.pageNum]) form[DWZ.pageInfo.pageNum].value = 1;
	_setInitPageNum(form);
	
	if (rel) {
		var $box = $("#" + rel);
		$box.ajaxUrl({
			type:"POST", url:$form.attr("action"), data: $form.serializeArray(), callback:function(){
				$box.find("[layoutH]").layoutH();
			}
		});
	}
	return false;
}
/**
 * 初始化分页信息
 * @param form 原生form对象
 */
//added by Sean on 20160919
function _setInitPageNum(form) {
	if (form[DWZ.pageInfo.pageNum]) {
		form[DWZ.pageInfo.pageNum].value = 1;
	}
	//the reason for the history
	if (form["pageNum"]) {
		form["pageNum"].value = 1;
	}
}

/**
 * 统一获取分页form对象方法
 * added by SeanYang on20160630 获取pagerForm对象
 */
function getPagerFormObjs($parent) {
	var form = $("#pagerForm", $parent);
	
	/*处理多个tab页时，使用局部刷新时，分页控件失败和from id重复问题 
	jsp页面的form id必须设置为局部刷新的id + '_pagerForm'
	edit by lihu date 2016-05-27*/
	if(form == null || form.size() <= 0 || typeof(form) == 'undefined'){
		form = $("form[id$='_pagerForm']", $parent);
	}
	return form;
}

/**
 * 
 * @param {Object} args {pageNum:"",numPerPage:"",orderField:"",orderDirection:""}
 * @param String formId 分页表单选择器，非必填项默认值是 "pagerForm"
 */
function _getPagerForm($parent, args) {
	var form = getPagerFormObjs($parent)[0];
	
	if (form) {
		/*给form添加隐藏域 pageNum,numPerPage参数 date 2016-05-23 edit by lihu */
		if (args["pageNum"]){
			if(null == form[DWZ.pageInfo.pageNum] || typeof(form[DWZ.pageInfo.pageNum]) == 'undefined'){
				$(form).append("<input type='hidden' name='"+DWZ.pageInfo.pageNum+"' />");
			}
			$(form).find("input[type='hidden'][name='"+DWZ.pageInfo.pageNum+"']").val(args["pageNum"]);
			
			//edited by Sean on 20160628 默认增加pageNum，现在jraf平台分页参数设置为pageNo
			if(null == form['pageNum'] || typeof(form['pageNum']) == 'undefined'){
				$(form).append("<input type='hidden' name='pageNum' />");
			}
			$(form).find("input[type='hidden'][name='pageNum']").val(args["pageNum"]);
			
		} 
		if (args["numPerPage"]){
			if(null == form[DWZ.pageInfo.numPerPage] || typeof(form[DWZ.pageInfo.numPerPage]) == 'undefined'){
				$(form).append("<input type='hidden' name='"+DWZ.pageInfo.numPerPage+"' />");
			}
			$(form).find("input[type='hidden'][name='"+DWZ.pageInfo.numPerPage+"']").val(args["numPerPage"]);
		} 
		
		if (args["orderField"]){
			if(null == form[DWZ.pageInfo.numPerPage] || typeof(form[DWZ.pageInfo.orderField]) == 'undefined'){
				$(form).append("<input type='hidden' name='"+DWZ.pageInfo.orderField+"' />");
			}
			$(form).find("input[type='hidden'][name='"+DWZ.pageInfo.orderField+"']").val(args["orderField"]);
		}
		
		if (args["orderDirection"]){
			if(null == form[DWZ.pageInfo.orderDirection] || typeof(form[DWZ.pageInfo.orderDirection]) == 'undefined'){
				$(form).append("<input type='hidden' name='"+DWZ.pageInfo.orderDirection+"' />");
			}
			$(form).find("input[type='hidden'][name='"+DWZ.pageInfo.orderDirection+"']").val(args["orderDirection"]);
		}
	}
	
	return form;
}


/**
 * 处理navTab中的分页和排序
 * targetType: navTab 或 dialog
 * rel: 可选 用于局部刷新div id号
 * data: pagerForm参数 {pageNum:"n", numPerPage:"n", orderField:"xxx", orderDirection:""}
 * callback: 加载完成回调函数
 */
function dwzPageBreak(options){
	var op = $.extend({ targetType:"navTab", rel:"", data:{pageNum:"", numPerPage:"", orderField:"", orderDirection:""}, callback:null}, options);

	var $parent = op.targetType == "dialog" ? $.pdialog.getCurrent() : navTab.getCurrentPanel();

	if (op.rel) {
		var $box = $parent.find("#" + op.rel);
		var form = _getPagerForm($box, op.data);
		if (form) {
			 if (!$(form).validate({
			        debug: true,
			        ignore: ".select2-search__field"
			    }).form()) {
			        return false;
			    }
			//added by Sean on 20160714 自动获取分页查询条件form
			if ( $(form).attr("id").indexOf("_pagerForm") != -1) {
				$box = $parent.find("#" + $(form).attr("id").substring(0, $(form).attr("id").indexOf("_pagerForm")));
			}
			$box.ajaxUrl({
				type:"POST", url:$(form).attr("action"), data: $(form).serializeArray(), callback:function(){
					$box.find("[layoutH]").layoutH();
				}
			});
		}
		//if (form)form.submit();
	} else {
		var form = _getPagerForm($parent, op.data);
		var params = $(form).serializeArray();
		if(form){
			if (!$(form).validate({
		        debug: true,
		        ignore: ".select2-search__field"
		    }).form()) {
		        return false;
		    }
		}
		//added by Sean on 20160622 自动获取分页查询条件form
		if (!!form && $(form).attr("id").indexOf("_pagerForm") != -1) {
			var $box = $parent.find("#" + $(form).attr("id").substring(0, $(form).attr("id").indexOf("_pagerForm")));
			$box.ajaxUrl({
				type:"POST", url:$(form).attr("action"), data: $(form).serializeArray(), callback:function(){
					$box.find("[layoutH]").layoutH();
				}
			});
			//$(form).submit();
		} else if (op.targetType == "dialog") {
			if (form) $.pdialog.reload($(form).attr("action"), {data: params, callback: op.callback});
			//if (form) $(form).submit();
		} else {
			if (form) navTab.reload($(form).attr("action"), {data: params, callback: op.callback});
			//if (form) $(form).submit();
		}
	}
}
/**
 * 处理navTab中的分页和排序
 * @param args {pageNum:"n", numPerPage:"n", orderField:"xxx", orderDirection:""}
 * @param rel： 可选 用于局部刷新div id号
 */
function navTabPageBreak(args, rel){
	dwzPageBreak({targetType:"navTab", rel:rel, data:args});
}
/**
 * 处理dialog中的分页和排序
 * 参数同 navTabPageBreak 
 */
function dialogPageBreak(args, rel){
	dwzPageBreak({targetType:"dialog", rel:rel, data:args});
}


function ajaxTodo(url, callback, data){   
	var $callback = callback || navTabAjaxDone;
	if (! $.isFunction($callback)) $callback = eval('(' + callback + ')');
	$.ajax({
		type:'POST',
		url:url,
		dataType:"json",
		traditional:true,
		data: data,
		cache: false,
		success: $callback,
		error: DWZ.ajaxError
	});
}

/**
 * create by ZhiYong Wen 2017-08-31
 */
function jrafGridSearch(form,grid){
	if(!$(form).valid()) {return false;}
	setUnconventionalInputValue($(form));
	var grid = $("#"+grid);
	var url = $(form).attr("action");
	var postData={};
	var dataArray = $(form).serializeArray();
	for(var i=0;i<dataArray.length;i++){
		if(postData[dataArray[i].name]){    
            if($.isArray(serializeObj[dataArray[i].name])){    
            	postData[dataArray[i].name].push(dataArray[i].value);    
            }else{    
            	postData[dataArray[i].name]=[serializeObj[dataArray[i].name],dataArray[i].value];    
            }    
        }else{    
        	postData[dataArray[i].name]=dataArray[i].value;     
        }    
	}
	grid.pqGrid("option", "dataModel.url", url);
	grid.pqGrid("option", "dataModel.postData", postData);
	grid.pqGrid("option", "pageModel.curPage", 1);
	grid.pqGrid("refreshDataAndView");
	return false;
}


/**
 * http://www.uploadify.com/documentation/uploadify/onqueuecomplete/	
 */
function uploadifyQueueComplete(queueData){
	var msg = "The total number of files uploaded: "+queueData.uploadsSuccessful+"<br/>"
		+ "The total number of errors while uploading: "+queueData.uploadsErrored+"<br/>"
		+ "The total number of bytes uploaded: "+queueData.queueBytesUploaded+"<br/>"
		+ "The average speed of all uploaded files: "+queueData.averageSpeed;
	
	if (queueData.uploadsErrored) {
		alertMsg.error(msg);
	} else {
		alertMsg.correct(msg);
	}
}
/**
 * http://www.uploadify.com/documentation/uploadify/onuploadsuccess/
 */
function uploadifySuccess(file, data, response){
	alert(data)
}

/**
 * http://www.uploadify.com/documentation/uploadify/onuploaderror/
 */
function uploadifyError(file, errorCode, errorMsg) {
	alertMsg.error(errorCode+": "+errorMsg);
}


/**
 * http://www.uploadify.com/documentation/
 * @param {Object} event
 * @param {Object} queueID
 * @param {Object} fileObj
 * @param {Object} errorObj
 */
function uploadifyError(event, queueId, fileObj, errorObj){
	alert("event:" + event + "\nqueueId:" + queueId + "\nfileObj.name:" 
		+ fileObj.name + "\nerrorObj.type:" + errorObj.type + "\nerrorObj.info:" + errorObj.info);
}

function getGroupData($this){
	if($this.hasClass("jraf-operation")){
		var grid = $this.closest(".pq-grid");
		var rowIndx = $(grid).pqGrid( "getRowIndx", {$tr:$this.closest("tr")}).rowIndx;
		var rowData = $(grid).pqGrid( "getRowData", {rowIndxPage:rowIndx} );
		return rowData;
	}
	if($this.hasClass("jraf-btn")){
		var data = {};
		var group = $this.attr("group");
		if(group){
			var grid = $("#"+group);
			var selectionArray = $(grid).pqGrid("selection",{type:"row",method:"getSelection"});
			for(var i=0;i<selectionArray.length;i++){
				var rowData = selectionArray[i].rowData;
				for(var key in rowData){
					if(data[key]){
						data[key].push(rowData[key]);
					}else{
						data[key] = [rowData[key]];
					}
				}
			}
		}
		return data;
	}
}


$.fn.extend({
	ajaxTodo:function(){
		return this.each(function(){
			var $this = $(this);
			var callback = $this.attr("callback");
			$this.click(function(event){
				if ($this.hasClass('disabled')) {
					return false;
				}
				var url = unescape($this.attr("href")).replaceTmById($(event.target).parents(".unitBox:first"));
				DWZ.debug(url);
				if (!url.isFinishedTm()) {
					alertMsg.error($this.attr("warn") || DWZ.msg("alertSelectMsg"));
					return false;
				}				
				var confirm = $this.attr("title") || $this.attr("confirm");
				if (confirm) {
					alertMsg.confirm(confirm, {
						okCall: function(){
							ajaxTodo(url, callback, getGroupData($this));
						}
					});
				} else {
					ajaxTodo(url, callback, getGroupData($this));
				}
				event.preventDefault();
			});
		});
	},
	dwzExport: function(){
		function _doExport($this) {
			var $p = $this.attr("targetType") == "dialog" ? $.pdialog.getCurrent() : navTab.getCurrentPanel();
			//modified by SeanYang on 20160630统一获取分页form对象
			var $form = getPagerFormObjs($p);//$("#pagerForm", $p);
			var url = $this.attr("href");
//			window.location = url+(url.indexOf('?') == -1 ? "?" : "&")+$form.serialize();

			var $iframe = $("#callbackframe");
			if ($iframe.size() == 0) {
				$iframe = $("<iframe id='callbackframe' name='callbackframe' src='about:blank' style='display:none'></iframe>").appendTo("body");
			}

			var pagerFormUrl = $form[0].action;
			$form[0].action = url;
			$form[0].target = "callbackframe";
			$form.submit();

			$form[0].action = pagerFormUrl;
		}
		
		return this.each(function(){
			var $this = $(this);
			$this.click(function(event){
				var title = $this.attr("title");
				if (title) {
					alertMsg.confirm(title, {
						okCall: function(){_doExport($this);}
					});
				} else {_doExport($this);}
			
				event.preventDefault();
			});
		});
	}
});

/**
 * The W3C XMLHttpRequest specification dictates that the charset is always UTF-8; specifying another charset will not force the browser to change the encoding.
 * iframe模拟ajax load, 解决GBK页面ajax load乱码问题
 *
 * @param url
 * @param callback
 */
$.iframeLoad = function(url, callback) {

	var $form = $('<form method="post" action="'+url+'" target="callbackframe" style="display: none"><button type="submit">submit</button></form>').appendTo('body'),
		$iframe = $("#callbackframe");

	if ($iframe.size() == 0) {
		$iframe = $('<iframe id="callbackframe" name="callbackframe" src="about:blank" style="display:none"></iframe>').appendTo('body');
	}

	_iframeResponse($iframe[0], function(response) {
		$form.remove();
		if (callback) callback.call($iframe, response);
	}, 'html');

	$form.submit();
};

$.fn.iframeLoad = function(url, callback) {
	return this.each(function(){
		var $box = $(this);

		$.iframeLoad(url, function(response){
			$box.html(response).initUI();
			if (callback) callback.call($box, response);
		});
	});
};
