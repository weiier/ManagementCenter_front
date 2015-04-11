<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@taglib prefix="s" uri="/struts-tags"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>    
<!DOCTYPE html>
<html lang="en">
<head>
	<base href="<%=basePath%>">
  	<title>index</title>
  	<meta charset="utf-8">
    <script src="login/js/jquery-1.7.1.min.js"></script>

</head>
<body id="page1">
<s:debug></s:debug>
<input type="hidden" id="message" value="<s:property value="message"/>">
</body>
 <script type="text/javascript">
 	alert($("#message").val());
	parent.$.XYTipsWindow.removeBox(); 
	 
 </script>
</html>
