package com.fengmianyu.smart.sso.core.client.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.mvc.service.mybatis.ServiceImpl;
import com.fengmianyu.smart.sso.core.client.dao.UserLocalInfoDao;
import com.fengmianyu.smart.sso.core.client.model.UserLocalInfo;
import com.fengmianyu.smart.sso.core.client.service.UserLocalInfoService;

@Service("userLocalInfoService")
public class UserLocalInfoServiceImpl extends ServiceImpl<UserLocalInfoDao, UserLocalInfo, Integer> implements UserLocalInfoService {

	@Autowired
	public void setDao(UserLocalInfoDao dao) {
		this.dao = dao;
	}
	
	@Override
	@Transactional
	public int saveOrUpdate(UserLocalInfo t) {
		UserLocalInfo temp = dao.get(t.getId());
		if(temp == null){
			return super.save(t);
		}else{
			return super.update(t);
		}
	}

	@Override
	public Pagination<UserLocalInfo> findPaginationByAccount(String account, Pagination<UserLocalInfo> p) {
		dao.findPaginationByAccount(account, p);
		return p;
	}
	
	@Override
	public UserLocalInfo findByAccount(String account) {
		return dao.findByAccount(account);
	}

	@Override
	public Pagination<UserLocalInfo> findPaginationByName(String name, String sort, String order, Pagination<UserLocalInfo> p) {
		dao.findPaginationByName(name, sort, order, p);
		return p;
	}

	@Override
	public UserLocalInfo findByJobNo(String jobNo) {
		return dao.findByJobNo(jobNo);
	}
}
