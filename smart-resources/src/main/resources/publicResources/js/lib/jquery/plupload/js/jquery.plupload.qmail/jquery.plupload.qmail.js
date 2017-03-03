
(function($){
	var pl_objs = {};
	this.i18n = function(lang) {
		return plupload.translate(lang) || lang;
	};
	
	function build(pl_id, pl_uploader) {
		pl_uploader.contents().each(function(index, obj) {
			if (!$(obj).is(".plupload")) {
				$(obj).remove();
			}
		});
		
		pl_uploader.prepend('<fieldset style="border : 1px solid #84A24A;text-align:left;color:#84A24A;font-size: 12px;font-family: Verdana;padding:5px;">'
			+'<legend id="'+pl_id+'">'+i18n("uploader")+'</legend>'
			+'<div id="container_'+pl_id+'">'
			+'<div class="plupload">'
			
			+'<div id="'+pl_id+'_fileHandle">'
			+'<input type="button" value="'+i18n("Add Files")+'" id="file_browse_'+pl_id+'" style="background:transparent;border:1px solid #84A24A; color:#84A24A" ></input>&nbsp;'
			+'<input type="button" value="'+i18n("Clear Files")+'" id="file_clear_'+pl_id+'" style="background:transparent;border:1px solid #84A24A; color:#84A24A;display:none;"></input> '
			+'<input type="button" value="'+i18n("Start Upload")+'" id="file_start_'+pl_id+'" style="background:transparent;border:1px solid #84A24A; color:#84A24A; display:none;"></input> '
			+'<input type="button" value="'+i18n("Stop Upload")+'" id="file_stop_'+pl_id+'" style="background:transparent;border:1px solid #84A24A; color:#84A24A;display:none;"></input> '
			+'</div>'
			
			+'<div id="file_body_'+pl_id+'">'
			+'<div id="file_list_'+pl_id+'" style="background-color:#DEEBC6;border:1px solid #84A24A; margin:3px 0px 0px 0px;padding:4px 3px 4px 3px;"></div>'
			+'<div id="file_count_'+pl_id+'" style="margin:3px 0px 0px 0px;">当前选择上传<font color="red">0</font>个附件</div>'
			+'<div id="file_message_'+pl_id+'" style="margin:3px 0px 0px 0px;"></div>'
			+'<div id="file_progbar_'+pl_id+'" style="margin:3px 0px 0px 0px;"></div>'
			+'</div>'
			
			+'</div>'
			+'</div>'
			+'</fieldset>'
		);
	}
	
	$.fn.pluploadQmail = function(config) {
		if (config) {this.each(function() {
			var pl_uploader = $(this);
			var pl_id = pl_uploader.attr("id");
			if (!pl_id) {
				pl_id = plupload.guid();
				pl_uploader.attr("id", pl_id);
			}
			build(pl_id,pl_uploader);
			
			var pluploadQmail = {
				pl_id : pl_id,
				pl_uploader : pl_uploader,
				runtime : null,
				setting : $.extend({
					rename : true,
					dragdrop : true,
					sortable : false,
					autostart : false,
					unique_names : true,
					multiple_queues : true,
					buttons : {
						browse : true,
						clear : false,
						start : true,
						stop : false
					},
					max_file_count : 0
				},config),
				FILE_COUNT_ERROR:-9001,
				getFile : function(index) {
					var file;
					if (typeof index === "number") {
						file = this.uploader.files[index];
					} else {
						file = this.uploader.getFile(index);
					}
					return file;
				}
			};

			var pl_obj = pl_objs[pl_id] = new plupload.Uploader($.extend({
				container : pl_id,
				browse_button : 'file_browse_'+pl_id
			},pluploadQmail.setting));
			
			pl_obj.bind("Error", function(pl, err) {
				if (err.code === plupload.INIT_ERROR) {
					pl.destroy();
				}
			});
			
			pl_obj.bind("Init",	function(pl) {
				if (!pluploadQmail.setting.buttons.browse) {
					$('#file_browse_'+pl_id).attr('disabled','disabled').hide();
					pl.disableBrowse(true);
				}
				if (pluploadQmail.setting.buttons.clear) {
					$('#file_clear_'+pl_id).show();
					$('#file_clear_'+pl_id).click(function(e) {
						if(!$('#file_clear_'+pl_id).attr('disabled')){
				    		pl_obj.splice();
				    		$('file_list_'+pl_id).html('');
						}
		    	        e.preventDefault();
			    	});
				}
				if (pluploadQmail.setting.buttons.start) {
					$('#file_start_'+pl_id).show();
					$('#file_start_'+pl_id).click(function(e) {
						if(!$('#file_start_'+pl_id).attr('disabled')){
							pl_obj.start();
						}
		    	        e.preventDefault();
			    	});
				}
				if (pluploadQmail.setting.buttons.stop) {
					$('#file_stop_'+pl_id).show();
					$('#file_stop_'+pl_id).click(function(e) {
						if(!$('#file_stop_'+pl_id).attr('disabled')){
							pl_obj.stop();
						}
		    	        e.preventDefault();
			    	});
				}
				if (pluploadQmail.setting.rename && !pluploadQmail.setting.unique_names) {
					pl_uploader.on('click','#file_list_' + pl_id+' span.plupload_file_name',function(file_span) {
						var file_target = $(file_span).find('font').eq(0), file_suffix = "";
						var file = pl.getFile($(file_span).attr('file_id'));
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
							if ($.inArray(e.keyCode,[13,27]) !== -1) {
									e.preventDefault();
									if (e.keyCode === 13) {
										file.name = $(this).val()+ file_suffix;
										file_target.html(file.name);
									}
									$(this).blur();
								}
							});
					});
				}
				if (pl_obj.features.dragdrop && pluploadQmail.setting.dragdrop) {
					pl.settings.drop_element = 'file_list_'+ pl_id;
					$("#file_list_" + pl_id) .append( '<li style="background: transparent;text-align: center;vertical-align: middle;border: 0;line-height: 100px;">' 
														+ i18n("Drag files here.") + "</li>");
				}
				
				$('#container_'+pl_id).attr('title',i18n("Using runtime: ")+(pluploadQmail.runtime = pl.runtime));
				
			});
			
			if (pluploadQmail.setting.max_file_count) {
				pl_obj.bind("FilesAdded", function(pl, add_files) {
					var out_file = [];
					var out_length = pl.files.length + add_files.length - pluploadQmail.setting.max_file_count;
					if (out_length > 0) {
						out_file = add_files.splice(add_files.length - out_length, out_length);
						pl.trigger("Error", {
							code : pluploadQmail.FILE_COUNT_ERROR,
							message : i18n("File count error."),
							file : out_file
						});
					}
				});
			}
			pl_obj.init();
			
			pl_obj.bind("FilesAdded", function(pl, files) {
				var span_str = '';
				$.each(files, function(index, file) {
					span_str = '<div id="file_obj_'+file.id+'" >'
							 + '<span file_id="'+file.id+'" style="float:left;" class="plupload_file_name" ><font color="black">'+file.name+'</font>&nbsp;</span>'
							 + '<span style="float:left;">&nbsp;<font color="gray">('+plupload.formatSize(file.size)+')</font>&nbsp;</span>'
							 + '<div style="float:left;" id="file_status_'+file.id+'"></div>'
							 + '<span style="float:left;">&nbsp;<a id="file_remove_'+file.id+'"><font color="blue">删除</font></a></span>'
							 + '<br/></div>';
					$('#file_list_'+pl_id).append(span_str);	
					$('#file_remove_'+file.id).click(function(e) {
						pl_obj.removeFile(file);
						e.preventDefault();
					});
					
					file.status_obj = $('#file_status_'+file.id);
					file.remove_obj = $('#file_remove_'+file.id);
				});
				
		        pl.refresh();
				$('#file_count_'+pl_id).html('当前选择上传<font color="red">'+pl.files.length+'</font>个附件</div>');
		        
				
				if (pluploadQmail.setting.autostart) {
					setTimeout(function(e) {
						pl_obj.start();
						e.preventDefault();
					}, 10);
				}
			});

			pl_obj.bind("FilesRemoved", function(pl, files) {
				$.each(files,function(index,file){
					$("#file_obj_"+ file.id).remove();
				});
			});
			
			pl_obj.bind("QueueChanged", function(pl) {
				if (!pl_obj.files.length && pl_obj.features.dragdrop && pl_obj.settings.dragdrop) {
					$("#file_list_" + pl_id) .append( '<li style="background: transparent;text-align: center;vertical-align: middle;border: 0;line-height: 100px;">' 
														+ i18n("Drag files here.") + "</li>");
				}
			});
			
			pl_obj.bind("StateChanged", function(pl) {
				if (pl_obj.features.multiple_queues && pluploadQmail.setting.multiple_queues){
					$('#file_browse_'+pl_id).attr('disabled','disabled');
					pl.disableBrowse(true);
				}
			});
			
			
			pl_obj.bind('BeforeUpload', function(pl, file) {
		       	var progress = '<div style="border: 1px solid #84A24A; width: 100px; height: 7px; float: left;">'
		       				+ '	<div id="file_progbar_'+file.id+'" style="background: #CDEB8B; width:0px; height: 7px; float: left;"></div>'
		       				+ '</div>';
		       	$('#file_status_' + file.id).html(progress);
		    });
			
			pl_obj.bind('UploadProgress', function(pl, file) {
			   	if(file.percent <100){
			       $('#file_progbar_' + file.id).css('width',file.percent);
				}else{
			        $('#file_status_' + file.id).html("");
				}
		    });
		 
			pl_obj.bind("FileUploaded", function(pl, file,response) {
			});
			
			pl_obj.bind('Error', function(up, err) {
		        var err_file = err.file,err_msg ='';
		        var err_detail = err.details;
				if (err_file) {
					err_msg = "<strong>" + err.message + "</strong>";
					
					if (err_detail) {
						err_msg += " <br /><i>"	+ err_detail + "</i>";
					} else {switch (err.code) {
						case plupload.FILE_EXTENSION_ERROR:
							err_detail = i18n("File: %s").replace("%s",	err_file.name);
							break;
						case plupload.FILE_SIZE_ERROR:
							err_detail = i18n("File: %f, size: %s, max file size: %m")
									.replace(/%([fsm])/g, function(r, q) {switch (q) {
											case "f": return err_file.name;
											case "s": return plupload.formatSize(err_file.size);
											case "m": return plupload.formatSize(plupload.parseSize(pluploadQmail.setting.max_file_size));
										}
									});
							break;
						case pluploadQmail.FILE_COUNT_ERROR:
							err_detail = i18n("Upload element accepts only %d file(s) at a time. Extra files were stripped.")
										.replace("%d", pluploadQmail.setting.max_file_count);
							break;
						case plupload.IMAGE_FORMAT_ERROR:
							err_detail = i18n("Image format either wrong or not supported.");
							break;
						case plupload.IMAGE_MEMORY_ERROR:
							err_detail = i18n("Runtime ran out of available memory.");
							break;
						case plupload.IMAGE_DIMENSIONS_ERROR:
							err_detail = i18n("Resoultion out of boundaries! <b>%s</b> runtime supports images only up to %wx%hpx.")
									.replace(/%([swh])/g, function(r, q){switch (q) {
											case "s": return pl.runtime;
											case "w": return pl.features.maxWidth;
											case "h": return pl.features.maxHeight;
										}
									});
							break;
						case plupload.HTTP_ERROR:
							err_detail = i18n("Upload URL might be wrong or doesn't exist");
							break;
						}
						err_msg += " <br /><i>" + err_detail + "</i>";
					}
			        $('file_status_'+err_file.id).html(err_msg);
				}
		        
				$('#file_message_'+pl_id).html(err_msg);
			    up.refresh();
		    });
		 
		});
	}};
})(jQuery);
