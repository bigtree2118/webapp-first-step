package com.fengmianyu.smart.sso.server.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.fengmianyu.smart.mvc.dao.Dao;
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.sso.server.model.Role;


/**
 * 角色持久化接口
 * 
 * @author Jack
 */
public interface RoleDao extends Dao<Role, Integer> {

	public int enable(@Param("isEnable") Boolean isEnable, @Param("idList") List<Integer> idList);

	public int resetPassword(@Param("password") String password, @Param("idList") List<Integer> idList);

	public List<Role> findAllPagination(@Param("name") String name, @Param("isEnable") Boolean isEnable,
										   @Param("appId") Integer appId,@Param("sort") String sort,
										   @Param("order") String order,Pagination<Role> p);
	
	public List<Role> findPaginationByName(@Param("name") String name, @Param("isEnable") Boolean isEnable,
			@Param("appId") Integer appId, Pagination<Role> p);


	public int deleteByAppIds(@Param("idList") List<Integer> idList);
	
	public Role findRoleAndAppNameById(@Param("id")Integer id);
	
	public List<String> findIssysByIds(@Param("idList")List<Integer> idList);
}
