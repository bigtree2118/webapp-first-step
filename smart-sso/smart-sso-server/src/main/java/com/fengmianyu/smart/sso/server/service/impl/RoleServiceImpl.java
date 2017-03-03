package com.fengmianyu.smart.sso.server.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fengmianyu.smart.mvc.exception.ServiceException;
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.service.mybatis.ServiceImpl;
import com.fengmianyu.smart.sso.server.common.Permissible;
import com.fengmianyu.smart.sso.server.dao.RoleDao;
import com.fengmianyu.smart.sso.server.model.Role;
import com.fengmianyu.smart.sso.server.service.RolePermissionService;
import com.fengmianyu.smart.sso.server.service.RoleService;
import com.fengmianyu.smart.sso.server.service.UserRoleService;

@Service("roleService")
public class RoleServiceImpl extends ServiceImpl<RoleDao, Role, Integer> implements RoleService {
	
	@Resource
	private UserRoleService userRoleService;
	@Resource
	private RolePermissionService rolePermissionService;

	@Autowired
	public void setDao(RoleDao dao) {
		this.dao = dao;
	}
	
	@Permissible
	public Result enable(Boolean isEnable, List<Integer> idList) {
		if(isEnable==false){
			boolean have = issys(idList);
			if(have){
				return Result.createErrorResult("", "不能禁用系统内置对象！");
			}
		}
		int rows = dao.enable(isEnable, idList);
		if (rows != idList.size()){
			throw new ServiceException("启用/禁用有误");
		}else{
			return Result.createSuccessResult().setMsg("操作成功：成功改变应用状态！");
		}
	}
	
	@Permissible
	public int saveOrUpdate(Role t) {
		return super.saveOrUpdate(t);
	}

	public Pagination<Role> findAllPagination(String name, Integer appId ,Boolean isEnable ,String sort , String order , Pagination<Role> p) {
		dao.findAllPagination(name, isEnable, appId,sort,order, p);
		return p;
	}
	
	public List<Role> findByAppId(Boolean isEnable, Integer appId) {
		if (appId == null)
			return new ArrayList<Role>(0);
		return dao.findPaginationByName(null, isEnable, appId, null);
	}
	
	@Permissible
	@Transactional
	public int deleteById(List<Integer> idList) {
		boolean have = issys(idList);
		if(have){
			return -1 ;
		}
		userRoleService.deleteByRoleIds(idList);
		rolePermissionService.deleteByRoleIds(idList);
		int rows = dao.deleteById(idList);
		if (rows != idList.size())
			throw new ServiceException("权限删除有误");
		return rows;
	}
	
	/**
	 * 判断选取的角色集合中是否存在系统内置角色
	 * @param idList
	 * @return
	 */
	private boolean issys(List<Integer> idList) {
		List<String> issyses = dao.findIssysByIds(idList);
		boolean have = false ;
		for(String issys : issyses){
			if("1".equals(issys)){
				have = true ;
				break ;
			}
		}
		return have;
	}
	
	public int deleteByAppIds(List<Integer> idList) {
		return dao.deleteByAppIds(idList);
	}

	@Override
	public Role findRoleAndAppNameById(Integer id) {
		Role role = dao.findRoleAndAppNameById(id);
		return role ;
	}
}
