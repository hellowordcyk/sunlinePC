$(function(){
	 $("body").on("click",".remind > .remind-close ",function(){
		 $(this).parent(".remind").remove(); //bootstrap提示信息初始化
	});
})
//navmenu顺序调节
	function doubledown($menu){
		$menu.removeClass("hidden");
		$menu.find("> .nav-clone").remove(); 
		$("nav .double-down > .fa").removeClass("fa-angle-double-up").addClass("fa-angle-double-down");
		$menu.removeClass("navMenu");
		var size = $menu.find("> li").size();
		var length = 0;
	    var outzise = size + 1;
	   for(var b= 0;b< size;b++){
		   length += $menu.find(" > li:eq("+ b +")").width();
		   if(length > $menu.width()){
			 outzise = b;
			 $menu.find(" > li:eq("+ (outzise - 1) +")").nextUntil().addClass("nav-hidden");
			 $menu.find(" > li:eq("+ (outzise - 1) +")").removeClass("nav-hidden").prevUntil().removeClass("nav-hidden");
			 $("nav .double-down").removeClass("hidden");
			 $(".navMenusize").text(size - b);
			 break;
		   }else{
				 $("nav .double-down").addClass("hidden");
				 $menu.find(" > li").removeClass("nav-hidden");
			  }
	   }
	 if( $menu.find("> .selected:first").index() >= outzise ){
		   var lengthw = $menu.find("> .selected:first").width();
		   var outzisew = null;
		   for(var b= 0;b< size;b++){
			   lengthw += $menu.find(" > li:eq("+ b +")").width();
			   if(lengthw > $menu.width()){
				 outzisew = b;
				 break;
			   }
		   }
		 $menu.find(" > li:eq("+ outzisew  +")").before($menu.find(" >.selected:first").clone());
		 $menu.find("> .selected:first").addClass("nav-clone hidden-xs").removeClass("nav-hidden").nextUntil().addClass("nav-hidden");
	 }
	}
	$(window).resize(function(){
		if(! $("#navMenu").hasClass("hidden")){
			 doubledown($("#navMenu"));
		}else if(! $("#navDropdown").hasClass("hidden")){
			doubledown($("#navDropdown"));
		}
 	}); 
	
	
