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
			
			//取得注册仓库，并展现
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/factorys!list?callback=?",function(data){
			//使用jquery中的each（data，function）函数从data.userList中获取factorys对象放入value中
				$.each(data.factorys,function(i,value){
					var str ="";
					if(value.owner==0){
						str+="自营";
					}else{
						str+="第三方";
					}
					 $("#message").append("<li><h4>名称："+value.name+"</h4>经纬度："+value.location+
					"<br>所有者："+str+"<p id=state_"+i+" class='factory_State'>仓库状态：未知</p><ul id=factory_"+i+"></ul></li>");
					 $("#select_box").append("<option value="+value.id+">"+value.name+"</option>");
				});	
			});
			
		//搜索函数
		$(".btun").click(function(){
			$('#content').block({  message: '<h1><img src="img/busy.gif" />请稍等...</h1>'} );
			var limit = null;
			var id = null;
			var keyword = null;
			if($("#limit").val()!="输入数量下限"){
				 limit = $("#limit").val();
			}
			if($("#select_box").val()!=0){
				id = $("#select_box").val();
			}
			if($("#keyword").val()!="键入关键字"){
				keyword = $("#keyword").val();
			}
			if(limit==null&&id==null&&keyword==null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/items!list?callback=?",function(data){
					$('#content').unblock();
					map.clearOverlays();
					var arr_point=[];
					var arr_window=[];
					$.each(data.sbs,function(i,value){
						if(value.factory_State==1){
							$("#state_"+i).html("仓库状态:离线");
							$('#state_'+i).css("background-color","#CCCCCC");
						}else{
							$("#factory_"+i).html("");
							$("#state_"+i).html("仓库状态:在线");
							if(value.items==""||value.items==null){
								$("#factory_"+i).html("仓库空空如也~~");
							}else{
								arr_point.push(value.factory_Loacation);
								var infoStr = "<li>仓库名称："+value.factory_Name+"</li>";
								$.each(value.items,function(j,va){
									$("#factory_"+i).append("<p>物资名称："+va.name+"&nbsp;&nbsp;&nbsp;&nbsp;数量："+va.quantity+"</p>");
									infoStr+="<li>物资名称："+va.name+"&nbsp;&nbsp;数量："+va.quantity+"</li>";
								});
								var info = new BMap.InfoWindow(infoStr);
								arr_window.push(info);
							}
						}
					});
					//地图上加标注
					function addMarker(point,index){
						var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
							   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
						});   						 
						var marker = new BMap.Marker(point, {icon: myIcon}); 
						map.addOverlay(marker);
						marker.addEventListener("click",function(){
							map.openInfoWindow(arr_window[index],point);
						});
					}
					
					for(var i=0;  i<arr_point.length; i++){
						var str1= arr_point[i].split(":");
						var ppoint = new BMap.Point(str1[0],str1[1]);
						addMarker(ppoint,i);
					}
				});
			}else if(limit==null&&id!=null&&keyword==null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/items!show?callback=?&&id="+id,function(data){
					$('#content').unblock();
					map.clearOverlays();
					var arr_point=[];
					var arr_window=[];
					var arr_title=[];
					$.each(data.sbs,function(i,value){
						if(value.factory_State==1){
							$("#state_"+(id-1)).html("仓库状态:离线");
						}else{
							$("#factory_"+(id-1)).html("");
							$("#state_"+(id-1)).html("仓库状态:在线");
							if(value.items==""||value.items==null){
								$("#factory_"+(id-1)).html("该仓库空空如也~~");
							}else{
								arr_point.push(value.factory_Loacation);
								arr_title.push(value.factory_Name);
								var infoStr = "<li>仓库名称："+value.factory_Name+"</li>";
								$.each(value.items,function(j,va){
									$("#factory_"+(id-1)).append("<p>物资名称："+va.name+"&nbsp;&nbsp;&nbsp;&nbsp;数量："+va.quantity+"</p>");
									infoStr+="<li>物资名称："+va.name+"&nbsp;&nbsp;数量："+va.quantity+"</li>";
								});
								var info = new BMap.InfoWindow(infoStr);
								arr_window.push(info);
							}
						}
					});
					
					//地图上加标注
					function addMarker(point,index){
						var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
								anchor: new BMap.Size(10, 25),                  // 指定定位位置   
							   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
						});   						 
						var marker = new BMap.Marker(point, {icon: myIcon}); 
						marker.setTitle(arr_title[index]);
						map.addOverlay(marker);
						marker.addEventListener("click",function(){
							map.openInfoWindow(arr_window[index],point);
						});
					}
					
					for(var i=0;  i<arr_point.length; i++){
						var str1= arr_point[i].split(":");
						var ppoint = new BMap.Point(str1[0],str1[1]);
						addMarker(ppoint,i);
					}
				});
			}else if(limit==null&&id==null&&keyword!=null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/items!search?callback=?&&keyword="+keyword,function(data){
					$('#content').unblock();
					map.clearOverlays();
					var arr_point=[];
					var arr_window=[];
					$.each(data.sbs,function(i,value){
						if(value.factory_State==1){
							$("#state_"+i).html("仓库状态:离线");
						}else{
							$("#factory_"+i).html("");
							$("#state_"+i).html("仓库状态:在线");
							if(value.items==""||value.items==null){
								$("#factory_"+i).html("没有符合条件的物资");
							}else{
								arr_point.push(value.factory_Loacation);
								var infoStr = "<li>仓库名称："+value.factory_Name+"</li>";
								$.each(value.items,function(j,va){
									$("#factory_"+i).append("<p>物资名称："+va.name+"&nbsp;&nbsp;&nbsp;&nbsp;数量："+va.quantity+"</p>");
									infoStr+="<li>物资名称："+va.name+"&nbsp;&nbsp;数量："+va.quantity+"</li>";
								});
								var info = new BMap.InfoWindow(infoStr);
								arr_window.push(info);
							}
						}
					});
					//地图上加标注
					function addMarker(point,index){
						var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
								anchor: new BMap.Size(10, 25),                  // 指定定位位置   
							   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
						});   						 
						var marker = new BMap.Marker(point, {icon: myIcon}); 
						map.addOverlay(marker);
						marker.addEventListener("click",function(){
							map.openInfoWindow(arr_window[index],point);
						});
					}
					
					for(var i=0;  i<arr_point.length; i++){
						var str1= arr_point[i].split(":");
						var ppoint = new BMap.Point(str1[0],str1[1]);
						addMarker(ppoint,i);
					}
				});
			}else if(limit==null&&id!=null&&keyword!=null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/items!search?callback=?&&keyword="+keyword+"&&id="+id,function(data){
					$('#content').unblock();
					map.clearOverlays();
					var arr_point=[];
					var arr_window=[];
					$.each(data.sbs,function(i,value){
						if(value.factory_State==1){
							$("#state_"+(id-1)).html("仓库状态:离线");
						}else{
							$("#factory_"+(id-1)).html("");
							$("#state_"+(id-1)).html("仓库状态:在线");
							if(value.items==""||value.items==null){
								$("#factory_"+(id-1)).html("没有符合条件的物资");
							}else{
								arr_point.push(value.factory_Loacation);
								var infoStr = "<li>仓库名称："+value.factory_Name+"</li>";
								$.each(value.items,function(j,va){
									$("#factory_"+(id-1)).append("<p>物资名称："+va.name+"&nbsp;&nbsp;&nbsp;&nbsp;数量："+va.quantity+"</p>");
									infoStr+="<li>物资名称："+va.name+"&nbsp;&nbsp;数量："+va.quantity+"</li>";
								});
								var info = new BMap.InfoWindow(infoStr);
								arr_window.push(info);
							}
						}
					});
					//地图上加标注
					function addMarker(point,index){
						var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
								anchor: new BMap.Size(10, 25),                  // 指定定位位置   
							   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
						});   						 
						var marker = new BMap.Marker(point, {icon: myIcon}); 
						map.addOverlay(marker);
						marker.addEventListener("click",function(){
							map.openInfoWindow(arr_window[index],point);
						});
					}
					
					for(var i=0;  i<arr_point.length; i++){
						var str1= arr_point[i].split(":");
						var ppoint = new BMap.Point(str1[0],str1[1]);
						addMarker(ppoint,i);
					}
				});
			}else if(limit!=null&&id==null&&keyword!=null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/items!search?callback=?&&keyword="+keyword
					+"&&limit="+limit,function(data){
					$('#content').unblock();
					map.clearOverlays();
					var arr_point=[];
					var arr_window=[];
					$.each(data.sbs,function(i,value){
						if(value.factory_State==1){
							$("#state_"+i).html("仓库状态:离线");
						}else{
							$("#state_"+i).html("仓库状态:在线");
							$("#factory_"+i).html("");
							if(value.items==""||value.items==null){
								$("#factory_"+i).html("没有符合物资");
							}else{
								arr_point.push(value.factory_Loacation);
								var infoStr = "<li>仓库名称："+value.factory_Name+"</li>";
								$.each(value.items,function(j,va){
									$("#factory_"+i).append("<p>物资名称："+va.name+"&nbsp;&nbsp;&nbsp;&nbsp;数量："+va.quantity+"</p>");
									infoStr+="<li>物资名称："+va.name+"&nbsp;&nbsp;数量："+va.quantity+"</li>";
								});
								var info = new BMap.InfoWindow(infoStr);
								arr_window.push(info);
							}
						}
					});
			//地图上加标注
					function addMarker(point,index){
						var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
								anchor: new BMap.Size(10, 25),                  // 指定定位位置   
							   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
						});   						 
						var marker = new BMap.Marker(point, {icon: myIcon}); 
						map.addOverlay(marker);
						marker.addEventListener("click",function(){
							map.openInfoWindow(arr_window[index],point);
						});
					}
					
					for(var i=0;  i<arr_point.length; i++){
						var str1= arr_point[i].split(":");
						var ppoint = new BMap.Point(str1[0],str1[1]);
						addMarker(ppoint,i);
					}
				});
			}else if(limit!=null&&id!=null&&keyword!=null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/items!search?callback=?&&keyword="+keyword
						+"&&limit="+limit+"&&id="+id,function(data){
						$('#content').unblock();
						map.clearOverlays();
						var arr_point=[];
						var arr_window=[];
						$.each(data.sbs,function(i,value){
							if(value.factory_State==1){
								$("#state_"+(id-1)).html("仓库状态:离线");
							}else{
								$("#factory_"+(id-1)).html("");
								$("#state_"+(id-1)).html("仓库状态:在线");
								if(value.items==""||value.items==null){
									$("#factory_"+(id-1)).html("没有符合物资");
								}else{
									arr_point.push(value.factory_Loacation);
									var infoStr = "<li>仓库名称："+value.factory_Name+"</li>";
									$.each(value.items,function(j,va){
										$("#factory_"+(id-1)).append("<p>物资名称："+va.name+"&nbsp;&nbsp;&nbsp;&nbsp;数量："+va.quantity+"</p>");
										infoStr+="<li>物资名称："+va.name+"&nbsp;&nbsp;数量："+va.quantity+"</li>";
									});
									var info = new BMap.InfoWindow(infoStr);
									arr_window.push(info);
								}
							}
						});
						//地图上加标注
						function addMarker(point,index){
							var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
									anchor: new BMap.Size(10, 25),                  // 指定定位位置   
								   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
							});   						 
							var marker = new BMap.Marker(point, {icon: myIcon}); 
							map.addOverlay(marker);
							marker.addEventListener("click",function(){
								map.openInfoWindow(arr_window[index],point);
							});
						}
						for(var i=0;  i<arr_point.length; i++){
							var str1= arr_point[i].split(":");
							var ppoint = new BMap.Point(str1[0],str1[1]);
							addMarker(ppoint,i);
						}
					});
			}
		});
});
				

