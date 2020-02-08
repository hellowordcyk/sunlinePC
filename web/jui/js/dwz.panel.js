/**
 * @author Roger Wu
 * @version 1.0
 * log:
 * 2016-12-29 Sean:
 *     * 修改自适应方法，如果未设置defH,则根据panel内容自适应
 *     * 增加“maxH”属性
 */
(function($){
	$.extend($.fn, {
		/**
		 * <div class="panel [colse|collapse]" defH="" minH="" >
		 */
		jPanel:function(options){
			var op = $.extend({header:"panelHeader", headerC:"panelHeaderContent", content:"panelContent", coll:"collapsable", exp:"expandable", footer:"panelFooter", footerC:"panelFooterContent"}, options);
			return this.each(function(){
				var $panel = $(this);
				var close = $panel.hasClass("close");
				var collapse = $panel.hasClass("collapse");
				
				var $content = $(">div", $panel).addClass(op.content);				
				var title = $(">h1",$panel).wrap('<div class="'+op.header+'"><div class="'+op.headerC+'"></div></div>');
				var aClass = close?op.exp:op.coll;
				if(collapse)$("<a href=\"\"></a>").addClass(aClass).insertAfter(title);

				var header = $(">div:first", $panel);
				var footer = $('<div class="'+op.footer+'"><div class="'+op.footerC+'"></div></div>').appendTo($panel);
				
				var defaultH = $panel.attr("defH")?$panel.attr("defH"):0;
				var minH = $panel.attr("minH")?$panel.attr("minH"):0;
				//added by Sean on 20161229 add in the maxH property to control the max height of a container 
				var maxH = $panel.attr("maxH")?$panel.attr("maxH"):0;
				if (close) 
					$content.css({
						height: "0px",
						display: "none"
					});
				else {
					if (defaultH > 0) 
						$content.height(defaultH + "px");
					else if(minH > 0) {
						$content.css("minHeight", minH+"px");
					} else if (maxH > 0) {
						$content.css("maxHeight", maxH+"px");
					}
				}
				if(!collapse) return;
				//var $pucker = $("a", header);
				var $pucker = $("a."+aClass, header);//modified by Sean on 20170111
				
				//modified by Sean on 20161229 auto-fit the height of panel, compute the height in the function of the click event 
				/*var inH = $content.innerHeight() - 6;
				if(minH > 0 && minH >= inH) defaultH = minH;
				else defaultH = inH;*/
				$pucker.click(function(){
					var inH = $content.innerHeight() - 6;
					if($pucker.hasClass(op.exp)){
						if(minH > 0 && minH >= inH) 
							defaultH = minH;
						else if (maxH > 0 && maxH <= inH) 
							defaultH = maxH;
						else 
							defaultH = inH;
						$content.jBlindDown({to:defaultH,call:function(){
							$pucker.removeClass(op.exp).addClass(op.coll);
							if(minH > 0) $content.css("minHeight",minH+"px");
							if(maxH > 0) $content.css("maxHeight",maxH+"px");
						}});
					} else { 
						if(minH > 0) $content.css("minHeight","");
						if(maxH > 0) $content.css("maxHeight","");
						if(minH >= inH) 
							$content.css("height", minH+"px");
						else if (maxH > 0 && maxH <= inH) 
							$content.css("height", maxH+"px");
							
						$content.jBlindUp({call:function(){
							$pucker.removeClass(op.coll).addClass(op.exp);
						}});
					}
					return false;
				});
			});
		}
	});
})(jQuery);     
