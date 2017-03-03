package com.fengmianyu.smart.sso.server.model;

import java.beans.Transient;
import java.util.Date;

import com.alibaba.fastjson.annotation.JSONField;
import com.fengmianyu.smart.mvc.model.PersistentObject;

/**
 * 权限
 * 
 * @author Jack
 */
public class Permission extends PersistentObject {

	private static final long serialVersionUID = 1L;

	/** 主键ID */
	private Integer id;	
	/** 应用ID */
	private Integer appId;
	/** 父ID */
	private Integer parentId;
	/** 图标 */
	@JSONField(serialize = false)
	private String icon;
	/** 名称 */
	private String name;
	/** 编码*/
	private String code;
	/** 权限URL */
	@JSONField(serialize = false)
	private String url;
	/** 相关URL */
	private String rela_url;
	/** 排序 */
	private Integer sort = Integer.valueOf(1);
	/** 是否路径菜单 */
	private Boolean path_menu;
	/** 是否菜单 */
	private Boolean isMenu;
	/** 是否启用 */
	private Boolean isEnable;
	/** 备注说明*/
	private String remark;
	/** 创建时间*/
	@JSONField(format = "yyyy-MM-dd HH:mm:ss")
	private Date create_timestamp;
	/** 创建人ID*/
	private Integer create_user_id;
	/** 上次修改时间*/
	@JSONField(format = "yyyy-MM-dd HH:mm:ss")
	private Date last_change_timestamp;
	/** 修改人ID*/
	private Integer change_user_id;
	
	//-----------扩展字段-----------//
	/** 是否选中，用于表示角色是否拥有该权限*/
	private Boolean checked;
	
	public Permission() {	}
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Integer getAppId() {
		return this.appId;
	}

	public void setAppId(Integer appId) {
		this.appId = appId;
	}

	public Integer getParentId() {
		return this.parentId;
	}

	public void setParentId(Integer parentId) {
		this.parentId = parentId;
	}
	
	public String getIcon() {
		return icon;
	}

	public void setIcon(String icon) {
		this.icon = icon;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public Integer getSort() {
		return this.sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public Boolean getIsMenu() {
		return this.isMenu;
	}

	public void setIsMenu(Boolean isMenu) {
		this.isMenu = isMenu;
	}

	public Boolean getIsEnable() {
		return this.isEnable;
	}

	public void setIsEnable(Boolean isEnable) {
		this.isEnable = isEnable;
	}
	
	@Transient
	public String getUrlStr() {
		return url;
	}
	
	@Transient
	public String getPermissionIcon() {
		return icon;
	}

	@Transient
	public Integer getpId() {
		return this.parentId;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public String getRela_url() {
		return rela_url;
	}

	public void setRela_url(String rela_url) {
		this.rela_url = rela_url;
	}

	public Boolean getPath_menu() {
		return path_menu;
	}

	public void setPath_menu(Boolean path_menu) {
		this.path_menu = path_menu;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public Date getCreate_timestamp() {
		return create_timestamp;
	}

	public void setCreate_timestamp(Date create_timestamp) {
		this.create_timestamp = create_timestamp;
	}

	public Integer getCreate_user_id() {
		return create_user_id;
	}

	public void setCreate_user_id(Integer create_user_id) {
		this.create_user_id = create_user_id;
	}

	public Date getLast_change_timestamp() {
		return last_change_timestamp;
	}

	public void setLast_change_timestamp(Date last_change_timestamp) {
		this.last_change_timestamp = last_change_timestamp;
	}

	public Integer getChange_user_id() {
		return change_user_id;
	}

	public void setChange_user_id(Integer change_user_id) {
		this.change_user_id = change_user_id;
	}

	public Boolean getChecked() {
		return checked;
	}

	public void setChecked(Boolean checked) {
		this.checked = checked;
	}
	
}
