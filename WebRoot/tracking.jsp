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
	<script src="js/jquery.ui.mouse.min.js"></script>
	<script src="js/jquery.ui.button.min.js"></script>
	<script src="js/jquery.ui.draggable.min.js"></script>
	<script src="js/jquery.ui.position.js"></script>
	<script src="js/jquery.ui.resizable.min.js"></script>
	<script src="js/jquery.ui.dialog.min.js"></script>
	<script src="js/superfish.js"></script>
	
	<script type="text/javascript">
	function changeOrder(id){
		if(id!=null){
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!show?callback=?&&id="+id,function(data){
				if(data.orders[0].state==1){
					var info="订单编号："+data.orders[0].id+"&nbsp;&nbsp;物资："+data.orders[0].itemName+"&nbsp;&nbsp;数量："
					+data.orders[0].itemQuantity+"&nbsp;&nbsp;状态：完成";
					$("#boxinfo").addClass("box-success").html(info);
				}
				var flag=0;
				$.each(data.orders[0].details,function(i,value){
						if(value.eventTime!=$("#"+value.id).text()){
							$("#message-info").html("");
							var showStr=null;
							if(value.arrivedState==1){
								showStr = "已发货";
							}else if(value.arrivedState==3){
								showStr = "已收货";
							}else if(value.arrivedState==-1){
								showStr="未响应";
							}else if(value.arrivedState==0){
								showStr="待发货";
							}
							$("#message-info").append("仓库"+value.factory.name+" <b>"+showStr+"</b>.");
							$( "#dialog-message" ).dialog( "open" );	
							flag=1;	
						}
				});
				if(flag!=0){
					$("#table-track").html("");
					$.each(data.orders[0].details,function(i,value){
						var arrStr = "";
						if(value.arrivedState==0){
							arrStr = "待发货";
						}else if(value.arrivedState==1){
							arrStr = "发货";
						}else if(value.arrivedState==2){
							arrStr = "待收货";
						}else if(value.arrivedState==3){
							arrStr = "收货";
						}else if(value.arrivedState==-1){
							arrStr="未响应";
						}
						var facStr = "";
						if(value.factoryDetail==0){
							facStr = "发货仓库";
						}else if(value.factoryDetail==1){
							facStr = "中转仓库";
						}else if(value.factoryDetail==-1){
							facStr = "收货仓库";
						}
						$("#table-track").append("<tr><td>"+value.id+"</td><td>"+value.factory.name+"</td><td>"+facStr+"</td><td>"
						+arrStr+"</td><td id='"+value.id+"'>"+value.eventTime+"</td><td id='location_"+i+
						"' style='display:none'>"+value.factory.location+"</td></tr>");
					});
				}
			});
		}
	}
	
$(document).ready(function(){		
	//用于定时查询当前订单的消息
	var orderID=null;
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
	//对话框
	$( "#dialog-message" ).dialog({
		autoOpen: false,
		modal: true,
		buttons: {
			Ok: function() {
				$(this).dialog( "close" );
			}
		}
	});
	
	function showOrder(id){
		$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!show?callback=?&&id="+id,function(data){
			$("#table-track").html("");
			$("#boxinfo").removeClass().addClass("box").html("请查询订单");
			$.each(data.orders,function(i,value){
				if(value.state==1){
					var info="订单编号："+value.id+"&nbsp;&nbsp;物资："+value.itemName+"&nbsp;&nbsp;数量："
					+value.itemQuantity+"&nbsp;&nbsp;状态：完成";
					$("#boxinfo").addClass("box-success").html(info);
				}else{
					var info="订单编号："+value.id+"&nbsp;&nbsp;物资："+value.itemName+"&nbsp;&nbsp;数量："
					+value.itemQuantity+"&nbsp;&nbsp;状态：未完成";
					$("#boxinfo").addClass("box-error").html(info);
				}
					var num=0;
					$.each(value.details,function(j,val){
						num++;
						var arrStr = "";
						if(val.arrivedState==0){
							arrStr = "待发货";
						}else if(val.arrivedState==1){
							arrStr = "发货";
						}else if(val.arrivedState==2){
							arrStr = "待收货";
						}else if(val.arrivedState==3){
							arrStr = "收货";
						}else if(val.arrivedState==-1){
							arrStr="未响应";
						}
						var facStr = "";
						if(val.factoryDetail==0){
							facStr = "发货仓库";
						}else if(val.factoryDetail==1){
							facStr = "中转仓库";
						}else if(val.factoryDetail==-1){
							facStr = "收货仓库";
						}
						$("#table-track").append("<tr><td>"+val.id+"</td><td>"+val.factory.name+"</td><td>"+facStr+"</td><td>"
						+arrStr+"</td><td id='"+val.id+"'>"+val.eventTime+"</td><td id='location_"+j+
						"' style='display:none'>"+val.factory.location+"</td></tr>");
						
					});
					$("#route_btn").html("");
					$("#route_btn").append("<input  type='button' id='"+num+"' class='btn' value='查看路径'/>");
					
			});
			$(".btn").click(function(){
				map.clearOverlays();
				var str=$(this).attr("id");
				var points = [];		
				for(var b=0; b<str;b++){
					var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
						   anchor: new BMap.Size(10, 25),                  // 指定定位位置   
						   imageOffset: new BMap.Size(0, 0 - b * 25)   // 设置图片偏移   
						 });   
						 
					var str1=$("#location_"+b).html().split(":");
					var ppoint = new BMap.Point(str1[0],str1[1]);
					points.push(ppoint);
					var marker = new BMap.Marker(ppoint, {icon: myIcon}); 
					map.addOverlay(marker);
				}
				var polyline = new BMap.Polyline(points, {strokeColor:"blue", strokeWeight:2, strokeOpacity:0.7});  
				map.addOverlay(polyline); 
			});
		});
	}
	var strID;
	if(<%=request.getParameter("id")%>!=null){
		strID = "<%=request.getParameter("id")%>";
	}else{
		strID = null;
	}
	//取出订单
	if(strID!=null){
		showOrder(strID);
		orderID=strID;
	}
	
	$("#search").click(function(){
		var search=null;
		if($("#order").val()!=null&&$("#order").val()!="请输入..."){
			search=$("#order").val();
		}
		if(search!=null&&$("#select_box").val()!=0){
			if($("#select_box").val()!=1){
				location.href = "trackingEPC.jsp?epc="+search;
			}else{
				showOrder(search);
			}
		}
		orderID=search;
	});
	
	self.setInterval(function(){changeOrder(orderID);}, 30000);
	
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
                    <li><a href="schedule.jsp">调度服务</a> </li>
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
			<p id="boxinfo" class="box">请查询订单</p>	
			<div id="tracking">
				<table class='no-style full'>
										<thead>
											<tr>
												<th>编号</th>
												<th>仓库</th>
												<th>类型</th>
												<th>动作</th>
												<th>时间</th>
											</tr>
										</thead>
										<tbody id="table-track">
										</tbody>
										<tfoot>
											<tr>
												<td></td>
												<td></td>
												<td id="route_btn"></td>
												<td></td>
												<td></td>
											</tr>
										</tfoot>
				</table>
				
			</div>	
			
<div id="dialog-message" title="物流信息">
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