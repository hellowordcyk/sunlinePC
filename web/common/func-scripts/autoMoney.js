$.fn.extend({
	
	/**
	 * get the number of autoNumeric plugin init dom
	 * return a javascript number object
	 */
	getNumber:function() {
		if($.fn.autoNumeric){
			return $(this).autoNumeric("get");
		}else{
			 throw new Error("haven't import the plugin,autoNumeric.min.js!");
		}
	},
	/**
	 * set and format number
	 * @param value
	 * @returns
	 */
	setNumberAndFormat:function(value) {
		if($.fn.autoNumeric){
			var scale = parseInt($(this).attr("scale")) || 2;
			if(scale > 6) scale = 6;
			$(this).autoNumeric('init',{
				mDec:scale, //默认小数位数
				vMax:"99999999999999999999999999999999.999999",
				vMin:"-99999999999999999999999999999999.999999",
				unSetOnSubmit:true
			});
			
			return $(this).autoNumeric('set', value);
		}else{
			 throw new Error("haven't import the plugin,autoNumeric.min.js!");
		}
	}
	
});