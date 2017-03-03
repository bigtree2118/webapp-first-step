package com.fengmianyu.smart.sso.server.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.fengmianyu.smart.mvc.provider.PasswordProvider;
import com.fengmianyu.smart.sso.core.client.model.UserLocalInfo;
import com.fengmianyu.smart.sso.core.rpc.AuthenticationRpcService;
import com.fengmianyu.smart.sso.core.rpc.Menu;
import com.fengmianyu.smart.sso.core.rpc.RpcUser;
import com.fengmianyu.smart.sso.server.common.LoginUser;
import com.fengmianyu.smart.sso.server.common.TokenManager;
import com.fengmianyu.smart.sso.server.model.User;
import com.fengmianyu.smart.sso.server.service.PermissionService;
import com.fengmianyu.smart.sso.server.service.UserService;
import com.fengmianyu.smart.util.StringUtils;



@Service("authenticationRpcService")
public class AuthenticationRpcServiceImpl implements AuthenticationRpcService {

	@Resource
	private PermissionService permissionService;
	@Resource
	private UserService userService;

	@Override
	public boolean validate(String token) {
		return TokenManager.validate(token) != null;
	}
	
	@Override
	public RpcUser findAuthInfo(String token, String appCode) {
		LoginUser user = TokenManager.validate(token);
		if (user != null) {
			return this.generateRpcUser(user);
		}
		return null;
	}
	
	@Override
	public List<Menu> findPermissionList(String token, String appCode) {
		if (StringUtils.isBlank(token)) {
			return permissionService.findListById(appCode, null);
		}
		else {
			LoginUser user = TokenManager.validate(token);
			if (user != null) {
				return permissionService.findListById(appCode, user.getUserId());
			}
			else {
				return new ArrayList<Menu>(0);
			}
		}
	}
	
	@Override
	public boolean updatePassword(String token, String newPassword) {
		LoginUser loginUser = TokenManager.validate(token);
		if (loginUser != null) {
			User user = userService.get(loginUser.getUserId());
			user.setPassword(PasswordProvider.encrypt(newPassword));
			int rows = userService.update(user);
			if (rows == 1)
				return true;
			else
				return false;
		}
		else {
			return false;
		}
	}
	
	private RpcUser generateRpcUser(LoginUser loginUser){
		String userName = loginUser.getUserName();
		User sysUser = (User)loginUser.getProfile();
		
		UserLocalInfo userLocalInfo = new UserLocalInfo();
		userLocalInfo.setId(sysUser.getId());
		userLocalInfo.setAccount(sysUser.getAccount());
		userLocalInfo.setUserName(sysUser.getUserName());
		userLocalInfo.setOrgId(userLocalInfo.getOrgId());
		userLocalInfo.setUserType(userLocalInfo.getUserType());
		userLocalInfo.setAddress(sysUser.getAddress());
		userLocalInfo.setCellPhone(sysUser.getCellPhone());
		userLocalInfo.setEmail(sysUser.getEmail());
		userLocalInfo.setCreateTimestamp(sysUser.getCreateTimestamp());
		userLocalInfo.setCreateUserId(sysUser.getCreateUserId());
		userLocalInfo.setGender(sysUser.getGender());
		userLocalInfo.setIsSys(sysUser.getIsSys());
		userLocalInfo.setJobNo(sysUser.getJobNo());
		userLocalInfo.setLastChangeTimestamp(sysUser.getLastChangeTimestamp());
		userLocalInfo.setLastLoginIp(sysUser.getLastLoginIp());
		userLocalInfo.setLastLoginTime(sysUser.getLastLoginTime());
		userLocalInfo.setOrgId(sysUser.getOrgId());
		
		return new RpcUser(userName, userLocalInfo);
	}
}
