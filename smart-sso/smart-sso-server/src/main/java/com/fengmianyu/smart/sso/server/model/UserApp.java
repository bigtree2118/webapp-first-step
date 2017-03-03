package com.fengmianyu.smart.sso.server.model;

import com.fengmianyu.smart.mvc.model.PersistentObject;

/**
 * 管理员应用映射
 * 
 * @author Jack
 */
public class UserApp extends PersistentObject {

	private static final long serialVersionUID = 1L;
	/** 主键ID */
	private Integer id;	
	/** 应用ID */
	private Integer appId;
	/** 管理员ID */
	private Integer userId;
	
	public UserApp() {
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
}
