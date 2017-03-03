<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/view/common/include.jsp"%>
<script language="javascript">
$(function(){
	
});

//校验APP编码(唯一性校验)
var checkAppCode = function (){
	if(!$('#code').val()){
		return 'true';
	}
	
	var valid = false;
	var params = {
		'code': $('#code').val(),
		ct: JXCore.getCurrentTime()
	};
	
	$.ajaxSetup({async: false});
	$.post('${_path}/admin/app/check', params, function(json){
		if(json.success){
			valid = json.data.valid
		}else{
			window.top.showSysMsg("检查应用编码时出现异常");
		}
	});
	$.ajaxSetup({async: true});
	
	return valid;
};


//提交表单（新增应用）
var submitForm = function($dialog, $grid, $pjq) {
	if(validateFormByLV()){
		window.parent.EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
		$.post('${_path}/admin/app/save', JXCore.serializeForm($('#form')), function(json) {
			window.parent.EasyuiExt.progressBar('close');
			if(json.success){
				window.top.showSysMsg("操作成功：成功添加应用");
				$grid.datagrid('load',{});
				$dialog.dialog('close');
			}else{
				window.top.showSysMsg("操作失败：" + json.msg||'未知错误');
			}
		}, 'json');
	}
};
</script>
</head>
<body>
	<form id="form" method="post">
		<div class="form-table">
			<table>
				<tr>
					<th><font>*</font>应用名称</th>
					<td>
						<input type="text" name="name" id="name" maxlength="100" class="LV_notNull"/>
					</td>
				</tr>
				<tr>
					<th><font>*</font>应用编码</th>
					<td>
						<input type="text" name="code" id="code" maxlength="100" class="LV_notNull LV_custom" 
							customMethod="checkAppCode" customFailMsg="该编码已经存在，应用编码不能重复"/>
					</td>
				</tr>
				<tr>
					<th><font>*</font>是否启用</th>
					<td>
						<label><input name="isEnable" value="true" type="radio" class="LV_radioCheck" checked="checked"/>是</label>
						<label><input name="isEnable" value="false" type="radio"/>否</label>
					</td>
				</tr>
				<tr>
					<th><font>*</font>顺序号</th>
					<td>
						<input type="text" name="sort" id="sort" class="LV_notNull"/>
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>
