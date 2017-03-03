/**
 * 定义多用户下拉树形选择框(UsersComboxTree)
 * v2.6.0
 * author: wbin
 */
 function UsersComboxTree(c){
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
 		if(treeNode.node_type != 0){
 			return;
 		}
 		//回填
 		$("#" + this.nameFiledId).val(treeNode.node_name);
 		var node_id = treeNode.node_id.substring(3);
 		$("#" + this.idFieldId).val(node_id);
 		
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
 	 			chkStyle : "checkbox" 
 			},
 			view: {
 				showIcon: function(treeId, treeNode){
 					if(treeNode.node_type == 0){
 						return true;
 					}else{
 						return false;
 					}
 				},
 				dblClickExpand: false,
 				selectedMulti: false
 			},
 			data: {
 					key: {
 						title: 'remark',
 						name: 'node_name'
 					},
 					simpleData: {
 						enable: true,
 						idKey: 'node_id',
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
 		$.ajaxSetup({async: false});
 		var temp_cache = null;
 	 	$.post(JXCore.basePath + 'basic/sys/loadOrgUserTreeNode.action', params, function(json){
 			if(json.resultCode == 'success'){
 				for(var i=0; i<json.nodeList.length; i++){
 					if(json.nodeList[i].node_type == 0){
 						json.nodeList[i].icon = JXCore.basePath + 'style/images/usersIco_03.png';	
 					}
 				}
 				
 				if(json.nodeList.length > 0){
 					json.nodeList[0].open = true;
 				}
 				temp_cache = json.nodeList;
 			}else{
 				alert("加载用户数据失败!");
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
 		this.treeObj = $.fn.zTree.init($("#" + this.treeId),this.setting, this.data_cache);
 		//绑定body的mousedown事件，隐藏树形框
 		$('body').bind("mousedown", this.onMousedown);
 		
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
 		var names = []; var ids = [];
 		$.each(nodes,function(index,node){
	 		if(node.node_type == 0){
				names.push(node.node_name);
				ids.push(node.node_id.substring(3)); 
	 		}
 		});
 		//回填
 		$("#" + this.nameFiledId).val(names.join(";"));
 		$("#" + this.idFieldId).val(ids.join(";"));
 	};
 	
 	this.initTreeBox();
 	
 	return this;
 };