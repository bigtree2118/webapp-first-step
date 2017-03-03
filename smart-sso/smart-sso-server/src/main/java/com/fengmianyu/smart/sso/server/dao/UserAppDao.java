package com.fengmianyu.smart.sso.server.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fengmianyu.smart.mvc.dao.Dao;
import com.fengmianyu.smart.sso.server.model.User;
import com.fengmianyu.smart.sso.server.model.UserApp;


/**
 * 管理员角色映射持久化接口
 * 
 * @author Jack
 */
public interface UserAppDao extends Dao<UserApp, Integer> {

	public UserApp findByUserAppId(@Param("userId") Integer userId, @Param("appId") Integer appId);

	public int deleteByAppIds(@Param("idList") List<Integer> idList);

	public int deleteByUserIds(@Param("idList") List<Integer> idList);
	
	public List<User> getNotAppUsers(@Param("appId") Integer appId);
	
}
