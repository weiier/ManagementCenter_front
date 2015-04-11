package com.map.util;

import java.util.ArrayList;
import java.util.List;

public class TestInteger {
	public static void main(String args[]){
		List<Integer> list = new ArrayList<Integer>();
		list.add(1);
		list.add(3);
		list.add(133);
		System.out.println(list.toString());
		String str = "";
		for (int i =0;i<list.size();i++){
			if(i!=list.size()-1)str+=list.get(i)+",";
			else str+=list.get(i);
		}
		System.out.println(str);
		String liststr[] = str.split(",");
		for (String s:liststr){
			System.out.println(Integer.parseInt(s));
		}
	}
}
