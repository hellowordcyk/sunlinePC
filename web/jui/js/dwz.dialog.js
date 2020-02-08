/**
 * @author Roger Wu
 * reference:dwz.drag.js, dwz.dialogDrag.js, dwz.resize.js, dwz.taskBar.js
 */
(function($){
	$.pdialog = {
		_op:{height:300, width:580, minH:40, minW:50, total:20, max:false, mask:true, resizable:true, drawable:true, maxable:true,minable:true,fresh:true,close:true},
		_current:null,
		_zIndex:42,
		getCurrent:function(){
			return this._current;
		},
		reload:function(url, options){
			var op = $.extend({data:{}, dialogId:"", callback:null}, options);
			var dialog = (op.dialogId && $("body").data(op.dialogId)) || this._current;
			if (dialog){
				var jDContent = dialog.find(".dialogContent");
				jDContent.ajaxUrl({
					type:"POST", url:url, data:op.data, callback:function(response){
						jDContent.find("[layoutH]").layoutH(jDContent);
						//edited by Sean on 20160526 dialogContent样式增加position：absolute,相应宽高度调整
						//$(".pageContent", dialog).width($(dialog).width()-14);
						$(".pageContent", dialog).width($(dialog).width());
						//edited by Sean on 20160526修复内容过多，超出宽度问题
						jDContent.width($(dialog).width());
						
						$(":button.close", dialog).click(function(){
							$.pdialog.close(dialog);
							return false;
						});
						if ($.isFunction(op.callback)) op.callback(response);
					}
				});
			}
		},
		//打开一个层
		open:function(url, dlgid, title, options) {
			var op = $.extend({},$.pdialog._op, options);
			var dialog = $("body").data(dlgid);
			//重复打开一个层
			if(dlgid !=="_blank" && dialog) {
				if(dialog.is(":hidden")) {
					dialog.show();
				}
				//added by Sean on 2016-12-26 clean params
				if(options.param) {
					dialog.data("param",options.param);
				}
				
				if(op.fresh || url != $(dialog).data("url")){
					dialog.data("url",url);
					dialog.find(".dialogHeader").find("h1").html(title);
					this.switchDialog(dialog);
					var jDContent = dialog.find(".dialogContent");

					jDContent.ajaxUrl({
						type:options.type||'GET', url:url, data:options.data || {}, callback:function(){
							jDContent.find("[layoutH]").layoutH(jDContent);
							//edited by Sean on 20160526 dialogContent样式增加position：absolute,相应宽高度调整
							//$(".pageContent", dialog).width($(dialog).width()-14);
							$(".pageContent", dialog).width($(dialog).width());
							
							$("button.close").click(function(){
								$.pdialog.close(dialog);
								return false;
							});
						}
					});
				}
			
			} else { //打开一个全新的层
			
				$("body").append(DWZ.frag["dialogFrag"]);
				dialog = $(">.dialog:last-child", "body");
				dialog.data("id",dlgid);
				dialog.data("url",url);
				if(options.close) dialog.data("close",options.close);
				if(options.param) dialog.data("param",options.param);
				($.fn.bgiframe && dialog.bgiframe());
				
				dialog.find(".dialogHeader").find("h1").html(title);
				$(dialog).css("zIndex", ($.pdialog._zIndex+=2));
				$("div.shadow").css("zIndex", $.pdialog._zIndex - 3).show();
				$.pdialog._init(dialog, options);
				$(dialog).click(function(){
					$.pdialog.switchDialog(dialog);
				});
				
				if(op.resizable)
					dialog.jresize();
				if(op.drawable)
				 	dialog.dialogDrag();
				if(op.close){
					$("a.close", dialog).click(function(event){ 
						$.pdialog.close(dialog);
						return false;
					});
				}else{
					$("a.close", dialog).hide();
				};
				if (op.maxable) {
					$("a.maximize", dialog).show().click(function(event){
						$.pdialog.switchDialog(dialog);
						$.pdialog.maxsize(dialog);
						dialog.jresize("destroy").dialogDrag("destroy");
						return false;
					});
				} else {
					$("a.maximize", dialog).hide();
				}
				$("a.restore", dialog).click(function(event){
					$.pdialog.restore(dialog);
					dialog.jresize().dialogDrag();
					return false;
				});
				if (op.minable) {
					$("a.minimize", dialog).show().click(function(event){
						$.pdialog.minimize(dialog);
						return false;
					});
				} else {
					$("a.minimize", dialog).hide();
				}
				$("div.dialogHeader a", dialog).mousedown(function(){
					return false;
				});
				$("div.dialogHeader", dialog).dblclick(function(){
					if($("a.restore",dialog).is(":hidden"))
						$("a.maximize",dialog).trigger("click");
					else
						$("a.restore",dialog).trigger("click");
				});
				if(op.max) {
//					$.pdialog.switchDialog(dialog);
					$.pdialog.maxsize(dialog);
					dialog.jresize("destroy").dialogDrag("destroy");
				}
				$("body").data(dlgid, dialog);
				$.pdialog._current = dialog;
				$.pdialog.attachShadow(dialog);
				//load data
				var jDContent = $(".dialogContent",dialog);
				jDContent.ajaxUrl({
					type:options.type||'GET', url:url, data:options.data || {}, callback:function(){
						jDContent.find("[layoutH]").layoutH(jDContent);
						//edited by Sean on 20160526 dialogContent样式增加position：absolute,相应宽高度调整
						//$(".pageContent", dialog).width($(dialog).width()-14);
						$(".pageContent", dialog).width($(dialog).width());
						
						$("button.close").click(function(){
							$.pdialog.close(dialog);
							return false;
						});
					}
				});
				
				/**
				 * 打开新层时，
				 */
				if (op.mask) {
					
				}
			}
			if (op.mask) {
				/*if ($("#dialogBackground2").is(':visible')){//the third mask div
					$("#dialogBackground3").show();
					$(dialog).css("zIndex", DWZ.maskArgs.dialogZindex+2000);
				} 
				else if ($("#dialogBackground").is(':visible')) {//the second mask div
					$("#dialogBackground2").show();
					$(dialog).css("zIndex", DWZ.maskArgs.dialogZindex+1000);
				} else {//the first mask div
*/					$("#dialogBackground").show();
					//$(dialog).css("zIndex", 1000);
				//$(".dialog").css("zIndex", DWZ.maskArgs.dialogZindex + 30 );
					$(dialog).css("zIndex", DWZ.maskArgs.dialogZindex + 31);
				/*}*/
				
				$("a.minimize",dialog).hide();
				$(dialog).data("mask", true);
				
				//added by Sean on 20160919 clean datepicker otherwise it'll display on the top of all divs
				$("#calendar").remove();
				
			}else {
				//add a task to task bar
				if(op.minable) $.taskBar.addDialog(dlgid,title);
			}
		},
		addCurrentParams: function (params) {
			var dialog = this.getCurrent();//$("body").data(dlgid);
			
			if (dialog) {
				var param = dialog.data("param");
				if(param && param != ""){
					param = DWZ.jsonEval(param);
				} else {
					param = {};
				} 
				$.extend(param, params);
				dialog.data("param", param);
			}
		},
		/**
		 * 切换当前层
		 * @param {Object} dialog
		 */
		switchDialog:function(dialog) {
			var index = $(dialog).css("zIndex");
			$.pdialog.attachShadow(dialog);
			if($.pdialog._current) {
				var cindex = $($.pdialog._current).css("zIndex");
				$($.pdialog._current).css("zIndex", index);
				$(dialog).css("zIndex", cindex);
				$("div.shadow").css("zIndex", cindex - 1);
				$.pdialog._current = dialog;
			}
			$.taskBar.switchTask(dialog.data("id"));
		},
		/**
		 * 给当前层附上阴隐层
		 * @param {Object} dialog
		 */
		attachShadow:function(dialog) {
			var shadow = $("div.shadow");
			if(shadow.is(":hidden")) shadow.show();
			shadow.css({
				top: parseInt($(dialog)[0].style.top) - 2,
				left: parseInt($(dialog)[0].style.left) - 4,
				height: parseInt($(dialog).height()) + 8,
				width: parseInt($(dialog).width()) + 8,
				zIndex:parseInt($(dialog).css("zIndex")) - 1
			});
			$(".shadow_c", shadow).children().andSelf().each(function(){
				$(this).css("height", $(dialog).outerHeight() - 4);
			});
		},
		_init:function(dialog, options) {
			var op = $.extend({}, this._op, options);
			var height = op.height>op.minH?op.height:op.minH;
			var width = op.width>op.minW?op.width:op.minW;
			if(isNaN(dialog.height()) || dialog.height() < height){
				$(dialog).height(height+"px");
				//edited by Sean on 20160526 dialogContent样式增加position：absolute,相应宽高度调整
				//$(".dialogContent",dialog).height(height - $(".dialogHeader", dialog).outerHeight() - $(".dialogFooter", dialog).outerHeight() - 6);
				$(".dialogContent",dialog).height((height - $(".dialogHeader", dialog).outerHeight() - $(".dialogFooter", dialog).outerHeight())+"px");
			}
			
			if(isNaN(dialog.css("width")) || dialog.width() < width) {
				$(dialog).width(width+"px");
				//edited by Sean on 20160526修复内容过多，超出宽度问题
				//$(".dialogContent",dialog).css("width", width+"px");
				$(".dialogContent",dialog).width(width+"px");
			}
			
			var iTop = ($(window).height()-dialog.height())/2;
			dialog.css({
				left: ($(window).width()-dialog.width())/2,
				top: iTop > 0 ? iTop : 0
			});
		},
		/**
		 * 初始化半透明层
		 * @param {Object} resizable
		 * @param {Object} dialog
		 * @param {Object} target
		 */
		initResize:function(resizable, dialog,target) {
			$("body").css("cursor", target + "-resize");
			resizable.css({
				top: $(dialog).css("top"),
				left: $(dialog).css("left"),
				height:$(dialog).css("height"),
				width:$(dialog).css("width")
			});
			resizable.show();
		},
		/**
		 * 改变阴隐层
		 * @param {Object} target
		 * @param {Object} options
		 */
		repaint:function(target,options){
			var shadow = $("div.shadow");
			if(target != "w" && target != "e") {
				shadow.css("height", shadow.outerHeight() + options.tmove);
				$(".shadow_c", shadow).children().andSelf().each(function(){
					$(this).css("height", $(this).outerHeight() + options.tmove);
				});
			}
			if(target == "n" || target =="nw" || target == "ne") {
				shadow.css("top", options.otop - 2);
			}
			if(options.owidth && (target != "n" || target != "s")) {
				shadow.css("width", options.owidth + 8);
			}
			if(target.indexOf("w") >= 0) {
				shadow.css("left", options.oleft - 4);
			}
		},
		/**
		 * 改变左右拖动层的高度
		 * @param {Object} target
		 * @param {Object} tmove
		 * @param {Object} dialog
		 */
		resizeTool:function(target, tmove, dialog) {
			$("div[class^='resizable']", dialog).filter(function(){
				return $(this).attr("tar") == 'w' || $(this).attr("tar") == 'e';
			}).each(function(){
				$(this).css("height", $(this).outerHeight() + tmove);
			});
		},
		/**
		 * 改变原始层的大小
		 * @param {Object} obj
		 * @param {Object} dialog
		 * @param {Object} target
		 */
		resizeDialog:function(obj, dialog, target) {
			var oleft = parseInt(obj.style.left);
			var otop = parseInt(obj.style.top);
			var height = parseInt(obj.style.height);
			var width = parseInt(obj.style.width);
			if(target == "n" || target == "nw") {
				tmove = parseInt($(dialog).css("top")) - otop;
			} else {
				tmove = height - parseInt($(dialog).css("height"));
			}
			$(dialog).css({left:oleft,width:width,top:otop,height:height});
			//edited by Sean on 20160526 dialogContent样式增加position：absolute,相应宽高度调整
			//$(".dialogContent", dialog).css("width", (width-12) + "px");
			//$(".pageContent", dialog).css("width", (width-14) + "px");
			$(".dialogContent", dialog).css("width", (width) + "px");
			$(".pageContent", dialog).css("width", (width) + "px");
			if (target != "w" && target != "e") {
				var content = $(".dialogContent", dialog);
				//content.css({height:height - $(".dialogHeader", dialog).outerHeight() - $(".dialogFooter", dialog).outerHeight() - 6});
				content.css({height: (height - $(".dialogHeader", dialog).outerHeight() - $(".dialogFooter", dialog).outerHeight())+"px"});
				content.find("[layoutH]").layoutH(content);
				$.pdialog.resizeTool(target, tmove, dialog);
			}
			$.pdialog.repaint(target, {oleft:oleft,otop: otop,tmove: tmove,owidth:width});
			
			$(window).trigger(DWZ.eventType.resizeGrid);
		},
		close:function(dialog) {
			if(typeof dialog == 'string') dialog = $("body").data(dialog);
			var close = dialog.data("close");
			var go = true;
			if(close && $.isFunction(close)) {
				var param = dialog.data("param");
				if(param && param != ""){
					param = DWZ.jsonEval(param);
					go = close(param);
				} else {
					go = close();
				}
				if(!go) return;
			}
			
			$(dialog).hide();
			$("div.shadow").hide();
			if($(dialog).data("mask")){
				/*if ($("#dialogBackground3").is(':visible')){//the third mask div
					$("#dialogBackground3").hide();
				} else if ($("#dialogBackground2").is(':visible')) {//the second mask div
					$("#dialogBackground2").hide();
				} else {//the first mask div
*/				
	            /* $("#dialogBackground").hide();*/
				/*}*/
				
			} else{
				if ($(dialog).data("id")) $.taskBar.closeDialog($(dialog).data("id"));
			}
			$("body").removeData($(dialog).data("id"));
			$(dialog).trigger(DWZ.eventType.pageClear).remove();
			$(window).trigger(DWZ.eventType.resizeGrid);
			if($(".dialog").size() <= 0){
	              $("#dialogBackground").hide();
             }
			$(".dialog").last().css("zIndex", DWZ.maskArgs.dialogZindex + 31 );
		},
		closeCurrent:function(){
			this.close($.pdialog._current);
		},
		checkTimeout:function(){
			var $conetnt = $(".dialogContent", $.pdialog._current);
			var json = DWZ.jsonEval($conetnt.html());
			if (json && json[DWZ.keys.statusCode] == DWZ.statusCode.timeout) this.closeCurrent();
		},
		maxsize:function(dialog) {
			$(dialog).data("original",{
				top:$(dialog).css("top"),
				left:$(dialog).css("left"),
				width:$(dialog).css("width"),
				height:$(dialog).css("height")
			});
			$("a.maximize",dialog).hide();
			$("a.restore",dialog).show();
			var iContentW = $(window).width();
			var iContentH = $(window).height() - 34;
			$(dialog).css({top:"0px",left:"0px",width:iContentW+"px",height:iContentH+"px"});
			$.pdialog._resizeContent(dialog,iContentW,iContentH);
		},
		restore:function(dialog) {
			var original = $(dialog).data("original");
			var dwidth = parseInt(original.width);
			var dheight = parseInt(original.height);
			$(dialog).css({
				top:original.top,
				left:original.left,
				width:dwidth,
				height:dheight
			});
			$.pdialog._resizeContent(dialog,dwidth,dheight);
			$("a.maximize",dialog).show();
			$("a.restore",dialog).hide();
			$.pdialog.attachShadow(dialog);
		},
		minimize:function(dialog){
			$(dialog).hide();
			$("div.shadow").hide();
			var task = $.taskBar.getTask($(dialog).data("id"));
			$(".resizable").css({
				top: $(dialog).css("top"),
				left: $(dialog).css("left"),
				height:$(dialog).css("height"),
				width:$(dialog).css("width")
			}).show().animate({top:$(window).height()-60,left:task.position().left,width:task.outerWidth(),height:task.outerHeight()},250,function(){
				$(this).hide();
				$.taskBar.inactive($(dialog).data("id"));
			});
		},
		_resizeContent:function(dialog,width,height) {
			var content = $(".dialogContent", dialog);
			//edited by Sean on 20160526 dialogContent样式增加position：absolute,相应宽高度调整
			//content.css({width:(width-12) + "px",height:height - $(".dialogHeader", dialog).outerHeight() - $(".dialogFooter", dialog).outerHeight() - 6});
			content.css({width:(width) + "px",height: (height - $(".dialogHeader", dialog).outerHeight() - $(".dialogFooter", dialog).outerHeight()) + "px" });
			content.find("[layoutH]").layoutH(content);
			//$(".pageContent", dialog).css("width", (width-14) + "px");
			$(".pageContent", dialog).css("width", (width) + "px");
			
			$(window).trigger(DWZ.eventType.resizeGrid);
		}
	};
})(jQuery);
