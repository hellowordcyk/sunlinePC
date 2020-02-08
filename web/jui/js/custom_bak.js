$(function(){
	 $("body").on("click",".remind > .remind-close ",function(){
		 $(this).parent(".remind").remove(); //bootstrap提示信息初始化
	});
	
	//控制满屏效果是否显示
	if(document.fullscreenEnabled == true || document.webkitFullscreenEnabled == true || document.mozFullScreenEnabled == true || document.msFullscreenEnabled == true){
		$("#toggle").show(0).click(function () {
			screenfull.toggle($('#body')[0]);
			$(this).find('i').toggleClass('fa-compress');
		});
	}
	 //点击切换左侧导航
	$('#sun_toggle').click(function(){
		
		var containerP = $('#container').css('padding-left');
	
		if(containerP == '187px'){
			$('#sun_toggle').find('i').removeClass('fa-chevron-left').addClass('fa-chevron-right')
			
			$('#sidebar').animate({'left':'-187px'},300);
			$('#container').animate({'padding-left':'1px'},400);
			
		}else{
			$('#sun_toggle').find('i').removeClass('fa-chevron-right').addClass('fa-chevron-left')
			
			$('#container').animate({'padding-left':'187px'},300);
			$('#sidebar').animate({'left':'0px'},400);
			
		}
	})	
	/* 横向菜单鼠标经过事件*/
	 $("#navDropdown").on("mouseover"," .dropdown-menu li",function() {
		 	$("ul",$(this)).first().show(0);
		 	$("ul",$(this)).first().css("left", $(this).parent().width());
		}).on("mouseout",".dropdown-menu li",function() {
			$("ul",$(this)).first().hide(0);
		});
	 
	 
	//左侧菜单
		$("#folderNavMenu").on("click",".side-first",function(){
			$("#folderNavMenu >li >ul >li").removeClass("selected");
			$(this).parent().find(">ul").slideToggle("1500");
			$(this).parent().find(">ul ul").slideUp();			
			$(this).parent().children().size()>1? $("#folderNavMenu .side-first").removeClass("selected"):$("#folderNavMenu li,#folderNavMenu .side-first").removeClass("selected");
			$(this).toggleClass("selected");

			//$("#folderNavMenu").find(".right-i").removeClass("fa-angle-down");
			$(this).find("span").toggleClass('up').parents('li').siblings().find(".right-i").removeClass('up');
			// $("#folderNavMenu").find(".right-i").removeClass("fa-angle-down").addClass("fa-angle-up");
			// $(this).find(".right-i").hasClass("fa-angle-down")? $(this).find(".right-i").removeClass("fa-angle-down").addClass("fa-angle-up").:$(this).find(".right-i").removeClass("fa-angle-up").addClass("fa-angle-down");
			$(this).parent().siblings().find("ul").slideUp("1500");
		})
		$("#folderNavMenu").on("click",".side-two",function(){
			$(this).parent().find(">ul").slideToggle("1500");
			$(this).parent().find(">ul ul").slideUp();
			/*$("#folderNavMenu .side-two").removeClass("selected");
			$(this).toggleClass("selected");*/
			$(this).parent().siblings().find("ul").slideUp("1500");
		})
		$("#folderNavMenu").on("click","> li >ul >li",function(){
			$("#folderNavMenu >li>.side-first").removeClass("selected");
			$("#folderNavMenu >li >ul >li").removeClass("selected");
			$(this).addClass("selected");
		})
			
	
	
	
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
	
	$(function(){
		var $menu = null;
		if(typeof(getMenuStyle)=="function"){
			getMenuStyle();
		}
		
		(Jraf.menuStyle == "3") ? ($menu = $("#navDropdown")) : ($menu = $("#navMenu")); 
		$("nav .double-down").click(function(){
		   $menu.find("> .nav-clone").remove(); 
		   $menu.toggleClass("navMenu");
		   $("nav .double-down > .fa").toggleClass("fa-angle-double-down").toggleClass("fa-angle-double-up");
		   if(! $menu.hasClass("navMenu")){
				doubledown( $menu);
			 }else{
			  $menu.find(">li").removeClass("nav-hidden");
		   }
		})
		$(document).on('click', function(e) {
			var mouseheight = e.pageY || e.screenY;
			if(mouseheight > $("#headerheight").height() || $(e.target).parents(".double-down").length < 0){
				$menu.removeClass("navMenu");
				$("nav .double-down > .fa").addClass("fa-angle-double-down").removeClass("fa-angle-double-up");
				 $menu.find(">li").removeClass("nav-hidden");
				 doubledown( $menu);
			}
		})
		/*点击头部菜单显示左侧菜单*/
		var isShow = false;
		$menu.on("click",">li",function(){
			if(!isShow){
				$('#sun_toggle').find('i').removeClass('fa-chevron-right').addClass('fa-chevron-left');
				isShow = true;
			}
			if(Jraf.menuStyle != "3"){
				if(!$("body").hasClass("initialise")){
					if($("#sidebar").css("display") == "none"){
						$("#sidebar_s .toggleMark").trigger("click");
					}
				}
				$("body").removeClass("initialise");// 初始化的左侧菜单不显示
				
				doubledown($menu);
			}
			if(Jraf.menuStyle != "3"){
				if($('#container').css('padding-left') != '187px'){
					$('#sun_toggle').find('i').removeClass('fa-chevron-right').addClass('fa-chevron-left')
				
					$('#container').animate({'padding-left':'187px'},300);
					$('#sidebar').animate({'left':'0px'},400);
				}
			}
		});
	})
	$(window).resize(function(){
		if(! $("#navMenu").hasClass("hidden")){
			 doubledown($("#navMenu"));
		}else if(! $("#navDropdown").hasClass("hidden")){
			doubledown($("#navDropdown"));
		}
 	}); 
	
	
