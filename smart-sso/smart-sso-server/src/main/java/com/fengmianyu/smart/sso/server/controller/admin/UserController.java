package com.fengmianyu.smart.sso.server.controller.admin;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fengmianyu.smart.mvc.config.ConfigUtils;
import com.fengmianyu.smart.mvc.controller.BaseController;
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.provider.PasswordProvider;
import com.fengmianyu.smart.mvc.util.ContextHelper;
import com.fengmianyu.smart.mvc.validator.Validator;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.server.model.App;
import com.fengmianyu.smart.sso.server.model.User;
import com.fengmianyu.smart.sso.server.service.AppService;
import com.fengmianyu.smart.sso.server.service.RoleService;
import com.fengmianyu.smart.sso.server.service.UserRoleService;
import com.fengmianyu.smart.sso.server.service.UserService;
import com.fengmianyu.smart.util.StringUtils;


/**
 * 管理员管理
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/admin/user")
public class UserController extends BaseController {

	private static final Logger LOGGER = LoggerFactory.getLogger(UserController.class);
	
	@Resource
	private UserService userService;
	@Resource
	private AppService appService;
	@Resource
	private RoleService roleService;
	@Resource
	private UserRoleService userRoleService;

	/**
	 * 进入查询界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String gotoList(Model model) {
		model.addAttribute("appList", getAppList());
		return "/admin/user/user_list";
	}
	
	/**
	 * 查询应用
	 * 
	 * @param name:过滤条件-应用名称
	 * @param appId:应用id
	 * @param sort:排序字段
	 * @param order:排序方式
	 * @param pageNo:页码
	 * @param pageSize:每页显示条数
	 * @return
	 */
	@RequestMapping(value = "/load", method = RequestMethod.GET)
	public @ResponseBody Result load(@ValidateParam(name = "名称 ") String name, 
			@ValidateParam(name = "应用ID ") Integer appId,
			String sort, String order,
			@ValidateParam(name = "开始页码", validators = { Validator.NOT_BLANK }) Integer pageNo,
			@ValidateParam(name = "显示条数 ", validators = { Validator.NOT_BLANK }) Integer pageSize) {
		try {
			// 按查询条件：应用名称，分页查询应用
			Pagination<User> page = new Pagination<User>(pageNo, pageSize);
			page = userService.findPaginationByName(name,appId,sort, order, page);
			return Result.createSuccessResult().setData(page);
		} catch (Exception e) {
			LOGGER.error("查询应用操作出现异常", e);
			return Result.createErrorResult().setMsg("查询操作出现异常，请联系管理员");
		}
	}
	
	/**
	 * 进入新增界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/goto_add", method = RequestMethod.GET)
	public String gotoAdd() {
		return "/admin/user/user_add";
	}
	
	/**
	 * 进入编辑页面
	 * 
	 * @param id:人员ID
	 * @param model:数据模型
	 * @return
	 */
	@RequestMapping(value = "/goto_edit", method = RequestMethod.GET)
	public String gotoEdit(Model model, @ValidateParam(name = "人员id", validators = { Validator.NOT_BLANK }) Integer id) {
		try{
			User user = userService.get(id);
			model.addAttribute("user", user);
			return "/admin/user/user_edit";
		}catch(Exception e){
			return DEFAULT_ERROR_PAGE_URI;
		}
	}
	
	/**
	 * 校验user工号唯一性
	 * @param id
	 * @param jobNo
	 * @return
	 */
	@RequestMapping(value = "/checkjobNo", method = RequestMethod.POST)
	public @ResponseBody Result checkjobNo(@ValidateParam(name = "ID") Integer id,
			@ValidateParam(name = "工号 ", validators = { Validator.NOT_BLANK }) String jobNo) {
		try{
			User user = userService.findByJobNo(jobNo);
			Map<String, Object> checkResult = new HashMap<String, Object>();
			
			boolean valid = true;
			//新增时
			if(id == null && user != null){
				valid = false;
			}
			//编辑时
			else if(id != null && user != null && !user.getId().equals(id)){
				valid = false;
			}
			checkResult.put("valid", Boolean.valueOf(valid));
			
			return Result.createSuccessResult().setData(checkResult);
		}catch(Exception e){
			LOGGER.error("检查人员工号时出现异常", e);
			return Result.createErrorResult().setMsg("检查人员工号时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 校验user账号唯一性
	 * @param id
	 * @param account
	 * @return
	 */
	@RequestMapping(value = "/checkAccount", method = RequestMethod.POST)
	public @ResponseBody Result checkAccount(@ValidateParam(name = "ID") Integer id,
			@ValidateParam(name = "登录账号", validators = { Validator.NOT_BLANK }) String account) {
		try{
			User user = userService.findByAccount(account);
			Map<String, Object> checkResult = new HashMap<String, Object>();
			
			boolean valid = true;
			//新增时
			if(id == null && user != null){
				valid = false;
			}
			//编辑时
			else if(id != null && user != null && !user.getId().equals(id)){
				valid = false;
			}
			checkResult.put("valid", Boolean.valueOf(valid));
			
			return Result.createSuccessResult().setData(checkResult);
		}catch(Exception e){
			LOGGER.error("检查人员账号时出现异常", e);
			return Result.createErrorResult().setMsg("检查人员账号时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 保存
	 * @param request
	 * @param id
	 * @param jobNo
	 * @param orgId
	 * @param account
	 * @param password
	 * @param userName
	 * @param gender
	 * @param email
	 * @param cellPhone
	 * @param address
	 * @param isSys
	 * @param isEnable
	 * @return
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	@ResponseBody
	public Result save(HttpServletRequest  request,
			Integer id,
			@ValidateParam(name = "工号", validators = { Validator.NOT_BLANK }) String jobNo,
			Integer orgId,
			@ValidateParam(name = "登陆账号", validators = { Validator.NOT_BLANK }) String account,
			@ValidateParam(name = "密码 ") String password,
			@ValidateParam(name = "姓名", validators = { Validator.NOT_BLANK }) String userName,
			@ValidateParam(name = "性别", validators = { Validator.NOT_BLANK }) Integer gender,
			@ValidateParam(name = "邮箱", validators = { Validator.NOT_BLANK }) String email,
			@ValidateParam(name = "手机号码", validators = { Validator.NOT_BLANK }) String cellPhone,
			String address,
			@ValidateParam(name = "系统内置", validators = { Validator.NOT_BLANK }) Boolean isSys,
			@ValidateParam(name = "是否启用 ", validators = { Validator.NOT_BLANK }) Boolean isEnable
			) {
		try{
			User user;
			Date date=new Date();
			if (id == null) {
				user = new User();
				user.setCreateTimestamp(date);
				user.setCreateUserId(ContextHelper.getCurrentUserId());
			}else {
				user = userService.get(id);
			}
			user.setJobNo(jobNo);
			if(orgId!=null){
				user.setOrgId(orgId);
			}
			user.setAccount(account);
			user.setUserName(userName);
			user.setGender(gender);
			user.setEmail(email);
			user.setCellPhone(cellPhone);
			user.setAddress(address);
			user.setIsSys(isSys);
			user.setIsEnable(isEnable);
			
			user.setLastLoginTime(date);
			user.setLastChangeTimestamp(date);
			user.setChangeUserId(ContextHelper.getCurrentUserId());
			user.setLastLoginIp(request.getRemoteAddr());
			if (StringUtils.isNotBlank(password)) {
				user.setPassword(PasswordProvider.encrypt(password));
			}
			userService.saveOrUpdate(user);
			return Result.createSuccessResult();
		}catch(Exception e){
			LOGGER.error("添加人员操作出现异常", e);
			return Result.createErrorResult().setMsg("添加操作出现异常，请联系管理员");
		}
	}
	
	/**
	 * 改变人员状态
	 * @param id
	 * @param isEnable
	 * @return
	 */
	@RequestMapping(value = "/enable", method = RequestMethod.POST)
	public @ResponseBody Result enable(@ValidateParam(name = "id", validators = { Validator.NOT_BLANK }) Integer id,
			@ValidateParam(name = "是否启用 ", validators = { Validator.NOT_BLANK }) Boolean isEnable) {
		try{
			List<Integer> idList = new ArrayList<Integer>();
			idList.add(id);
			userService.enable(isEnable, idList);
			return Result.createSuccessResult();
		}catch(Exception e){
			LOGGER.error("更新人员状态时出现异常", e);
			return Result.createErrorResult().setMsg("更新人员状态时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 删除人员
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public @ResponseBody Result delete(@ValidateParam(name = "id", validators = { Validator.NOT_BLANK }) Integer id) {
		try{
			List<Integer> idList = new ArrayList<Integer>();
			idList.add(id);
			
			int rows = userService.deleteById(idList);
			
			return Result.createSuccessResult().setData(rows);
		}catch(Exception e){
			LOGGER.error("删除人员时出现异常", e);
			return Result.createErrorResult().setMsg("删除人员时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 重置密码
	 * @param ids
	 * @return
	 */
	@RequestMapping(value = "/resetPassword", method = RequestMethod.POST)
	public @ResponseBody Result resetPassword(
			@ValidateParam(name = "ids", validators = { Validator.NOT_BLANK }) String ids) {
		userService.resetPassword(PasswordProvider.encrypt(ConfigUtils.getProperty("system.init.password")), getAjaxIds(ids));
		return Result.createSuccessResult();
	}
	
	private List<App> getAppList() {
		return appService.findByAll(null);
	}
	
	/**
	 * 根据appId查询包含人员
	 * @param appId
	 * @param pageNo
	 * @param pageSize
	 * @return
	 */
	@RequestMapping(value = "/getAppUsers", method = RequestMethod.GET)
	public @ResponseBody Result getAppUsers(
			@ValidateParam(name = "应用ID ") Integer appId,
			@ValidateParam(name = "开始页码", validators = { Validator.NOT_BLANK }) Integer pageNo,
			@ValidateParam(name = "显示条数 ", validators = { Validator.NOT_BLANK }) Integer pageSize) {
		try {
			// 按查询条件：应用名称，分页查询应用
			Pagination<User> page = new Pagination<User>(pageNo, pageSize);
			page = userService.findPaginationByAccount(null,appId,page);
			return Result.createSuccessResult().setData(page);
		} catch (Exception e) {
			LOGGER.error("查询应用操作出现异常", e);
			return Result.createErrorResult().setMsg("查询操作出现异常，请联系管理员");
		}
	}
}