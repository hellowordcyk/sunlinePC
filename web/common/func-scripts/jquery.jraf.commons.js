/*
 * Jraf Platform Commons JavaScript Based On jQuery.js and DWZ.js
 * 	
 * Copyright (c) 2004-2015 Sunline Technologies,Ltd
 * All right reserved
 *
 * Version: 1.0.0
 * Author: TonyFang
 * Description: 基于jQuery和DWZ JUI针对Jraf平台的一些常用方法进行封装
 * 
 */
/**
 * 对jQuery进行扩展
 */
(function($) {
	/**
	 * 扩展String字符串
	 */
	$.extend(String.prototype, {
		// 是否空白字符串，也可使用jui的isSpaces
		isBlank : function() {
			return /^\s*$/.test(this);
		},
		// 判断字符串中是否包含某段字符
		include : function(pattern) {
			return this.indexOf(pattern) > -1;
		}
	});
})(jQuery);


/**
 * 公共操作对象
 */
var CommonUtils = {
	/**
	 * 获取块下的所有input select textarea等与后端交互数据的元素
	 * @param obj
	 * @returns
	 */	
	__findElementsInBlock : function(obj){
		var $obj = $(obj);
		if (!$obj) {
			alertMsg.error('[jraf.commons.CommonUtils][method=__findElementsInBlock]传入参数无效！');
			return;
		}
		// 所有元素
		var _elements;
		// 判断当前的对象是否表单
		//if ($obj.is('form')) {
		//	_elements = $($obj[0].elements);
		//} else {
			// 查找后代中所有的input/select/textarea节点
		_elements = $obj.find('input,select,textarea');
		//}
		return _elements;
	},
	/**
	 * 初始化隐藏的输入框
	 * @param obj 目标对象，查询该目标下的输入框以及在该对象下新增隐藏输入框
	 * @param name
	 * @param value
	 */
	__initHiddenInput : function(obj, name, value){
		// 判断是否存在oldName
		var oldName = "__old__" + name;
		var _oldInput = $(obj).find('input:hidden[name="' + oldName + '"]',obj);
		// 不存在则新增
		if ($(_oldInput).size()==0) {
			$(obj).append('<input type="hidden" name="' + oldName + '" value="' + value + '"/>');
		}
	},
	/**
	 * 初始化块记录旧值，并把旧值存入到对象中
	 * @param obj
	 */
	initOldValue : function(obj) {
		// 找到块中存在的所有与__old__相关的元素，并清除
		$(obj).find('input[name^="__old__"]').remove();
		var _elements = this.__findElementsInBlock(obj);
		// 遍历所有元素，并将其初始值存入隐含的input中
		$(_elements).each(function() {
			var ele = $(this);
			// 排除掉hidden/button/image以及被禁用掉元素
			if (ele.is('input:button') 
					|| ele.is('input:image') || ele.prop('disabled'))
				return true;
			CommonUtils.setOldValue2HiddenInput(obj, ele);
		});
	},
	/**
	 * 为每个元素绑定点击事件，当点击该元素时，将值绑定到隐藏input中
	 * @param obj
	 * 
	 */
	initRecordOldValue : function(obj) {
		// 找到块中存在的所有与__old__相关的元素，并清除
		$(obj).remove('input[name^="__old__"]');
		var _elements = this.__findElementsInBlock(obj);
		// 遍历所有元素
		$(_elements).each(function() {
			var ele = $(this);
			// 排除掉hidden/button/image
			if (ele.is('input:hidden') || ele.is('input:button') 
					|| ele.is('input:image'))
				return true;
			// 为每个元素绑定点击事件
			ele.live('click', function() {
				CommonUtils.setOldValue2HiddenInput(obj, ele);
			});
		});
	},
	/**
	 * 设置旧值到隐藏输入框
	 * @param obj
	 * @param ele
	 */
	setOldValue2HiddenInput : function(obj, ele) {
		var _name = $(ele).attr('name');
		if(typeof(_name)=="undefined")
			return;
		var _value = '';
		if($(ele).is('input:checkbox')){
			var vArr = new Array();
			$('input[name="' + _name + '"]:checked',obj).each(function(){
				vArr.push($(this).val());
			});
			_value = vArr.toString();
		} else if($(ele).is('input:radio')){ 
			_value = $('input[name="' + _name + '"]:checked',obj).val();
		} else if ($(ele).is('textarea')) {
			_value = $(ele).text();
		} else if($(ele).is('select')){
			_value = $('select[name="' + _name + '"]',obj).val();
		}else{
			_value = $('input[name="' + _name + '"]',obj).val();
		}
		this.__initHiddenInput(obj, _name, _value);
	},
	/**
	 * 是否数据修改，基于普通标签，但需配合initOldValue标签使用
	 * @param obj
	 * @returns {Boolean}
	 */
	isInputChanged : function(obj){
		var _elements = this.__findElementsInBlock(obj);
		var flag = false;
		// 遍历所有元素
		$(_elements).each(function() {
			var ele = $(this);
			// 不存在或禁用，跳过
			if (ele.size()==0 || ele.prop('disabled'))
				return true;
			var name = ele.attr('name');
			// 获取存放旧值的控件对象
			var oldObj = $(obj).find('input[name="__old__'+ name +'"]');
			// 无旧值
			if($(oldObj).size()==0)
				return true;
			var __oldValue = oldObj.val();
			if (ele.is('input:radio') || ele.is('input:checkbox')) { // 获取其选中值
				if(ele.prop("checked") && ele.val() !== __oldValue){
					flag = true;
					return false;
				}
			} else if (ele.is('textarea')) {
				if(ele.val() !== __oldValue){
					flag = true;
					return false;
				}
			} else {
				if(ele.val() !== __oldValue){
					flag = true;
					return false;
				}
			}
		});
		return flag;
	},
	/**
	 * 是否数据修改，需配合h标签使用
	 * @param obj
	 * @returns {Boolean}
	 */
	isInputChangedWithTag : function(obj){
		var _elements = this.__findElementsInBlock(obj);
		var flag = false;
		// 遍历所有元素
		$(_elements).each(function() {
			var ele = $(this);
			var __oldValue = ele.attr('__oldValue');
			// 不存在或禁用或无旧值，跳过
			if (ele.size()==0 || ele.prop('disabled') || !__oldValue)
				return true;
			if (ele.is('input:radio') || ele.is('input:checkbox')) { // 获取其选中值
				if(ele.prop("checked") && ele.val() !== __oldValue){
					flag = true;
					return false;
				}
			} else if (ele.is('textarea')) {
				if(ele.text() !== __oldValue){
					flag = true;
					return false;
				}
			} else {
				if(ele.val() !== __oldValue){
					flag = true;
					return false;
				}
			}
		});
		return flag;
	},
	/**
	 * 从属性中取出旧值，配合h标签使用
	 * @param obj
	 */
	extractOldValueInAttr : function(obj){
		var _elements = this.__findElementsInBlock(obj);
		// 遍历所有元素并设置一个hidden值
		$(_elements).each(function() {
			var ele = $(this);
			var name = ele.attr('name');
			var value = ele.attr('__oldValue');
			// 存在旧值即存放都hidden标签
			if(typeof(value)=="undefined")
				return true;				
			// 判断是否存在oldName
			var oldName = "__old__" + name;
			var _oldInput = $(obj).find('input:hidden[name="' + oldName + '"]');
			// 不存在则新增
			if ($(_oldInput).size()==0) {
				$(obj).append('<input type="hidden" name="' + oldName + '" value="' + value + '"/>');
			}
		});
	},
	/**
	 * 刷新旧值
	 * @param obj
	 */
	refreshOldValueWithTag : function(obj){
		var _elements = this.__findElementsInBlock(obj);
		// 遍历所有元素
		$(_elements).each(function() {
			var ele = $(this);
			// 不存在或禁用，跳过
			if (ele.size()==0 || ele.prop('disabled') || ele.is("input:hidden"))
				return true;
			ele.attr("__oldValue",ele.val());
		});
	}
};


/**
 * 判断是否修改数据并校验回调，基于H标签
 */
function validateCallbackWithTag(form, callback, confirmMsg) {
	var $form = $(form);
	// 判断是否为form，如果不是form直接返回false
	if (!$form.is("form"))
		return false;
	// 遍历表单下的所有控件，判断其value和__oldValue是否一致，
	if (!CommonUtils.isInputChangedWithTag(form)) {
		alertMsg.info("未修改任何数据！");
		return false;
	}
	// 取出__oldVaule值并传入后台
	CommonUtils.extractOldValueInAttr(form);
	return validateCallback(form, function(json){
		CommonUtils.refreshOldValueWithTag(form);
		if($.isFunction(callback)){
			callback(json);
		}
	}, confirmMsg);
}

/**
 * 判断是否修改数据并校验回调，基于普通标签
 */
function $validateCallback (form, callback, confirmMsg) {
	var $form = $(form);
	// 判断是否为form，如果不是form直接返回false
	if (!$form.is("form"))
		return false;
	// 判断值是否修改
	if (!CommonUtils.isInputChanged(form)) {
		alertMsg.info("未修改任何数据！");
		return false;
	}
	return validateCallback(form, function(json){
		CommonUtils.initOldValue(form);
		if($.isFunction(callback)){
			callback(json);
		}
	}, confirmMsg);
}

/**
 * @param nextField String 下一个输入空间名称
 * @param index number 获取到符合规则的多个时，指定聚焦到第几个
 * @description : 如果指出了下一个控件的名称或者序号参数，当按下回车键的时候，会将焦点指向指定位置，
 * 在自定义标签中使用时，如下:
 * <sc:tagName next="nextField" index="index" /> 或者 just <sc:tagName next="nextField" />
 */
function nextInput(nextField, indexNum) {
	var focusObj = document.getElementsByName(nextField);
	for ( var i = 0; i < focusObj.length; i++) {
		if ((focusObj[i].type != "hidden") && (!focusObj[i].disabled)) {
			if ((indexNum != null) && (indexNum != "")
					&& (parseInt(indexNum) < focusObj.length)) {
				focusObj[indexNum].focus();
			} else {
				focusObj[i].focus();
			}
		}
	}
}
