package com.fengmianyu.smart.sso.server.controller.admin;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fengmianyu.smart.mvc.controller.BaseController;
import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.validator.Validator;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.server.model.App;
import com.fengmianyu.smart.sso.server.model.User;
import com.fengmianyu.smart.sso.server.model.UserApp;
import com.fengmianyu.smart.sso.server.service.AppService;
import com.fengmianyu.smart.sso.server.service.UserAppService;

/**
 * 管理员管理
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/admin/userApp")
public class UserAppController extends BaseController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(UserAppController.class);

	@Resource
	private AppService appService;
	@Resource
	private UserAppService userAppService;
	
	@RequestMapping(value = "/allocate", method = RequestMethod.GET)
	public String edit(@ValidateParam(name = "管理员Id", validators = { Validator.NOT_BLANK }) Integer userId, Model model) {
		model.addAttribute("userId", userId);
		model.addAttribute("appList", getAppList(userId));
		return "/admin/user/user_app";
	}

	@RequestMapping(value = "/allocateSave", method = RequestMethod.POST)
	public @ResponseBody Result allocateSave(
			@ValidateParam(name = "管理员ID", validators = { Validator.NOT_BLANK }) Integer userId,
			@ValidateParam(name = "应用IDS") String appIds,
			HttpServletRequest request) {
		List<Integer> idList = getAjaxIds(appIds);
		List<UserApp> list = new ArrayList<UserApp>();
		UserApp bean = null;
		for (Integer appId : idList) {
			bean = new UserApp();
			bean.setAppId(appId);
			bean.setUserId(userId);
			list.add(bean);
		}
		return Result.createSuccessResult(userAppService.allocate(userId, idList, list), "授权成功");
	}
	
	/**
	 * 进入应用用户界面
	 * @param appId
	 * @return
	 */
	@RequestMapping(value = "/gotoAppUsers", method = RequestMethod.GET)
	public String gotoRoleUser(
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK })Integer appId){
		return "/admin/app/app_user";
	}
	
	/**
	 * 加载没有分配应用的人员列表
	 * @param roleId
	 * @return
	 */
	@RequestMapping(value = "/getNotAppUsers", method = RequestMethod.GET)
	public @ResponseBody Result getNotAppUsers(
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK })Integer appId){
		try{
			List<User> list= userAppService.getNotAppUsers(appId);
			return Result.createSuccessResult().setData(list);
		}catch(Exception e){
			LOGGER.error("加载没有分配应用的人员列表时出现异常", e);
			return Result.createErrorResult().setMsg("加载没有分配应用的人员列表时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 设置应用人员
	 * @param appId
	 * @param userIds
	 * @return
	 */
	@RequestMapping(value = "/setAppUsers", method = RequestMethod.POST)
	public @ResponseBody Result setAppUsers(
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK }) Integer appId,
			@ValidateParam(name = "人员IDS ") String userIds) {
		try {
			List<Integer> idList = getAjaxIds(userIds);
			List<UserApp> list = new ArrayList<UserApp>();
			UserApp bean = null;
			for (Integer userId : idList) {
				bean = new UserApp();
				bean.setAppId(appId);
				bean.setUserId(userId);
				list.add(bean);
			}
			userAppService.setAppUsers(appId, list);
			return Result.createSuccessResult().setMsg("设置应用人员成功");
		} catch (Exception e) {
			LOGGER.error("设置应用人员时出现异常", e);
			return Result.createErrorResult().setMsg("设置应用人员时出现异常，请联系管理员");
		}
	}
	
	private List<App> getAppList(Integer userId) {
		List<App> list = appService.findByAll(null);
		for (App app : list) {
			UserApp userApp = userAppService.findByUserAppId(userId, app.getId());
			if (null != userApp) {
				app.setIsChecked(true);
			}
			else {
				app.setIsChecked(false);
			}
		}
		return list;
	}
}