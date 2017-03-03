<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/view/common/include.jsp"%>
<script>
$(function(){
	
});

//提交表单（分配角色）
var submitForm = function($dialog, $grid, $pjq) {
	if(validateFormByLV()){
		window.parent.EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
		var roleIds = "";
		$("input[name='roleId']:checked").each(function(i, d){
			if(i > 0){
				roleIds += ",";
			}
			roleIds += $(this).val();
		});
		var userId=$("#userId").val();
		var appId=$("#_appId").val();
		var params={
			'userId':userId,
			'roleIds':roleIds,
			'appId':appId
		}
		$.post('${_path}/admin/userRole/allocateSave', params, function(json) {
			window.parent.EasyuiExt.progressBar('close');
			if(json.success){
				window.top.showSysMsg("操作成功：成功分配角色");
				$grid.datagrid('load',{});
				$dialog.dialog('close');
			}else{
				window.top.showSysMsg("操作失败：" + json.msg||'未知错误');
			}
		}, 'json');
	}
};

//根据应用联动查询角色
var change = function (){
	var params = {
		'userId': $('#userId').val(),
		'appId': $('#_appId').val()
	};
	$.ajaxSetup({async: false});
	$.get('${_path}/admin/userRole/change', params, function(json){
		if(json.success){
			var data = json.data;
			$("#_roleDiv").html('');
			var html= '';
			for(var i=0; i<data.length; i++){
				html += '	<label>';
				html += '		<input name="roleId" value="' + data[i].id + '" type="checkbox" ';
				if(data[i].isChecked){
					html += 'checked="checked"';
				}
				html += '		/>';
				html += '		<span>&nbsp;&nbsp;' + data[i].name + '</span>';
				html += '	</label>';
			}
			$("#_roleDiv").append(html);
		}else{
			window.top.showSysMsg("查询角色出现异常");
		}
	}); 
	$.ajaxSetup({async: true});
};
</script>
</head>
<body>
	<form id="form" method="post">
		<input type="hidden" name="id" id="userId" value="${userId}" />
		<div class="form-table">
			<table>
				<tr>
					<th>应用列表</th>
					<td>
						<select id="_appId" name="appId" onchange="change();" style="width:200px">
							<c:if test="${empty appList}">
								<option value="">--请选择--</option>
							</c:if>
							<c:forEach var="item" items="${appList}">
								<option value="${item.id}">${item.name}</option>
							</c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th>分配角色</th>
					<td>
						<div id="_roleDiv">
							<c:forEach var="item" items="${roleList}">
								<label>
									<input name="roleId" value="${item.id}" type="checkbox" ${item.isChecked ? 'checked="checked"' : ''}/>
									<span class="lbl">&nbsp;&nbsp;${item.name}</span>
								</label>
							</c:forEach>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>