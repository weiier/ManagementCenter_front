package com.map.dao.impl;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.text.ParseException;
import java.util.List;

import javax.annotation.Resource;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.stereotype.Component;
import com.map.dao.UserDao;
import com.map.model.User;
@Component("userDao")
public class UserDaoImpl implements UserDao{
	private HibernateTemplate hibernateTemplate;
	@Override
	public String addUser(User u) {
		 String message=null;
		 String result="[";
	     String urlName="";
	      try {
	          	urlName="http://10.103.241.20:8888/aspireRFIDonsTrackingService/register?uname="+u.getUsername()+"&&upw="
	      +u.getPassword();
	            URL U=new URL(urlName);
	            URLConnection connection=U.openConnection();
	            connection.connect();
	            BufferedReader in=new BufferedReader(new InputStreamReader(connection.getInputStream(),"UTF-8"));
	            String line;
	            while((line=in.readLine())!=null)
	            {
	                result+=line;
	            }
	                in.close();
	                result+="]";
	        }catch (Exception e) {
	                System.out.println();
	                System.out.println("����������ӷ����쳣����:"+e.toString());
	                System.out.println("���ӵ�ַ��:"+urlName);
	        }
	      try {
				JSONArray jsonArray = new JSONArray(result);
				JSONObject jsonJ = jsonArray.getJSONObject(0);
				message = jsonJ.getString(result);
				this.hibernateTemplate.save(u);
				
				/*if(jsonJ.getString("result").equals("username is already exits. ")){
					message = "���û�����ע��,������ע��";
				}else if(jsonJ.getString("result").equals("user added successfully. ")){
					message = "ע��ɹ�,���¼";
					this.hibernateTemplate.save(u);
				}else{
					message="ע�ᷢ���쳣������ϵ����Ա";
				}*/
			} catch (ParseException e) {
					e.printStackTrace();
			}
	        System.out.println(result);
	        return message;
	}

	@Override
	public User checkUser(String uname, String pw) {
		List<User> users = hibernateTemplate.find("from User u where u.username='" 
				+ uname + "' and u.password='" +pw+"'");
		if(users != null && users.size() > 0){
			return users.get(0);
		}
		return null;
	}

	public HibernateTemplate getHibernateTemplate() {
		return hibernateTemplate;
	}
	@Resource
	public void setHibernateTemplate(HibernateTemplate hibernateTemplate) {
		this.hibernateTemplate = hibernateTemplate;
	}
	
}
