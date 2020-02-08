/**
 * @author Roger Wu v1.0
 * @author ZhangHuihua@msn.com 2011-4-1
 */
(function($){
	$.fn.jTable = function(options){
		return this.each(function(){
		 	var $table = $(this), nowrapTD = $table.attr("nowrapTD");
		 	var tlength = $table.width() -(10-2);//edited by Sean on 20160505 minus margin's width and border's width for the "list" style defining in css file
		 	if(!$table.is(":visible")){
		 		tlength = $table.parent().width();
		 	}
		 	
		 	var aStyles = [];
			/*var $tc = $table.parent().addClass("j-resizeGrid"); // table parent container
*/			var $tc = $table.wrap("<div class='j-resizeGrid'></div>"); // table parent container
			var $tcW = $tc.width();
			var $tcInnerW = $tc.innerWidth();
			var $tcPaddingW = $tcInnerW - $tcW;
			
			var field = $table.attr("orderField");
			var direction = $table.attr("orderDirection");
			//edited by Sean on 20160505 minus margin's width 10 for the "list" style defining in css file
			$tcW = $tcW - $tcPaddingW -10;
			var layoutH = $(this).attr("layoutH");

			var oldThs = $table.find("thead>tr:last-child").find("th");

			for(var i = 0, l = oldThs.size(); i < l; i++) {
				var $th = $(oldThs[i]);
				var style = [], width = Math.abs($th.innerWidth() - (100 * $th.innerWidth() / tlength)-2);
				style[0] = parseInt(width);
				style[1] = $th.attr("align");
				aStyles[aStyles.length] = style;
			}
		
			//edited by Sean on 20160505 fixed the width
			$(this).wrap("<div class='grid' style='width:100%'></div>");
			var $grid = $table.parent().html($table.html());
			var thead = $grid.find("thead");
			thead.wrap("<div class='gridHeader hidden-xs'><div class='gridThead'><table style='width:100%'></table></div></div>");

			var lastH = $(">tr:last-child", thead);
			var ths = $(">th", lastH);
			$("th",thead).each(function(){
				var $th = $(this);
				$th.html("<div class='gridCol' title='"+$th.text()+"'>"+ $th.html() +"</div>");	
			});
			
			var cls = {};
			if(field && direction){
				var fieldArray = field.split(",");
				var directionArray = direction.split(",");
				if(fieldArray != null && fieldArray.length>0){
					for(var i=0;i<fieldArray.length;i++){
						if(directionArray.length>i){
							cls[fieldArray[i]] = directionArray[i];
						}
					}
				}
			}
			ths.each(function(i){
				var $th = $(this), style = aStyles[i];
				$th.addClass(style[1]).hoverClass("hover").removeAttr("align").removeAttr("width").width(style[0]);
				var orderField = $th.attr("orderField");
				if(orderField && cls[orderField]){
					$th.addClass(cls[orderField]);
				}
			}).filter("[orderField]").orderBy({
				targetType: $table.attr("targetType"),
				rel:$table.attr("rel"),
				asc: $table.attr("asc") || "asc",
				desc:  $table.attr("desc") || "desc"
			});
			//layoutStr主要是判断tbody是否有滚动条
			if(layoutStr){
				$(".gridThead",$tc).css("padding-right","17px");
			}
			
			var tbody = $grid.find(">tbody");
			var layoutStr = layoutH ? " layoutH='" + layoutH + "'" : "";
			
			tbody.wrap("<div class='gridScroller'" + layoutStr + " style='width:100%;height:100%;'><div class='gridTbody'><table style='width:100%'></table></div></div>");
			
			var $trs = tbody.find('>tr');
			
			$trs.hoverClass().each(function(){
				var $tr = $(this);
				var $ftds = $(">td", this);

				for (var i=0; i < $ftds.size(); i++) {
					var $ftd = $($ftds[i]);
					var hoverTitle = $ftd.text().replace(/\s*/g,"")
					if($ftd.find('select').size()){
						hoverTitle = "";
					}
					if (nowrapTD != "false") $ftd.html("<div title='"+hoverTitle+"'>" + $ftd.html() + "</div>");
					if (i < aStyles.length) $ftd.addClass(aStyles[i][1]);
				}		
				$tr.click(function(){
					$trs.filter(".selected").removeClass("selected");
					$tr.addClass("selected");
					var sTarget = $tr.attr("target");
					if (sTarget) {
						if ($("#"+sTarget, $grid).size() == 0) {
							$grid.prepend('<input id="'+sTarget+'" type="hidden" />');
						}
						$("#"+sTarget, $grid).val($tr.attr("rel"));
					}
				});
			});
			tbody = tbody.before(thead.clone()).prev();
			tbody.find(".gridCol").addClass("visible-xs");
			var ftr = $(">tr:first-child", tbody);
			
			//兼容ie9数据量较大，table样式错乱问题
			if ($.browser.msie && $.browser.version === '9.0')
			{
				tbody.next().html(function(i, el) {
				      return el.replace(/>\s*</g, '><');
				   });
			}
			/*$(">th",ftr).each(function(i){
				if (i < aStyles.length) $(this).width(aStyles[i][0]);
				
				//当gridBody中又empty的空元素的时候设置这个单元格的宽度等于gridThead > table中的，6是table > gridThead中左右padding
				if($(">th",ftr).first().hasClass("empty")){
				  $(">thd",ftr).width($grid.find(".gridThead > table").width() - 6); 
				}
			});	*/		
			$grid.append("<div class='resizeMarker' style='height:300px; left:57px;display:none;'></div><div class='resizeProxy' style='height:300px; left:377px;display:none;'></div>");
	
			var scroller = $(".gridScroller", $grid);
			scroller.scroll(function(event){
				var header = $(".gridThead", $grid);
				if(scroller.scrollLeft() > 0){
					header.css("position", "relative");
					var scroll = scroller.scrollLeft();
					header.css("left", scroller.cssv("left") - scroll);
				}
				if(scroller.scrollLeft() == 0) {
					header.css("position", "relative");
					header.css("left", "0px");
				}
		        return false;
			});		
			
			
		
			
			$(">tr", thead).each(function(){

				$(">th", this).each(function(i){
					var th = this, $th = $(this);
					$th.mouseover(function(event){
						var offset = $.jTableTool.getOffset(th, event).offsetX;
						if($th.outerWidth() - offset < 5) {
							$th.css("cursor", "col-resize").mousedown(function(event){
								$(".resizeProxy", $grid).show().css({
									left: $.jTableTool.getRight(th)- $(".gridScroller", $grid).scrollLeft() ,
									top:$.jTableTool.getTop(th),
									height:$.jTableTool.getHeight(th,$grid),
									cursor:"col-resize"
								});
								$(".resizeMarker", $grid).show().css({
										left: $.jTableTool.getLeft(th) + 1 - $(".gridScroller", $grid).scrollLeft(),
										top: $.jTableTool.getTop(th),
										height:$.jTableTool.getHeight(th,$grid)									
								});
								$(".resizeProxy", $grid).jDrag($.extend(options, {scop:true, cellMinW:20, relObj:$(".resizeMarker", $grid)[0],
										move: "horizontal",
										event:event,
										stop: function(){
											var pleft = $(".resizeProxy", $grid).position().left;
											var mleft = $(".resizeMarker", $grid).position().left;
											var move = pleft - mleft - $th.outerWidth() ;

											var cols = $.jTableTool.getColspan($th);
											var cellNum = $.jTableTool.getCellNum($th);
											var oldW = $th.width(), newW = $th.width() + move;
											var $dcell = $(">th", ftr).eq(cellNum - 1);
											if(newW < 10){
												newW = 10;
											}
											$th.width(newW + "px");
											$dcell.width((newW + 7) +"px");
											
											//当gridBody中又empty的空元素的时候设置这个单元格的宽度等于gridThead > table中的，6是table > gridThead中左右padding
											/*if($(">th",ftr).first().hasClass("empty")){
											  $(">th",ftr).width($grid.find(".gridThead > table").width() - 6); 
											}*/
											/*var $table1 = $(thead).parent();
											$table1.width(($table1.width() - oldW + newW)+"px");
											var $table2 = $(tbody).parent();
											$table2.width(($table2.width() - oldW + newW)+"px");*/
											
											$(".resizeMarker,.resizeProxy", $grid).hide();
										}
									})
								);
							});
						} else {
							$th.css("cursor", $th.attr("orderField") ? "pointer" : "default");
							$th.unbind("mousedown");
						}
						return false;
					});
				});
			});
			
		
			function _resizeGrid(){
				$grid.each(function(){
					var  gridW = $(this).find(".gridScroller").height();
					var  gridTableW = $(this).find(".gridScroller").find("table").height();
				if(gridW < gridTableW){
					$(this).find(".gridThead").css("padding-right","17px");
				}else{
					$(this).find(".gridThead").css("padding-right","0");
				}
			  })
			}
			$(window).unbind(DWZ.eventType.resizeGrid).bind("resizeGrid", _resizeGrid);
		});
	};
	

	
	$.jTableTool = {
		getLeft:function(obj) {
			var width = 0;
			$(obj).prevAll().each(function(){
				width += $(this).outerWidth();
			});
			return width - 1;
		},
		getRight:function(obj) {
			var width = 0;
			$(obj).prevAll().andSelf().each(function(){
				width += $(this).outerWidth();
			});
			return width - 1;
		},
		getTop:function(obj) {
			var height = 0;
			$(obj).parent().prevAll().each(function(){
				height += $(this).outerHeight();
			});
			return height;
		},
		getHeight:function(obj, parent) {
			var height = 0;
			var head = $(obj).parent();
			head.nextAll().andSelf().each(function(){
				height += $(this).outerHeight();
			});
			$(".gridTbody", parent).children().each(function(){
				height += $(this).outerHeight();
			});
			return height;
		},
		getCellNum:function(obj) {
			return $(obj).prevAll().andSelf().size();
		},
		getColspan:function(obj) {
			return $(obj).attr("colspan") || 1;
		},
		getStart:function(obj) {
			var start = 1;
			$(obj).prevAll().each(function(){
				start += parseInt($(this).attr("colspan") || 1);
			});
			return start;
		},
		getPageCoord:function(element){
			var coord = {x: 0, y: 0};
			while (element){
			    coord.x += element.offsetLeft;
			    coord.y += element.offsetTop;
			    element = element.offsetParent;
			}
			return coord;
		},
		getOffset:function(obj, evt){
			if(/msie/.test(navigator.userAgent.toLowerCase())) {
				var objset = $(obj).offset();
				var evtset = {
					offsetX:evt.pageX || evt.screenX,
					offsetY:evt.pageY || evt.screenY
				};
				var offset ={
			    	offsetX: evtset.offsetX - objset.left,
			    	offsetY: evtset.offsetY - objset.top
				};
				return offset;
			}
			var target = evt.target;
			if (target.offsetLeft == undefined){
			    target = target.parentNode;
			}
			var pageCoord = $.jTableTool.getPageCoord(target);
			var eventCoord ={
			    x: window.pageXOffset + evt.clientX,
			    y: window.pageYOffset + evt.clientY
			};
			var offset ={
			    offsetX: eventCoord.x - pageCoord.x,
			    offsetY: eventCoord.y - pageCoord.y
			};
			return offset;
		}
	};
})(jQuery);

