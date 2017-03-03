package com.fengmianyu.smart.sso.server.model;

import java.util.Date;

import com.alibaba.fastjson.annotation.JSONField;
import com.fengmianyu.smart.mvc.enums.TrueFalseEnum;
import com.fengmianyu.smart.mvc.model.PersistentObject;

/**
 * 角色
 * 
 * @author Jack
 */
public class Role extends PersistentObject {

	private static final long serialVersionUID = 1L;

	/** 主键ID */
	private Integer id;	
	/** 应用ID */
	private Integer appId;
	/** 名称 */
	private String name;
	/** 排序 */
	private Integer sort = Integer.valueOf(1);
	/** 描述 */
	private String description;
	/** 是否启用 */
	private Boolean isEnable = Boolean.valueOf(true);
	/**创建时间  */
	@JSONField(format = "yyyy-MM-dd HH:mm:ss")
	private Date create_timestamp ;
	/**修改时间  */
	@JSONField(format = "yyyy-MM-dd HH:mm:ss")
	private Date last_change_timestamp ;
	/**改变者Id */
	private Integer change_user_id ;
	/**创建者ID */
	private Integer create_user_id ;
	
	/**应用名称  */
	private String appName ;
	
	/** 系统内置 */
	private Boolean issys = Boolean.valueOf(false);
	
	
	public Role() {
		super();
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public Boolean getIssys() {
		return issys;
	}

	public void setIssys(Boolean issys) {
		this.issys = issys;
	}

	public Date getCreate_timestamp() {
		return create_timestamp;
	}

	public void setCreate_timestamp(Date create_timestamp) {
		this.create_timestamp = create_timestamp;
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

	public Integer getCreate_user_id() {
		return create_user_id;
	}

	public void setCreate_user_id(Integer create_user_id) {
		this.create_user_id = create_user_id;
	}

	public String getAppName() {
		return appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}

	public Integer getAppId() {
		return this.appId;
	}

	public void setAppId(Integer appId) {
		this.appId = appId;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Integer getSort() {
		return this.sort;
	}

	public void setSort(Integer sort) {
		this.sort = sort;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Boolean getIsEnable() {
		return this.isEnable;
	}

	public void setIsEnable(Boolean isEnable) {
		this.isEnable = isEnable;
	}
	
	/** 以下为显示辅助参数 */
	private Boolean isChecked = Boolean.valueOf(false);
	
	public Boolean getIsChecked() {
		return isChecked;
	}

	public void setIsChecked(Boolean isChecked) {
		this.isChecked = isChecked;
	}
	
	public String getIsEnableStr() {
		return (isEnable != null && isEnable) ? TrueFalseEnum.TRUE.getLabel() : TrueFalseEnum.FALSE.getLabel();
	}
}
