/**
 * 定义流程类型下拉选择框树(ProcessTypeComboxTree)
 * v1.0.0
 * author: chenbing
 */
function ProcessTypeComboxTree(c){
	this.idFieldId = c.idFieldId;
	this.nameFiledId = c.nameFieldId;
	this.treeBoxId = this.nameFiledId + '_treeBox';	
	this.treeId = this.nameFiledId + '_tree';
	this.data_cache = null;
	
	this.onNodeClick = function (e, treeId, treeNode){
		//回填
		if(treeNode.pt_id == 0){
			return;
		}
		$("#" + this.nameFiledId).val(treeNode.pt_name);
		$("#" + this.idFieldId).val(treeNode.pt_id);
		this.hideTreeBox();
	};
	if(typeof c.onNodeClick == 'function'){
		this.onNodeClick = c.onNodeClick;
	} 
	this.onNodeClick = this.onNodeClick.bind(this);
	
	this.onMousedown = function(event){
		if (!(event.target.id == this.treeBoxId || $(event.target).parents('#' + this.treeBoxId).length>0)) {
			this.hideTreeBox();
		}
	};
	this.onMousedown = this.onMousedown.bind(this);
	
	this.showTreeBox = function(){
		//获取文本框的偏移位置和高度
		var nameField = $('#' + this.nameFiledId);
		var offset = nameField.offset();
		var treeBox = $('#' + this.treeBoxId);
		treeBox.css({
			left: offset.left-10 + "px", 
			top: (offset.top + nameField.outerHeight() + "px") 
		}).slideDown("fast");
	};
	this.showTreeBox = this.showTreeBox.bind(this);
	
	this.setting = {
		check: {
			enable: false
		},
		view: {
			showIcon: false,
			dblClickExpand: false,
			selectedMulti: false
		},
		data: {
				key: {
					title: 'remark',
					name: 'pt_name'
				},
				simpleData: {
					enable: true,
					idKey: 'pt_id',
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
	 	$.getJSON(JXCore.basePath + 'workflow/base/process_loadProSystem.action', params, function(json){
			if(json.resultCode == 'success'){
				if(json.list.length > 0){
					json.list[0].open = true;
				}
				temp_cache = json.list;
			}else{
				alert("加载流程类型失败!");
			}
		});
		this.data_cache = temp_cache;
	};
	
	this.initTreeBox = function(){
		this.load();
		var tbHtml = '';
		tbHtml += '<div id="' + this.treeBoxId + '" class="menuContent" style="display:none; position: absolute;" >';
		tbHtml += 	'<ul id="' + this.treeId + '" class="ztree" style="margin:0 0 0 10px; border: 1px solid #A0A6AB; background: #fff; overflow-y:scroll; overflow-x:auto; width:145px; height: 180px;"></ul>';
		tbHtml += '</div>';
		$('#' + this.idFieldId).after(tbHtml);
		
		$.fn.zTree.init($("#" + this.treeId), this.setting, this.data_cache);
		//绑定body的mousedown事件，隐藏树形框
		$('body').bind("mousedown", this.onMousedown);
		
		var nameField = $('#' + this.nameFiledId);
		//设置nameField的基本属性和样式
		nameField.addClass('treeInput').attr('readonly', true).css({'width':'153px'}).click(this.showTreeBox);
		//绑定清除按钮
		var clearBtn = $('<div class="ext-icon-clear" title="清空"></div>').click(this.clear);
		nameField.after(clearBtn);
	};
	
	this.clear = function(){
		$('#' + this.idFieldId).val('');
		$('#' + this.nameFiledId).val('');
	};
	this.clear = this.clear.bind(this);
	
	this.hideTreeBox = function(){
		$("#" + this.treeBoxId).hide();
	};
	
	this.initTreeBox();
	
	return this;
};

