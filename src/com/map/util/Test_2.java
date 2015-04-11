package com.map.util;

public class Test_2 {
	Test_2(String name,String wd){
		this.name=name;
		this.wd=wd;
	}
	private String name;
	private String wd;
	
public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getWd() {
		return wd;
	}

	public void setWd(String wd) {
		this.wd = wd;
	}
	
	public static void main(String args[]){
		Test_2 a = new Test_2("zhang","1123");
		System.out.println(a.getName());
		Test_2 b = a;
		b.setName("wang");
		System.out.println(a.getName());
	}

}


