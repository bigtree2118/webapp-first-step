/**
 * 如果当前窗口不是顶层窗口,则将首页置为顶层窗口
 */
if(window != window.top){ window.top.location.href = location.href; }
var mainMenu, mainTabs;

/**
 * 初始化首页内容
 */
$(function(){
	$('#mainLayout').layout('panel', 'center').panel({
		onResize : function(width, height) {
			setIframeHeight('centerIframe', $('#mainLayout').layout('panel', 'center').panel('options').height - 5);
		}
	});
	
	tabCloseEvent();
	
	mainTabs = $('#mainTabs').tabs({
		fit : true,
		border : false,
		tools : [ {
			iconCls : 'ext-icon-arrow_up',
			handler : function() {
				mainTabs.tabs({
					tabPosition : 'top'
				});
			}
		}, {
			iconCls : 'ext-icon-arrow_down',
			handler : function() {
				mainTabs.tabs({
					tabPosition : 'bottom'
				});
			}
		}, {
			iconCls : 'ext-icon-arrow_refresh',
			handler : function() {
				var panel = mainTabs.tabs('getSelected').panel('panel');
				var frame = panel.find('iframe');
				try {
					if (frame.length > 0) {
						for (var i = 0; i < frame.length; i++) {
							frame[i].contentWindow.document.write('');
							frame[i].contentWindow.close();
							frame[i].src = frame[i].src;
						}
						if (navigator.userAgent.indexOf("MSIE") > 0) {// IE特有回收内存方法
							try {
								CollectGarbage();
							} catch (e) {
							}
						}
					}
				} catch (e) {
				}
			}
		}]
	});
	
	initMenuTree();
	initCollection();
	renderFooter();
});

function setIframeHeight(iframe, height) {
	iframe.height = height;
}

//菜单权限树配置
var setting = {
	data: {
		key: {
			title:"name",
			name:"name"
		},
		simpleData: {
			enable: true,
			idKey: "id",
			pIdKey: "parentId"				
		}
	},
	check: {
		enable: false
	},
	view: {
		selectedMulti: false,
		fontCss: getFontCss,
		showLine :false,
        dblClickExpand : false 
	},
	callback: {   
		beforeDrag: false,
		beforeExpand: beforeExpand,
		onClick: onClick
	}
};

function dblClickExpand(treeId, treeNode) {
	return treeNode.level_no > 0;
}

function beforeExpand(treeId, treeNode) {
	var expandedNodes = treeRightObj.getNodesByParam("open", true, treeNode.getParentNode());
	for ( var i = expandedNodes.length - 1; i >= 0; i--) {
		if (treeId != expandedNodes[i].id && expandedNodes[i].level == treeNode.level) {
			treeRightObj.expandNode(expandedNodes[i], false);
		}
	}
	if(lastNode != getBaseNode(treeNode)){
		treeRightObj.expandNode(lastNode, false);
		lastNode = getBaseNode(treeNode);
	}
}

function onClick(event, treeId, treeNode,clickFlag) {
	if(treeNode.aurl !=null && treeNode.aurl !=""){
		addTab(treeNode.name,treeNode.aurl);
	}else{
		if(!treeNode.open){
			treeRightObj.expandNode(treeNode, true,false,true,true);
		}else{
			treeRightObj.expandNode(treeNode, false,false,true,true);
		}
	}
}

function getFontCss(treeId, treeNode) {
	return (!!treeNode.highlight) ? {color:"#A60000", "font-weight":"bold"} : {color:"#333", "font-weight":"normal"};
}

//搜索权限节点==================================start==============================================================
var lastValue = "", nodeList = [] , lastNode, treeRightObj ={}, cursor = 0;
function searchRight(value) {
    var re = new RegExp(/^[A-Za-z]+$/);    
	if(value ==="") return;
	if(value ===lastValue){
		if(changeHightlight(false))cursor++;
		if(!expandNode(cursor)) expandNode(0);
	}else{
		lastValue = value;
		changeHightlight(false);
		if(re.test(value)){//节点助记码
		   value=value.toLowerCase();
		   lastValue = value;
		   nodeList = treeRightObj.getNodesByParamFuzzy("right_zjm", value,null);
		  if(nodeList==null || nodeList.length==0){
		   nodeList = treeRightObj.getNodesByParamFuzzy("right_zjm_full", value,null);
		  }
		}else{//节点名称
		  nodeList = treeRightObj.getNodesByParamFuzzy("right_name", value,null);
		}
		expandNode(0);
	}
}
//获得节点的根
function getBaseNode(node){
	return node.level ==0? node : getBaseNode(node.getParentNode());
}
//设置是否高亮
function changeHightlight(flag){
	if(nodeList[cursor] !=undefined){
		nodeList[cursor].highlight = flag;
		treeRightObj.updateNode(nodeList[cursor]);
		return true;
	}else{
		return false;
	}
}
//展开搜索到的第几个节点
function expandNode(_cursor){
	cursor = _cursor;
	if(nodeList[cursor] !=undefined){
		changeHightlight(true);
		if(nodeList[cursor].children ==undefined && !nodeList[cursor].getParentNode().open){
			treeRightObj.expandNode(nodeList[cursor].getParentNode(), true,false,true,true);
		}else if(!nodeList[cursor].open){
			treeRightObj.expandNode(nodeList[cursor], true,false,true,true);
		}
		var baseNode = getBaseNode(nodeList[cursor]);
		if(!baseNode.open){
			treeRightObj.expandNode(baseNode, true,false,true,true);
		}
		return true;
	}else{
		return false;
	}
}
//搜索权限节点==================================end==============================================================
	
	
//初始化目录树
function initMenuTree(){
	$.getJSON(JXCore.basePath + "/admin/menu", {'ct':(new Date()).getTime()}, function(result) {
		if(!(result && result.data)){
			window.top.showSysMsg('加载菜单信息失败!');
			return;
		}
		var menuList = [];
		for(var i=0; i<result.data.length;i++){
			var menuItem = {};
			menuItem.id = result.data[i].id;
			menuItem.name = result.data[i].name;
			menuItem.parentId = result.data[i].parentId;
			menuItem.aurl = result.data[i].url;
			
			menuList.push(menuItem);
		}
		treeRightObj = $.fn.zTree.init($("#treeRight"), setting, menuList);
	});
}

// 初始化个人收藏
function initCollection(){
	
}

function addTab(title, url, iconCls){
	url = JXCore.basePath + url;
	var tabItem = {
		title: title,
		closable : true,
		border : false,
		//iconCls: iconCls,
		fit : true,
		content: '<iframe src="' + url + '" allowTransparency="true" style="border:0;width:100%;height:99%;" frameBorder="0"></iframe>'
	};
	
	if (mainTabs.tabs('exists', tabItem.title)) {
		mainTabs.tabs('select', tabItem.title);
		mainTabs.tabs('update', {tab: mainTabs.tabs('getSelected'), options:tabItem});
	} else {
		mainTabs.tabs('add', tabItem);
	}
	tabClose();
}

function logout(){
	$.messager.confirm('确认信息', '你确认要退出当前系统吗？', function(r){
		if (r){
			window.location.href = JXCore.basePath + '/logout';
		}}
	);
}

//进入个人中心
function toUserSpace(){
	addTab('个人中心','/admin/uspace/index');
}

function changeTheme (themeName) {
	var $easyuiTheme = $('#easyuiTheme');
	var url = $easyuiTheme.attr('href');
	var href = url.substring(0, url.indexOf('themes')) + 'themes/' + themeName + '/easyui.css';
	$easyuiTheme.attr('href', href);
	
	var $cssTheme =  $('#cssTheme');
	var cssUrl = $cssTheme.attr('href');
	var cssHref = cssUrl.substring(0, cssUrl.indexOf('skin')) + 'skin/' + themeName + '/css.css';
	$cssTheme.attr('href', cssHref);

	var $iframe = $('iframe');
	if ($iframe.length > 0) {
		for (var i = 0; i < $iframe.length; i++) {
			var ifr = $iframe[i];
			try {
				$(ifr).contents().find('#easyuiTheme').attr('href', href);
				$(ifr).contents().find('#cssTheme').attr('href', cssHref);
			} catch (e) {
				try {
					ifr.contentWindow.document.getElementById('easyuiTheme').href = href;
					ifr.contentWindow.document.getElementById('cssTheme').href = cssHref;
				} catch (e) { }
			}
		}
	}

	JXCore.cookie('easyuiTheme', themeName, {
		expires : 7
	});
}

function fullScreen(){
	if ($.util.supportsFullScreen) {
        if ($.util.isFullScreen()) {
            $.util.cancelFullScreen();
        } else {
            $.util.requestFullScreen();
        }
    } else {
        window.top.showSysMsg("当前浏览器不支持全屏 API，请更换至最新的 Chrome/Firefox/Safari 浏览器或通过 F11 快捷键进行操作。");
    }
}

function showSysMsg(msg){
	$.messager.show({
		title:'提示信息',
		msg:msg,
		timeout:3000,
		showSpeed: 500,
		showType:'slide',
		style:{
			right:'',
			top:document.body.scrollTop+document.documentElement.scrollTop,
			bottom:''
		}
	});
}

function renderFooter(){
	$('#currentUserName').show();
}

function tabClose(){
    /*双击关闭TAB选项卡*/
    var temp = $(".tabs-inner:not(:first)", mainTabs);
    temp.unbind('dblclick');
    temp.dblclick(function(){
        var subtitle = $(this).children("span").text();
		if("我的主页"==subtitle) return;
        mainTabs.tabs('close',subtitle);
    });
	/*右键事件*/
	temp = $(".tabs-inner:not(:first)", mainTabs);
	temp.unbind('contextmenu');
	temp.bind('contextmenu',function(e){
		var subtitle =$(this).children("span").text();
		if("我的主页"==subtitle) return;
        $('#mm').menu('show', {
            left: e.pageX,
            top: e.pageY
        });
		mainTabs.tabs('select',subtitle);
        $('#mm').data("currtab",subtitle);
        return false;
    });
	temp = $(".icon-reload", mainTabs);
	temp.unbind('click');
	temp.click(function(e){//刷新页面
		var subtitle =$(this).prev().text();
		var tab=mainTabs.tabs('getTab', subtitle); 
		for(var i=0;i<tab.find("iframe").length;i++){
			var _refresh_ifram =tab.find("iframe")[i];
			_refresh_ifram.contentWindow.location.href=_refresh_ifram.src;
		}
    });
}

//绑定右键菜单事件
function tabCloseEvent(){
	//重新加载
    $('#mm-reload').click(function(){
        var currtab_title = $('#mm').data("currtab");
        var panel = mainTabs.tabs('getTab', currtab_title).panel('panel');
		var frame = panel.find('iframe');
		try {
			if (frame.length > 0) {
				for (var i = 0; i < frame.length; i++) {
					frame[i].contentWindow.document.write('');
					frame[i].contentWindow.close();
					frame[i].src = frame[i].src;
				}
				if (navigator.userAgent.indexOf("MSIE") > 0) {// IE特有回收内存方法
					try { CollectGarbage(); } 
					catch (e) { }
				}
			}
		} catch (e) { }
    });
	
    //关闭当前
    $('#mm-tabclose').click(function(){
        var currtab_title = $('#mm').data("currtab");
        mainTabs.tabs('close',currtab_title);
    });
    
    //全部关闭
    $('#mm-tabcloseall').click(function(){
        $('.tabs-inner span:not(:first)', mainTabs).each(function(i,n){
            var t = $(n).text();
            mainTabs.tabs('close',t);
        });    
    });
    
    //关闭除当前之外的TAB
    $('#mm-tabcloseother').click(function(){
        var currtab_title = $('#mm').data("currtab");
        $('.tabs-inner span:not(:first)', mainTabs).each(function(i,n){
            var t = $(n).text();
            if(t!=currtab_title){
            	mainTabs.tabs('close',t);
            }
        });    
    });
    
    //关闭当前右侧的TAB
    $('#mm-tabcloseright').click(function(){
        var nextall = $('.tabs-selected', mainTabs).nextAll();
        if(nextall.length==0){
            return false;
        }
        nextall.each(function(i,n){
            var t=$('a:eq(0) span',$(n)).text();
            mainTabs.tabs('close',t);
        });
        return false;
    });
    
    //关闭当前左侧的TAB
    $('#mm-tabcloseleft').click(function(){
        var prevall = $('.tabs-selected', mainTabs).prevAll();
        if(prevall.length==1){
            return false;
        }
		prevall.length=prevall.length-1;
        prevall.each(function(i,n){
            var t=$('a:eq(0) span',$(n)).text();
            mainTabs.tabs('close',t);
        });
        return false;
    });
}
