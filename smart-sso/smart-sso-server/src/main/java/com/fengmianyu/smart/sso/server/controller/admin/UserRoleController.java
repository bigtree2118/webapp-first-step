package com.fengmianyu.smart.sso.server.controller.admin;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.CollectionUtils;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fengmianyu.smart.mvc.controller.BaseController;
import com.fengmianyu.smart.mvc.enums.TrueFalseEnum;
import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.validator.Validator;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.server.model.App;
import com.fengmianyu.smart.sso.server.model.Role;
import com.fengmianyu.smart.sso.server.model.UserRole;
import com.fengmianyu.smart.sso.server.service.AppService;
import com.fengmianyu.smart.sso.server.service.RoleService;
import com.fengmianyu.smart.sso.server.service.UserRoleService;


/**
 * 管理员角色分配管理
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/admin/userRole")
public class UserRoleController extends BaseController {
	private static final Logger LOGGER = LoggerFactory.getLogger(UserController.class);
	
	@Resource
	private AppService appService;
	@Resource
	private RoleService roleService;
	@Resource
	private UserRoleService userRoleService;

	@RequestMapping(value = "/allocate", method = RequestMethod.GET)
	public String edit(@ValidateParam(name = "管理员Id", validators = { Validator.NOT_BLANK }) Integer userId, Model model) {
		List<App> appList = appService.findByUserId(TrueFalseEnum.TRUE.getValue(), userId);
		model.addAttribute("userId", userId);
		model.addAttribute("appList", appList);
		model.addAttribute("roleList", getRoleList(userId, CollectionUtils.isEmpty(appList) ? null : appList.get(0).getId()));
		return "/admin/user/user_role";
	}
	
	@RequestMapping(value = "/change", method = RequestMethod.GET)
	public @ResponseBody Result changeApp(
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK }) Integer appId,
			@ValidateParam(name = "管理员ID", validators = { Validator.NOT_BLANK }) Integer userId) {
		return Result.createSuccessResult().setData(getRoleList(userId, appId));
	}

	@RequestMapping(value = "/allocateSave", method = RequestMethod.POST)
	public @ResponseBody Result allocateSave(
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK }) Integer appId,
			@ValidateParam(name = "管理员ID", validators = { Validator.NOT_BLANK }) Integer userId,
			@ValidateParam(name = "角色IDS ") String roleIds) {
		List<Integer> idList = getAjaxIds(roleIds);
		List<UserRole> list = new ArrayList<UserRole>();
		UserRole bean = null;
		for (Integer roleId : idList) {
			bean = new UserRole();
			bean.setAppId(appId);
			bean.setUserId(userId);
			bean.setRoleId(roleId);
			list.add(bean);
		}
		return Result.createSuccessResult(userRoleService.allocate(userId, appId, list), "授权成功");
	}
	
	/**
	 * 加载角色的人员列表
	 * @param roleId
	 * @return
	 */
	@RequestMapping(value = "/getRoleUsers", method = RequestMethod.GET)
	public @ResponseBody Result getRoleUsers(@ValidateParam(name = "角色ID ", validators = { Validator.NOT_BLANK })Integer roleId){
		try{
			return Result.createSuccessResult().setData(userRoleService.getRoleUsers(roleId));
		}catch(Exception e){
			LOGGER.error("加载角色的人员列表时出现异常", e);
			return Result.createErrorResult().setMsg("加载角色的人员列表时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 加载没有授权角色的人员列表
	 * @param roleId
	 * @return
	 */
	@RequestMapping(value = "/getNotRoleUsers", method = RequestMethod.GET)
	public @ResponseBody Result getNotRoleUsers(
			@ValidateParam(name = "角色ID ", validators = { Validator.NOT_BLANK })Integer roleId,
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK })Integer appId){
		try{
			return Result.createSuccessResult().setData(userRoleService.getNotRoleUsers(roleId, appId));
		}catch(Exception e){
			LOGGER.error("加载没有授权角色的人员列表时出现异常", e);
			return Result.createErrorResult().setMsg("加载没有授权角色的人员列表时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 进入角色用户界面
	 * @param roleId
	 * @param appId
	 * @return
	 */
	@RequestMapping(value = "/gotoRoleUser", method = RequestMethod.GET)
	public String gotoRoleUser(
			@ValidateParam(name = "角色ID ", validators = { Validator.NOT_BLANK })Integer roleId,
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK })Integer appId){
		return "/admin/role/role_user";
	}
	
	/**
	 * 设置角色人员
	 * @param appId
	 * @param roleId
	 * @param userIds
	 * @return
	 */
	@RequestMapping(value = "/setRoleUsers", method = RequestMethod.POST)
	public @ResponseBody Result setRoleUsers(
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK }) Integer appId,
			@ValidateParam(name = "角色ID", validators = { Validator.NOT_BLANK }) Integer roleId,
			@ValidateParam(name = "人员IDS ") String userIds) {
		try {
			List<Integer> idList = getAjaxIds(userIds);
			List<UserRole> list = new ArrayList<UserRole>();
			UserRole bean = null;
			for (Integer userId : idList) {
				bean = new UserRole();
				bean.setAppId(appId);
				bean.setUserId(userId);
				bean.setRoleId(roleId);
				list.add(bean);
			}
			userRoleService.setRoleUsers(roleId, appId, list);
			
			return Result.createSuccessResult().setMsg("设置角色人员成功");
		} catch (Exception e) {
			LOGGER.error("设置角色人员时出现异常", e);
			return Result.createErrorResult().setMsg("设置角色人员时出现异常，请联系管理员");
		}
	}

	private List<Role> getRoleList(Integer userId, Integer appId) {
		List<Role> list = roleService.findByAppId(TrueFalseEnum.TRUE.getValue(), appId);
		for (Role role : list) {
			UserRole userRole = userRoleService.findByUserRoleId(userId, role.getId());
			if (null != userRole) {
				role.setIsChecked(true);
			}
			else {
				role.setIsChecked(false);
			}
		}
		return list;
	}
}