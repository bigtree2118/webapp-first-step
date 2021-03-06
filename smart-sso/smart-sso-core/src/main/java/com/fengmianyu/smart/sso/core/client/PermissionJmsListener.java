package com.fengmianyu.smart.sso.core.client;

import javax.jms.JMSException;
import javax.jms.Message;
import javax.jms.MessageListener;
import javax.jms.TextMessage;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;

import com.fengmianyu.smart.mvc.config.ConfigUtils;


/**
 * 权限变更消息监听
 * 
 * @author Jack
 */
public class PermissionJmsListener implements MessageListener {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(PermissionJmsListener.class);
	
	@Autowired
	private SsoRealm ssoRealm;

	@Override
	public void onMessage(Message message) {
		String appCode = null;
		try {
			appCode = ((TextMessage) message).getText();
		}
		catch (JMSException e) {
			LOGGER.error("Jms illegal message!");
		}

		if (ConfigUtils.getProperty("app.code").equals(appCode)) {
			ssoRealm.clearApplicationPermissions();
			ssoRealm.clearAllCachedAuthorizationInfo();
			LOGGER.info("成功通知appCode为：{}的应用更新权限！", appCode);
		}
	}
}
