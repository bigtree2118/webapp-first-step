<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="Content-Type" content="text/html; charset=UTF-8"/>
<meta name="generator" content="Bigtree"/>
<jsp:include page="/admin/common/include.jsp"></jsp:include>
	<script type="text/javascript" src="jquery.pivotgrid.js"></script>
</head>
<body>
	<h2>Pivot Grid</h2>
	<div style="margin-bottom:10px">
		<a href="javascript:void(0)" class="easyui-menubutton" style="width:70px;height:78px;" data-options="size:'large',iconCls:'icon-load',iconAlign:'top',plain:false,menu:'#mm'">Load</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" style="width:70px;height:78px;" data-options="size:'large',iconCls:'icon-layout',iconAlign:'top',plain:false" onclick="javascript:$('#pg').pivotgrid('layout')">Layout</a>
	</div>
	<div id="mm" style="display:none">
		<div onclick="load1()">Load Data1</div>
		<div onclick="load2()">Load Data2</div>
	</div>
	<table id="pg" style="width:700px;height:300px"></table>
	<style type="text/css">
		.icon-load{
			background:url('load.png') no-repeat center center;
		}
		.icon-layout{
			background:url('layout.png') no-repeat center center;
		}
	</style>
	<script type="text/javascript">
		$(function(){
			load1();
		});

		function load1(){
			$('#pg').pivotgrid({
				url:'pivotgrid_data1.json',
				method:'get',
				pivot:{
					rows:['Country','Category'],
					columns:['Color'],
					values:[
						{field:'Price',op:'sum'},
						{field:'Discount',op:'sum'}
					]
				},
				valuePrecision:0,
				valueStyler:function(value,row,index){
					if (/Discount$/.test(this.field) && value>100 && value<500){
						return 'background:#D8FFD8'
					}
				}
			})
		}
		function load2(){
			$('#pg').pivotgrid({
				url:'pivotgrid_data2.json',
				method:'get',
				pivot:{
					rows:['form','name'],
					columns:['year'],
					values:[
						{field:'gdp'},
						{field:'oil'},
						{field:'balance'}
					]
				},
				valuePrecision:3,
				valueStyler:function(value,row,index){
					if (/balance$/.test(this.field) && value<0){
						return 'background:pink'
					}
				}
			})
		}
	</script>
</body>
</html>