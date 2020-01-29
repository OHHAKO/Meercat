

   var topic = "hansung/#";
   
   var floor="All Floor";
   var group="All Group";
   var floor2="All Floor";
   var group2="All Group";
   var floor3="All Floor";
   var group3="All Group";
   
   var targetPCList="";
   var targetProcessList="";
   
   /*var logNum;
   var logCount="0";
   var checkNum;
   var checkCount="0";*/

var xmlOfDBAndSub;

loadExistingDataInDB(); // 처음부터 DB가즈오는 함수 호출

function printDBTableXmlData(data) { // xml 이 넘어와서 파싱 후 화면에 출력

	printGroupManagementTable(data);
	printPcManagementTable(data);
	printDetectCheckTable(data);
	printDetectionLogTable(data);

	// 여기서 4개 테이블의 tr 들에게 이벤트 붙여주어야함

}

function printGroupManagementTable(data) {

	$(data).find("recentTable").find("record").each(
			function() {
						// alert($(this).find('classroom').text());
						var trId = $(this).find('classroom').text() + "-"
								+ $(this).find('pcNumber').text();
						// alert()
						var commandLine = "<tr onclick='showPCTable(this)' id='"
								+ $(this).find('classroom').text() + "-"
								+ $(this).find('pcNumber').text() + "'> <td>"
								+ $(this).find('classroom').text() + "</td>"
								+ "<td>" + $(this).find('pcNumber').text()
								+ "</td>" + "<td>"
								+ $(this).find('recentProcess').text()
								+ "</td>" + "<td>"
								+ $(this).find("processCount").text() + "</td>"
								+ "<td>" + $(this).find('time').text()
								+ "</td> <td>" + $(this).find('state').text()
								+ "</td></tr>";

						$('#groupManagementList').append(commandLine);
						
						
						var trNode = document.getElementById(trId);
						if ($(this).find('state').text() == "Y"
								|| $(this).find('state').text() == "y")
							trNode.lastChild.innerHTML = "<span class='label label-success'>Connect</span>";
						if ($(this).find('state').text() == "N"
								|| $(this).find('state').text() == "n")
							trNode.lastChild.innerHTML = "<span class='label label-danger'>Disconnect</span>";

					});
}

function printPcManagementTable(data) {
	// pc별관리 테이블
	$(data)
			.find("detectTable")
			.find("record")
			.each(
					function() {
						// alert($(this).find('classroom').text());
						var commandLine2 = "<tr id='"
								+ $(this).find('classroom').text()
								+ "-"
								+ $(this).find('pcNumber').text()
								+ "'> <td>"
								+ $(this).find('classroom').text()
								+ "</td>"
								+ "<td>"
								+ $(this).find('pcNumber').text()
								+ "</td>"
								+ "<td>"
								+ $(this).find('processName').text()
								+ "</td>"
								+ "<td>"
								+ $(this).find('time').text()
								+ "</td>"
								+ "<td><input type='checkbox' name='PCchkBox' class='pcManagementItem' value='" 
								+ $(this).find('processName').text()
								+ "'></td></tr>";
						$('#pcManagementList').append(commandLine2);
					});
}

function printDetectCheckTable(data) {
	// 감지확인 테이블 찍기
	$(data).find("detectTable").find("record").each(
			function() {
				// alert($(this).find('classroom').text());
				var commandLine3 = "<tr id='"
						+ $(this).find('classroom').text() + "-"
						+ $(this).find('pcNumber').text() + "'> <td>"
						+ $(this).find('classroom').text() + "</td>" + "<td>"
						+ $(this).find('pcNumber').text() + "</td>" + "<td>"
						+ $(this).find('processName').text() + "</td>" + "<td>"
						+ $(this).find("time").text() + "</td>"
						+ "<td><input type='checkbox' name='processChkbox' class='detectCheckItem' value='"
						+ $(this).find('classroom').text()+"-"+$(this).find('pcNumber').text()+"-"+$(this).find('processName').text()
						+ "'>"
						+ "</td>" + "</tr>";
				$('#detectCheckList').append(commandLine3);
			});
	document.getElementById("detectedCheckNum").innerHTML=document.getElementById("detectCheckList").rows.length;
}

function printDetectionLogTable(data) {
	$(data).find("logTable").find("record").each(
			function() {
				// alert($(this).find('classroom').text());
				
				var trId2 = $(this).find('classroom').text() + "-"
				+ $(this).find('pcNumber').text(); //자바스크립트 변수
				
				var commandLine = "<tr id='" + $(this).find('classroom').text()
						+ "-" + $(this).find('pcNumber').text() + "'> <td>"
						+ $(this).find('classroom').text() + "</td>" + "<td>"
						+ $(this).find('pcNumber').text() + "</td>" + "<td>"
						+ $(this).find('processName').text() + "</td>" + "<td>"
						+ $(this).find("time").text() + "</td>" + "<td>"
						+ $(this).find('detectionState').text() + "</td>" + "</tr>";
				$('#detectLogList').append(commandLine);
				
				//var trNode = $("'#"+trId2+"'");
					var trNode = document.getElementById(trId2); //자바스크립트 변수
				
				
			//	if ($(this).find('detectionState').text() == "creation"){
		//			trNode.lastChild.
				//	$("#"+trId2.toString()).children().last().css("color","red")
				//	trNode.lastChild.css("COLOR","RED")
				//	$("#"+trId2).css("COLOR","RED");
		//		}
					
					
		//		if ($(this).find('detectionState').text() == "deletion"){
		//			console.log("삭제")
				//	trNode.lastChild.setAttribute("style","COLOR:GREEN");
					//	trNode.lastChild.innerHTML = "<span class='label label-danger'>Disconnect</span>";
					
		//		}
					

			});
	document.getElementById("detectedLogNum").innerHTML=document.getElementById("detectLogList").rows.length;
}

function loadExistingDataInDB() { // db에서 정보 사악 가져옴
	console.log("loadExistingDataInDB 함수 임니당");
	$.ajax({	type : 'POST',
				url : "./DBTableXml.jsp",
				dataType : 'xml',
				success : function(xmlData) {
					console.log("loadExistingDataInDB 함수 ajax 성공");
					printDBTableXmlData(xmlData);
					xmlOfDBAndSub = xmlData;

				},
				error : function(request, status, error) {
					System.out.println("aJax fail xxxxxxxxxxxxxxx request :"
							+ request);
					System.out.println("status :" + status);
					System.out.println(" error :" + error);

				},
				complete : function() { // success,error 끝난 후 호출

				}

			});
	
}

function getSelectElement(dataFromXml) {
	var floorArray = dataFromXml.getElementsByTagName("floor");
	var classArray = dataFromXml.getElementsByTagName("class");
	var pcArray = dataFromXml.getElementsByTagName("client");
	var floorCheck;

	for (var i = 0; i < floorArray.length; i++) {
		$('.selectFloor').append(
				"<option class='optionFloor'" + "optionFloor='"
						+ floorArray[i].getAttribute('name') + "'>"
						+ floorArray[i].getAttribute('name') + "</option>");
	}

	$('#selectFloorInGMT').change(
			function() {
				var floorId= $(this).val(); //눌린 floor의 호수
				var clsArray; //눌린 floor에 해당하는 class 배열로 넣기
				floorCheck = checkAllFloor($(this).val(),$(this)); // 넘어온 floor값 체크해서 disalbed 설정후 floor값 리턴(all이면 0)
			
				

				for(var j=0; j < floorArray.length; j++){ 
					if(floorId==floorArray[j].getAttribute('name'))
						clsArray = floorArray[j].getElementsByTagName("class");
				}
		
				if (floorCheck == 0) {
					
					resetSelect(document.getElementById('selectGroupInGMT')); //select 초기화
					resetTableBody($('#groupManagementList'));
					printGroupManagementTable(xmlOfDBAndSub);
				} else {
					
				//	눌린 floorId로 테이블 찍기
					resetTableBody($('#groupManagementList'));
					reprintGroupManagementTablebyFloor(this);
					resetSelect(document.getElementById('selectGroupInGMT'));
					for (var i = 0; i < clsArray.length; i++) {
						$('#selectGroupInGMT').append(
								"<option class='optionClass'" + "optionClass='"
										+ clsArray[i].getAttribute('name')
										+ "'>"
										+ clsArray[i].getAttribute('name')
										+ "</option>");
					}
				}
			})
			
	$('#selectFloorInDCT').change(
			function() {
				var floorId= $(this).val();
				var clsArray; //눌린 floor에 해당하는 class 배열로 넣기
				floorCheck = checkAllFloor2($(this).val(),$(this)); // 넘어온 floor값 체크해서 disalbed 설정후 floor값 리턴(all이면 0)
						
				print
//				if (floorCheck == 0) {
//					alert("you select all floor");
//				} else {
//					
//					for (var i = 0; i < classArray.length; i++) {
//						$('#selectGroupInDCT').append(
//								"<option class='optionClass'" + "optionClass='"
//										+ classArray[i].getAttribute('name')
//										+ "'>"
//										+ classArray[i].getAttribute('name')
//										+ "</option>");
//					}
//				}
				
				for(var j=0; j < floorArray.length; j++){ 
					if(floorId==floorArray[j].getAttribute('name'))
						clsArray = floorArray[j].getElementsByTagName("class");
				}
				if (floorCheck == 0) {
				//	alert("you select all floor");
					resetSelect(document.getElementById('selectGroupInDCT')); //select 초기화
					resetTableBody($('#detectCheckList'));
					printDetectCheckTable(xmlOfDBAndSub);
				} else { //floor all버튼 아닐경우
					resetTableBody($('#detectCheckList'));
					resetSelect(document.getElementById('selectGroupInDCT'));
					for (var i = 0; i < clsArray.length; i++) {
						$('#selectGroupInDCT').append(
								"<option class='optionClass'" + "optionClass='"
										+ clsArray[i].getAttribute('name')
										+ "'>"
										+ clsArray[i].getAttribute('name')
										+ "</option>");
					}
				}
				
				
				
			})
			
			
	$('#selectFloorInDLT').change(
			function() {
				var floorId= $(this).val();
				var clsArray; //눌린 floor에 해당하는 class 배열로 넣기
				floorCheck = checkAllFloor3($(this).val(),$(this)); // 넘어온 floor값 체크해서 disalbed 설정후 floor값 리턴(all이면 0)
															
//				if (floorCheck == 0) {
//					alert("you select all floor");
//				} else {
//					for (var i = 0; i < classArray.length; i++) {
//						$('#selectGroupInDLT').append(
//								"<option class='optionClass'" + "optionClass='"
//										+ classArray[i].getAttribute('name')
//										+ "'>"
//										+ classArray[i].getAttribute('name')
//										+ "</option>");
//					}
//				}
				
				for(var j=0; j < floorArray.length; j++){ 
					if(floorId==floorArray[j].getAttribute('name'))
						clsArray = floorArray[j].getElementsByTagName("class");
				}
				if (floorCheck == 0) {
				//	alert("you select all floor");
					resetSelect(document.getElementById('selectGroupInDLT')); //select 초기화
					resetTableBody($('#detectLogList'));
					printDetectionLogTable(xmlOfDBAndSub);
				} else {
					resetSelect(document.getElementById('selectGroupInDLT'));
					for (var i = 0; i < clsArray.length; i++) {
						$('#selectGroupInDLT').append(
								"<option class='optionClass'" + "optionClass='"
										+ clsArray[i].getAttribute('name')
										+ "'>"
										+ clsArray[i].getAttribute('name')
										+ "</option>");
					}
				}
				
				
			})
			
			
			
			
			

	$('.optionClass').click(function() {

	})
	// 향후 분리시켜 나오도록 조정
	// 강의실 selected="selected" 시에 그 강의실 pc정보 가져오기 함수 작동하는 이벤트 등록
	// pc selected="selected" 시에 그 pc detectTable 정보 가져오기 함수 작동하는 이벤트 등록

}


function resetSelect(selectTag){
	//$('#selectGroupInGMT').html("<option class='optionClass' optionClass='all' >All Class</option>");
	selectTag.innerHTML="<option class='optionClass' optionClass='all' >All Class</option>";
}

function checkAllFloor(optionVal,thisSelect) { // 넘어온 floor값 체크해서 disabled 설정.
	if (optionVal == $('#allFloor').val()) {
		$('#selectGroupInGMT').attr("disabled", "disabled");
		return 0
	} else {
		$('#selectGroupInGMT').removeAttr("disabled");
		return optionVal
	}

}

function checkAllFloor2(optionVal,thisSelect) { // 넘어온 floor값 체크해서 disabled 설정.
	if (optionVal == $('#allFloor').val()) {
		$('#selectGroupInDCT').attr("disabled", "disabled");
		return 0
	} else {
		$('#selectGroupInDCT').removeAttr("disabled");
		return optionVal
	}

}

function checkAllFloor3(optionVal,thisSelect) { // 넘어온 floor값 체크해서 disabled 설정.
	if (optionVal == $('#allFloor').val()) {
		$('#selectGroupInDLT').attr("disabled", "disabled");
		return 0
	} else {
		$('#selectGroupInDLT').removeAttr("disabled");
		return optionVal
	}

}

function resetTableBody(tableBodyObj){
//	alert($(tableBodyObj).attr('id'));
	tableBodyObj.html("<div></dit>");
}

function reprintGroupManagementTable(selectedObj){ //눌린 group select 객체가 넘어옴
	var selectedOptVal = $(selectedObj).val(); // 눌린 강의실  호수.
	
	

	$(xmlOfDBAndSub).find("recentTable").find("record").each(
			function() {
				if($(this).find('classroom').text()==selectedOptVal){
					var trId = $(this).find('classroom').text() + "-"
					 		+ $(this).find('pcNumber').text();
					
					var commandLine = "<tr onclick='showPCTable(this)' id='"
							+ $(this).find('classroom').text() + "-"
							+ $(this).find('pcNumber').text() + "'> <td>"
							+ $(this).find('classroom').text() + "</td>"
							+ "<td>" + $(this).find('pcNumber').text()
							+ "</td>" + "<td>"
							+ $(this).find('recentProcess').text()
							+ "</td>" + "<td>"
							+ $(this).find("processCount").text() + "</td>"
							+ "<td>" + $(this).find('time').text()
							+ "</td> <td>" + $(this).find('state').text()
							+ "</td></tr>";
					
					$('#groupManagementList').append(commandLine);
						
					var trNode = document.getElementById(trId);
					if ($(this).find('state').text() == "Y"
							|| $(this).find('state').text() == "y")
						trNode.lastChild.innerHTML = "<span class='label label-success'>Connect</span>";
					if ($(this).find('state').text() == "N"
							|| $(this).find('state').text() == "n")
						trNode.lastChild.innerHTML = "<span class='label label-danger'>Disconnect</span>";
					
				}
				
				
				
				

					});
}

function reprintGroupManagementTablebyFloor(selectedObj){ // 눌린 group select 객체가 넘어옴
	var selectedOptVal = $(selectedObj).val(); // 눌린 강의실  호수.
	
	
	if(selectedOptVal=="1floor"){
		
		$(xmlOfDBAndSub).find("recentTable").find("record").each(
				function() {
					if($(this).find('classroom').text()=="102" || $(this).find('classroom').text()=="103" ){
						var trId = $(this).find('classroom').text() + "-"
						 		+ $(this).find('pcNumber').text();
						
						var commandLine = "<tr onclick='showPCTable(this)' id='"
								+ $(this).find('classroom').text() + "-"
								+ $(this).find('pcNumber').text() + "'> <td>"
								+ $(this).find('classroom').text() + "</td>"
								+ "<td>" + $(this).find('pcNumber').text()
								+ "</td>" + "<td>"
								+ $(this).find('recentProcess').text()
								+ "</td>" + "<td>"
								+ $(this).find("processCount").text() + "</td>"
								+ "<td>" + $(this).find('time').text()
								+ "</td> <td>" + $(this).find('state').text()
								+ "</td></tr>";
						
						$('#groupManagementList').append(commandLine);
							
						var trNode = document.getElementById(trId);
						if ($(this).find('state').text() == "Y"
								|| $(this).find('state').text() == "y")
							trNode.lastChild.innerHTML = "<span class='label label-success'>Connect</span>";
						if ($(this).find('state').text() == "N"
								|| $(this).find('state').text() == "n")
							trNode.lastChild.innerHTML = "<span class='label label-danger'>Disconnect</span>";
						
					}		

						});
		
		
	}else if(selectedOptVal=="2floor"){
		
		$(xmlOfDBAndSub).find("recentTable").find("record").each(
				function() {
					if($(this).find('classroom').text()=="201" || $(this).find('classroom').text()=="202" ){
						var trId = $(this).find('classroom').text() + "-"
						 		+ $(this).find('pcNumber').text();
						
						var commandLine = "<tr onclick='showPCTable' id='"
								+ $(this).find('classroom').text() + "-"
								+ $(this).find('pcNumber').text() + "'> <td>"
								+ $(this).find('classroom').text() + "</td>"
								+ "<td>" + $(this).find('pcNumber').text()
								+ "</td>" + "<td>"
								+ $(this).find('recentProcess').text()
								+ "</td>" + "<td>"
								+ $(this).find("processCount").text() + "</td>"
								+ "<td>" + $(this).find('time').text()
								+ "</td> <td>" + $(this).find('state').text()
								+ "</td></tr>";
						
						$('#groupManagementList').append(commandLine);
							
						var trNode = document.getElementById(trId);
						if ($(this).find('state').text() == "Y"
								|| $(this).find('state').text() == "y")
							trNode.lastChild.innerHTML = "<span class='label label-success'>Connect</span>";
						if ($(this).find('state').text() == "N"
								|| $(this).find('state').text() == "n")
							trNode.lastChild.innerHTML = "<span class='label label-danger'>Disconnect</span>";
						
					}		

						});
		
	}else if(selectedOptVal=="3floor")
	
	

	$(xmlOfDBAndSub).find("recentTable").find("record").each(
			function() {
				if($(this).find('classroom').text()==selectedOptVal){
					var trId = $(this).find('classroom').text() + "-"
					 		+ $(this).find('pcNumber').text().split("-")[1];
					
					
					var commandLine = "<tr onclick='showPCTable' id='"
							+ $(this).find('classroom').text() + "-"
							+ $(this).find('pcNumber').text().split("-")[1] + "'> <td>"
							+ $(this).find('classroom').text() + "</td>"
							+ "<td>" + $(this).find('pcNumber').text()
							+ "</td>" + "<td>"
							+ $(this).find('recentProcess').text()
							+ "</td>" + "<td>"
							+ $(this).find("processCount").text() + "</td>"
							+ "<td>" + $(this).find('time').text()
							+ "</td> <td>" + $(this).find('state').text()
							+ "</td></tr>";
					
					$('#groupManagementList').append(commandLine);
						
					var trNode = document.getElementById(trId);
					if ($(this).find('state').text() == "Y"
							|| $(this).find('state').text() == "y")
						trNode.lastChild.innerHTML = "<span class='label label-success'>Connect</span>";
					if ($(this).find('state').text() == "N"
							|| $(this).find('state').text() == "n")
						trNode.lastChild.innerHTML = "<span class='label label-danger'>Disconnect</span>";
					
				}		

					});
}



function reprintDetectCheckTable(selectedObj) {
	var selectedOptVal = $(selectedObj).val(); // 눌린 강의실  호수.
	// pc별관리 테이블
	$(xmlOfDBAndSub).find("detectTable").find("record").each(
			function() {
				// alert($(this).find('classroom').text());
				
				if(selectedOptVal==$(this).find('classroom').text()){
					var commandLine3 = "<tr id='"
						+ $(this).find('classroom').text() + "-"
						+ $(this).find('pcNumber').text() + "'> <td>"
						+ $(this).find('classroom').text() + "</td>" + "<td>"
						+ $(this).find('pcNumber').text() + "</td>" + "<td>"
						+ $(this).find('processName').text() + "</td>" + "<td>"
						+ $(this).find("time").text() + "</td>"
						+ "<td><input type='checkbox' class='detectCheckItem'>"
						+ "</td>" + "</tr>";
				$('#detectCheckList').append(commandLine3);
					
					
					
				}
				
			});
	
}


function reprintDetectCheckTableEachFloor(selectedObj){
	var selectedOptVal = $(selectedObj).val(); //눌린 
	
	
}


function reprintDetectionLogTable(selectedObj) {
	var selectedOptVal = $(selectedObj).val(); // 눌린 강의실  호수.
	
	
		$(xmlOfDBAndSub).find("logTable").find("record").each(
			function() {
				// alert($(this).find('classroom').text());
				
				if(selectedOptVal==$(this).find('classroom').text()){
					var trId2 = $(this).find('classroom').text() + "-"
					+ $(this).find('pcNumber').text(); //자바스크립트 변수
					
					var commandLine = "<tr id='" + $(this).find('classroom').text()
							+ "-" + $(this).find('pcNumber').text() + "'> <td>"
							+ $(this).find('classroom').text() + "</td>" + "<td>"
							+ $(this).find('pcNumber').text() + "</td>" + "<td>"
							+ $(this).find('processName').text() + "</td>" + "<td>"
							+ $(this).find("time").text() + "</td>" + "<td>"
							+ $(this).find('detectionState').text() + "</td>" + "</tr>";
					$('#detectLogList').append(commandLine);
				}
				
				/*var trNode = document.getElementById(trId2);
				if ($(this).find('detectionState').text() == "creation")
					trNode.lastChild.innerHTML = "<span class='label label-success'>Connect</span>";
				if ($(this).find('detectionState').text() == "deletion")
					trNode.lastChild.innerHTML = "<span class='glyphicon glyphicon-remove'></span>";*/				
			});
}

$(document).ready(function() {
	$('#detectCheckItem-all').click(function() {
		$('.detectCheckItem').prop('checked', this.checked);
		
	});

	$('#pcManagementItem-all').click(function() {
		$('.pcManagementItem').prop('checked', this.checked);
	});
	
	
	
	$('#selectGroupInGMT').change(function(){
		//this를 함수로 넘겨서 this에 해당하는 값으로 xml 가져와 프린트. 프린트 전에 테이블 초기화 할것
		
		resetTableBody($('#groupManagementList')); //테이블바디 객체 넘김
		reprintGroupManagementTable($(this));
	})
	
	$('#selectGroupInDCT').change(function(){
		
		resetTableBody($('#detectCheckList')); //테이블바디 객체 넘김
		reprintDetectCheckTable($(this));
	})
	
	$('#selectGroupInDLT').change(function(){
		
		resetTableBody($('#detectLogList')); //테이블바디 객체 넘김
		reprintDetectionLogTable($(this));
	})
	

});


function onMessageArrived(message) {
	var topicArray = message.destinationName.split("/");
    // var messageArray = message.payloadString.split(";");
    
    var groupTable=document.getElementById("groupManagementList");
    var pcTable=document.getElementById("pcManagementList");
    var logTable=document.getElementById("detectLogList");
    var checkTable=document.getElementById("detectCheckList");
    
    var date = new Date();
    var localeDate = date.toLocaleDateString();
    var localeTime = date.toLocaleTimeString();

    if (topicArray[1] == "creationDetect") {
    	console.log(message.payloadString);
       var contentArray=message.payloadString.split(";");
       var createState="CREATE";
       
       var id=topicArray[3]+"-"+topicArray[4];
       
       /////그룹프로세스테이블 갱신///
       for(var i=0;i<groupTable.rows.length;i++){
          if(groupTable.rows[i].getAttribute("id")==id){  // 각 행의
                                              // id값(102-1)과
                                              // 비교 후 같으면 프로세스
                                              // 개수,이름,시간만 변경
        	 groupTable.rows[i].cells[2].innerHTML=contentArray[1];
             groupTable.rows[i].cells[3].innerHTML=contentArray[0];
             groupTable.rows[i].cells[4].innerHTML=localeDate+" "+localeTime;
          }
       }
       console.log("groupTable add");
       
       
       //////도착한 메시지의 토픽이 피씨테이블과 일치한다면 갱신///////
       if(topicArray[3]==pcTable.getAttribute("name").split("-")[0]
    		   && topicArray[4]==pcTable.getAttribute("name").split("-")[1]){
    	   for(var i=0;i<contentArray.length-1;i++){
    		   addRowPcProcess(topicArray[3],topicArray[4],contentArray[i+1],localeDate+" "+localeTime,
    				   "<input type='checkbox' name='PCchkBox' value='"
                       +contentArray[i+1]
                       +"' aria-label='...'>")
    	   }
    	   console.log("PCTable add");
       }
       
       // //////////////////////////////
       // ////없으면 xml만 갱신하는 코드////////
       // //////////////////////////////
       
       
       
       // //전체 감지로그테이블에 추가////
       console.log(floor2+" "+topicArray[2]);
       
       if(floor2=="All Floor"){ // floor2셀렉트박스가 디폴트면 테이블 갱신-모든걸 다 띄움 
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectLog(topicArray[3],topicArray[4],contentArray[i+1],
                   localeDate+" "+localeTime, createState); // 강의실,pc번호,프로세스이름,시간,상태
          }
          console.log("logTable-default add");
          document.getElementById("detectedLogNum").innerHTML=document.getElementById("detectLogList").rows.length; 
       }
       
       else if(floor2==topicArray[2]){ // floor2는 선택되어있지만 group2가 디폴트면 해당 floor인 것만 띄음
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectLog(topicArray[3],topicArray[4],contentArray[i+1],
                   localeDate+" "+localeTime, createState); // 강의실,pc번호,프로세스이름,시간,상태
          }
          console.log("logTable-floor add");
          document.getElementById("detectedLogNum").innerHTML=document.getElementById("detectLogList").rows.length; 
       }
       
       else if(floor2==topicArray[2] && group2==topicArray[3]){
          // floor2와 group2 둘다 선택되었으면 해당 floor2,group2인것만 띄움 
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectLog(topicArray[3],topicArray[4],contentArray[i+1],
                   localeDate+" "+localeTime, createState); // 강의실,pc번호,프로세스이름,시간,상태
             // 
          }
          console.log("logTable-floor group add");
          document.getElementById("detectedLogNum").innerHTML=document.getElementById("detectLogList").rows.length;
       }
       else{
          return;
       }
       
       
       
       
       ///////전체 감지확인테이블에 추가////////
       console.log(floor3+" "+topicArray[2]);
       
       if(floor3=="All Floor"){ // floor3셀렉트박스가 디폴트면 테이블 갱신-모든걸 다 띄움 
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectProcess(topicArray[3],topicArray[4],contentArray[i+1], localeDate+" "+localeTime, 
                   "<input type='checkbox' name='processChkbox' value='"
                   +topicArray[3]+"-"+topicArray[4]+"-"+contentArray[i+1]
                   +"' aria-label='...'>");  // 강의실,pc번호,프로세스이름,시간,체크박스
          }
          console.log("checkTable-floor group add");
          document.getElementById("detectedCheckNum").innerHTML=document.getElementById("detectCheckList").rows.length; 
       }
       
       else if(floor3==topicArray[2]){ // floor3는 선택되어있지만 group3가 디폴트면 해당 floor인 것만 띄음
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectProcess(topicArray[3],topicArray[4],contentArray[i+1], localeDate+" "+localeTime, 
                   "<input type='checkbox' name='processChkbox' value='"
                   +topicArray[3]+"-"+topicArray[4]+"-"+contentArray[i+1]
                   +"' aria-label='...'>");  // 강의실,pc번호,프로세스이름,시간,체크박스
          }
          console.log("checkTable-floor group add");
          document.getElementById("detectedCheckNum").innerHTML=document.getElementById("detectCheckList").rows.length;
       }
       
       else if(floor3==topicArray[2] && group3==topicArray[3]){
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectProcess(topicArray[3],topicArray[4],contentArray[i+1], localeDate+" "+localeTime, 
                   "<input type='checkbox' name='processChkbox' value='"
                   +topicArray[3]+"-"+topicArray[4]+"-"+contentArray[i+1]
                   +"' aria-label='...'>");  // 강의실,pc번호,프로세스이름,시간,체크박스
          }
          console.log("checkTable-floor group add");
          document.getElementById("detectedCheckNum").innerHTML=document.getElementById("detectCheckList").rows.length;
       }
       else{
          return;
       }
    }
    
    
   
    
    else if (topicArray[1] == "deletionDetect") {
    	console.log(message.payloadString);
       var contentArray=message.payloadString.split(";");
       var deleteState="DELETE";
       var id=topicArray[3]+"-"+topicArray[4];
       
       for(var i=0;i<groupTable.rows.length;i++){
    	   //console.log(groupTable.rows[i].getAttribute("id"));
          if(groupTable.rows[i].getAttribute("id")==id){    //각 행의 id와 현재 변수 id의 값이 같아야만 실행됨
        	  
             if(contentArray[0]=="0"){  // 프로세스가 다 지워져서 이제 감지되는게 0개면
                groupTable.rows[i].cells[2].innerHTML="";  // 프로세스이름 공란
                groupTable.rows[i].cells[3].innerHTML="";  // 프로세스수 공란
                groupTable.rows[i].cells[4].innerHTML="";  // 시간 공란
             }
             
             else{
            	 //console.log(contentArray[0]+" "+groupTable.rows[i].getAttribute("id")+" "+id);
            	 
                for(var j=0;j<contentArray.length-1;j++){  // delete후남은프로세스 개수만큼 다시검사
                   if(groupTable.rows[i].cells[2].outerHTML==contentArray[j+1]){  // 지워진프로세스이름이 테이블에 나타나있으면 바꿔야함
                      if(j+1>contentArray.length-1)  // 다음프로세스 이름으로 바꿀건데 다음프로세스가없으면 그전껄로바꿈
                         groupTable.rows[i].cells[2].innerHTML=contentArray[j-1];
                      else
                         groupTable.rows[i].cells[2].innerHTML=contentArray[j+2];   // 있으면다음껄로바꿈
                   }
                   groupTable.rows[i].cells[4].innerHTML=localeDate+" "+localeTime;
                   groupTable.rows[i].cells[3].innerHTML=contentArray[0];
                }
             }
             
          }
       }
       console.log("groupTable add");
       
       
       // ///pc테이블에서 삭제//////
       if(topicArray[3]==pcTable.rows[0].cells[0].outerText
    		   && topicArray[4]==pcTable.rows[0].cells[1].outerText){
    	   for(var j=0;j<contentArray.length-1;j++){
    		   console.log(pcTable.rows.length);
    		   for(var i=0;i<pcTable.rows.length;i++){
    			   if(pcTable.rows[i].cells[2].outerText==contentArray[j+1]){
    				   pcTable.deleteRow(i);
    			   }
    		   }
    		   console.log("PCTable del");
    	   }
       }
       
       
       // //전체 로그테이블에 추가////
       console.log(floor2+" "+topicArray[2]);
       
       if(floor2=="All Floor"){ // floor2셀렉트박스가 디폴트면 테이블 갱신-모든걸 다 띄움 
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectLog(topicArray[3],topicArray[4],contentArray[i+1],
                   localeDate+" "+localeTime, deleteState); // 강의실,pc번호,프로세스이름,시간,상태
          }
          console.log("logTable-default add");
          document.getElementById("detectedLogNum").innerHTML=document.getElementById("detectLogList").rows.length; 
       }
       
       else if(floor2==topicArray[2]){ // floor2는 선택되어있지만 group2가 디폴트면 해당 floor인 것만 띄음
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectLog(topicArray[3],topicArray[4],contentArray[i+1],
                   localeDate+" "+localeTime, deleteState); // 강의실,pc번호,프로세스이름,시간,상태
          }
          console.log("logTable-floor add");
          document.getElementById("detectedLogNum").innerHTML=document.getElementById("detectLogList").rows.length; 
       }
       
       else if(floor2==topicArray[2] && group2==topicArray[3]){
          // floor2와 group2 둘다 선택되었으면 해당 floor2,group2인것만 띄움 
          for(var i=0;i<contentArray.length-1;i++){
             addRowDetectLog(topicArray[3],topicArray[4],contentArray[i+1],
                   localeDate+" "+localeTime, deleteState); // 강의실,pc번호,프로세스이름,시간,상태
             // 
          }
          console.log("logTable-floor group add");
          document.getElementById("detectedLogNum").innerHTML=document.getElementById("detectLogList").rows.length; 
       }
       else{
          return;
       }
       
       
       
       
       ///////전체 감지확인테이블에서 삭제////////
       if(floor3=="All Floor"){
          for(var j=1;j<=contentArray.length;j++){  // 지워졌다고 날라온 프로세스 개수만큼
             console.log(contentArray[0]);
             for(var i=0;i<checkTable.rows.length;i++){
                if(topicArray[3]==checkTable.rows[i].cells[0].outerText){
                   if(topicArray[4]==checkTable.rows[i].cells[1].outerText){
                      if(contentArray[j]==checkTable.rows[i].cells[2].outerText){
                         checkTable.deleteRow(i);
                      }
                   }
                }
             }
          }
          console.log("checkTable-floor group del");
          document.getElementById("detectedCheckNum").innerHTML=document.getElementById("detectCheckList").rows.length;
       }
       else if(floor3==topicArray[2]){ // floor3는 선택되어있지만 group3가 디폴트면 해당 floor인 것만 띄음
          for(var j=1;j<=contentArray.length;j++){  // 지워졌다고 날라온 프로세스 개수만큼
             console.log(contentArray[0]);
             for(var i=0;i<checkTable.rows.length;i++){
                if(topicArray[3]==checkTable.rows[i].cells[0].outerText){
                   if(topicArray[4]==checkTable.rows[i].cells[1].outerText){
                      if(contentArray[j]==checkTable.rows[i].cells[2].outerText){
                         checkTable.deleteRow(i);
                      }
                   }
                }
             }
          }
          console.log("checkTable-floor group del");
          document.getElementById("detectedCheckNum").innerHTML=document.getElementById("detectCheckList").rows.length;
       }
       else if(floor3==topicArray[2] && group3==topicArray[3]){
          for(var j=1;j<=contentArray.length;j++){  // 지워졌다고 날라온 프로세스 개수만큼
             console.log(contentArray[0]);
             for(var i=0;i<checkTable.rows.length;i++){
                if(topicArray[3]==checkTable.rows[i].cells[0].outerText){
                   if(topicArray[4]==checkTable.rows[i].cells[1].outerText){
                      if(contentArray[j]==checkTable.rows[i].cells[2].outerText){
                         checkTable.deleteRow(i);
                      }
                   }
                }
             }
          }
          console.log("checkTable-floor group del");
          document.getElementById("detectedCheckNum").innerHTML=document.getElementById("detectCheckList").rows.length;
       }
       else{
          return;
       }
       
    }
    
    else if (topicArray[1] == "alive") {
    	var id=topicArray[3]+"-"+topicArray[4];  //ex)102-1
        
        // ///이미 그룹프로세스 테이블에 해당 강의실-pc번호가 있는지 검사 후 있으면 alive여부 변경해줌///
    	if(message.payloadString=="y"){
    		for(var i=0;i<groupTable.rows.length;i++){
    			if(groupTable.rows[i].getAttribute("id")==id){
    				groupTable.rows[i].cells[5].innerHTML="<span class='label label-success'>Connect</span>";
    			}
    		}
    		console.log("groupTable connect add");
    	}
    	else{
    		for(var i=0;i<groupTable.rows.length;i++){
    			if(groupTable.rows[i].getAttribute("id")==id){
    				groupTable.rows[i].cells[5].innerHTML="<span class='label label-danger'>Disconnect</span>";
    			}
    		}
    		console.log("groupTable disconnect add");
    	}
    }
    
    else {
       return;
    }
}

function addRowGroupProcess(str1, str2, str3, str4 ,str5) {  // 강의실,pc번호,프로세스이름,프로세스수,시간
    var table=document.getElementById("groupManagementList");
    // var row = my_tbody.insertRow(0); // 상단에 추가
    var row = table.insertRow(table.rows.length); // 하단에 추가
    row.id = str1+"-"+str2;   // ex)102-9

    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);
    var cell3 = row.insertCell(2);
    var cell4 = row.insertCell(3);
    var cell5 = row.insertCell(4);
    cell1.innerHTML = str1;
    cell2.innerHTML = str2;
    cell3.innerHTML = str3;
    cell4.innerHTML = str4;
    cell5.innerHTML = str5;
 }
 
 function addRowPcProcess(str1, str2, str3, str4, str5){
    var table=document.getElementById("pcManagementList");
    var row = table.insertRow(0); // 상단에 추가
    //var row = table.insertRow(table.rows.length); // 하단에 추가
    row.id = str3;  // 프로세스이름이 그 행의 id

    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);
    var cell3 = row.insertCell(2);
    var cell4 = row.insertCell(3);
    var cell5 = row.insertCell(4);
    cell1.innerHTML = str1;
    cell2.innerHTML = str2;
    cell3.innerHTML = str3;
    cell4.innerHTML = str4;
    cell5.innerHTML = str5;
 }
 
 function addRowDetectProcess(str1, str2, str3, str4, str5){
    var table=document.getElementById("detectCheckList");
    var row = table.insertRow(0); // 상단에 추가
    // var row = table.insertRow(table.rows.length); // 하단에 추가
    row.id = str1+"-"+str2;

    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);
    var cell3 = row.insertCell(2);
    var cell4 = row.insertCell(3);
    var cell5 = row.insertCell(4);
    cell1.innerHTML = str1;
    cell2.innerHTML = str2;
    cell3.innerHTML = str3;
    cell4.innerHTML = str4;
    cell5.innerHTML = str5;
 }
 
 function addRowDetectLog(str1, str2, str3, str4, str5){  // 강의실,pc번호,프로세스이름,시간,상태
    var table=document.getElementById("detectLogList");
    var row = table.insertRow(0); // 상단에 추가
    // var row = table.insertRow(table.rows.length); // 하단에 추가
    row.id = str1+"-"+str2;

    var cell1 = row.insertCell(0);
    var cell2 = row.insertCell(1);
    var cell3 = row.insertCell(2);
    var cell4 = row.insertCell(3);
    var cell5 = row.insertCell(4);
    cell1.innerHTML = "<span class='redSpan'>"+str1+"</span>";
    cell2.innerHTML = "<span class='redSpan'>"+str2+"</span>";
    cell3.innerHTML = "<span class='redSpan'>"+str3+"</span>";
    cell4.innerHTML = "<span class='redSpan'>"+str4+"</span>";
    cell5.innerHTML = str5;
    
    var redSpan = document.getElementsByClassName("redSpan");
    console.log("redSpan");
    for(var i=0;i<redSpan.length;i++){
       redSpan[i].style.animation = "textColorAnimation 30s";
    }
    // redSpan.style.animationDuration= "30s";
 }

 
 // /////////////////////////////////////첫번째 selectBox-그룹별 관리
 // 테이블/////////////////
 function setFloor() {
    var selectFloor = document.getElementById("selectFloorInGMT");
    var selectFloorValue = selectFloor.options[selectFloor.selectedIndex].value;

    floor = selectFloorValue;
    console.log(floor);
 }

 function setGroup() {
    var selectGroup = document.getElementById("selectGroupInGMT");
    var selectGroupValue = selectGroup.options[selectGroup.selectedIndex].value;

    group = selectGroupValue;
    console.log(floor+" "+group);
 }
 
 
 // ////////////////////////////////
 // ///두번째 selectBox-감지 확인 테이블/////
 // /////////////////////////////////
 
 function setFloor2() {
    var selectFloor = document.getElementById("selectFloorInDCT");
    var selectFloorValue = selectFloor.options[selectFloor.selectedIndex].value;

    floor2 = selectFloorValue;
    console.log(floor2);
 }

 function setGroup2() {
    var selectGroup = document.getElementById("selectGroupInDCT");
    var selectGroupValue = selectGroup.options[selectGroup.selectedIndex].value; // 그selectGroup의선택된인덱스의value를가져옴

    group2 = selectGroupValue;
    console.log(floor2+" "+group2);
 }
 
 
 // /////////////////////////////////////
 ////////세번째 selectBox-감지 로그 테이블/////////////////
 function setFloor3() {
    var selectFloor = document.getElementById("selectFloorInDLT"); 
    var selectFloorValue = selectFloor.options[selectFloor.selectedIndex].value;

    floor3 = selectFloorValue;
    console.log(floor3);
 }

 function setGroup3() {
    var selectGroup = document.getElementById("selectGroupInDLT");
    var selectGroupValue = selectGroup.options[selectGroup.selectedIndex].value;

    group3 = selectGroupValue;
    console.log(floor3+" "+group3);
 }
 
 
 
 
 function showPCTable(obj){   //이 함수의 코드를 xml에서 해당 레코드 값을 가져오는 코드로 바꾸어야함
    var clickTrId=obj.getAttribute("id").split("-"); //ex)102-1
    document.getElementById("pcManagementList").innerHTML="";
    
    var clickTrGroup= clickTrId[0]; //ex)102
    var clickTrPC= clickTrId[1];  //ex)13
    console.log(clickTrGroup+" "+clickTrPC);
    
    //////관리테이블 행 클릭할때마다 해당 피씨테이블의 name속성을 102-12등으로 지정////
    document.getElementById("pcManagementList").setAttribute("name",clickTrGroup+"-"+clickTrPC);
    console.log(document.getElementById("pcManagementList").getAttribute("name"));
    
    /*for(var i=0;i<obj.cells[3].outerText;i++){  // 클릭한 테이블 행의 3번째 레코드값만큼
       addRowPcProcess(obj.cells[0].outerText, obj.cells[1].outerText, obj.cells[2].outerText, obj.cells[4].outerText, 
             "<input type='checkbox' name='PCchkBox' value='"
             +obj.cells[2].outerText
             +"' aria-label='...'>");
    }*/
    //강의실 pc번호 프로세스 시간 종료
    
    $(xmlOfDBAndSub).find("detectTable").find("record").each(
    		function(){
    			if($(this).find('classroom').text()==clickTrGroup && $(this).find('pcNumber').text()==clickTrPC){
    				
    				var chkbox = "<input type='checkbox' name='PCchkBox' value='"
						+$(this).find('processName').text()
						+"' aria-label='...'>";
    				
    				addRowPcProcess($(this).find('classroom').text(),
    						$(this).find('pcNumber').text(), $(this).find('processName').text(),
    						$(this).find('time').text(),chkbox);
        		}	
    		}
    )    
    
 }
 
 
 
 
 /*function test(me) {
    var isChecked = $(me).is(":checked");
    var txt;

    if (isChecked == true) {
       targetList += $(me).parent().parent().text().trim();
    }
    targetList += ";";
 }*/
 
 function killPCProcess(){
    setTargetList();
    
    targetPCList=targetPCList.slice(0,-1);
    console.log(targetPCList);
    
    message = new Paho.MQTT.Message(targetPCList);
    message.destinationName = "hansung/processKill/" + floor + "/" + group + "/1" ;

    client.send(message);
    console.log(message+" "+message.destinationName);
 }
 
 function setTargetList(){
    var chk = document.getElementsByName("PCchkBox"); // 체크박스객체를 담는다
    var len = chk.length;    // 체크박스의 전체 개수

    for(var i=0; i<len; i++){
       if(chk[i].checked == true){  // 체크가 되어있는 값 구분
          targetPCList+=chk[i].value;
          targetPCList+=";";
       }
    }
 }
 
 function killProcess(obj){
    setTargetList2();
    
    targetProcessList=targetProcessList.slice(0,-1);
    var targetListArray=targetProcessList.split(";");
    
    for(var i=0;i<targetListArray.length;i++){
       var topicFloor;
       var topicGroup=targetListArray[i].split("-")[0];
       var topicPC=targetListArray[i].split("-")[1];
       
       if(topicGroup.substring(0,1)=="1")
          topicFloor="1floor";
       else if(topicGroup.substring(0,1)=="2")
          topicFloor="2floor";
       else if(topicGroup.substring(0,1)=="3")
          topicFloor="3floor";
       
       console.log(topicFloor+" "+topicGroup+" "+topicPC);
       
       message = new Paho.MQTT.Message(targetListArray[i].split("-")[2]);
       message.destinationName = "hansung/processKill/" + topicFloor + "/" + topicGroup + "/"+topicPC;
       
       client.send(message);
       console.log(message+" "+message.destinationName);
    }
 }
 
 function setTargetList2(){
    var chk = document.getElementsByName("processChkbox"); // 체크박스객체를 담는다
    var len = chk.length;    // 체크박스의 전체 개수

    for(var i=0; i<len; i++){
       if(chk[i].checked == true){  // 체크가 되어있는 값 구분
          console.log(chk[i].value);
          targetProcessList+=chk[i].value;
          targetProcessList+=";";
       }
    }
 }
