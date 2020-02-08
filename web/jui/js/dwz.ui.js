
$.fn.jrafAjaxSend = function(){
	var $this = $(this),
		html = '<div class="jf-shade"><div class="jf-shade-bg"></div><div  class="jf-shade-progress"><i class="fa fa-spinner fa-spin fa-4x fa-fw"></i></div></div>';
	if(!$this || !$this.length) $this = $("body");
	if($this.is("body") || $this.hasClass("unitBox")){
		$this.append(html);
	}else{
		var $box = $this.parents("body, .unitBox").first();
		$box.append(html);
	}
},
$.fn.jrafAjaxComplete = function(){
	
	var $this = $(this);
	if(!$this || !$this.length)  $this = $("body");
	
	if(!$this.is("body") && !$this.hasClass("unitBox")){
		$this = $this.parents("body, .unitBox").first();
	}
	var $remove = $this.find(">.jf-shade:not(.jf-shade-remove)").last();
	$remove.addClass("jf-shade-remove");
	
	$remove.hide(1);
	setTimeout(function(){
		$remove.remove();
	},1);
}

function initEnv() {
	$("body").append(DWZ.frag["dwzFrag"]);

	$(window).resize(function(){
		initLayout();
		$(this).trigger(DWZ.eventType.resizeGrid);
	});

	var ajaxbg = $("#background,#progressBar");
	//ajaxbg.hide();
	$(document).ajaxStart(function(){
		if($(".jf-shade").length>0) return;
		$("body").jrafAjaxSend();
		$("body > .jf-shade:last").addClass("jf-shade-body");
		/*if(!Jraf.controlAjaxBg) {
			ajaxbg.show(0);
		}*/
	}).ajaxStop(function(){
		if(! $("body > .jf-shade-body").length) return;
		$("body").jrafAjaxComplete();
		
		/*if(!Jraf.controlAjaxBg) {
			//ajaxbg.hide(10);
		}*/
	}).ajaxComplete(function(){
		if(! $("body > .jf-shade-body").length) return;
		$("body").jrafAjaxComplete();
		
		/*if(!Jraf.controlAjaxBg) {
			//ajaxbg.hide(10);
		}*/
	});
	
	if ($.fn.jBar) $("#leftside").jBar({minW:150, maxW:700});
	
	if ($.taskBar) $.taskBar.init();
	if (window.navTab) navTab.init();
	if ($.fn.switchEnv) $("#switchEnvBox").switchEnv();
	if ($.fn.navMenu) $("#navMenu").navMenu();
		
	setTimeout(function(){
		initLayout();

		// 注册DWZ插件。
		DWZ.regPlugins.push(initUI); //第三方jQuery插件注册方法：DWZ.regPlugins.push(function($p){});

		// 首次初始化插件
		$(document).initUI();
		
		// navTab styles
		var jTabsPH = $("div.tabsPageHeader");
		jTabsPH.find(".tabsLeft").hoverClass("tabsLeftHover");
		jTabsPH.find(".tabsRight").hoverClass("tabsRightHover");
		jTabsPH.find(".tabsMore").hoverClass("tabsMoreHover");
	
	}, 10);

}
//蒙版显示与隐藏
function progressShow(text) {
	var progress = $("#background,#progressBar1");
	text == null || text == undefined ? $("#progressBar1").text($("#progressBar").text()):$("#progressBar1").text(text);
	progress.show();
}
function progressHide() {
	var progress = $("#background,#progressBar1");
	progress.hide();
}

function initLayout(){
	/*edited by Sean on 20160115 框架样式调整*/
	var iContentW = $(window).width() - (DWZ.ui.sbar ? $("#sidebar").width() + 8 : 34);
	var iContentH = $(window).height() - $("#headerheight").height() - 45;
	if($("#navTab > .tabsPageHeader").css("display") == "none"){
		iContentH = iContentH + 37;
	}
   /* $("#container").width(iContentW);*/
	/*$("#container .tabsPageContent").height(iContentH - 14).find("[layoutH]").layoutH();*/
	$("#container").hasClass("changes-cale") ? $("#container .tabsPageContent").height($(window).height() - 77).find("[layoutH]").layoutH() : $("#container .tabsPageContent").height(iContentH - 32).find("[layoutH]").layoutH();
	$("#sidebar, #sidebar_s .collapse, #splitBar, #splitBarProxy").height(iContentH + 40);
/*	$("#sidebar_s .collapse, #splitBar, #splitBarProxy").height(iContentH);*/
	
/*	$("#sidebar").height(iContentH + 40);*/
	$("#taskbar").css({top: iContentH + $("#headerheight").height() + 5, width:$(window).width()});
	$(".changescale").unbind().bind("click", function(){
		$("#container").toggleClass("changes-cale");
		$("#container").hasClass("changes-cale") ? $("#container .tabsPageContent").height($(window).height() - 77).find("[layoutH]").layoutH() : $("#container .tabsPageContent").height(iContentH - 32).find("[layoutH]").layoutH();
	})
}
/**
 * 取collection指定列的值，组装成data 放在option.data 里面，最后Ajax 传入后台
 * @param selectedIds
 * @param targetType
 * @returns {Array}
 */
function _getPkvals(selectedIds, targetType){
	var pkvalArr = [];
	var ids = "";
	var pkvals = "";
	var pkvalas = "";
	var pkvalbs = "";
	var pkvalcs = "";
	var pkvalds = "";
	var $box = targetType == "dialog" ? $.pdialog.getCurrent() : navTab.getCurrentPanel();
	var f_pkval = false;
	var f_pkvala = false;
	var f_pkvalb = false;
	var f_pkvalc = false;
	var f_pkvald = false;
	$box.find("input:checked").filter("[name='"+selectedIds+"']").each(function(i){
		var val = $(this).val();
		ids += i==0 ? val : ","+val;
		
		var pkval = $(this).attr("pkval");
		var pkvala = $(this).attr("pkvala");
		var pkvalb = $(this).attr("pkvalb");
		var pkvalc = $(this).attr("pkvalc");
		var pkvald = $(this).attr("pkvald");
		if(pkval && !f_pkval) {
			f_pkval = true;
		}
		if(f_pkval) {
			pkvals += i==0?pkval:","+pkval;
		}
		
		if(f_pkval && pkvala && !f_pkvala) {
			f_pkvala = true;
		}
		if(f_pkvala) {
			pkvalas += i==0?pkvala:","+pkvala;
		}
		
		if(f_pkval && f_pkvala && pkvalb && !f_pkvalb) {
			f_pkvalb = true;
		}
		if(f_pkvalb) {
			pkvalbs += i==0?pkvalb:","+pkvalb;
		}
		
		if(f_pkval && f_pkvala && f_pkvalb && pkvalc && !f_pkvalc) {
			f_pkvalc = true;
		}
		if(f_pkvalc) {
			pkvalcs += i==0?pkvalc:","+pkvalc;
		}
		
		if(f_pkval && f_pkvala && f_pkvalb && f_pkvalc && pkvald && !f_pkvald) {
			f_pkvald = true;
		}
		if(f_pkvald) {
			pkvalds += i==0?pkvald:","+pkvald;
		}
	});
	pkvalArr.push({field:selectedIds,vals:ids});
	if(f_pkval) {
		pkvalArr.push({field:"pkval",vals:pkvals});
		if(f_pkvala) {
			pkvalArr.push({field:"pkvala",vals:pkvalas});
			if(f_pkvalb) {
				pkvalArr.push({field:"pkvalb",vals:pkvalbs});
				if(f_pkvalc) {
					pkvalArr.push({field:"pkvalc",vals:pkvalcs});
					if(f_pkvald) {
						pkvalArr.push({field:"pkvald",vals:pkvalds});
					}
				}
			}
		}
	}
	return pkvalArr;
}

/**
 * 去collection的值
 * @param $this 
 * @returns
 * log collection 修改为同意 group
 */
function getCollectionData($this) {
	var selectedIds = $this.attr("group") || "ids";
	var targetType = $this.attr("targetType");
	var pkvalArr = _getPkvals(selectedIds, targetType);
	return $.map(pkvalArr,function(val,i) {
		return $.map(val.vals.split(","),function(val1,j) {
			return {name:val.field,value:val1};
		});	
	});
}


function initUI($p){
	if ($.fn.jrafSelect) $("select.jraf-select", $p).jrafSelect($p);
	
	//tables
	if ($.fn.jTable) $("table.table", $p).jTable();

	// css tables
	if ($.fn.cssTable) $('table.list', $p).cssTable();

	if ($.fn.jPanel) $("div.panel", $p).jPanel();

	//auto bind tabs
	$("div.tabs", $p).each(function(){
		var $this = $(this);
		var options = {};
		options.currentIndex = $this.attr("currentIndex") || 0;
		options.eventType = $this.attr("eventType") || "click";
		$this.tabs(options);
	});

	if ($.fn.jTree) $("ul.tree", $p).jTree();

	if ($.fn.jTree){
		$('div.accordion', $p).each(function(){
			var $this = $(this);
			$this.accordion({fillSpace:$this.attr("fillSpace"),alwaysOpen:true,active:0});
		});
	}

	if ($.fn.checkboxCtrl){
		$(":button.checkboxCtrl, :checkbox.checkboxCtrl", $p).checkboxCtrl($p);
	}
	
	if ($.fn.combox) $("select.combox",$p).combox();
	
	if ($.fn.xheditor) {
		$("textarea.editor", $p).each(function(){
			var $this = $(this);
			var op = {html5Upload:false, skin: 'vista',tools: $this.attr("tools") || 'full'};
			var upAttrs = [
				["upLinkUrl","upLinkExt","zip,rar,txt"],
				["upImgUrl","upImgExt","jpg,jpeg,gif,png"],
				["upFlashUrl","upFlashExt","swf"],
				["upMediaUrl","upMediaExt","avi"]
			];
			
			$(upAttrs).each(function(i){
				var urlAttr = upAttrs[i][0];
				var extAttr = upAttrs[i][1];
				
				if ($this.attr(urlAttr)) {
					op[urlAttr] = $this.attr(urlAttr);
					op[extAttr] = $this.attr(extAttr) || upAttrs[i][2];
				}
			});
			
			$this.xheditor(op);
		});
	}
	
	if ($.fn.uploadify) {
		$(":file[uploaderOption]", $p).each(function(){
			var $this = $(this);
			var options = {
				fileObjName: $this.attr("name") || "file",
				auto: true,
				multi: true,
				onUploadError: uploadifyError,
				onQueueComplete:uploadifyQueueComplete
			};
			var uploaderOption = DWZ.jsonEval($this.attr("uploaderOption"));
			$.extend(options, uploaderOption);

			DWZ.debug("uploaderOption: "+DWZ.obj2str(uploaderOption));
			
			$this.uploadify(options);
		});
	}
	
	// init styles
	$("input[type=text], input[type=password], textarea", $p).addClass("textInput").focusClass("focus");

	$("input[readonly], textarea[readonly]", $p).addClass("readonly");
	$("input[disabled=true], textarea[disabled=true]", $p).addClass("disabled");

	$("input[type=text]", $p).not("div.tabs input[type=text]", $p).filter("[alt]").inputAlert();
	if ($.fn.autoNumeric){
		$("input[customtype='money']", $p).each(function(){
			var scale = parseInt($(this).attr("scale")) || 2;
			if(scale > 6) scale = 6;
			$(this).autoNumeric('init',{
				mDec:scale, //默认小数位数
				vMax:"99999999999999999999999999999999.999999",
				vMin:"-99999999999999999999999999999999.999999",
				unSetOnSubmit:true
			});
		});
	}

	//Grid ToolBar
	$("div.panelBar li, div.panelBar", $p).hoverClass("hover");

	//Button
	$("div.button", $p).hoverClass("buttonHover");
	$("div.buttonActive", $p).hoverClass("buttonActiveHover");
	
	//tabsPageHeader
	$("div.tabsHeader li, div.tabsPageHeader li, div.accordionHeader, div.accordion", $p).hoverClass("hover");

	//validate form
	if ($.fn.validate) {
		$("form.required-validate", $p).each(function(){
			var $form = $(this);
			$form.validate({
				onsubmit: false,
				focusInvalid: false,
				focusCleanup: true,
				errorElement: "span",
				ignore:".ignore",
				invalidHandler: function(form, validator) {
					//var errors = validator.numberOfInvalids();
					var errors = validator.size();
					if (errors) {
						var message = DWZ.msg("validateFormError",[errors]);
						alertMsg.error(message);
					}
				}
			});

			$form.find('input[customvalid]').each(function(){
				var $input = $(this);
				$input.rules("add", {
					customvalid: $input.attr("customvalid")
				})
			});
		});
	}

	if ($.fn.datepicker){
		$('input.date', $p).each(function(){
			var $this = $(this);
			var opts = {};
			if ($this.attr("dateFmt")) opts.pattern = $this.attr("dateFmt");
			if ($this.attr("minDate")) opts.minDate = $this.attr("minDate");
			if ($this.attr("maxDate")) opts.maxDate = $this.attr("maxDate");
			if ($this.attr("mmStep")) opts.mmStep = $this.attr("mmStep");
			if ($this.attr("ssStep")) opts.ssStep = $this.attr("ssStep");
			if($this.next("a").hasClass("inputDateButton")) $this.next("a").html('<i class="jf-btn-calendar"></i>');
			$this.datepicker(opts,$p);
		});
	}

	// navTab
	$("a[target=navTab]", $p).each(function(){
		$(this).click(function(event){
			var $this = $(this);
			var title = $this.attr("title") || $this.text();
			var collection = $this.attr("group");
			var pkData = null;
			if(collection) {
				pkData = getCollectionData($(this));
			}
			var tabid = $this.attr("rel") || "_blank";
			var fresh = eval($this.attr("fresh") || "true");
			var external = eval($this.attr("external") || "false");
			//added by Sean on 20161230 added the param property
			var param = $this.attr("param") || "";
			var data = new Object();
			if(pkData!=null || param.length>0) {
				data = $.extend(pkData,param);
			}
			if($this.hasClass("jraf-btn") || $this.hasClass("jraf-operation")){
				data = $.extend(data,getGroupData($this));
			}
			//added by Sean on 20161230 added the method property
			var type = $this.attr("method") || "GET";
			//added by Sean on 20170105 added the colse property
			var close = eval($this.attr("close") || "");
			var treeid = $this.closest("ul").prop("id")||"false";
			
			var url = unescape($this.attr("href")).replaceTmById($(event.target).parents(".unitBox:first"));
			DWZ.debug(url);
			if (!url.isFinishedTm()) {
				alertMsg.error($this.attr("warn") || DWZ.msg("alertSelectMsg"));
				return false;
			}
			navTab.openTab(tabid, url,{title:title, fresh:fresh, external:external, data: data, type: type, close: close}, treeid);
			event.preventDefault();
		});
	});

	//dialogs
	$("a[target=dialog]", $p).each(function(){
		$(this).click(function(event){
			var $this = $(this);
			var title = $this.attr("title") || $this.text();
			var rel = $this.attr("rel") || "_blank";
			var options = {};
			if($this.attr("option")){
				var op = $this.attr("option");
				var reg = /([\u2E80-\u9FFFa-zA-Z0-9_-]+)/g;
				var op = op.replace(/'/g,"").replace(reg,"\"$1\"");
				options = JSON.parse(op);
			}
			var w = $this.attr("width");
			var h = $this.attr("height");
			if (w) options.width = w;
			if (h) options.height = h;
			options.max = eval($this.attr("max") || "false");
			//edited by Sean on 20160526默认开启遮罩
			options.mask = eval($this.attr("mask") || "true");
			options.maxable = eval($this.attr("maxable") || "true");
			options.minable = eval($this.attr("minable") || "true");
			options.fresh = eval($this.attr("fresh") || "true");
			options.resizable = eval($this.attr("resizable") || "true");
			options.drawable = eval($this.attr("drawable") || "true");
			options.close = eval($this.attr("close") || "");
			var param = $this.attr("param") || "";
			//options.data = options.param;
			
			//added by Sean on 20161230 added the method property
			options.type = $this.attr("method") || "GET";
			
			var collection = $this.attr("group");
			var pkData = null;
			if(collection) {
				pkData = getCollectionData($(this));
			}
			var data = new Object();
			if(pkData!=null || param.length>0) {
				data = $.extend(pkData,param);
			}
			if($this.hasClass("jraf-btn") || $this.hasClass("jraf-operation")){
				data = getGroupData($this);
			}
			options.data = data;
			var url = unescape($this.attr("href")).replaceTmById($(event.target).parents(".unitBox:first"));
			DWZ.debug(url);
			if (!url.isFinishedTm()) {
				alertMsg.error($this.attr("warn") || DWZ.msg("alertSelectMsg"));
				return false;
			}
			$.pdialog.open(url, rel, title, options);
			
			return false;
		});
	});
	$("a[target=ajax]", $p).each(function(){
		$(this).click(function(event){
			var $this = $(this);
			var rel = $this.attr("rel");
			//make tag of  a[target=ajax] bring value by id edit by hzx 20161215
			var url = unescape($this.attr("href")).replaceTmById($(event.target).parents(".unitBox:first"));
			DWZ.debug(url);
			if (!url.isFinishedTm()) {
				alertMsg.error($this.attr("warn") || DWZ.msg("alertSelectMsg"));
				return false;
			}
			
			if (rel) {
				var $rel = $("#"+rel);
				$rel.loadUrl(url, {}, null/*function(){
					$rel.find("[layoutH]").layoutH();
				}*/);
			}

			event.preventDefault();
		});
	});
	$("div.pagination:not(.datagrid-pager)", $p).each(function(){
		var $this = $(this);
		$this.dwzpagination({
			targetType:$this.attr("targetType"),
			rel:$this.attr("rel"),
			totalCount:$this.attr("totalCount"),
			numPerPage:$this.attr("numPerPage"),
			pageNumShown:$this.attr("pageNumShown"),
			currentPage:$this.attr("currentPage"),
			noCount:$this.attr("noCount")
		});
		_getPagerForm($p, {"pageNum":$this.attr("currentPage"),"numPerPage":$this.attr("numPerPage")});
	});

	if ($.fn.sortDrag) $("div.sortDrag", $p).sortDrag();

	// dwz.ajax.js
	if ($.fn.ajaxTodo) $("a[target=ajaxTodo]", $p).ajaxTodo();
	if ($.fn.dwzExport) $("a[target=dwzExport]", $p).dwzExport();
	
	if ($.fn.lookup) $("a[lookupgroup], a.btnLook", $p).lookup();
	if ($.fn.multLookup) $("[multLookup]:button", $p).multLookup();
	if ($.fn.suggest) $("input[suggestFields]", $p).suggest();
	if ($.fn.itemDetail) $("table.itemDetail", $p).itemDetail();
	if ($.fn.selectedTodo) $("a[target=selectedTodo]", $p).selectedTodo();
	if ($.fn.pagerForm) $("form[rel=pagerForm]", $p).pagerForm({parentBox:$p});

	//init jraf.js
	if(window.Jraf){
		var options = {};
		Jraf.init(options,$p);
	}

}


