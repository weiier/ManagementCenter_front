package com.map.dao;

import com.map.model.User;

public interface UserDao {
	public String addUser(User u);
	public User checkUser(String uname,String pw);
}
