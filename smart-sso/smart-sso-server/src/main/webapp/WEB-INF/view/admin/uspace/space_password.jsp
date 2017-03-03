<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="/WEB-INF/view/common/include.jsp"></jsp:include>
<script type="text/javascript">
//验证唯一性
var checkNewPasd = function() {
	var valid = 'true';
	var newpwd = document.getElementById('newpwd').value;
	var pword = document.getElementById('pword').value;
	if(newpwd==pword)
	return (valid == 'true');
};

//提交秘密修改
var submitForm = function() {
	if(validateFormByLV()){
		$.post($('#passform').attr('action'), JXCore.serializeForm($('#passform')), function(json) {
			if(json.success){
				window.top.showSysMsg("密码修改成功");
				window.top.location = JXCore.basePath + '/logout';
			}else{
				window.top.showSysMsg("操作失败：" + json.msg||'');
			}
		}, 'json');
	}
};

</script>
</head>
<body class="easyui-layout" style="margin:2px;">
	<div class="form-table">
		<form action="${_path}/admin/uspace/savePassword" method="post" id="passform">
			<table>
				<tr>
					<th><font>*</font>新设密码</th>
					<td><input type="password" class="LV_notNull LV_length" maxlength="32" minlength="6" name="newPassword" id="newpwd" /></td>
				</tr>
				<tr>
					<th><font>*</font>确认密码</th>
					<td><input type="password" class="LV_notNull LV_custom LV_length" maxlength="32" minlength="6" customMethod="checkNewPasd" customFailMsg="您输入的新密码不一致" name="confirmPassword" id="pword" /></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="toolbar"  class="easyui-toolbar" style="margin-left:1px;">
   		<a href="javascript:void(0);" class="easyui-linkbutton" data-options="iconCls:'icon-ok'" id="saveBtn" onclick="javascript:submitForm();">保存</a>
   	</div>
</body>
</html>