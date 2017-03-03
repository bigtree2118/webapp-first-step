<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="<%=basePath%>js/lib/jquery/msdropdown/script/jquery-1.9.0.min.js"></script>
<link href="<%=basePath%>js/lib/jquery/msdropdown/themes/default/dd.css" rel="stylesheet" type="text/css" />
<script src="<%=basePath%>js/lib/jquery/msdropdown/script/jquery.dd.min.js"></script>
</head>
<body>
	<div>
		 <select id="payments" name="payments" style="width:250px;">
	        <option value="amex" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/Mastercard-56.png" data-description="My life. My card...">Amex</option>
	        <option value="Discover" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/Paypal-56.png" data-description="It pays to Discover...">Discover</option>
	        <option value="Mastercard" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/Visa-56.png" data-title="For everything else..." data-description="For everything else...">Mastercard</option>
	    </select> 
	    
	    <select  id="tech" style="width:200px">
	      <option value="shopping_cart" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/icon_cart.gif">Shopping Cart</option>
	      <option value="calendar" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/icon_calendar.gif">Calendar</option>
	      <option value="email"  data-image="<%=basePath%>js/lib/jquery/msdropdown/images/icon_email.gif">Email</option>
	      <option value="games" selected="selected" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/icon_games.gif">Games</option>
	      <option value="music" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/icon_music.gif">Music</option>
	      <option value="phone" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/icon_phone.gif">Phone</option>
	      <option value="video" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/icon_video.gif">Video</option>
	      <option value="cd" data-image="<%=basePath%>js/lib/jquery/msdropdown/images/icon_cd.gif">CD</option>
	    </select>
	</div>
	<script language="javascript">
		$(function(){
			$("#payments").msDropdown({visibleRows:4});
			$("#tech").msDropdown().data("dd");//{animStyle:'none'} /{animStyle:'slideDown'} {animStyle:'show'}	
		});
	</script>
</body>
</html>
