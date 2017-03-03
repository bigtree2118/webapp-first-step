package com.fengmianyu.smart.sso.server.controller.admin;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.fengmianyu.smart.mvc.util.ContextHelper;
import com.fengmianyu.smart.mvc.validator.Validator;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.server.model.Permission;
import com.fengmianyu.smart.sso.server.model.Role;
import com.fengmianyu.smart.sso.server.model.RolePermission;
import com.fengmianyu.smart.sso.server.service.AppService;
import com.fengmianyu.smart.sso.server.service.PermissionService;
import com.fengmianyu.smart.sso.server.service.RolePermissionService;
import com.fengmianyu.smart.sso.server.service.RoleService;
import com.fengmianyu.smart.util.DateUtils;

/**
 * 角色管理
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/admin/role")
public class RoleController extends BaseController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(UserController.class);
	@Resource
	private RoleService roleService;
	@Resource
	private AppService appService;
	@Resource
	private RolePermissionService rolePermissionService;
	@Resource
	private PermissionService permissionService;
	
	@RequestMapping(value="list", method = RequestMethod.GET)
	public String execute(Model model) {
		try {
			model.addAttribute("apps", appService.findAppAllIdName());
			return "/admin/role/role_list";
		} catch (Exception e) {
			return DEFAULT_ERROR_PAGE_URI; 	
		}
	}

	/**
	 * 查找记录
	 * @param name
	 * @param appId
	 * @param isEnable
	 * @param sort
	 * @param order
	 * @param pageNo
	 * @param pageSize
	 * @return
	 */
	@RequestMapping(value = "/findList", method = RequestMethod.GET)
	public @ResponseBody Result list(@ValidateParam(name = "角色名") String name,
			@ValidateParam(name = "应用Id") Integer appId,
			Boolean isEnable,
			String sort , String order,
			@ValidateParam(name = "开始页码", validators = { Validator.NOT_BLANK }) Integer pageNo,
			@ValidateParam(name = "显示条数 ", validators = { Validator.NOT_BLANK }) Integer pageSize) {
		try {
			return Result.createSuccessResult().setData(roleService.findAllPagination(name, appId,isEnable ,sort,order, new Pagination<Role>(pageNo, pageSize)));
		} catch (Exception e) {
			LOGGER.error("查询角色列表操作出现异常", e);
			return Result.createErrorResult().setMsg("查询操作出现异常，请联系管理员");
		}
	}
	
	/**
	 * 进入新增界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/addRole", method = RequestMethod.GET)
	public String addRole(Model model) {
		try {
			List<Map<String , Object>> maps = appService.findAppAllIdName() ;
			model.addAttribute("apps",maps);
			return "/admin/role/role_add";
		} catch (Exception e) {
			return DEFAULT_ERROR_PAGE_URI ;
		}
	}
	
	/**
	 * 进入编辑页面
	 * 
	 * @param id:应用ID
	 * @param model:数据模型
	 * @return
	 */
	@RequestMapping(value = "/editRole", method = RequestMethod.GET)
	public String gotoEdit(Model model, @ValidateParam(name = "角色ID", validators = { Validator.NOT_BLANK }) Integer id) {
			try {
				Role role = roleService.findRoleAndAppNameById(id);
				model.addAttribute("role", role);
				return "/admin/role/role_edit";
			} catch (Exception e) {
				return DEFAULT_ERROR_PAGE_URI ;
			}
	}

	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public @ResponseBody Result save(@ValidateParam(name = "ID") Integer id,
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK }) Integer appId,
			@ValidateParam(name = "角色名", validators = { Validator.NOT_BLANK }) String name,
			@ValidateParam(name = "排序", validators = { Validator.NOT_BLANK }) Integer sort,
			@ValidateParam(name = "描述") String description,
			@ValidateParam(name = "系统内置") Boolean issys,
			@ValidateParam(name = "是否启用 ", validators = { Validator.NOT_BLANK }) Boolean isEnable) {
		try {
			Role role;
			if (id == null) {
				role = new Role();
				role.setCreate_user_id(ContextHelper.getCurrentUserId());
				role.setCreate_timestamp(DateUtils.getCurrentDate());
				role.setLast_change_timestamp(role.getCreate_timestamp());
				role.setChange_user_id(role.getCreate_user_id());
			}else {
				role = roleService.get(id);
				role.setChange_user_id(ContextHelper.getCurrentUserId());
				role.setLast_change_timestamp(new Date());
				role.setId(id);
			}
			role.setAppId(appId);
			role.setIssys(issys);
			role.setName(name);
			role.setSort(sort);
			role.setDescription(description);
			role.setIsEnable(isEnable);
			roleService.saveOrUpdate(role);
			return Result.createSuccessResult();
		} catch (Exception e) {
			LOGGER.error("添加角色操作出现异常", e);
			return Result.createErrorResult().setMsg("添加操作出现异常，请联系管理员");
		}
	}
	
	/**
	 * 查询角色拥有的权限
	 * @param roleId 角色ID
	 * @return
	 */
	@RequestMapping(value = "/allocate", method = RequestMethod.GET)
	public @ResponseBody Result allocate(
			@ValidateParam(name = "应用ID", validators = { Validator.NOT_BLANK }) Integer appId,
			@ValidateParam(name = "角色ID", validators = { Validator.NOT_BLANK }) Integer roleId) {
		try{
			List<Permission> permList = permissionService.findByCode(null, appId, true);
			List<RolePermission> rpermList = rolePermissionService.findByRoleId(roleId);
			
			Set<Integer> permIds = new HashSet<Integer>(rpermList.size());
			for(RolePermission rp : rpermList){
				permIds.add(rp.getPermissionId());
			}
			
			for(Permission p : permList){
				if(permIds.contains(p.getId())){
					p.setChecked(true);
				}else{
					p.setChecked(false);
				}
			}
			return Result.createSuccessResult().setData(permList);
		}catch(Exception e){
			LOGGER.error("查询角色拥有的权限时出现异常", e);
			return Result.createErrorResult().setMsg("查询角色拥有的权限时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 保存角色权限
	 * @param appId
	 * @param roleId
	 * @param permissionIds
	 * @return
	 */
	@RequestMapping(value = "/allocateSave", method = RequestMethod.POST)
	public @ResponseBody Result allocateSave(
			@ValidateParam(name = "应用ID ", validators = { Validator.NOT_BLANK }) Integer appId,
			@ValidateParam(name = "角色ID", validators = { Validator.NOT_BLANK }) Integer roleId,
			@ValidateParam(name = "权限IDS ") String permissionIds) {
		try {
			List<Integer> idList = getAjaxIds(permissionIds);
			List<RolePermission> list = new ArrayList<RolePermission>();
			Integer permissionId;
			for (Iterator<Integer> i$ = idList.iterator(); i$.hasNext(); list.add(new RolePermission(appId, roleId, permissionId))) {
				permissionId = i$.next();
			}
			return Result.createSuccessResult(rolePermissionService.allocate(roleId, list), "授权成功");
		} catch (Exception e) {
			LOGGER.error("保存角色权限时出现异常", e);
			return Result.createErrorResult().setMsg("保存角色权限时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 删除角色
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public @ResponseBody Result delete(@ValidateParam(name = "id", validators = { Validator.NOT_BLANK }) Integer id) {
		try{
			List<Integer> idList = new ArrayList<Integer>();
			idList.add(id);
			int rows = roleService.deleteById(idList);
			if(rows==-1){
				return Result.createErrorResult("", "不能删除系统内置角色！");
			}
			return Result.createSuccessResult().setData(rows).setMsg("操作成功：成功删除");
		}catch(Exception e){
			LOGGER.error("删除角色时出现异常", e);
			return Result.createErrorResult().setMsg("删除角色时出现异常，请联系管理员");
		}
	}
	/**
	 * 禁用/启用
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
			Result r = roleService.enable(isEnable, idList);
			return r;
		}catch(Exception e){
			LOGGER.error("更新角色状态时出现异常", e);
			return Result.createErrorResult().setMsg("更新角色状态时出现异常，请联系管理员");
		}
	}
}