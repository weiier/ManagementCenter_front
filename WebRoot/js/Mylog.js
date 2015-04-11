
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
		//取出仓库
		$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/factorys!list?callback=?",function(data){
			$.each(data.factorys,function(i,value){
				 $("#select_box").append("<option value="+value.id+">"+value.name+"</option>");
			});
		});
		//取得日志
		$(".btun").click(function(){
			var start = $("#start").val();
			var end = $("#end").val();
			var id = $("#select_box").val();
			var datable=$('#example').dataTable({"bDestroy":true});
			datable.fnClearTable();//清空数据表
			if(id==0){
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/logs!search?callback=?&&start="+start
						+"&&end="+end,function(data){	
					$.each(data.logs,function(i,value){
						if(value.factoryState==0){
							$("#tbody").append("<tr><td>&nbsp;&nbsp;"+value.id+"</td><td>"+value.factory.name
							+"</td><td>&nbsp;&nbsp; &nbsp;在线&nbsp;  </td><td class='center'>"+value.stateTime+"</td><td class='center'> &nbsp;查看</td></tr>");
						}else{
							$("#tbody").append("<tr class='gradeX'><td>&nbsp;&nbsp;"+value.id+"</td><td>"+value.factory.name
							+"</td><td>&nbsp; &nbsp; &nbsp;离线&nbsp; </td><td class='center'>"+value.stateTime+"</td><td class='center'> &nbsp;查看</td></tr>");					
						}
					});
					$('#example').dataTable({"bDestroy":true});//重新调用插件
				});
			}else {
				$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/logs!search?callback=?&&start="+start
						+"&&end="+end+"&&id="+id,function(data){	
					$.each(data.logs,function(i,value){
						if(value.factoryState==0){
							$("#tbody").append("<tr><td>&nbsp;&nbsp;"+value.id+"</td><td>"+value.factory.name
							+"</td><td>&nbsp;&nbsp; &nbsp;在线&nbsp;  </td><td class='center'>"+value.stateTime+"</td><td class='center'> &nbsp;查看</td></tr>");
						}else{
							$("#tbody").append("<tr class='gradeX'><td>&nbsp;&nbsp;"+value.id+"</td><td>"+value.factory.name
							+"</td><td>&nbsp; &nbsp; &nbsp;离线&nbsp; </td><td class='center'>"+value.stateTime+"</td><td class='center'> &nbsp;查看</td></tr>");					
						}
					});
					$('#example').dataTable({"bDestroy":true});//重新调用插件
				});
			}
		});
});