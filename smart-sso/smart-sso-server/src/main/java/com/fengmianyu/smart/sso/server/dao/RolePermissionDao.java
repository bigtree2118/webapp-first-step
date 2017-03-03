package com.fengmianyu.smart.sso.server.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fengmianyu.smart.mvc.dao.Dao;
import com.fengmianyu.smart.sso.server.model.RolePermission;


/**
 * 角色权限映射持久化接口
 * 
 * @author Jack
 */
public interface RolePermissionDao extends Dao<RolePermission, Integer> {
	
	public List<RolePermission> findByRoleId(@Param("roleId") Integer roleId);
	
	public int deleteByPermissionIds(@Param("idList") List<Integer> idList);
	
	public int deleteByRoleIds(@Param("idList") List<Integer> idList);
	
	public int deleteByAppIds(@Param("idList") List<Integer> idList);
}
