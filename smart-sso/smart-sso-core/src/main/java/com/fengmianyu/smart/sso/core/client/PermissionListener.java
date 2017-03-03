package com.fengmianyu.smart.sso.core.client;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.http.HttpSessionEvent;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.util.StringUtils;

import com.fengmianyu.smart.mvc.config.ConfigUtils;
import com.fengmianyu.smart.mvc.util.SpringUtils;
import com.fengmianyu.smart.sso.core.rpc.AuthenticationRpcService;
import com.fengmianyu.smart.sso.core.rpc.Menu;
import com.fengmianyu.smart.sso.core.rpc.Permissionable;



/**
 * 权限初始化
 * 
 * @author Jack
 */
public class PermissionListener implements ServletContextListener{
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PermissionListener.class);

	@Override
	public void contextDestroyed(ServletContextEvent sce) {
	}

	@Override
	public void contextInitialized(ServletContextEvent event) {
		ServletContext servletContext = (ServletContext) event.getServletContext();
		initApplicationPermissions(servletContext);
	}

	/**
	 * 应用初始化，获取应用所有的菜单及权限
	 * @param servletContext
	 */
	public static void initApplicationPermissions(ServletContext servletContext) {
		AuthenticationRpcService authenticationRpcService = SpringUtils.getBean(AuthenticationRpcService.class);
		List<Menu> dbList = null;
		try {
			dbList = authenticationRpcService.findPermissionList(null, ConfigUtils.getProperty("app.code"));
		}
		catch (Exception e) {
			dbList = new ArrayList<Menu>(0);
			LOGGER.error("无法连接到单点登录鉴权系统,请检查service.properties中sso.local.url配置", e);
		}
		List<Menu> menuList = new ArrayList<Menu>();
		Set<String> operateSet = new HashSet<String>();
		for (Menu menu : dbList) {
			if (menu.getIsMenu()) {
				menuList.add(menu);
			}
			if (!StringUtils.isEmpty(menu.getUrl())) {
				operateSet.add(menu.getUrl());
			}
			//将目录菜单或按钮的相关url添加到应用权限集合中
			if (!StringUtils.isEmpty(menu.getRela_url())){
				String [] rus = menu.getRela_url().split(",");
				for(int i=0, l=rus.length; i<l; i++){
					operateSet.add(rus[i]);
				}
			}
		}
		servletContext.setAttribute(Permissionable.APPLICATION_MENU, menuList);
		servletContext.setAttribute(Permissionable.APPLICATION_PERMISSION, operateSet);
	}

	public void sessionDestroyed(HttpSessionEvent arg0) {
	}
}
