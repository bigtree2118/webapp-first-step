<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="org.apache.commons.lang3.StringUtils"%> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring" %>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form" %>
<%
String _path = (String)request.getServletContext().getAttribute("_path");

Map<String, Cookie> cookieMap = new HashMap<String, Cookie>();
Cookie[] cookies = request.getCookies();
if (null != cookies) {
	for (Cookie cookie : cookies) {
		cookieMap.put(cookie.getName(), cookie);
	}
}

//指定如果用户未选择主题样式，那么初始化一个默认主题样式
String easyuiTheme = "metro-standard";
if (cookieMap.containsKey("easyuiTheme")) {
	Cookie cookie = (Cookie) cookieMap.get("easyuiTheme");
	easyuiTheme = cookie.getValue();
}

session.setAttribute("easyuiTheme", easyuiTheme);
%>

<%-- 引入主题样式 --%>
<link rel="stylesheet" type="text/css" media="screen" href="${_path}/resources/js/lib/jquery/easyui/themes/<%=easyuiTheme%>/easyui.css" id="easyuiTheme"/>
<link rel="stylesheet" type="text/css" media="screen" href="${_path}/resources/js/lib/jquery/easyui/themes/icon.css"/>
<link rel="stylesheet" type="text/css" media="screen" href="${_path}/resources/style/icon.ext.css"/>
<link rel="stylesheet" type="text/css" media="screen" href="${_path}/resources/style/skin/<%=easyuiTheme%>/css.css" id="cssTheme"/>
<link rel="stylesheet" type="text/css" media="screen" href="${_path}/resources/js/lib/validation/css/livevalidation.css"/>
<link rel="stylesheet" type="text/css" media="screen" href="${_path}/resources/js/lib/jquery/zTree/css/zTreeStyle/zTreeStyle.css"/>

<%-- 引入JXCore --%>
<script type="text/javascript" src="${_path}/resources/js/jx/JXCore.js"></script>
<script type="text/javascript">
JXCore.basePath = '${_path}';
JXCore.pixel_0 = '${_path}/resources/style/images/pixel_0.gif';//0像素的背景，一般用于占位
</script>

<%-- 引入jQuery --%>
<%
String User_Agent = request.getHeader("User-Agent");
if (StringUtils.indexOfIgnoreCase(User_Agent, "MSIE") > -1 && (StringUtils.indexOfIgnoreCase(User_Agent, "MSIE 6") > -1 
		|| StringUtils.indexOfIgnoreCase(User_Agent, "MSIE 7") > -1 
		|| StringUtils.indexOfIgnoreCase(User_Agent, "MSIE 8") > -1)) {
	out.println("<script type='text/javascript' src='" + _path + "/resources/js/lib/jquery/jquery-1.9.1.min.js'></script>");
} else {
	out.println("<script type='text/javascript' src='" + _path + "/resources/js/lib/jquery/jquery-2.0.3.min.js'></script>");
}
%>
<script type="text/javascript" src="${_path}/resources/js/lib/jquery/jquery.migrate.js"></script>
<script type="text/javascript" src="${_path}/resources/js/lib/jquery/jquery.jdirk.js"></script>

<%-- 引入easyui组件--%>
<script type="text/javascript" src="${_path}/resources/js/lib/jquery/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${_path}/resources/js/lib/jquery/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${_path}/resources/js/lib/jquery/easyui/jquery.easyui.ext.js"></script>
<%-- 引入ztree树形组件--%>
<script type="text/javascript" src="${_path}/resources/js/lib/jquery/zTree/js/jquery.ztree.all-3.3.js"></script>
<%-- 引入my97日期时间组件 --%>
<script type="text/javascript" src="${_path}/resources/js/lib/My97DatePicker/WdatePicker.js"></script>
<%-- 引入验证组件livevalidation --%>
<script type="text/javascript" src="${_path}/resources/js/lib/validation/livevalidation.js"></script>
<script type="text/javascript" src="${_path}/resources/js/jx/validate/validate_form.js"></script>
<% if(easyuiTheme.equals("black")){ %>
<style type="text/css">
.ztree span {color: white;}
.ztree li a.curSelectedNode {padding-top:0px; background-color:#606060; color:black; height:16px; border:1px #FFB951 solid; opacity:0.8;}
</style>
<% } %>