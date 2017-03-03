<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="/WEB-INF/view/common/include.jsp"></jsp:include>
<script>
$(function(){
	
});

//校验人员工号(唯一性校验)
var checkJobNo = function (){
	if(!$('#jobNo').val()){
		return 'true';
	}
	
	var valid = false;
	var params = {
		'jobNo': $('#jobNo').val(),
		ct: JXCore.getCurrentTime()
	};
	
	$.ajaxSetup({async: false});
	$.post('${_path}/admin/user/checkjobNo', params, function(json){
		if(json.success){
			valid = json.data.valid
		}else{
			window.top.showSysMsg("检查工号时出现异常");
		}
	}); 
	$.ajaxSetup({async: true});
	
	return valid;
};

//校验账号(唯一性校验)
var checkAccount = function (){
	if(!$('#account').val()){
		return 'true';
	}
	
	var valid = false;
	var params = {
		'account': $('#account').val(),
		ct: JXCore.getCurrentTime()
	};
	
	$.ajaxSetup({async: false});
	 $.post('${_path}/admin/user/checkAccount', params, function(json){
		if(json.success){
			valid = json.data.valid
		}else{
			window.top.showSysMsg("检查账号时出现异常");
		}
	}); 
	$.ajaxSetup({async: true});
	
	return valid;
}; 

//提交表单（新增人员）
var submitForm = function($dialog, $grid, $pjq) {
	if(validateFormByLV()){
		window.parent.EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
		$.post('${_path}/admin/user/save', JXCore.serializeForm($('#form')), function(json) {
			window.parent.EasyuiExt.progressBar('close');
			if(json.success){
				window.top.showSysMsg("操作成功：成功添加人员");
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
					<th><font>*</font>工号</th>
					<td>
						<input type="text" name="jobNo" id="jobNo" maxlength="20" class="LV_notNull LV_custom" 
							customMethod="checkJobNo" customFailMsg="该工号已经存在，工号不能重复"/>
					</td>
					<th>组织机构id</th>
					<td>
						<input type="text" name="orgId" id="orgId" maxlength="100" />
					</td>
				</tr>
				<tr>
					<th><font>*</font>登录账号</th>
					<td>
						<input type="text" name="account" id="account" maxlength="100" class="LV_notNull LV_custom" 
							customMethod="checkAccount" customFailMsg="该账号已经存在，账号不能重复"/>
					</td>
					<th><font>*</font>密码</th>
					<td>
						<input type="password" name="password" id="password" maxlength="100" class="LV_notNull"/>
					</td>
				</tr>
				<tr>
					<th><font>*</font>姓名</th>
					<td>
						<input type="text" name="userName" id="userName" maxlength="100" class="LV_notNull"/>
					</td>
					<th>性别</th>
					<td>
						<label><input name="gender" value="1" type="radio" class="LV_radioCheck" checked="checked"/>男</label>
						<label><input name="gender" value="2" type="radio"/>女</label>
					</td>
				</tr>
				<tr>
					<th><font>*</font>邮箱</th>
					<td>
						<input type="text" name="email" id="email" maxlength="100" class="LV_notNull"/>
					</td>
					<th><font>*</font>手机号码</th>
					<td>
						<input type="text" name="cellPhone" id="cellPhone" maxlength="100" class="LV_notNull" />
					</td>
				</tr>
				<tr>
					<th>联系地址</th>
					<td>
						<input type="text" name="address" id="address" maxlength="100" />
					</td>
					<th>系统内置</th>
					<td>
						<label><input name="isSys" value="1" type="radio" class="LV_radioCheck" checked="checked"/>是</label>
						<label><input name="isSys" value="2" type="radio"/>否</label>
					</td>
				</tr>
				<tr>
					<th>是否启用</th>
					<td>
						<label><input name="isEnable" value="true" type="radio" class="LV_radioCheck" checked="checked"/>是</label>
						<label><input name="isEnable" value="false" type="radio"/>否</label>
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>