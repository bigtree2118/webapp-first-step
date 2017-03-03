package com.fengmianyu.smart.coder.generate;

import java.util.HashMap;
import java.util.Map;

import com.fengmianyu.smart.coder.system.FreemarkerUtils;
import com.fengmianyu.smart.coder.system.StringUtils;



/**
 * Dao
 * 
 * @author Jack
 */
public class Dao {

	private Map<String, Object> dataMap;

	public Dao(String company, String project, String module, String model) {
		dataMap = new HashMap<String, Object>();
		/** 公司 **/
		dataMap.put("company", company);
		/** 项目 **/
		dataMap.put("project", project);
		/** 模块 **/
		if (StringUtils.isNotBlank(module))
			dataMap.put("module", module);
		/** 模型 **/
		dataMap.put("model", model);
	}
	
	public String getHtml(){
		return FreemarkerUtils.getText("dao.ftl", dataMap);
	}
}
