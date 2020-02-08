//基于Jraf_Prototype.js
var Jraf_Menu = Class.create({
    initialize: function(options) {
        this.options = {
            topMainObj: null, //生成主菜单的位置
            subMenuObj: null, //二级及以下菜单位置 
            clickMain: null, //点击主菜单
            clickNode: null, //非叶子节点点击事件方法
            clickLeafNode: null,//叶子节点点击事件方法
            queryparams: {
                sysName:    '<sc:fmt type="crypto" value="pcmc"/>',
                oprID:      '<sc:fmt type="crypto" value="sm_query"/>',
                actions:    '<sc:fmt type="crypto" value="getMenuList"/>',
                subsysid: null,
                recursive: 1
            },
            queryCallBack: null,//查询后的回调函数
            expandImgSrc: "./img/expand.gif",
            endNodeImgSrc: "./img/endnode.gif"
        };
         Object.extend(this.options, options || { });
         this.options.topMainObj = $(this.options.topMainObj);
         this.options.subMenuObj = $(this.options.subMenuObj);
         Element.extend(this.options.topMainObj);
         
         this.gMenuDatas = new Hash();
         this.gMenuDatas.set("n", {"self": null, "datas": [], "childnum": 0});//根节点
         
         //初始化
         this.__createMainMenu();
	},
	/**
	 * 创建主菜单
	 * 返回结果，必需包含的属性：
	 *     menuid, menuname, pmenuid, subsysid, linkurl, sortno
	 */
	__createMainMenu: function () {
		var ajax = new Jraf.Ajax({evalJS:false, evalJSON:false});
	    ajax.sendForXml('/xmlprocesserservlet', this.options.queryparams, function(xml){
	        try{
	            var pkg = new Jraf.Pkg(xml);
	            if(pkg.result() != '0'){
	                alert('[Jraf_Menu][method=createMainMenu]获取菜单数据出错：'+pkg.allMsgs());
	                return;
	            }
	            var rcds = pkg.rspDatas().Record;
	            if(!rcds) rcds=[];
	            if(!Object.isArray(rcds)) rcds = [rcds];
	            
	            var menuitem = null;
	            var pmenuid = "";
	            for (var i = 0, len = rcds.length; i < len; i ++) {
	                menuitem = rcds[i];
	                var tempJSON = {
	                	"self": menuitem,
            			"datas": [],
            			"childnum": 0
                	};
	                this.gMenuDatas.set(this.__getKey(menuitem.menuid), tempJSON);
	                
	                if (menuitem.pmenuid ==null || menuitem.menuid==menuitem.pmenuid) {
	                	pmenuid = this.__getKey("");
	                } else {
	                	pmenuid = this.__getKey(menuitem.pmenuid);
	                }
	                if (this.gMenuDatas.get(pmenuid) != null) {
	                	var tempMD = this.gMenuDatas.get(pmenuid);
	                	tempMD.datas[tempMD.datas.length] = menuitem;
	                	tempMD.childnum ++;
	                }
	            }
	        }catch(e){
	            alert('[Jraf_Menu][method=createMainMenu]JSERROR:'+e.message);
	        }
	        this.__createTopMenu();//初始化
	    }.bind(this));
	    ajax=null;
	}, 
	__getKey: function (menuid) {
		return "n"+menuid;
	},
	getMenuDatas: function () {
		return this.gMenuDatas;
	},
	/**
	 * @param key 值为'n'+菜单id ('n'+menuid), 根节点为'n'（menuid为空）
	 */
	getMenuJSON: function (key) {
		return this.gMenuDatas[key];
	},
	__createTopMenu: function () {
		//隐藏
		Element.hide(this.options.topMainObj);
		var oUl = new Element("ul");
		//this.options.topMainObj.update(oUl);
		this.options.topMainObj.appendChild(oUl);
		var oTopMenus = this.gMenuDatas.get(this.__getKey(""));
		var menu = null;
		var oLi = null;
		var oA = null;
		for(var i =0, len = oTopMenus.datas.length; i < len; i ++) {
			menu = oTopMenus.datas[i];
			oLi = new Element("li", {"subsysid": menu.subsysid,"menuid": menu.menuid});
			if (i == 0) {
				Element.writeAttribute(oLi, "id", "current");
			} 
			oA = new Element("a", {"hidefocus": true, "href": "#;returnValue=false;"});
			Element.observe(oA, "click", this.__clickTopMenus.bind(this));
			Element.insert(oA, menu.menuname);
			Element.insert(oLi, oA);
			
			Element.insert(oUl, oLi);
		}
		//显示
		Element.show(this.options.topMainObj);
		//$("current").down("a").click();
		//初始化一级菜单后回调函数
		if (typeof this.options.queryCallBack == "function") {
			this.options.queryCallBack();
		}
	},
	refreshCurrentMenu: function () {
		Element.down(Element.down(this.options.topMainObj, "#current"), "a").click();
	},
	/**
	 * 
	 * @returns
	 */
	__clickTopMenus: function () {
		try {
			var oLi =$(Event.findElement(event, "li"));
			//设置为当前选中菜单
			Element.down(Element.up(oLi, "ul"), "li[id='current']").id="";
			oLi.id = "current";
			
			//显示二级以下菜单
			this.__creatSubMenu(Element.readAttribute(oLi, "menuid"));
			
			if (typeof this.options.clickMain == "function") {
				this.options.clickMain(Element.readAttribute(oLi, "subsysid"), Element.readAttribute(oLi, "menuid"));
			}
		} catch(e) {
			alert("[method=__clickTopMenus]jserror: " + e.message);
			return;
		}
	},
	/*
	 * 跨域（frame）ie6下不能添加创建的节点（document.createElement），
	 * 将方法移到需要创建节点的页面里
	 */
	__creatSubMenu: function (menuid) {
		Element.hide(this.options.subMenuObj);

		var oSpan = new Element("span");
		Element.update(this.options.subMenuObj, oSpan);
		
		var oMenuTemp = null;
		var oMenu = this.gMenuDatas.get(this.__getKey(menuid));
		for (var i = 0, len=oMenu.datas.length; i < len; i ++) {
			oMenuTemp = oMenu.datas[i];
			this.__creatSubMenuTemp(oSpan, oMenuTemp.menuid);
		}
		
		Element.show(this.options.subMenuObj);
	},
	/*
	 * 跨域（frame）ie6下不能添加创建的节点（document.createElement），
	 * 将方法移到需要创建节点的页面里
	 */
	__creatSubMenuTemp: function (oSpan, menuid) {
		var oMenu = this.gMenuDatas.get(this.__getKey(menuid));
		if (oMenu == null) 
			return;
		//循环创建菜单
		var oMenuTemp = null;
		var len = oMenu.datas.length;
		var oPrtSpan = null;//父
		var oSubSpan = null;//叶子节点
		if (len > 0) {
			oPrtSpan = new Element("span", {"isleaf": "false", "childnum": oMenu.datas.length, "menuid": oMenu.self.menuid});
			Element.addClassName(oPrtSpan, "hasItems");
			Element.observe(oPrtSpan, "click", this.__clickNode.bind(this));
			
			var oImg = new Element("img", {"align": "middle"});
			Element.addClassName(oImg, "ec");
			oImg.src=this.options.expandImgSrc;//"./img/expand.gif";
			
			Element.insert(oPrtSpan, oImg);
			Element.insert(oPrtSpan, oMenu.self.menuname);
			
			Element.insert(oSpan, oPrtSpan);
			var oSpanTmp = new Element("span", {name: "cn"});
			Element.setStyle(oSpanTmp, {"display": "none"});
			Element.insert(oSpan, oSpanTmp);
			
			//TODO: 菜单按照sortno排序，现在按照查询顺序创建
			for (var i = 0; i < len; i ++) {
				oMenuTemp = oMenu.datas[i];
				this.__creatSubMenuTemp(oSpanTmp, oMenuTemp.menuid);
			}
		} else {
			oSubSpan = new Element("span", {"isleaf": "true", "childnum": 0, "menuid": oMenu.self.menuid});
			Element.addClassName(oSubSpan, "Items");
			Element.setStyle(oSubSpan, {"padding-left": "10px"});
			Element.observe(oSubSpan, "click", this.__clickNode.bind(this));
			
			var oImg = new Element("img", {"align": "middle"});
			Element.addClassName(oImg, "ec");
			oImg.src=this.options.endNodeImgSrc;//"./img/endnode.gif";
			
			Element.insert(oSubSpan, oImg);
			Element.insert(oSubSpan, oMenu.self.menuname);
			
			Element.insert(oSpan, oSubSpan);
		}
		
	},
	__clickNode: function (e) {
		var oSpan =$(Event.findElement(e || event, "span"));//当前点击菜单
		
		var menuid = Element.readAttribute(oSpan, "menuid");
		var oMenu = this.gMenuDatas.get(this.__getKey(menuid));
		if (Element.readAttribute(oSpan,"isleaf") == "false") {
			var oPrtSpan = Element.up(oSpan);
			var oOpenSpan = Element.down(oPrtSpan, "#__JrafMenu_Current_ID");
			if (oOpenSpan) { //清除以前打开的菜单
				Element.hide(oOpenSpan);
				oOpenSpan.id = "";
				Element.writeAttribute(oOpenSpan, "id", "");
			}
			var oSubSpan = oSpan.nextSibling;//Element.next(oPrtSpan, "span[name=cn]");//子菜单节点
			
			oSubSpan.id = "__JrafMenu_Current_ID";
			Element.writeAttribute(oSubSpan, "id", "__JrafMenu_Current_ID");
			
			Element.show(oSubSpan);
			//点击父节点，扩展方法
			if(typeof this.options.clickLeafNode == "function") {
				/*
				 * @param obj 当前菜单数据
				 * @param []  子菜单数据
				 */
				this.options.clickNode(oMenu.self, oMenu.datas);//执行点击叶子节点事件
			}
			return;
		}
		
		//增加选中颜色
		var oPrtSpan = Element.up(oSpan);
		var oOpenSpan = Element.down(oPrtSpan, "#__JrafMenu_Subnode_Current_ID");
		if (oOpenSpan) { //清除以前打开的菜单
			Element.setStyle(oOpenSpan, {"color": "#000"});
			oOpenSpan.id = "";
			Element.writeAttribute(oOpenSpan, "id", "");
		}
		
		oSpan.id = "__JrafMenu_Subnode_Current_ID";
		Element.setStyle(oSpan, {"color": "#990000"});
		Element.writeAttribute(oSpan, "id", "__JrafMenu_Subnode_Current_ID");
		//叶子节点
		if(typeof this.options.clickLeafNode == "function") {
			this.options.clickLeafNode(oMenu.self);//执行点击叶子节点事件
		}
	},
	__callWorkflow: function (subsysid) {
		alert("__callWorkflow")
	},
	getPathName: function (menuid) {
		if (menuid == null) 
			return "";
		var oMenu = this.gMenuDatas.get(this.__getKey(menuid));
		var self = oMenu.self;
		var pathName = "";
		var current = "<span class='current'>"+self.menuname+"</span>"; 

		//叶子节点往上查找
		var tempPath = "";
		while (1==1) {
			self = this.gMenuDatas.get(this.__getKey(self.pmenuid)).self;
			if (self == null) {
				break;
			}
			tempPath = self.menuname+"&nbsp;>&nbsp;" + tempPath; 
		}
		pathName += tempPath;
		pathName += current;
		return pathName;
	}
});