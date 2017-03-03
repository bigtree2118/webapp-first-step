/**
 * 定义多选组织机构下拉选择框树(OrgsComboxTree)
 * v2.6.0
 * author: chenbing
 */
 function OrgsComboxTree(c){
 	this.idFieldId = c.idFieldId;
 	this.nameFiledId = c.nameFieldId;
 	this.treeBoxId = this.nameFiledId + '_treeCheckBox';	
 	this.treeId = this.nameFiledId + '_treeCheck';
 	this.data_cache = null;
 	this.treeObj = {};
 	
 	this.callback = function(treeObj){};
 	if(typeof c.callback == 'function'){
 		this.callback = c.callback;
 	} 
 	this.callback = this.callback.bind(this);
 	
 	//click事件
 	this.onNodeClick = function (e, treeId, treeNode){
 	
 		//回填
 		$("#" + this.nameFiledId).val(treeNode.org_name);
 		$("#" + this.idFieldId).val(treeNode.org_id);
 		
 		this.treeObj.checkAllNodes(false);
 		this.treeObj.checkNode(treeNode, true, true);
 		this.hideTreeBox();
 		this.callback(this.treeObj);
 	};
 	this.onNodeClick = this.onNodeClick.bind(this);
 	
 	//mousedown事件
 	this.onMousedown = function(event){
 		if (!(event.target.id == this.treeBoxId || $(event.target).parents('#' + this.treeBoxId).length>0)) {
 			this.backValues();
 			this.hideTreeBox();
 			this.callback(this.treeObj);
 		}
 	};
	this.onMousedown = this.onMousedown.bind(this);
	
 	this.showTreeBox = function(){
 		//获取文本框的偏移位置和高度
 		var nameField = $('#' + this.nameFiledId);
 		var offset = nameField.offset();
 		var treeBox = $('#' + this.treeBoxId);
 		treeBox.css({
 			left: (offset.left-10) + "px",  
 			top: (offset.top + nameField.outerHeight() + "px") 
 		}).slideDown("fast");
 	};
 	this.showTreeBox = this.showTreeBox.bind(this);
 	
 	this.setting = {
 			check: {
 				enable: true,
 				chkboxType: { 'Y': '', 'N': '' },
 	 			chkStyle : "checkbox" 
 			},
 			view: {
 				showIcon: false,
				dblClickExpand: false,
				selectedMulti: false
 			},
 			data: {
 					key: {
 						title: 'remark',
 						name: 'org_name'
 					},
 					simpleData: {
 						enable: true,
 						idKey: 'org_id',
						pIdKey: 'parent_id'			
 					}
 				},
 			callback: {                 
 				beforeDrag: false,
 				onClick: this.onNodeClick
 			}
 		};
 	
 	this.load = function(){
 		if(this.data_cache){
 			return;
 		}
 		
 		//通过json模式得到数据值
 		var params = { ct: (new Date()).getTime() };
 		var temp_cache = null;
 		$.ajaxSetup({async: false});
 	 	$.post(JXCore.basePath + 'basic/sys/org_loadOrgFromCache.action', params, function(json){
 			if(json.resultCode == 'success'){
 				
 				if(json.list.length > 0){
 					json.list[0].open = true;
 				}
 				temp_cache = json.list;
 			}else{
 				alert("加载组织机构数据失败!");
 			}
 		});
 	 	$.ajaxSetup({async: true});
 	 	
 		this.data_cache = temp_cache;
 	};
 	
 	this.initTreeBox = function(){
 		this.load();
 		var tbHtml = '';
 		tbHtml += '<div id="' + this.treeBoxId + '" class="menuContent" style="display:none; position: absolute;" >';
 		tbHtml += 	'<ul id="' + this.treeId + '" class="ztree" style="margin:0 0 0 10px; border: 1px solid #A0A6AB; background: #fff; overflow-y:scroll; overflow-x:auto; width:145px; height: 180px;"></ul>';
 		tbHtml += '</div>';
 		$('#' + this.idFieldId).after(tbHtml);
 		this.treeObj = $.fn.zTree.init($("#" + this.treeId),this.setting, this.data_cache);
 		//绑定document的mousedown事件，隐藏树形框
 		$(document).bind("mousedown", this.onMousedown);
 		
 		var nameField = $('#' + this.nameFiledId);
 		//设置nameField的基本属性和样式
 		nameField.addClass('treeInput').attr('readonly', true).css({'width':'153px','float':'left'}).click(this.showTreeBox);
 		//绑定清除按钮
 		var clearBtn = $('<div class="ext-icon-clear" style="float: left" title="清空"></div>').click(this.clear);
 		nameField.after(clearBtn);
 	};
 	
 	this.clear = function(){
 		$('#' + this.idFieldId).val('');
 		$('#' + this.nameFiledId).val('');
 		this.treeObj.checkAllNodes(false);
 	};
 	this.clear = this.clear.bind(this);
 	
 	this.hideTreeBox = function(){
 		$("#" + this.treeBoxId).hide();
 	};
 	
 	this.backValues = function(){
 		var nodes = this.treeObj.getCheckedNodes(true);
 		if(nodes != null && nodes != ''){
 			var names = []; var ids = [];
	 		$.each(nodes,function(index,node){
				names.push(node.org_name);
				ids.push(node.org_id); 
	 		});
	 		//回填
	 		$("#" + this.nameFiledId).val(names.join(";"));
	 		$("#" + this.idFieldId).val(ids.join(";"));
 		}
 	};
 	
 	this.initTreeBox();
 	
 	return this;
 };