package com.fengmianyu.smart.sso.server.controller.admin;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.validator.Validator;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.core.rpc.AuthenticationRpcService;
import com.fengmianyu.smart.sso.core.rpc.Permissionable;

/**
 * 首页管理
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/admin/uspace")
public class UserSpaceController {
	private static final Logger LOGGER = LoggerFactory.getLogger(UserSpaceController.class);
	@Resource
	private AuthenticationRpcService authenticationRpcService;
	
	@RequestMapping(value = "index")
	public String index() {
		return "/admin/uspace/space_main";
	}
	
	@RequestMapping(value = "gotoPassword")
	public String gotoPassword() {
		return "/admin/uspace/space_password";
	}
	
	@RequestMapping(value = "savePassword", method = RequestMethod.POST)
	@ResponseBody
	public Result savePassword(
			@ValidateParam(name = "新密码", validators = { Validator.NOT_BLANK }) String newPassword,
			@ValidateParam(name = "确认密码", validators = { Validator.NOT_BLANK }) String confirmPassword,
			HttpServletRequest request) {
		try {
			if (newPassword.equals(confirmPassword)
					&& authenticationRpcService.updatePassword(
							request.getSession().getAttribute(Permissionable.SESSION_TOKEN).toString(), newPassword))
				return Result.createSuccessResult().setMsg("修改成功");
			else
				return Result.createErrorResult().setMsg("修改失败");
		} catch (Exception e) {
			LOGGER.error("修改密码出现异常", e);
			return Result.createErrorResult().setMsg("修改密码出现异常，请联系管理员");
		}
	}
}
