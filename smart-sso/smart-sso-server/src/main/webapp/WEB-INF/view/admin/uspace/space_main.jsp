<%@ page language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<jsp:include page="/WEB-INF/view/common/include.jsp"></jsp:include>
<script type="text/javascript">
$(function(){
	$('#mainTabs').tabs({
		fit : true,
		border : false,
		tabPosition: 'left',
		onSelect:function(title, index){
	        if(index == 0){
	        	$('#frm_password').attr('src', '${_path}/admin/uspace/gotoPassword');
	        }
	    }
	});
});
</script>
</head>
<body class="easyui-layout" >
	<div data-options="region:'center', border:false" style="overflow: hidden;">
		<div id="mainTabs">
			<div title="修改密码" data-options="iconCls:'ext-icon-key'">
				<iframe id="frm_password" src="" allowTransparency="true" style="border: 0; width: 100%; height: 99%;" frameBorder="0"></iframe>
			</div>
		</div>
	</div>
</body>
</html>

