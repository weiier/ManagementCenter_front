
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
			buttonImageOnly: true,
			dateFormat:"yy-mm-dd",
		});
		$( "#end" ).datepicker({
			showOn: "button",
			buttonImage: "img/calendar.gif",
			buttonImageOnly: true,
			dateFormat:"yy-mm-dd",
		});
		
		//加载表格插件
		$('#example').dataTable();
		//取出订单数据
		$("#search").click(function(){
			var datable=$('#example').dataTable({"bDestroy":true});
			datable.fnClearTable();//清空数据表
			var start = null;
			var id = null;
			var end = null;
			if($("#order").val()!="订单编号"){
				id = $("#order").val();
			}
			if($("#start").val()!="起始时间"){
				start = $("#start").val();
			}
			if($("#end").val()!="结束时间"){
				end = $("#end").val();
			}
			if(start==null&&id==null&&end==null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!list?callback=?",function(data){
					$.each(data.orders,function(i,value){
						if(value.state==1){
							$("#tbody").append("<tr><td>"+value.id+"</td><td>"+value.transcationID+"</td><td>"+value.route+
								"</td><td>完成</td><td><a href='order.jsp?id="+value.id+"'> 查看</a></td></tr>");
						}else{
							$("#tbody").append("<tr class='gradeX'><td>"+value.id+"</td><td>"+value.transcationID+"</td><td>"+value.route+
								"</td><td>未完</td><td> <a href='order.jsp?id="+value.id+"'> 查看</a></td></tr>");					
						}
					});
					$('#example').dataTable({"bDestroy":true});//重新调用插件
				});
			}else if(start!=null&&id==null&&end!=null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!search?callback=?&&start="+start+"&&end="+end,function(data){
					$.each(data.orders,function(i,value){
						if(value.state==1){
							$("#tbody").append("<tr><td>"+value.id+"</td><td>"+value.transcationID+"</td><td>"+value.route+
									"</td><td>完成</td><td><a href='order.jsp?id="+value.id+"'> 查看</a></td></tr>");
						}else{
							$("#tbody").append("<tr class='gradeX'><td>"+value.id+"</td><td>"+value.transcationID+"</td><td>"+value.route+
									"</td><td>未完</td><td> <a href='order.jsp?id="+value.id+"'> 查看</a></td></tr>");						
						}
					});
					$('#example').dataTable({"bDestroy":true});//重新调用插件
				});
			}else if(start!=null&&id!=null&&end!=null){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!search?callback=?&&start="+start+"&&end="
						+end+"&&id="+id,function(data){
					$.each(data.orders,function(i,value){
						if(value.state==1){
							$("#tbody").append("<tr><td>"+value.id+"</td><td>"+value.transcationID+"</td><td>"+value.route+
									"</td><td>完成</td><td><a href='order.jsp?id="+value.id+"'> 查看</a></td></tr>");
						}else{
							$("#tbody").append("<tr class='gradeX'><td>"+value.id+"</td><td>"+value.transcationID+"</td><td>"+value.route+
									"</td><td>未完</td><td> <a href='order.jsp?id="+value.id+"'> 查看</a></td></tr>");		
						}
					});
					$('#example').dataTable({"bDestroy":true});//重新调用插件
				});
			}
		});
});