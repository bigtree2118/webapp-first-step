<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>锋面雨综合权限管理系统</title>
<meta name="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="generator" content="Bigtree"/>
<style type="text/css">
html,body { overflow: hidden; }
#north-region{ background:url('${_path}/resources/style/images/top-background.jpg') repeat-x; }
#systemName{ background:url('${_path}/static/image/system_title.png') no-repeat; }
.ztree span {font-size: 15px;}
</style>
</head>
<body id="mainLayout" class="easyui-layout">
	<div data-options="region:'north',href:''" style="height: 40px; overflow: hidden;" id="north-region">
		<div id='systemName' style="width: 100%; height: 100%;"></div>
		<div style="position: absolute; right: 0px; bottom: 0px;">
			<a href="javascript:toUserSpace();" class="l-btn l-btn-small l-btn-plain m-btn m-btn-small">
				<span class="l-btn-left l-btn-icon-left">
					<span class="l-btn-text">个人中心</span>
					<span class="l-btn-icon ext-icon-user">&nbsp;</span>
					<span class="m-btn-line"></span>
				</span>
			</a>
			<a href="javascript:void(0);" class="easyui-menubutton" data-options="menu:'#layout_north_kzmbMenu',iconCls:'ext-icon-cog'">控制中心</a>
			<a href="javascript:logout();" class="l-btn l-btn-small l-btn-plain m-btn m-btn-small">
				<span class="l-btn-left l-btn-icon-left">
					<span class="l-btn-text">退出系统</span>
					<span class="l-btn-icon ext-icon-door_out">&nbsp;</span>
					<span class="m-btn-line"></span>
				</span>
			</a>
		</div>
		<div id="layout_north_kzmbMenu" style="width: 100px; display: none;">
			<div data-options="iconCls:'ext-icon-arrow_inout'" onclick="fullScreen();">全屏切换</div>
			<div class="menu-sep"></div>
			<div data-options="iconCls:'ext-icon-rainbow'">
				<span>切换皮肤</span>
				<div style="width: 120px;">
					<div onclick="changeTheme('metro-standard');" title="metro-standard">磁性-标准</div>
					<div onclick="changeTheme('metro-green');" title="metro-green">磁性-绿色</div>
					<div onclick="changeTheme('metro-red');" title="metro-red">磁性-红色</div>
					<div class="menu-sep"></div>
					<div onclick="changeTheme('ui-cupertino');" title="ui-cupertino">清泉</div>
					<div onclick="changeTheme('ui-pepper-grinder');" title="ui-pepper-grinder">杏黄</div>
					<div onclick="changeTheme('ui-sunny');" title="ui-sunny">阳光</div>
					<div class="menu-sep"></div>
					<div onclick="changeTheme('blue');" title="blue">蓝色</div>
					<div onclick="changeTheme('black');" title="black">黑色</div>
					<div onclick="changeTheme('silver');" title="silver">银色</div>
				</div>
			</div>
		</div>
	</div>
	<div data-options="region:'west',href:'',split:true, iconCls:'ext-icon-application_home'" title="导航栏" style="width: 220px; padding: 1px;">
        <div id="navTabs" class="easyui-tabs" data-options="fit: true, border: false, tools: '#navTabs_tools'">
        	<div data-options="title: '导航菜单', refreshable: false, selected: true,iconCls:'ext-icon-application_view_tile'">
                <div class="search" style="margin-top:3px; margin-left:5px;">
					<input id="right_name" class="easyui-searchbox" data-options="prompt:'输入菜单名称，模糊查询',searcher:searchRight" style="width:155px;"></input>
			    </div>
				<ul id="treeRight" class="ztree"></ul>
            </div>
            <div data-options="title: '个人收藏', refreshable: false, selected: true,iconCls:'ext-icon-star'">
				<ul id="favoMenu_Tree" class="ztree" style="padding-top: 2px; padding-bottom: 2px;"></ul>
            </div>
        </div>
	</div>
	<div data-options="region:'center'" style="overflow: hidden;">
		<div id="mainTabs">
			<div title="我的主页" data-options="iconCls:'ext-icon-mydesktop'">
				<iframe id='centerIframe' src="" allowTransparency="true" style="border: 0; width: 100%; height: 99%;" frameBorder="0"></iframe>
			</div>
		</div>
	</div>
	<div id="mm" class="easyui-menu" style="width:150px; display:none">
		<div id="mm-reload">重新加载</div>
		<div class="menu-sep"></div>
	    <div id="mm-tabclose">关闭标签页</div>
	    <div id="mm-tabcloseall">关闭全部标签页</div>
	    <div id="mm-tabcloseother">关闭其他标签页</div>
	    <div id="mm-tabcloseright">关闭右侧标签页</div>
	    <div id="mm-tabcloseleft">关闭左侧标签页</div>
	</div>
	<div data-options="region:'south',href:'',border:false" style="height: 20px; overflow: hidden;">
		<span id="currentUserName">
			当前用户：${_sessionProfile.userName}
		</span>
	</div>
	<%@ include file="/WEB-INF/view/common/include.jsp"%>
	<script type="text/javascript" src="${_path}/static/js/admin/index.js"></script>
</body>
</html>