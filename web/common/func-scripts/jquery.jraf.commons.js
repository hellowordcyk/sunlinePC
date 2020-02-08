/*
 * Jraf Platform Commons JavaScript Based On jQuery.js and DWZ.js
 * 	
 * Copyright (c) 2004-2015 Sunline Technologies,Ltd
 * All right reserved
 *
 * Version: 1.0.0
 * Author: TonyFang
 * Description: ����jQuery��DWZ JUI���Jrafƽ̨��һЩ���÷������з�װ
 * 
 */
/**
 * ��jQuery������չ
 */
(function($) {
	/**
	 * ��չString�ַ���
	 */
	$.extend(String.prototype, {
		// �Ƿ�հ��ַ�����Ҳ��ʹ��jui��isSpaces
		isBlank : function() {
			return /^\s*$/.test(this);
		},
		// �ж��ַ������Ƿ����ĳ���ַ�
		include : function(pattern) {
			return this.indexOf(pattern) > -1;
		}
	});
})(jQuery);


/**
 * ������������
 */
var CommonUtils = {
	/**
	 * ��ȡ���µ�����input select textarea�����˽������ݵ�Ԫ��
	 * @param obj
	 * @returns
	 */	
	__findElementsInBlock : function(obj){
		var $obj = $(obj);
		if (!$obj) {
			alertMsg.error('[jraf.commons.CommonUtils][method=__findElementsInBlock]���������Ч��');
			return;
		}
		// ����Ԫ��
		var _elements;
		// �жϵ�ǰ�Ķ����Ƿ��
		//if ($obj.is('form')) {
		//	_elements = $($obj[0].elements);
		//} else {
			// ���Һ�������е�input/select/textarea�ڵ�
		_elements = $obj.find('input,select,textarea');
		//}
		return _elements;
	},
	/**
	 * ��ʼ�����ص������
	 * @param obj Ŀ����󣬲�ѯ��Ŀ���µ�������Լ��ڸö������������������
	 * @param name
	 * @param value
	 */
	__initHiddenInput : function(obj, name, value){
		// �ж��Ƿ����oldName
		var oldName = "__old__" + name;
		var _oldInput = $(obj).find('input:hidden[name="' + oldName + '"]',obj);
		// ������������
		if ($(_oldInput).size()==0) {
			$(obj).append('<input type="hidden" name="' + oldName + '" value="' + value + '"/>');
		}
	},
	/**
	 * ��ʼ�����¼��ֵ�����Ѿ�ֵ���뵽������
	 * @param obj
	 */
	initOldValue : function(obj) {
		// �ҵ����д��ڵ�������__old__��ص�Ԫ�أ������
		$(obj).find('input[name^="__old__"]').remove();
		var _elements = this.__findElementsInBlock(obj);
		// ��������Ԫ�أ��������ʼֵ����������input��
		$(_elements).each(function() {
			var ele = $(this);
			// �ų���hidden/button/image�Լ������õ�Ԫ��
			if (ele.is('input:button') 
					|| ele.is('input:image') || ele.prop('disabled'))
				return true;
			CommonUtils.setOldValue2HiddenInput(obj, ele);
		});
	},
	/**
	 * Ϊÿ��Ԫ�ذ󶨵���¼����������Ԫ��ʱ����ֵ�󶨵�����input��
	 * @param obj
	 * 
	 */
	initRecordOldValue : function(obj) {
		// �ҵ����д��ڵ�������__old__��ص�Ԫ�أ������
		$(obj).remove('input[name^="__old__"]');
		var _elements = this.__findElementsInBlock(obj);
		// ��������Ԫ��
		$(_elements).each(function() {
			var ele = $(this);
			// �ų���hidden/button/image
			if (ele.is('input:hidden') || ele.is('input:button') 
					|| ele.is('input:image'))
				return true;
			// Ϊÿ��Ԫ�ذ󶨵���¼�
			ele.live('click', function() {
				CommonUtils.setOldValue2HiddenInput(obj, ele);
			});
		});
	},
	/**
	 * ���þ�ֵ�����������
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
	 * �Ƿ������޸ģ�������ͨ��ǩ���������initOldValue��ǩʹ��
	 * @param obj
	 * @returns {Boolean}
	 */
	isInputChanged : function(obj){
		var _elements = this.__findElementsInBlock(obj);
		var flag = false;
		// ��������Ԫ��
		$(_elements).each(function() {
			var ele = $(this);
			// �����ڻ���ã�����
			if (ele.size()==0 || ele.prop('disabled'))
				return true;
			var name = ele.attr('name');
			// ��ȡ��ž�ֵ�Ŀؼ�����
			var oldObj = $(obj).find('input[name="__old__'+ name +'"]');
			// �޾�ֵ
			if($(oldObj).size()==0)
				return true;
			var __oldValue = oldObj.val();
			if (ele.is('input:radio') || ele.is('input:checkbox')) { // ��ȡ��ѡ��ֵ
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
	 * �Ƿ������޸ģ������h��ǩʹ��
	 * @param obj
	 * @returns {Boolean}
	 */
	isInputChangedWithTag : function(obj){
		var _elements = this.__findElementsInBlock(obj);
		var flag = false;
		// ��������Ԫ��
		$(_elements).each(function() {
			var ele = $(this);
			var __oldValue = ele.attr('__oldValue');
			// �����ڻ���û��޾�ֵ������
			if (ele.size()==0 || ele.prop('disabled') || !__oldValue)
				return true;
			if (ele.is('input:radio') || ele.is('input:checkbox')) { // ��ȡ��ѡ��ֵ
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
	 * ��������ȡ����ֵ�����h��ǩʹ��
	 * @param obj
	 */
	extractOldValueInAttr : function(obj){
		var _elements = this.__findElementsInBlock(obj);
		// ��������Ԫ�ز�����һ��hiddenֵ
		$(_elements).each(function() {
			var ele = $(this);
			var name = ele.attr('name');
			var value = ele.attr('__oldValue');
			// ���ھ�ֵ����Ŷ�hidden��ǩ
			if(typeof(value)=="undefined")
				return true;				
			// �ж��Ƿ����oldName
			var oldName = "__old__" + name;
			var _oldInput = $(obj).find('input:hidden[name="' + oldName + '"]');
			// ������������
			if ($(_oldInput).size()==0) {
				$(obj).append('<input type="hidden" name="' + oldName + '" value="' + value + '"/>');
			}
		});
	},
	/**
	 * ˢ�¾�ֵ
	 * @param obj
	 */
	refreshOldValueWithTag : function(obj){
		var _elements = this.__findElementsInBlock(obj);
		// ��������Ԫ��
		$(_elements).each(function() {
			var ele = $(this);
			// �����ڻ���ã�����
			if (ele.size()==0 || ele.prop('disabled') || ele.is("input:hidden"))
				return true;
			ele.attr("__oldValue",ele.val());
		});
	}
};


/**
 * �ж��Ƿ��޸����ݲ�У��ص�������H��ǩ
 */
function validateCallbackWithTag(form, callback, confirmMsg) {
	var $form = $(form);
	// �ж��Ƿ�Ϊform���������formֱ�ӷ���false
	if (!$form.is("form"))
		return false;
	// �������µ����пؼ����ж���value��__oldValue�Ƿ�һ�£�
	if (!CommonUtils.isInputChangedWithTag(form)) {
		alertMsg.info("δ�޸��κ����ݣ�");
		return false;
	}
	// ȡ��__oldVauleֵ�������̨
	CommonUtils.extractOldValueInAttr(form);
	return validateCallback(form, function(json){
		CommonUtils.refreshOldValueWithTag(form);
		if($.isFunction(callback)){
			callback(json);
		}
	}, confirmMsg);
}

/**
 * �ж��Ƿ��޸����ݲ�У��ص���������ͨ��ǩ
 */
function $validateCallback (form, callback, confirmMsg) {
	var $form = $(form);
	// �ж��Ƿ�Ϊform���������formֱ�ӷ���false
	if (!$form.is("form"))
		return false;
	// �ж�ֵ�Ƿ��޸�
	if (!CommonUtils.isInputChanged(form)) {
		alertMsg.info("δ�޸��κ����ݣ�");
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
 * @param nextField String ��һ������ռ�����
 * @param index number ��ȡ�����Ϲ���Ķ��ʱ��ָ���۽����ڼ���
 * @description : ���ָ������һ���ؼ������ƻ�����Ų����������»س�����ʱ�򣬻Ὣ����ָ��ָ��λ�ã�
 * ���Զ����ǩ��ʹ��ʱ������:
 * <sc:tagName next="nextField" index="index" /> ���� just <sc:tagName next="nextField" />
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
