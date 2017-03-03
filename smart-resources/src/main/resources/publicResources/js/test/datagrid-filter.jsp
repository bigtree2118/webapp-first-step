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
	<script type="text/javascript" src="datagrid-filter.js"></script>
	<style>
		.icon-filter{
			background:url('filter.png') no-repeat center center;
		}
	</style>
	<script>
		var data = [
           	{"productid":"FI-SW-01","productname":"Koi","unitcost":10.00,"status":"P","listprice":36.50,"attr1":"Large","itemid":"EST-1"},
        	{"productid":"K9-DL-01","productname":"Dalmation","unitcost":12.00,"status":"P","listprice":18.50,"attr1":"Spotted Adult Female","itemid":"EST-10"},
        	{"productid":"RP-SN-01","productname":"Rattlesnake","unitcost":12.00,"status":"P","listprice":38.50,"attr1":"Venomless","itemid":"EST-11"},
        	{"productid":"RP-SN-01","productname":"Rattlesnake","unitcost":12.00,"status":"P","listprice":26.50,"attr1":"Rattleless","itemid":"EST-12"},
        	{"productid":"RP-LI-02","productname":"Iguana","unitcost":12.00,"status":"P","listprice":35.50,"attr1":"Green Adult","itemid":"EST-13"},
        	{"productid":"FL-DSH-01","productname":"Manx","unitcost":12.00,"status":"N","listprice":158.50,"attr1":"Tailless","itemid":"EST-14"},
        	{"productid":"FL-DSH-01","productname":"Manx","unitcost":12.00,"status":"P","listprice":83.50,"attr1":"With tail","itemid":"EST-15"},
        	{"productid":"FL-DLH-02","productname":"Persian","unitcost":12.00,"status":"P","listprice":23.50,"attr1":"Adult Female","itemid":"EST-16"},
        	{"productid":"FL-DLH-02","productname":"Persian","unitcost":12.00,"status":"N","listprice":89.50,"attr1":"Adult Male","itemid":"EST-17"},
        	{"productid":"AV-CB-01","productname":"Amazon Parrot","unitcost":92.00,"status":"N","listprice":63.50,"attr1":"Adult Male","itemid":"EST-18"}
        ];
		$(function(){
			var dg = $('#dg').datagrid({
				filterBtnIconCls:'icon-filter'
			});
			dg.datagrid('enableFilter', [{
				field:'listprice',
				type:'numberbox',
				options:{precision:1},
				op:['equal','notequal','less','greater']
			},{
				field:'unitcost',
				type:'numberbox',
				options:{precision:1},
				op:['equal','notequal','less','greater']
			},{
				field:'status',
				type:'combobox',
				options:{
					panelHeight:'auto',
					data:[{value:'',text:'All'},{value:'P',text:'P'},{value:'N',text:'N'}],
					onChange:function(value){
						if (value == ''){
							dg.datagrid('removeFilterRule', 'status');
						} else {
							dg.datagrid('addFilterRule', {
								field: 'status',
								op: 'equal',
								value: value
							});
						}
						dg.datagrid('doFilter');
					}
				}
			}]);
		});
	</script>
</head>
<body>
	<h1>DataGrid Filter Row</h1>
	
	<table id="dg" title="DataGrid" style="width:700px;height:250px" data-options="
				singleSelect:true,
				data:data
			">
		<thead>
			<tr>
				<th data-options="field:'itemid',width:80">Item ID</th>
				<th data-options="field:'productid',width:100">Product</th>
				<th data-options="field:'listprice',width:80,align:'right'">List Price</th>
				<th data-options="field:'unitcost',width:80,align:'right'">Unit Cost</th>
				<th data-options="field:'attr1',width:250">Attribute</th>
				<th data-options="field:'status',width:60,align:'center'">Status</th>
			</tr>
		</thead>
	</table>
</body>
</html>