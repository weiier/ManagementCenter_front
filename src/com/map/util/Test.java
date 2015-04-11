package com.map.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;
import java.text.ParseException;
import org.json.JSONArray;
import org.json.JSONObject;

public class Test {
	public static String stringSendGet(String url,String uname,String pw)
    {
        String result="[";
        String urlName="";
      try {
          	urlName=url+"?uname="+uname+"&&upw="+pw;
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
                System.out.println("与服务器连接发生异常错误:"+e.toString());
                System.out.println("连接地址是:"+urlName);
        }
      
      
      try {
			JSONArray jsonArray = new JSONArray(result);
			for(int i=0; i<jsonArray.length();i++){
				JSONObject jsonJ = jsonArray.getJSONObject(i);
				System.out.println(jsonJ.getString("result")+jsonJ.getString("uname"));
			}
		} catch (ParseException e) {
				e.printStackTrace();
		}
      
      
        System.out.println(result);
        return result;
      }
       
      public static void main(String[] args){
          Test.stringSendGet("http://10.103.241.20:8888/aspireRFIDonsTrackingService/register","admin","test");
      }
}
