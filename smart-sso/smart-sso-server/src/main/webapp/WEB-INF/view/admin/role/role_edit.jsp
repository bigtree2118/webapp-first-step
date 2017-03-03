<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/view/common/include.jsp"%>
<script language="javascript">
$(function(){
});

//提交表单（编辑应用）
var submitForm = function($dialog, $grid, $pjq) {
	if(validateFormByLV()){
		window.parent.EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
		$.post('${_path}/admin/role/save', JXCore.serializeForm($('#form')), function(json) {
			window.parent.EasyuiExt.progressBar('close');
			if(json.success){
				window.top.showSysMsg("操作成功：成功修改应用");
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
		<input type="hidden" name="id" id="appId" value="${role.id}" />
		<div class="form-table">
			<table>
				<tr>
					<th><font>*</font>应用名称</th>
					<td>
						<input name="appName" id="appName" value=${role.appName } readonly="readonly">
						<input type="hidden" name="appId"  value=${role.appId } >
					</td>
				</tr>
				<tr>
					<th><font>*</font>角色名称</th>
					<td>
						<input type="text" name="name" id="name" value="${role.name }" maxlength="100" class="LV_notNull"/>
					</td>
				</tr>
				<tr>
					<th><font>*</font>系统内置</th>
					<td>
						<label><input name="issys" value="true" type="radio" class="LV_radioCheck" ${role.issys ? 'checked="checked"' : ''}/>是</label>
						<label><input name="issys" value="false" type="radio" ${!role.issys ? 'checked="checked"' : ''}/>否</label>
					</td>
				</tr>
				<tr>
					<th><font>*</font>是否启用</th>
					<td>
						<label><input name="isEnable" value="true" type="radio" class="LV_radioCheck" ${role.isEnable ? 'checked="checked"' : ''}/>是</label>
						<label><input name="isEnable" value="false" type="radio" ${!role.isEnable ? 'checked="checked"' : ''}/>否</label>
					</td>
				</tr>
				<tr>
					<th><font>*</font>顺序号</th>
					<td>
						<input type="text" name="sort" id="sort" value="${role.sort }" class="LV_notNull"/>
					</td>
				</tr>
				<tr>
					<th><font>*</font>描述</th>
					<td>
						<input type="text" name="description" value="${role.description }" id="description"/>
					</td>
				</tr>
				<%-- <tr>
					<th><font>*</font>创建时间
					</th>
					<td>
						<input type="text" name="createTimestampStr" value="${role.createTimestampStr }" id="createTimestamp" readonly="readonly"/>
					</td>
				</tr> --%>
			</table>
		</div>
	</form>
</body>
</html>
