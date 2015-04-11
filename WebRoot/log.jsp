<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
	<head>
	 <base href="<%=basePath%>">
	<title>ons</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
	<link href="css/Cstyle.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/demos.css">
	<link rel="stylesheet" href="css/demo_table.css">
	<link rel="stylesheet" href="css/jquery.ui.all.css">
	<link rel="stylesheet" href="test/css/style.css">
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=OseZYMkkn4lVf4VOEpNpX9DX"></script>
	
	<script src="js/jquery-1.10.2.js"></script>
	<script src="js/jquery.ui.core.js"></script>
	<script src="js/jquery.ui.datepicker.js"></script>
	<script src="js/jquery.dataTables.js"></script>
	<script src="js/superfish.js"></script>
	<script src="js/Mylog.js"></script>
	
	</head>
	<body id="page1">
		<div class="tail-bottom">
<!-- Header -->
<header id="head">
    <div class="inner">
        <h1 class="logo"><a>ONS</a></h1>
        <div class="fright">
            <div class="header-meta">
                <div id="search-form">
					<div class="text"><input type="text"  id="start" onblur="if(this.value==''){this.value='起始时间';this.style.color='#aaa';}" 
						onfocus="if(this.value=='起始时间'){this.value='';this.style.color='#666';}" value="起始时间">
					</div>
					
					<div class="text"><input type="text"   id="end" onblur="if(this.value==''){this.value='结束时间';this.style.color='#aaa';}" 
						onfocus="if(this.value=='结束时间'){this.value='';this.style.color='#666';}" value="结束时间">
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
                    <li><a href="search.jsp">物资搜索</a></li>
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
                    <li class="current"><a href="orderlog.jsp">历史服务</a>
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
			<!-- section -->
				<section>					
					<table class="display stylized" id="example">
						<thead>
							<tr>
								<th  class="center">编号</th>
								<th  class="center">所属仓库</th>
								<th  class="center">状态</th>
								<th  class="center">日志时间</th>
								<th  class="center">操作</th>
							</tr>
						</thead>
						<tbody id="tbody">
						</tbody>
						<tfoot>
							<tr>
								<th  class="center">编号</th>
								<th  class="center">所属仓库</th>
								<th  class="center">状态</th>
								<th  class="center">日志时间</th>
								<th  class="center">操作</th>
							</tr>
						</tfoot>
					</table>				
				</section>
				<!-- End of Left column/section -->
				
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