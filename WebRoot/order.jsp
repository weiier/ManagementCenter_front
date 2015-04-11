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
	<link href="css/Cstyle.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/demos.css">
	<link rel="stylesheet" href="css/demo_table.css">
	<link rel="stylesheet" href="css/jquery.ui.all.css">
	<link rel="stylesheet" href="test/css/style.css">
	<link rel="stylesheet" href="css/custom.css" type="text/css" />
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=OseZYMkkn4lVf4VOEpNpX9DX"></script>
	<script src="js/jquery-1.10.2.js"></script>
	<script src="js/jquery.ui.core.js"></script>
	<script src="js/jquery.ui.datepicker.js"></script>
	<script src="js/jquery.ui.widget.js"></script>
	<script src="js/jquery.ui.tabs.js"></script>
	<script src="js/superfish.js"></script>
	<script type="text/javascript" SRC="js/administry.js"></script>
	<script type="text/javascript">
$(document).ready(function(){		
	//载入地图
	var map = new BMap.Map("allmap");
	var point = new BMap.Point(108.56,39.45);
	map.centerAndZoom(point,5);
	map.enableScrollWheelZoom();
	map.addControl(new BMap.NavigationControl());
	map.addControl(new BMap.OverviewMapControl());
	map.addControl(new BMap.MapTypeControl());
	map.setCurrentCity("北京");
	
	$('nav').superfish({
		//useClick: true
	});
	
	//插入日历
	$( "#start" ).datepicker({
		showOn: "button",
		buttonImage: "img/calendar.gif",
		prevText:"上个月",   
        nextText:"下个月",
		buttonImageOnly: true,
		dateFormat:"yy-mm-dd",
	});
	$( "#end" ).datepicker({
		showOn: "button",
		buttonImage: "img/calendar.gif",
		buttonImageOnly: true,
		dateFormat:"yy-mm-dd",
	});
	
	var strID = <%=request.getParameter("id")%>;
	//取出订单
	if(strID!=null){
		$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!show?callback=?&&id="+strID,function(data){
			$.each(data.orders,function(i,value){
				if(value.state==1){
					$("#tabs-1").append("<div class='content-box corners content-box-closed'><header><h3><img SRC='img/accept.png' />订单编号："+value.id+
					"&nbsp;&nbsp;&nbsp;物资："+value.itemName+"&nbsp;&nbsp;&nbsp;数量："+value.itemQuantity+
					"</h3></header><section><table class='no-style full'><tbody id='order_tabs_"+i+"'></tbody></table></section></div>");
					var num=0;
					$.each(value.details,function(j,val){
						var Str = "";
						num++;
						if(val.arrivedState==0){
							Str = "待发货";
						}else if(val.arrivedState==1){
							Str = "已发货";
						}else if(val.arrivedState==2){
							Str = "待收货";
						}else if(val.arrivedState==3){
							Str = "已收货";
						}
						$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
							"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
					});
					$("#order_tabs_"+i).append("<tr><td><input id='"+i+"_"+num+"' type='button' class='btn' value='查看路径'/> </td>"+
					"<td><a href='tracking.jsp?id="+value.id+"'><input type='button' class='btn btn-green' value='跟踪'></a>");
					
				}else{
					$("#tabs-2").append("<div class='content-box corners content-box-closed'><header><h3><img SRC='img/information.png' />订单编号："+value.id+
							"&nbsp;&nbsp;&nbsp;物资："+value.itemName+"&nbsp;&nbsp;&nbsp;数量："+value.itemQuantity+
							"</h3></header><section><table class='no-style full'><tbody id='order_tabs_"+i+"'></tbody></table></section></div>");
					var num=0;
							$.each(value.details,function(j,val){
								var Str = "";
								num++;
								if(val.arrivedState==-1){
									Str = "未响应";
								}else if(val.arrivedState==0){
									Str = "待发货";
								}else if(val.arrivedState==1){
									Str = "已发货";
								}else if(val.arrivedState==2){
									Str = "待收货";
								}else if(val.arrivedState==3){
									Str = "已收货";
								}
								$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
										"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
							});
							$("#order_tabs_"+i).append("<tr><td><input id='"+i+"_"+num+"' type='button' class='btn' value='查看路径'/> </td>"+
									"<td><a href='tracking.jsp?id="+value.id+"'><input type='button' class='btn btn-green' value='跟踪'></a>");
					}
			});
			$(".btn").click(function(){
				map.clearOverlays();
				var str=$(this).attr("id").split("_");
				var points = [];		
				for(var b=0; b<str[1];b++){
					var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
						   anchor: new BMap.Size(10, 25),                  // 指定定位位置   
						   imageOffset: new BMap.Size(0, 0 - b * 25)   // 设置图片偏移   
						 });   
						 
					var str1=$("#location_"+str[0]+"_"+b).html().split(":");
					var ppoint = new BMap.Point(str1[0],str1[1]);
					points.push(ppoint);
					var marker = new BMap.Marker(ppoint, {icon: myIcon}); 
					map.addOverlay(marker);
				}
				var polyline = new BMap.Polyline(points, {strokeColor:"blue", strokeWeight:2, strokeOpacity:0.7});  
				map.addOverlay(polyline); 
			});
			//初始化conten box	
			Administry.setup();
		});
	}
	
	//加载tab
	$( "#tabs" ).tabs();

		//订单搜索
		$(".btun").click(function(){
			var start = null;
			var id = null;
			var end = null;
			if($("#order").val()!="请输入订单编号"){
				id = $("#order").val();
			}
			if($("#start").val()!="起始时间"){
				start = $("#start").val();
			}
			if($("#end").val()!="结束时间"){
				end = $("#end").val();
			}
			
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!search?callback=?&&id="+id+"&&start="+start+"&&end="+end,function(data){
				$("#tabs-1").html("");
				$("#tabs-2").html("");
				$.each(data.orders,function(i,value){
					if(value.state==1){
						$("#tabs-1").append("<div class='content-box corners content-box-closed'><header><h3><img SRC='img/accept.png' />订单编号："+value.id+
						"&nbsp;&nbsp;&nbsp;物资："+value.itemName+"&nbsp;&nbsp;&nbsp;数量："+value.itemQuantity+
						"</h3></header><section><table class='no-style full'><tbody id='order_tabs_"+i+"'></tbody></table></section></div>");
						var num=0;
						$.each(value.details,function(j,val){
							var Str = "";
							num++;
							if(val.arrivedState==0){
								Str = "待发货";
							}else if(val.arrivedState==1){
								Str = "已发货";
							}else if(val.arrivedState==2){
								Str = "待收货";
							}else if(val.arrivedState==3){
								Str = "已收货";
							}
							$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
								"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
						});
						$("#order_tabs_"+i).append("<tr><td><input id='"+i+"_"+num+"' type='button' class='btn' value='查看路径'/> </td>"+
								"<td><a href='tracking.jsp?id="+value.id+"'><input type='button' class='btn btn-green' value='跟踪'></a>");
					}else{
						$("#tabs-2").append("<div class='content-box corners content-box-closed'><header><h3><img SRC='img/information.png' />订单编号："+value.id+
								"&nbsp;&nbsp;&nbsp;物资："+value.itemName+"&nbsp;&nbsp;&nbsp;数量："+value.itemQuantity+
								"</h3></header><section><table class='no-style full'><tbody id='order_tabs_"+i+"'></tbody></table></section></div>");
						var num=0;
								$.each(value.details,function(j,val){
									var Str = "";
									num++;
									if(val.arrivedState==-1){
										Str = "未响应";
									}else if(val.arrivedState==0){
										Str = "待发货";
									}else if(val.arrivedState==1){
										Str = "已发货";
									}else if(val.arrivedState==2){
										Str = "待收货";
									}else if(val.arrivedState==3){
										Str = "已收货";
									}
									$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
											"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
								});
								$("#order_tabs_"+i).append("<tr><td><input id='"+i+"_"+num+"' type='button' class='btn' value='查看路径'/> </td>"+
										"<td><a href='tracking.jsp?id="+value.id+"'><input type='button' class='btn btn-green' value='跟踪'></a>");
						}
				});
				$(".btn").click(function(){
					map.clearOverlays();
					var str=$(this).attr("id").split("_");
					var points = [];		
					for(var b=0; b<str[1];b++){
						var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
							   anchor: new BMap.Size(10, 25),                  // 指定定位位置   
							   imageOffset: new BMap.Size(0, 0 - b * 25)   // 设置图片偏移   
							 });   
							 
						var str1=$("#location_"+str[0]+"_"+b).html().split(":");
						var ppoint = new BMap.Point(str1[0],str1[1]);
						points.push(ppoint);
						var marker = new BMap.Marker(ppoint, {icon: myIcon}); 
						map.addOverlay(marker);
					}
					var polyline = new BMap.Polyline(points, {strokeColor:"blue", strokeWeight:2, strokeOpacity:0.7});  
					map.addOverlay(polyline); 
				});
				//初始化conten box	
				Administry.setup();
			});
		});
			
});
	</script>
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
					<div class="text"><input type="text"  id="start" onblur="if(this.value==''){this.value='起始时间';}" 
						onfocus="if(this.value=='起始时间'){this.value='';}" value="起始时间">
					</div>
					
					<div class="text"><input type="text"   id="end" onblur="if(this.value==''){this.value='结束时间';}" 
						onfocus="if(this.value=='结束时间'){this.value='';}" value="结束时间">
					</div>
							
					<div class="text2"><input type="text"   id="order" onblur="if(this.value==''){this.value='请输入订单编号';}" 
						onfocus="if(this.value=='请输入订单编号'){this.value='';}" value="请输入订单编号">
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
                   <li class="current"><a href="order.jsp">物流服务</a>
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
		<li><a href="#tabs-1">已完成订单</a></li>
		<li><a href="#tabs-2">未完成订单</a></li>
	</ul>
	<div id="tabs-1">		
	</div>

	<div id="tabs-2">			
	</div>
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