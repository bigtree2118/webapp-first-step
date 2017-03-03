package com.fengmianyu.smart.sso.server.service.impl;

import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fengmianyu.smart.mvc.exception.ServiceException;
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.mvc.service.mybatis.ServiceImpl;
import com.fengmianyu.smart.sso.server.common.Permissible;
import com.fengmianyu.smart.sso.server.dao.AppDao;
import com.fengmianyu.smart.sso.server.model.App;
import com.fengmianyu.smart.sso.server.service.AppService;
import com.fengmianyu.smart.sso.server.service.PermissionService;
import com.fengmianyu.smart.sso.server.service.RolePermissionService;
import com.fengmianyu.smart.sso.server.service.RoleService;
import com.fengmianyu.smart.sso.server.service.UserAppService;
import com.fengmianyu.smart.sso.server.service.UserRoleService;
import com.fengmianyu.smart.sso.server.service.UserService;

@Service("appService")
public class AppServiceImpl extends ServiceImpl<AppDao, App, Integer> implements AppService {
	
	@Resource
	private UserService userService;
	@Resource
	private RoleService roleService;
	@Resource
	private PermissionService permissionService;
	@Resource
	private UserRoleService userRoleService;
	@Resource
	private UserAppService userAppService;
	@Resource
	private RolePermissionService rolePermissionService;

	@Autowired
	public void setDao(AppDao dao) {
		this.dao = dao;
	}
	
	@Permissible
	public int enable(Boolean isEnable, List<Integer> idList) {
		return dao.enable(isEnable, idList);
	}
	
	@Permissible
	public int saveOrUpdate(App t) {
		return super.saveOrUpdate(t);
	}

	public List<App> findByAll(String name) {
		return dao.findPaginationByName(name, null, null, null);
	}

	public Pagination<App> findPaginationByName(String name, String sort, String order, Pagination<App> p) {
		dao.findPaginationByName(name, sort, order, p);
		return p;
	}

	public App findByCode(String code) {
		return dao.findByCode(code);
	}
	
	public List<App> findByUserId(Boolean isEnable, Integer userId) {
		return dao.findByUserId(isEnable, userId);
	}
	
	@Permissible
	@Transactional
	public int deleteById(List<Integer> idList) {
		rolePermissionService.deleteByAppIds(idList);
		userRoleService.deleteByAppIds(idList);
		userAppService.deleteByAppIds(idList);
		permissionService.deleteByAppIds(idList);
		roleService.deleteByAppIds(idList);
		int rows = dao.deleteById(idList);
		if (rows != idList.size())
			throw new ServiceException("应用删除有误");
		return rows;
	}

	public Set<String> findAppCodeByUserId(Boolean isEnable, Integer userId) {
		return dao.findAppCodeByUserId(isEnable, userId);
	}

	@Override
	public List<Map<String, Object>> findAppAllIdName() {
		List<Map<String, Object>> maps = dao.findAppAllIdName();
		return maps;
	}
}
