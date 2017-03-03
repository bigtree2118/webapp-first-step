package com.fengmianyu.smart.mvc.util;

/**
 * 缓存接口
 * 
 * @author Jack
 */
public interface CacheConfig {

	/**
	 * 获取缓存数据
	 * 
	 * @param cacheName
	 * @param key
	 * @return
	 */
	public Object getCache(String cacheName, String key);

	/**
	 * 插入缓存数据
	 * 
	 * @param cacheName
	 * @param key
	 * @return
	 */
	public void putCache(String cacheName, String key, Object object);

}