/*
 *easyui.datagrid.extend.js
 *date:2014.12.3
 *create by dint
 *http://www.cnblogs.com/dint/
*/

(function (jq, methods) {
    methods = {
        encoder:document.createElement("div"),
        edtypes: ",numberbox,text,datebox,selectbox,",
        zIndex:0,
        htmlEncode: function (value) {
            var encoder = jq(methods.encoder);
            encoder.text(value);
            return encoder.html();
        },
        getGridTrRow: function (grid,irow,opts) {
            irow = parseInt('' + irow, 10);
            opts = opts||jq.data(grid, "datagrid").options;
            var tr_ = opts.finder.getTr(grid, irow);
            var _bodyTr = ((tr_.length > 1) ? tr_[1] : tr_[0]);
            var _body = jq(jq(_bodyTr).parents('table')[0]).parent('div.datagrid-body')[0];
            var editors = jq(_bodyTr).find('div.editor_grid_div');
            var iRowEdit_=-1;
            if(editors.length){
                var sArr=editors[0].id.split('_');
                iRowEdit_ = parseInt(sArr[0],10);
            }
            return {
                body: _body,
                bodyTr: _bodyTr,
                tr: tr_,
                row: opts.finder.getRow(grid, irow),
                iRowEdit: iRowEdit_
            };
        },
		init:function(opts){
			if(!this.datagrid){
			   jq.error('can not find easyui framework!');
			}
			if((!opts)||(!opts.columns)||(!opts.columns.length)){
			   this.datagrid.apply(this,arguments);return;
			}
			var heads = opts.columns[0];
			opts._editor_list_ = [];
			opts._editor_rowindex = 0;
			opts._editor_oldinx = -1;
			opts.focusColor = opts.focusColor || '#ffe48d';
			if (opts.singleSelect) opts._editor_focusrow = {}, opts._row_current = null;
			for(var i=0,il=heads.length,head;i<il;i++){
			  head=heads[i];
			  if(head){
			      if (head.editor && (methods.edtypes.indexOf("," + head.editor.type + ",") >= 0)) {
			          head._editor = head.editor;
			          opts._editor_list_.push('' + i + '_' + head.field);
			          head.editor = null;
			          head.formatter = (function (i0, field0,myopts) {
			              return function (val, row, inx) {
			                  if (opts._editor_oldinx !== inx) {
			                      myopts._editor_rowindex++;
			                  }
			                  opts._editor_oldinx = inx;
			                  return "<div class='editor_grid_div' id='"
                                  + myopts._editor_rowindex + "_" + i0 + "_" + field0 + "'>"
                                  + methods.htmlEncode(val)+"</div>";
			          }})(i,head.field+'',opts);
			    }
			  }
			}
			opts._editor_field = opts._editor_list_[0];
		    /*
            opts._onLoadSuccess=opts.onLoadSuccess;
			opts.onLoadSuccess = (function (opt,method) {
			    return function (data) {
			        method._loadCompleted(this, data.length);
			     if (opt._onLoadSuccess && (opt._onLoadSuccess.apply(this,arguments) === false)) return false;
		    }})(opts,methods);
            */
			this.datagrid.apply(this, arguments);
			this.each(function () {
			    methods._loadCompleted(this,0);
			});
		},
		//_focusColor: '#ffe48d',
		_loadCompleted: function (grid, rlen) {
		    var append = false;
		    var opts = jq.data(grid, "datagrid").options;
		    var trow = methods.getGridTrRow(grid, 0), _tr = jq(trow.bodyTr);
		    if ((!trow.row)||(trow.row.length === 0)) {
		        jq(grid).datagrid('appendRow', {});
		        append = true;
		    }
		    trow = methods.getGridTrRow(grid, 0), _tr = jq(trow.bodyTr);
		    var body = jq(_tr.parents('table')[0]).parent('div.datagrid-body');
		    var header = body.parent('div').children('div.datagrid-header');
		    var footer = body.parent('div').children('div.datagrid-footer');
		    opts._tip_body = body;
		    opts._header_offset_ = {
		        width: header.width()||0,
		        height: header.height()||0,
		        innerWidth:header.innerWidth()||0,
		        innerHeight: header.innerHeight() || 0,
		        outerWidth: header.outerWidth() || 0,
		        outerHeight: header.outerHeight() || 0,
		        offset: header.offset() || {},
		        position: header.position() || {}
		    };
		    var bg = "";
		    body.unbind('click');
		    (function (m, g) {
		        var fnRC = function (e) {
		            var tr = e.target;
		            if ((!tr.tagName) || (tr.tagName.toLowerCase() !== 'tr')) {
		                var div = jq(tr).parents('div.editor_grid_div');
		                if (div.length > 0) { tr = jq(div[0]).parents('tr')[0]; }
		                else { tr = jq(tr).parents('tr')[0]; }
		            }
		            if (tr && ((typeof tr.rowIndex) != 'undefined') && (tr.rowIndex >= 0)) m._rowFocus(g, tr.rowIndex, e.target);
		        }
		        body.click(fnRC);
		    })(this, grid);
		    if (append) jq(grid).datagrid('deleteRow', 0);
		},
		_rowFocus: function (grid, irow, target, opts) {
		    irow = parseInt('' + irow, 10);
		    var opts =opts||jq.data(grid, "datagrid").options;
		    var trow = this.getGridTrRow(grid, irow, opts);
		    var tr = trow.bodyTr, row = trow.row;
		    if (!row) return;
		    var be = !((!row.__editor__) || (row.__editor__.status !== 1));
		    if (be && opts.onRowBlur && opts._row_current){
		        var rowinx0 = opts._row_current.rowIndex;
		        var trow0 = this.getGridTrRow(grid, rowinx0, opts);
		        var row0 = trow0.row, tr0 = trow0.bodyTr;
		        if (opts.onRowBlur.apply(grid,
                               [rowinx0, row0, tr0]) === false) return;
		    }

		    if (opts._editor_focusrow) {
		        jq(opts._editor_focusrow).css('background-color', '');
		        opts._editor_focusrow = tr;
		    }
		    //jq(tr).css('background-color',this._focusColor);focusColor
		    jq(tr).css('background-color', opts.focusColor);
		    if (!be) return;
		    /*
            if (opts.onRowBlur&&opts._row_current) {
		        var rowinx0 = opts._row_current.rowIndex;
		        var trow0 = this.getGridTrRow(grid, rowinx0, opts);
		        var row0 = trow0.row, tr0 = trow0.tr[1];
		        if (opts.onRowBlur.apply(grid,
                               [rowinx0, row0, tr0]) === false) return;
		    }
            */
		    opts._row_current = tr;
		    var editor_cell;
		    if ((target!==null)&&(target!==undefined)) {
		        var ntarget=parseInt(target, 10);
		        if ((!isNaN(ntarget)) && (ntarget >= 0)) {
		            if ((ntarget>=0) && (ntarget < opts._editor_list_.length)) {
		                opts._editor_field = opts._editor_list_[ntarget];
		            }
		        } else {
		            editor_cell = jq(target).parents('div.editor_grid_div');
		            if (editor_cell.length) {
		                var sArr = editor_cell[0].id.split('_');
		                opts._editor_field = sArr.slice(1).join('_');
		            }
		            else if (target.parentNode.tagName &&
                        (target.parentNode.tagName.toLowerCase() == 'td')) {
		                editor_cell = jq(target).find('div.editor_grid_div');

		                if (opts._editor_list_ && editor_cell.length) {
		                    var cellInx = target.parentNode.cellIndex;
		                    for (var i = 0, il = opts._editor_list_.length; i < il; i++) {
		                        sArr = opts._editor_list_[i].split('_');
		                        if (parseInt(sArr[0], 10) === cellInx) {
		                            opts._editor_field = opts._editor_list_[i];
		                            break;
		                        }
		                    }
		                }
		            }
		        }
		    }
            
		    if (opts._editor_field) {
		        sArr = opts._editor_field.split('_');
		        var cinx = parseInt(sArr[0]), field = sArr.slice(1).join('_');
		        var head = opts.columns[0][cinx];
		        if (head._editor && head._editor.type) {
		            var box = methods._boxFactory(head._editor.type);
		            var editArr = jq(tr).find('div.editor_grid_div');
		            if (editArr.length) {
		                sArr = editArr[0].id.split('_');
		                irow = parseInt(sArr[0]);
		            }
		            /*var cedit = jq(tr).find('#' + irow + '_' + opts._editor_field);*/
		            var cedit = methods._nearedit(irow, tr, opts, opts._editor_field);
		            if (box&&cedit&&cedit.length) box.focus.call(cedit[0],true);
		            if (opts.onRowFocus && (opts.onRowFocus.apply(grid,
                        [tr.rowIndex, row, tr]) === false)) return;
		        }
		    }
		},
		_nearedit: function (irow, tr,opts, sedit) {
		    var cedit = jq(tr).find('#' + irow + '_' + opts._editor_field);
		    if ((cedit.length) && (cedit.is(':visible'))) return cedit;
		    var list_edits = opts._editor_list_;
		    var index = -1;
		    for (var i = 0, il = opts._editor_list_.length; i < il; i++) {
		        if (opts._editor_list_[i]===sedit){
		            index = i;
		            break;
		        }
		    }
		    if (index >= 0) {
		        var near_l =-1,near_r=-1,ed;
		        for (i = index; i >= 0; i--) {
		            ed = jq(tr).find('#' + irow + '_' + opts._editor_list_[i]);
		            if (ed.length && (ed.is(':visible'))) {
		                near_l = i; break;
		            }
		        }
		        for (i = index, il = opts._editor_list_.length; i < il; i++) {
		            ed = jq(tr).find('#' + irow + '_' + opts._editor_list_[i]);
		            if (ed.length && (ed.is(':visible'))) {
		                near_l = i; break;
		            }
		        }
		        if ((near_l < 0) && (near_r < 0)) { cedit=null; }
		        else {
		            if (near_l < 0) {
		                cedit = jq(tr).find('#' + irow + '_' + opts._editor_list_[near_r]);
		            } else {
		                if (near_r < 0) {
		                    cedit = jq(tr).find('#' + irow + '_' + opts._editor_list_[near_l]);
		                } else {
		                    cedit = jq(tr).find('#' + irow + '_'
                                + opts._editor_list_[((near_l < near_r) ? near_l : near_r)]);
		                }
		            }
		        }
		    }
		},
		toolTip:function(irow,message){
		    this.each(function () {
		        methods._toolTip(this, irow, message);
		    });
		},
		unToolTip:function(irow){
		    this.each(function () {
		        methods._unToolTip(this, irow);
		    });
		},
		_toolTip: function (grid, irow, message) {
		    irow = parseInt('' + irow, 10);
		    var opts = opts || jq.data(grid, "datagrid").options;
		    var trow = methods.getGridTrRow(grid, irow, opts), _tr = jq(trow.bodyTr);
		    var trPos = _tr.offset(), tabPos = opts._tip_body.offset();
		    /*var pos = _tr.offset();*/
		    if (opts._gridedit_tip_) {
		        opts._gridedit_tip_.remove && opts._gridedit_tip_.remove();
		    }
		    var html = [];
		    html[html.length] = "<div class='tooltip-content'><span class='editgrid_tooltip_content' style='color:red'></span>";
		    html[html.length] = "</div><div class='tooltip-arrow-outer'></div><div class='tooltip-arrow'></div>";
		    var tip = jq("<div tabindex='-1' class='tooltip tooltip-bottom'></div>");
		    tip.html(html.join(''));
		    tip.appendTo(opts._tip_body);
		    opts._gridedit_tip_ = tip;
		    
		    opts._gridedit_tip_.find('span.editgrid_tooltip_content').text(message);
		    var pos = _tr.position();
		    var tipPos = (((tabPos.top + opts._tip_body.height() - trPos.top - _tr.height()
                                             - opts._gridedit_tip_.outerHeight()) < 0) ? 'top' : 'bottom');
		    opts._gridedit_tip_[0].className = 'tooltip tooltip-' + tipPos;
		    var tipt= ((tipPos === 'bottom') ? (pos.top + _tr.height())
                                             : (pos.top - opts._gridedit_tip_.outerHeight()));
		    if (tipt < 0) {
		        tipt = opts._header_offset_.outerHeight || _tr.outerHeight();
		    }
		    else if (tipt > (opts._tip_body.innerHeight())) {
		        var footer = opts._tip_body.parent('div').children('div.datagrid-footer');
		        if (footer&&footer.length) {
		            tipt = (footer.position().top - opts._gridedit_tip_.outerHeight()
                        - 6 - opts._tip_body.outerHeight() + opts._tip_body.height());
		        } else {
		            tipt = (opts._tip_body.innerHeight()
                   - opts._gridedit_tip_.outerHeight());
		        }
		    }
		    var tipl = jq(grid).position().left + ((jq(opts._tip_body).width() - opts._gridedit_tip_.width()) / 2);
		    opts._gridedit_tip_.css({
		        'left': tipl + 'px',
		        'top': tipt + 'px',
		        'z-index': '9000',
		        'display': 'block',
		        'position': 'absolute'
		    });
		},
		_unToolTip: function (grid) {
		    var opts = opts || jq.data(grid, "datagrid").options;
		    if (!opts._gridedit_tip_) return;
		    opts._gridedit_tip_.css('display', 'none');
		    opts._gridedit_tip_.remove();
		    opts._gridedit_tip_ = null;
		},
		textBox:{
		    init: function (rinx, cinx, field, row, head) {
		        var txtbox = document.createElement('INPUT');
		        txtbox.type = 'text';
		        jq(txtbox).addClass("textbox-txt");
		        /*txtbox.style.width = "100%";*/
		        jq(txtbox).val(row[field]);
		        var args = [], args = args.slice.call(arguments, 0);
		        args.push(txtbox);
		        methods.textBox._bindTxtEvents.apply(this, args);
		        return txtbox;
		    },
		    _bindTxtEvents: function (rinx, cinx, field, row, head,txtbox) {
		        if (head._editor.options) {
		            if (head._editor.options.onChange) {
		                row.__editor__.values[cinx] = txtbox.value;
		                txtbox.onchange = (function (_e, _row, _inx, fnChange) {
		                    return function () {
		                        var args = [];
		                        args = args.concat(this.value, _row.__editor__.values[_inx], _row,
                                    args.slice.call(arguments, 0));
		                        _row.__editor__.values[_inx] = this.value;
		                        var ret = _e.options.onChange.apply(this, args);
		                        if (fnChange && (fnChange.apply(this, arguments) === false)) return false;
		                    }
		                })(head._editor, row, cinx, txtbox.onchange);
		            }
		            if (head._editor.options.onKeyDown) {
		                txtbox.onkeydown = (function (_e, _row, _inx, fnKeyD) {
		                    return function (e) {
		                        var args = [];
		                        e=e||window.event;
		                        args = args.concat(e, this.value, _row,
                                    args.slice.call(arguments, 1));
		                        if (_e.options.onKeyDown.apply(this, args) === false) return false;
		                        if (fnKeyD && (fnKeyD.apply(this, arguments) === false)) return false;
		                    }
		                })(head._editor, row, cinx, txtbox.onkeydown);
		            }
		        }
		    },
		    val: function (data) {
		        return methods.textBox.target.call(this).val(data);
		    },
		    target:function(){
		        return jq(this).find('input[type=text]');
		    },
		    focus: function (selected) {
		        var fobj = jq(this).find('input[type=text]');
		        fobj.focus()
		        if (selected) fobj.select();
		    },
		    destroy: function (rinx, cinx, field, row, head) {
		        row[field] = jq(this.childNodes[0]).val();
		        jq(this).html('');
		        jq(this).text(row[field]);
		    }
		},
		numberBox:{
		    init: function (rinx, cinx, field, row, head) {
		        var numberbox = methods.textBox.init.apply(this, arguments);
		        numberbox.onkeydown = (function (method, fnKeyD) {
		            return function (e) {
		                e=e||window.event;
		                if (fnKeyD && (fnKeyD.apply(this, arguments) === false)) return false;
		                if (method._invalidateNumberBox(this, e) === false) return false;
		            }
		        })(methods, numberbox.onkeydown);
		        return numberbox;
		    },
		    focus: function (selected) {
		        methods.textBox.focus.apply(this, arguments);
		    },
		    target: function () {
		        return methods.textBox.target.apply(this, arguments);
		    },
		    val: function (data) {
		        return methods.textBox.val.apply(this, arguments);
		    },
		    destroy: function () {
		        methods.textBox.destroy.apply(this, arguments);
		    }
		},
		selectBox: {
		    _init:function(rinx, cinx, field, row, head,icon,icon1,mOpts){
		        var html = [];
		        html[html.length] = "<table cellpadding='0' border='0' cellspacing='0' style='width:100%'>";
		        html[html.length] = "<tr><td>";
		        html[html.length] = "<input type='text' class='"
                    + icon + "-text' style='width:100%; height: 20px; line-height: 20px;'/>";
		        html[html.length] = "</td><td style='width:20px'>";
		        html[html.length] = "<span class='" + icon + "-arrow' style='height: 20px;width:20px'>";
		        html[html.length] = "</span>";
		        html[html.length] = "</td></tr></table>";
		        var span = jq("<span class='" + icon + " "+icon1+"' style='width: 100%; height: 20px;'></span>");
		        span.html(html.join(''));
		        span.find('input.' + icon + '-text').val(row[field]);
		        (function (_span, _arrow, _opts) {
		            _span.find( 'span.' +_arrow+ '-arrow').click(function (e) {
		                var args = [], args = args.slice.call(arguments, 0);
		                _opts.mArrowClick.apply(span.find('input.' + _arrow + '-text')[0],args);
		            });
		        })(span, icon, mOpts);
		        var args = [rinx, cinx, field, row, head, span.find('input.' + icon + '-text')[0]];
		        methods.textBox._bindTxtEvents.apply(this,args);
		        return span[0];
		    },
		    init: function (rinx, cinx, field, row, head) {
		        var args = [];
		        args = args.slice.call(arguments, 0);
		        args.push('selector', 'selectbox', {
		            mArrowClick:(function (_head) {
		                return function () {
		                    if (_head._editor && _head._editor.options) {
		                        if (_head._editor.options.onSelectHandler) {
		                            var args = [], args = args.slice.call(arguments,0);
		                            args.push(rinx, row, cinx);
		                            _head._editor.options.onSelectHandler.apply(this,args);
		                        }
		                    }
		                }
		            })(head, rinx)
		        });
		        return methods.selectBox._init.apply(this,args)
		    },
		    focus: function (selected) {
		        var fobj = jq(this).find('input.selector-text');
		        fobj.focus()
		        if (selected) fobj.select();
		    },
		    val: function (data) {
		        return methods.selectBox.target.call(this).val(data);
		    },
		    target: function () {
		        return jq(this).find('input.selector-text');
		    },
		    destroy: function (rinx, cinx, field, row, head) {
		        row[field] = jq(this).find('input.selector-text').val();
		        jq(this).html('');
		        jq(this).text(row[field]);
		    }
		},
		dateBox: {
            calendar:null,
		    init: function (rinx, cinx, field, row, head) {
		        var args = [];
		        args = args.slice.call(arguments, 0);
		        args.push('combo', 'datebox', {
		            mArrowClick:(function(h){
		                return function () {
		                var calendar=methods.dateBox.calendar;
		                if (!calendar) {
		                    var html = [];
		                    html[html.length] = "<table cellpadding='0' border='0' cellspacing='0'>";
		                    html[html.length] = "<tr><td class='editgrid_calendar'><td></tr>";
		                    html[html.length] = "<tr><td style='text-align:center'><a href='#' class='editgrid_calendar_tody'>今天</a>&nbsp;&nbsp;";
		                    html[html.length] = "&nbsp;&nbsp;<a href='#' class='editgrid_calendar_close'>关闭</a><td></tr>";
		                    html[html.length] = "</table>";
		                    calendar = methods.dateBox.calendar = jq('<div></div>');
		                    calendar.html(html.join(''));
		                    calendar.appendTo(document.body);
		                }
		                var pos = jq(this).offset();
		                calendar.css({
		                    'z-index': '998',
		                    'display': 'block',
		                    'position': 'absolute',
		                    'left': pos.left + 'px',
		                    'border': 'solid 1px #95B8E7',
		                    'background-color':'#f5f5f5',
		                    'top': pos.top+jq(this).height() + 'px'
		                });
		                calendar.find('a.editgrid_calendar_tody')[0].onclick = (function (target, datebox, ghead) {
		                    return function () {
		                        var d = new Date(),target_=jq(target);
		                        var oval = target_.val(), nval = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate();
		                        target_.val(nval);
		                        datebox.calendar.find('td.editgrid_calendar').html('');
		                        datebox.calendar.css('display', 'none');
		                        datebox.focus.call(target_.parents('div.editor_grid_div')[0], true);
		                        if ((oval !== nval) && ghead && ghead._editor && ghead._editor.options) {
		                            ghead._editor.options.onChange && ghead._editor.options.onChange.apply(target, [nval, oval]);
		                        }
		                    }
		                })(this,methods.dateBox,h)
		                calendar.find('a.editgrid_calendar_close')[0].onclick = (function (target,datebox) {
		                    return function () {
		                        datebox.calendar.find('td.editgrid_calendar').html('');
		                        datebox.calendar.css('display', 'none');
		                        datebox.focus.call(jq(target).parents('div.editor_grid_div')[0], true);
                                
		                    }
		                })(this,methods.dateBox)
		                var _container=calendar.find('td.editgrid_calendar');
		                _container.html('');
		                var _calendar = jq('<div></div');
		                _calendar.appendTo(_container[0]);
		                
		                (function (target,mycalendar,datebox,ghead) {
		                    var _arg = {
		                        weeks: ['日', '一', '二', '三', '四', '五', '六'],
		                        months:['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
		                        onSelect: function (date) {
		                            var target_ = jq(target), oval = target_.val();
		                            var nval =date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
		                            target_.val(nval);
		                            mycalendar.find('.editgrid_calendar').html('');
		                            mycalendar.css('display', 'none');
		                            datebox.focus.call(target_.parents('div.editor_grid_div')[0], true);
		                            if ((nval !== oval) && ghead._editor && ghead._editor.options) {
		                                ghead._editor.options.onChange && ghead._editor.options.onChange.apply(target, [nval, oval]);
		                            }
		                        }
		                    }
		                    var d_arr = target.value.split('-');
		                    var n_year=parseInt(d_arr[0], 10);
		                    if (n_year&&(n_year>1900)&&(n_year<2200)) _arg.year = n_year;
		                    var n_month = parseInt(d_arr[1], 10);
		                    if (n_month && (n_month >= 1) && (n_month <= 12)) _arg.month = n_month;
		                    _arg.current = new Date(), _arg.current.setFullYear(n_year, n_month - 1, parseInt(d_arr[2], 10));
		                    _calendar.calendar(_arg);
		                })(this, calendar,methods.dateBox,h);
		            }})(head)
		        });
		        return methods.selectBox._init.apply(this, args);
		    },
		    focus: function (selected) {
		        var fobj = jq(this).find('input.combo-text');
		        fobj.focus();
		        if (selected) fobj.select();
		    },
		    val: function (data) {
		        return methods.dateBox.target.call(this).val(data);
		    },
		    target: function () {
		        return jq(this).find('input.combo-text');
		    },
		    destroy: function (rinx, cinx, field, row, head) {
		        row[field] = jq(this).find('input.combo-text').val();
		        jq(this).html('');
		        jq(this).text(row[field]);
		    }
		},
		_deleteRow:function(grid,irow,opts){
		    opts = opts || jq.data(grid, "datagrid").options;
		    var trow = methods.getGridTrRow(grid, irow, opts);
		    var tr = trow.bodyTr, row = trow.row;
		    if (opts._row_current && (tr=== opts._row_current)) {
		        var nRowInx=-1;
		        var rows=jq(grid).datagrid('getRows');
		        if (irow >=0&&(irow<rows.length-1)) {
		            nRowInx = irow+1;
		        } else {
		            if (rows.length > 0) {
		                nRowInx = irow-1;
		            }
		        }
		        if (nRowInx!==-1)
		            methods._rowFocus(grid,nRowInx, null, opts);
		    }
		    jq(grid).datagrid('deleteRow', irow);
		},
		_editRow: function (grid, irow, opts) {
		    irow = parseInt('' + irow, 10);
			 opts=opts||jq.data(grid,"datagrid").options;
		    var trow = methods.getGridTrRow(grid, irow, opts);
		    var tr = trow.tr, row = trow.row;
				if ((row.__editor__) && (row.__editor__.status === 1)) return;
				if (!row.__editor__) row.__editor__ = { values: {}, status: 1 };
				var heads = opts.columns[0];
				var cedits = jq(trow.bodyTr).find('div.editor_grid_div');
				for (var i = 0, il = cedits.length, cedit, box; i < il; i++) {
				    cedit = cedits[i]; box = null; fbox = null;
				    var sArr = cedit.id.split('_'), sfield = sArr.slice.call(sArr, 2).join('_');
				    var cinx = parseInt(sArr[1], 10), head = heads[cinx];
				    if (heads) {
				        var cinx = parseInt(sArr[1], 10), head = heads[cinx];
				        if (head && head._editor && head._editor.type) {
				            box = methods._boxFactory(head._editor.type);
				            if (box) {
				                box = box.init.apply(cedit, [parseInt(sArr[0], 10), cinx, sfield, row, head]);
				                jq(cedit).html('');
				                cedit.appendChild(box);
				            }
				        }
				    }
				}
				row.__editor__.status = 1;

		        /*????*/
				if (opts._keyboard && (opts._keyboard._keyusing === true)) {
				    methods.keyBoard._bindEvtOneRow(grid, null, opts, null, irow);
				}
		},
		_invalidateNumberBox:function(target,e){
		    if (!(((e.keyCode >= 48) && (e.keyCode <= 57))
                || (e.keyCode === 189) || (e.keyCode === 190)
                || (e.keyCode === 46) || (e.keyCode === 8))) {
		        return false;
		    }
		},
		_endEditRow: function (grid, irow, opts) {
		  opts=opts||jq.data(grid,"datagrid").options;
		    var trow = methods.getGridTrRow(grid, irow, opts);
		    var tr = trow.tr, row = trow.row;
			if ((!row.__editor__) || (row.__editor__.status !== 1)) return;
			var heads = opts.columns[0];
			var cedits = jq(trow.bodyTr).find('div.editor_grid_div');
			for(var i=0,il=cedits.length,cedit,head,box;i<il;i++){
			   cedit=cedits[i],box=null;
			   var sArr = cedit.id.split('_'), sfield = sArr.slice.call(sArr, 2).join('_');
			   if (heads) {
			       var cinx = parseInt(sArr[1], 10), head = heads[cinx];
			       if (head && head._editor&&head._editor.type) {
			           box = methods._boxFactory(head._editor.type);
			           if(box)box.destroy.apply(cedit,[parseInt(sArr[0], 10), cinx, sfield, row, head]);
			       }
			   }
			}
			row.__editor__.status = 0;
		},
		_showZz: function () {
		    var z,_z,m,_m;
		    if (!(z = document.getElementById(this.mId))) {
		        z = document.createElement('DIV');
		        document.body.appendChild(z);
		    }
		    if(!(m=document.getElementById(this.mId+'_MSG'))){
		        _m = jq("<div class='datagrid-mask-msg' id='" + this.mId + "_MSG'></div>");
		        m = _m[0];
		        document.body.appendChild(m);
		    }
		    _z = jq(z);
		    var _table = jq(this.mZObj),pos=_table.offset();
		    _z.css({
		        'z-index': '999',
		        'display': 'block',
		        'position': 'absolute',
                'background-color':'#000000',
                'left': pos.left + 'px',
                'top': pos.top + 'px',
                'opacity': '0.05'
		    });
		    _z.width(_table.outerWidth());
		    _z.height(_table.outerHeight());
		    _m = jq(m);
		    _m.text('数据加载中....');
		    _m.removeClass('data-loading');
		    _m.addClass('data-loading');
		    _m.css({
		        'z-index': '1000',
		        'display': 'block',
		        'position': 'absolute',
		        'left': (pos.left+((_z.width()-_m.width())/2)) + 'px',
		        'top': (pos.top+((_z.height() - _m.height())/2)) + 'px'
		    });
		    this.mask = { z: z, m: m };
		},
		_closeZZ: function () {
		    if (!this.mask) return;
		    if(this.mask.z)jq(this.mask.z).remove();
		    if (this.mask.m) jq(this.mask.m).remove();
		    this.mask = null;
		},
		_boxFactory: function (type) {
		    var box;
		    if (type === 'text') {
		        box = methods.textBox;
		    } else if (type === 'numberbox') {
		        box = methods.numberBox;
		    } else if (type === 'datebox') {
		        box = methods.dateBox;
		    } else if (type === 'selectbox') {
		        box = methods.selectBox;
		    }
		    else {
		        box = methods[type];
		    }
		    return box;
		},
		keyBoard: {
		    init: function (grid) {
		        var opts = jq.data(grid, "datagrid").options;
		        var rows = jq(grid).datagrid('getRows');
		        opts._keyboard = {
		            rowIndex: 0,
		            cellIndex: 0,
		            _keyusing:true
		        };
		        if (rows.length > 0) {
		            jq(grid).editgrid('rowFocus', 0, 0);
		        }
		        var _37 = 37, _38 = 38, _39 = 39, _40 = 40, _13 = 13, num;
		        if (opts.kBoard) {
		            num = parseInt(opts.kBoard.kLeft, 10);
		            if ((!isNaN(num)) && (num >= 1) && (num <= 127)) _37 = num;
		            num = parseInt(opts.kBoard.kTop, 10);
		            if ((!isNaN(num)) && (num >= 1) && (num <= 127)) _38 = num;
		            num = parseInt(opts.kBoard.kRight, 10);
		            if ((!isNaN(num)) && (num >= 1) && (num <= 127)) _39 = num;
		            num = parseInt(opts.kBoard.kDown, 10);
		            if ((!isNaN(num)) && (num >= 1) && (num <= 127)) _40 = num;
		            num = parseInt(opts.kBoard.kMain, 10);
		            if ((!isNaN(num)) && (num >= 1) && (num <= 127)) _13 = num;
		        }
		        opts._keyboard._37 = _37, opts._keyboard._38 = _38;
		        opts._keyboard._39 = _39, opts._keyboard._40 = _40;
		        opts._keyboard._13 = _13;
		        var heads = opts.columns[0];
		        for (var i = 0, il = rows.length, row; i < il; i++) {
		            row = rows[i];
		            this._bindEvtOneRow(grid,row,opts,heads,i);
		        }
		    },
		    _bindEvtOneRow: function (grid, row, opts, heads, i) {
		        opts=opts||jq.data(grid, "datagrid").options;
		        var trow = methods.getGridTrRow(grid, i, opts), row = trow.row;
		        if (!heads) {
		            heads = opts.columns[0];
		        }
		        if (row.__editor__ && (row.__editor__.status === 1)) {
		            for (var j = 0, jl = opts._editor_list_.length, box, head; j < jl; j++) {
		                var sArr = opts._editor_list_[j].split('_'), cinx = parseInt(sArr[0]);
		                box = null; head = heads[cinx];
		                if (head._editor) {
		                    box = methods._boxFactory(head._editor.type);
		                    if (box) {
		                        var cedit = jq(trow.body).find('#' + trow.iRowEdit + '_' + opts._editor_list_[j])[0];
		                        var _edit = box.target.call(cedit, null);
		                        _edit[0].onkeydown = (function (method, _grid, _kdown) {
		                            return (function (e) {
		                                e=e||window.event;
		                                if (method.keyBoard._keyEvents(e, _grid) === false) return false;
		                                if (_kdown && (_kdown.apply(this, arguments) === false)) return false;
		                            });
		                        })(methods, grid, (_edit.length ? _edit[0].onkeydown : null));
		                    }
		                }
		            }
		        }
		    },
		    _keyEvents: function (e,grid) {
		        var opts = jq.data(grid, "datagrid").options;
		        var _key=opts._keyboard;
		        if (e.keyCode === _key._13) {
		            if (this.nextColumn(grid, e.target||e.srcElement, opts) === false) {
		                var irow=this.nextRow(grid, e.target||e.srcElement, opts) 
		                if (irow>=0) methods._rowFocus(grid, irow,0,opts);
		            }
		        }
		        else if (e.keyCode === _key._37) {
		            this.prevColumn(grid, e.target||e.srcElement, opts);
		        }
		        else if (e.keyCode === _key._38) {
		            this.prevRow(grid, e.target||e.srcElement, opts);
		        }
		        else if (e.keyCode === _key._39) {
		            this.nextColumn(grid, e.target||e.srcElement, opts);
		        }
		        else if (e.keyCode === _key._40) {
		            this.nextRow(grid, e.target||e.srcElement, opts);
		        }
		    },
		    nextRow: function (grid,target,opts) {
		        if (opts._row_current) {
		            var rows = jq(grid).datagrid('getRows'),rowlen=rows.length-1;
		            var irow = opts._row_current.rowIndex || 0;
		            if (opts.kBoard&&opts.kBoard.onBeforeNextRow) {
		                var trow=methods.getGridTrRow(grid,irow,opts);
		                if (opts.kBoard.onBeforeNextRow.apply(grid,
                            [trow.row, irow, target]) == false) return irow;
		            }
		            if (irow <= rowlen) {
		                if (irow === rowlen) {
		                    if (opts.kBoard && opts.kBoard.autoNewRow) {
		                        var arow = rows[0], nrow = {};
		                        for (var i in arow) {
		                            nrow[i]='';
		                        }
		                        jq(grid).editgrid('appendRow', nrow);
		                        if (rows.length === (rowlen + 2)) {
		                            methods._editRow(grid, irow + 1, opts);
		                            methods._rowFocus(grid, irow + 1, target, opts);
		                            return irow + 1;
		                        }
		                    }
		                } else {
		                    methods._rowFocus(grid, irow + 1, target, opts);
		                    return irow + 1;
		                }
		            }
		            return irow;
		        }
		        return -1;
		    },
		    prevRow: function (grid,target, opts) {
		        if (opts._row_current) {
		            var irow = opts._row_current.rowIndex || 0;
		            if (opts.kBoard&&opts.kBoard.onBeforePrevRow) {
		                var trow = methods.getGridTrRow(grid, irow, opts);
		                if (opts.kBoard.onBeforePrevRow.apply(grid,
                            [trow.row, irow, target]) === false) return;
		            }
		            if (irow > 0) {
		                methods._rowFocus(grid, irow-1,target,opts);
		            }
		        }
		    },
		    nextColumn: function (grid,target, opts) {
		        var lstedit = opts._editor_list_;
		        var heads = opts.columns[0];
		        var editor = jq(target).parents('div.editor_grid_div');
		        var sArr = editor[0].id.split('_');
		        var field = sArr.slice(1).join('_'), rowInx = parseInt(sArr[0], 10);
		        var trow = methods.getGridTrRow(grid, 0, opts);
		        if (opts.kBoard&&opts.kBoard.onNextColumn) {
		            if (opts.kBoard.onNextColumn.apply(target,
                        [rowInx, parseInt(sArr[1], 10)]) === false) return true;
		        }
		        for (var i = 0, il = lstedit.length, box, head; i < il; i++) {
		            if (lstedit[i] === field) {
		                if (i>=(il-1)) return false;
		                if (i<(il-1)) {
		                    for (var j = i+1; j < il; j++) {
		                        var nfield = lstedit[j]; sArr = nfield.split('_');
		                        var cinx = parseInt(sArr[0], 10);
		                        var cedit = jq(trow.body).find('#' + rowInx + '_' + nfield);
		                        if (cedit.is(':visible')) {
		                            opts._editor_field = nfield;
		                            head = heads[cinx];
		                            if (head._editor && head._editor.type) {
		                                box = methods._boxFactory(head._editor.type);
		                                if (box) {
		                                    box.focus.call(cedit, true);
		                                    return true;
		                                }
		                            }
		                            break;
		                        }
		                    }
		                    break;
		                }
		            }
		        }
		        return false;
		    },
		    prevColumn: function (grid,target, opts) {
		        var lstedit = opts._editor_list_;
		        var heads = opts.columns[0];
		        var editor = jq(target).parents('div.editor_grid_div');
		        var sArr = editor[0].id.split('_');
		        var field = sArr.slice(1).join('_'), rowInx = parseInt(sArr[0], 10);
		        var trow = methods.getGridTrRow(grid,0, opts)
		        if (opts.kBoard&&opts.kBoard.onBeforePrevColumn) {
		            if (opts.kBoard.onBeforePrevColumn.apply(target,
                        [rowInx, parseInt(sArr[1], 10)]) === false) return;
		        }
		        for (var i = 0, il = lstedit.length,box,head; i < il; i++) {
		            if (lstedit[i] === field) {
		                if (i<=0) return;
		                if (i > 0) {
		                    for (var j = i - 1; j >= 0; j--) {
		                        var nfield = lstedit[j]; sArr = nfield.split('_');
		                        var cinx = parseInt(sArr[0], 10);
		                        var cedit = jq(trow.body).find('#' + rowInx + '_' + nfield);
		                        if (cedit.is(':visible')) {
		                            opts._editor_field = nfield;
		                            head = heads[cinx];
		                            if (head._editor && head._editor.type) {
		                                box = methods._boxFactory(head._editor.type);
		                                if (box) box.focus.call(cedit, true);
		                            }
		                            break;
		                        }
		                    }
		                    break;
		                }
		            }
		        }
		    }
		},
		keyBoardInit: function () {
		    this.each(function () {
		        methods.keyBoard.init(this);
		    });
		},
		postData:function(data,url,fnSuccess,i){
		    i = parseInt('' + i, 10);
		    if ((typeof data) !== 'object') data = {};
		    this.each(function(){	
		        var self=this;
		        var opts = jq.data(self, "datagrid").options;
		        var trow = methods.getGridTrRow(self, 0,opts), tr = trow.tr;
		        var curl=opts.editurl||url;
		        if(!curl)return;
		        var cdata={};
		        for (var d in data) cdata[d] = data[d];
		        (function (pack) { pack.doPost(); })({
		            doPost: function () {
		                (function (pkg) {
		                    pkg.mShowZz();
		                    jq.post(pkg.mUrl,pkg.mData,function (revdata) {
		                        try {
		                            pkg.mFnSucc && pkg.mFnSucc.call(pkg,revdata);
		                            (!pkg.mFnSucc)&&pkg.mOpts.onPostDataSuccess && pkg.mOpts.onPostDataSuccess.call(pkg,revdata);
		                        } catch (e) {
		                            try {
		                                pkg.mOpts.onPostDataError && pkg.mOpts.onPostDataError(e);
		                                (!pkg.mOpts.onPostDataError) && pkg.mOpts.onLoadError && pkg.mOpts.onLoadError(r);
		                            } catch (e) { }
		                        }
		                        pkg.mCloseZz();
		                    }).error(function (r) {
		                        try{
		                            pkg.mOpts.onPostDataError && pkg.mOpts.onPostDataError(r);
		                            (!pkg.mOpts.onPostDataError) && pkg.mOpts.onLoadError && pkg.mOpts.onLoadError(r);
		                        } catch (e) { }
		                        pkg.mCloseZz();
		                    });
		                })(this);
		            },
		            mThis:self,
		            mId: 'ZZ'+methods.zIndex,
		            mZObj:jq(tr).parents('table')[0].parentNode,
		            mOpts:opts,
		            mData: cdata,
		            mUrl: curl,
		            mShowZz: methods._showZz,
		            mCloseZz: methods._closeZZ,
		            mFnSucc: fnSuccess
		        });
		        methods.zIndex = methods.zIndex + 1;
		    });
		},
		appendRow:function(nrow){
		    this.each(function () {
		        var opts = jq.data(this, "datagrid").options
		        if (opts.onAppendRow &&
                    (opts.onAppendRow.apply(this, [nrow]) === false)) return false;
		        jq(this).datagrid('appendRow', nrow);
		    });
		},
		getFocusRow: function () {
		    var rows = [];
		    this.each(function () {
		        var opts = jq.data(this, "datagrid").options
		        if (opts._row_current && (opts._row_current.rowIndex >= 0)) {
		            var trow = methods.getGridTrRow(this, opts._row_current.rowIndex, opts);
		            trow.rowIndex = opts._row_current.rowIndex;
		            rows.push(trow);
		        }
		    });
		    if (rows.length == 0) { return null;}
		    if (rows.length == 1) { return rows[0]; }
		    return rows;
		},
		_getRowData: function (grid, irow) {
		    irow = parseInt('' + irow, 10);
		    var opts = jq.data(grid, "datagrid").options
		    var trow = methods.getGridTrRow(grid, irow, opts), tr = trow.bodyTr, row0 = trow.row;
		    if (!row0) return null;
		    row = {};
		    for (var j in row0) row[j] = row0[j];
		    var heads = opts.columns[0];
		    var cedits = jq(tr).find('div.editor_grid_div');
		    for (var i = 0, il = cedits.length; i < il; i++) {
		        var edit = cedits[i], sArr = edit.id.split('_');
		        var celinx = parseInt(sArr[1]);
		        var field = sArr.slice(2).join('_'), head = heads[celinx];
		        if (head && head._editor) {
		            var box = methods._boxFactory(head._editor.type);
		            if (box) row[field] = box.target.call(edit).val();
		        }
		    }
		    return row;
		},
		getRowData:function(irow){
		    var datas = [];
		    this.each(function () {
		        datas.push(methods._getRowData(this,irow))
		    });
		    if (datas.length === 0) return null;
		    if (datas.length === 1) return datas[0];
		    return datas;
		},
		beginEdit: function (i) {
		    i = parseInt('' + i, 10);
		    this.each(function(){	
		  	  methods._editRow(this,i);
		    });
		},
		endEdit: function (i) {
		    i = parseInt('' + i, 10);
		    this.each(function(){	
		  	  methods._endEditRow(this,i);
		    });
		},
		deleteRow:function(i){
		    i = parseInt('' + i, 10);
		    this.each(function () {
		        methods._deleteRow(this, i);
		    });
		},
		rowFocus: function (irow, icell) {
		    irow = parseInt('' + irow, 10), icell = parseInt('' + icell, 10);
		    this.each(function () {
		        var opts = jq.data(this, "datagrid").options,td;
		        if ((!isNaN(icell)) && (icell >= 0)) {
		            var trow = methods.getGridTrRow(this, irow, opts);
		            var tr = trow.bodyTr; td = tr.childNodes[icell];
		        }
		        methods._rowFocus(this, irow,
                    ((td && td.childNodes && td.childNodes.length) ? td.childNodes[0] : null), opts);
		    });
		},
		refreshRow: function (irow) {
		    irow = parseInt(''+irow, 10);
		    this.each(function () {
		        var opts = jq.data(this, "datagrid").options
		        var trow = methods.getGridTrRow(this, irow,opts), row = trow.row;
		        jq(this).datagrid('refreshRow', irow);
		        if (row.__editor__ && row.__editor__.status) row.__editor__.status = 0;
		    });
		},
		allRefreshRow:function(){
		    this.each(function () {
		        var opts = jq.data(this, "datagrid").options
		        var rows = jq(this).datagrid('getRows');
		        for (var i = 0, il = rows.length, row; i < il; i++) {
                    row=rows[i]
		            var irow = jq(this).datagrid('getRowIndex',row);
		            jq(this).datagrid('refreshRow', irow);
		            if (row.__editor__ && row.__editor__.status) row.__editor__.status = 0;
		        }
		    });
		},
		allBeginEdit:function(){
		  this.each(function(){	
		  	 var rows=jq(this).datagrid('getRows');
		  	 var opts=jq.data(this,"datagrid").options;
		  	 for(var i=0,il=rows.length;i<il;i++){
		  	   methods._editRow(this,i,opts);
		  	 }
		  });
		},
		allEndEdit:function(){
		  this.each(function(){	
		  	 var rows=jq(this).datagrid('getRows');
		  	 var opts=jq.data(this,"datagrid").options;
		  	 for(var i=0,il=rows.length;i<il;i++){
		  	   methods._endEditRow(this,i,opts);
		  	 }
		  });
		},
		_cltoolTipTim: function (index,self,tim) {
		    return window.setTimeout(function () {
		        var opts = jq.data(self, "datagrid").options;
		        jq(self).editgrid('unToolTip', index);
		        opts._tooltip_._timer_ = null;
		    }, tim);
		},
		toolTipTim: function (index, msg, timeOut) {
		    if (!msg && (msg !== 0)) { return; }
		    timeOut = timeOut || 5000;
		    index = parseInt(index, 10);
		    this.each(function () {
		        var opts = jq.data(this, "datagrid").options;
		        if (!opts._tooltip_) opts._tooltip_ = { _timer_: null, _cachemsg_: null };
		        if ((opts._tooltip_._timer_) && (opts._tooltip_._cachemsg_ === msg)) {
		            window.clearTimeout(opts._tooltip_._timer_);
		            opts._tooltip_._timer_ = methods._cltoolTipTim(index, this, timeOut);
		        } else {
		            var this_ = jq(this);
		            if (opts._tooltip_._timer_)
		                window.clearTimeout(opts._tooltip_._timer_);
		            this_.editgrid('unToolTip', index);
		            this_.editgrid('toolTip', index, msg);
		            opts._tooltip_._cachemsg_ = msg;
		            opts._tooltip_._timer_ = methods._cltoolTipTim(index, this, timeOut);
		        }
		    });
		}
	};
	jq.fn.extend({
		editgrid:function(name0){
			var slice=Array.prototype.slice;
			if(((typeof name0)==='object')||(!name0)){
			   var m=methods.init;
			}else{
			  if(m=methods[name0]){
			    arguments =slice.call(arguments,1);
			  } else {
			     return jq.fn.datagrid.apply(this,arguments);
			  }
			}
			if(m)return m.apply(this,arguments);
		}
	});
})(jQuery,null);