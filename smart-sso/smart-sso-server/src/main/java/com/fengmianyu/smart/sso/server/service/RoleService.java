package com.fengmianyu.smart.sso.server.service;

import java.util.List;

import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.service.Service;
import com.fengmianyu.smart.sso.server.dao.RoleDao;
import com.fengmianyu.smart.sso.server.model.Role;



/**
 * 角色服务接口
 * 
 * @author Jack
 */
public interface RoleService extends Service<RoleDao, Role, Integer> {
	
	/**
	 * 启用禁用操作
	 * @param isEnable 是否启用
	 * @param idList 角色ID集合
	 * @return
	 */
	public Result enable(Boolean isEnable, List<Integer> idList);
	
	/**
	 * 根据角色名称和应用ID查询分页列表
	 * @param name 角色名称
	 * @param appId 应用ID
	 * @param pageNo 分页起始
	 * @param pageSize 分页记录数
	 * @return
	 */
	public Pagination<Role> findAllPagination(String name, Integer appId , Boolean isEnable ,String sort , String order , Pagination<Role> p);
	
	/**
	 * 查询应用可用角色
	 * @param isEnable 是否启用
	 * @param appId 应用ID
	 * @return
	 */
	public List<Role> findByAppId(Boolean isEnable, Integer appId);
	
	/**
	 * 删除某个应用下的所有角色
	 * @param idList 应用ID集合
	 * @return
	 */
	public int deleteByAppIds(List<Integer> idList);
	
	/**
	 * 根据roleId查找Role对象（包含相关联的app名称）
	 * @param id
	 * @return
	 */
	public Role findRoleAndAppNameById(Integer id);
}
