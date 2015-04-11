<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
	<head>
	<title>ONS</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
	<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
	<link href="css/Cstyle.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/demos.css">
	<link rel="stylesheet" href="css/jquery.ui.all.css">
	<link rel="stylesheet" type="text/css" href="css/jquery-ui.css" />
	<link rel="stylesheet" href="test/css/style.css">
	<link rel="stylesheet" href="css/custom.css" type="text/css" />
	<link rel="stylesheet" type="text/css" href="css/jquery.multiselect.css" />
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=OseZYMkkn4lVf4VOEpNpX9DX"></script>
	<script src="js/jquery-1.10.2.js"></script>
	<script src="js/jquery.ui.core.js"></script>
	<script src="js/jquery.ui.widget.js"></script>
	<script src="js/jquery.ui.tabs.js"></script>
	<script src="js/jquery.ui.mouse.min.js"></script>
	<script src="js/jquery.ui.button.min.js"></script>
	<script src="js/jquery.ui.draggable.min.js"></script>
	<script src="js/jquery.ui.position.js"></script>
	<script src="js/jquery.ui.resizable.min.js"></script>
	<script src="js/jquery.ui.dialog.min.js"></script>
	<script type="text/javascript" src="js/jquery.multiselect.js"></script>
	<script type="text/javascript" src="js/jquery.multiselect.zh-cn.js"></script>
	<script type="text/javascript" SRC="js/administry.js"></script>
	<script type="text/javascript" SRC="js/json2.js"></script>
	<script type="text/javascript" src="js/jquery.blockUI.js"></script>
	<script src="js/superfish.js"></script>
	<script type="text/javascript" SRC="js/Myschedule.js"></script>
	
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
					<div class="text">
						<select id="select_box"> 
							<option value=0 selected>选择查询类型</option>
							<option value=1>查询订单编号</option>
							<option value=2>查询transcationID</option>
							<option value=3>查询商品编号</option>
						</select>
					</div> 
							
					<div class="text2"><input type="text"   id="order" onblur="if(this.value==''){this.value='请输入...';}" 
						onfocus="if(this.value=='请输入...'){this.value='';}" value="请输入...">
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
                    <li  class="current"><a href="schedule.jsp">调度服务</a></li>
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
							<!-- section -->
					<div id="tabs">
						<ul>
							<li><a href="#tabs-1">调度</a></li>
						</ul>	
							<div id="tabs-1">
										<form>
											<fieldset>
												<legend>请填写调度单</legend>
												
												<p>
													<label class="required">物资名称</label><br/>
													<input type="text" id="tabs1_item" class="half"  name="item"/>
												</p>
														
												<p>
													<label class="required">物资数量</label><br/>
													<input type="text" id="tabs1_quantity" class="half" name="quantity"/>
												</p>
												
												<p>
													<label class="required">收货仓库</label><br/>
													<select id="tabs1_des" class="half" multiple="multiple" size="3">
													</select>
												</p>
												
												<p>	
													<label class="required">发货仓库</label><br/>
												</p>
												<div class="box box-info" id="tabs1_origin">
													<p>暂无发货仓库信息</p>
												</div>	
										
												<p><input id="tabs1_route" type="button" class="btn btn-green" value="使用推荐路径"/> or 
												<a href="javascript: //;" onClick="$('#tabs1_form').slideDown(); return false;" class="btn">
												<span class="icon icon-add">&nbsp;</span>自定义</a>
											</p>				
										</fieldset>
									
									</form>
									
									<form id="tabs1_form" style="display:none">
										<div class="box">
											<p class="box box-info">中转仓库信息</p>
											<p>
												<label class="required">中转仓库:</label><br/>
												<select id="tabs1_mid" class="half" multiple="multiple" size="3">
													<optgroup label='第1号中转仓库'></optgroup>
													<optgroup label='第2号中转仓库'></optgroup>
												</select>
											</p>
											<p>
												<input  type="button" id="tabs1_custom" class="btn btn-red" value="调度"/>
											</p>
										</div>
									</form>
					</div>
					</div>
					
					<div id="dialog-message" title="订单调度信息">
					<p id="message-info">
					</p>
					</div>
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