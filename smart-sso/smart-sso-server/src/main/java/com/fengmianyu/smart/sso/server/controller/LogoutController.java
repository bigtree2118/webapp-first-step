package com.fengmianyu.smart.sso.server.controller;

import javax.servlet.http.HttpServletRequest;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.fengmianyu.smart.mvc.util.CookieUtils;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.server.common.TokenManager;
import com.fengmianyu.smart.util.StringUtils;

/**
 * 远程登出
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/logout")
public class LogoutController {

	@RequestMapping(method = RequestMethod.GET)
	public String logout(@ValidateParam(name = "返回链接") String backUrl, HttpServletRequest request) {
		String token = CookieUtils.getCookie(request, "token");
		if (token != null) {
			TokenManager.remove(token);
		}
		SecurityUtils.getSubject().logout();
		return StringUtils.isBlank(backUrl) ? "redirect:/admin/index" : "redirect:" + backUrl;
	}
}