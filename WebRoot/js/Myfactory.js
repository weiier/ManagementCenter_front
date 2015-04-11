			//定时查询和刷新
		function getFactorys(){
			var map = new BMap.Map("allmap");
			var point = new BMap.Point(108.56,39.45);
			map.centerAndZoom(point,5);
			map.enableScrollWheelZoom();
			map.addControl(new BMap.NavigationControl());
			map.addControl(new BMap.OverviewMapControl());
			map.addControl(new BMap.MapTypeControl());
			map.setCurrentCity("北京");
			
			$('#content').block({  message: '<h1><img src="img/busy.gif" /> 请稍等...</h1>'} );
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/factorys!list?level=1&&callback=?",function(data){
				$('#content').unblock();
				map.clearOverlays();
				$("#message").html("");
				//使用jquery中的each（data，function）函数从data.userList中获取factorys对象放入value中
					var arr_point=[];
					var arr_address=[];
					var arr_title=[];
					$.each(data.subs,function(i,value){
						var state="";
						arr_point.push(value.factory_Loacation);
						arr_address.push(value.factory_City);
						arr_title.push(value.factory_Name);
						if(value.factory_State==1){
							state+="离线";
						}else{
							state+="在线";
						}
						$("#message").append("<li id=factory_"+i+"><a><strong id="+i+">名称："+value.factory_Name+"</strong>经纬度："
								+value.factory_Loacation+"<br>描述："+value.factory_Description+"<p id=state_"+i+">状态："+state+"</p></a></li>");
						if(state=="离线"){
							$('#state_'+i).css("background-color","#CCCCCC");
						}
					});
					
					var size=arr_point.length;
					var infoWindow = [];
					for(var i=0;  i<size; i++){
						var info = new BMap.InfoWindow("名称："+arr_title[i]+"<br>地址："+arr_address[i]);
						infoWindow.push(info);
					}
					var markers = [];
					function addMarker(point,index){
						var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
							   offset: new BMap.Size(10, 25),                  // 指定定位位置   
							   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
						});   						 
						var marker = new BMap.Marker(point, {icon: myIcon}); 
						marker.setTitle(index);
						map.addOverlay(marker);
						marker.addEventListener("click",function(){
							map.openInfoWindow(infoWindow[index],point);
						});
						marker.addEventListener("mouseover",function(){
							$("#factory_"+index).css("background-color","#B4CDCD");
						});
						marker.addEventListener("mouseout",function(){
							$("#factory_"+index).css("background-color","");
						});
						markers.push(marker);
					}
					var points = [];
					for(var i=0;  i<size; i++){
						var str1= arr_point[i].split(":");
						var ppoint = new BMap.Point(str1[0],str1[1]);
						points.push(ppoint);
						addMarker(ppoint,i);
					}		
					
					$('strong').click(function(){
						var str=$(this).attr("id");
						markers[str].setAnimation(BMAP_ANIMATION_BOUNCE);
					});
					
					$('strong').mouseout(function(){
						var str=$(this).attr("id");
						markers[str].setAnimation();
					});
				});
		}
				
	
		
		$(document).ready(function(){
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
			
			//取出仓库
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/factorys!list?callback=?",function(data){
			//使用jquery中的each（data，function）函数从data.userList中获取factorys对象放入value中
				var arr_point=[];
				var arr_address=[];
				var arr_title=[];
				$.each(data.factorys,function(i,value){
					arr_point.push(value.location);
					arr_address.push(value.city);
					arr_title.push(value.description);
					$("#message").append("<li id=factory_"+i+"><a><strong id="+i+">名称："+value.name+"</strong>经纬度："
							+value.location+"<br>描述："+value.description+"<br><p>状态：待查询</p></a></li>");
				});
				
				var size=arr_point.length;
				
				var infoWindow = [];
				for(var i=0;  i<size; i++){
					var info = new BMap.InfoWindow("名称："+arr_title[i]+"<br>地址："+arr_address[i]);
					infoWindow.push(info);
				}
				//标点，绑定事件
				var markers = [];
				function addMarker(point,index){
					var myIcon = new BMap.Icon("img/markers.png", new BMap.Size(23, 25), {   
						   offset: new BMap.Size(10, 25),                  // 指定定位位置   
						   imageOffset: new BMap.Size(0, 0 - index * 25)   // 设置图片偏移   
					});   						 
					var marker = new BMap.Marker(point, {icon: myIcon}); 
					marker.setTitle(index);
					map.addOverlay(marker);
					marker.addEventListener("click",function(){
						map.openInfoWindow(infoWindow[index],point);
					});
					marker.addEventListener("mouseover",function(){
						$("#factory_"+index).css("background-color","#B4CDCD");
					});
					marker.addEventListener("mouseout",function(){
						$("#factory_"+index).css("background-color","");
					});
					markers.push(marker);
				}
				
				var points = [];
				for(var i=0;  i<size; i++){
					var str1= arr_point[i].split(":");
					var ppoint = new BMap.Point(str1[0],str1[1]);
					points.push(ppoint);
					addMarker(ppoint,i);
				}
					
				$('strong').click(function(){
					var str=$(this).attr("id");
					markers[str].setAnimation(BMAP_ANIMATION_BOUNCE);
				});
				
				$('strong').mouseout(function(){
					var str=$(this).attr("id");
					markers[str].setAnimation();
				});
			});
			//五分钟刷新一次
			self.setInterval("getFactorys()", 5*60000);

			$("#refresh").click(function(){
				getFactorys();
			});
			//tracking
			$("#search").click(function(){
				var search=null;
				if($("#order").val()!=null&&$("#order").val()!="请输入..."){
					search=$("#order").val();
				}
				if(search!=null&&$("#select_box").val()!=0){
					if($("#select_box").val()==1){
						location.href = "tracking.jsp?id="+search;
					}else{
						location.href = "trackingEPC.jsp?epc="+search;
					}
				}
			});
		});
	
		