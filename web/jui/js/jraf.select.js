(function($){
    $.fn.jrafSelect = function($p){
        return this.each(function(){
        	var $this = $(this);
        	var disabled = $this.attr("disabled")=="disabled"?true:false;
        	var multiple = $this.attr("multiple")=="multiple"?true:false;
        	var showSerch = $this.attr("showserch")=="true"?null:"Infinity";
    		var dir = $this.attr("alignright")=="true"?"rtl":"";
    		var maxSelect = $this.attr("maxselect");
    		
    		var remoteUrl = $this.attr("remoteurl");
    		var remoteDataType = "xml";
    		var remoteDataFilter = "xmlDataFilter";
    		var remoteValue = $this.attr("remotevalue") || "value";
    		var remoteLable = $this.attr("remotelable") || "lable";
    		var remoteParam = $this.attr("remoteparam") || remoteLable || $this.attr("name") || "searh_term";
    		var group = $this.attr("group") || "group";
    		var pageSize = $this.attr("remotepagesize") || null;
    		var value = $this.attr("defaultValue") || null;
    		
    		var option = {
				multiple: multiple,
				dir: dir,
				disabled: disabled,
				minimumResultsForSearch: showSerch,
				maximumSelectionLength: maxSelect,
				width: "100%"
    		};
    		if(value){
    			initSelected($this, value, remoteUrl, remoteValue, remoteLable);
			}
    		if(remoteUrl) {
    			option.minimumInputLength = 0;
    			option.ajax = {
					type:"post",
					url: remoteUrl,
				    dataType: remoteDataType,
				    delay: 250,
				    cache: true,
				    data: function (params) {
				    	var param = {};
				    	param.PageNo = params.page||1;
				    	param[remoteParam] = params.term;
				    	if(pageSize){
				    		param.PageSize = pageSize;
				    	}
				    	return param;
					},
					processResults: function (data, params) {
						if(remoteDataFilter){
							return eval(remoteDataFilter+"(data, params,group)");
						}else{
							params.page = params.page || 1;
							return {
								results: data.items,
								pagination: {
							          more: (params.page*30) < data.total_count
							    }
							};
						}
					}
				};
			}
    		
    		$this.select2(option);
    		
    		function initSelected($this, value, remoteUrl, remoteValue, remoteLable){
    			if(remoteUrl) {
    				var data = {};
    				data[remoteValue] = value;
    				$.ajax({
        				url: remoteUrl,
        				data:data,
        				type: "POST",
        				dataType: "xml",
        				success: function(data){
        					data = Jraf.parseXmlResponseDataToJson(data);
        					$(data.Record).each(function(i,record){
        						if(record[remoteValue] && record[remoteLable]){
        							var html = "<option value='"+record[remoteValue]+"' selected='selected'>"+record[remoteLable]+"</option>";
        							$this.append(html);
        						}
        					});
        				}
        			});
				}else{
					$(value.split(",")).each(function(i,selectedV){
						$this.find("option[value='"+selectedV+"']").attr("selected","selected");
					});
				}
    		}
    		
    		function xmlDataFilter(data, params, group){
    			data = Jraf.parseXmlResponseDataToJson(data);
    			var results = new Array();
    			$(data.Record).each(function(i,record){
    				var item = {element: HTMLOptionElement};
    				var groupText = null;
    				for(var key in record){
    					if(key == remoteValue){
    						item.id = record[key];
    					}
    					if(key == remoteLable){
    						item.text = record[key];
    					}
    					if(group && key == group){
    						groupText = record[key];
    					}
    				}
    				if(groupText != null){
    					var isNewGroup = true;
    					$(results).each(function(i,result){
    						if(result.text == groupText && result.element == HTMLOptGroupElement){
    							result.children.push(item);
    							isNewGroup = false;
    						}
    					});
    					if(isNewGroup){
    						results.push({text:groupText,children:[item],element:HTMLOptGroupElement});
    					}
    				}else{
    					results.push(item);
    				}
    			});
    			var more = false;
    			if(data.PageInfo){
    				more = data.PageInfo.PageSize*data.PageInfo.PageNo < data.PageInfo.RecordCount;
    			}
    			var result = {results:results,pagination:{more:more}};
    			return result;
    		}
        });		
    }
})(jQuery);
