package com.fengmianyu.smart.mvc.util;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.BeanUtils;
import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.web.context.ServletContextAware;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

/**
 * 上下文工具类
 * @author Chenbing(Jack.Chen)
 * @version 1.0
 * @createTime 2012 11:41:35 AM
 * @Email wwwchenbing@gmail.com
 */
public final class ContextHelper implements ApplicationContextAware,ServletContextAware{
	/**
	 * 当前应用所在的servlet上下文
	 */
	public static ServletContext servletContext;
	
	/**
	 * 当前应用内部Bean所在的application上下文
	 */
	public static ApplicationContext applicationContext;
	
	
	public ContextHelper(){}
	

	/**
	 * 返回当前登录用户ID
	 * @return
	 */
	public static Integer getCurrentUserId(){
		Object profile = getRequest().getSession().getAttribute("_sessionProfile");
		UserProfile userProfile = new UserProfile();
		BeanUtils.copyProperties(profile, userProfile);
		return userProfile.getId();
		
	}
	
	/**
	 * 返回当前登录用户的用户名
	 * @return
	 */
	public static String getCurrentUserName(){
		Object profile = getRequest().getSession().getAttribute("_sessionProfile");
		UserProfile userProfile = new UserProfile();
		BeanUtils.copyProperties(profile, userProfile);
		return userProfile.getUserName();
	}
	
	/**
	 * <p>设置ServletContext。</p>
	 */
	@Override
	public void setServletContext(ServletContext servletContext) {
		ContextHelper.servletContext = servletContext;	
	}


	/**
	 * <p>设置ApplicationContext。</p>
	 */
	@Override
	public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
		ContextHelper.applicationContext = applicationContext;
	}
	
	/**
	 * <p>根据bean的ID获取spring初始化的javabean</p>
	 */
	public static Object getBean(String beanId){
		return getApplicationContext().getBean(beanId);
	}
	
	/**
	 * <p>根据bean的class类型获取spring初始化的javabean</p>
	 */
	public static <T> T getBean(Class<T> classType){
		return getApplicationContext().getBean(classType);
	}
	
	/**
	 * 返回HttpServletRequest
	 * @return
	 */
	public static HttpServletRequest getRequest(){
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		return request;
	}
	
	/**
	 * 返回ServletContext
	 * @return
	 */
	public static ServletContext getServletContext(){
		return ContextHelper.servletContext;
	}
	
	/**
	 * 返回ApplicationContext
	 * @return
	 */
	public static ApplicationContext getApplicationContext(){
		return ContextHelper.applicationContext;
	}
	
	static class UserProfile{
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
		public UserProfile() {
			super();
		}
		public Integer getId() {
			return id;
		}
		public void setId(Integer id) {
			this.id = id;
		}
		public String getJobNo() {
			return jobNo;
		}
		public void setJobNo(String jobNo) {
			this.jobNo = jobNo;
		}
		public String getAccount() {
			return account;
		}
		public void setAccount(String account) {
			this.account = account;
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
		public String getLastLoginIp() {
			return lastLoginIp;
		}
		public void setLastLoginIp(String lastLoginIp) {
			this.lastLoginIp = lastLoginIp;
		}
	}
}
