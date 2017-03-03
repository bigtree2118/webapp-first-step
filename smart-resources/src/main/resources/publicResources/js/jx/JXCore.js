/*
 * JXCore
 * v1.0.0
 * author: chenbing
 */

JXCore = {version: '1.0.0'};

/**
 * 将配置对象(c)的所有属性复制到一个对象(o)中
 * @param {Object} o obj The receiver of the properties
 * @param {Object} c The source of the properties
 * @param {Object} defaults A different object that will also be applied for default values
 * @return {Object} returns o
 * @member JXCore apply
 */
JXCore.apply = function(o, c, defaults){
	if(defaults){
        // no "this" reference for friendly out of scope calls
        JXCore.apply(o, defaults);
    }
    if(o && c && typeof c == 'object'){
        for(var p in c){
            o[p] = c[p];
        }
    }
    return o;
};

/**
 * 克隆复制一个对象
 * @param {Object} o 被克隆的对象
 * @return {Object} returns 新的对象
 * @member JXCore clone
 */
JXCore.clone = function(obj){
	var o;
	if(typeof obj == 'object'){
		if(obj === null){
			o = null;
		}else{
			if(obj instanceof Array){
				o = [];
				for(var i=0, len = obj.length; i<len; i++){
					o.push(JXCore.clone(obj[i]));
				}
			}else{
				o = {};
				for(var j in obj){
					o[j] = JXCore.clone(obj[j]);
				}
			}
		}
	}else{
		o = obj;
	}
	
	return o;
};

JXCore.apply(JXCore, {
	/**
     * 系统访问地址
    */
	basePath : null,
	
	/**
     * 一个可重用的空函数
     * @property
     * @type Function
    */
    emptyFn : function(){},
        
	/**
	 * 将配置对象(c)的所有属性复制到一个对象(o)中,被复制的属性只能是o对象中不存在的
	 * @param {Object} o The receiver of the properties
	 * @param {Object} c The source of the properties
	 * @return {Object} returns o
	 */
	applyIf: function(o, c){
	    if(o && c){
	        for(var p in c){
	            if(typeof o[p] == "undefined"){ o[p] = c[p]; }
	        }
	    }
	    return o;
	},
	
	/**
	 * 创建命名空间，用法如下：
	 * JXCore.namespace('Company', 'Company.data');
	 * Company.Widget = function() { ... }
	 * Company.data.CustomStore = function(config) { ... }
     * @param {String} namespace1
     * @param {String} namespace2
     * @param {String} etc
     * @method namespace
     */
	namespace : function(){
        var a=arguments, o=null, i, j, d, rt;
        for (i=0; i<a.length; ++i) {
            d=a[i].split(".");
            rt = d[0];
            eval('if (typeof ' + rt + ' == "undefined"){' + rt + ' = {};} o = ' + rt + ';');
            for (j=1; j<d.length; ++j) {
                o[d[j]]=o[d[j]] || {};
                o=o[d[j]];
            }
        }
    },
    
    /**
     * 判断传入的对象是否是null、undefined或者是一个空字符串
     * @param {Mixed} value The value to test
     * @param {Boolean} allowBlank (optional) true to allow empty strings (defaults to false)
     * @return {Boolean}
     */
    isEmpty : function(v, allowBlank){
        return v === null || v === undefined || (!allowBlank ? v === '' : false);
    },
    
    /**
     * 判断传入的对象是否是一个数组对象
     * @param {Object} object The object to test
     * @return {Boolean}
     */
    isArray : function(v){
        return v && typeof v.length == 'number' && typeof v.splice == 'function';
    },

    /**
     * 判断传入的对象是否是一个日期对象
     * @param {Object} object The object to test
     * @return {Boolean}
     */
    isDate : function(v){
        return v && typeof v.getFullYear == 'function';
    },
	
	/**
	 * 按模版格式化字符串
	 * @param 格式化之前的字符串
	 * @returns 格式化之后的字符串
	 */
	formatString : function(str) {
		for (var i = 0; i < arguments.length - 1; i++) {
			str = str.replace("{" + i + "}", arguments[i + 1]);
		}
		return str;
	},
	
	/**
	 * 格式化毫秒
	 * @param 格式化之前的字符串
	 * @returns 格式化之后的字符串
	 */
	formatMillis : function(ms) {
		if(ms == null){
			return "";
		}
		
		var time = ms;
		var day, hour, minute, second;
		day = Math.floor(time / 86400000);
		hour = Math.floor((time - day * 86400000) / 3600000);
		minute = Math.floor((time - day * 86400000 - hour * 3600000) / 60000);
		second = Math.floor((time - day * 86400000 - hour * 3600000 - minute * 60000) / 1000);
		
		return day + "天" + hour + "小时" + minute + "分" + second + "秒";
	},
	
	/**
	 * 将jquery.form表单元素的值序列化成对象
	 * @example JXCore.serializeForm($('#formId'))
	 * @param form
	 * @requires jQuery
 	 * @returns object
	 */
	serializeForm : function(form) {
		var o = {};
		$.each(form.serializeArray(), function(index) {
			if (this['value'] != undefined && this['value'].length > 0) {// 如果表单项的值非空，才进行序列化操作
				if (o[this['name']]) {
					o[this['name']] = o[this['name']] + "," + this['value'];
				} else {
					o[this['name']] = this['value'];
				}
			}
		});
		return o;
	}, 
	/**
	 * 将jquery.form表单元素的值序列化成对象
	 * @example JXCore.serializeForm($('#formId'))
	 * @param form
	 * @requires jQuery
 	 * @returns object
	 */
	serializeFormIncludeNull : function(form) {
		var o = {};
		$.each(form.serializeArray(), function(index) {
			if (this['value'] != undefined) {// 如果表单项的值非空，才进行序列化操作
				if (o[this['name']]) {
					o[this['name']] = o[this['name']] + "," + this['value'];
				} else {
					o[this['name']] = this['value'];
				}
			}
		});
		return o;
	}, 
    /**
     * Create a cookie with the given key and value and other optional parameters.
     * 
     * @example JXCore.cookie('the_cookie', 'the_value');
     * @desc Set the value of a cookie.
     * @example JXCore.cookie('the_cookie', 'the_value', { expires: 7, path: '/', domain: 'jquery.com', secure: true });
     * @desc Create a cookie with all available options.
     * @example JXCore.cookie('the_cookie', 'the_value');
     * @desc Create a session cookie.
     * @example JXCore.cookie('the_cookie', null);
     * @desc Delete a cookie by passing null as value. Keep in mind that you have to use the same path and domain used when the cookie was set.
     * 
     * @param String
     *            key The key of the cookie.
     * @param String
     *            value The value of the cookie.
     * @param Object
     *            options An object literal containing key/value pairs to provide optional cookie attributes.
     * @option Number|Date expires Either an integer specifying the expiration date from now on in days or a Date object. If a negative value is specified (e.g. a date in the past), the cookie will be deleted. If set to null or omitted, the cookie will be a session cookie and will not be retained when the the browser exits.
     * @option String path The value of the path atribute of the cookie (default: path of page that created the cookie).
     * @option String domain The value of the domain attribute of the cookie (default: domain of page that created the cookie).
     * @option Boolean secure If true, the secure attribute of the cookie will be set and the cookie transmission will require a secure protocol (like HTTPS).
     * @type undefined
     * 
     * @name JXCore.cookie
     * Get the value of a cookie with the given key.
     * 
     * @example JXCore.cookie('the_cookie');
     * @desc Get the value of a cookie.
     * 
     * @param String
     *            key The key of the cookie.
     * @return The value of the cookie.
     * @type String
     * 
     */
    cookie : function(key, value, options) {
    	if (arguments.length > 1 && (value === null || typeof value !== "object")) {
    		options = $.extend({}, options);
    		if (value === null) {
    			options.expires = -1;
    		}
    		if (typeof options.expires === 'number') {
    			var days = options.expires, t = options.expires = new Date();
    			t.setDate(t.getDate() + days);
    		}
    		return (document.cookie = [ encodeURIComponent(key), '=', options.raw ? String(value) : encodeURIComponent(String(value)), options.expires ? '; expires=' + options.expires.toUTCString() : '', options.path ? '; path=' + options.path : '', options.domain ? '; domain=' + options.domain : '', options.secure ? '; secure' : '' ].join(''));
    	}
    	options = value || {};
    	var result, decode = options.raw ? function(s) {
    		return s;
    	} : decodeURIComponent;
    	return (result = new RegExp('(?:^|; )' + encodeURIComponent(key) + '=([^;]*)').exec(document.cookie)) ? decode(result[1]) : null;
    },
    
    getCurrentTime: function(){
    	return (new Date()).getTime();
    }
});

JXCore.namespace('JXCore.dateUtil');
JXCore.applyIf(JXCore.dateUtil, {
	MILLI : "ms",
    SECOND : "s",
    MINUTE : "mi",
    HOUR : "h",
    DAY : "d",
    MONTH : "mo",
    YEAR : "y",
    
	/**
	 * 克隆复制一个Date对象
	 * @param date
	 * @returns {Date}
	 */
	clone : function(date) {
        return new Date(date.getTime());
    },
    
	/**
	 * 判断是否是闰年
	 * @param date
	 * @returns {Boolean}
	 */
	isLeapYear : function(date) {
        var year = date.getFullYear();
        return !!((year & 3) == 0 && (year % 100 || (year % 400 == 0 && year)));
    },
	
	/**
	 * 获取一个月的天数
	 */
	getDaysInMonth: (function() {
        var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        return function(date) { 
            var m = date.getMonth();

            return m == 1 && JXCore.dateUtil.isLeapYear(date) ? 29 : daysInMonth[m];
        };
    }()),
    
    /**
     * 获取月份的第一天的日期
     * @param date
     * @returns {Date}
     */
    getFirstDateOfMonth : function(date) {
        return new Date(date.getFullYear(), date.getMonth(), 1);
    },

    /**
     * 获取月份的最后一天的日期
     * @param date
     * @returns {Date}
     */
    getLastDateOfMonth : function(date) {
        return new Date(date.getFullYear(), date.getMonth(), JXCore.dateUtil.getDaysInMonth(date));
    },
    
    add : function(date, interval, value) {
        var d = JXCore.dateUtil.clone(date),
            day, decimalValue, base = 0;
        if (!interval || value === 0) {
            return d;
        }

        decimalValue = value - parseInt(value, 10);
        value = parseInt(value, 10);

        if (value) {
            switch(interval.toLowerCase()) {
                case JXCore.dateUtil.MILLI:
                    d.setTime(d.getTime() + value);
                    break;
                case JXCore.dateUtil.SECOND:
                    d.setTime(d.getTime() + value * 1000);
                    break;
                case JXCore.dateUtil.MINUTE:
                    d.setTime(d.getTime() + value * 60 * 1000);
                    break;
                case JXCore.dateUtil.HOUR:
                    d.setTime(d.getTime() + value * 60 * 60 * 1000);
                    break;
                case JXCore.dateUtil.DAY:
                    d.setDate(d.getDate() + value);
                    break;
                case JXCore.dateUtil.MONTH:
                    day = date.getDate();
                    if (day > 28) {
                        day = Math.min(day, JXCore.dateUtil.getLastDateOfMonth(JXCore.dateUtil.add(JXCore.dateUtil.getFirstDateOfMonth(date), JXCore.dateUtil.MONTH, value)).getDate());
                    }
                    d.setDate(day);
                    d.setMonth(date.getMonth() + value);
                    break;
                case JXCore.dateUtil.YEAR:
                    day = date.getDate();
                    if (day > 28) {
                        day = Math.min(day, JXCore.dateUtil.getLastDateOfMonth(JXCore.dateUtil.add(JXCore.dateUtil.getFirstDateOfMonth(date), JXCore.dateUtil.YEAR, value)).getDate());
                    }
                    d.setDate(day);
                    d.setFullYear(date.getFullYear() + value);
                    break;
            }
        }

        if (decimalValue) {
            switch (interval.toLowerCase()) {
                case JXCore.dateUtil.MILLI:    base = 1;               break;
                case JXCore.dateUtil.SECOND:   base = 1000;            break;
                case JXCore.dateUtil.MINUTE:   base = 1000*60;         break;
                case JXCore.dateUtil.HOUR:     base = 1000*60*60;      break;
                case JXCore.dateUtil.DAY:      base = 1000*60*60*24;   break;

                case JXCore.dateUtil.MONTH:
                    day = JXCore.dateUtil.getDaysInMonth(d);
                    base = 1000*60*60*24*day;
                    break;

                case JXCore.dateUtil.YEAR:
                    day = (utilDate.isLeapYear(d) ? 366 : 365);
                    base = 1000*60*60*24*day;
                    break;
            }
            if (base) {
                d.setTime(d.getTime() + base * decimalValue); 
            }
        }

        return d;
    }
});


/**
 * 扩展数组Array的prototype
 */
JXCore.applyIf(Array.prototype, {
    /**
     * Checks whether or not the specified object exists in the array.
     * @param {Object} o The object to check for
     * @return {Number} The index of o in the array (or -1 if it is not found)
     */
    indexOf : function(o){
       for (var i = 0, len = this.length; i < len; i++){
          if(this[i] == o) return i;
       }
       return -1;
    },

    /**
     * Removes the specified object from the array.  If the object is not found nothing happens.
     * @param {Object} o The object to remove
     * @return {Array} this array
     */
    remove : function(o){
       var index = this.indexOf(o);
       if(index != -1){
           this.splice(index, 1);
       }
       return this;
    }
});

/**
 * 扩展字符串String的prototype
 */
JXCore.applyIf(String, {

    /**
     * 对字符(' 和 \)进行转义 
     * @param {String} string The string to escape
     * @return {String} The escaped string
     * @static
     */
    escape : function(string) {
        return string.replace(/('|\\)/g, "\\$1");
    },

    /**
     * 用自定的字符填充字符串的左边，这个功能在进行数字和日期字符串的格式化时特别游泳。
     * 用法如下:
     * var s = String.leftPad('123', 5, '0');
	 * s 变为了 '00123'
     * @param {String} string The original string
     * @param {Number} size The total length of the output string
     * @param {String} char (optional) The character with which to pad the original string (defaults to empty string " ")
     * @return {String} The padded string
     * @static
     */
    leftPad : function (val, size, ch) {
        var result = new String(val);
        if(!ch) {
            ch = " ";
        }
        while (result.length < size) {
            result = ch + result;
        }
        return result.toString();
    },

    /**
     * 格式化包含占位符的字符串.每个占位符必须唯一，必须已{0},{1},{2}.....的格式递增
     * 用法如下：
     * var cls = 'my-class', text = 'Some text';
     * var s = String.format('&lt;div class="{0}">{1}&lt;/div>', cls, text);
     * s 变为了 '&lt;div class="my-class">Some text&lt;/div>'
     * @param {String} string The tokenized string to be formatted
     * @param {String} value1 The value to replace token {0}
     * @param {String} value2 Etc...
     * @return {String} The formatted string
     * @static
     */
    format : function(format){
        var args = Array.prototype.slice.call(arguments, 1);
        return format.replace(/\{(\d+)\}/g, function(m, i){
            return args[i];
        });
    }
});

/**
 * 去掉字符串前后的空白字符
 */
String.prototype.trim = function(){
    var re = /^\s+|\s+$/g;
    return function(){ return this.replace(re, ""); };
}();

/**
 * 去掉字符串左边的空白字符
 */
String.prototype.ltrim = function(){
    var re = /(^\s*)/g;
    return function(){ return this.replace(re, ""); };
}();

/**
 * 判断开始字符是否是XX
 * @param {String} XX
 */
String.prototype.startWith = function(str) {
	var reg = new RegExp("^" + str);
	return function(){ return reg.test(this); };
}();

/**
 * 判断结束字符是否是XX
 * @param {String} XX
 */
String.prototype.endWith = function(source, str) {
	var reg = new RegExp(str + "$");
	return function(){ return reg.test(this); };
}();

/**
 * 去掉字符串右边的空白字符
 */
String.prototype.rtrim = function(){
    var re = /(\s*$)/g;
    return function(){ return this.replace(re, ""); };
}();

/**
 * 扩展数字Number的prototype
 */
JXCore.applyIf(Number.prototype, {
    
});

/**
 * 对Date的扩展，将 Date 转化为指定格式的String 
 * 月(M)、日(d)、小时(h)、分(m)、秒(s)、季度(q) 可以用 1-2 个占位符， 
 * 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) 
 * 例子： 
 * (new Date()).Format("yyyy-MM-dd hh:mm:ss.S") ==> 2006-07-02 08:09:04.423 
 * (new Date()).Format("yyyy-M-d h:m:s.S")      ==> 2006-7-2 8:9:4.18
 */ 
Date.prototype.format = function(fmt){ //author: meizz 
	var o = { 
		"M+" : this.getMonth()+1,                 //月份 
		"d+" : this.getDate(),                    //日 
		"h+" : this.getHours(),                   //小时 
		"m+" : this.getMinutes(),                 //分 
		"s+" : this.getSeconds(),                 //秒 
		"q+" : Math.floor((this.getMonth()+3)/3), //季度 
		"S"  : this.getMilliseconds()             //毫秒 
	}; 
	if(/(y+)/.test(fmt)) 
		fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
	for(var k in o) 
		if(new RegExp("("+ k +")").test(fmt)) 
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length))); 
	return fmt; 
};

/**
 * 扩展日期Date的prototype
 */
JXCore.applyIf(Date.prototype, {
	/**
	 * 返回与另一个时间之间相差的毫秒数
	 * @param {Date} date (optional) Defaults to now
	 * @return {Number} The diff in milliseconds
	 * @member Date getElapsed
	 
    getElapsed: function(date) {
	    return Math.abs((date || new Date()).getTime()-this.getTime());
	}
	*/
	
	
});

/**
 * 扩展函数Function的prototype
 */
Function.prototype.bind = function(obj) {
	var method = this;
	temp = function() {
		return method.apply(obj, arguments);
	};
	return temp;
};


