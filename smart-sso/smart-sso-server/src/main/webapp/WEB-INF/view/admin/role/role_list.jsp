<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="Content-Type" content="text/html; charset=UTF-8"/>
<%@ include file="/WEB-INF/view/common/include.jsp"%>
<script language="javascript">
var role_grid, role_user_grid, role_perm_grid, permTree, setUserDialog;
var role_id, app_id;

//打开应用添加窗口
var addFun = function() {
	var dialog = EasyuiExt.modalDialog({
		title : '添加角色',
		url : '${_path}/admin/role/addRole',
		height: 400,
		buttons : [ {
			text : '提交',
			iconCls: 'icon-ok',
			handler : function() {
				dialog.find('iframe').get(0).contentWindow.submitForm(dialog, role_grid, parent.$);
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
	var row =  $('#role_grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var roleId = row.id;
	var dialog = parent.EasyuiExt.modalDialog({
		title : '编辑应用',
		url : '${_path}/admin/role/editRole?id=' + roleId,
		height: 400,
		buttons : [ {
			text : '提交',
			iconCls: 'icon-ok',
			handler : function() {
				dialog.find('iframe').get(0).contentWindow.submitForm(dialog, role_grid, parent.$);
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

//删除角色
var deleteFun = function() {
	var row =  $('#role_grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var roleId = row.id;
	var roleName = row.name;
	$.messager.confirm('询问', JXCore.formatString('您确定要删除该角色[{0}]吗？', roleName), function(r) {
		if (r) {
			var params = {
				ct : JXCore.getCurrentTime(),
				'id': roleId
			};
			$.post('${_path}/admin/role/delete', params, function(json){
				if(json.success){
					window.top.showSysMsg(json.msg);
					role_grid.datagrid('load',JXCore.serializeForm($('#searchForm')));
				}else{
					window.top.showSysMsg("操作失败：" + json.msg||'');
				}
			},'json');
		}
	});
};

//修改状态
var changeStatus = function(id, name, enable) {
	var row =  $('#role_grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var roleId = row.id;
	var roleName = row.name;
	var enable = row.isEnable;
	$.messager.confirm('询问', JXCore.formatString('您确定要{0}应用[{1}]吗？', enable ? '禁用':'启用', roleName), function(r) {
		if (r) {
			var params = {
				ct : JXCore.getCurrentTime(),
				'id': roleId,
				'isEnable': (enable ? false : true)
			};
			$.post('${_path}/admin/role/enable', params, function(json){
				if(json.success){
					checkStatusChange(enable?false:true);
					window.top.showSysMsg(json.msg);
					role_grid.datagrid('load',JXCore.serializeForm($('#searchForm')));
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
	//角色列表
	role_grid = $('#role_grid').datagrid({
		title : '',
		queryParams: {
			
		},
		url : '${_path}/admin/role/findList',
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
			title : '角色名',
			field : 'name',
			sortable : true
		} , {
			width : '150',
			title : '所属应用',
			align: 'left',
			field : 'appName',
			sortable : true
		} , {
			width : '60',
			title : '顺序号',
			field : 'sort',
			align: 'right',
			sortable : true
		} , {
			width : '150',
			title : '描述',
			field : 'description',
			align: 'left',
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
			width : '130',
			title : '创建时间',
			field : 'create_timestamp',
			sortable : true
		} , {
			width : '130',
			title : '修改时间',
			field : 'last_change_timestamp',
			sortable : true
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
			
			if (role_id && role_id === rowData.id) {
	        	return;
	    	}
			
			var $layout = $('#layout');
            var south = $layout.layout('panel', 'south');
            south.panel('setTitle', JXCore.formatString('角色【<font style="color:red;">{0}</font>】，所属应用【<font style="color:blue;">{1}</font>】', rowData.name, rowData.appName));
            if (south.panel('options').collapsed) {
                $layout.layout('expand', 'south');
            }
			
            role_id = rowData.id;
            app_id = rowData.appId;
			
            loadPermTree();
			
            role_user_grid.datagrid({
            	url: '${_path}/admin/userRole/getRoleUsers',
            	method: 'get',
                queryParams: {roleId: role_id}
            });			
        }
	});
	
	//查询角色人员信息
	role_user_grid = $('#role_user_grid').datagrid({
		title : '',
		striped : true,
		rownumbers : true,
		idField : 'id',
		remoteSort: 'false',
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
            		url : '${_path}/admin/userRole/gotoRoleUser?roleId=' + role_id + '&appId=' + app_id,
            		buttons : [ {
            			text : '确认',
            			iconCls: 'icon-ok',
            			handler : function() {
            				setUserDialog.find('iframe').get(0).contentWindow.setRoleUser(role_user_grid);
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
            	var allRows = role_user_grid.datagrid('getRows');
            	var selectedRows = role_user_grid.datagrid('getSelections'), unselectedIds = [];
            	for(var i=0, len=allRows.length; i<len; i++){
            		if(!$.array.contains(selectedRows, allRows[i], function(sr, ar){ 
						return sr.id == ar.id; 
					})){
            			unselectedIds.push(allRows[i].id);
            		}
            	}
            	
            	var userIds = unselectedIds.join(',');
            	setRoleUser(userIds);
            }
        }],
		onBeforeLoad : function(param) {},
		onLoadSuccess : function(data) {
			role_user_grid.datagrid('uncheckAll');
		},
		loadFilter: function(data, parent){
			if(data.success){
				var result = {};
				result.rows = data.data;
				result.total = data.data.length;
				return result;
			}else{
				window.top.showSysMsg("加载角色人员失败");
				return false
			}
		}
	});
	
	role_perm_grid = $('#role_perm_grid').datagrid({
        fit: true,
        border: false,
        showHeader: false,
        toolbar: [{
	        	id: 'authButton',
	    		disabled: true,
                text: '授权',
                iconCls: 'icon-ok',
                plain: false,
                handler: setRolePerm
        }]
    });
	
	permTree = $('<ul/>');
    $('#role_perm_grid').data().datagrid.dc.body2.append(permTree);
	
});


//查询角色权限信息
var loadPermTree = function(){
	permTree.tree({
		url: JXCore.formatString('${_path}/admin/role/allocate?roleId={0}&appId={1}&ct={2}', 
				role_id, 
				app_id,
				JXCore.getCurrentTime()),
		method: 'get',
		checkbox: true,
		lines: true,
		loadFilter: function(data, parent){
			if(data.success){
				//添加虚拟根节点
				data.data.unshift({id: -1, name:'权限目录', parentId:0});
				return convert(data.data);
			}else{
				window.top.showSysMsg("加载角色权限失败");
				return [];
			}
		},
		onBeforeLoad: function(node, param){
			$('#authButton').linkbutton('disable');
		},
		onLoadSuccess:function(node, data){
			permTree.tree('collapseAll');
			var root = permTree.tree('getRoot');
			permTree.tree('expand', root.target);
			$('#authButton').linkbutton('enable');
		}
	});
	permTree.tree('collapseAll');
};

//角色授权
var setRolePerm = function(){
	var permissionIds = [];
	var selectedPerms = permTree.tree('getChecked',  ['checked','indeterminate']);
	for(var i=0, len=selectedPerms.length; i<len; i++){
		if(selectedPerms[i].id != -1){//过滤虚拟根节点
			permissionIds.push(selectedPerms[i].id);
		}
	}
	
	EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
	$.post('${_path}/admin/role/allocateSave', { permissionIds: permissionIds.join(','), roleId: role_id, appId: app_id }, function(json){
		EasyuiExt.progressBar('close');
		if(json.success){
			window.top.showSysMsg(json.msg);
			loadPermTree();
		}else{
			window.top.showSysMsg("操作失败：" + json.msg);
		}
	},'json');
};

//设置角色人员
var setRoleUser = function(userIds){
	EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
	$.post('${_path}/admin/userRole/setRoleUsers', { 'appId': app_id, 'roleId': role_id, userIds: userIds}, function(json){
		EasyuiExt.progressBar('close');
		if(json.success){
			window.top.showSysMsg("操作成功：成功设置角色人员");
			role_user_grid.datagrid({
				url: '${_path}/admin/userRole/getRoleUsers',
            	method: 'get',
                queryParams: {roleId: role_id}
            });
			if(setUserDialog){
				try{ setUserDialog.dialog('close');	}catch(e){}
			}
		}else{
			window.top.showSysMsg("操作失败：" + json.resultMsg||'');
		}
	}, 'json');
};

//将权限列表转换成权限树
var convert = function(rows){
	function exists(rows, parentId){
		for(var i=0; i<rows.length; i++){
			if (rows[i].id == parentId) return true;
		}
		return false;
	}
	
	var nodes = [];
	// get the top level nodes
	for(var i=0; i<rows.length; i++){
		var row = rows[i];
		if (!exists(rows, row.parentId)){
			nodes.push({ 
				id: row.id, 
				text: row.name, 
				checked: row.checked
			});
		}
	}
	
	var toDo = [];
	for(var i=0; i<nodes.length; i++){
		toDo.push(nodes[i]);
	}
	while(toDo.length){
		// the parent node
		var node = toDo.shift(); 
		
	    // get the children nodes
		for(var i=0; i<rows.length; i++){
			var row = rows[i];
			if (row.parentId == node.id){
				var child = {
						id:row.id, 
						text:row.name, 
						checked: row.checked
				};
				if (node.children){
					node.children.push(child);
				} else {
					node.children = [child];
				}
				if(node.children && node.children.length>0){
					node.checked = false;
				}
				toDo.push(child);
			}
		}
	}
	return nodes;
};

</script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false" id="layout">
	<div id="toolbar"  class="easyui-toolbar" style="display: none;">
		<form id="searchForm" style="margin-top:2px;">
			<table class="search-form-table">
				<tr>
					<th>
						角色名称:
					</th>
					<td>
						<input name="name" style="width: 135px;" />
					</td>
					<td>
						<label>&nbsp; 应用:</label>
						<select name="appId">
							<option value="">--请选择--</option>
							<c:forEach items="${apps }" var="app">
								<option value="${app.id }">${app.name }</option>
							</c:forEach>
						</select>
					</td>
					<td style="padding-left: 15px;">
						<label for="isEnable1"><input type="radio" name="isEnable" id="isEnable1" value="true"/>启用</label> 
						<label for="isEnable2"><input type="radio" name="isEnable" id="isEnable2" value="false"/>禁用</label> 
					</td>
					<td style="padding-left: 10px;">
						<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'ext-icon-zoom'" onclick="role_grid.datagrid('load',JXCore.serializeForm($('#searchForm')));">过滤</a>
						<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'ext-icon-zoom_out'" onclick="$('#searchForm input[type=radio]').attr('checked',false);$('#searchForm input[type!=radio]').val('');role_grid.datagrid('load',{});">重置</a>
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
		<table id="role_grid" data-options="fit:true,border:false"></table>
	</div>
	<div data-options="region:'south',border:true" style="height: 300px;padding: 2px; margin-left: 2px;" title="角色详情" collapsed="true" split='true'>
        <div class="easyui-layout" fit="true">
            <div region="west" style="width: 400px;">
                <div class="easyui-panel" fit="true" border="false" title="角色的权限">
                	<table id="role_perm_grid"></table>
                </div>
            </div>
            <div region="center" title="角色的成员" style="border-left: none;">
                <table id="role_user_grid"  data-options="fit:true,border:false"></table>
            </div>
        </div>
    </div>
</body>
</html>