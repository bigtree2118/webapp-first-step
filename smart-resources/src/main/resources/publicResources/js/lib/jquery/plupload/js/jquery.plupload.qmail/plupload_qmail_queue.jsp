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
<link  type="text/css" href="<%=basePath%>js/lib/jquery/plupload/js/jquery.plupload.queue/css/jquery.plupload.queue.css" rel="stylesheet" media="screen" />
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/jquery.min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/plupload_browserplus-min.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/plupload.full.js"></script>
<script type="text/javascript" src="<%=basePath%>js/lib/jquery/plupload/js/i18n/cn.js"></script>
<script type="text/javascript">
(function(c) {
	var pl_objs = {};
	function i18n(lang) {
		return plupload.translate(lang) || lang;
	}
	function build(pl_id, pl_uploader) {
		pl_uploader.contents().each(function(index, obj) {
			if (!c(obj).is(".plupload")) {
				c(obj).remove();
			}
		});
		
		pl_uploader.prepend('<div class="plupload_wrapper plupload_scroll"><div id="'
			+ pl_id
			+ '_container" class="plupload_container"><div class="plupload"><div class="plupload_header"><div class="plupload_header_content"><div class="plupload_header_title">'
			+ i18n("Select files")
			+ '</div><div class="plupload_header_text">'
			+ i18n("Add files to the upload queue and click the start button.")
			+ '</div></div></div><div class="plupload_content"><div class="plupload_filelist_header"><div class="plupload_file_name">'
			+ i18n("Filename")
			+ '</div><div class="plupload_file_action">&nbsp;</div><div class="plupload_file_status"><span>'
			+ i18n("Status")
			+ '</span></div><div class="plupload_file_size">'
			+ i18n("Size")
			+ '</div><div class="plupload_clearer">&nbsp;</div></div><ul id="'
			+ pl_id
			+ '_filelist" class="plupload_filelist"></ul><div class="plupload_filelist_footer"><div class="plupload_file_name"><div class="plupload_buttons"><a href="#" class="plupload_button plupload_add">'
			+ i18n("Add files")
			+ '</a><a href="#" class="plupload_button plupload_start">'
			+ i18n("Start upload")
			+ '</a></div><span class="plupload_upload_status"></span></div><div class="plupload_file_action"></div><div class="plupload_file_status"><span class="plupload_total_status">0%</span></div><div class="plupload_file_size"><span class="plupload_total_file_size">0 b</span></div><div class="plupload_progress"><div class="plupload_progress_container"><div class="plupload_progress_bar"></div></div></div><div class="plupload_clearer">&nbsp;</div></div></div></div></div><input type="hidden" id="'
			+ pl_id
			+ '_count" name="'
			+ pl_id
			+ '_count" value="0" /></div>');
	}
	c.fn.pluploadQueue = function(e) {
		if (e) {this.each(function() {
			var pl_uploader = c(this);
			var pl_id = pl_uploader.attr("id");
			
			if (!pl_id) {
				pl_id = plupload.guid();
				pl_uploader.attr("id", pl_id);
			}
			
			var pl_obj = new plupload.Uploader(c.extend({
				dragdrop : true,
				container : pl_id
			}, e));
			
			pl_objs[pl_id] = pl_obj;
			
			function showFileStatus(file) {
				var status = "";
				if (file.status == plupload.DONE) {
					status = "plupload_done";
				}
				if (file.status == plupload.FAILED) {
					status = "plupload_failed";
				}
				if (file.status == plupload.QUEUED) {
					status = "plupload_delete";
				}
				if (file.status == plupload.UPLOADING) {
					status = "plupload_uploading";
				}
				var file_status = c("#" + file.id).attr("class", status).find("a").css("display", "block");
				
				if (file.hint) {
					file_status.attr("title", file.hint);
				}
			}
			
			function showProgress() {
				c("span.plupload_total_status", pl_uploader).html(pl_obj.total.percent + "%");
				c("div.plupload_progress_bar", pl_uploader).css("width",pl_obj.total.percent + "%");
				c("span.plupload_upload_status", pl_uploader).html(i18n("Uploaded %d/%d files")
						.replace(/%d\/%d/,pl_obj.total.uploaded + "/"+ pl_obj.files.length));
			}
			
			function g() {
				var file_list = c("ul.plupload_filelist", pl_uploader).html(""), file_count = 0, file_info ="";
				
				c.each(pl_obj.files, function(p, file) {
					
					file_info = "";
					if (file.status == plupload.DONE) {
						if (file.target_name) {
							file_info += '<input type="hidden" name="' + pl_id + "_" + file_count + '_tmpname" value="' + plupload.xmlEncode(file.target_name) + '" />';
						}
						file_info += '<input type="hidden" name="' + pl_id + "_" + file_count + '_name" value="' + plupload .xmlEncode(file.name) + '" />';
						file_info += '<input type="hidden" name="' + pl_id + "_" + file_count + '_status" value="' + (file.status == plupload.DONE ? "done" : "failed") + '" />';
						file_count++;
						c("#" + pl_id + "_count").val(file_count);
					}
					
					file_list.append('<li id="'+ file.id+ '"><div class="plupload_file_name"><span>'+ file.name
						+ '</span></div><div class="plupload_file_action"><a href="#"></a></div><div class="plupload_file_status">'
						+ file.percent+ '%</div><div class="plupload_file_size">'+ plupload.formatSize(file.size)
						+ '</div><div class="plupload_clearer">&nbsp;</div>'+ file_info + "</li>");
				
					showFileStatus(file);
				
					c("#"+ file.id + ".plupload_delete a").click(function(e) {
							c("#"+ file.id).remove();
							pl_obj.removeFile(file);
							e.preventDefault();
						});
					});
				
					c("span.plupload_total_file_size", pl_uploader).html(
							
						plupload.formatSize(pl_obj.total.size));
				
						if (pl_obj.total.queued === 0) {
							c("span.plupload_add_text", pl_uploader).html(a("Add files."));
						} else {
							c("span.plupload_add_text", pl_uploader).html(pl_obj.total.queued + " files queued.");
						}
						
						c("a.plupload_start", pl_uploader).toggleClass("plupload_disabled", pl_obj.files.length == (pl_obj.total.uploaded + pl_obj.total.failed));
						
						file_list[0].scrollTop = file_list[0].scrollHeight;
						
						showProgress();
						
						if (!pl_obj.files.length && pl_obj.features.dragdrop && pl_obj.settings.dragdrop) {
								c("#" + pl_id + "_filelist").append('<li class="plupload_droptext">' + i18n("Drag files here.") + "</li>");
							}
						}
			
						pl_obj.bind("UploadFile", function(pl, file) {
							c("#" + file.id).addClass("plupload_current_file");
						});
						
						pl_obj.bind("Init",	function(pl) {
							build(pl_id, pl_uploader);
							
							if (!e.unique_names && e.rename) {
								pl_uploader.on("click","#" + pl_id + "_filelist div.plupload_file_name span",
									function(file_obj) {
										var file_target = c(file_obj.target), file_suffix = "";
										var file = pl.getFile(file_target.parents("li")[0].id);
										var file_name = file.name;
										var file_RegExp = /^(.+)(\.[^.]+)$/.exec(file_name);
										if (file_RegExp) {
											file_name = file_RegExp[1];
											file_suffix = file_RegExp[2];
										}
										file_target.hide().after('<input type="text" />');
										file_target.next().val(file_name).focus().blur(function() {
											file_target.show().next().remove();
										}).keydown(function(e) {
											if (c.inArray(e.keyCode,[13,27]) !== -1) {
													e.preventDefault();
													if (e.keyCode === 13) {
														file.name = c(this).val()+ file_suffix;
														file_target.html(file.name);
													}
													c(this).blur();
												}
											});
									});
							 }
							
							c("a.plupload_add", pl_uploader).attr("id",pl_id + "_browse");
							pl.settings.browse_button = pl_id + "_browse";
							if (pl.features.dragdrop && pl.settings.dragdrop) {
								pl.settings.drop_element = pl_id + "_filelist";
								c("#" + pl_id + "_filelist") .append( '<li class="plupload_droptext">' + i18n("Drag files here.") + "</li>");
							}
							c("#" + pl_id + "_container").attr("title", i18n("Using runtime: ")+ pl.runtime);
							c("a.plupload_start", pl_uploader).click(function(e) {
								if (!c(this).hasClass("plupload_disabled")) {
									pl_obj.start();
								}
								e.preventDefault();
							});
							c("a.plupload_stop", pl_uploader).click(function(e) {
								e.preventDefault();
								pl_obj.stop();
							});
							c("a.plupload_start", pl_uploader).addClass(
								"plupload_disabled");
							});
					
							pl_obj.init();
								
							pl_obj.bind("Error",function(pl, err) {
								var file = err.file, err_msg ="";
								if (file) {
									err_msg = err.message;
									if (err.details) {
										err_msg += " (" + err.details + ")";
									}
									if (err.code == plupload.FILE_SIZE_ERROR) {
										alert(i18n("Error: File too large: ") + file.name);
									}
									if (err.code == plupload.FILE_EXTENSION_ERROR) {
										alert(i18n("Error: Invalid file extension: ") + file.name);
									}
									file.hint = err_msg;
									c("#" + file.id).attr("class","plupload_failed").find("a").css("display","block").attr("title", err_msg);
								}
							});
							
							pl_obj.bind("StateChanged",function() {
								if (pl_obj.state === plupload.STARTED) {
									c("li.plupload_delete a,div.plupload_buttons", pl_uploader).hide();
									c("span.plupload_upload_status,div.plupload_progress,a.plupload_stop", pl_uploader).css("display", "block");
									c("span.plupload_upload_status", pl_uploader) .html("Uploaded " + pl_obj.total.uploaded + "/" + pl_obj.files.length + " files");
									if (e.multiple_queues) {
										c("span.plupload_total_status,span.plupload_total_file_size",pl_uploader).show();
									}
								} else {
									g();
									
									c("a.plupload_stop,div.plupload_progress",pl_uploader).hide();
									c("a.plupload_delete", pl_uploader).css("display", "block");
								}
							});
							
							pl_obj.bind("QueueChanged", g);
							pl_obj.bind("FileUploaded", function(pl, file) {
								showFileStatus(file);
							});
							
							pl_obj.bind("UploadProgress",function(pl, file) {
								c("#"+ file.id + " div.plupload_file_status",pl_uploader).html(m.percent + "%");
								showFileStatus(file);
								showProgress();
								if (e.multiple_queues&& pl_obj.total.uploaded+ pl_obj.total.failed == pl_obj.files.length) {
									c(".plupload_buttons,.plupload_upload_status",pl_uploader).css("display","inline");
									c(".plupload_start", pl_uploader).addClass("plupload_disabled");
									c("span.plupload_total_status,span.plupload_total_file_size",pl_uploader).hide();
								}
							});
							
							if (e.setup) {
								e.setup(pl_obj);
							}
					});
		
			return this;
		} else {
			return pl_objs[c(this[0]).attr("id")];
		}
	};
})(jQuery);

$(function(){
	$("#uploader").pluploadQueue({
		runtimes : 'gears,flash,silverlight,browserplus,html5,html4',
		url : '<%=basePath%>basic/sys/filePlupload.action',
        chunk_size : '1mb',
        max_file_size : '10mb',
        //max_file_count : 2,//文件个数限制失效
        unique_names : false,
        rename : true,
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
			