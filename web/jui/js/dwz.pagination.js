/**
 * 
 * @author ZhangHuihua@msn.com
 * @param {Object} opts Several options
 */
(function($){
	$.fn.extend({
		dwzpagination: function(opts){
			var setting = {
				first$:"li.j-first", prev$:"li.j-prev", next$:"li.j-next", last$:"li.j-last", nums$:"li.j-num>a", jumpto$:"li.jumpto",
				pageNumFrag:'<li class="#liClass#"><a href="javascript:;">#pageNum#</a></li>'
			};
			return this.each(function(){
				var $this = $(this);
				var pc = new Pagination(opts);
				var interval = pc.getInterval();
				var pageNumFrag = '';
				for (var i=interval.start; i<interval.end;i++){
					pageNumFrag += setting.pageNumFrag.replaceAll("#pageNum#", i).replaceAll("#liClass#", i==pc.getCurrentPage() ? 'selected j-num' : 'j-num');
				}
				var newhtml = "";
				if(pc.getNoCount()) {
					newhtml = DWZ.frag["paginationNoCount"].replaceAll("#pageSize#",pc.getPageSize())
					  .replaceAll("#currentPage#",pc.getCurrentPage())
					  .replaceAll("#targetType#",pc.targetType());
				}else{
					newhtml = DWZ.frag["pagination"].replaceAll("#totalCount#",pc.getTotalCount()).replaceAll("#pageSize#",pc.getPageSize())
					  .replaceAll("#currentPage#",pc.getCurrentPage()).replaceAll("#pageCount#",pc.numPages())
					  .replaceAll("#targetType#",pc.targetType());
				}
				/*$this.html(DWZ.frag["pagination"].replaceAll("#pageNumFrag#", pageNumFrag).replaceAll("#currentPage#", pc.getCurrentPage())).find("li").hoverClass();*/
				$this.html(newhtml).find("li").hoverClass();
			
				var minNumPerPage = 1000;
				$this.find("select option").each(function(obj){
				   if(parseInt($(this).text()) < minNumPerPage){
					   minNumPerPage = parseInt($(this).text());
				   }
				});
				if(pc.getTotalCount() <= minNumPerPage){
					$this.css("display","none");
				};
				var $first = $this.find(setting.first$);
				var $prev = $this.find(setting.prev$);
				var $next = $this.find(setting.next$);
				var $last = $this.find(setting.last$);
				var $numPerPage = $this.find("select[name='numPerPage']");
				
				if (pc.hasPrev()){
					$first.add($prev).find(">span").hide();
					_bindEvent($first, 1,pc.getPageSize(), pc.targetType(), pc.rel());
					_bindEvent($prev, pc.getCurrentPage()-1,pc.getPageSize(), pc.targetType(), pc.rel());
				} else {
					$first.add($prev).addClass("disabled").find(">a").hide();
				}
				
				if (pc.hasNext()) {
					$next.add($last).find(">span").hide();
					_bindEvent($last, pc.numPages(),pc.getPageSize(), pc.targetType(), pc.rel());
					_bindEvent($next, pc.getCurrentPage()+1,pc.getPageSize(), pc.targetType(), pc.rel());
				} else {
					$next.add($last).addClass("disabled").find(">a").hide();
				}
				
				/* 给每页记录数选择框添加change绑定事件  跳转到最后一页 date 2016-05-24 edit by lihu */
				if($numPerPage){
					if ($.fn.combox) $numPerPage.combox();
					$numPerPage.change(function(){
						dwzPageBreak({targetType:pc.targetType(), rel:pc.rel(), data:{pageNum:1, numPerPage:$numPerPage.val()}});  //如果修改pageSize 那么默认跳转到第一页
					});
					//给a标签赋值，否则会显示不正常
					$this.find("a[name='numPerPage']").html(pc.getPageSize());
	
					$this.find("select option").each(function(obj){
						if($(this).text() == pc.getPageSize()){
							$(this).attr("selected", "selected");  
						}
					});
				}
	
				$this.find(setting.nums$).each(function(i){
					_bindEvent($(this), i+interval.start,pc.getPageSize(), pc.targetType(), pc.rel());
				});
				$this.find(setting.jumpto$).each(function(){
					var $this = $(this);
					var $inputBox = $this.find(":text");
					var $button = $this.find(":button");
					$button.click(function(event){
						var pageNum = $inputBox.val();
						
						if (pageNum && pageNum.isPositiveInteger()) {
							/*判断如果输入的页数大于总页数，跳转到最后一页 date 2016-05-24 edit by lihu */
							pageNum = (pageNum > pc.numPages() ? pc.numPages():pageNum);
							
							dwzPageBreak({targetType:pc.targetType(), rel:pc.rel(), data: {pageNum:pageNum,numPerPage:pc.getPageSize()}});
						}
					});
					$inputBox.keyup(function(event){
						if (event.keyCode == DWZ.keyCode.ENTER) $button.click();
					});
				});
				
				
			});
			
			/*方法添加numPerPage参数 date 2016-05-23 edit by lihu */
			function _bindEvent($target, pageNum,numPerPage, targetType, rel){
				$target.bind("click", {pageNum:pageNum,numPerPage:numPerPage}, function(event){
					dwzPageBreak({targetType:targetType, rel:rel, data:{pageNum:event.data.pageNum, numPerPage:event.data.numPerPage}});
					event.preventDefault();
				});
				
			}
		},
		
		orderBy: function(options){
			var op = $.extend({ targetType:"navTab", rel:"", asc:"asc", desc:"desc"}, options);
			return this.each(function(){
				var $this = $(this);
				$this.css({cursor:"pointer"});
				$this.click(function(){
					var orderField = new Array();
					var orderDirection = new Array();
					$this.closest("table").find("[orderField]").each(function(i,td){
						var field = $(td).attr("orderField");
						if($(td).attr("orderField")){
							if(td == $this[0]){
								orderField.push($(td).attr("orderField") );
								orderDirection.push($(td).hasClass(op.asc) ? op.desc : $(td).hasClass(op.desc)?"":op.asc);
							}else{
								orderField.push($(td).attr("orderField") );
								orderDirection.push($(td).hasClass(op.asc) ? op.asc : $(td).hasClass(op.desc)?op.desc:"");
							}
						}
					});
					dwzPageBreak({targetType:op.targetType, rel:op.rel, data:{orderField: orderField, orderDirection: orderDirection}});
				});
				
			});
		},
		pagerForm: function(options){
			var op = $.extend({pagerForm$:"#pagerForm", parentBox:document}, options);
			var frag = '<input type="hidden" name="#name#" value="#value#" />';
			return this.each(function(){
				//modified by SeanYang on 20160630统一获取分页form对象
				var $searchForm = $(this), $pagerForm = $(getPagerFormObjs(op.parentBox).get(0));//$(op.pagerForm$, op.parentBox);
				if (!$pagerForm) {//找不到return
					return;
				}
				var actionUrl = $pagerForm.attr("action").replaceAll("#rel#", $searchForm.attr("action"));
				$pagerForm.attr("action", actionUrl);
				$searchForm.find(":input").each(function(){
					var $input = $(this), name = $input.attr("name");
					if (name && (!$input.is(":checkbox,:radio") || $input.is(":checked"))){
						if ($pagerForm.find(":input[name='"+name+"']").length == 0) {
							var inputFrag = frag.replaceAll("#name#", name).replaceAll("#value#", $input.val());
							$pagerForm.append(inputFrag);
						}
					}
				});
			});
		}
	});
	
	var Pagination = function(opts) {
		this.opts = $.extend({
			targetType:"navTab",	// navTab, dialog
			rel:"", //用于局部刷新div id号
			totalCount:0,
			numPerPage:10,
			pageNumShown:10,
			currentPage:1,
			noCount:false,
			callback:function(){return false;}
		}, opts);
	}
	
	$.extend(Pagination.prototype, {
		targetType:function(){return this.opts.targetType},
		rel:function(){return this.opts.rel},
		numPages:function() {
			return this.opts.numPerPage==0?0:Math.ceil(this.opts.totalCount/this.opts.numPerPage);
		},
		getTotalCount:function(){
			return Math.ceil(this.opts.totalCount);
		},
		getPageSize:function(){
			return Math.ceil(this.opts.numPerPage);
		},
		getInterval:function(){
			var ne_half = Math.ceil(this.opts.pageNumShown/2);
			var np = this.numPages();
			var upper_limit = np - this.opts.pageNumShown;
			var start = this.getCurrentPage() > ne_half ? Math.max( Math.min(this.getCurrentPage() - ne_half, upper_limit), 0 ) : 0;
			var end = this.getCurrentPage() > ne_half ? Math.min(this.getCurrentPage()+ne_half, np) : Math.min(this.opts.pageNumShown, np);
			return {start:start+1, end:end+1};
		},
		getCurrentPage:function(){
			var currentPage = parseInt(this.opts.currentPage);
			if (isNaN(currentPage)) return 1;
			return currentPage;
		},
		hasPrev:function(){
			return this.getCurrentPage() > 1;
		},
		hasNext:function(){
			if(this.getNoCount()||this.getNoCount()=="true") {
				return this.getTotalCount()>=this.getPageSize();
			}else{
				return this.getCurrentPage() < this.numPages();
			}
		},
		getNoCount:function() {
			return this.opts.noCount;
		}
	});
})(jQuery);
