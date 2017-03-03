package com.fengmianyu.smart.sso.server.controller.admin;

import java.util.ArrayList;
import java.util.Date;
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
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.mvc.model.Result;
import com.fengmianyu.smart.mvc.validator.Validator;
import com.fengmianyu.smart.mvc.validator.annotation.ValidateParam;
import com.fengmianyu.smart.sso.server.model.App;
import com.fengmianyu.smart.sso.server.service.AppService;
import com.fengmianyu.smart.sso.server.service.impl.PermissionSubject;

/**
 * 应用管理
 * 
 * @author Joe
 */
@Controller
@RequestMapping("/admin/app")
public class AppController extends BaseController {
	private static final Logger LOGGER = LoggerFactory.getLogger(AppController.class);

	@Resource
	private AppService appService;

	@Resource
	private PermissionSubject permissionSubject;

	/**
	 * 进入查询界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "/list", method = RequestMethod.GET)
	public String gotoList() {
		return "/admin/app/app_list";
	}

	/**
	 * 查询应用
	 * 
	 * @param name:过滤条件-应用名称
	 * @param sort:排序字段
	 * @param order:排序方式
	 * @param pageNo:页码
	 * @param pageSize:每页显示条数
	 * @return
	 */
	@RequestMapping(value = "/load", method = RequestMethod.GET)
	public @ResponseBody Result load(@ValidateParam(name = "名称 ") String name, String sort, String order,
			@ValidateParam(name = "开始页码", validators = { Validator.NOT_BLANK }) Integer pageNo,
			@ValidateParam(name = "显示条数 ", validators = { Validator.NOT_BLANK }) Integer pageSize) {
		try {
			// 按查询条件：应用名称，分页查询应用
			Pagination<App> page = new Pagination<App>(pageNo, pageSize);
			page = appService.findPaginationByName(name, sort, order, page);
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
		return "/admin/app/app_add";
	}
	
	/**
	 * 进入编辑页面
	 * 
	 * @param id:应用ID
	 * @param model:数据模型
	 * @return
	 */
	@RequestMapping(value = "/goto_edit", method = RequestMethod.GET)
	public String gotoEdit(Model model, @ValidateParam(name = "应用id", validators = { Validator.NOT_BLANK }) Integer id) {
		try{
			App app = appService.get(id);
			model.addAttribute("app", app);
			return "/admin/app/app_edit";
		}catch(Exception e){
			return DEFAULT_ERROR_PAGE_URI;
		}
	}

	/**
	 * 保存
	 * @param id
	 * @param name
	 * @param code
	 * @param isEnable
	 * @param sort
	 * @return
	 */
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public @ResponseBody Result save(@ValidateParam(name = "ID") Integer id,
			@ValidateParam(name = "名称 ", validators = { Validator.NOT_BLANK }) String name,
			@ValidateParam(name = "应用编码 ", validators = { Validator.NOT_BLANK }) String code,
			@ValidateParam(name = "是否启用 ", validators = { Validator.NOT_BLANK }) Boolean isEnable,
			@ValidateParam(name = "排序 ", validators = { Validator.NOT_BLANK, Validator.INT }) Integer sort) {
		try{
			App app;
			if (id == null) {
				app = new App();
				app.setCreateTime(new Date());
			} else {
				app = appService.get(id);
			}
			app.setName(name);
			app.setCode(code);
			app.setSort(sort);
			app.setIsEnable(isEnable);
			appService.saveOrUpdate(app);
			return Result.createSuccessResult();
		}catch(Exception e){
			LOGGER.error("添加应用操作出现异常", e);
			return Result.createErrorResult().setMsg("添加操作出现异常，请联系管理员");
		}
	}
	
	/**
	 * 校验APP编码唯一性
	 * @param id
	 * @param code
	 * @return
	 */
	@RequestMapping(value = "/check", method = RequestMethod.POST)
	public @ResponseBody Result checkAppCode(@ValidateParam(name = "ID") Integer id,
			@ValidateParam(name = "应用编码 ", validators = { Validator.NOT_BLANK }) String code) {
		try{
			App app = appService.findByCode(code);
			Map<String, Object> checkResult = new HashMap<String, Object>();
			
			boolean valid = true;
			//新增时
			if(id == null && app != null){
				valid = false;
			}
			//编辑时
			else if(id != null && app != null && !app.getId().equals(id)){
				valid = false;
			}
			checkResult.put("valid", Boolean.valueOf(valid));
			
			return Result.createSuccessResult().setData(checkResult);
		}catch(Exception e){
			LOGGER.error("检查APP编码时出现异常", e);
			return Result.createErrorResult().setMsg("检查APP编码时出现异常，请联系管理员");
		}
	}


	/**
	 * 改变应用状态
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
			
			appService.enable(isEnable, idList);
			
			return Result.createSuccessResult();
		}catch(Exception e){
			LOGGER.error("更新应用状态时出现异常", e);
			return Result.createErrorResult().setMsg("更新应用状态时出现异常，请联系管理员");
		}
	}

	/**
	 * 删除应用
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public @ResponseBody Result delete(@ValidateParam(name = "id", validators = { Validator.NOT_BLANK }) Integer id) {
		try{
			List<Integer> idList = new ArrayList<Integer>();
			idList.add(id);
			
			int rows = appService.deleteById(idList);
			
			return Result.createSuccessResult().setData(rows);
		}catch(Exception e){
			LOGGER.error("删除应用时出现异常", e);
			return Result.createErrorResult().setMsg("删除应用时出现异常，请联系管理员");
		}
	}

	@RequestMapping(value = "/sync/permissions", method = RequestMethod.POST)
	public @ResponseBody Result syncPermissions(
			@ValidateParam(name = "应用编码集合", validators = { Validator.NOT_BLANK }) String code) {
		try {
			permissionSubject.update(code);
			return Result.createSuccessResult().setMsg("权限同步成功");
		} catch (Exception e) {
			LOGGER.error("同步权限时出现异常", e);
			return Result.createErrorResult().setMsg("同步权限时出现异常，请联系管理员");
		}
	}
}