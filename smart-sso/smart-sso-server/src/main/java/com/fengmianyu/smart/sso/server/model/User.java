package com.fengmianyu.smart.sso.server.model;

import java.util.Date;

import com.alibaba.fastjson.annotation.JSONField;
import com.fengmianyu.smart.mvc.enums.TrueFalseEnum;
import com.fengmianyu.smart.mvc.model.PersistentObject;

/**
 * 管理员
 * 
 * @author Jack
 */
public class User extends PersistentObject {

	private static final long serialVersionUID = 1L;

	/** 主键ID */
	private Integer id;	
	/** 用户工号*/
	private String jobNo;
	/** 登录名 */
	private String account;
	/** 密码 */
	private String password;
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
	/** 登录总次数 */
	private Integer loginCount = Integer.valueOf(0);
	/** 是否启用 */
	private Boolean isEnable = Boolean.valueOf(true);
	
	public User() {
		super();
	}

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

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getLastLoginIp() {
		return lastLoginIp;
	}

	public void setLastLoginIp(String lastLoginIp) {
		this.lastLoginIp = lastLoginIp;
	}

	public Integer getLoginCount() {
		return loginCount;
	}

	public void setLoginCount(Integer loginCount) {
		this.loginCount = loginCount;
	}

	public Date getLastLoginTime() {
		return lastLoginTime;
	}

	public void setLastLoginTime(Date lastLoginTime) {
		this.lastLoginTime = lastLoginTime;
	}

	public Boolean getIsEnable() {
		return isEnable;
	}

	public void setIsEnable(Boolean isEnable) {
		this.isEnable = isEnable;
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
	
	public String getIsSysStr() {
		return (isSys != null && isSys) ? TrueFalseEnum.TRUE.getLabel() : TrueFalseEnum.FALSE.getLabel();
	}

}
