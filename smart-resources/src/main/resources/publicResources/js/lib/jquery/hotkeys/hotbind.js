//This page is a result of an autogenerated content made by running test.html with firefox.
        //defhottype 触发默认绑定事件。默认click，其它只用传入jquery支持所以有事件都可以如获取焦点focus
   //引入所需JS库和CSS样式
   
   



	var settings={defhottype:"click"};//
	/**wangrong
	 * 初使化热键绑定方法
	 * 热键完成绑定过后，必须在DOM加载完成过后，来执行初使化绑定页面上的快捷键才会生效
	 */
	function initBindHotkeys(){
        $("[hotkey]").each(function(){
     		var obj = $(this);
     		//解除绑定JS事件时，可能还未添加任何事件，所以必须处理异常。以免JS报错后面代码不再执行。
     		try{
     			var hotkey = obj.attr("hotkey");
     			/*if(hotkey.indexOf("+")>0){
     				hotkey=hotkey.substring(hotkey.indexOf("+")+1).trim();
     			}*/
     			$(document).hotunbind('keydown',hotkey.toLowerCase());
     		}catch(e){
     			//$.trace(e.message);
     		}
     		//绑定JS事件
     		$(document).hotbind('keydown',obj.attr("hotkey"),function(evt){
     			var hottype = obj.attr("hottype");
     			if(!hottype){
     				hottype=settings.defhottype;
     			}
     			//触发事件
     			$(obj).trigger(hottype);
     		});
//     		alert(hotkeys.triggersMap.tostring());
        });
         var userAgent = navigator.userAgent;
         //add highlightAccessKeys
         try{
        	 $.highlightAccessKeys({ debug: false});
         }catch(e){
        	 $.trace(e.message);
         }
         window.focus();
     }
     
     
