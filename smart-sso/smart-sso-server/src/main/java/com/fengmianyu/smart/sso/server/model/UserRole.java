package com.fengmianyu.smart.sso.server.model;

import com.fengmianyu.smart.mvc.model.PersistentObject;

/**
 * 管理员角色映射
 * 
 * @author Jack
 */
public class UserRole extends PersistentObject {

	private static final long serialVersionUID = 1L;

	/** 主键ID */
	private Integer id;	
	/** 应用ID */
	private Integer appId;
	/** 管理员ID */
	private Integer userId;
	/** 角色ID */
	private Integer roleId;
	
	
	public UserRole() {
		super();
	}
	
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

	public Integer getUserId() {
		return this.userId;
	}

	public void setUserId(Integer userId) {
		this.userId = userId;
	}

	public Integer getRoleId() {
		return this.roleId;
	}

	public void setRoleId(Integer roleId) {
		this.roleId = roleId;
	}
}
