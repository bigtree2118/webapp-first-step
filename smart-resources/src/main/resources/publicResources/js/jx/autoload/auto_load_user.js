/**
 *函数功能说明：输入销售人员姓名时自动提示
 *传入参数：user_name:用户姓名标签Id
 *		   user_id:用户id标签id
 *		   org_name:用户组织名称标签id
 *		   org_id:用户组织id标签id
 *		   dep_name:用户部门名称标签id
 *		   dep_id:用户部门id标签id
 *		   area_name:用户区域名称标签id
 *		   area_id:用户区域id标签id
 *		   cellphone_no:用户手机号码Id
 *		   address：用户地址
 *@author:mzl
 *@date:2013-5-22
*/
function UserAutoComplete(user){
	this.Field_user_name = user.user_name;
	this.Field_user_id= user.user_id;
	this.Field_org_name = user.org_name;
	this.Field_org_id = user.org_id;
	this.Field_dep_name = user.dep_name;
	this.Field_dep_id = user.dep_id;
	this.Field_area_name = user.area_name;
	this.Field_area_id = user.area_id;
	this.Field_cellphone_no = user.cellphone_no;
	this.Field_address = user.address;
	this.usercache = {};
	
	this.initClear = function(){//用于清空数据
		$('#'+this.Field_user_id).val('');
		if($('#'+this.Field_org_name).val()){
			$('#'+this.Field_org_name).val('');
		};
		if($('#'+this.Field_org_id).val()){
			$('#'+this.Field_org_id).val('');
		};
		if($('#'+this.Field_dep_name).val()){
			$('#'+this.Field_dep_name).val('');
		};
		if($('#'+this.Field_dep_id).val()){
			$('#'+this.Field_dep_id).val('');
		};
		if($('#'+this.Field_area_name).val()){
			$('#'+this.Field_area_name).val('');
		};
		if($('#'+this.Field_area_id).val()){
			$('#'+this.Field_area_id).val('');
		};
		if($('#'+this.Field_cellphone_no).val()){
			$('#'+this.Field_cellphone_no).val('');
		};
		if($('#'+this.Field_address).val()){
			$('#'+this.Field_address).val('');
		};
	};
	
	this.initClear = this.initClear.bind(this);
	var initClear = this.initClear;
	var usercache = this.usercache;
	this.autocomplete =function(){
		$('#'+this.Field_user_name).autocomplete({
		source: function (request, response) { 
				//如果缓存中存在，就直接返回缓存中的数据
				var search = request.term;
				initClear();
				if(search in usercache) {
					var entrys = usercache[search];
					var entrysTemp = entrys;
					response(entrysTemp);
					return;
				}
				//缓存中没有找到关键字，请求查询后台数据
				var params = {
					'user.user_zjm': search,
					'ct': (new Date()).getTime()
				};
				$.post(JXCore.basePath + "basic/sys/user_loadUserFromCache.action",params,function(json){
					var entrys = [];
					var listLength = json.userList.length;
					if(listLength ==0){
						$('#' + this.Field_user_id).val();
						entrys[entrys.length]={
							label:"未找到相应的人员"
						};
					}else if(listLength < 10){
						for( var i = 0;i<listLength;i++){
							entrys[entrys.length]={
									label: json.userList[i].user_name+'('+json.userList[i].org_path+')',
									user_name:json.userList[i].user_name,
									user_id:json.userList[i].user_id,
									org_name:json.userList[i].org_name,
									org_id:json.userList[i].org_id,
									dep_name:json.userList[i].dep_name,
									dep_id:json.userList[i].dep_id,
									area_id:json.userList[i].area_id,
									cellphone_no:json.userList[i].cellphone_no,
									address:json.userList[i].address
							};
						}
					}else{
						for( var i = 0;i<10;i++){
							entrys[entrys.length]={
									label: json.userList[i].user_name+'('+json.userList[i].org_path+')',
									user_name:json.userList[i].user_name,
									user_id:json.userList[i].user_id,
									org_name:json.userList[i].org_name,
									org_id:json.userList[i].org_id,
									dep_name:json.userList[i].dep_name,
									dep_id:json.userList[i].dep_id,
									area_name:json.userList[i].area_name,
									area_id:json.userList[i].area_id,
									cellphone_no:json.userList[i].cellphone_no,
									address:json.userList[i].address
							};
						}
						
					}
					usercache[request.term] = entrys;
					response(entrys);
				});
			},
		minLength: 1,   
		select:function(event,ui) {
				$('#'+user.user_name).val(ui.item.user_name);
				$('#'+user.user_id).val(ui.item.user_id);
				if($('#'+user.org_name).val()){
					 $('#'+user.org_name).val(ui.item.org_name);
				};
				if($('#'+user.org_id).val()){
					 $('#'+user.org_id).val(ui.item.org_id);
				};
				if($('#'+user.dep_name).val()){
					 $('#'+user.dep_name).val(ui.item.dep_name);
				};
				if($('#'+user.dep_id).val()){
					 $('#'+user.dep_id).val(ui.item.dep_id);
				};
				if($('#'+user.area_name).val()){
					 $('#'+user.area_name).val(ui.item.area_name);
				};
				if($('#'+user.area_id).val()){
					 $('#'+user.area_id).val(ui.item.area_id);
				};
				if($('#'+user.cellphone_no).val()){
				  	$('#'+user.cellphone_no).val(ui.item.cellphone_no);
				};
				if($('#'+user.address).val()){
				  	$('#'+user.address).val(ui.item.address);
				};
				$( '#'+ui.item.user_name).attr( 'selected','selected' );
				return false;
			} 
		});
		
	};
	
	this.autocomplete = this.autocomplete.bind(this);
	
	this.clear = function(){
			$('#' + this.Field_user_name).val('');
			$('#' + this.Field_user_id).val('');
			if($('#'+this.Field_org_name).val()){
				$('#'+this.Field_org_name).val('');
			};
			if($('#'+this.Field_org_id).val()){
				$('#'+this.Field_org_id).val('');
			};
			if($('#'+this.Field_dep_name).val()){
				$('#'+this.Field_dep_name).val('');
			};
			if($('#'+this.Field_dep_id).val()){
				$('#'+this.Field_dep_id).val('');
			};
			if($('#'+this.Field_area_name).val()){
				$('#'+this.Field_area_name).val('');
			};
			if($('#'+this.Field_area_id).val()){
				$('#'+this.Field_area_id).val('');
			};
			if($('#'+this.Field_cellphone_no).val()){
				$('#'+this.Field_cellphone_no).val('');
			};
			if($('#'+this.Field_address).val()){
				$('#'+this.Field_address).val('');
			};
	};
	
	this.clear = this.clear.bind(this);
	
	this.initAutoComplete = function(){
		$("#"+this.Field_user_name).attr("class","autoInput");
		var clearBtn = $('<div class="ext-icon-clear" title="清空"></div>').click(this.clear);
		$("#"+this.Field_user_name).after(clearBtn);
		this.autocomplete();
		
	};
	
	this.initAutoComplete = this.initAutoComplete.bind(this);
	
	this.initAutoComplete();
	
	return this;
}
