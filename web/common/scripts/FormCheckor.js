FormCheckor = {version:"1.0"};

FormCheckor.ValidationRule=Class.create({
	initialize: function(className,test,options) {
		var e = Prototype.emptyFunction;
		this.ie = Prototype.Browser.IE;
		this.className = className;
		this._test = test ? test : function(v,elm,args){ return true };
		
		this.options = Object.extend({}, options || {});		
  },
	test : function(v, elm,args) {
		return this._test(v,elm,args);
	}
});

//Helper
FormCheckor.Helper={
	isEmpty:function(str){
	return str==null||str.length==0;
	},
	
	twoDepthArrayToErrorObject:function(array){
		var obj={};
		array.each(function(smallAry){
			obj[smallAry[0]] = smallAry[1];
		});
		return obj;
	},
	
	twoDepthArrayToRuleObject:function(array){
		var obj={};
		array.each(function(smallAry){
			obj[smallAry[0]] = new FormCheckor.ValidationRule(smallAry[0],smallAry[1],smallAry[2]?smallAry[2]:{});
		});
		return obj;
	},
	
	getArgumentFromClassName : function(prefix,className) {
		if(!className || !prefix){	return [];}
		var pattern = new RegExp(prefix+'-(\\S+)');
		var matchs = className.match(pattern);
		if(!matchs){return []};
		var results = [];
		var args =  matchs[1].split('-');
		for(var i = 0; i < args.length; i++) {
			if(args[i] == '') {
				if(i+1 < args.length) args[i+1] = '-'+args[i+1];
			}else{
				results.push(args[i]);
			}
		}		
		return results;
	},
	
	putArgumentToError:function(error,args) {
		args = args || [];
		FormCheckor.Helper.assert(args.constructor == Array,"Validator.format() arguement 'args' must is Array");
		var result = error;
		for (var i = 0; i < args.length; i++){
			result = result.replace(/%s/, args[i]);	
		}
		return result;
	},
	
	assert:function(condition,message) {
		var errorMessage = message || ("assert failed error,condition="+condition);
		if (!condition) {
			alert(errorMessage);
			throw new Error(errorMessage);
		}else {
			return condition;
		}
	},
	
	isVisible : function(elm) {
		if(!elm||!elm.tagName){
		  alert("not find this element please check the id in your element's class easyvalidation arguments about compare bewteen elements");
		  return false;
		}
		while(elm.tagName != 'BODY') {
			if(!$(elm).visible()) return false;
			elm = elm.parentNode;
		}
		return true;
	},
	
	genAdviceId: function(className, elm) {
		return Try.these(
			function(){ return 'advice-' + className + '-' + (elm.id ? elm.id : elm.name) },
			function(){ return 'advice-' + (elm.id ? elm.id : elm.name) }
		);
	},
	
	getAdvice : function(className, elm) {
		return $(FormCheckor.Helper.genAdviceId(className, elm));
	},
	
	getElmID : function(elm) {
		return elm.id ? elm.id : elm.name;
	},
	
	_getInputValue : function(elmIn) {		
		var elm = $(elmIn);
		if(!$(elmIn)){
			alert("error:no element for your equal compare!" + elmIn );
			return false;
		}
		var tagN = elm.tagName.toLowerCase();
		var type=elm.type.toLowerCase();
		if(tagN=='input'){
			if(type == 'file') {
				return elm.value;
			}
			if(type == 'radio'||type == 'checkbox') {
				return type;
			}			
			return $F(elm);		
		}
		if(tagN=='select'){
			return type;
		}
		return $F(elm);	
	}		
};

//Testor
FormCheckor.Testor={
	isEmpty:function(str){
		return FormCheckor.Helper.isEmpty(str);
	},

	isNumber:function(v) {
				return  (!isNaN(v) && !/^\s+$/.test(v));
			},

	isDigits:function(v) {
				return   !/[^\d]/.test(v);
			},

	isAlpha:function(v) {
				return   /^[a-zA-Z]+$/.test(v)
			},

	isAlphaNumber:function(v) {
				return   !/\W/.test(v)
			},

	isDate:function (v) {
				var test = new Date(v);
				return  !isNaN(test);
			},


	isEmail:function (v) {
				return  /\w{1,}[@][\w\-]{1,}([.]([\w\-]{1,})){1,3}$/.test(v)
			},
	isUrl:function(v) {
				return  /^(http|https|ftp):\/\/(([A-Z0-9][A-Z0-9_-]*)(\.[A-Z0-9][A-Z0-9_-]*)+)(:(\d+))?\/?/i.test(v)
			},

	isDateAu:function(v) {
				var regex = /^(\d{2})\/(\d{2})\/(\d{4})$/;
				if(!regex.test(v)) return false;
				var d = new Date(v.replace(regex, '$2/$1/$3'));
				return ( parseInt(RegExp.$2, 10) == (1+d.getMonth()) ) && 
							(parseInt(RegExp.$1, 10) == d.getDate()) && 
							(parseInt(RegExp.$3, 10) == d.getFullYear() );
			},

	isCurrencyDollar:function(v) {
				// [$]1[##][,###]+[.##]
				// [$]1###+[.##]
				// [$]0.##
				// [$].##
				return  /^\$?\-?([1-9]{1}[0-9]{0,2}(\,[0-9]{3})*(\.[0-9]{0,2})?|[1-9]{1}\d*(\.[0-9]{0,2})?|0(\.[0-9]{0,2})?|(\.[0-9]{1,2})?)$/.test(v)
			},


			
	isDateCn:function(v) {				
				var regex = /^(\d{4})-(\d{2})-(\d{2})$/;
				if(!regex.test(v)) return false;
				var d = new Date(v.replace(regex, '$1/$2/$3'));
				return ( parseInt(RegExp.$2, 10) == (1+d.getMonth()) ) && 
							(parseInt(RegExp.$3, 10) == d.getDate()) && 
							(parseInt(RegExp.$1, 10) == d.getFullYear() );
			},
	isInteger:function(v) {
				return  (/^[-+]?[\d]+$/.test(v));
			},

	isChinese:function(v) {
				return  (/^[\u4e00-\u9fa5]+$/.test(v));
			},
	isIp:function(v) {
				return  (/^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/.test(v));
			},

	isZip:function(v) {
				return  (/^[0-9]\d{5}$/.test(v));
			},

	isPhone:function(v) {
				return  /^((0[1-9]{3})?(0[12][0-9])?[-])?\d{6,8}$/.test(v);
			},

	isMobilePhone:function(v) {
				return  (/(^0?[1][35][0-9]{9}$)/.test(v));
			}
};

Object.extend(FormCheckor.Testor,{
	radioCheckboxOneRequired:function(v,elm) {
				var p = elm.parentNode;
				var options = p.getElementsByTagName('INPUT');
				var result=$A(options).any(function(elm) {
					return $F(elm);
				});
				return result;
			},
	elmEquals:function (v,elm,args,metadata) {
				return  $F(args[0]) == v;
			},

	elmNumberLessthan:function (v,elm,args,metadata) {
				if(FormCheckor.Testor.isNumber(v) && FormCheckor.Testor.isNumber($F(args[0])))
					return  parseFloat(v) < parseFloat($F(args[0]));
				return  v < $F(args[0]);
			},

	elmNumberGreatthan:function (v,elm,args,metadata) {
				if(FormCheckor.Testor.isNumber(v) && FormCheckor.Testor.isNumber($F(args[0])))
					return  parseFloat(v) > parseFloat($F(args[0]));
				return  v > $F(args[0]);
			},

	numberMax:function (v,elm,args,metadata) {
		return  parseFloat(v) <= parseFloat(args[0]);
	},

	numberMin:function (v,elm,args,metadata) {
		return parseFloat(v) >= parseFloat(args[0]);
	},

	lengthMin:function (v,elm,args) {
		//alert(args[0]);
		return v.length >= parseInt(args[0]);
	},
	lengthMax:function (v,elm,args) {
		return  v.length <= parseInt(args[0]);
	},

	isInFiles:function (v,elm,args,metadata) {
		return  $A(args).any(function(extentionName) {
			return new RegExp('\\.'+extentionName+'$','i').test(v);
		});
	},

	numberRange:function (v,elm,args,metadata) {
		return  (parseFloat(v) >= parseFloat(args[0]) && parseFloat(v) <= parseFloat(args[1]))
	},

	integerRange:function (v,elm,args,metadata) {
		return  (parseInt(v) >= parseInt(args[0]) && parseInt(v) <= parseInt(args[1]))
	},

	integerMin:function (v,elm,args,metadata) {
		return  parseInt(v) >= parseInt(args[0]) ;
	},

	integerMax:function (v,elm,args,metadata) {
		return   parseInt(v) <= parseInt(args[0]);
	},

	lenRange:function (v,elm,args,metadata) {
		return  (v.length >= parseInt(args[0]) && v.length <= parseInt(args[1]))
	},

	pattern:function (v,elm,args,metadata) {
		var extractPattern = /validate-pattern-\/(\S*)\/(\S*)?/;
		FormCheckor.Helper.assert(extractPattern.test(elm.className),"invalid validate-pattern expression,example: validate-pattern-/a/i");
		elm.className.match(extractPattern);
		return  new RegExp(RegExp.$1,RegExp.$2).test(v);
	},

	selectRange:function (v,elm,args,metadata) {			
			var hasChecked = 0;
			min = args[0]?args[0]||1:0
			max = args[1]?args[1]:elm.options.length;
			//alert(min+"min\\max:==>"+groups.options.length)
			for(var i=elm.options.length-1;i>=0;i--){
				var opt =elm[i];
				if(opt.selected&&opt.value!="") hasChecked++;
			}
			return min <= hasChecked && hasChecked <= max;
	},

	checkboxRange:function (v,elm,args,metadata) {			
		var groups = document.getElementsByName(elm.name);
		var hasChecked = 0;
		min = args[0]?args[0]||1:0
		max = args[1]?args[1]:groups.length;	
		for(var i=groups.length-1;i>=0;i--){
			var opt =groups[i];
			if(opt.checked) hasChecked++;
		}
		return min <= hasChecked && hasChecked <= max;
	},

	selectOneRequired:function (v,elm,args,metadata) {			
			var hasChecked = 0;
			min = 1;			
			for(var i=elm.options.length-1;i>=0;i--){
				var opt =elm[i];
				if(opt.selected&&opt.value!="") hasChecked++;
			}
			return min <= hasChecked;
	},

	lenBMin:function (v,elm,args,metadata) {
			var lenB = v.replace(/[^\x00-\xff]/g,"**").length;
			var min = args[0]?args[0]||1:0			
			return min <= lenB ;
	},

	lenBMax:function (v,elm,args,metadata) {
			var lenB = v.replace(/[^\x00-\xff]/g,"**").length;			
			var max = args[0]?args[0]:Number.MAX_VALUE;
			return lenB <= max;
	},

	lenBRange:function (v,elm,args,metadata) {
			var lenB = v.replace(/[^\x00-\xff]/g,"**").length;
			var min = args[0]?args[0]||1:0
			var max = args[1]?args[1]:Number.MAX_VALUE;
			return min <= lenB && lenB <= max;
	}
}
);

Object.extend(FormCheckor.Testor,{
	ajaxFun:function(v,elm,args,easyV) {
		FormCheckor.Helper.assert(elm.getAttribute('validateUrl'),'element validate by ajax must has "validateUrl" attribute');		
		if(elm._ajaxValidating && elm._hasAjaxValidateResult) {
			elm._ajaxValidating = false;
			elm._hasAjaxValidateResult = false;
			return elm._ajaxValidateResult;
		}
		var sendRequest = function() {
			new Ajax.Request(elm.getAttribute('validateUrl'),{
				parameters : Form.Element.serialize(elm),
				onSuccess : function(response) {
					//alert(response.responseText.strip() );
					if('true' != response.responseText.strip()  && 'false' != response.responseText.strip()){
						FormCheckor.Helper.assert(false,'validate by ajax,response.responseText must equals "true" or "false",actual='+response.responseText);
					}
					elm._ajaxValidateResult = eval(response.responseText);
					elm._hasAjaxValidateResult = true;
					easyV.testRule('validate-ajax',elm,easyV);
					//alert(easyV.testRule('validate-ajax',elm,easyV));
				}
			});
			elm._ajaxValidating = true;
			return true;
		}
		return elm._ajaxValidating || sendRequest();
	}
});	
	
//rulesSource
FormCheckor.rulesSource=[
		['validate-required',  function(v) {
					return  !FormCheckor.Testor.isEmpty(v); // || /^\s+$/.test(v));
				}],
		['validate-number', FormCheckor.Testor.isNumber],
		['validate-digits',  FormCheckor.Testor.isDigits],
		['validate-alpha', FormCheckor.Testor.isAlpha],
		['validate-alphanum',  FormCheckor.Testor.isAlphaNumber],
		['validate-date', FormCheckor.Testor.isDate],
		['validate-email',  FormCheckor.Testor.isEmail],
		['validate-url',FormCheckor.Testor.isUrl],
		['validate-date-au', FormCheckor.Testor.isDateAu ],
		['validate-currency-dollar', FormCheckor.Testor.isCurrencyDollar],
		['validate-date-cn',  FormCheckor.Testor.isDateCn],
		['validate-integer',  FormCheckor.Testor.isInteger],
		['validate-chinese', FormCheckor.Testor.isChinese],
		['validate-ip', FormCheckor.Testor.isIp],
		['validate-zip', FormCheckor.Testor.isZip],			
		['validate-phone', FormCheckor.Testor.isPhone],
		['validate-mobile-phone',FormCheckor.Testor.isMobilePhone],
		['validate-elm-equals', FormCheckor.Testor.elmEquals],
		['validate-elm-number-lessthan',FormCheckor.Testor.elmNumberLessthan],
		['validate-elm-number-greatthan', FormCheckor.Testor.elmNumberGreatthan],
		['validate-number-max',FormCheckor.Testor.numberMax,{depends : ['validate-number']}],
		['validate-number-min',FormCheckor.Testor.numberMin,{depends : ['validate-number']}],
		['validate-number-range',FormCheckor.Testor.numberRange,{depends : ['validate-number']}],
		['validate-length-min',FormCheckor.Testor.lengthMin],
		['validate-length-max',FormCheckor.Testor.lengthMax],
		['validate-length-range', FormCheckor.Testor.lenRange],
		['validate-lengthB-min',FormCheckor.Testor.lenBMin],
		['validate-lengthB-max',FormCheckor.Testor.lenBMax],
		['validate-lengthB-range',FormCheckor.Testor.lenBRange],	
		['validate-integer-min',FormCheckor.Testor.integerMin,{depends : ['validate-integer']}],
		['validate-integer-max',FormCheckor.Testor.integerMax,{depends : ['validate-integer']}],
		['validate-integer-range',FormCheckor.Testor.integerRange,{depends : ['validate-integer']}],
		['validate-select-one-required',FormCheckor.Testor.selectOneRequired],
		['validate-radio-checkbox-one-required', FormCheckor.Testor.radioCheckboxOneRequired],
		['validate-select-range',FormCheckor.Testor.selectRange],
		['validate-checkbox-range',FormCheckor.Testor.checkboxRange],
		['validate-file', FormCheckor.Testor.isInFiles],
		['validate-pattern',FormCheckor.Testor.pattern],
		['validate-ajax',FormCheckor.Testor.ajaxFun]
	];

FormCheckor.Validation = Class.create({
	initialize: function(form, options) {
		this.config = Object.extend(
		  { onSubmit : true,
			focusOnError : true,
			alertOnSubmit : false,
			stopOnFirst : false,
			immediate : false,		
			useTitles : false,			
			onFormValidate : function(result,form, easyV) {},
			onElementValidate : function(result, elm,easyV) {}}, 
		  options||{}
	  	);

		this.errorsSource=FormCheckor.errorSource;
		this.rules=FormCheckor.Helper.twoDepthArrayToRuleObject(FormCheckor.rulesSource);
		this.errors=FormCheckor.Helper.twoDepthArrayToErrorObject(this.errorsSource);
		this.validations={};

		this.form = $(form)?$(form):document.forms[form]; 
		this.errorsForShow=[];
		if(this.config.onSubmit){			
			Event.observe(this.form,'submit',this.onSubmit.bind(this),false);
		} 
		if(this.config.immediate) {
			var easyV=this;
			Form.getElements(this.form).each(function(elm) { 
				var type = elm.type.toLowerCase();
				var tagN = elm.tagName.toLowerCase();
				if( type == 'radio'||type == 'checkbox') {
					Event.observe(elm, 'click', function(evt) { this.validate(Event.element(evt),easyV); }.bind(this));
				}else if(tagN=='select'){
					Event.observe(elm, 'change', function(evt) { this.validate(Event.element(evt),easyV); }.bind(this));
				}else{
					Event.observe(elm, 'blur', function(evt) { this.validate(Event.element(evt),easyV); }.bind(this));
				}
				//Event.observe(elm, 'focus', function(evt){ this.reset(Event.element(evt),this); });
			},this);
		}
  },
	onSubmit :  function(ev){
		if(!this.validateAll()) Event.stop(ev);
	},

	reset : function(elm) {
		elm = $(elm);
		var classNames = elm.classNames();
		classNames.each(function(className) {
			var prop = '__advice'+className.camelize();
			if(elm[prop]) {
				var advice = FormCheckor.Helper.getAdvice(className, elm);
				advice.hide();
				elm[prop] = '';
			}
			elm.removeClassName('validation-failed');
			elm.removeClassName('validation-passed');
		});
	}
,
	getRule:function(className){
		var ruleNameResult=this.getRuleName(className);			
		return this.rules[ruleNameResult]?this.rules[ruleNameResult]:new FormCheckor.ValidationRule();
	},
	getRuleName:function (className){
		var ruleNameResult;
		for(var ruleName in this.rules) {
			if(className == ruleName) {
				ruleNameResult = ruleName;
				break;
			}
			if(className.indexOf(ruleName) >= 0) {
				ruleNameResult = ruleName;
			}
		}	
		return ruleNameResult;
	},
	getRealError:function(className,elm,easyValidation,args){
		var dependError = null;
		var rule=this.getRule(className);
		if(easyValidation.config.useTitles||elm.className.indexOf('useTitle') >= 0){
			if(elm && elm.title){
				return elm.title;
			}
		}
		var error = this.getError(this.getRuleName(className));
		if(typeof error == 'string') {
			if($F(elm)) args.push($F(elm).length);
			error = FormCheckor.Helper.putArgumentToError(error,args);
		}else if(typeof error == 'function') {
			error($F(elm),elm,args,easyValidation);
		}else{
			alert('error must type of string !');
		}
		return error;
	},
	getError:function(className){
		return  this.errors[className]?this.errors[className]:this.errors["validation-failed"];
	},
	validate : function(elm,easyValidation){
		elm = $(elm);
		var classNames = elm.classNames().toArray();
		if(!classNames.include("validate-required")
		&&FormCheckor.Helper.isEmpty(FormCheckor.Helper._getInputValue(elm))){return true;}
		return result = classNames.all(
			function(className) {
				var result = this.testRule(className,elm,easyValidation);
				this.config.onElementValidate(result, elm,easyValidation);
				return result;
			},this
		)
	},
	testRule : function(className,elm,easyValidation) {		
		var args  = FormCheckor.Helper.getArgumentFromClassName(this.getRuleName(className),className);
		var rule = this.getRule(className);		
		var prop = '__advice' + className.camelize();
		if(FormCheckor.Helper.isVisible(elm)){
			var resultDepends=false;
			resultDepends=$A(rule.options.depends).any(function(classNameDepend){
				var ruleDepend = this.getRule(classNameDepend);
					if(!this.testRule(classNameDepend,elm,easyValidation)){
						return true;
					}
					return false;
			},this);
			if(resultDepends==true){};
		}
		if(FormCheckor.Helper.isVisible(elm) && !rule.test(FormCheckor.Helper._getInputValue(elm),elm,args)) {
			var advice = FormCheckor.Helper.getAdvice(className, elm);
			var error=this.getRealError(className,elm,easyValidation,args);	
			//if(!elm[prop]) {
				if(!advice) {									
					advice = '<div class="validation-advice" id="' + FormCheckor.Helper.genAdviceId(className,elm) + '" style="display:none">' + error + '</div>'
					switch (elm.type.toLowerCase()) {
						case 'checkbox':
						case 'radio':
							var p = elm.parentNode;
							if(p) {
								//new Insertion.After(elm, advice);
								new Insertion.Bottom(p, advice);
							} else {
								new Insertion.After(elm, advice);
							}
							break;
						default:
							new Insertion.After(elm, advice);
					}
					//advice = $('advice-' + className + '-' + FormCheckor.Helper.getElmID(elm));
					advice = FormCheckor.Helper.getAdvice(className,elm);
					//alert('advice-' + className + '-' + elm.id);
				}else{
					advice.update(error);
				}
				
				if(typeof Effect == 'undefined') {
					advice.style.display = 'block';
				} else {
					new Effect.Appear(advice, {duration : 1 });
				}
			//}
			elm[prop] = true;
			elm.removeClassName('validation-passed');
			var type=elm.type.toLowerCase();
			if(type!='radio'&&type!='checkbox'){
				elm.addClassName('validation-failed');	
			}			
			return false;
		} else {
			var advice = FormCheckor.Helper.getAdvice(className, elm);
			if(advice) advice.hide();
			elm[prop] = '';
			elm.removeClassName('validation-failed');
			elm.addClassName('validation-passed');				
			return true;			
		}
	}
});


Object.extend(FormCheckor.Validation.prototype,{
	validateAll : function(easy) {
		var easyV=easy||this;
		var result = false;
		if(this.config.stopOnFirst) {
			result = Form.getElements(this.form).all(function(elm) {  return this.validate(elm,easyV); },this);
		} else {
			result = Form.getElements(this.form).collect(function(elm) { return this.validate(elm,easyV); },this).all();
		}
		if(!result && this.config.focusOnError) {
			var first=Form.getElements(this.form).findAll(function(elm){return $(elm).hasClassName('validation-failed')}).first();
			if(first&&first.select) first.select();
			if(first&&first.focus){first.focus();}			
		}
		this.config.onFormValidate(result, easyV.form, easyV);
		return result;
	},

	addRules:function(rulesArray){
		return Object.extend(this.rules,FormCheckor.Helper.twoDepthArrayToRuleObject(rulesArray));
	},	
	
	addRuleAndError:function(rule,error){
		var cname=rule.className;
		if(!this.rules[cname]){			
			Object.extend(this.rules,{cname:rule});
			Object.extend(this.errors,{cname:error});		
		}
	}
}
);

//autobind
FormCheckor.autoBind=function() {
	var forms = document.getElementsByClassName('validate-required-form');
	$A(forms).each(function(form){
		var eValidation = new FormCheckor.Validation(form,{immediate:true});
		var formId=FormCheckor.Helper.getElmID(form);
		alert('formId='+formId);
		Object.extend(eValidation,{formId:eValidation})
		Event.observe(form,'reset',function() {eValidation.reset();},false);
	});
};

Event.observe(window,'load',FormCheckor.autoBind,false);