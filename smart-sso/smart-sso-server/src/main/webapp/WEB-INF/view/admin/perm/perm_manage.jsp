<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="/WEB-INF/view/common/include.jsp"></jsp:include>

<script type="text/javascript">
var countRelaUrl = 0;
$(function(){
	//初始化应用选择框	
	$('#appIdField').combobox({
		onChange: function(nv, ov){
			loadTreeNodes(nv);
		}
	});

	//初始化权限权树
	loadTreeNodes();
});

var setting = {
	edit: {
		enable: true,
		showRemoveBtn: false,
		showRenameBtn: false
	},
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
		dblClickExpand: dblClickExpand ,
		addHoverDom: addHoverDom,
		removeHoverDom: removeHoverDom,
		selectedMulti: false
	},
	callback: { 
		onClick: onClick,
		beforeDrag:function(){return false;} 
	}
};

function loadTreeNodes(appId){
	if(JXCore.isEmpty(appId)){
		appId = $('input[name="appIdField"]').val();
	}
	if(JXCore.isEmpty(appId)) return;
	
	$('#appId').val(appId);
	$.getJSON("${_path}/admin/permission/nodes", {appId: appId, 'ct': (new Date()).getTime()}, function(json){
		if(json.success){
			var list = [];
			list.push({
				id: -1,
				name: '根节点',
				code: '',
				open: true,
				isMenu: true,
				isEnable: true,
				icon: '${_path}/resources/style/images/icons/root.gif'
			});
			for(var i=0; i<json.data.length; i++){
				var item = {};
				item.id = json.data[i].id;
				item.parentId = json.data[i].parentId;
				item.appId = json.data[i].appId;
				item.name = json.data[i].name;
				item.code = json.data[i].code;
				item.urlStr = json.data[i].urlStr;
				item.rela_url = json.data[i].rela_url;
				item.sort = json.data[i].sort;
				item.path_menu = json.data[i].path_menu;
				item.isMenu = json.data[i].isMenu;
				if(item.isMenu){
					item.icon = '${_path}/resources/style/images/icons/menu.gif'
				}else{
					item.icon = '${_path}/resources/style/images/icons/button.gif'
				}
				item.isEnable = json.data[i].isEnable;
				list.push(item);
			}
			$.fn.zTree.init($("#treeZone"), setting, list);
		}else{
			window.top.showSysMsg(json.msg || "加载权限信息失败!");
		}
	});
}

function dblClickExpand(treeId, treeNode) {
	return treeNode.level_no > 0;
}

function onClick(event, treeId, treeNode,clickFlag) {
	if(treeNode.id == -1){
		$('#modeMsg').empty();
		$('#saveBtn').linkbutton('disable');
	}else{
		changeMode('update');
	}
	$("input[name='id']").val(treeNode.id);
	$("input[name='name']").val(treeNode.name);
	$("input[name='code']").val(treeNode.code);
	$("input[name='isEnable'][value="+treeNode.isEnable+"]").attr("checked",true);
	$("input[name='isMenu'][value="+treeNode.isMenu+"]").attr("checked",true);
	$("input[name='path_menu'][value="+treeNode.path_menu+"]").attr("checked",true);
	changePermType(treeNode.path_menu);
	$("input[name='sort']").val(treeNode.sort);
	$("input[name='url']").val(treeNode.urlStr);
	
	var rela_url = treeNode.rela_url;
	var relaList = [];
	if(!JXCore.isEmpty(rela_url)){
		relaList = rela_url.split(',');
	}
	//处理相关URL
	if(relaList.length == 0){//相关URL为空时处理
		var relaUrlHtml = '<span id="rela_url_0">'
			+ '<input name="relaUrls" value="" maxlength="400" size="50" />&nbsp;'
			+ '<img src="${_path}/resources/style/images/icons/add.gif" onclick="addRelaUrl();" title="点击增加一行"></img><br/></span>';
		$('#td_rela_url').html(relaUrlHtml);
	}else{
		for(var i=0;i<relaList.length;i++){
			if(i == 0){
				var relaUrlHtml = '<span id="rela_url_0">'
					+ '<input name="relaUrls" value="'+relaList[i]+'" maxlength="400" size="50" />&nbsp;'
					+ '<img src="${_path}/resources/style/images/icons/add.gif" onclick="addRelaUrl();" title="点击增加一行"></img><br/></span>';
				$('#td_rela_url').html(relaUrlHtml);
			}else{
				var urlHtml = '<span id="rela_url_'+ i +'">'
					+ '<input name="relaUrls"  value="'+relaList[i]+'" maxlength="400" size="50" />&nbsp;'
					+ '<img src="${_path}/resources/style/images/icons/delete.png" onclick="delRelaUrl(' + i + ');" title="点击移除此行"></img><br/></span>';
				$('#td_rela_url').append(urlHtml);			
			}
		}
	}
	
	var pn = treeNode.getParentNode();
	$("input[name='parentId']").val(pn!=null ? pn.id : '');
	$("input[name='parentName']").val(pn!=null ? pn.name : '');
	$("#parentCode").val(pn!=null ? pn.code : '');
	event.stopPropagation();
}

function addHoverDom(treeId, treeNode) {
	var sObj = $("#" + treeNode.tId + "_span");
	if (treeNode.editNameFlag || $("#addBtn_"+treeNode.id).length>0) return;
	var addStr = "<span class='button add' id='addBtn_" + treeNode.id + "' title='添加权限' onfocus='this.blur();'></span>";
	sObj.after(addStr);
	var btn = $("#addBtn_"+treeNode.id);
	if (btn) btn.bind("click", function(event){
		$.fn.zTree.getZTreeObj("treeZone").selectNode(treeNode);
		changeMode('insert',treeNode);
		$("input[name='parentName']").val(treeNode.name);
		$("input[name='parentId']").val(treeNode.id);
		$("input[name='parentCode']").val(treeNode.code);
		
		$("input[name='id']").val('');
		$("input[name='name']").val('');
		$("input[name='code']").val(treeNode.code);
		$("input[name='isEnable'][value=true]").attr("checked",true);
		$("input[name='isMenu'][value=true]").attr("checked",true);
		$("input[name='path_menu'][value=true]").attr("checked",true);
		changePermType(true);
		$("input[name='sort']").val('');
		$("input[name='url']").val('');
		$("input[name='remark']").val('');
		
		
		//处理相关URL
		var relaUrlHtml = '<span id="rela_url_0">'
			+ '<input name="relaUrls" value="" maxlength="400" size="50" />&nbsp;'
			+ '<img src="${_path}/resources/style/images/icons/add.gif" onclick="addRelaUrl();" title="点击增加一行"></img><br/></span>';
		$('#td_rela_url').html(relaUrlHtml);
		countRelaUrl = 0;
		
		event.stopPropagation();
	});
};
function removeHoverDom(treeId, treeNode) {
	$("#addBtn_"+treeNode.id).unbind().remove();
};

//控制操作模式
function changeMode(mode){
	var modeMsg = '编辑模式';
	if(mode == 'insert'){
		modeMsg = '创建模式';
	}
	var saveBtn = 1;
	var childrens = $.fn.zTree.getZTreeObj("treeZone").getSelectedNodes(true)[0].children;
	if(childrens == undefined && mode != 'insert'){
 		$('#deleteBtn').linkbutton('enable');
 	}else{
 		$('#deleteBtn').linkbutton('disable');
 	}
	
	$('#checkType').val(mode);
	$('#saveBtn').linkbutton('enable');
	$('#modeMsg').empty().append(modeMsg);
}

//控制路径菜单的权限类型不能是“按钮”
function changePermType(path_menu){
	if(path_menu){
		$("input[name='isMenu'][value=true]").attr("checked",true);
		$('#permType2').css('color','gray');
		$("input[name='isMenu'][value=false]").attr("disabled",true);
	}else{
		$('#permType2').css('color','');
		$("input[name='isMenu'][value=false]").attr("disabled",false);
	}
}

//控制相关URL
function addRelaUrl(){
	countRelaUrl++;
	var urlHtml = '<span id="rela_url_'+countRelaUrl+'">'
		+ '<input name="relaUrls" maxlength="400" size="50" />&nbsp;'
		+ '<img src="${_path}/resources/style/images/icons/delete.png" onclick="delRelaUrl('+countRelaUrl+');" title="点击移除此行"></img><br/></span>';
	$('#td_rela_url').append(urlHtml);			
}
function delRelaUrl(num){
	$('#rela_url_'+num).remove();			
}

//验证权限编码唯一性
var checkCode = function() {
	var valid = true;
	var checkType = $("#checkType").val();
	var params = {
		'code':$('#code').val(),
		'parentId': $('#parentId').val(),
		'appId' : $('input[name="appIdField"]').val(),
		'ct': (new Date()).getTime()
	};
	if(checkType=='update') params['id'] = $('#id').val();
	
	$.ajaxSetup({async: false});
	$.post('${_path}/admin/permission/check_code', params, function(json){
		valid=json.data.valid;
	}, 'json');
	$.ajaxSetup({async: true});
	
	return valid;
};

//验证名称唯一性
var checkName = function() {
	var valid = true;
	var checkType = $("#checkType").val();
	var params = {
			'name': $('#name').val(),
			'parentId': $('#parentId').val(),
			'appId' : $('input[name="appIdField"]').val(),
			'ct': (new Date()).getTime()
		};
		
		if(checkType == 'update'){
			params['id'] = $('#id').val();
		}
	
	$.ajaxSetup({async: false});
	$.post('${_path}/admin/permission/check_name', params, function(json){
		valid=json.data.valid;
	}, 'json');
	$.ajaxSetup({async: true});
	
	return valid;
};

//添加或修改权限
var submitForm = function() {
	if(validateFormByLV()){
		$.post($('#form').attr('action'), JXCore.serializeForm($('#form')), function(json) {
			if(json.success){
				window.top.showSysMsg("操作成功：成功保存权限信息");
				loadTreeNodes();
			}else{
				window.top.showSysMsg("操作失败：" + json.msg||'保存权限过程失败');
			}
		}, 'json');
	}
};

//删除权限
function deletePerm(){
	var treeObj = $.fn.zTree.getZTreeObj("treeZone");
	var node = treeObj.getSelectedNodes(true)[0];
	var appId = $('#appId').val();
	$.post("${_path}/admin/permission/delete",{'id': node.id, appId: appId},function (json){
		if(json.success){
			window.top.showSysMsg("操作成功：成功删除权限信息");
			loadTreeNodes();
		}else{
			window.top.showSysMsg("操作失败：" + json.msg||'删除权限操作失败');
		}
	}, 'json');
}

//同步权限
function syncPerm(){
	$.post("${_path}/admin/app/sync/permissions",{code:  $('input[name="appIdField"]').val()},function (json){
		if(json.success){
			window.top.showSysMsg(json.msg);
		}else{
			window.top.showSysMsg("操作失败：" + json.msg);
		}
	}, 'json');
}
</script>
<style type="text/css">
.ztree li span.button.add {margin-left:2px; margin-right: -1px; background-position:-144px 0; vertical-align:top; *vertical-align:middle}
.ztree li span.button.switch.level0 {visibility:hidden; width:1px;}
.ztree li ul.level0 {padding:0; background:none;}
</style>
</head>
<body class="easyui-layout" style="margin:3px;height:99%;" >
	<div data-options="region:'west',split:true,border:true" style="width:280px;">
		<div class="search" style="margin-top:5px; margin-left:5px;">
			<label>所属应用</label>
			<select id="appIdField" name="appIdField" style="width: 150px;">
				<c:forEach var="item" items="${appList}">
					<option value="${item.id}">${item.name}</option>
				</c:forEach>
			</select>
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" id="syncBtn" onclick="javascript:syncPerm();">同步</a>
		</div>
		<ul id="treeZone" class="ztree"></ul>
	</div>
	<div data-options="region:'center',border:true" style="padding:5px;">
		<form action="${_path}/admin/permission/save" id="form" method="post">
			<div class="form-table">
				<table>
					<tr>
						<th>操作模式</th>
						<td colspan="3">
							<font id="modeMsg" style="font-weight: bold; font-size: medium;"></font>
							<input type="hidden" name="checkType" id="checkType" /></td>
					</tr>
					<tr>
						<th>父节点</th>
						<td colspan="3">
							<input type="text" name="parentName" id="parentName" readonly="readonly" class="unenterTextbox" />
							<input type="hidden" name="parentId" id="parentId" />
							<input type="hidden" name="parentCode" id="parentCode"/>
							<input type="hidden" name="appId" id="appId"/>
						</td>
					</tr>
					<tr>
						<th><font>*</font>权限名称</th>
						<td colspan="3">
							<input type="text" name="name" class="LV_notNull LV_custom" customMethod="checkName" customFailMsg="在同一父节点下，权限名称不能重复" id="name" /> 
						</td>
					</tr>
					<tr id="tr_code">
						<th><font>*</font>权限编码</th>
						<td colspan="3">
							<input type="text" name="code" class="LV_notNull LV_custom" customMethod="checkCode" customFailMsg="权限编码已经存在" maxlength="100" id="code"/>
							<input type="hidden" name="id" id="id"/>
						</td>
					</tr>
					<tr>
						<th><font>*</font>权限状态</th>
						<td colspan="3">
							<label>
								<input type="radio" name="isEnable" value="true" checked="checked" />启用</label>
							&nbsp;&nbsp; 
							<label>
								<input type="radio" name="isEnable" value="false" />禁用</label>
						</td>
					</tr>
					<tr>
						<th><font>*</font>路径菜单</th>
						<td colspan="3">
							<label>
								<input type="radio" name="path_menu" value="true" onclick="changePermType(true)"/>是</label>
							&nbsp;&nbsp; 
							<label>
								<input type="radio" name="path_menu" value="false" onclick="changePermType(false)" checked="checked"/>否</label>
						</td>
					</tr>
					<tr>
						<th><font>*</font>权限类型</th>
						<td colspan="3">
							<label>
								<input type="radio" name="isMenu" value="true" checked="checked" />菜单</label>
							&nbsp;&nbsp; 
							<label id="permType2" >
								<input type="radio" name="isMenu" value="false" />按钮</label>
						</td>
					</tr>
					<tr>
						<th><font>*</font>顺序号</th>
						<td colspan="3">
							<input type="text" class="LV_notNull LV_numberic" name="sort" id="sort" />
						</td>
					</tr>
					<tr id="tr_url">
						<th>访问URL</th>
						<td colspan="3"><input name="url" id="url" maxlength="400" size="50" /></td>
					</tr>
					<tr id="tr_rela_url">
						<th style="vertical-align: middle;">相关URL</th>
						<td colspan="3" id="td_rela_url">
							<span id="rela_url_0">
								<input name="relaList[0]" maxlength="400" size="50" />
								<img src="${_path}/resources/style/images/icons/add.gif" onclick="addRelaUrl();" title="点击增加一行"></img><br />
							</span>
						</td>
					</tr>
					<tr>
						<th>备注说明</th>
						<td colspan="3"><input name="remark" id="remark" maxlength="150" size="50" /></td>
					</tr>
				</table>
			</div>
		</form>
		<div id="toolbar"  class="easyui-toolbar">
    		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="disabled:true,iconCls:'icon-ok'" id="saveBtn" onclick="javascript:submitForm();">保存</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="disabled:true,iconCls:'ext-icon-action_delete'" id="deleteBtn"  onclick="javascript:deletePerm();">删除</a>
    	</div>
	</div>
</body>
</html>
