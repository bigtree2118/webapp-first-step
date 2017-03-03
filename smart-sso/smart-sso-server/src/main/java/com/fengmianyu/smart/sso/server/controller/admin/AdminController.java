package com.fengmianyu.smart.sso.server.controller.admin;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.sso.core.rpc.Permissionable;

/**
 * 首页管理
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/admin")
public class AdminController {
	private static final Logger LOGGER = LoggerFactory.getLogger(AdminController.class);
	
	@RequestMapping(value="index", method = RequestMethod.GET)
	public String index() {
		return "/admin/index";
	}

	@RequestMapping(value = "menu", method = RequestMethod.GET)
	public @ResponseBody Result menu(HttpServletRequest request) {
		try {
			//从回话中获取登录用户权限下的菜单
			Object userMenuList = request.getSession().getAttribute(Permissionable.SESSION_USER_MENU);
			//从上下文中获取当前系统菜单
			Object appMenuList = request.getServletContext().getAttribute(Permissionable.APPLICATION_MENU);
			// 如果配置的权限拦截器，则返回登录用户权限下的菜单，没有权限拦截限制的情况下，返回当前系统菜单呈现
			Object resultData = (userMenuList==null ? appMenuList : userMenuList);
			
			return Result.createSuccessResult().setData(resultData);
		} catch (Exception e) {
			LOGGER.error("获取菜单出现异常", e);
			return Result.createErrorResult().setMsg("获取菜单出现异常，请联系管理员");
		}
	}
}