<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/view/common/include.jsp"%>
<script type="text/javascript">
var role_user_gird;
var paramList = $.util.request;

//处理请求参数
var paramMap = {};
for(var i=0; i<paramList.length; i++){
	paramMap[ paramList[i]['name'] ] = paramList[i]['value'];
}

$(function(){
	//新增角色用户信息
	role_user_gird = $('#role_user_gird').datagrid({
		title : '',
		url: '${_path}/admin/userRole/getNotRoleUsers',
		method: 'get',
		queryParams: paramMap,
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
		onBeforeLoad : function(param) {},
		onLoadSuccess : function(data) {
			role_user_gird.datagrid('uncheckAll');
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
});

var setRoleUser = function(pgrid){
	var users = role_user_gird.datagrid('getSelections');
	var userIdArray = [];
	for(var i=0; i<users.length; i++){
		userIdArray.push(users[i].id);
	}
	
	users =  pgrid.datagrid('getRows');
	if(users.length > 0){
		for(var i=0; i<users.length; i++){
			userIdArray.push(users[i].id);
		}
	}
	
	window.parent.setRoleUser(userIdArray.join(','));
};
</script>
</head>
<body class="easyui-layout" data-options="fit:true,border:false" id="layout">
	<div data-options="region:'center',fit:true,border:false">
		<table id="role_user_gird" data-options="fit:true,border:false"></table>
	</div>
</body>
</html>
