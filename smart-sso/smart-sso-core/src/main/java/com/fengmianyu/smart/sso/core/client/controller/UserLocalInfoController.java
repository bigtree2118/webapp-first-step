package com.fengmianyu.smart.sso.core.client.controller;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fengmianyu.smart.mvc.controller.BaseController;
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.validator.Validator;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.core.client.model.UserLocalInfo;
import com.fengmianyu.smart.sso.core.client.service.UserLocalInfoService;


/**
 * 管理员管理
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/admin/userlocalinfo")
public class UserLocalInfoController extends BaseController {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserLocalInfoController.class);
	
	@Resource
	private UserLocalInfoService userLocalInfoService;

	/**
	 * 进入查询界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String gotoList(Model model) {
		return "/admin/user/user_list";
	}
	
	/**
	 * 查询应用
	 * 
	 * @param name:过滤条件
	 * @param sort:排序字段
	 * @param order:排序方式
	 * @param pageNo:页码
	 * @param pageSize:每页显示条数
	 * @return
	 */
	@RequestMapping(value = "/load", method = RequestMethod.GET)
	public @ResponseBody Result load(@ValidateParam(name = "名称 ") String name, 
			String sort, String order,
			@ValidateParam(name = "开始页码", validators = { Validator.NOT_BLANK }) Integer pageNo,
			@ValidateParam(name = "显示条数 ", validators = { Validator.NOT_BLANK }) Integer pageSize) {
		try {
			// 按查询条件：应用名称，分页查询应用
			Pagination<UserLocalInfo> page = new Pagination<UserLocalInfo>(pageNo, pageSize);
			page = userLocalInfoService.findPaginationByName(name, sort, order, page);
			return Result.createSuccessResult().setData(page);
		} catch (Exception e) {
			LOGGER.error("查询应用操作出现异常", e);
			return Result.createErrorResult().setMsg("查询操作出现异常，请联系管理员");
		}
	}
}