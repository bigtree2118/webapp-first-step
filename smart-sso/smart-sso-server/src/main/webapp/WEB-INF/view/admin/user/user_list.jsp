<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="Content-Type" content="text/html; charset=UTF-8"/>
<%@ include file="/WEB-INF/view/common/include.jsp"%>
<script>
var grid;
//打开人员添加窗口
var addFun = function() {
	var dialog = EasyuiExt.modalDialog({
		title : '添加人员',
		url : '${_path}/admin/user/goto_add',
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


//打开人员编辑窗口
var editFun = function() {
	var row =  $('#grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var appId = row.id;
	var dialog = parent.EasyuiExt.modalDialog({
		title : '编辑人员',
		url : '${_path}/admin/user/goto_edit?id=' + appId,
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

//删除人员
var deleteFun = function() {
	var row =  $('#grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var appId = row.id;
	var userName = row.userName;
	$.messager.confirm('询问', JXCore.formatString('您确定要删除人员[{0}]吗？', userName), function(r) {
		if (r) {
			var params = {
				ct : JXCore.getCurrentTime(),
				'id': appId
			};
			$.post('${_path}/admin/user/delete', params, function(json){
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
	var appName = row.account;
	var enable = row.isEnable;
	$.messager.confirm('询问', JXCore.formatString('您确定要{0}账号[{1}]吗？', enable ? '禁用':'启用', appName), function(r) {
		if (r) {
			var params = {
				ct : JXCore.getCurrentTime(),
				'id': appId,
				'isEnable': (enable ? false : true)
			};
			$.post('${_path}/admin/user/enable', params, function(json){
				if(json.success){
					checkStatusChange(enable?false:true);
					window.top.showSysMsg("操作成功：成功改变人员状态");
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

//重置密码
var resetPassword = function() {
	var row =  $('#grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var appId = row.id;
	var userName = row.userName;
	$.messager.confirm('询问', JXCore.formatString('您确定要重置[{0}]的密码吗？', userName), function(r) {
		if (r) {
			var params = {
				ct : JXCore.getCurrentTime(),
				'ids': appId
			};
			$.post('${_path}/admin/user/resetPassword', params, function(json){
				if(json.success){
					window.top.showSysMsg("操作成功：成功重置");
					grid.datagrid('load',JXCore.serializeForm($('#searchForm')));
				}else{
					window.top.showSysMsg("操作失败：" + json.msg||'');
				}
			},'json');
		}
	});
};

//分配应用
var allocateApp = function() {
	var row =  $('#grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var userId = row.id;
	var dialog = parent.EasyuiExt.modalDialog({
		title : '分配应用',
		url : '${_path}/admin/userApp/allocate?userId=' + userId,
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

//分配角色
var allocateRole = function() {
	var row =  $('#grid').datagrid('getSelected');
	if(row==null){
		window.top.showSysMsg("请先选择一条记录");
		return;
	}
	var userId = row.id;
	var dialog = parent.EasyuiExt.modalDialog({
		title : '分配应用',
		url : '${_path}/admin/userRole/allocate?userId=' + userId,
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

$(function() {
	//人员列表
	grid = $('#grid').datagrid({
		title : '',
		queryParams: {
			
		},
		url : '${_path}/admin/user/load',
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
			width : '80',
			title : '工号',
			field : 'jobNo',
			sortable : true
		},
		{
			width : '150',
			title : '登录账号',
			field : 'account',
			sortable : true
		}, {
			width : '150',
			title : '姓名',
			field : 'userName',
			sortable : true
		} , {
			width : '60',
			title : '性别',
			field : 'gender',
			align : 'center',
			formatter : function(value, row, index) {
				if(value == 1){
					return '男';
				}else if(value == 2){
					return '女';
				}
			},
			sortable : true
		} ,{
			width : '150',
			title : '邮箱',
			field : 'email',
			sortable : false
		} ,{
			width : '150',
			title : '手机号码',
			field : 'cellPhone',
			sortable : false
		} , {
			width : '250',
			title : '地址',
			field : 'address',
			sortable : false
		} ,{
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
			field : 'createTimestamp'
		} , {
			width : '100',
			title : '登录总次数',
			field : 'loginCount'
		} , {
			width : '120',
			title : '最后登录IP',
			field : 'lastLoginIp'
		} , {
			width : '120',
			title : '最后登录时间',
			field : 'lastLoginTime',
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
        }
	});
});

</script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false">
	<div id="toolbar"  class="easyui-toolbar" style="display: none;">
		<form id="searchForm" style="margin-top:2px;">
			<table class="search-form-table">
				<tr>
					<th style="width:100px">
						工号/账号/姓名:
					</th>
					<td>
						<input name="name" style="width: 135px;" />
					</td>
					<td>
						<label>&nbsp; 应用:</label>
						<select id="_appId" name="appId">
							<option value="">--请选择--</option>
							<c:forEach var="item" items="${appList}">
								<option value="${item.id}">${item.name}</option>
							</c:forEach>
						</select>
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
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-edit'" onclick="resetPassword();">重置密码</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="allocateApp();">分配应用</a>
			<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-add'" onclick="allocateRole();">分配角色</a>
		</form>
	</div>
	<div data-options="region:'center',fit:true,border:false">
		<table id="grid" data-options="fit:true,border:false"></table>
	</div>
</body>
</html>