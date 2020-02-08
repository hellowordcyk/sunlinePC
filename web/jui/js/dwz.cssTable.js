/**
 * Theme Plugins
 * @author 张慧华 z@j-ui.com
 */
(function($){
	$.fn.extend({
		cssTable: function(options){

			return this.each(function(){
				var $this = $(this);
				var $trs = $this.find('tbody>tr');
				var $grid = $this.parent(); // table
				var nowrap = $this.hasClass("nowrap");
				
				var field = $this.attr("orderField");
				var direction = $this.attr("orderDirection");
				
				$trs.hoverClass("hover").each(function(index){
					var $tr = $(this);
					if (!nowrap && index % 2 == 1) $tr.addClass("trbg");
					
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
				$this.find("thead [orderField]").each(function(){
					var $th = $(this);
					var orderField = $th.attr("orderField");
					if(orderField && cls[orderField]){
						$th.addClass(cls[orderField]);
					}
				}).orderBy({
					targetType: $this.attr("targetType"),
					rel:$this.attr("rel"),
					asc: $this.attr("asc") || "asc",
					desc:  $this.attr("desc") || "desc"
				});
				//兼容ie9数据量较大，table样式错乱问题
				if ($.browser.msie && $.browser.version === '9.0')
				{
					$this.html(function(i, el) {
					      return el.replace(/>\s*</g, '><');
					   });
				}
			});
		}
	});
})(jQuery);
