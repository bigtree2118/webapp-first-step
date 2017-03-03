package com.fengmianyu.smart.sso.server.dao;

import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.ibatis.annotations.Param;

import com.fengmianyu.smart.mvc.dao.Dao;
import com.fengmianyu.smart.mvc.model.Pagination;
import com.fengmianyu.smart.sso.server.model.App;


/**
 * 应用持久化接口
 * 
 * @author Jack
 */
public interface AppDao extends Dao<App, Integer> {
	
	public int enable(@Param("isEnable") Boolean isEnable, @Param("idList") List<Integer> idList);
	
	public List<App> findPaginationByName(@Param("name") String name, @Param("sort")String sort, @Param("order")String order, Pagination<App> p);
	
	public App findByCode(@Param("code") String code);
	
	public List<App> findByUserId(@Param("isEnable") Boolean isEnable, @Param("userId") Integer userId);
	
	public Set<String> findAppCodeByUserId(@Param("isEnable") Boolean isEnable, @Param("userId") Integer userId);
	
	public List<Map<String , Object>> findAppAllIdName();
}
