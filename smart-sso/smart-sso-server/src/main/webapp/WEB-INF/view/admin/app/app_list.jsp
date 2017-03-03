<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="Content-Type" content="text/html; charset=UTF-8"/>
<%@ include file="/WEB-INF/view/common/include.jsp"%>
<script language="javascript">
var grid,app_user_grid;
var app_id;
//打开应用添加窗口
var addFun = function() {
	var dialog = EasyuiExt.modalDialog({
		title : '添加应用',
		url : '${_path}/admin/app/goto_add',
		height: 400,
		buttons : [ {
			text : '提交',
			iconCls: 'icon-ok',
			handler : function() {
				dialog.find('iframe').get(0).contentWindow.submitForm(dialog, grid, parent.$);
			}
		},{
			text : '关闭',
			iconCls: 'icon-cancel',
			handler : function() {
				dialog.dialog('close');
			}
		} ]
	});
};


//打开应用编辑窗口
var editFun = function() {
	var row =  $('#grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var appId = row.id;
	var dialog = parent.EasyuiExt.modalDialog({
		title : '编辑应用',
		url : '${_path}/admin/app/goto_edit?id=' + appId,
		height: 400,
		buttons : [ {
			text : '提交',
			iconCls: 'icon-ok',
			handler : function() {
				dialog.find('iframe').get(0).contentWindow.submitForm(dialog, grid, parent.$);
			}
		},{
			text : '关闭',
			iconCls: 'icon-cancel',
			handler : function() {
				dialog.dialog('close');
			}
		} ]
	});
};

//删除应用
var deleteFun = function() {
	var row =  $('#grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var appId = row.id;
	var appName = row.name;
	$.messager.confirm('询问', JXCore.formatString('您确定要删除应用[{1}]吗？', appName), function(r) {
		if (r) {
			var params = {
				ct : JXCore.getCurrentTime(),
				'id': appId
			};
			$.post('${_path}/admin/app/delete', params, function(json){
				if(json.success){
					window.top.showSysMsg("操作成功：成功删除");
					grid.datagrid('load',JXCore.serializeForm($('#searchForm')));
				}else{
					window.top.showSysMsg("操作失败：" + json.msg||'');
				}
			},'json');
		}
	});
};

//修改状态
var changeStatus = function(id, name, enable) {
	var row =  $('#grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var appId = row.id;
	var appName = row.name;
	var enable = row.isEnable;
	$.messager.confirm('询问', JXCore.formatString('您确定要{0}应用[{1}]吗？', (enable ? '禁用':'启用'), appName), function(r) {
		if (r) {
			var params = {
				ct : JXCore.getCurrentTime(),
				'id': appId,
				'isEnable': (enable ? false : true)
			};
			$.post('${_path}/admin/app/enable', params, function(json){
				if(json.success){
					checkStatusChange(enable?false:true);
					window.top.showSysMsg("操作成功：成功改变应用状态");
					grid.datagrid('load',JXCore.serializeForm($('#searchForm')));
				}else{
					window.top.showSysMsg("操作失败：" + json.msg||'');
				}
			},'json');
		}
	});
};

var checkStatusChange = function(status){
	if(status){
		$('#disabledButton').show();
		$('#enableButton').hide();
	}else{
		$('#disabledButton').hide();
		$('#enableButton').show();
	}
}


$(function() {
	//应用列表
	grid = $('#grid').datagrid({
		title : '',
		queryParams: {
			
		},
		url : '${_path}/admin/app/load',
		method : 'get',
		striped : true,
		rownumbers : true,
		pagination : true,
		singleSelect : true,
		idField : 'id',
		sortName : 'sort',
		sortOrder : 'asc',
		pageSize : 20,
		pageList : [ 10, 20, 50, 100],
		columns : [ [{checkbox: true},
		{
			width : '150',
			title : '应用名称',
			field : 'name',
			sortable : true
		}, {
			width : '150',
			title : '应用编码',
			field : 'code',
			sortable : true
		} , {
			width : '60',
			title : '顺序号',
			field : 'sort',
			align: 'right',
			sortable : true
		} , {
			width : '60',
			title : '状态',
			field : 'isEnable',
			align : 'center',
			formatter : function(value, row, index) {
				if(value == true){
					return '启用';
				}else if(value == false){
					return '禁用';
				}
			}
		} , {
			width : '120',
			title : '创建时间',
			field : 'createTime'
		}] ],
		toolbar : '#toolbar',
		loadFilter: function(data){
			var result = {};
			if(data.success){
				result.rows = data.data.list;
				result.total = data.data.rowCount;
				result.footer = data.data.rowCount;
			}else{
				window.top.showSysMsg(data.msg);
				result.rows = [];
				result.total = 0;
			}
			return result;
		},
		onBeforeLoad : function(param) {},
		onLoadSuccess : function(data) {
			$('.iconImg').attr('src', JXCore.pixel_0);
		},
		onClickRow: function(rowIndex, rowData) {
			checkStatusChange(rowData.isEnable);
			
			if (app_id && app_id === rowData.id) {
	        	return;
	    	}

			var $layout = $('#layout');
            var south = $layout.layout('panel', 'east');
            south.panel('setTitle', JXCore.formatString('应用【<font style="color:red;">{0}</font>】', rowData.name));
            if (south.panel('options').collapsed) {
                $layout.layout('expand', 'east');
            }
			
            app_id = rowData.id;
			
            app_user_grid.datagrid({
            	url: '${_path}/admin/user/getAppUsers',
            	method: 'get',
                queryParams: {appId: app_id}
            });			
        }
	});
	
	app_user_grid = $('#app_user_grid').datagrid({
		title : '',
		striped : true,
		rownumbers : true,
		idField : 'id',
		remoteSort: 'false',
		pageSize : 10,
		pageList : [10, 20, 50, 100],
		pagination : true,
		columns : [ [
		{checkbox: true},
		{
			width : '120',
			title : '工号',
			field : 'jobNo'
		}, {
			width : '120',
			title : '姓名',
			field : 'userName'
		}] ],
		toolbar: [{
            text: '增加成员',
            iconCls: 'icon-add',
            handler: function(){
            	setUserDialog = EasyuiExt.modalDialog({
            		title : '选择人员',
            		url : '${_path}/admin/userApp/gotoAppUsers?appId=' + app_id,
            		buttons : [ {
            			text : '确认',
            			iconCls: 'icon-ok',
            			handler : function() {
            				setUserDialog.find('iframe').get(0).contentWindow.setAppUsers(app_user_grid);
            			}
            		},{
            			text : '取消',
            			iconCls: 'icon-cancel',
            			handler : function() {
            				setUserDialog.dialog('close');
            			}
            		} ]
            	});
            }
        }, {
            text: '移除人员',
            iconCls: 'ext-icon-action_remove',
            handler: function(){
            	var allRows = app_user_grid.datagrid('getRows');
            	var selectedRows = app_user_grid.datagrid('getSelections'), unselectedIds = [];
            	for(var i=0, len=allRows.length; i<len; i++){
            		if(!$.array.contains(selectedRows, allRows[i], function(sr, ar){ 
						return sr.id == ar.id; 
					})){
            			unselectedIds.push(allRows[i].id);
            		}
            	}
            	var userIds = unselectedIds.join(',');
            	setAppUsers(userIds);
            }
        }],
		onBeforeLoad : function(param) {},
		onLoadSuccess : function(data) {
			app_user_grid.datagrid('uncheckAll');
		},
		loadFilter: function(data){
			var result = {};
			if(data.success){
				debugger
				var result = {};
				result.rows = data.data.list;
				result.total = data.data.rowCount;
				result.footer = data.data.pageSize;
			}else{
				window.top.showSysMsg(data.msg);
				result.rows = [];
				result.total = 0;
			}
			return result;
		}
	});
});
//设置角色人员
var setAppUsers = function(userIds){
	EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
	$.post('${_path}/admin/userApp/setAppUsers', { 'appId': app_id,userIds: userIds}, function(json){
		EasyuiExt.progressBar('close');
		if(json.success){
			window.top.showSysMsg("操作成功：成功设置应用人员");
			app_user_grid.datagrid({
				url: '${_path}/admin/user/getAppUsers',
            	method: 'get',
                queryParams: {appId: app_id}
            });
			if(setUserDialog){
				try{ setUserDialog.dialog('close');	}catch(e){}
			}
		}else{
			window.top.showSysMsg("操作失败：" + json.resultMsg||'');
		}
	}, 'json');
};
</script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false" id="layout">
	<div id="toolbar"  class="easyui-toolbar" style="display: none;">
		<form id="searchForm" style="margin-top:2px;">
			<table class="search-form-table">
				<tr>
					<th>
						应用名称
					</th>
					<td>
						<input name="name" style="width: 135px;" />
					</td>
					<td style="padding-left: 10px;">
						<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'ext-icon-zoom'" onclick="grid.datagrid('load',JXCore.serializeForm($('#searchForm')));">过滤</a>
						<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'ext-icon-zoom_out'" onclick="$('#searchForm input[type=radio]').attr('checked',false);$('#searchForm input[type!=radio]').val('');grid.datagrid('load',{});">重置</a>
					</td>
				</tr>
			</table>
			
			<hr class="line-sep"/>
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="addFun();">添加</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="editFun();">编辑</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-remove'" onclick="deleteFun();">刪除</a>
			<a href="javascript:void(0);" style="display: none;" id="disabledButton" class="easyui-linkbutton" data-options="iconCls:'ext-icon-lock_add'" onclick="changeStatus();">禁用</a>
			<a href="javascript:void(0);" id="enableButton" class="easyui-linkbutton" data-options="iconCls:'ext-icon-lock_break'" onclick="changeStatus();">启用</a>
			
		</form>
	</div>
	<div data-options="region:'center',fit:true,border:false">
		<table id="grid" data-options="fit:true,border:false"></table>
	</div>
	<div data-options="region:'east',border:true" style="width:800px;padding: 2px; margin-left: 2px;" title="应用详情" collapsed="true" split='true'>
        <div class="easyui-layout" fit="true">
            <div region="center" title="包含的人员" style="border-left: none;">
                <table id="app_user_grid"  data-options="fit:true,border:false"></table>
            </div>
        </div>
    </div>
</body>
</html>