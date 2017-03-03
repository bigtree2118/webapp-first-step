package com.fengmianyu.smart.sso.server.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fengmianyu.smart.mvc.dao.Dao;
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.sso.server.model.User;


/**
 * 管理员持久化接口
 * 
 * @author Jack
 */
public interface UserDao extends Dao<User, Integer> {
	
	public int enable(@Param("isEnable") Boolean isEnable, @Param("idList") List<Integer> idList);
	
	public int resetPassword(@Param("password") String password, @Param("idList") List<Integer> idList);

	public List<User> findPaginationByAccount(@Param("account") String account, @Param("appId") Integer appId, Pagination<User> p);
	
	public User findByAccount(@Param("account") String account);
	
	public List<User> findPaginationByName(@Param("name") String name, @Param("appId") Integer appId, @Param("sort")String sort, @Param("order")String order, Pagination<User> p);
	
	public User findByJobNo(@Param("jobNo") String jobNo);
}
