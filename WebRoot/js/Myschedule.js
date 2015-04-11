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
		//加载tab
		$( "#tabs" ).tabs();
		
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
		
		var idList = [];
		//取出仓库
		$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/factorys!list?callback=?",function(data){
			var arr_point=[];
			var arr_address=[];
			var arr_title=[];
			var arr_name=[];
			$.each(data.factorys,function(i,value){
				 $("#tabs1_des").append("<option value="+value.id+" id='factory_"+value.id+"'>"+value.name+"</option>");			
				//$("#tabs1_mid").append("<option value="+value.id+">"+value.name+"</option>");
				$("#tabs1_mid optgroup[label='第1号中转仓库']").append("<option value=1_"+value.id+">"+value.name+"</option>");
				$("#tabs1_mid optgroup[label='第2号中转仓库']").append("<option value=2_"+value.id+">"+value.name+"</option>");
				arr_point.push(value.location);
				arr_address.push(value.city);
				arr_title.push(value.description);
				arr_name.push(value.name);
			});					
			var size=arr_point.length;
			var infoWindow = [];
			for(var i=0;  i<size; i++){
				var info = new BMap.InfoWindow("名称："+arr_name[i]+"<br>地址："+arr_address[i]+"<br>描述："+arr_title[i]);
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
				
				markers.push(marker);
			}
			
			var points = [];
			for(var i=0;  i<size; i++){
				var str1= arr_point[i].split(":");
				var ppoint = new BMap.Point(str1[0],str1[1]);
				points.push(ppoint);
				addMarker(ppoint,i);
			}
							
			//加载下拉列表插件
			$("#tabs1_mid").multiselect({
				selectedList:4,
				close:function(){
				}
			});
			
			
			$("#tabs1_des").multiselect({
				selectedList: 4,
				 close: function(){
					$('#content').block({  message: '<h1><img src="img/busy.gif" />正在查询...</h1>'} );
					 $.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/items!schedule?callback=?&&ids="
							 +$("#tabs1_des").val()+"&&keyword="+$("#tabs1_item").val(),function(data){
								 $('#content').unblock();
								$("#tabs1_origin").html("");
								 for(var l=0;l<idList.length;l++){
									 idList.pop();
								 }
								 $.each(data.maps,function(key,value){
									 	idList.push(key);
									 	//怎么判断
									 	if(value==[]){
									 		$("#tabs1_origin").append("<p>发往"+$("#factory_"+key).html()+"暂无合适发货仓库</p>");
									 	}else{
									 		$("#tabs1_origin").append("<p>发往"+$("#factory_"+key).html()+"</p>");
									 	}
									 	 $.each(value,function(i,val){
											$("#tabs1_origin").append("<input type='checkbox'  name='checkbox_"+key+"' value="+val.factory_ID+">仓库："
											+$("#factory_"+val.factory_ID).html()+"物资："+val.items[0].name+"库存："+val.items[0].quantity+"</br>");
										});
								});								 
						});
				   }
			});
		});

		//取得调度表单内容
		$("#tabs1_route").click(function(){
			$('#content').block({  message: '<h1><img src="img/busy.gif" />正在调度...</h1>'} );
			var str= new Array();
			for(var id=0;id<idList.length;id++){
				$("input[name='checkbox_"+idList[id]+"']:checkbox:checked").each(function(){ 
					var item = $("#tabs1_item").val();
					var quantity = $("#tabs1_quantity").val();
					str.push({'origin':$(this).val(),'des':idList[id],'item':item,'quantity':quantity});
				}) ;
			}
			var jsonStr =JSON.stringify(str);
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!create?callback=?&&jsonStr="+jsonStr,function(data){
				//location.reload();
				$("#message-info").html("");
				 $.each(data.message,function(key,value){
					 if(key>0){
						 $("#message-info").append("调度成功，订单号为<b>"+key+"</b>,路径为<b>"+value+"</b><br>");
					 }else{
						 $("#message-info").html("调度失败，请对路径<b>"+value+"</b>重新调度<br>");
					 }
				 });
				 $('#content').unblock();
				 $( "#dialog-message" ).dialog( "open" );	
			});
		});
		
		//带中转
		$("#tabs1_custom").click(function(){
			
			function c(string){
				var str = new Array();
				for(var i = 0; i<string.length;i++){
					str.push(string[i].split("_")[1]);
				}
				return str;
			}
			
			$('#content').block({  message: '<h1><img src="img/busy.gif" />正在调度...</h1>'} );
			var str= new Array();
			for(var id=0;id<idList.length;id++){
				$("input[name='checkbox_"+idList[id]+"']:checkbox:checked").each(function(){ 
					var item = $("#tabs1_item").val();
					var quantity = $("#tabs1_quantity").val();
					if($("#tabs1_mid").val()==null){
						str.push({'origin':$(this).val(),'des':idList[id],'item':item,'quantity':quantity,
							'route':$(this).val()+","+idList[id]});
					}else{
						str.push({'origin':$(this).val(),'des':idList[id],'item':item,'quantity':quantity,
							'route':$(this).val()+","+c($("#tabs1_mid").val())+","+idList[id]});
					}
				}) ;
			}
			var jsonStr =JSON.stringify(str);
			alert(jsonStr);
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!custom?callback=?&&jsonStr="+jsonStr,function(data){
				$("#message-info").html("");
				 $.each(data.message,function(key,value){
					 if(key>0){
						 $("#message-info").append("调度成功，订单号为<b>"+key+"</b>,路径为<b>"+value+"</b><br>");
					 }else{
						 $("#message-info").html("调度失败，请对路径<b>"+value+"</b>重新调度<br>");
					 }
				 });
				 $('#content').unblock();
				 $( "#dialog-message" ).dialog( "open" );	
			});
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
