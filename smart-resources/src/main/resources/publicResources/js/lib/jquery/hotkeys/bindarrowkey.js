
/**   @功能说明 给table的输入框添加绑定上下左右键移动的方法。 后期完善成直接加载对所以有配置的table支持，直接输入初使化即可，有空再写。
	  @参数 obj this对象
	  @使用方法1:
	  		 <input type='text' isnull='true' onfocus='this.select()' onkeydown='bindArrowKey(this)'/>
 			*引入js包在input 标签中加入onfocus='this.select()' onkeydown='bindArrowKey(this)'即可
 	    使用方法2:
 	       引入js包。在数据初使化完成过程调initArrowTab(tabName)。 tabName需添加方向键支持的<table>。推荐使用第二种方法，初使化。
 	   @作者
	  		wangrong/2012-11-25
	  */

function initArrowTab(tabName){
	$("table[name="+tabName+"], table[id="+tabName+"]").each(function(){
			//动态添加事件
			$(this).find("tr > td > input[type=text]").each(function(){
				//$(this).attr("onfocus","this.select()");    //现在不能实现内容全选
				//$(this).attr("onkeydown","'bindArrowKey(this)'");
				
				$(this).focus(function(){
					$(this).get(0).select();
				});
				$(this).keydown(function(){
					bindArrowKey($(this));
				});
			})
	})
}
function bindArrowKey(obj){
	//alert(event.keyCode);
	if(event.keyCode==40){
		goNext(obj);
	}else if(event.keyCode==38){
		goPrevious(obj);
	}else if(event.keyCode==37){
		goLeft(obj);
	}else if(event.keyCode==39){
		goRight(obj);
	}
}
function goNext(obj){
	var currIdx=0;
	$(obj).parentsUntil(":has(td)").parent().find('td').each(function(a){
		if($(this).find(obj).length==1){
			return false;
		}else{
			currIdx++;
		}
	});
	//最后一个元素 不做操作
	if($(obj).parentsUntil(":has(td)").parent().next().length==0){
		return;
	}
//	alert($(obj).parentsUntil(":has(td)").parent().next().find("td").eq(currIdx).find("input[type=text]").eq(0).parent().html());
	$(obj).parentsUntil(":has(td)").parent().next().find("td").eq(currIdx).find("input[type=text]").eq(0).focus();
}
function goPrevious(obj){
	var currIdx=0;
	$(obj).parentsUntil(":has(td)").parent().find('td').each(function(a){
		if($(this).find(obj).length==1){
			return false;
		}else{
			currIdx++;
		}
	});
	//第一个元素 不做操作
	if($(obj).parentsUntil(":has(td)").parent().prev().prev().length==0){
		return;
	}
	$(obj).parentsUntil(":has(td)").parent().prev().find("td").eq(currIdx).find("input[type=text]").eq(0).focus();
}
function goLeft(obj){
	//最左一个元素
	if($(obj).parent().prev().length==0){
		return false;
	}
	var currobj = $(obj).parent();
	while(true){
		if(currobj.prev().find("input[type=text]").length==1){
			$(currobj).prev().find("input[type=text]").eq(0).focus();
			return false;
		}else{
			//没有下一个元素
			if(currobj.prev().length==0){
				return false;
			}
			currobj=currobj.prev();
		}
	}
}
function goRight(obj){
	//最右一个元素
	if($(obj).parent().next().length==0){
		return false;
	}
	var currobj = $(obj).parent();
	while(true){
		if(currobj.next().find("input[type=text]").length==1){
			$(currobj).next().find("input[type=text]").eq(0).focus();
			return false;
		}else{
			//没有下一个元素
			if(currobj.next().length==0){
				return false;
			}
			currobj=currobj.next();
		}
	}
}