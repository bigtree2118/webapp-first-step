<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script type='text/javascript' src='<%=basePath %>js/lib/jquery/jquery-2.0.3.min.js'></script>
<script type='text/javascript' src='<%=basePath %>js/jx/JXCore.js'></script>
<script language="javascript">
var basePath = '<%=basePath%>';
$(function(){
	fresh();
	self.setInterval("fresh()",5000);
	
	$('img').click(function(){
		var imgid = $(this).attr('id');
		var size = $(this).attr('size');
		if(size == 'b'){
			$(this).attr('width', 436).attr('height', 240).attr('size', 's');
			$('img[id!=' + imgid + ']').each(function(i){
				$(this).show();
			});	
			return;
		}else{
			$(this).attr('width', 818).attr('height', 450).attr('size', 'b');
			$('img[id!=' + imgid + ']').each(function(i){
				$(this).hide();
			});	
		}
	});
});

function fresh(){
	var ct = (new Date()).getTime();
	var url = 'http://image.sinajs.cn/newchart/{0}/n/{1}.gif&ct=' + ct;
	$('#img1').attr('src', JXCore.formatString(url, $('#type1').val(), $('#code1').val()));
	$('#img2').attr('src', JXCore.formatString(url, $('#type2').val(), $('#code2').val()));
	$('#img3').attr('src', JXCore.formatString(url, $('#type3').val(), $('#code3').val()));
	$('#img4').attr('src', JXCore.formatString(url, $('#type4').val(), $('#code4').val()));
	$('#img5').attr('src', JXCore.formatString(url, $('#type5').val(), $('#code5').val()));
}
</script>
</head>
<body>
	<div style="padding: 2px;">
		<div style="margin-bottom: 2px; width: 100%">
			代码1<input id="code1" type="text" value="sh600011" style="width: 60px;"/>
				 <select id="type1">
				 	<option value="min">min</option>
				 	<option value="daily">daily</option>
				 	<option value="weekly">weekly</option>
				 	<option value="monthly">monthly</option>
				 </select>&nbsp;&nbsp;
			代码2<input id="code2" type="text" value="sh600718" style="width: 60px;"/>
				 <select id="type2">
				 	<option value="min">min</option>
				 	<option value="daily">daily</option>
				 	<option value="weekly">weekly</option>
				 	<option value="monthly">monthly</option>
				 </select>&nbsp;&nbsp;
			代码3<input id="code3" type="text" value="sz002024" style="width: 60px;"/>
				 <select id="type3">
				 	<option value="min">min</option>
				 	<option value="daily">daily</option>
				 	<option value="weekly">weekly</option>
				 	<option value="monthly">monthly</option>
				 </select>&nbsp;&nbsp;
			代码4<input id="code4" type="text" value="sh000001" style="width: 60px;"/>
				 <select id="type4">
				 	<option value="min">min</option>
				 	<option value="daily">daily</option>
				 	<option value="weekly">weekly</option>
				 	<option value="monthly">monthly</option>
				 </select>
			代码5<input id="code5" type="text" value="sh600706" style="width: 60px;"/>
				 <select id="type5">
				 	<option value="min">min</option>
				 	<option value="daily">daily</option>
				 	<option value="weekly">weekly</option>
				 	<option value="monthly">monthly</option>
				 </select>
		</div>
		<img id="img1" width="436" height="240"/>
		<img id="img2" width="436" height="240"/>
		<img id="img3" width="436" height="240"/>
		<img id="img4" width="436" height="240"/>
		<img id="img5" width="436" height="240"/>
	</div>
</body>
</html>
