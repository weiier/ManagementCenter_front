package com.map.service;

import javax.annotation.Resource;

import org.springframework.stereotype.Component;

import com.map.dao.UserDao;
import com.map.model.User;
@Component
public class UserManager {
	private UserDao userDao;
	
	public User check(String uname,String pw){
		return this.userDao.checkUser(uname, pw);
	}
	
	public String register(User u){
		return this.userDao.addUser(u);
	}
	
	public UserDao getUserDao() {
		return userDao;
	}
	@Resource
	public void setUserDao(UserDao userDao) {
		this.userDao = userDao;
	}
	
}
