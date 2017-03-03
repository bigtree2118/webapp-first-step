<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/view/common/include.jsp"%>
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
		'id': $('#userId').val(),
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
		'id': $('#userId').val(),
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

//提交表单（编辑人员）
var submitForm = function($dialog, $grid, $pjq) {
	if(validateFormByLV()){
		window.parent.EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
		$.post('${_path}/admin/user/save', JXCore.serializeForm($('#form')), function(json) {
			window.parent.EasyuiExt.progressBar('close');
			if(json.success){
				window.top.showSysMsg("操作成功：成功修改人员");
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
		<input type="hidden" name="id" id="userId" value="${user.id}" />
		<div class="form-table">
			<table>
				<tr>
					<th><font>*</font>工号</th>
					<td>
						<input type="text" name="jobNo" id="jobNo"  value="${user.jobNo }" maxlength="100" class="LV_notNull LV_custom" 
							customMethod="checkJobNo" customFailMsg="该工号已经存在，工号不能重复"/>
					</td>
					<th>组织机构id</th>
					<td>
						<input type="text" name="orgId" id="orgId"  value="${user.orgId }"  maxlength="100" />
					</td>
				</tr>
				<tr>
					<th><font>*</font>登录账号</th>
					<td>
						<input type="text" name="account" id="account" value="${user.account }" maxlength="100" class="LV_notNull LV_custom" 
							customMethod="checkAccount" customFailMsg="该账号已经存在，账号不能重复"/>
					</td>
					<th><font>*</font>密码</th>
					<td>
						<input type="password" name="password" id="password" value="" 
								${!empty user.id ? 'data-rel="tooltip" title="不修改请留空"' : ''}
								${empty user.id ? 'required="true"' : ''}  maxlength = '16' /><font style="color:red">不修改请留空</font>
					</td>
				</tr>
				<tr>
					<th><font>*</font>姓名</th>
					<td>
						<input type="text" name="userName" id="userName" value="${user.userName }"  maxlength="100" class="LV_notNull"/>
					</td>
					<th>性别</th>
					<td>
						<label><input name="gender" value="1" type="radio" class="LV_radioCheck"  ${(user.gender==1)?'checked="checked"':'' }/>男</label>
						<label><input name="gender" value="2" type="radio" ${(user.gender==2)?'checked="checked"':'' }/>女</label>
					</td>
				</tr>
				<tr>
					<th><font>*</font>邮箱</th>
					<td>
						<input type="text" name="email" id="email"  value="${user.email }"  maxlength="100" class="LV_notNull"/>
					</td>
					<th><font>*</font>手机号码</th>
					<td>
						<input type="text" name="cellPhone" id="cellPhone"  value="${user.cellPhone }" maxlength="100" class="LV_notNull" />
					</td>
				</tr>
				<tr>
					<th>联系地址</th>
					<td>
						<input type="text" name="address" id="address"  value="${user.address }" maxlength="100" />
					</td>
					<th>系统内置</th>
					<td>
						<label><input name="isSys" value="true" type="radio" class="LV_radioCheck"  ${user.isSys?'checked="checked"':'' }/>是</label>
						<label><input name="isSys" value="false" type="radio" ${!user.isSys?'checked="checked"':'' }/>否</label>
					</td>
				</tr>
				<tr>
					<th>是否启用</th>
					<td>
						<label><input name="isEnable" value="true" type="radio" class="LV_radioCheck" ${user.isEnable?'checked="checked"':'' }/>是</label>
						<label><input name="isEnable" value="false" type="radio" ${!user.isEnable?'checked="checked"':'' }/>否</label>
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>
