package com.map.util;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class SecurityFilter implements Filter{
	@Override
	public void destroy() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain chain) throws IOException, ServletException {
			HttpServletRequest req = (HttpServletRequest)request;
			HttpServletResponse res = (HttpServletResponse) response;
			HttpSession session = req.getSession();
			String path = req.getServletPath();
			System.out.println(path);
			System.out.println(session.getAttribute("user"));
		if(!"/login.html".equals(path)&&!"/reg.html".equals(path)&&!"/redirect.jsp".equals(path)){
				if(session.getAttribute("user")!=null){
					chain.doFilter(request, response);
				}else{
					res.sendRedirect("login.html");
				}
			}else{
				chain.doFilter(request, response);
			}
	}
	
	@Override
	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub
		
	}

}
