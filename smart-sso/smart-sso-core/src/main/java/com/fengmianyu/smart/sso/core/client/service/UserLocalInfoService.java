package com.fengmianyu.smart.sso.core.client.service;

import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.mvc.service.Service;
import com.fengmianyu.smart.sso.core.client.dao.UserLocalInfoDao;
import com.fengmianyu.smart.sso.core.client.model.UserLocalInfo;



/**
 * 人员本地服务接口
 * 
 * @author Jack
 */
public interface UserLocalInfoService extends Service<UserLocalInfoDao, UserLocalInfo, Integer> {
	/**
	 * 根据登录名和应用ID查询分页列表
	 * @param account 登录名
	 * @param appId 应用ID
	 * @param pageNo 分页起始
	 * @param pageSize 分页记录数
	 * @return
	 */
	public Pagination<UserLocalInfo> findPaginationByAccount(String account, Pagination<UserLocalInfo> p);
	
	/**
	 * 根据登录查询
	 * @param account 登录名
	 * @return
	 */
	public UserLocalInfo findByAccount(String account);
	
	/**
	 * 根据名称分页查询
	 * @param name 人员姓名
	 * @return
	 */
	public Pagination<UserLocalInfo> findPaginationByName(String name, String sort, String order, Pagination<UserLocalInfo> p);
	
	/**
	 * 根据工号查询
	 * @param jobNo 工号
	 * @return
	 */
	public UserLocalInfo findByJobNo(String jobNo);
}
