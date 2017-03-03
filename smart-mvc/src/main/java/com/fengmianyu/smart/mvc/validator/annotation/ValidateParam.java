package com.fengmianyu.smart.mvc.validator.annotation;

import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

import com.fengmianyu.smart.mvc.validator.Validator;


/**
 * 自定义请求参数注解
 * 
 * @author Jack
 */
@Target(ElementType.PARAMETER)
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface ValidateParam {

	/**
	 * 验证器
	 * @return
	 */
	Validator[] validators() default {};
	
	/**
	 * 参数的描述名称
	 * @return
	 */
	String name() default "";
}

