
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
		//取出订单
		$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!list?callback=?",function(data){
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
							$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
							"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
						}
						if(val.arrivedState==1){
							Str = "已发货";
							$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
							"<td id='location_"+i+"_"+j+"'style='display:none'>"+val.factory.location+"</td></tr>");
						}
						if(val.arrivedState==2){
							Str = "待收货";
							$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
							"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
						}
						if(val.arrivedState==3){
							Str = "已收货";
							$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
							"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
						}
					});
					$("#order_tabs_"+i).append("<tr><td colspan='2' align='center'><input id='"+i+"_"+num+"' type='button'; class='btn' value='查看路径'/> </td>");
					
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
									$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
									"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
								}
								if(val.arrivedState==0){
									Str = "待发货";
									$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
									"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
								}
								if(val.arrivedState==1){
									Str = "已发货";
									$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
									"<td id='location_"+i+"_"+j+"'style='display:none'>"+val.factory.location+"</td></tr>");
								}
								if(val.arrivedState==2){
									Str = "待收货";
									$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
									"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
								}
								if(val.arrivedState==3){
									Str = "已收货";
									$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
									"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
								}
							});
							$("#order_tabs_"+i).append("<tr><td colspan='2' align='center'><input id='"+i+"_"+num+"' type='button'; class='btn' value='查看路径'/> </td>");
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
		
		//加载tab
		$( "#tabs" ).tabs();
		
		//订单搜索
		$(".btun").click(function(){
			var start = null;
			var id = 0;
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
								$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
								"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
							}
							if(val.arrivedState==1){
								Str = "已发货";
								$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
								"<td id='location_"+i+"_"+j+"'style='display:none'>"+val.factory.location+"</td></tr>");
							}
							if(val.arrivedState==2){
								Str = "待收货";
								$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
								"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
							}
							if(val.arrivedState==3){
								Str = "已收货";
								$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
								"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
							}
						});
						$("#order_tabs_"+i).append("<tr><td colspan='2' align='center'><input id='"+i+"_"+num+"' type='button'; class='btn' value='查看路径'/> </td>");
						
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
										$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
										"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
									}
									if(val.arrivedState==0){
										Str = "待发货";
										$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
										"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
									}
									if(val.arrivedState==1){
										Str = "已发货";
										$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
										"<td id='location_"+i+"_"+j+"'style='display:none'>"+val.factory.location+"</td></tr>");
									}
									if(val.arrivedState==2){
										Str = "待收货";
										$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
										"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
									}
									if(val.arrivedState==3){
										Str = "已收货";
										$("#order_tabs_"+i).append("<tr><td><b>"+val.eventTime+"</b></td><td>仓库"+val.factory.name+Str+"</td>"+
										"<td id='location_"+i+"_"+j+"' style='display:none'>"+val.factory.location+"</td></tr>");
									}
								});
								$("#order_tabs_"+i).append("<tr><td colspan='2' align='center'><input id='"+i+"_"+num+"' type='button'; class='btn' value='查看路径'/> </td>");
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