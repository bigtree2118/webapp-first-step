package com.fengmianyu.smart.sso.core.client.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fengmianyu.smart.mvc.dao.Dao;
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.sso.core.client.model.UserLocalInfo;


/**
 * 管理员持久化接口
 * 
 * @author Jack
 */
public interface UserLocalInfoDao extends Dao<UserLocalInfo, Integer> {

	public List<UserLocalInfo> findPaginationByAccount(@Param("account") String account, Pagination<UserLocalInfo> p);
	
	public UserLocalInfo findByAccount(@Param("account") String account);
	
	public List<UserLocalInfo> findPaginationByName(@Param("name") String name, @Param("sort")String sort, @Param("order")String order, Pagination<UserLocalInfo> p);
	
	public UserLocalInfo findByJobNo(@Param("jobNo") String jobNo);
}
