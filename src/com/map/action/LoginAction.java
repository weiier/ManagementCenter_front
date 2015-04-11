package com.map.action;
import java.util.Date;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.struts2.interceptor.SessionAware;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.map.model.User;
import com.map.service.UserManager;
import com.opensymphony.xwork2.ActionSupport;
@Component
@Scope("prototype")
public class LoginAction extends ActionSupport implements SessionAware{
	private String uname;
	private String upw;
	private UserManager um;
	private Map<String,Object> session;

	public String execute(){
		User u = new User();
		if(um.check(uname, upw)!=null){
			u=um.check(uname, upw);
			session.clear();
			session.put("user",u);
			System.out.println(session);
			return "success";
		}else{
			return "fail";
		}
	}
	
	public String getUname() {
		return uname;
	}
	public void setUname(String uname) {
		this.uname = uname;
	}
	public UserManager getUm() {
		return um;
	}
	@Resource
	public void setUm(UserManager um) {
		this.um = um;
	}

	public String getUpw() {
		return upw;
	}
	public void setUpw(String upw) {
		this.upw = upw;
	}

	public Map<String, Object> getSession() {
		return session;
	}

	public void setSession(Map<String, Object> session) {
		this.session = session;
	}
}
