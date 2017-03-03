package com.fengmianyu.smart.sso.server.service;

import java.util.List;

import com.fengmianyu.smart.mvc.service.Service;
import com.fengmianyu.smart.sso.server.dao.UserAppDao;
import com.fengmianyu.smart.sso.server.model.User;
import com.fengmianyu.smart.sso.server.model.UserApp;

/**
 * 管理员角色映射服务接口
 * 
 * @author Jack
 */
public interface UserAppService extends Service<UserAppDao, UserApp, Integer> {
	
	/**
	 * 根据管理员ID和角色ID查询映射
	 * @param userId 管理员ID
	 * @param roleId 角色ID
	 * @return
	 */
	public UserApp findByUserAppId(Integer userId, Integer roleId);
	
	/**
	 * 根据管理员ID给管理员分配角色
	 * @param userId 管理员ID
	 * @param idList 应用ID集合
	 * @param list 管理员角色映射集合
	 * @return
	 */
	public int allocate(Integer userId, List<Integer> idList, List<UserApp> list);
	
	/**
	 * 根据管理员ID集合删除映射
	 * @param idList 管理员ID集合
	 * @return
	 */
	public int deleteByUserIds(List<Integer> idList);
	
	/**
	 * 根据应用ID集合删除映射
	 * @param idList 应用ID集合
	 * @return
	 */
	public int deleteByAppIds(List<Integer> idList);
	
	/**
	 * 加载未分配应用的人员列表
	 * @param appId 应用ID
	 * @return
	 */
	public List<User> getNotAppUsers(Integer appId);
	
	/**
	 * 根据应用ID给应用设置人员
	 * @param appId 应用ID
	 * @param list 管理员角色映射集合
	 * @return
	 */
	public int setAppUsers(Integer appId, List<UserApp> list);

}
