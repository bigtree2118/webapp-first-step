
<%@page import="java.util.Date"%>
<%@ page language="java" pageEncoding="utf-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>上传文件</title>
<base target="_self"/>
<link  type="text/css" href="<%=basePath%>js/lib/jquery/plupload/js/jquery.plupload.ui/css/jquery-ui.css" rel="stylesheet" media="screen" />
<link  type="text/css" href="<%=basePath%>js/lib/jquery/plupload/js/jquery.plupload.ui/css/jquery.ui.plupload.css" rel="stylesheet" media="screen" />
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/jquery.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/jquery.plupload.ui/jquery-ui.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/plupload_browserplus-min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/plupload.full.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/i18n/cn.js"></script>
<script type="text/javascript">

(function(f,w,c,p){
	var pl_objs = {};
	this.i18n = function(i18n) {
		return c.translate(i18n) || i18n;
	};
	
	this.build = function (body){
		body.innerHTML ='<fieldset style="border : 1px solid #84A24A;text-align:left;color:#84A24A;font-size: 12px;font-family: Verdana;padding:5px;">' 
			+'<legend>upload</legend>'
			+'<div id="container">'
			+'<input type="button" value="添加附件" id="fileBrowse" style="background:transparent;border:1px solid #84A24A; color:#84A24A" ></input>&nbsp;'
			+'<input type="button" value="清空附件" id="fileClear" onclick="fileClear();" style="background:transparent;border:1px solid #84A24A; color:#84A24A;display:none;"></input>'
			+'<input type="button" value="开始上传" id="fileStart" onclick="fileClear();" style="background:transparent;border:1px solid #84A24A; color:#84A24A;display:none;"></input>'
			+'<input type="button" value="停止上传" id="fileStop" onclick="fileClear();" style="background:transparent;border:1px solid #84A24A; color:#84A24A;display:none;"></input>'
			+'<div id="fileList" style="background-color:#DEEBC6;border:1px solid #84A24A; margin:3px 0px 0px 0px;padding:4px 3px 4px 3px;">'
			+'<p>您的浏览器未安装 Flash, Silverlight, Gears, BrowserPlus 或者支持 HTML5 .</p>'
			+'</div>'
			+'<div id="fileTotal" style="margin:3px 0px 0px 0px;">当前选择上传<font color="red">0</font>个附件</div>'
			+'<div id="fileMsg" style="margin:3px 0px 0px 0px;"></div>'
			+'</div>'
			+'</fieldset>';
	};
	
	p.widget(
		'plupload.qmail',{
			content_back : '',
			runtime : null,
			options : {
				drag_drop :true,
				multiple_queues : true,
				buttons :{
					browse :true,
					clear :true,
					start : true,
					stop : false
				},
				auto_start : false,
				sortable : false,
				max_file_count : 0
			},
			FILE_COUNT_ERROR : -9001,
			_create : function(){
				var current = this;
				var pl_id = this.element.id;
				if (!pl_id) {
					pl_id = plupload.guid();
					this.element.id = pl_id;
				}
				this.id = pl_id;
				this.content_back = this.element.innerHTML;
				build(this.element);
				this.container = g(".plupload_container", this.element).attr("id", k + "_container");
				this.filelist = g(".plupload_filelist_content", this.container).attr({
					id : k + "_filelist",
					unselectable : "on"
				});
				
				this.browse_button = g(".plupload_add", this.container).attr("id", k + "_browse");
				this.start_button = g(".plupload_start", this.container).attr("id", k + "_start");
				this.stop_button = g(".plupload_stop", this.container).attr("id", k + "_stop");
				this.progressbar = g(".plupload_progress_container",this.container);
				if (g.ui.progressbar) {
					this.progressbar.progressbar();
				}
				this.counter = g(".plupload_count", this.element)
					.attr({
						id : k + "_count",
						name : k + "_count"
					});
				
				var pl_obj = this.uploader = pl_objs[pl_id] = new c.Uploader(plupload.extend(
						{container : pl_id,browse_button : "browse_"+ pl_id}, this.options));
				
				pl_obj.bind("Error", function(pl, err) {
					if (err.code === c.INIT_ERROR) {
						current.destroy();
					}
				});
				
				pl_obj.bind("Init",	function(l, m) {
					if (!i.options.buttons.browse) {
						i.browse_button.button("disable").hide();
						l.disableBrowse(true);
					}
					if (!i.options.buttons.start) {
						i.start_button.button("disable").hide();
					}
					if (!i.options.buttons.stop) {
						i.stop_button.button("disable").hide();
					}
					if (!i.options.unique_names && i.options.rename) {
						i._enableRenaming();
					}
					if (j.features.dragdrop	&& i.options.dragdrop) {
						i._enableDragAndDrop();
					}
					
					current.container.title = b("Using runtime: ")+(current.runtime = err.runtime);
					
					current.start_button.click(function(fn){
						if (!g(this).button("option","disabled")) {
							pl_obj.start();
						}
						fn.preventDefault();
					});
					
					current.stop_button.click(function(fn) {
						pl_obj.stop();
						fn.preventDefault();
					});
				});
				
				if (current.options.max_file_count) {
					pl_obj.bind("FilesAdded", function(pl, add_files) {
						var out_file = [];
						var out_length = pl.files.length + add_files.length - current.options.max_file_count;
						if (out_length > 0) {
							out_file = add_files.splice(add_files.length - out_length, out_length);
							pl.trigger("Error", {
								code : current.FILE_COUNT_ERROR,
								message : i18n("File count error."),
								file : out_file
							});
						}
					});
				}
				
				pl_obj.init();
		
				pl_obj.bind("FilesAdded", function(pl, add_files) {
					current._trigger("selected", null, {
						up : pl,
						files : add_files
					});
					if (current.options.autostart) {
						setTimeout(function() {
							current.start();
						}, 10);
					}
				});
				
				pl_obj.bind("FilesRemoved", function(pl, del_files) {
					current._trigger("removed", null, {
						up : pl,
						files : del_files
					});
				});
				
				pl_obj.bind("QueueChanged", function(pl) {
					current._updateFileList();
				});
				
				pl_obj.bind("StateChanged", function(pl) {
					current._handleState();
				});
				
				pl_obj.bind("UploadFile", function(pl, up_file) {
					current._handleFileStatus(up_file);
				});
				
				pl_obj.bind("FileUploaded", function(pl, up_file,res_obj) {
					current._handleFileStatus(m);
					current._trigger("uploaded", null, {
						up : pl,
						file : up_file
					});
				});
				
				pl_obj.bind("UploadProgress", function(pl,up_file ) {
					g("#" + up_file.id).find(".plupload_file_status")
						.html(up_file.percent + "%").end()
						.find(".plupload_file_size").html(c.formatSize(up_file.size));
					
					current._handleFileStatus(up_file);
					current._updateTotalProgress();
					
					current._trigger("progress", null, {
						up : pl,
						file : up_file
					});
				});
				
				pl_obj.bind("UploadComplete", function(pl, up_files) {
					current._trigger("complete", null, {
						up : pl,
						files : up_files
					});
				});
		
		
				pl_obj.bind("Error",function(pl, err) {
					var err_file = err.file,err_msg,err_detail;
					if (err_file) {
						err_msg = "<strong>" + err.message + "</strong>";
						err_detail = err.details;
						if (err_detail) {
							err_msg += " <br /><i>"	+ err.details + "</i>";
						} else {switch (err.code) {
							case c.FILE_EXTENSION_ERROR:
								err_detail = i18n("File: %s").replace("%s",	err_file.name);
								break;
							case c.FILE_SIZE_ERROR:
								err_detail = i18n("File: %f, size: %s, max file size: %m")
										.replace(/%([fsm])/g, function(r, q) {switch (q) {
												case "f": return err_file.name;
												case "s": return err_file.size;
												case "m": return c.parseSize(current.options.max_file_size);
											}
										});
								break;
							case i.FILE_COUNT_ERROR:
								err_detail = i18n("Upload element accepts only %d file(s) at a time. Extra files were stripped.")
											.replace("%d", current.options.max_file_count);
								break;
							case c.IMAGE_FORMAT_ERROR:
								err_detail = c.translate("Image format either wrong or not supported.");
								break;
							case c.IMAGE_MEMORY_ERROR:
								err_detail = c.translate("Runtime ran out of available memory.");
								break;
							case c.IMAGE_DIMENSIONS_ERROR:
								err_detail = c.translate("Resoultion out of boundaries! <b>%s</b> runtime supports images only up to %wx%hpx.")
										.replace(/%([swh])/g, function(r, q){switch (q) {
												case "s": return pl.runtime;
												case "w": return pl.features.maxWidth;
												case "h": return pl.features.maxHeight;
											}
										});
								break;
							case c.HTTP_ERROR:
								err_detail = b("Upload URL might be wrong or doesn't exist");
								break;
							}
							err_msg += " <br /><i>" + detail + "</i>";
						}
						
						current.notify("error", err_msg);
						current._trigger("error", null, {up : pl,file : err_file, error : err_msg});
					}
				});
		},
		_setOption : function(but_obj, but_con) {
			var current = this;
			if (but_obj == "buttons" && typeof (but_con) == "object") {
				
				but_con = g.extend(current.options.buttons, but_con);
				
				if (!but_con.browse) {
					current.browse_button.button("disable").hide();
					
					up.disableBrowse(true);
				} else {
					current.browse_button.button("enable").show();
					
					up.disableBrowse(false);
				}
				if (!but_con.start) {
					current.start_button.button("disable").hide();
				} else {
					current.start_button.button("enable").show();
				}
				if (!but_con.stop) {
					but_con.stop_button.button("disable").hide();
				} else {
					but_con.start_button.button("enable").show();
				}
			}
			current.uploader.settings[but_obj] = but_con;
		},
		
		start : function() {
			this.uploader.start();
			this._trigger("start", null);
		},
		
		stop : function() {
			this.uploader.stop();
			this._trigger("stop", null);
		},
		
		getFile : function(index) {
			var file;
			if (typeof index === "number") {
				file = this.uploader.files[index];
			} else {
				file = this.uploader.getFile(index);
			}
			return file;
		},
		
		removeFile : function(index) {
			var file = this.getFile(index);
			if (file) {
				this.uploader.removeFile(file);
			}
		},
		
		clearQueue : function() {
			this.uploader.splice();
		},
		
		getUploader : function() {
			return this.uploader;
		},
		
		refresh : function() {
			this.uploader.refresh();
		},
		
		_handleState : function() {
			var current = this, current_uploader = this.uploader;
			if (current_uploader.state === c.STARTED) {
				g(current.start_button).button("disable");
				g([]).add(current.stop_button).add(".plupload_started").removeClass("plupload_hidden");
				
				g(".plupload_upload_status", current.element).html( i18n("Uploaded %d/%d files")
						.replace("%d/%d", current_uploader.total.uploaded + "/"	+ current_uploader.files.length));
				
				g(".plupload_header_content", current.element).addClass("plupload_header_content_bw");
				
			} else {
				g([]).add(current.stop_button).add(".plupload_started").addClass("plupload_hidden");
				
				if (current.options.multiple_queues){
					g(current.start_button).button("enable");
					g(".plupload_header_content", j.element).removeClass("plupload_header_content_bw");
				}
				current._updateFileList();
			}
		},
		
		_handleFileStatus : function(pl) {
			var n="", j="";
			if (!g("#" + pl.id).length) {
				return
			}
			switch (pl.status) {
				case c.DONE:
					n = "plupload_done";
					j = "ui-icon ui-icon-circle-check";
					break;
				case c.FAILED:
					n = "ui-state-error plupload_failed";
					j = "ui-icon ui-icon-alert";
					break;
				case c.QUEUED:
					n = "plupload_delete";
					j = "ui-icon ui-icon-circle-minus";
					break;
				case c.UPLOADING:
					n = "ui-state-highlight plupload_uploading";
					j = "ui-icon ui-icon-circle-arrow-w";
					var i = g(".plupload_scroll", this.container);
					var m = i.scrollTop();
					var o = i.height();
					var k = g("#" + pl.id).position().top + g("#" + pl.id).height();
					if (o < k) {
						i.scrollTop(m + k - o);
					}
					break;
			}
			n += "ui-state-default plupload_file";
			
			g("#" + pl.id).attr("class", n).find(".ui-icon").attr("class", j);
		},
		
		_updateTotalProgress : function() {
			var i = this.uploader;
			this.progressbar.progressbar("value", i.total.percent);
			this.element.find(".plupload_total_status").html(
				i.total.percent + "%").end().find(".plupload_total_file_size").html(
					c.formatSize(i.total.size)).end().find(".plupload_upload_status").html(
						i18n("Uploaded %d/%d files").replace("%d/%d", i.total.uploaded + "/" + i.files.length));
		},
		
		_updateFileList : function() {
			var k = this, j = this.uploader, m = this.filelist, l = 0, n = this.id + "_";
			if (g.ui.sortable && this.options.sortable) {
				g("tbody.ui-sortable", m).sortable("destroy");
			}
			m.empty();
			g.each(j.files,function(q, p) {
				var i = ""; var o = n + l;
				if (p.status === c.DONE) {
					if (p.target_name) {
						i += '<input type="hidden" name="' + o + '_tmpname" value="' + c.xmlEncode(p.target_name) + '" />';
					}
					i += '<input type="hidden" name="' + o + '_name" value="' + c.xmlEncode(p.name) + '" />';
					i += '<input type="hidden" name="' + o + '_status" value="' + (p.status === c.DONE ? "done" : "failed") + '" />';
					l++; k.counter.val(l);
				}
				m.append('<tr class="ui-state-default plupload_file" id="'
					+ p.id
					+ '"><td class="plupload_cell plupload_file_name"><span>'
					+ p.name
					+ '</span></td><td class="plupload_cell plupload_file_status">'
					+ p.percent
					+ '%</td><td class="plupload_cell plupload_file_size">'
					+ c
							.formatSize(p.size)
					+ '</td><td class="plupload_cell plupload_file_action"><div class="ui-icon"></div>'
					+ i
					+ "</td></tr>");
				k._handleFileStatus(p);
				g("#"+ p.id + ".plupload_delete .ui-icon, #" + p.id + ".plupload_done .ui-icon").click(function(r) {
						g("#"+ p.id).remove();
						j.removeFile(p);
						r.preventDefault();
					});
					k._trigger("updatelist", null,m);
				});
				if (j.total.queued === 0) {
					g(".ui-button-text", k.browse_button).html(il8n("Add Files"));
				} else {
					g(".ui-button-text", k.browse_button).html(il8n("%d files queued").replace("%d",j.total.queued));
				}
				if (j.files.length === (j.total.uploaded + j.total.failed)) {
					k.start_button.button("disable");
				} else {
					k.start_button.button("enable");
				}
				m[0].scrollTop = m[0].scrollHeight;
				k._updateTotalProgress();
				if (!j.files.length && j.features.dragdrop && j.settings.dragdrop) {
				g("#" + o + "_filelist").append('<tr><td class="plupload_droptext">' + b("Drag files here.") + "</td></tr>");
			} else {
				if (k.options.sortable && g.ui.sortable) {
					k._enableSortingList();
				}
			}
		},
		
		_enableRenaming : function() {
			var i = this;
			this.filelist.on("click",".plupload_delete .plupload_file_name span",function(o) {
				var m = g(o.target), k, n, j, l = "";
				k = i.uploader.getFile(m.parents("tr")[0].id);
				j = k.name;
				n = /^(.+)(\.[^.]+)$/.exec(j);
				if (n) {
					j = n[1];
					l = n[2];
				}
				m.hide().after('<input class="plupload_file_rename" type="text" />');
				m.next().val(j).focus().blur(function() {
					m.show().next().remove();
				}).keydown(function(q) {
					var p = g(this);
					if (g.inArray(q.keyCode,[13, 27 ]) !== -1) {
						q.preventDefault();
						if (q.keyCode === 13) {
							k.name = p.val()+ l;
							m.html(k.name);
						}
						p.blur();
					}
				});
			});
		},
		
		_enableDragAndDrop : function() {
			this.filelist.append('<tr><td class="plupload_droptext">' + b("Drag files here.") + "</td></tr>");
			this.filelist.parent().attr("id", this.id + "_dropbox");
			this.uploader.settings.drop_element = this.options.drop_element = this.id + "_dropbox";
		},
		
		_enableSortingList : function() {
			var i = this;
			if (g("tbody tr", this.filelist).length < 2) {
				return
			}
			g("tbody", this.filelist).sortable({
				containment : "parent",
				items : ".plupload_delete",
				helper : function(l, k) {
					return k.clone(true)
							.find("td:not(.plupload_file_name)")
							.remove().end()
							.css("width","100%");
				},
				stop : function(p, o) {
					var m = [];
					g.each(g(this).sortable("toArray"),function(q, r) {
						m[m.length] = i.uploader.getFile(r);
					});
					m.unshift(m.length);
					m.unshift(0);
					Array.prototype.splice.apply(i.uploader.files,m);
				}
			});
		},
		
		notify : function(j, k) {
			var i = g('<div class="plupload_message"><span class="plupload_message_close ui-icon ui-icon-circle-close" title="'
					+ b("Close")
					+ '"></span><p><span class="ui-icon"></span>'
					+ k + "</p></div>");
			i.addClass("ui-state-" + (j === "error" ? "error" : "highlight")).find(
					"p .ui-icon")
					.addClass("ui-icon-" + (j === "error" ? "alert" : "info")).end()
					.find(".plupload_message_close").click(function() {
						i.remove();
					}).end();
			g(".plupload_header_content", this.container).append(i);
		},
		
		destroy : function() {
			g(".plupload_button", this.element).unbind();
			if (g.ui.button) {
				g(".plupload_add, .plupload_start, .plupload_stop",this.container).button("destroy");
			}
			if (g.ui.progressbar) {
				this.progressbar.progressbar("destroy");
			}
			if (g.ui.sortable && this.options.sortable) {
				g("tbody", this.filelist).sortable("destroy");
			}
			this.uploader.destroy();
			this.element.empty().html(this.contents_bak);
			this.contents_bak = "";
			g.Widget.prototype.destroy.apply(this);
		}
	});
	
})(window, document, plupload);

$(function(){
	$("#uploader").plupload({
		runtimes : 'gears,flash,silverlight,browserplus,html5,html4',
		url : '<%=basePath%>basic/sys/filePlupload.action',
        runtimes : 'gears,flash,silverlight,browserplus,html5',
        url : 'upload.php',
        chunk_size : '1mb',
        max_file_size : '10mb',
        max_file_count : 2,
        unique_names : true,
        multiple_queues : true,
        resize : {width : 320, height : 240, quality : 90},
        filters : [
            {title : "Image files", extensions : "jpg,gif,png"},
            {title : "Zip files", extensions : "zip"}
        ],
		flash_swf_url : '<%=basePath%>js/lib/jquery/plupload/js/plupload.flash.swf',
		silverlight_xap_url : '<%=basePath%>js/lib/jquery/plupload/js/plupload.silverlight.xap'
	});
	
});
</script>
</head>
<body>
	<fieldset style="border: 1pxsolid #84A24A; text-align: left; COLOR: #84A24A; FONT-SIZE: 12px; font-family: Verdana; padding: 5px;">
		<div id="uploader">
			<p>您的浏览器未安装 Flash, Silverlight, Gears, BrowserPlus 或者支持 HTML5 .</p>
		</div>
	</fieldset>
</body>
</html>
			