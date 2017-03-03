<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%@ include file="/WEB-INF/view/common/include.jsp"%>
<script>
$(function(){
	
});

//提交表单（分配应用）
var submitForm = function($dialog, $grid, $pjq) {
	if(validateFormByLV()){
		window.parent.EasyuiExt.progressBar({value:'正在处理,请您稍等...'});
		var appIds = "";
		$("input[name='appId']:checked").each(function(i, d){
			if(i > 0){
				appIds += ",";
			}
			appIds += $(this).val();
		});
		var userId=$("#userId").val();
		var params={
			'userId':userId,
			'appIds':appIds
		}
		$.post('${_path}/admin/userApp/allocateSave', params, function(json) {
			window.parent.EasyuiExt.progressBar('close');
			if(json.success){
				window.top.showSysMsg("操作成功：成功分配应用");
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
		<input type="hidden" name="id" id="userId" value="${userId}" />
		<div class="form-table">
			<table>
				<tr>
					<th>应用列表</th>
					<td>
						<c:forEach var="item" items="${appList}">
							<div class='col-sm-2'>
								<label>
									<input name="appId" value="${item.id}" type="checkbox" class="ace" ${item.isChecked ? 'checked="checked"' : ''}/>
									<span class="lbl">&nbsp;&nbsp;${item.name}</span>
								</label>
							</div>
						</c:forEach>
					</td>
				</tr>
			</table>
		</div>
	</form>
</body>
</html>