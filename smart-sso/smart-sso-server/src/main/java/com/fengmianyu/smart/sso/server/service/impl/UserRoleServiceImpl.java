package com.fengmianyu.smart.sso.server.service.impl;

import java.util.Arrays;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fengmianyu.smart.mvc.service.mybatis.ServiceImpl;
import com.fengmianyu.smart.sso.server.common.Permissible;
import com.fengmianyu.smart.sso.server.dao.UserRoleDao;
import com.fengmianyu.smart.sso.server.model.User;
import com.fengmianyu.smart.sso.server.model.UserRole;
import com.fengmianyu.smart.sso.server.service.UserRoleService;


@Service("userRoleService")
public class UserRoleServiceImpl extends ServiceImpl<UserRoleDao, UserRole, Integer> implements UserRoleService {

	@Autowired
	public void setDao(UserRoleDao dao) {
		this.dao = dao;
	}
	
	@Permissible
	@Transactional
	public int allocate(Integer userId, Integer appId, List<UserRole> list) {
		dao.deleteByUserIds(Arrays.asList(userId), appId);
		return super.save(list);
	}
	
	@Transactional
	public UserRole findByUserRoleId(Integer userId, Integer roleId) {
		return dao.findByUserRoleId(userId, roleId);
	}
	
	@Transactional
	public int deleteByRoleIds(List<Integer> idList) {
		return dao.deleteByRoleIds(idList);
	}
	
	@Transactional
	public int deleteByUserIds(List<Integer> idList, Integer appId) {
		return dao.deleteByUserIds(idList, appId);
	}
	
	@Transactional
	public int deleteByAppIds(List<Integer> idList) {
		return dao.deleteByAppIds(idList);
	}

	@Transactional
	public int deleteForChangeApp(Integer userId, List<Integer> idList) {
		if(idList.size()==0){
			idList=null;
		}
		return dao.deleteForChangeApp(userId, idList);
	}

	@Override
	public List<User> getRoleUsers(Integer roleId) {
		return dao.getRoleUsers(roleId);
	}
	
	@Override
	public List<User> getNotRoleUsers(Integer roleId, Integer appId) {
		return dao.getNotRoleUsers(roleId, appId);
	}
	
	@Transactional
	@Override
	public int setRoleUsers(Integer roleId, Integer appId, List<UserRole> list) {
		dao.deleteByRoleIdsAndAppId(Arrays.asList(roleId), appId);
		return super.save(list);
	}
}
