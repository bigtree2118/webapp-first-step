package com.fengmianyu.smart.sso.server.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fengmianyu.smart.mvc.exception.ServiceException;
import com.fengmianyu.smart.mvc.service.mybatis.ServiceImpl;
import com.fengmianyu.smart.sso.core.rpc.Menu;
import com.fengmianyu.smart.sso.server.common.Permissible;
import com.fengmianyu.smart.sso.server.dao.PermissionDao;
import com.fengmianyu.smart.sso.server.model.Permission;
import com.fengmianyu.smart.sso.server.service.PermissionService;
import com.fengmianyu.smart.sso.server.service.RolePermissionService;

@Service("permissionService")
public class PermissionServiceImpl extends ServiceImpl<PermissionDao, Permission, Integer> implements PermissionService {

	@Resource
	private RolePermissionService rolePermissionService;
	@Resource
	private PermissionService permissionService;

	@Autowired
	public void setDao(PermissionDao dao) {
		this.dao = dao;
	}

	@Permissible
	public void enable(Boolean isEnable, List<Integer> idList) {
		int rows = dao.enable(isEnable, idList);
		if (rows != idList.size())
			throw new ServiceException("启用/禁用有误");
	}
	
	@Permissible
	public int saveOrUpdate(Permission t) {
		return super.saveOrUpdate(t);
	}

	public List<Permission> findByName(String name, Integer appId, Integer parentId, Boolean isEnable) {
		return dao.findByName(name, appId, parentId, isEnable);
	}
	
	public List<Permission> findByCode(String code, Integer appId, Boolean isEnable) {
		return dao.findByCode(code, appId, isEnable);
	}

	@Permissible
	@Transactional
	public int deletePermission(Integer id, Integer appId) {
		List<Integer> idList = new ArrayList<Integer>();
		
		List<Permission> list = permissionService.findByName(null, appId, null, null);
		loopSubList(id, idList, list);
		idList.add(id);
		
		rolePermissionService.deleteByPermissionIds(idList);
		
		int rows = dao.deleteById(idList);
		if (rows != idList.size())
			throw new ServiceException("权限删除有误");
		return rows;
	}

	// 递归方法，删除子权限
	protected void loopSubList(Integer id, List<Integer> idList, List<Permission> list) {
		for (Permission p : list) {
			if (id.equals(p.getParentId())) {
				idList.add(p.getId());
				loopSubList(p.getId(), idList, list);
			}
		}
	}
	
	public int deleteByAppIds(List<Integer> idList) {
		return dao.deleteByAppIds(idList);
	}

	public List<Menu> findListById(String appCode, Integer userId) {
		return dao.findListById(appCode, userId);
	}
}
