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
	<style type="text/css">
	#img {
		max-width: 70px; 
		max-height: 70px; 
	} 
	</style>
	<script type="text/javascript">	
$(document).ready(function(){		
	var trackingID=null;
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
	
	function c(string){
		if(string==null)string = "无权限";
		return string;
	}	
	function showEPC(epc){
		var name = $("#track_username").val();
		var upw = $("#track_password").val();
		var company = $("#track_company").val();
		$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/tracks?callback=?&&username="+name
			+"&&password="+upw+"&&epc="+epc+"&&company="+company,function(data){
			var infoWindow = [];
			if(data.result==null){
				$("#table-track").append("<tr><td colspan='2'>该条epc暂无tracking记录</td></tr>");
			}
			var info="epc编号："+data.epc;
			$("#boxinfo").addClass("box-info").html(info);
			var num=0;
			$("#table-track").html("");

			$.each(data.result,function(i,value){
						num++;
						var logoStr =("logo/0000004.png;logo/0000003.png").split(";");
						var imageData = ("bmp/hide_0000004.png;bmp/hide_0000003.png").split(";");
						var docData = ("pdf/hide_0000004.pdf;pdf/hide_0000003.pdf").split(";");
						$("#table-track").append("<tr><td>company.name</td><td>"+c(value.queryResult[0].company.name)+"</td></tr>")
							.append("<tr><td>company.address</td><td>"+c(value.queryResult[0].company.address)+"</td></tr>")
							.append("<tr><td>company.id</td><td>"+c(value.queryResult[0].company.id)+"</td></tr>")
							.append("<tr><td>company.bankId</td><td>"+c(value.queryResult[0].company.bankId)+"</td></tr>")
							.append("<tr><td>company.areaId</td><td>"+c(value.queryResult[0].company.areaId)+"</td></tr>")
							.append("<tr><td>company.logo</td><td><img id='img'  src='http://10.103.242.71:8888/aspireRFIDonsTrackingService/"
									+logoStr[i]+"'>"+"</td></tr>")
							.append("<tr><td>company.imageData</td><td><img id='img' src='http://10.103.242.71:8888/aspireRFIDonsTrackingService/"
									+imageData[i]+"'>"+"</td></tr>")
							.append("<tr><td>company.docData</td><td><a id='doc' href='http://10.103.242.71:8888/aspireRFIDonsTrackingService/"
									+docData[i]+"'>点击查看文档"+"</a></td></tr>")
							.append("<tr><td>company.description</td><td>"+c(value.queryResult[0].company.description)+"</td></tr>")
							.append("<tr><td>event.action</td><td>"+c(value.queryResult[0].event.action)+"</td></tr>")
							.append("<tr><td>event.LocationUri</td><td>"+c(value.queryResult[0].event.bizLocationUri)+"</td></tr>")
							.append("<tr><td>event.StepUri</td><td>"+c(value.queryResult[0].event.bizStepUri)+"</td></tr>")
							.append("<tr><td>event.eventTime</td><td>"+c(value.queryResult[0].event.eventTime)+"</td></tr>")
							.append("<tr><td>event.readPointUri</td><td>"+c(value.queryResult[0].event.readPointUri)+"</td></tr>")
							.append("<tr><td id='location_"+i+"' style='display:none'>"+value.queryResult[0].longitude+":"+value.queryResult[0].latitude+"</td></tr>");
	
						var info = new BMap.InfoWindow("公司名称："+value.queryResult[0].company.name+"<br>描述："+value.queryResult[0].company.description
							+"<br>仓库URI："+value.queryResult[0].event.bizLocationUri+"<br>读写器URI："+value.queryResult[0].event.readPointUri);
						infoWindow.push(info);
						
			});
			$("#route_btn").html("");
			$("#route_btn").append("<input  type='button' id='"+num+"' class='btn' value='查看路径'/>");
					
			function addMarker(point,index){
				var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
					   anchor: new BMap.Size(10, 25),                  // 指定定位位置   
					   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
				});   						 
				var marker = new BMap.Marker(point, {icon: myIcon}); 
				marker.setTitle(index);
				map.addOverlay(marker);
				marker.addEventListener("click",function(){
					map.openInfoWindow(infoWindow[index],point);
				});
			}
			
			$(".btn").click(function(){
				map.clearOverlays();
				var str=$(this).attr("id");
				var points = [];		
				for(var b=0; b<str;b++){		 
					var str1=$("#location_"+b).html().split(":");
					var ppoint = new BMap.Point(str1[0],str1[1]);
					points.push(ppoint);
					addMarker(ppoint,b);
				}
				var polyline = new BMap.Polyline(points, {strokeColor:"blue", strokeWeight:2, strokeOpacity:0.7});  
				map.addOverlay(polyline); 
			});
		});
	}
	
	var strEPC = "<%=request.getParameter("epc")%>";
	//取出订单
	if(strEPC!="null"){
		showEPC(strEPC);
		trackingID=strEPC;
	}
	
	//搜索
	$("#search").click(function(){
		var search=null;
		if($("#order").val()!=null&&$("#order").val()!="请输入..."){
			search=$("#order").val();
		}
		if(search!=null&&$("#select_box").val()!=0){
			if($("#select_box").val()==1){
				location.href = "tracking.jsp?id="+search;
			}else{
				showEPC(search);
			}
		}
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
                        <input type="hidden" id="track_username" value="${sessionScope.user.username}"/>
                         <input type="hidden" id="track_password" value="${sessionScope.user.password}"/>
                          <input type="hidden" id="track_company" value="${sessionScope.user.company}"/>
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
			<p id="boxinfo" class="box">请查询epc详单</p>	
			<div id="tracking">
				<table class='no-style full'>
										<thead>
											<tr>
												<th>类型</th>
												<th>内容</th>
											</tr>
										</thead>
										<tbody id="table-track">
										</tbody>
										<tfoot>
											<tr>
												<td></td>
												<td id="route_btn"></td>
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