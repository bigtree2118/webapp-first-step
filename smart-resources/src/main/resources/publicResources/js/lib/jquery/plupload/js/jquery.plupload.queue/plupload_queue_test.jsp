<%@page import="java.util.Date"%>
<%@ page language="java" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>上传文件jquery.plupload.queue</title>
<base target="_self"/>
<link  type="text/css" href="<%=basePath%>js/lib/jquery/plupload/js/jquery.plupload.queue/css/jquery.plupload.queue.css" rel="stylesheet" media="screen" />
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/jquery.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/plupload_browserplus-min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/plupload.full.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/jquery.plupload.queue/jquery.plupload.queue.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/i18n/cn.js"></script>
<script type="text/javascript">
$(function(){
	$("#uploader").pluploadQueue({
		runtimes : 'gears,flash,silverlight,browserplus,html5,html4',
		url : '<%=basePath%>basic/sys/filePlupload.action',
        chunk_size : '1mb',
        max_file_size : '10mb',
        //max_file_count : 2,//文件个数限制失效
        unique_names : true,
        multiple_queues : true,
        resize : {width : 320, height : 240, quality : 90},
        filters : [
            {title : "Image files", extensions : "jpg,gif,png"},
            {title : "Zip files", extensions : "zip"}
        ],
		flash_swf_url : '<%=basePath%>js/lib/jquery/plupload/js/plupload.flash.swf',
		silverlight_xap_url : '<%=basePath%>js/lib/jquery/plupload/js/plupload.silverlight.xap'
	});
	
});
</script>
</head>
<body>
	<fieldset style="border: 1pxsolid #84A24A; text-align: left; COLOR: #84A24A; FONT-SIZE: 12px; font-family: Verdana; padding: 5px;">
		<div id="uploader">
			<p>您的浏览器未安装 Flash, Silverlight, Gears, BrowserPlus 或者支持 HTML5 .</p>
		</div>
	</fieldset>
</body>
</html>