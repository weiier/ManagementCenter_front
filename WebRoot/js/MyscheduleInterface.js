
	$(document).ready(function(){
		//�����ͼ
		var map = new BMap.Map("allmap");
		var point = new BMap.Point(108.56,39.45);
		map.centerAndZoom(point,5);
		map.enableScrollWheelZoom();
		map.addControl(new BMap.NavigationControl());
		map.addControl(new BMap.OverviewMapControl());
		map.addControl(new BMap.MapTypeControl());
		map.setCurrentCity("����");
		
		$('nav').superfish({
			//useClick: true
		});
		
		//����tab
		$( "#tabs" ).tabs();
		//ȡ���ֿ�
		$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/factorys!list?callback=?",function(data){
			$.each(data.factorys,function(i,value){
				 $("#tabs1_origin").append("<option value="+value.id+">"+value.name+"</option>");
				 $("#tabs1_des").append("<option value="+value.id+">"+value.name+"</option>");
				 $("#tabs1_mid optgroup").append("<option value="+value.id+">"+value.name+"</option>");
				 $("#tabs2_origin").append("<option value="+value.id+">"+value.name+"</option>");
				 $("#tabs2_des").append("<option value="+value.id+">"+value.name+"</option>");
				 $("#tabs2_mid optgroup").append("<option value="+value.id+">"+value.name+"</option>");
			});
		});
		//�û��Զ���·��
		$("#tabs1_custom").click(function(){
			var origin = $("#tabs1_origin").val();
			var des = $("#tabs1_des").val();
			var mid = $("#tabs1_mid").val();
			var str= new Array();
			for(var i=0;i<des.length;i++){
					str.push({'origin':origin,'des':des[i],'mid':mid});
			}
			var jsonStr =JSON.stringify(str);
			alert(jsonStr);
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!create?callback=?&&jsonStr="+jsonStr,function(data){
				alert(data.message);
			});
		});
		//ȡ�õ��ȱ?����
		$("#tabs1_route").click(function(){
			var origin = $("#tabs1_origin").val();
			var des = $("#tabs1_des").val();
			var item = $("#tabs1_item").val();
			var quantity = $("#tabs1_quantity").val();
			var str= new Array();
			for(var i=0;i<des.length;i++){
					str.push({'origin':origin,'des':des[i],'item':item,'quantity':quantity});
			}
			var jsonStr =JSON.stringify(str);
			alert(jsonStr);
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/orders!create?callback=?&&jsonStr="+jsonStr,function(data){
			});
		});
		
		//ȡ�õ��ȱ?����
		$("#tabs2_route").click(function(){
			var origin = $("#tabs2_origin").val();
			var des = $("#tabs2_des").val();
			var item = $("#tabs2_item").val();
			var quantity = $("#tabs2_quantity").val();
			var str= new Array();
			for(var i=0;i<origin.length;i++){
					str.push({'origin':origin[i],'des':des,'item':item,'quantity':quantity});
			}
			var jsonStr =JSON.stringify(str);
			alert(jsonStr);
			$.getJSON("http://10.103.242.71:8888/aspireRFIDonsTrackingService/testJson?jsonStr="+jsonStr,function(data){
				alert(data.message);
			});
		});
		
	});
