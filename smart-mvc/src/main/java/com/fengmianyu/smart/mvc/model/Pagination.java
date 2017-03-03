package com.fengmianyu.smart.mvc.model;

import java.io.Serializable;
import java.util.List;


/**
 * 分页包含列表list属性基类
 * 
 * @author Jack
 */
public class Pagination<T> extends PaginationSupport implements Serializable {
	
	private static final long serialVersionUID = 7002501955628078021L;
	/** 当前页的数据 */
	private List<T> list;

	public Pagination() {
	}


	public Pagination(int pageNo, int pageSize) {
		super(pageNo, pageSize);
	}
	
	public Pagination(int pageNo, int pageSize, String sort, String order) {
		super(pageNo, pageSize, sort, order);
	}

	/**
	 * 获得分页内容
	 * 
	 * @return
	 */
	public List<T> getList() {
		return list;
	}

	/**
	 * 设置分页内容
	 * 
	 * @param list
	 */
	public void setList(List<T> list) {
		this.list = list;
	}
}
