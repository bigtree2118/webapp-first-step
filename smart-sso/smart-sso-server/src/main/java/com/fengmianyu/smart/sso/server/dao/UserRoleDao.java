package com.fengmianyu.smart.sso.server.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fengmianyu.smart.mvc.dao.Dao;
import com.fengmianyu.smart.sso.server.model.User;
import com.fengmianyu.smart.sso.server.model.UserRole;


/**
 * 管理员角色映射持久化接口
 * 
 * @author Jack
 */
public interface UserRoleDao extends Dao<UserRole, Integer> {

	public UserRole findByUserRoleId(@Param("userId") Integer userId, @Param("roleId") Integer roleId);

	public int deleteByRoleIds(@Param("idList") List<Integer> idList);

	public int deleteByUserIds(@Param("idList") List<Integer> idList, @Param("appId") Integer appId);
	
	public int deleteByRoleIdsAndAppId(@Param("idList") List<Integer> idList, @Param("appId") Integer appId);

	public int deleteByAppIds(@Param("idList") List<Integer> idList);
	
	public int deleteForChangeApp(@Param("userId") Integer userId, @Param("idList") List<Integer> idList);
	
	public List<User> getRoleUsers(@Param("roleId") Integer roleId);
	
	public List<User> getNotRoleUsers(@Param("roleId") Integer roleId, @Param("appId") Integer appId);
}
