package com.map.action;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.text.ParseException;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Component;

import com.map.model.User;
import com.map.service.UserManager;
import com.opensymphony.xwork2.ActionSupport;
@Component
@Scope("prototype")
public class RegisterAction extends ActionSupport{
	private String username;
	private String password;
	private String email;
	private String message;
	private int company;
	private UserManager um;
	public String execute(){
		User u = new User();
		u.setEmail(email);
		u.setPassword(password);
		u.setUsername(username);
		u.setCompany(company);
		message = this.um.register(u);
		return "success";
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
	public UserManager getUm() {
		return um;
	}
	@Resource
	public void setUm(UserManager um) {
		this.um = um;
	}
	public int getCompany() {
		return company;
	}
	public void setCompany(int company) {
		this.company = company;
	}
	
}
