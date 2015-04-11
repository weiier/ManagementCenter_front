<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
	<head>
	 <base href="<%=basePath%>">
	<title>ONS</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<link href="css/Cstyle.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/demos.css">
	<link rel="stylesheet" href="test/css/style.css">
	<link rel="stylesheet" href="css/custom.css" type="text/css" />
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=OseZYMkkn4lVf4VOEpNpX9DX"></script>
	<script type="text/javascript" src="js/jquery-1.10.2.js"></script>
	<script type="text/javascript" src="js/jquery.blockUI.js"></script>
	<script src="js/superfish.js"></script>
	<script type="text/javascript" src="js/Mysearch.js"></script>
	</head>
	<body id="page1">
		<div class="tail-bottom">
				<!-- HEADER -->
<header id="head">
    <div class="inner">
        <h1 class="logo"><a>ONS</a></h1>
        <div class="fright">
            <div class="header-meta">
                <div id="search-form">
					<div class="text"><input type="text" id="limit" onblur="if(this.value==''){this.value='输入数量下限';}" 
						onfocus="if(this.value=='输入数量下限'){this.value='';}" value="输入数量下限">
					</div>
						
					<div class="text2"><input type="text" id="keyword" onblur="if(this.value==''){this.value='键入关键字';}" 
						onfocus="if(this.value=='键入关键字'){this.value='';}" value="键入关键字">
					</div>
							 
					<div class="text">
						<select id="select_box"> 
							<option value=0 selected>选择仓库</option>
						</select>
					</div>
					<div class="btun"><input id="search" type='button' class='btn' value='搜索'/></div>
                </div>
                  <div class="col-elem">
                    <span class="phone">
                        欢迎您回来，${sessionScope.user.username}<br><a href="loginOutAction">注销</a>
                    </span>
                    <div class="user"><a href="factory.jsp">ONS</a></div>
                </div>
            </div>
             <nav>
                <ul class="sf-menu">
                    <li ><a href="factory.jsp">仓库查询</a></li>
                    <li  class="current"><a href="search.jsp">物资搜索</a></li>
                     <li><a href="schedule.jsp">调度服务</a></li>
                   <li><a href="order.jsp">物流服务</a>
                    	<ul>
                           <li><a href="trackingEPC.jsp">物流跟踪</a>
                            	<ul>
                                    <li><a href="tracking.jsp">跟踪订单</a></li>
                                    <li><a href="trackingEPC.jsp">跟踪trancation</a></li>
                                </ul>
                            </li>
                            <li><a href="order.jsp">订单物流</a></li>
                        </ul>
                      </li>
                    <li><a href="orderlog.jsp">历史服务</a>
                    	<ul>
                            <li><a href="log.jsp">历史日志</a></li>
                            <li><a href="orderlog.jsp">历史订单</a></li>
                        </ul>
                    </li>
                </ul>
            </nav>
        </div>
    </div>
</header>			
				<!-- CONTENT -->
				<div id="content">
					<div class="tail-right">
						<div class="wrapper">
							<div class="col-1">
							<hr>
								<p class="box box-info">仓库信息</p>	
								<div class="indent">
									<ul class="list" id="message">
									</ul>
								</div>
							</div>
							<div class="col-2" id="allmap">
							</div>
						</div>
					</div>
				</div>
				<!-- FOOTER -->
				<div id="footer">
					<div class="indent">
						<div class="fleft">Designed by: <img alt="KYL.com" src="images/logo.jpg" title="KYL.com - ONSTrackingSystem" />@KYL.com</div>
						<div class="fright">Copyright - 1.0 By Zhang</div>
					</div>
				</div>
			</div>
	</body>
	</html>