package com.fengmianyu.smart.sso.server.controller.admin;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fengmianyu.smart.mvc.controller.BaseController;
import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.util.ContextHelper;
import com.fengmianyu.smart.mvc.validator.Validator;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.server.model.App;
import com.fengmianyu.smart.sso.server.model.Permission;
import com.fengmianyu.smart.sso.server.service.AppService;
import com.fengmianyu.smart.sso.server.service.PermissionService;
import com.fengmianyu.smart.util.DateUtils;



/**
 * 权限管理(含菜单权限)
 * 
 * @author Jack
 */
@Controller
@RequestMapping("/admin/permission")
public class PermissionController extends BaseController {
	private static final Logger LOGGER = LoggerFactory.getLogger(PermissionController.class);
	
	@Resource
	private PermissionService permissionService;
	@Resource
	private AppService appService;

	/**
	 * 进入权限管理界面
	 * @param model
	 * @return
	 */
	@RequestMapping(value="/manage", method = RequestMethod.GET)
	public String gotoManage(Model model) {
		model.addAttribute("appList", getAppList());
		return "/admin/perm/perm_manage";
	}

	/**
	 * 加载权限树节点
	 * @param appId
	 * @param name
	 * @param isEnable
	 * @return
	 */
	@RequestMapping(value = "/nodes", method = RequestMethod.GET)
	public @ResponseBody Result getNodes(
			@ValidateParam(name = "应用ID ") Integer appId,
			@ValidateParam(name = "名称") String name,
			@ValidateParam(name = "是否启用 ") Boolean isEnable) {
		try{
			List<Permission> list = permissionService.findByName(name, appId, null, isEnable);
			return Result.createSuccessResult().setData(list);
		}catch(Exception e){
			LOGGER.error("加载权限树出现异常", e);
			return Result.createErrorResult();
		}
	}

	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public @ResponseBody Result save(@ValidateParam(name = "ID") Integer id,
			@ValidateParam(name = "应用ID", validators = { Validator.NOT_BLANK }) Integer appId,
			@ValidateParam(name = "父ID") Integer parentId,
			@ValidateParam(name = "名称", validators = { Validator.NOT_BLANK }) String name,
			@ValidateParam(name = "编号", validators = { Validator.NOT_BLANK }) String code,
			@ValidateParam(name = "图标") String icon,
			@ValidateParam(name = "权限URL") String url,
			@ValidateParam(name = "相关权限URL") List<String> relaUrls,
			@ValidateParam(name = "排序", validators = { Validator.NOT_BLANK }) Integer sort,
			@ValidateParam(name = "是否路径菜单", validators = { Validator.NOT_BLANK }) Boolean path_menu,
			@ValidateParam(name = "是否菜单", validators = { Validator.NOT_BLANK }) Boolean isMenu,
			@ValidateParam(name = "是否启用 ", validators = { Validator.NOT_BLANK }) Boolean isEnable,
			@ValidateParam(name = "备注说明 ") String remark	) {
		Permission permission;
		try{
			if (id == null) {
				permission = new Permission();
				permission.setAppId(appId);
				permission.setParentId(parentId);
				permission.setCreate_timestamp(DateUtils.getCurrentDate());
				permission.setCreate_user_id(ContextHelper.getCurrentUserId());
				permission.setLast_change_timestamp(DateUtils.getCurrentDate());
				permission.setChange_user_id(ContextHelper.getCurrentUserId());
			} else {
				permission = permissionService.get(id);
				permission.setLast_change_timestamp(DateUtils.getCurrentDate());
				permission.setChange_user_id(ContextHelper.getCurrentUserId());
			}
			permission.setCode(code);
			permission.setName(name);
			permission.setIcon(icon);
			permission.setUrl(url);
			
			if(relaUrls != null && relaUrls.size() > 0){
				//使用逗号分隔符，将相关权限URL拼接成一个字符串
				String rela_url = "";
				for(int i=0; i<relaUrls.size(); i++){
					if(i == 0){
						rela_url += relaUrls.get(i);
					}else{
						rela_url += ("," + relaUrls.get(i));
					}
				}
				permission.setRela_url(rela_url);
			}
			
			permission.setSort(sort);
			permission.setPath_menu(path_menu);
			permission.setIsMenu(isMenu);
			permission.setIsEnable(isEnable);
			permission.setRemark(remark);
			
			return Result.createSuccessResult(permissionService.saveOrUpdate(permission), "成功保存权限信息");
		}catch(Exception e){
			LOGGER.error("保存权限出现异常", e);
			return Result.createErrorResult().setMsg("保存权限出现异常，请联系管理员");
		}
	}
	
	/**
	 * 校验权限编号
	 * 在同一个应用中编码不能重复
	 * @param parentId
	 * @param id
	 * @param code
	 * @return
	 */
	@RequestMapping(value = "/check_code", method = RequestMethod.POST)
	public @ResponseBody Result checkCode(
			@ValidateParam(name="ID") Integer id, 
			@ValidateParam(name="应用ID", validators={ Validator.NOT_BLANK }) Integer appId, 
			@ValidateParam(name="父ID", validators={ Validator.NOT_BLANK }) Integer parentId, 
			@ValidateParam(name="编号", validators={ Validator.NOT_BLANK }) String code){
		try{
			List<Permission> list = permissionService.findByCode(code, appId, null);
			boolean valid = true;
			
			//新增时
			if(id == null && list != null && list.size() > 0){
				valid = false;
			}
			//编辑时
			else if(id != null && list != null && list.size() == 1 && !list.get(0).getId().equals(id)){
				valid = false;
			}
			
			Map<String, Object> checkResult = new HashMap<String, Object>();
			checkResult.put("valid", Boolean.valueOf(valid));
			
			
			return Result.createSuccessResult().setData(checkResult);
		}catch(Exception e){
			LOGGER.error("校验权限编码时出现异常", e);
			return Result.createErrorResult().setMsg("校校验权限编码时出现异常，请联系管理员");
		}
	}
	
	/**
	 * 校验权限名称
	 * 在同一个父节点下权限名称不能重复
	 * @param parentId
	 * @param id
	 * @param code
	 * @return
	 */
	@RequestMapping(value = "/check_name", method = RequestMethod.POST)
	public @ResponseBody Result checkName(
			@ValidateParam(name="ID") Integer id, 
			@ValidateParam(name="父ID", validators={ Validator.NOT_BLANK }) Integer parentId,
			@ValidateParam(name="名称", validators={ Validator.NOT_BLANK })String name){
		try{
			List<Permission> list = permissionService.findByName(name, null, parentId, null);
			boolean valid = true;
			
			//新增时
			if(id == null && list != null && list.size() > 0){
				valid = false;
			}
			//编辑时
			else if(id != null && list != null && list.size() == 1 && !list.get(0).getId().equals(id)){
				valid = false;
			}
			
			Map<String, Object> checkResult = new HashMap<String, Object>();
			checkResult.put("valid", Boolean.valueOf(valid));
			
			return Result.createSuccessResult().setData(checkResult);
		}catch(Exception e){
			LOGGER.error("校验权限名称时出现异常", e);
			return Result.createErrorResult().setMsg("校验权限名称时出现异常，请联系管理员");
		}
	}

	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public @ResponseBody Result delete(
			@ValidateParam(name = "id", validators = { Validator.NOT_BLANK }) Integer id,
			@ValidateParam(name = "应用ID", validators = { Validator.NOT_BLANK }) Integer appId) {
		try{
			return Result.createSuccessResult(permissionService.deletePermission(id, appId), "成功删除权限");
		}catch(Exception e){
			LOGGER.error("删除权限时出现异常", e);
			return Result.createErrorResult().setMsg("删除权限时出现异常，请联系管理员");
		}
		
	}

	private List<App> getAppList() {
		return appService.findByAll(null);
	}
}