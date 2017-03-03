package com.fengmianyu.smart.sso.core.client.model;

import java.util.Date;

import com.alibaba.fastjson.annotation.JSONField;
import com.fengmianyu.smart.mvc.enums.TrueFalseEnum;
import com.fengmianyu.smart.mvc.model.PersistentObject;

/**
 * 人员本地信息
 * 
 * @author Jack
 */
public class UserLocalInfo extends PersistentObject {

	private static final long serialVersionUID = 1L;
	/** 主键ID */
	private Integer id;	
	/** 用户工号*/
	private String jobNo;
	/** 登录名 */
	private String account;
	/** 组织机构id*/
	private int orgId;
	/** 用户姓名*/
	private String userName;
	/** 性别1=男，2=女*/
	private int gender;
	/** 电子邮箱*/
	private String email;
	/** 手机号码*/
	private String cellPhone;
	/** 联系地址*/
	private String address;
	/** 用户类型（保留字段）*/
	private int userType;
	/** 系统内置*/
	private Boolean isSys=Boolean.valueOf(true);
	/** 最后登录IP */
	private String lastLoginIp;
	/** 最后登录时间 */
	@JSONField(format = "yyyy-MM-dd HH:mm:ss")
	private Date lastLoginTime;
	
	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public String getAccount() {
		return account;
	}

	public void setAccount(String account) {
		this.account = account;
	}

	public String getLastLoginIp() {
		return lastLoginIp;
	}

	public void setLastLoginIp(String lastLoginIp) {
		this.lastLoginIp = lastLoginIp;
	}

	public Date getLastLoginTime() {
		return lastLoginTime;
	}

	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}

	public String getJobNo() {
		return jobNo;
	}

	public void setJobNo(String jobNo) {
		this.jobNo = jobNo;
	}

	public int getOrgId() {
		return orgId;
	}

	public void setOrgId(int orgId) {
		this.orgId = orgId;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public int getGender() {
		return gender;
	}

	public void setGender(int gender) {
		this.gender = gender;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCellPhone() {
		return cellPhone;
	}

	public void setCellPhone(String cellPhone) {
		this.cellPhone = cellPhone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getUserType() {
		return userType;
	}

	public void setUserType(int userType) {
		this.userType = userType;
	}

	public Boolean getIsSys() {
		return isSys;
	}

	public void setIsSys(Boolean isSys) {
		this.isSys = isSys;
	}

	public String getIsSysStr() {
		return (isSys != null && isSys) ? TrueFalseEnum.TRUE.getLabel() : TrueFalseEnum.FALSE.getLabel();
	}
}
