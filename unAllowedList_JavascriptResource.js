	

	var allProcessTable=document.getElementById("pcProcessList");
	
	var blackSubTopic;
	var processSubTopic;

	var blackTopicFloor;
	var blackTopicClass;

	var targetList = "";

	var selectGroup;
	var selectGroupValue;
	var selectFloor;
	var selectFloorValue;

	var selectGroup2;
	var selectGroupValue2;
	var selectFloor2;
	var selectFloorValue2;
	var selectPC;
	var selectPCValue;

	function onMessageArrived2(message) { //블랙리스트,프로세스리스트 받는 함수
		//var table = document.getElementById("unAllowList");
		blackSubTopicArray = message.destinationName.split("/"); // hansung/blacklistShow/...
		console.log(message.destinationName);
		console.log(message.payloadString);

		if (blackSubTopicArray[1] == "BlacklistShow") {
			var contentArray = message.payloadString.split(";"); // 블랙리스트들이 배열로 저장됨
			console.log("blacklist: " + contentArray[0]);
			document.getElementById("blackNum").innerHTML=contentArray[0];

			if (contentArray[0] != 0) {
				/* var detectTable=document.getElementById("tableBody");
				var detectTable2=document.getElementById("table2Body"); */

				for (var i = 0; i < contentArray[0]; i++) {
					addRow(contentArray[i + 1],
							"<input type='checkbox' name='chkBox' onchange='test(this);' value='"
									+ contentArray[i + 1]
									+ "' aria-label='...'>"); //각 tr의 체크박스의 value값을 해당 프로세스 이름으로 주겠다.
				}
			}
		}

		else if (blackSubTopicArray[1] == "ProcesslistShow") {
			document.getElementById("pcProcessList").innerHTML="";
			var contentArray = message.payloadString.split(";"); // 프로세스리스트들이 배열로 저장됨
			console.log("processlist: " + contentArray[0]);
			document.getElementById("processNum").innerHTML=contentArray[0];

			if (contentArray[0] != 0) {
				for (var i = 0; i < contentArray[0]; i++) {
					addRow2(contentArray[i + 1]);
				}
			}
		}

		else {
			return;
		}
	}

	function addRow(str1, str2) {
		var table = document.getElementById("unAllowList");
		var row = table.insertRow(table.rows.length); // 하단에 추가
		//var row = table.insertRow(0); // 상단에 추가
		row.id = str1;

		var cell1 = row.insertCell(0);
		var cell2 = row.insertCell(1);
		cell1.innerHTML = str1;
		cell2.innerHTML = str2;
	}

	function addRow2(str1) {
		var table = document.getElementById("pcProcessList");
		var row = table.insertRow(table.rows.length); // 하단에 추가
		//var row = table.insertRow(0); // 상단에 추가
		row.id = str1; //각 프로세스테이블의 행들의 id는 해당 프로세스 이름으로 주겠다

		var cell1 = row.insertCell(0);
		cell1.innerHTML = str1;
	}

	function addBlackList(obj) {
		document.getElementById("unAllowList").innerHTML = "";
		var addlist = document.getElementById("processAdd").value + ";";

		message = new Paho.MQTT.Message(addlist);
		message.destinationName = "hansung/blacklistAdd/" + blackTopicFloor
				+ "/" + blackTopicClass + "/1";
		console.log(message.destinationName);
		// console.log("addlist topic: "+message.destinationName);

		blackClient.send(message);
		console.log("publish success : " + message);
		document.getElementById("processAdd").value = "";
	}

	function delBlackList() {
		document.getElementById("unAllowList").innerHTML = "";

		message = new Paho.MQTT.Message(targetList);
		message.destinationName = "hansung/blacklistDelete/" + blackTopicFloor
				+ "/" + blackTopicClass + "/1";
		console.log(message.destinationName);
		blackClient.send(message);
		console.log("message send: " + message);
	}

	function test(me) {
		var isChecked = $(me).is(":checked");
		var txt;

		if (isChecked == true) {
			targetList += $(me).parent().parent().text().trim();
		}
		targetList += ";";
	}

	function setBlackTopic() {
		selectGroup = document.getElementById("selectGroup"); //selectGroup이라는 id가진애 가져옴
		selectGroupValue = selectGroup.options[selectGroup.selectedIndex].value; //그 selectGroup의 선택된 인덱스의 value를 가져옴

		selectFloor = document.getElementById("selectFloor"); //selectFloor라는 id가진애 가져옴
		selectFloorValue = selectFloor.options[selectFloor.selectedIndex].value; //그 selectFloor의 선택된 인덱스의 value를 가져옴

		blackTopicFloor = selectFloorValue;
		blackTopicClass = selectGroupValue;

		blackSubTopic = "hansung/+/" + blackTopicFloor + "/" + blackTopicClass + "/#";
		blackClient.subscribe(blackSubTopic);
		console.log(blackSubTopic);
		
		message = new Paho.MQTT.Message("");
		message.destinationName = "hansung/blacklistShow/" + blackTopicFloor
				+ "/" + blackTopicClass + "/1";
		console.log(message.destinationName);

		blackClient.send(message);
		console.log("publish success : " + message);
		
	}

	function setProcessTopic() {
		selectFloor2 = document.getElementById("selectProcessFloor"); //selectGroup이라는 id가진애 가져옴
		selectFloorValue2 = selectFloor2.options[selectFloor2.selectedIndex].value; //그 selectGroup의 선택된 인덱스의 value를 가져옴

		selectGroup2 = document.getElementById("selectProcessGroup"); //selectFloor라는 id가진애 가져옴
		selectGroupValue2 = selectGroup2.options[selectGroup2.selectedIndex].value; //그 selectFloor의 선택된 인덱스의 value를 가져옴

		selectPC = document.getElementById("selectProcessPC");
		selectPCValue = selectPC.options[selectPC.selectedIndex].value.substring(4,5);

		processSubTopic = "hansung/+/" + selectFloorValue2 + "/"
				+ selectGroupValue2 + "/" + selectPCValue;
		blackClient.subscribe(processSubTopic);
		console.log(processSubTopic);
		
		message = new Paho.MQTT.Message("");
		message.destinationName = "hansung/processlistShow/" + selectFloorValue2
				+ "/" + selectGroupValue2 + "/" + selectPCValue;
		console.log(message.destinationName);

		blackClient.send(message);
		console.log("publish success : " + message);
	}
	
	
	   function getSelectElement(xml){
	         var floorArray = xml.getElementsByTagName("floor");
	         var classArray = xml.getElementsByTagName("class");
	         var pcArray    = xml.getElementsByTagName("client"); ///pc
	         
	         
	         for(var i = 0 ; i < floorArray.length ; i++){  //셀렉에 층 option 다 추가
	            $('.selectFloor').append("<option class='optionFloor'"
	                  +"optionFloor='"+floorArray[i].getAttribute('name')+"' value='"+floorArray[i].getAttribute('name')+"'>"
	                  +floorArray[i].getAttribute('name')+"</option>");
	         }
	         
	         $('#selectFloor').change(function(){
	            var floorId = $(this).val(); //눌린 floor 호수 
	            var clsArray; //눌린 floor에 해당하는 class 배열넣기 
	            
	            for(var j=0; j < floorArray.length; j++){ 
	                  if(floorId==floorArray[j].getAttribute('name'))
	                     clsArray = floorArray[j].getElementsByTagName("class");
	                  
	               }
	            
	            resetSelect($('#selectGroup')); 
	            $('#selectProcessPC').html("<option selected='selected'>PC Number</option>")
	             if($(this).val()!=$('#noFloor1').val()){
	            for (var i = 0; i < clsArray.length; i++) {
	                  $('#selectGroup').append(
	                        "<option class='optionClass'" + "optionClass='"
	                              + clsArray[i].getAttribute('name')
	                              + "'>"
	                              + clsArray[i].getAttribute('name')
	                              + "</option>");
	               }
	             }
	         })
	         
	         
	         $('#selectProcessFloor').change(function(){
	            var floorId = $(this).val(); //눌린 floor 호수 
	            var clsArray; //눌린 floor에 해당하는 class 배열넣기 
	            
	            for(var j=0; j < floorArray.length; j++){ 
	                  if(floorId==floorArray[j].getAttribute('name'))
	                     clsArray = floorArray[j].getElementsByTagName("class");
	                  
	               }
	            
	            resetSelect($('#selectProcessGroup')); 
	            $('#selectProcessPC').html("<option selected='selected'>PC Number</option>")
	            
	            if($(this).val()!=$('#noFloor2').val()){
	            	alert($('#noFloor').val())
	            	for (var i = 0; i < clsArray.length; i++) {
	                    $('#selectProcessGroup').append(
	                          "<option class='optionClass'" + "optionClass='"
	                                + clsArray[i].getAttribute('name')
	                                + "'>"
	                                + clsArray[i].getAttribute('name')
	                                + "</option>");
	                 }
	            }
	            
	            
	         })
	         
	          $('#selectProcessGroup').change(function(){
	            var classId = $(this).val(); //눌린 floor 호수 
	            var pcArray; //눌린 class에 해당하는 pc 배열넣기 
	            
	            for(var j=0; j < classArray.length; j++){ 
	                  if(classId==classArray[j].getAttribute('name'))
	                     pcArray = classArray[j].getElementsByTagName("client");
	                  
	               }
	            resetSelect($('#selectProcessPC')); 
	            for (var i = 0; i < pcArray.length; i++) {
	                  $('#selectProcessPC').append(
	                        "<option class='optionClass'" + "optionClass='"
	                              + pcArray[i].getAttribute('name')
	                              + "'>"
	                              + pcArray[i].getAttribute('name')
	                              + "</option>");
	               }
	         })
	         
	         
	         
	                  
	         
//	         for(var i = 0 ; i < classArray.length ; i++){
//	            $('.selectClass').append("<option class='optionClass'" +
//	                  +"optionClass='"+classArray[i].getAttribute('name')+"' value='"+classArray[i].getAttribute('name')+"'>"
//	                  +classArray[i].getAttribute('name')+"</option>");
//	         }
	         
//	         for(var i = 0 ; i < pcArray.length ; i++){
//	             $('.selectPC').append("<option class='optionPC'" +
//	                   +"optionPC='"+pcArray[i].getAttribute('name')+"' value='"+pcArray[i].getAttribute('name')+"'>"
//	                   +pcArray[i].getAttribute('name')+"</option>");
//	          }
	         
//	         $('.optionFloor').on("change",function(){
//	            var btId = $(this).attr("optionFloor");
//	            alert(btId);
//	         
//	            
//	         })
	         
	      //   for(var i = 0 ; i < pcArray.length ; i++){
	         //   $('.selectPc').append("<option class='optionPc'>"+pcArray[i].getAttribute('name')+"</option>");
	         //}         
	         
	         //향후 분리시켜 나오도록 조정
	         //console.log(classArray.length);
	         //강의실 selected="selected" 시에 그 강의실 pc정보 가져오기 함수 작동하는 이벤트 등록
	         //pc selected="selected" 시에 그 pc detectTable 정보 가져오기 함수 작동하는 이벤트 등록
	         
	      }
	   
	   function resetSelect(selectTag){
	       //  alert($(selectTag).attr("id"));
	         $(selectTag).html("<option class='optionClass'>Class</option>")
	      }

