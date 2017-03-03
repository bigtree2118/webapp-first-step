package com.fengmianyu.smart.sso.core.client;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authc.LogoutFilter;
import org.springframework.beans.factory.annotation.Autowired;

import com.fengmianyu.smart.sso.core.rpc.AuthenticationRpcService;


/**
 * 单点退出配置
 * 
 * @author Jack
 */
public class SsoLogoutFilter extends LogoutFilter {
	
	@Autowired
	private AuthenticationRpcService authenticationRpcService;

	@Override
	protected boolean preHandle(ServletRequest request, ServletResponse response) throws Exception {
		Subject subject = SecurityUtils.getSubject();
		if (subject != null && !authenticationRpcService.validate(subject.getPrincipal().toString())) {
			String redirectUrl = getRedirectUrl(request, response, subject);
			subject.logout();
			issueRedirect(request, response, redirectUrl);
			return false;
		}
		return true;
	}
}
