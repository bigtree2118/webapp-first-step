package com.fengmianyu.smart.sso.server.controller.common;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

/**
 * 公用控制
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/common/common")
public class CommonController {

	/**
	 * 没访问权限跳转页
	 * 
	 * @return
	 */
	@RequestMapping(value = "noPermission", method = RequestMethod.GET)
	public String noPermission() {
		return "/noPermission";
	}

	/**
	 * 系统公用错误页
	 * 
	 * @return
	 */
	@RequestMapping(value = "error", method = RequestMethod.GET)
	public String error() {
		return "/error";
	}
}