package com.fengmianyu.smart.sso.server.service.impl;

import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fengmianyu.smart.mvc.service.mybatis.ServiceImpl;
import com.fengmianyu.smart.sso.server.common.Permissible;
import com.fengmianyu.smart.sso.server.dao.UserAppDao;
import com.fengmianyu.smart.sso.server.model.User;
import com.fengmianyu.smart.sso.server.model.UserApp;
import com.fengmianyu.smart.sso.server.service.UserAppService;
import com.fengmianyu.smart.sso.server.service.UserRoleService;

@Service("userAppService")
public class UserAppServiceImpl extends ServiceImpl<UserAppDao, UserApp, Integer> implements UserAppService {

	@Resource
	private UserRoleService userRoleService;
	
	@Autowired
	public void setDao(UserAppDao dao) {
		this.dao = dao;
	}
	
	@Permissible
	@Transactional
	public int allocate(Integer userId, List<Integer> idList, List<UserApp> list) {
		userRoleService.deleteForChangeApp(userId, idList);
		dao.deleteByUserIds(Arrays.asList(userId));
		return super.save(list);
	}
	
	public UserApp findByUserAppId(Integer userId, Integer roleId) {
		return dao.findByUserAppId(userId, roleId);
	}
	
	public int deleteByUserIds(List<Integer> idList) {
		return dao.deleteByUserIds(idList);
	}
	
	public int deleteByAppIds(List<Integer> idList) {
		return dao.deleteByAppIds(idList);
	}

	@Override
	public List<User> getNotAppUsers(Integer appId) {
		return dao.getNotAppUsers(appId);
	}

	@Transactional
	@Override
	public int setAppUsers(Integer appId, List<UserApp> list) {
		dao.deleteByAppIds(Arrays.asList(appId));
		return super.save(list);
	}
	
}
