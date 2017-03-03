if(window != window.top){
	window.top.location.href = location.href;  
}

$(function() {
	var messageBox = $('#messageBox');
	
    $('#loginbtn').click(function(){
    	login();
    });
    
    $('#user_account').keydown(function(event){
		if(event.which == 13){
			$('#user_password').focus();
		}
	});
	
	$('#user_password').keydown(function(event){
		if(event.which == 13){
			login();
		}
	});
	
	$('#verifycode').keydown(function(event){
		if(event.which == 13){
			login();
		}
	});
	
	$('#verifycodeImg').click(function(event){
		$('#verifycodeImg').attr('src', JXCore.basePath + 'public/verifyCodeImage?ct=' + (new Date()).getTime());
	});
	
	function showMessage(msg){
		messageBox.text('');
		messageBox.text(msg);
	}
	
	function clearMessage(){
		messageBox.text('');
	}
	
	function login(){
		clearMessage();
		var loginUrl = JXCore.basePath + 'login.action';
		$.post(loginUrl, {
			'user.user_account' : $('#user_account').val(),
			'user.user_password' : $('#user_password').val(),
			'verifycode' : $('#verifycode').val()
		}, function(rsp){
			if(rsp.resultCode == 'success'){
				window.location.href = JXCore.basePath + 'index.action';
			}else if(rsp.resultCode == 'sureAgain'){
				window.location.href = JXCore.basePath + 'admin/public/sure_again.jsp';
			}else if(rsp.resultCode == 'vrifyCodeDiscorrect'){
				$('#verifycode').val('');
				$('#verifycodeImg').attr('src', JXCore.basePath + 'public/verifyCodeImage?ct=' + (new Date()).getTime());
				showMessage(rsp.resultMsg);
			}else{
				showMessage(rsp.resultMsg);
			}
		}, 'JSON').error(function(){
		    alert('系统错误,请联系管理员');
		});	
	}
});

