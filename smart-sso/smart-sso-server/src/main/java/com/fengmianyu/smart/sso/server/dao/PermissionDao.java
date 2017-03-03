package com.fengmianyu.smart.sso.server.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fengmianyu.smart.mvc.dao.Dao;
import com.fengmianyu.smart.sso.core.rpc.Menu;
import com.fengmianyu.smart.sso.server.model.Permission;



/**
 * 权限持久化接口
 * 
 * @author Jack
 */
public interface PermissionDao extends Dao<Permission, Integer> {
	
	public int enable(@Param("isEnable") Boolean isEnable, @Param("idList") List<Integer> idList);
	
	public int resetPassword(@Param("password") String password, @Param("idList") List<Integer> idList);

	public List<Permission> findByName(@Param("name") String name, @Param("appId") Integer appId, @Param("parentId") Integer parentId, @Param("isEnable") Boolean isEnable);
	
	public List<Permission> findByCode(@Param("code") String code, @Param("appId") Integer appId, @Param("isEnable") Boolean isEnable);
	
	public int deleteByAppIds(@Param("idList") List<Integer> idList);
	
	public List<Menu> findListById(@Param("appCode") String appCode, @Param("userId") Integer userId);
}
