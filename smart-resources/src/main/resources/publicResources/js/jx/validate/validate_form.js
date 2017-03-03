/**
* desc 表单提交前验证数据
* 用法: 1 先引三个文件包，jquery.js,livevalidation.css,livevalidation.js
* 		2 需要验证的字段内容，直接在class后面添加。比如不能为空，class="LV_notNull"
*       3 实例请到:\admin\public\validate_data.jsp 查看
* 返回: boolean
* @author yangxi,chenbing
*/

ValidateForm = {};
ValidateForm.fields = [];
function validateFormByLV(options){
	//清除验证错误信息
	for(var i=0, len=ValidateForm.fields.length; i<len; i++){
		ValidateForm.fields[i].removeClass("LV_invalid_field");
		ValidateForm.fields[i].tooltip('destroy');
	}
	ValidateForm.fields = [];
	
   	function showTip(field, e){
   		ValidateForm.fields.push(field);
   		field.tooltip({
   			position: 'right',
   		    content: '<span style="color:black;">' + e.message + '</span>',
   		    onShow: function(){
   		        $(this).tooltip('tip').css({
   		            backgroundColor: '#FFFFA3',
   		            borderColor: '#F0D23C'
   		        });
   		    }
   		});
   		field.tooltip('show');
		field.addClass('LV_invalid_field');
   	}
   	
   	var valid = true, scope = $(document);
   	if(options && options.scopeId){
   		scope = $('#' + options.scopeId);
   	}
   	
   	$('.LV_notNullByComp').each(function(){
   		var id = $(this).attr("comboname");
   		$('input[name="'+id+'"]').parent().find('input').eq(0).addClass("LV_notNull");
   	});
   	
   	
   	//非空验证
	$(".LV_notNull", scope).each(function(){
		var field = $(this);
		try{
			
			var config = {};
			config.failureMessage = '必填项不能为空';
			
			Validate.Presence(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//数字验证
	$(".LV_numberic", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			var failMsg = '只能为数字';
			if( field.attr('maximum') ){
				config.maximum = field.attr('maximum');
				failMsg += '，不能大于' + field.attr('maximum');
			}
			if( field.attr('minimum') ){
				config.minimum  = field.attr('minimum');
				failMsg += '，不能小于' + field.attr('minimum');
			}
			
			config.failureMessage = field.attr('failMsg') ? field.attr('failMsg') : failMsg;
			Validate.Numericality(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//整数验证
	$(".LV_integer", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			config.onlyInteger = true;
			var failMsg = '只能为整数';
			if( field.attr('maximum') ){
				config.maximum = field.attr('maximum');
				failMsg += '，不能大于' + field.attr('maximum');
			}
			if( field.attr('minimum') ){
				config.minimum  = field.attr('minimum');
				failMsg += '，不能小于' + field.attr('minimum');
			}
			
			config.failureMessage = field.attr('failMsg') ? field.attr('failMsg') : failMsg;
			
			Validate.Numericality(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//正整数验证
	$(".LV_positiveInteger", scope).each(function(){
		var field = $(this);
		try{
			var c_value = field.val();
			Validate.Numericality(c_value,{ onlyInteger: true , minimum: 1, failureMessage: '只能为正整数' });
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	
	//字符串长度验证
	$(".LV_length", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			var failMsg = '';
			if( field.attr('maxlength') ){
				config.maximum = field.attr('maxlength');
				failMsg = '长度不能大于' + field.attr('maxlength');
			}
			if( field.attr('minlength') ){
				config.minimum  = field.attr('minlength');
				failMsg = '长度不能小于' + field.attr('minlength');
			}
			
			config.failureMessage = field.attr('failMsg') ? field.attr('failMsg') : failMsg;
			Validate.Length(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//电子邮箱地址验证
	$(".LV_email", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			if(field.attr('failMsg')){
				config.failureMessage = field.attr('failMsg');
			}
			Validate.Email(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//电话号码(包括座机号)
	$(".LV_telephone", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			if(field.attr('failMsg')){
				config.failureMessage = field.attr('failMsg');
			}
			Validate.Telephone(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//电话号码(包括座机号)
	$(".LV_phone", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			if(field.attr('failMsg')){
				config.failureMessage = field.attr('failMsg');
			}
			Validate.Phone(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//字母数字下划线组合字符串
	$(".LV_codeNo", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			if(field.attr('failMsg')){
				config.failureMessage = field.attr('failMsg');
			}
			Validate.CodeNo(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//身份证号码
	$(".LV_idCardNo", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			if(field.attr('failMsg')){
				config.failureMessage = field.attr('failMsg');
			}
			Validate.IDCardNo(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	//银行卡
	$(".LV_bankCard", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			if(field.attr('failMsg')){
				config.failureMessage = field.attr('failMsg');
			}
			if(field.val()){
				Validate.BankNumber(field.val(), config);
			}
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	//radio或check 字段验证
	$(".LV_radioCheck", scope).each(function(){
		var field = $(this);
		try{
			var failMsg = '请选择一项';
			if(field.attr('failMsg')){
				config.failureMessage = field.attr('failMsg');
			}
			
			var checkFlag = false;
			$("input[name='"+field.attr("name")+"']", scope).each(function(){
				if(this.checked){
					checkFlag = true;
				}
			});
		    
		    if(checkFlag == false){
		    	Validate.fail(failMsg);
		    }
		}catch(e){
			valid = false;
			var target = $("input[name='"+field.attr("name")+"']:last");
			showTip(target, e);
		}
	});
	
	//自定义验证函数
	$(".LV_custom", scope).each(function(){
		var field = $(this);
		try{
			var config = {};
			if(field.attr('customFailMsg')){
				config.failureMessage = field.attr('customFailMsg');
			}
			var customMethod = field.attr('customMethod');
			config.against = function(){
				return eval(customMethod +'()');
			};
			Validate.Custom(field.val(), config);
		}catch(e){
			valid = false;
			showTip(field, e);
		}
	});
	
	return valid;
}